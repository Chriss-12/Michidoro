import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';

void main() {
  late MichiFocusDatabase database;
  late DriftSyncExchangeRepository repository;
  final now = DateTime(2026, 8, 14, 10);

  setUp(() async {
    database = MichiFocusDatabase(NativeDatabase.memory());
    repository = DriftSyncExchangeRepository(database);
    await repository.initializeLocalState(
      groupId: 'group-a',
      installationId: 'phone-a',
      protocolVersion: 1,
      now: now,
    );
  });

  tearDown(() => database.close());

  test(
    'commits application mutation, counter, and outbox atomically',
    () async {
      final outbox = await repository.commitLocalMutation(
        groupId: 'group-a',
        installationId: 'phone-a',
        entityType: 'goal',
        entityId: 'goal-a',
        now: now,
        buildOperation: (counter, _) async => _draft('operation-$counter'),
        mutate: (db) => GoalsDao(db).insertGoal(
          GoalRecordsCompanion.insert(
            id: 'goal-a',
            title: 'Read',
            targetSessions: 2,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );

      expect(outbox.originCounter, 1);
      expect(outbox.operationId, 'operation-1');
      expect((await GoalsDao(database).findById('goal-a'))?.title, 'Read');
      expect(
        (await repository.pendingOutbox()).single.operationId,
        'operation-1',
      );
    },
  );

  test(
    'rolls back application mutation and counter when outbox insert fails',
    () async {
      await repository.commitLocalMutation(
        groupId: 'group-a',
        installationId: 'phone-a',
        entityType: 'goal',
        entityId: 'goal-a',
        now: now,
        buildOperation: (_, _) async => _draft('duplicate-operation'),
        mutate: (_) async {},
      );

      await expectLater(
        repository.commitLocalMutation(
          groupId: 'group-a',
          installationId: 'phone-a',
          entityType: 'goal',
          entityId: 'goal-a',
          now: now,
          buildOperation: (_, _) async => _draft('duplicate-operation'),
          mutate: (db) => GoalsDao(db).insertGoal(
            GoalRecordsCompanion.insert(
              id: 'rolled-back-goal',
              title: 'Must roll back',
              targetSessions: 1,
              createdAt: now,
              updatedAt: now,
            ),
          ),
        ),
        throwsA(anything),
      );

      expect(await GoalsDao(database).findById('rolled-back-goal'), isNull);
      final state = await database
          .select(database.syncLocalStateRecords)
          .getSingle();
      expect(state.logicalCounter, 1);
    },
  );

  test(
    'applies a remote operation once and deduplicates exact repeats',
    () async {
      const identity = RemoteSyncOperationIdentity(
        operationId: 'remote-1',
        groupId: 'group-a',
        originDeviceId: 'phone-b',
        originCounter: 1,
        payloadSha256: _sha,
      );
      var applications = 0;

      expect(
        await repository.applyRemoteOperation(
          operation: identity,
          appliedAt: now,
          apply: (_) async => applications++,
        ),
        isTrue,
      );
      expect(
        await repository.applyRemoteOperation(
          operation: identity,
          appliedAt: now,
          apply: (_) async => applications++,
        ),
        isFalse,
      );
      expect(applications, 1);
    },
  );

  test('rolls back remote mutation when ledger recording conflicts', () async {
    await repository.applyRemoteOperation(
      operation: const RemoteSyncOperationIdentity(
        operationId: 'remote-first',
        groupId: 'group-a',
        originDeviceId: 'phone-b',
        originCounter: 1,
        payloadSha256: _sha,
      ),
      appliedAt: now,
      apply: (_) async {},
    );

    await expectLater(
      repository.applyRemoteOperation(
        operation: const RemoteSyncOperationIdentity(
          operationId: 'remote-conflict',
          groupId: 'group-a',
          originDeviceId: 'phone-b',
          originCounter: 1,
          payloadSha256: _otherSha,
        ),
        appliedAt: now,
        apply: (db) => GoalsDao(db).insertGoal(
          GoalRecordsCompanion.insert(
            id: 'remote-rolled-back',
            title: 'Must roll back',
            targetSessions: 1,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      ),
      throwsStateError,
    );
    expect(await GoalsDao(database).findById('remote-rolled-back'), isNull);
  });

  test(
    'records concurrent same-field changes instead of overwriting',
    () async {
      await repository.commitLocalMutation(
        groupId: 'group-a',
        installationId: 'phone-a',
        entityType: 'goal',
        entityId: 'goal-a',
        now: now,
        buildOperation: (_, _) async => _draft('local-title'),
        mutate: (db) => GoalsDao(db).insertGoal(
          GoalRecordsCompanion.insert(
            id: 'goal-a',
            title: 'Local title',
            targetSessions: 2,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );
      var applied = false;

      final result = await repository.applyRemoteCausalOperation(
        identity: const RemoteSyncOperationIdentity(
          operationId: 'remote-title',
          groupId: 'group-a',
          originDeviceId: 'phone-b',
          originCounter: 1,
          payloadSha256: _otherSha,
        ),
        entityType: 'goal',
        entityId: 'goal-a',
        parentVersion: const {},
        changedFields: const {'title'},
        isDelete: false,
        isCreate: false,
        appliedAt: now,
        apply: (_, _, {required applyDelete}) async => applied = true,
      );

      expect(result, RemoteCausalApplyResult.conflicted);
      expect(applied, isFalse);
      expect(
        (await GoalsDao(database).findById('goal-a'))?.title,
        'Local title',
      );
      expect(
        await database.select(database.syncConflictRecords).get(),
        hasLength(1),
      );
    },
  );

  test('a delayed update cannot revive a causally deleted entity', () async {
    await repository.commitLocalMutation(
      groupId: 'group-a',
      installationId: 'phone-a',
      entityType: 'goal',
      entityId: 'goal-a',
      now: now,
      buildOperation: (_, _) async => _draft('local-create'),
      mutate: (db) => GoalsDao(db).insertGoal(
        GoalRecordsCompanion.insert(
          id: 'goal-a',
          title: 'Temporary',
          targetSessions: 1,
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );
    await repository.commitLocalMutation(
      groupId: 'group-a',
      installationId: 'phone-a',
      entityType: 'goal',
      entityId: 'goal-a',
      now: now,
      buildOperation: (_, parent) async => LocalSyncOperationDraft(
        operationId: 'local-delete',
        entityType: 'goal',
        entityId: 'goal-a',
        parentVersionJson: jsonEncode(parent),
        changedFieldsJson: '{}',
        operationKind: 'delete',
        payloadSha256: _sha,
      ),
      mutate: (db) => GoalsDao(db).deleteById('goal-a'),
    );
    var applied = false;

    final result = await repository.applyRemoteCausalOperation(
      identity: const RemoteSyncOperationIdentity(
        operationId: 'delayed-update',
        groupId: 'group-a',
        originDeviceId: 'phone-b',
        originCounter: 1,
        payloadSha256: _otherSha,
      ),
      entityType: 'goal',
      entityId: 'goal-a',
      parentVersion: const {},
      changedFields: const {'title'},
      isDelete: false,
      isCreate: false,
      appliedAt: now,
      apply: (_, _, {required applyDelete}) async => applied = true,
    );

    expect(result, RemoteCausalApplyResult.conflicted);
    expect(applied, isFalse);
    expect(await GoalsDao(database).findById('goal-a'), isNull);
  });
}

const _sha = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const _otherSha =
    'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';

LocalSyncOperationDraft _draft(String operationId) => LocalSyncOperationDraft(
  operationId: operationId,
  entityType: 'goal',
  entityId: 'goal-a',
  parentVersionJson: '{}',
  changedFieldsJson: '{"title":"Read"}',
  operationKind: 'create',
  payloadSha256: _sha,
);
