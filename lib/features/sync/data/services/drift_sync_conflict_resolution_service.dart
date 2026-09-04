import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_conflict.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_conflict_resolution_service.dart';

class DriftSyncConflictResolutionService
    implements SyncConflictResolutionService {
  DriftSyncConflictResolutionService({
    required MichiFocusDatabase database,
    required DriftSyncExchangeRepository exchangeRepository,
    required SecureSyncIdGenerator idGenerator,
    DateTime Function()? clock,
  }) : _database = database,
       _exchangeRepository = exchangeRepository,
       _idGenerator = idGenerator,
       _clock = clock ?? DateTime.now;

  final MichiFocusDatabase _database;
  final DriftSyncExchangeRepository _exchangeRepository;
  final SecureSyncIdGenerator _idGenerator;
  final DateTime Function() _clock;

  @override
  Future<List<SyncConflict>> loadOpen({
    required String groupId,
    required String localInstallationId,
    required String localDeviceName,
  }) async {
    final records = await _exchangeRepository.openConflictRecords(groupId);
    return records
        .map(
          (record) => _decodeConflict(
            record,
            localInstallationId: localInstallationId,
            localDeviceName: localDeviceName,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> resolve({
    required String conflictId,
    required String groupId,
    required String localInstallationId,
    required String localDeviceName,
    required SyncConflictChoice choice,
  }) async {
    final record = await (_database.select(
      _database.syncConflictRecords,
    )..where((row) => row.id.equals(conflictId))).getSingleOrNull();
    if (record == null ||
        record.groupId != groupId ||
        record.status != 'open') {
      throw StateError('Open synchronization conflict does not exist.');
    }
    final decoded = _decodeCandidates(record.candidatesJson);
    if (choice == SyncConflictChoice.preserveBoth) {
      await _preserveBoth(
        record: record,
        candidates: decoded,
        groupId: groupId,
        localInstallationId: localInstallationId,
        localDeviceName: localDeviceName,
      );
      return;
    }
    final candidate = choice == SyncConflictChoice.local
        ? decoded.local
        : decoded.remote;
    if (!candidate.canApply) {
      throw StateError('The selected conflict candidate cannot be restored.');
    }

    final Map<String, Object?> changedFields;
    final String operationKind;
    if (candidate.isDeletion) {
      changedFields = const {};
      operationKind = 'delete';
    } else if (record.fieldName != null) {
      changedFields = {record.fieldName!: candidate.value};
      operationKind = 'update';
    } else {
      final value = candidate.snapshot;
      if (value.isEmpty) {
        throw StateError('Conflict candidate does not contain a full entity.');
      }
      changedFields = value;
      operationKind = 'create';
    }

    final now = _sqliteDateTime(_clock().toUtc());
    await _exchangeRepository.commitConflictResolution(
      conflictId: conflictId,
      groupId: groupId,
      installationId: localInstallationId,
      operationKind: operationKind,
      changedFields: changedFields,
      now: now,
      buildOperation: (counter, parentVersion) async {
        final operation = SyncOperation(
          groupId: groupId,
          operationId: _idGenerator.create('operation'),
          originDeviceId: localInstallationId,
          originCounter: counter,
          entityType: record.entityType,
          entityId: record.entityId,
          parentVersion: parentVersion,
          changedFields: changedFields,
          operationKind: operationKind,
          createdAtEpochMillis: now.millisecondsSinceEpoch,
          originDeviceName: localDeviceName,
          entitySnapshot: candidate.isDeletion
              ? candidate.snapshot
              : {
                  ...candidate.snapshot,
                  ...changedFields,
                },
        );
        final digest = await Sha256().hash(operation.canonicalBytes());
        return LocalSyncOperationDraft(
          operationId: operation.operationId,
          entityType: operation.entityType,
          entityId: operation.entityId,
          parentVersionJson: _canonicalJson(parentVersion),
          changedFieldsJson: _canonicalJson(changedFields),
          operationKind: operation.operationKind,
          payloadSha256: digest.bytes
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join(),
          entitySnapshotJson: _canonicalJson(
            candidate.isDeletion
                ? candidate.snapshot
                : {...candidate.snapshot, ...changedFields},
          ),
          originDeviceName: localDeviceName,
        );
      },
      mutate: (database) async {
        if (candidate.isDeletion) {
          await _deleteEntity(database, record.entityType, record.entityId);
        } else {
          await _applyFields(
            database,
            entityType: record.entityType,
            entityId: record.entityId,
            fields: changedFields,
            createIfMissing: operationKind == 'create',
          );
        }
      },
    );
  }

  Future<void> _preserveBoth({
    required SyncConflictRecord record,
    required _StoredCandidates candidates,
    required String groupId,
    required String localInstallationId,
    required String localDeviceName,
  }) async {
    final domainConflict = _decodeConflict(
      record,
      localInstallationId: localInstallationId,
      localDeviceName: localDeviceName,
    );
    if (!domainConflict.canPreserveBoth) {
      throw StateError('This conflict cannot preserve both versions safely.');
    }
    final originalChoice = domainConflict.isDeletionConflict
        ? (candidates.local.isDeletion
              ? SyncConflictChoice.local
              : SyncConflictChoice.remote)
        : SyncConflictChoice.local;
    final duplicate = domainConflict.isDeletionConflict
        ? (candidates.local.isDeletion ? candidates.remote : candidates.local)
        : candidates.remote;
    final duplicateId = _idGenerator.create(
      record.entityType == 'calendarEvent'
          ? 'calendar-event'
          : record.entityType,
    );
    final now = _sqliteDateTime(_clock().toUtc());

    await _database.transaction(() async {
      await resolve(
        conflictId: record.id,
        groupId: groupId,
        localInstallationId: localInstallationId,
        localDeviceName: localDeviceName,
        choice: originalChoice,
      );
      await _exchangeRepository.commitLocalMutation(
        groupId: groupId,
        installationId: localInstallationId,
        entityType: record.entityType,
        entityId: duplicateId,
        now: now,
        buildOperation: (counter, parentVersion) async {
          final operation = SyncOperation(
            groupId: groupId,
            operationId: _idGenerator.create('operation'),
            originDeviceId: localInstallationId,
            originCounter: counter,
            entityType: record.entityType,
            entityId: duplicateId,
            parentVersion: parentVersion,
            changedFields: duplicate.snapshot,
            operationKind: 'create',
            createdAtEpochMillis: now.millisecondsSinceEpoch,
            originDeviceName: localDeviceName,
            entitySnapshot: duplicate.snapshot,
          );
          final digest = await Sha256().hash(operation.canonicalBytes());
          return LocalSyncOperationDraft(
            operationId: operation.operationId,
            entityType: operation.entityType,
            entityId: operation.entityId,
            parentVersionJson: _canonicalJson(parentVersion),
            changedFieldsJson: _canonicalJson(duplicate.snapshot),
            operationKind: operation.operationKind,
            payloadSha256: digest.bytes
                .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                .join(),
            originDeviceName: localDeviceName,
            entitySnapshotJson: _canonicalJson(duplicate.snapshot),
          );
        },
        mutate: (database) => _applyFields(
          database,
          entityType: record.entityType,
          entityId: duplicateId,
          fields: duplicate.snapshot,
          createIfMissing: true,
        ),
      );
    });
  }

  SyncConflict _decodeConflict(
    SyncConflictRecord record, {
    required String localInstallationId,
    required String localDeviceName,
  }) {
    final candidates = _decodeCandidates(record.candidatesJson);
    return SyncConflict(
      id: record.id,
      entityType: record.entityType,
      entityId: record.entityId,
      fieldName: record.fieldName,
      createdAt: record.createdAt,
      local: _toDomainCandidate(
        candidates.local,
        localInstallationId: localInstallationId,
        localDeviceName: localDeviceName,
      ),
      remote: _toDomainCandidate(
        candidates.remote,
        localInstallationId: localInstallationId,
        localDeviceName: localDeviceName,
      ),
    );
  }

  SyncConflictCandidate _toDomainCandidate(
    _StoredCandidate candidate, {
    required String localInstallationId,
    required String localDeviceName,
  }) {
    final storedName = candidate.deviceName.trim();
    final label = storedName.isNotEmpty
        ? storedName
        : candidate.originDeviceId == localInstallationId &&
              localDeviceName.trim().isNotEmpty
        ? localDeviceName.trim()
        : _shortDeviceId(candidate.originDeviceId);
    return SyncConflictCandidate(
      originDeviceId: candidate.originDeviceId,
      deviceLabel: label,
      recordedAt: candidate.recordedAt,
      value: candidate.value,
      isDeletion: candidate.isDeletion,
      canApply: candidate.canApply,
      snapshot: candidate.snapshot,
    );
  }

  _StoredCandidates _decodeCandidates(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic> || decoded['schemaVersion'] != 1) {
      return _StoredCandidates.unsupported();
    }
    return _StoredCandidates(
      local: _decodeCandidate(decoded['local']),
      remote: _decodeCandidate(decoded['remote']),
    );
  }

  _StoredCandidate _decodeCandidate(Object? source) {
    if (source is! Map<String, dynamic>) {
      return _StoredCandidate.unsupported();
    }
    final origin = source['originDeviceId'];
    final recordedAt = source['recordedAt'];
    return _StoredCandidate(
      originDeviceId: origin is String ? origin : '',
      deviceName: source['deviceName'] is String
          ? source['deviceName']! as String
          : '',
      recordedAt: recordedAt is int && recordedAt > 0
          ? DateTime.fromMillisecondsSinceEpoch(recordedAt, isUtc: true)
          : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      value: source['value'],
      snapshot: source['snapshot'] is Map<String, dynamic>
          ? Map<String, Object?>.from(
              source['snapshot']! as Map<String, dynamic>,
            )
          : const {},
      isDeletion: source['isDeletion'] == true,
      canApply: source['canApply'] == true,
    );
  }

  Future<Map<String, Object?>?> readCurrentFields(
    MichiFocusDatabase database,
    String entityType,
    String entityId,
  ) {
    return switch (entityType) {
      'goal' => _goalFields(database, entityId),
      'task' => _taskFields(database, entityId),
      'calendarEvent' => _calendarFields(database, entityId),
      'routine' => _routineFields(database, entityId),
      'quickNote' => _quickNoteFields(database, entityId),
      _ => Future.value(),
    };
  }

  Future<Map<String, Object?>?> _goalFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final row = await (database.select(
      database.goalRecords,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return {
      'title': row.title,
      'targetSessions': row.targetSessions,
      'completedSessions': row.completedSessions,
      'targetDate': row.targetDate?.millisecondsSinceEpoch,
      'createdAt': row.createdAt.millisecondsSinceEpoch,
      'updatedAt': row.updatedAt.millisecondsSinceEpoch,
    };
  }

  Future<Map<String, Object?>?> _taskFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final row = await (database.select(
      database.taskRecords,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return {
      'title': row.title,
      'status': row.status,
      'isCompleted': row.isCompleted,
      'scheduledDate': row.scheduledDate?.millisecondsSinceEpoch,
      'goalId': row.goalId,
      'durationMinutes': row.durationMinutes,
      'createdAt': row.createdAt.millisecondsSinceEpoch,
      'updatedAt': row.updatedAt.millisecondsSinceEpoch,
    };
  }

  Future<Map<String, Object?>?> _calendarFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final row = await (database.select(
      database.calendarEventRecords,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return {
      'title': row.title,
      'scheduledAt': row.scheduledAt.millisecondsSinceEpoch,
      'durationMinutes': row.durationMinutes,
      'createdAt': row.createdAt.millisecondsSinceEpoch,
    };
  }

  Future<Map<String, Object?>?> _routineFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final routine = await (database.select(
      database.routineRecords,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (routine == null) return null;
    final days =
        await (database.select(database.routineDayRecords)
              ..where((item) => item.routineId.equals(id))
              ..orderBy([(item) => OrderingTerm.asc(item.weekday)]))
            .get();
    final items =
        await (database.select(database.routineItemRecords)
              ..where((item) => item.routineId.equals(id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    return {
      'aggregate': {
        'name': routine.name,
        'description': routine.description,
        'iconKey': routine.iconKey,
        'colorKey': routine.colorKey,
        'customColorArgb': routine.customColorArgb,
        'validFromLocalDate': routine.validFromLocalDate,
        'validUntilLocalDate': routine.validUntilLocalDate,
        'status': routine.status,
        'pausedUntilLocalDate': routine.pausedUntilLocalDate,
        'archivedAt': routine.archivedAt?.millisecondsSinceEpoch,
        'createdAt': routine.createdAt.millisecondsSinceEpoch,
        'updatedAt': routine.updatedAt.millisecondsSinceEpoch,
        'weekdays': days.map((day) => day.weekday).toList(growable: false),
        'items': items
            .map(
              (item) => {
                'id': item.id,
                'position': item.position,
                'title': item.title,
                'scheduledMinute': item.scheduledMinute,
                'durationMinutes': item.durationMinutes,
                'goalId': item.goalId,
                'isOptional': item.isOptional,
                'reminderMinutesBefore': item.reminderMinutesBefore,
                'pomodoroMode': item.pomodoroMode,
                'customFocusMinutes': item.customFocusMinutes,
                'customBreakMinutes': item.customBreakMinutes,
                'createdAt': item.createdAt.millisecondsSinceEpoch,
                'updatedAt': item.updatedAt.millisecondsSinceEpoch,
              },
            )
            .toList(growable: false),
      },
    };
  }

  Future<Map<String, Object?>?> _quickNoteFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final row = await (database.select(
      database.quickNoteRecords,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return {
      'text': row.textContent,
      'isCompleted': row.isCompleted,
      'colorArgb': row.colorArgb,
      'localDate': row.localDate,
      'priority': row.priority,
      'position': row.position,
      'createdAt': row.createdAt.millisecondsSinceEpoch,
      'updatedAt': row.updatedAt.millisecondsSinceEpoch,
    };
  }

  Future<void> _deleteEntity(
    MichiFocusDatabase database,
    String entityType,
    String entityId,
  ) async {
    switch (entityType) {
      case 'goal':
        await (database.delete(
          database.goalRecords,
        )..where((row) => row.id.equals(entityId))).go();
      case 'task':
        await (database.delete(
          database.taskRecords,
        )..where((row) => row.id.equals(entityId))).go();
      case 'calendarEvent':
        await (database.delete(
          database.calendarEventRecords,
        )..where((row) => row.id.equals(entityId))).go();
      case 'routine':
        await (database.delete(
          database.routineRecords,
        )..where((row) => row.id.equals(entityId))).go();
      case 'quickNote':
        await (database.delete(
          database.quickNoteRecords,
        )..where((row) => row.id.equals(entityId))).go();
      default:
        throw StateError('Unsupported synchronization entity type.');
    }
  }

  Future<void> _applyFields(
    MichiFocusDatabase database, {
    required String entityType,
    required String entityId,
    required Map<String, Object?> fields,
    required bool createIfMissing,
  }) {
    return switch (entityType) {
      'goal' => _applyGoal(database, entityId, fields, createIfMissing),
      'task' => _applyTask(database, entityId, fields, createIfMissing),
      'calendarEvent' => _applyCalendar(
        database,
        entityId,
        fields,
        createIfMissing,
      ),
      'routine' => _applyRoutine(database, entityId, fields, createIfMissing),
      'quickNote' => _applyQuickNote(
        database,
        entityId,
        fields,
        createIfMissing,
      ),
      _ => throw StateError('Unsupported synchronization entity type.'),
    };
  }

  Future<void> _applyGoal(
    MichiFocusDatabase database,
    String id,
    Map<String, Object?> fields,
    bool create,
  ) async {
    final existing = await (database.select(
      database.goalRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      if (!create) throw StateError('Goal no longer exists.');
      await database
          .into(database.goalRecords)
          .insert(
            GoalRecordsCompanion.insert(
              id: id,
              title: _string(fields, 'title'),
              targetSessions: _int(fields, 'targetSessions'),
              completedSessions: Value(_int(fields, 'completedSessions')),
              targetDate: Value(_dateOrNull(fields['targetDate'])),
              createdAt: _date(fields, 'createdAt'),
              updatedAt: _date(fields, 'updatedAt'),
            ),
          );
      return;
    }
    await (database.update(
      database.goalRecords,
    )..where((row) => row.id.equals(id))).write(
      GoalRecordsCompanion(
        title: _valueIf(fields, 'title', () => _string(fields, 'title')),
        targetSessions: _valueIf(
          fields,
          'targetSessions',
          () => _int(fields, 'targetSessions'),
        ),
        completedSessions: _valueIf(
          fields,
          'completedSessions',
          () => _int(fields, 'completedSessions'),
        ),
        targetDate: _nullableValueIf(
          fields,
          'targetDate',
          () => _dateOrNull(fields['targetDate']),
        ),
        updatedAt: _valueIf(
          fields,
          'updatedAt',
          () => _date(fields, 'updatedAt'),
        ),
      ),
    );
  }

  Future<void> _applyTask(
    MichiFocusDatabase database,
    String id,
    Map<String, Object?> fields,
    bool create,
  ) async {
    final existing = await (database.select(
      database.taskRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      if (!create) throw StateError('Task no longer exists.');
      await database
          .into(database.taskRecords)
          .insert(
            TaskRecordsCompanion.insert(
              id: id,
              title: _string(fields, 'title'),
              isCompleted: Value(_bool(fields, 'isCompleted')),
              status: Value(_string(fields, 'status')),
              scheduledDate: Value(_dateOrNull(fields['scheduledDate'])),
              goalId: Value(_nullableString(fields['goalId'])),
              durationMinutes: Value(_nullableInt(fields['durationMinutes'])),
              createdAt: _date(fields, 'createdAt'),
              updatedAt: _date(fields, 'updatedAt'),
            ),
          );
      return;
    }
    await (database.update(
      database.taskRecords,
    )..where((row) => row.id.equals(id))).write(
      TaskRecordsCompanion(
        title: _valueIf(fields, 'title', () => _string(fields, 'title')),
        isCompleted: _valueIf(
          fields,
          'isCompleted',
          () => _bool(fields, 'isCompleted'),
        ),
        status: _valueIf(fields, 'status', () => _string(fields, 'status')),
        scheduledDate: _nullableValueIf(
          fields,
          'scheduledDate',
          () => _dateOrNull(fields['scheduledDate']),
        ),
        goalId: _nullableValueIf(
          fields,
          'goalId',
          () => _nullableString(fields['goalId']),
        ),
        durationMinutes: _nullableValueIf(
          fields,
          'durationMinutes',
          () => _nullableInt(fields['durationMinutes']),
        ),
        updatedAt: _valueIf(
          fields,
          'updatedAt',
          () => _date(fields, 'updatedAt'),
        ),
      ),
    );
  }

  Future<void> _applyCalendar(
    MichiFocusDatabase database,
    String id,
    Map<String, Object?> fields,
    bool create,
  ) async {
    final existing = await (database.select(
      database.calendarEventRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      if (!create) throw StateError('Calendar event no longer exists.');
      await database
          .into(database.calendarEventRecords)
          .insert(
            CalendarEventRecordsCompanion.insert(
              id: id,
              title: _string(fields, 'title'),
              scheduledAt: _date(fields, 'scheduledAt'),
              durationMinutes: _int(fields, 'durationMinutes'),
              createdAt: _date(fields, 'createdAt'),
            ),
          );
      return;
    }
    await (database.update(
      database.calendarEventRecords,
    )..where((row) => row.id.equals(id))).write(
      CalendarEventRecordsCompanion(
        title: _valueIf(fields, 'title', () => _string(fields, 'title')),
        scheduledAt: _valueIf(
          fields,
          'scheduledAt',
          () => _date(fields, 'scheduledAt'),
        ),
        durationMinutes: _valueIf(
          fields,
          'durationMinutes',
          () => _int(fields, 'durationMinutes'),
        ),
      ),
    );
  }

  Future<void> _applyRoutine(
    MichiFocusDatabase database,
    String id,
    Map<String, Object?> fields,
    bool create,
  ) async {
    final aggregate = fields['aggregate'];
    if (aggregate is Map<String, dynamic>) {
      await RoutinesDao(database).saveRoutineAggregate(
        routine: RoutineRecordsCompanion.insert(
          id: id,
          name: _string(aggregate, 'name'),
          description: Value(_nullableString(aggregate['description'])),
          iconKey: Value(_string(aggregate, 'iconKey')),
          colorKey: Value(_string(aggregate, 'colorKey')),
          customColorArgb: Value(_nullableInt(aggregate['customColorArgb'])),
          validFromLocalDate: Value(
            _nullableString(aggregate['validFromLocalDate']),
          ),
          validUntilLocalDate: Value(
            _nullableString(aggregate['validUntilLocalDate']),
          ),
          status: Value(_string(aggregate, 'status')),
          pausedUntilLocalDate: Value(
            _nullableString(aggregate['pausedUntilLocalDate']),
          ),
          archivedAt: Value(_dateOrNull(aggregate['archivedAt'])),
          createdAt: _date(aggregate, 'createdAt'),
          updatedAt: _date(aggregate, 'updatedAt'),
        ),
        days: _intList(aggregate['weekdays'])
            .map(
              (weekday) => RoutineDayRecordsCompanion.insert(
                routineId: id,
                weekday: weekday,
              ),
            )
            .toList(growable: false),
        items: _mapList(aggregate['items'])
            .map(
              (item) => RoutineItemRecordsCompanion.insert(
                id: _string(item, 'id'),
                routineId: id,
                position: _int(item, 'position'),
                title: _string(item, 'title'),
                scheduledMinute: _int(item, 'scheduledMinute'),
                durationMinutes: _int(item, 'durationMinutes'),
                goalId: Value(_nullableString(item['goalId'])),
                isOptional: Value(_bool(item, 'isOptional')),
                reminderMinutesBefore: Value(
                  _nullableInt(item['reminderMinutesBefore']),
                ),
                pomodoroMode: Value(_string(item, 'pomodoroMode')),
                customFocusMinutes: Value(
                  _nullableInt(item['customFocusMinutes']),
                ),
                customBreakMinutes: Value(
                  _nullableInt(item['customBreakMinutes']),
                ),
                createdAt: _date(item, 'createdAt'),
                updatedAt: _date(item, 'updatedAt'),
              ),
            )
            .toList(growable: false),
      );
      return;
    }
    if (!create && await RoutinesDao(database).findRoutineById(id) == null) {
      throw StateError('Routine no longer exists.');
    }
    await (database.update(
      database.routineRecords,
    )..where((row) => row.id.equals(id))).write(
      RoutineRecordsCompanion(
        status: _valueIf(fields, 'status', () => _string(fields, 'status')),
        pausedUntilLocalDate: _nullableValueIf(
          fields,
          'pausedUntilLocalDate',
          () => _nullableString(fields['pausedUntilLocalDate']),
        ),
        archivedAt: _nullableValueIf(
          fields,
          'archivedAt',
          () => _dateOrNull(fields['archivedAt']),
        ),
        updatedAt: _valueIf(
          fields,
          'updatedAt',
          () => _date(fields, 'updatedAt'),
        ),
      ),
    );
  }

  Future<void> _applyQuickNote(
    MichiFocusDatabase database,
    String id,
    Map<String, Object?> fields,
    bool create,
  ) async {
    final existing = await (database.select(
      database.quickNoteRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      if (!create) throw StateError('Quick note no longer exists.');
      await database
          .into(database.quickNoteRecords)
          .insert(
            QuickNoteRecordsCompanion.insert(
              id: id,
              textContent: _string(fields, 'text'),
              isCompleted: Value(_bool(fields, 'isCompleted')),
              colorArgb: _int(fields, 'colorArgb'),
              localDate: Value(_nullableString(fields['localDate'])),
              priority: Value(_nullableString(fields['priority'])),
              position: _int(fields, 'position'),
              createdAt: _date(fields, 'createdAt'),
              updatedAt: _date(fields, 'updatedAt'),
            ),
          );
      return;
    }
    await (database.update(
      database.quickNoteRecords,
    )..where((row) => row.id.equals(id))).write(
      QuickNoteRecordsCompanion(
        textContent: _valueIf(
          fields,
          'text',
          () => _string(fields, 'text'),
        ),
        isCompleted: _valueIf(
          fields,
          'isCompleted',
          () => _bool(fields, 'isCompleted'),
        ),
        colorArgb: _valueIf(
          fields,
          'colorArgb',
          () => _int(fields, 'colorArgb'),
        ),
        localDate: _nullableValueIf(
          fields,
          'localDate',
          () => _nullableString(fields['localDate']),
        ),
        priority: _nullableValueIf(
          fields,
          'priority',
          () => _nullableString(fields['priority']),
        ),
        position: _valueIf(
          fields,
          'position',
          () => _int(fields, 'position'),
        ),
        updatedAt: _valueIf(
          fields,
          'updatedAt',
          () => _date(fields, 'updatedAt'),
        ),
      ),
    );
  }

  String _shortDeviceId(String source) {
    final value = source.trim();
    if (value.isEmpty) return 'desconocido';
    return value.length <= 8 ? value : '…${value.substring(value.length - 8)}';
  }

  String _canonicalJson(Map<String, Object?> source) {
    final keys = source.keys.toList()..sort();
    return jsonEncode({for (final key in keys) key: source[key]});
  }

  DateTime _sqliteDateTime(DateTime value) =>
      DateTime.fromMillisecondsSinceEpoch(
        (value.millisecondsSinceEpoch ~/ 1000) * 1000,
        isUtc: true,
      );
}

class _StoredCandidates {
  const _StoredCandidates({required this.local, required this.remote});

  _StoredCandidates.unsupported()
    : local = _StoredCandidate.unsupported(),
      remote = _StoredCandidate.unsupported();

  final _StoredCandidate local;
  final _StoredCandidate remote;
}

class _StoredCandidate {
  const _StoredCandidate({
    required this.originDeviceId,
    required this.deviceName,
    required this.recordedAt,
    required this.value,
    required this.snapshot,
    required this.isDeletion,
    required this.canApply,
  });

  _StoredCandidate.unsupported()
    : originDeviceId = '',
      deviceName = '',
      recordedAt = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      value = null,
      snapshot = const {},
      isDeletion = false,
      canApply = false;

  final String originDeviceId;
  final String deviceName;
  final DateTime recordedAt;
  final Object? value;
  final Map<String, Object?> snapshot;
  final bool isDeletion;
  final bool canApply;
}

Value<T> _valueIf<T>(
  Map<String, Object?> fields,
  String field,
  T Function() value,
) => fields.containsKey(field) ? Value(value()) : const Value.absent();

Value<T?> _nullableValueIf<T>(
  Map<String, Object?> fields,
  String field,
  T? Function() value,
) => fields.containsKey(field) ? Value(value()) : const Value.absent();

String _string(Map<String, Object?> values, String key) {
  final value = values[key];
  if (value is! String || value.trim().isEmpty) throw const FormatException();
  return value;
}

String? _nullableString(Object? value) {
  if (value == null) return null;
  if (value is! String) throw const FormatException();
  return value;
}

int _int(Map<String, Object?> values, String key) {
  final value = values[key];
  if (value is! int) throw const FormatException();
  return value;
}

int? _nullableInt(Object? value) {
  if (value == null) return null;
  if (value is! int) throw const FormatException();
  return value;
}

bool _bool(Map<String, Object?> values, String key) {
  final value = values[key];
  if (value is! bool) throw const FormatException();
  return value;
}

DateTime _date(Map<String, Object?> values, String key) {
  final value = _int(values, key);
  if (value < 1) throw const FormatException();
  return DateTime.fromMillisecondsSinceEpoch(value);
}

DateTime? _dateOrNull(Object? value) {
  if (value == null) return null;
  if (value is! int || value < 1) throw const FormatException();
  return DateTime.fromMillisecondsSinceEpoch(value);
}

List<int> _intList(Object? value) {
  if (value is! List || value.any((item) => item is! int)) {
    throw const FormatException();
  }
  return value.cast<int>();
}

List<Map<String, Object?>> _mapList(Object? value) {
  if (value is! List) throw const FormatException();
  return value
      .map((item) {
        if (item is! Map<String, dynamic>) throw const FormatException();
        return Map<String, Object?>.from(item);
      })
      .toList(growable: false);
}
