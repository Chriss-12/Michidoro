import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_conflict_resolution_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_conflict.dart';

void main() {
  late MichiFocusDatabase database;
  late DriftSyncExchangeRepository exchange;
  late DriftSyncConflictResolutionService service;
  final now = DateTime.utc(2026, 8, 24, 15);

  setUp(() async {
    database = MichiFocusDatabase(NativeDatabase.memory());
    exchange = DriftSyncExchangeRepository(database);
    service = DriftSyncConflictResolutionService(
      database: database,
      exchangeRepository: exchange,
      idGenerator: SecureSyncIdGenerator(random: Random(32)),
      clock: () => now.add(const Duration(minutes: 3)),
    );
    await exchange.initializeLocalState(
      groupId: _groupId,
      installationId: _localId,
      protocolVersion: 1,
      now: now,
    );
    await exchange.commitLocalMutation(
      groupId: _groupId,
      installationId: _localId,
      entityType: 'goal',
      entityId: 'goal-a',
      now: now,
      buildOperation: (_, _) async => const LocalSyncOperationDraft(
        operationId: 'local-create',
        entityType: 'goal',
        entityId: 'goal-a',
        parentVersionJson: '{}',
        changedFieldsJson: '{"title":"Leer local"}',
        operationKind: 'create',
        payloadSha256: _sha,
      ),
      mutate: (db) => GoalsDao(db).insertGoal(
        GoalRecordsCompanion.insert(
          id: 'goal-a',
          title: 'Leer local',
          targetSessions: 2,
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );
    await exchange.applyRemoteCausalOperation(
      identity: const RemoteSyncOperationIdentity(
        operationId: 'remote-title',
        groupId: _groupId,
        originDeviceId: _remoteId,
        originCounter: 1,
        payloadSha256: _otherSha,
      ),
      entityType: 'goal',
      entityId: 'goal-a',
      parentVersion: const {},
      changedFields: const {'title'},
      isDelete: false,
      isCreate: false,
      appliedAt: now.add(const Duration(minutes: 2)),
      remoteChangedFields: const {'title': 'Leer remoto'},
      remoteEntitySnapshot: {
        'title': 'Leer remoto',
        'targetSessions': 2,
        'completedSessions': 0,
        'targetDate': null,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.add(const Duration(minutes: 1)).millisecondsSinceEpoch,
      },
      remoteDeviceName: 'Poco personal',
      remoteCreatedAt: now.add(const Duration(minutes: 1)),
      readCurrentFields: (db) => service.readCurrentFields(
        db,
        'goal',
        'goal-a',
      ),
      apply: (_, _, {required applyDelete}) async {},
    );
  });

  tearDown(() => database.close());

  test('shows both candidates and publishes a dominating resolution', () async {
    final conflicts = await service.loadOpen(
      groupId: _groupId,
      localInstallationId: _localId,
      localDeviceName: 'Realme personal',
    );

    expect(conflicts, hasLength(1));
    expect(conflicts.single.fieldName, 'title');
    expect(conflicts.single.local.deviceLabel, 'Realme personal');
    expect(conflicts.single.local.value, 'Leer local');
    expect(conflicts.single.remote.deviceLabel, 'Poco personal');
    expect(conflicts.single.remote.value, 'Leer remoto');

    await service.resolve(
      conflictId: conflicts.single.id,
      groupId: _groupId,
      localInstallationId: _localId,
      localDeviceName: 'Realme personal',
      choice: SyncConflictChoice.remote,
    );

    expect((await GoalsDao(database).findById('goal-a'))?.title, 'Leer remoto');
    expect(
      await service.loadOpen(
        groupId: _groupId,
        localInstallationId: _localId,
        localDeviceName: 'Realme personal',
      ),
      isEmpty,
    );
    final conflictRecord = await database
        .select(database.syncConflictRecords)
        .getSingle();
    expect(conflictRecord.status, 'resolved');
    expect(conflictRecord.resolutionOperationId, isNotEmpty);
    final resolution = await (database.select(
      database.syncOutboxRecords,
    )..where((row) => row.originCounter.equals(2))).getSingle();
    expect(jsonDecode(resolution.changedFieldsJson), {'title': 'Leer remoto'});
    expect(jsonDecode(resolution.parentVersionJson), {
      _localId: 1,
      _remoteId: 1,
    });
  });

  test('an incoming dominating choice closes the local conflict', () async {
    final result = await exchange.applyRemoteCausalOperation(
      identity: const RemoteSyncOperationIdentity(
        operationId: 'resolution-from-another-phone',
        groupId: _groupId,
        originDeviceId: _resolverId,
        originCounter: 1,
        payloadSha256: _resolutionSha,
      ),
      entityType: 'goal',
      entityId: 'goal-a',
      parentVersion: const {_localId: 1, _remoteId: 1},
      changedFields: const {'title'},
      isDelete: false,
      isCreate: false,
      appliedAt: now.add(const Duration(minutes: 4)),
      remoteChangedFields: const {'title': 'Elección compartida'},
      apply: (db, fields, {required applyDelete}) async {
        await (db.update(
          db.goalRecords,
        )..where((row) => row.id.equals('goal-a'))).write(
          const GoalRecordsCompanion(title: Value('Elección compartida')),
        );
      },
    );

    expect(result, RemoteCausalApplyResult.applied);
    expect(
      (await GoalsDao(database).findById('goal-a'))?.title,
      'Elección compartida',
    );
    expect(
      await service.loadOpen(
        groupId: _groupId,
        localInstallationId: _localId,
        localDeviceName: 'Realme personal',
      ),
      isEmpty,
    );
    final record = await database
        .select(database.syncConflictRecords)
        .getSingle();
    expect(record.status, 'resolved');
    expect(record.resolutionOperationId, 'resolution-from-another-phone');
  });

  test('preserves both safe goal versions in one atomic decision', () async {
    final conflict = (await service.loadOpen(
      groupId: _groupId,
      localInstallationId: _localId,
      localDeviceName: 'Realme personal',
    )).single;
    expect(conflict.canPreserveBoth, isTrue);

    await service.resolve(
      conflictId: conflict.id,
      groupId: _groupId,
      localInstallationId: _localId,
      localDeviceName: 'Realme personal',
      choice: SyncConflictChoice.preserveBoth,
    );

    final goals = await GoalsDao(database).getAllGoals();
    expect(
      goals.map((goal) => goal.title),
      containsAll(['Leer local', 'Leer remoto']),
    );
    expect(goals.map((goal) => goal.id).toSet(), hasLength(2));
    expect(
      await service.loadOpen(
        groupId: _groupId,
        localInstallationId: _localId,
        localDeviceName: 'Realme personal',
      ),
      isEmpty,
    );
    final outbox = await database.select(database.syncOutboxRecords).get();
    expect(outbox.map((row) => row.originCounter), [1, 2, 3]);
    expect(
      outbox.skip(1).every((row) => row.originDeviceName == 'Realme personal'),
      isTrue,
    );
  });

  test(
    'restores a remotely edited entity after a concurrent local deletion',
    () async {
      const goalId = 'goal-delete-update';
      final snapshot = <String, Object?>{
        'title': 'Plan original',
        'targetSessions': 4,
        'completedSessions': 1,
        'targetDate': null,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      };
      await exchange.commitLocalMutation(
        groupId: _groupId,
        installationId: _localId,
        entityType: 'goal',
        entityId: goalId,
        now: now,
        buildOperation: (_, _) async => LocalSyncOperationDraft(
          operationId: 'local-create-delete-update',
          entityType: 'goal',
          entityId: goalId,
          parentVersionJson: '{}',
          changedFieldsJson: jsonEncode(snapshot),
          operationKind: 'create',
          payloadSha256: _sha,
          originDeviceName: 'Realme personal',
          entitySnapshotJson: jsonEncode(snapshot),
        ),
        mutate: (db) => GoalsDao(db).insertGoal(
          GoalRecordsCompanion.insert(
            id: goalId,
            title: 'Plan original',
            targetSessions: 4,
            completedSessions: const Value(1),
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );
      await exchange.commitLocalMutation(
        groupId: _groupId,
        installationId: _localId,
        entityType: 'goal',
        entityId: goalId,
        now: now.add(const Duration(minutes: 1)),
        buildOperation: (_, parent) async => LocalSyncOperationDraft(
          operationId: 'local-delete-update',
          entityType: 'goal',
          entityId: goalId,
          parentVersionJson: jsonEncode(parent),
          changedFieldsJson: '{}',
          operationKind: 'delete',
          payloadSha256: _otherSha,
          originDeviceName: 'Realme personal',
          entitySnapshotJson: jsonEncode(snapshot),
        ),
        mutate: (db) => (db.delete(
          db.goalRecords,
        )..where((row) => row.id.equals(goalId))).go(),
      );
      final remoteSnapshot = <String, Object?>{
        ...snapshot,
        'title': 'Plan editado en Poco',
        'updatedAt': now.add(const Duration(minutes: 2)).millisecondsSinceEpoch,
      };
      final result = await exchange.applyRemoteCausalOperation(
        identity: const RemoteSyncOperationIdentity(
          operationId: 'remote-update-after-local-delete',
          groupId: _groupId,
          originDeviceId: _remoteId,
          originCounter: 2,
          payloadSha256: _resolutionSha,
        ),
        entityType: 'goal',
        entityId: goalId,
        parentVersion: const {},
        changedFields: const {'title', 'updatedAt'},
        isDelete: false,
        isCreate: false,
        appliedAt: now.add(const Duration(minutes: 2)),
        remoteChangedFields: {
          'title': 'Plan editado en Poco',
          'updatedAt': remoteSnapshot['updatedAt'],
        },
        remoteEntitySnapshot: remoteSnapshot,
        remoteDeviceName: 'Poco personal',
        remoteCreatedAt: now.add(const Duration(minutes: 2)),
        readCurrentFields: (db) =>
            service.readCurrentFields(db, 'goal', goalId),
        apply: (_, _, {required applyDelete}) async {},
      );
      expect(result, RemoteCausalApplyResult.conflicted);

      final conflict = (await service.loadOpen(
        groupId: _groupId,
        localInstallationId: _localId,
        localDeviceName: 'Realme personal',
      )).firstWhere((item) => item.entityId == goalId);
      expect(conflict.local.isDeletion, isTrue);
      expect(conflict.remote.deviceLabel, 'Poco personal');
      expect(conflict.remote.canApply, isTrue);

      await service.resolve(
        conflictId: conflict.id,
        groupId: _groupId,
        localInstallationId: _localId,
        localDeviceName: 'Realme personal',
        choice: SyncConflictChoice.remote,
      );
      expect(
        (await GoalsDao(database).findById(goalId))?.title,
        'Plan editado en Poco',
      );
    },
  );

  test(
    'keeps the true friendly origin across a third-phone conflict',
    () async {
      const goalId = 'goal-three-phones';
      final pocoSnapshot = <String, Object?>{
        'title': 'Versión Poco',
        'targetSessions': 1,
        'completedSessions': 0,
        'targetDate': null,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      };
      await exchange.applyRemoteCausalOperation(
        identity: const RemoteSyncOperationIdentity(
          operationId: 'poco-create-three-phones',
          groupId: _groupId,
          originDeviceId: _remoteId,
          originCounter: 2,
          payloadSha256: _resolutionSha,
        ),
        entityType: 'goal',
        entityId: goalId,
        parentVersion: const {},
        changedFields: pocoSnapshot.keys.toSet(),
        isDelete: false,
        isCreate: true,
        appliedAt: now,
        remoteChangedFields: pocoSnapshot,
        remoteEntitySnapshot: pocoSnapshot,
        remoteDeviceName: 'Poco personal',
        apply: (db, _, {required applyDelete}) => GoalsDao(db).insertGoal(
          GoalRecordsCompanion.insert(
            id: goalId,
            title: 'Versión Poco',
            targetSessions: 1,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );
      final thirdSnapshot = <String, Object?>{
        ...pocoSnapshot,
        'title': 'Versión tercer teléfono',
        'updatedAt': now.add(const Duration(minutes: 1)).millisecondsSinceEpoch,
      };
      await exchange.applyRemoteCausalOperation(
        identity: const RemoteSyncOperationIdentity(
          operationId: 'third-phone-update',
          groupId: _groupId,
          originDeviceId: _resolverId,
          originCounter: 1,
          payloadSha256: _otherSha,
        ),
        entityType: 'goal',
        entityId: goalId,
        parentVersion: const {},
        changedFields: const {'title', 'updatedAt'},
        isDelete: false,
        isCreate: false,
        appliedAt: now.add(const Duration(minutes: 1)),
        remoteChangedFields: {
          'title': thirdSnapshot['title'],
          'updatedAt': thirdSnapshot['updatedAt'],
        },
        remoteEntitySnapshot: thirdSnapshot,
        remoteDeviceName: 'Galaxy trabajo',
        readCurrentFields: (db) =>
            service.readCurrentFields(db, 'goal', goalId),
        apply: (_, _, {required applyDelete}) async {},
      );

      final conflict = (await service.loadOpen(
        groupId: _groupId,
        localInstallationId: _localId,
        localDeviceName: 'Realme personal',
      )).firstWhere((item) => item.entityId == goalId);
      expect(conflict.local.deviceLabel, 'Poco personal');
      expect(conflict.remote.deviceLabel, 'Galaxy trabajo');
    },
  );
}

const _groupId = 'group_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const _localId = 'installation_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
const _remoteId = 'installation_cccccccccccccccccccccccccccccccc';
const _resolverId = 'installation_dddddddddddddddddddddddddddddddd';
const _sha = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const _otherSha =
    'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
const _resolutionSha =
    'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd';
