import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_initial_bootstrap_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';

void main() {
  late MichiFocusDatabase database;
  late DriftSyncInitialBootstrapService service;
  final now = DateTime.utc(2026, 8, 15, 12);

  setUp(() async {
    database = MichiFocusDatabase(NativeDatabase.memory());
    service = DriftSyncInitialBootstrapService(
      database: database,
      exchangeRepository: DriftSyncExchangeRepository(database),
      idGenerator: SecureSyncIdGenerator(random: Random(42)),
      clock: () => now,
    );
    await _seedExistingData(database, now);
  });

  tearDown(() => database.close());

  test(
    'queues existing mutable data in dependency order with complete payloads',
    () async {
      final report = await service(
        groupId: _groupId,
        installationId: _installationId,
        protocolVersion: 1,
      );

      expect(report.queued, 4);
      expect(report.skipped, 0);
      final outbox = await database.select(database.syncOutboxRecords).get();
      outbox.sort(
        (left, right) => left.originCounter.compareTo(right.originCounter),
      );
      expect(outbox.map((row) => row.entityType), [
        'goal',
        'routine',
        'task',
        'calendarEvent',
      ]);
      expect(outbox.map((row) => row.operationKind), everyElement('create'));
      expect(outbox.map((row) => row.parentVersionJson), everyElement('{}'));

      final task =
          jsonDecode(outbox[2].changedFieldsJson) as Map<String, dynamic>;
      expect(task['title'], 'Existing task');
      expect(task['goalId'], 'goal-existing');
      expect(task['status'], 'in_progress');
      final routine =
          jsonDecode(outbox[1].changedFieldsJson) as Map<String, dynamic>;
      final aggregate = routine['aggregate'] as Map<String, dynamic>;
      expect(aggregate['weekdays'], [1, 3]);
      final items = (aggregate['items'] as List).cast<Map<String, dynamic>>();
      expect(items.single['title'], 'First item');
    },
  );

  test('is idempotent when preparation is repeated', () async {
    final first = await service(
      groupId: _groupId,
      installationId: _installationId,
      protocolVersion: 1,
    );
    final second = await service(
      groupId: _groupId,
      installationId: _installationId,
      protocolVersion: 1,
    );

    expect(first.queued, 4);
    expect(second.queued, 0);
    expect(second.skipped, 4);
    expect(
      await database.select(database.syncOutboxRecords).get(),
      hasLength(4),
    );
    final state = await database
        .select(database.syncLocalStateRecords)
        .getSingle();
    expect(state.logicalCounter, 4);
  });

  test('repairs an entity that only has a pre-bootstrap local update', () async {
    final exchange = DriftSyncExchangeRepository(database);
    await exchange.initializeLocalState(
      groupId: _groupId,
      installationId: _installationId,
      protocolVersion: 1,
      now: now,
    );
    await exchange.commitLocalMutation(
      groupId: _groupId,
      installationId: _installationId,
      entityType: 'goal',
      entityId: 'goal-existing',
      now: now,
      buildOperation: (counter, parentVersion) async =>
          const LocalSyncOperationDraft(
            operationId: 'operation_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            entityType: 'goal',
            entityId: 'goal-existing',
            parentVersionJson: '{}',
            changedFieldsJson: '{"title":"Existing goal"}',
            operationKind: 'update',
            payloadSha256:
                'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          ),
      mutate: (_) async {},
    );

    final report = await service(
      groupId: _groupId,
      installationId: _installationId,
      protocolVersion: 1,
    );
    final goalOutbox =
        await (database.select(database.syncOutboxRecords)
              ..where((row) => row.entityId.equals('goal-existing'))
              ..orderBy([(row) => OrderingTerm.asc(row.originCounter)]))
            .get();

    expect(report.queued, 4);
    expect(goalOutbox.map((row) => row.operationKind), ['update', 'create']);
    expect(
      jsonDecode(goalOutbox.last.changedFieldsJson),
      containsPair('targetSessions', 8),
    );
    final repeated = await service(
      groupId: _groupId,
      installationId: _installationId,
      protocolVersion: 1,
    );
    expect(repeated.queued, 0);
  });
}

Future<void> _seedExistingData(
  MichiFocusDatabase database,
  DateTime now,
) async {
  await database
      .into(database.goalRecords)
      .insert(
        GoalRecordsCompanion.insert(
          id: 'goal-existing',
          title: 'Existing goal',
          targetSessions: 8,
          completedSessions: const Value(2),
          createdAt: now.subtract(const Duration(days: 3)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      );
  await database
      .into(database.routineRecords)
      .insert(
        RoutineRecordsCompanion.insert(
          id: 'routine-existing',
          name: 'Existing routine',
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now,
        ),
      );
  await database.batch((batch) {
    batch
      ..insertAll(database.routineDayRecords, [
        RoutineDayRecordsCompanion.insert(
          routineId: 'routine-existing',
          weekday: 3,
        ),
        RoutineDayRecordsCompanion.insert(
          routineId: 'routine-existing',
          weekday: 1,
        ),
      ])
      ..insert(
        database.routineItemRecords,
        RoutineItemRecordsCompanion.insert(
          id: 'item-existing',
          routineId: 'routine-existing',
          position: 0,
          title: 'First item',
          scheduledMinute: 480,
          durationMinutes: 25,
          createdAt: now,
          updatedAt: now,
        ),
      );
  });
  await database
      .into(database.taskRecords)
      .insert(
        TaskRecordsCompanion.insert(
          id: 'task-existing',
          title: 'Existing task',
          status: const Value('in_progress'),
          goalId: const Value('goal-existing'),
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.calendarEventRecords)
      .insert(
        CalendarEventRecordsCompanion.insert(
          id: 'calendar-existing',
          title: 'Existing event',
          scheduledAt: now.add(const Duration(days: 1)),
          durationMinutes: 30,
          createdAt: now,
        ),
      );
}

const _groupId = 'group_0123456789abcdef0123456789abcdef';
const _installationId = 'installation_0123456789abcdef0123456789abcdef';
