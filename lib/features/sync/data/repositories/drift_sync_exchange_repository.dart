import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';

class LocalSyncOperationDraft {
  const LocalSyncOperationDraft({
    required this.operationId,
    required this.entityType,
    required this.entityId,
    required this.parentVersionJson,
    required this.changedFieldsJson,
    required this.operationKind,
    required this.payloadSha256,
  });

  final String operationId;
  final String entityType;
  final String entityId;
  final String parentVersionJson;
  final String changedFieldsJson;
  final String operationKind;
  final String payloadSha256;
}

class RemoteSyncOperationIdentity {
  const RemoteSyncOperationIdentity({
    required this.operationId,
    required this.groupId,
    required this.originDeviceId,
    required this.originCounter,
    required this.payloadSha256,
  });

  final String operationId;
  final String groupId;
  final String originDeviceId;
  final int originCounter;
  final String payloadSha256;
}

enum RemoteCausalApplyResult {
  applied,
  duplicate,
  deferred,
  conflicted,
  obsolete,
}

class DriftSyncExchangeRepository {
  DriftSyncExchangeRepository(this._database);

  final MichiFocusDatabase _database;

  Future<void> initializeLocalState({
    required String groupId,
    required String installationId,
    required int protocolVersion,
    required DateTime now,
  }) async {
    _requireText(groupId, 'groupId');
    _requireText(installationId, 'installationId');
    if (protocolVersion < 1) {
      throw ArgumentError.value(protocolVersion, 'protocolVersion');
    }
    final existing = await (_database.select(
      _database.syncLocalStateRecords,
    )..where((row) => row.groupId.equals(groupId))).getSingleOrNull();
    if (existing != null) {
      if (existing.installationId != installationId ||
          existing.protocolVersion != protocolVersion) {
        throw StateError('Sync local state does not match this enrollment.');
      }
      return;
    }
    await _database
        .into(_database.syncLocalStateRecords)
        .insert(
          SyncLocalStateRecordsCompanion.insert(
            groupId: groupId,
            installationId: installationId,
            protocolVersion: protocolVersion,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<SyncOutboxRecord> commitLocalMutation({
    required String groupId,
    required String installationId,
    required String entityType,
    required String entityId,
    required DateTime now,
    required Future<LocalSyncOperationDraft> Function(
      int originCounter,
      Map<String, int> parentVersion,
    )
    buildOperation,
    required Future<void> Function(MichiFocusDatabase database) mutate,
  }) {
    return _database.transaction(() async {
      final state = await (_database.select(
        _database.syncLocalStateRecords,
      )..where((row) => row.groupId.equals(groupId))).getSingleOrNull();
      if (state == null || state.installationId != installationId) {
        throw StateError('No matching local sync state is initialized.');
      }

      final parentVersion = await _entityVersion(
        groupId: groupId,
        entityType: entityType,
        entityId: entityId,
      );
      final counter = state.logicalCounter + 1;
      final operation = await buildOperation(counter, parentVersion);
      _validateDraft(operation);
      if (operation.entityType != entityType ||
          operation.entityId != entityId) {
        throw StateError('Operation target changed while being committed.');
      }
      await mutate(_database);
      await (_database.update(
        _database.syncLocalStateRecords,
      )..where((row) => row.groupId.equals(groupId))).write(
        SyncLocalStateRecordsCompanion(
          logicalCounter: Value(counter),
          updatedAt: Value(now),
        ),
      );
      await _database
          .into(_database.syncOutboxRecords)
          .insert(
            SyncOutboxRecordsCompanion.insert(
              operationId: operation.operationId,
              groupId: groupId,
              originDeviceId: installationId,
              originCounter: counter,
              entityType: operation.entityType,
              entityId: operation.entityId,
              parentVersionJson: operation.parentVersionJson,
              changedFieldsJson: operation.changedFieldsJson,
              operationKind: operation.operationKind,
              protocolVersion: state.protocolVersion,
              payloadSha256: operation.payloadSha256.toLowerCase(),
              createdAt: now,
            ),
          );
      final resultingVersion = <String, int>{
        ...parentVersion,
        installationId: counter,
      };
      final resultingVersionJson = _canonicalVersionJson(resultingVersion);
      if (operation.operationKind == 'delete') {
        await (_database.delete(
              _database.syncEntityVersionRecords,
            )..where(
              (row) =>
                  row.groupId.equals(groupId) &
                  row.entityType.equals(entityType) &
                  row.entityId.equals(entityId),
            ))
            .go();
        await _database
            .into(_database.syncTombstoneRecords)
            .insertOnConflictUpdate(
              SyncTombstoneRecordsCompanion.insert(
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                causalVersionJson: resultingVersionJson,
                operationId: operation.operationId,
                originDeviceId: installationId,
                deletedAt: now,
              ),
            );
      } else {
        final fields = (jsonDecode(operation.changedFieldsJson) as Map).keys;
        for (final field in fields.cast<String>()) {
          await _database
              .into(_database.syncEntityVersionRecords)
              .insertOnConflictUpdate(
                SyncEntityVersionRecordsCompanion.insert(
                  groupId: groupId,
                  entityType: entityType,
                  entityId: entityId,
                  fieldName: field,
                  causalVersionJson: resultingVersionJson,
                  operationId: operation.operationId,
                  originDeviceId: installationId,
                  updatedAt: now,
                ),
              );
        }
        await (_database.delete(
              _database.syncTombstoneRecords,
            )..where(
              (row) =>
                  row.groupId.equals(groupId) &
                  row.entityType.equals(entityType) &
                  row.entityId.equals(entityId),
            ))
            .go();
      }
      return (_database.select(_database.syncOutboxRecords)
            ..where((row) => row.operationId.equals(operation.operationId)))
          .getSingle();
    });
  }

  Future<bool> enqueueBootstrapCreate({
    required String groupId,
    required String installationId,
    required String entityType,
    required String entityId,
    required DateTime now,
    required Future<LocalSyncOperationDraft?> Function(
      MichiFocusDatabase database,
      int originCounter,
    )
    buildOperation,
  }) {
    return _database.transaction(() async {
      final state = await (_database.select(
        _database.syncLocalStateRecords,
      )..where((row) => row.groupId.equals(groupId))).getSingleOrNull();
      if (state == null || state.installationId != installationId) {
        throw StateError('No matching local sync state is initialized.');
      }

      final existingVersion = await _entityVersion(
        groupId: groupId,
        entityType: entityType,
        entityId: entityId,
      );
      final tombstone =
          await (_database.select(
                _database.syncTombstoneRecords,
              )..where(
                (row) =>
                    row.groupId.equals(groupId) &
                    row.entityType.equals(entityType) &
                    row.entityId.equals(entityId),
              ))
              .getSingleOrNull();
      final existingCreate =
          await (_database.select(
                _database.syncOutboxRecords,
              )..where(
                (row) =>
                    row.groupId.equals(groupId) &
                    row.entityType.equals(entityType) &
                    row.entityId.equals(entityId) &
                    row.operationKind.equals('create'),
              ))
              .getSingleOrNull();
      final hasRemoteBaseline = existingVersion.keys.any(
        (origin) => origin != installationId,
      );
      if (tombstone != null || existingCreate != null || hasRemoteBaseline) {
        return false;
      }

      final counter = state.logicalCounter + 1;
      final operation = await buildOperation(_database, counter);
      if (operation == null) return false;
      _validateDraft(operation);
      if (operation.entityType != entityType ||
          operation.entityId != entityId ||
          operation.operationKind != 'create' ||
          operation.parentVersionJson != '{}') {
        throw StateError('Invalid initial synchronization operation.');
      }

      await (_database.update(
        _database.syncLocalStateRecords,
      )..where((row) => row.groupId.equals(groupId))).write(
        SyncLocalStateRecordsCompanion(
          logicalCounter: Value(counter),
          updatedAt: Value(now),
        ),
      );
      await _database
          .into(_database.syncOutboxRecords)
          .insert(
            SyncOutboxRecordsCompanion.insert(
              operationId: operation.operationId,
              groupId: groupId,
              originDeviceId: installationId,
              originCounter: counter,
              entityType: entityType,
              entityId: entityId,
              parentVersionJson: operation.parentVersionJson,
              changedFieldsJson: operation.changedFieldsJson,
              operationKind: operation.operationKind,
              protocolVersion: state.protocolVersion,
              payloadSha256: operation.payloadSha256.toLowerCase(),
              createdAt: now,
            ),
          );

      final versionJson = _canonicalVersionJson({installationId: counter});
      final fields = (jsonDecode(operation.changedFieldsJson) as Map).keys;
      for (final field in fields.cast<String>()) {
        await _database
            .into(_database.syncEntityVersionRecords)
            .insertOnConflictUpdate(
              SyncEntityVersionRecordsCompanion.insert(
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                fieldName: field,
                causalVersionJson: versionJson,
                operationId: operation.operationId,
                originDeviceId: installationId,
                updatedAt: now,
              ),
            );
      }
      return true;
    });
  }

  Future<bool> applyRemoteOperation({
    required RemoteSyncOperationIdentity operation,
    required DateTime appliedAt,
    required Future<void> Function(MichiFocusDatabase database) apply,
  }) {
    _validateRemoteIdentity(operation);
    return _database.transaction(() async {
      final existing =
          await (_database.select(
                _database.syncAppliedOperationRecords,
              )..where((row) => row.operationId.equals(operation.operationId)))
              .getSingleOrNull();
      if (existing != null) {
        if (existing.groupId != operation.groupId ||
            existing.originDeviceId != operation.originDeviceId ||
            existing.originCounter != operation.originCounter ||
            existing.payloadSha256 != operation.payloadSha256.toLowerCase()) {
          throw StateError('Repeated operation has inconsistent identity.');
        }
        return false;
      }

      final sameCounter =
          await (_database.select(
                _database.syncAppliedOperationRecords,
              )..where(
                (row) =>
                    row.groupId.equals(operation.groupId) &
                    row.originDeviceId.equals(operation.originDeviceId) &
                    row.originCounter.equals(operation.originCounter),
              ))
              .getSingleOrNull();
      if (sameCounter != null) {
        throw StateError(
          'Origin counter is already owned by another operation.',
        );
      }

      await apply(_database);
      await _database
          .into(_database.syncAppliedOperationRecords)
          .insert(
            SyncAppliedOperationRecordsCompanion.insert(
              operationId: operation.operationId,
              groupId: operation.groupId,
              originDeviceId: operation.originDeviceId,
              originCounter: operation.originCounter,
              payloadSha256: operation.payloadSha256.toLowerCase(),
              appliedAt: appliedAt,
            ),
          );
      return true;
    });
  }

  Future<RemoteCausalApplyResult> applyRemoteCausalOperation({
    required RemoteSyncOperationIdentity identity,
    required String entityType,
    required String entityId,
    required Map<String, int> parentVersion,
    required Set<String> changedFields,
    required bool isDelete,
    required bool isCreate,
    required DateTime appliedAt,
    required Future<void> Function(
      MichiFocusDatabase database,
      Set<String> fieldsToApply, {
      required bool applyDelete,
    })
    apply,
  }) {
    _validateRemoteIdentity(identity);
    return _database.transaction(() async {
      final localState =
          await (_database.select(
                _database.syncLocalStateRecords,
              )..where((row) => row.groupId.equals(identity.groupId)))
              .getSingleOrNull();
      if (localState == null ||
          localState.protocolVersion != 1 ||
          localState.installationId == identity.originDeviceId) {
        throw StateError(
          'Remote operation does not match the local enrollment.',
        );
      }
      final existing =
          await (_database.select(
                _database.syncAppliedOperationRecords,
              )..where((row) => row.operationId.equals(identity.operationId)))
              .getSingleOrNull();
      if (existing != null) {
        if (existing.groupId != identity.groupId ||
            existing.originDeviceId != identity.originDeviceId ||
            existing.originCounter != identity.originCounter ||
            existing.payloadSha256 != identity.payloadSha256.toLowerCase()) {
          throw StateError('Repeated operation has inconsistent identity.');
        }
        return RemoteCausalApplyResult.duplicate;
      }
      final sameCounter =
          await (_database.select(
                _database.syncAppliedOperationRecords,
              )..where(
                (row) =>
                    row.groupId.equals(identity.groupId) &
                    row.originDeviceId.equals(identity.originDeviceId) &
                    row.originCounter.equals(identity.originCounter),
              ))
              .getSingleOrNull();
      if (sameCounter != null) {
        throw StateError(
          'Origin counter is already owned by another operation.',
        );
      }

      final currentVersions = await _fieldVersions(
        groupId: identity.groupId,
        entityType: entityType,
        entityId: entityId,
      );
      final tombstone =
          await (_database.select(
                _database.syncTombstoneRecords,
              )..where(
                (row) =>
                    row.groupId.equals(identity.groupId) &
                    row.entityType.equals(entityType) &
                    row.entityId.equals(entityId),
              ))
              .getSingleOrNull();
      final knownVersion = <String, int>{};
      for (final version in currentVersions.values) {
        _mergeVersionInto(knownVersion, version);
      }
      if (tombstone != null) {
        _mergeVersionInto(
          knownVersion,
          _decodeVersion(tombstone.causalVersionJson),
        );
      }
      if (!_dominates(knownVersion, parentVersion)) {
        return RemoteCausalApplyResult.deferred;
      }

      final resultingVersion = <String, int>{...parentVersion};
      final currentOrigin = resultingVersion[identity.originDeviceId] ?? 0;
      if (identity.originCounter <= currentOrigin) {
        throw StateError('Remote origin counter does not advance its parent.');
      }
      resultingVersion[identity.originDeviceId] = identity.originCounter;
      final resultingJson = _canonicalVersionJson(resultingVersion);
      final fieldsToApply = <String>{};
      final conflicts = <String>{};

      if (isDelete) {
        if (_dominates(parentVersion, knownVersion)) {
          await apply(_database, const {}, applyDelete: true);
          await (_database.delete(
                _database.syncEntityVersionRecords,
              )..where(
                (row) =>
                    row.groupId.equals(identity.groupId) &
                    row.entityType.equals(entityType) &
                    row.entityId.equals(entityId),
              ))
              .go();
          await _database
              .into(_database.syncTombstoneRecords)
              .insertOnConflictUpdate(
                SyncTombstoneRecordsCompanion.insert(
                  groupId: identity.groupId,
                  entityType: entityType,
                  entityId: entityId,
                  causalVersionJson: resultingJson,
                  operationId: identity.operationId,
                  originDeviceId: identity.originDeviceId,
                  deletedAt: appliedAt,
                ),
              );
        } else if (!_dominates(knownVersion, resultingVersion)) {
          conflicts.add('__delete__');
        }
      } else if (tombstone != null) {
        final tombstoneVersion = _decodeVersion(tombstone.causalVersionJson);
        if (isCreate && _dominates(parentVersion, tombstoneVersion)) {
          fieldsToApply.addAll(changedFields);
        } else if (!_dominates(tombstoneVersion, resultingVersion)) {
          conflicts.add('__delete__');
        }
      } else {
        for (final field in changedFields) {
          final current = currentVersions[field] ?? const <String, int>{};
          if (_dominates(parentVersion, current)) {
            fieldsToApply.add(field);
          } else if (!_dominates(current, resultingVersion)) {
            conflicts.add(field);
          }
        }
        if (fieldsToApply.isNotEmpty) {
          await apply(_database, fieldsToApply, applyDelete: false);
          for (final field in fieldsToApply) {
            await _database
                .into(_database.syncEntityVersionRecords)
                .insertOnConflictUpdate(
                  SyncEntityVersionRecordsCompanion.insert(
                    groupId: identity.groupId,
                    entityType: entityType,
                    entityId: entityId,
                    fieldName: field,
                    causalVersionJson: resultingJson,
                    operationId: identity.operationId,
                    originDeviceId: identity.originDeviceId,
                    updatedAt: appliedAt,
                  ),
                );
          }
          await (_database.delete(
                _database.syncTombstoneRecords,
              )..where(
                (row) =>
                    row.groupId.equals(identity.groupId) &
                    row.entityType.equals(entityType) &
                    row.entityId.equals(entityId),
              ))
              .go();
        }
      }

      for (final field in conflicts) {
        await _database
            .into(_database.syncConflictRecords)
            .insertOnConflictUpdate(
              SyncConflictRecordsCompanion.insert(
                id: 'conflict:${identity.operationId}:$field',
                groupId: identity.groupId,
                entityType: entityType,
                entityId: entityId,
                fieldName: Value(field == '__delete__' ? null : field),
                candidatesJson: jsonEncode({
                  'remoteOperationId': identity.operationId,
                  'remoteOriginDeviceId': identity.originDeviceId,
                  'remoteVersion': resultingVersion,
                  'currentVersion': field == '__delete__'
                      ? knownVersion
                      : currentVersions[field],
                }),
                createdAt: appliedAt,
              ),
            );
      }
      await _database
          .into(_database.syncAppliedOperationRecords)
          .insert(
            SyncAppliedOperationRecordsCompanion.insert(
              operationId: identity.operationId,
              groupId: identity.groupId,
              originDeviceId: identity.originDeviceId,
              originCounter: identity.originCounter,
              payloadSha256: identity.payloadSha256.toLowerCase(),
              appliedAt: appliedAt,
            ),
          );
      if (conflicts.isNotEmpty) return RemoteCausalApplyResult.conflicted;
      if (isDelete || fieldsToApply.isNotEmpty) {
        return RemoteCausalApplyResult.applied;
      }
      return RemoteCausalApplyResult.obsolete;
    });
  }

  Future<List<SyncOutboxRecord>> pendingOutbox({
    String? groupId,
    String? originDeviceId,
  }) {
    final query = _database.select(_database.syncOutboxRecords)
      ..where((row) {
        var expression = row.publicationState.isNotValue('published');
        if (groupId != null) expression &= row.groupId.equals(groupId);
        if (originDeviceId != null) {
          expression &= row.originDeviceId.equals(originDeviceId);
        }
        return expression;
      })
      ..orderBy([(row) => OrderingTerm.asc(row.originCounter)]);
    return query.get();
  }

  Future<SyncOutboxRecord> markPublicationAttempt(String operationId) {
    return _database.transaction(() async {
      final record = await _outboxById(operationId);
      if (record.publicationState == 'published') return record;
      await (_database.update(
        _database.syncOutboxRecords,
      )..where((row) => row.operationId.equals(operationId))).write(
        SyncOutboxRecordsCompanion(
          publicationState: const Value('publishing'),
          publicationAttempts: Value(record.publicationAttempts + 1),
        ),
      );
      return _outboxById(operationId);
    });
  }

  Future<void> markPublished({
    required String operationId,
    required DateTime publishedAt,
  }) async {
    final changed =
        await (_database.update(
          _database.syncOutboxRecords,
        )..where((row) => row.operationId.equals(operationId))).write(
          SyncOutboxRecordsCompanion(
            publicationState: const Value('published'),
            publishedAt: Value(publishedAt),
          ),
        );
    if (changed != 1) throw StateError('Outbox operation does not exist.');
  }

  Future<void> markPublicationFailed(String operationId) async {
    final changed =
        await (_database.update(
              _database.syncOutboxRecords,
            )..where(
              (row) =>
                  row.operationId.equals(operationId) &
                  row.publicationState.isNotValue('published'),
            ))
            .write(
              const SyncOutboxRecordsCompanion(
                publicationState: Value('failed'),
              ),
            );
    if (changed > 1) throw StateError('Outbox identity is not unique.');
  }

  Future<SyncOutboxRecord> _outboxById(String operationId) async {
    final record = await (_database.select(
      _database.syncOutboxRecords,
    )..where((row) => row.operationId.equals(operationId))).getSingleOrNull();
    if (record == null) throw StateError('Outbox operation does not exist.');
    return record;
  }

  Future<Map<String, int>> _entityVersion({
    required String groupId,
    required String entityType,
    required String entityId,
  }) async {
    final rows =
        await (_database.select(
              _database.syncEntityVersionRecords,
            )..where(
              (row) =>
                  row.groupId.equals(groupId) &
                  row.entityType.equals(entityType) &
                  row.entityId.equals(entityId),
            ))
            .get();
    final merged = <String, int>{};
    for (final row in rows) {
      final decoded = jsonDecode(row.causalVersionJson);
      if (decoded is! Map<String, dynamic>) {
        throw StateError('Stored causal version is invalid.');
      }
      for (final entry in decoded.entries) {
        final counter = entry.value;
        if (counter is! int || counter < 1) {
          throw StateError('Stored causal counter is invalid.');
        }
        final current = merged[entry.key] ?? 0;
        if (counter > current) merged[entry.key] = counter;
      }
    }
    final tombstone =
        await (_database.select(
              _database.syncTombstoneRecords,
            )..where(
              (row) =>
                  row.groupId.equals(groupId) &
                  row.entityType.equals(entityType) &
                  row.entityId.equals(entityId),
            ))
            .getSingleOrNull();
    if (tombstone != null) {
      _mergeVersionInto(merged, _decodeVersion(tombstone.causalVersionJson));
    }
    return merged;
  }

  Future<Map<String, Map<String, int>>> _fieldVersions({
    required String groupId,
    required String entityType,
    required String entityId,
  }) async {
    final rows =
        await (_database.select(
              _database.syncEntityVersionRecords,
            )..where(
              (row) =>
                  row.groupId.equals(groupId) &
                  row.entityType.equals(entityType) &
                  row.entityId.equals(entityId),
            ))
            .get();
    return {
      for (final row in rows)
        row.fieldName: _decodeVersion(row.causalVersionJson),
    };
  }

  Map<String, int> _decodeVersion(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Stored causal version is invalid.');
    }
    return decoded.map((key, value) {
      if (value is! int || value < 1) {
        throw StateError('Stored causal counter is invalid.');
      }
      return MapEntry(key, value);
    });
  }

  bool _dominates(Map<String, int> left, Map<String, int> right) {
    for (final entry in right.entries) {
      if ((left[entry.key] ?? 0) < entry.value) {
        return false;
      }
    }
    return true;
  }

  void _mergeVersionInto(Map<String, int> target, Map<String, int> source) {
    for (final entry in source.entries) {
      if ((target[entry.key] ?? 0) < entry.value) {
        target[entry.key] = entry.value;
      }
    }
  }

  String _canonicalVersionJson(Map<String, int> version) {
    final devices = version.keys.toList()..sort();
    return jsonEncode({for (final device in devices) device: version[device]});
  }

  void _validateDraft(LocalSyncOperationDraft draft) {
    _requireText(draft.operationId, 'operationId');
    _requireText(draft.entityType, 'entityType');
    _requireText(draft.entityId, 'entityId');
    _requireText(draft.operationKind, 'operationKind');
    _requireJsonObject(draft.parentVersionJson, 'parentVersionJson');
    _requireJsonObject(draft.changedFieldsJson, 'changedFieldsJson');
    _requireSha256(draft.payloadSha256);
  }

  void _validateRemoteIdentity(RemoteSyncOperationIdentity operation) {
    _requireText(operation.operationId, 'operationId');
    _requireText(operation.groupId, 'groupId');
    _requireText(operation.originDeviceId, 'originDeviceId');
    if (operation.originCounter < 1) {
      throw ArgumentError.value(operation.originCounter, 'originCounter');
    }
    _requireSha256(operation.payloadSha256);
  }

  void _requireJsonObject(String source, String name) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('$name must contain a JSON object.');
    }
  }

  void _requireSha256(String value) {
    if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(value)) {
      throw const FormatException(
        'payloadSha256 must be a SHA-256 hex digest.',
      );
    }
  }

  void _requireText(String value, String name) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, name, 'Must not be empty.');
    }
  }
}
