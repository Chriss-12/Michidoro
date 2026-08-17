import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/routines/data/repositories/drift_routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';

void main() {
  test(
    'clears every unified table and preserves the database schema',
    () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final now = DateTime(2026, 8, 11, 8);

      await database
          .into(database.goalRecords)
          .insert(
            GoalRecordsCompanion.insert(
              id: 'goal-1',
              title: 'Goal',
              targetSessions: 4,
              createdAt: now,
              updatedAt: now,
            ),
          );
      final routinesRepository = DriftRoutinesRepository(RoutinesDao(database));
      await routinesRepository.saveRoutine(
        Routine(
          id: 'routine-1',
          name: 'Morning',
          iconKey: 'sun',
          colorKey: 'amber',
          status: RoutineStatus.active,
          createdAt: now,
          updatedAt: now,
          weekdays: [now.weekday],
          items: [
            RoutineItem(
              id: 'item-1',
              routineId: 'routine-1',
              position: 0,
              title: 'Read',
              scheduledMinute: 8 * 60,
              durationMinutes: 30,
              goalId: 'goal-1',
              isOptional: false,
              pomodoroMode: RoutinePomodoroMode.none,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );
      await routinesRepository.reconcileLocalDay(now);
      final task = (await TasksDao(database).getAllTasks()).single;

      await database
          .into(database.taskCompletionEventRecords)
          .insert(
            TaskCompletionEventRecordsCompanion.insert(
              id: 'completion-1',
              taskId: Value(task.id),
              taskIdSnapshot: task.id,
              completedAt: now,
            ),
          );
      await database
          .into(database.reportingMetadataRecords)
          .insert(
            ReportingMetadataRecordsCompanion.insert(
              id: 'completion-history',
              completionTrackingStartedAt: now,
            ),
          );
      await PomodoroSessionsDao(database).insertSession(
        PomodoroSessionRecordsCompanion.insert(
          id: 'session-1',
          startedAt: now,
          endedAt: now.add(const Duration(minutes: 25)),
          plannedSeconds: 1500,
          focusedSeconds: 1500,
          goalId: const Value('goal-1'),
          taskId: Value(task.id),
          status: 'completed',
          createdAt: now,
        ),
      );
      await PomodoroRuntimeDao(database).saveActive(
        PomodoroRuntimeRecordsCompanion.insert(
          id: 'active-runtime',
          taskId: Value(task.id),
          phase: 'focus',
          isRunning: true,
          remainingSeconds: 900,
          phaseTotalSeconds: 1500,
          cadenceFocusMinutes: 25,
          cadenceBreakMinutes: 5,
          longBreakMinutes: 15,
          longBreakFrequency: 4,
          autoStartBreak: true,
          autoStartFocus: false,
          planMode: 'continuous',
          blockIndex: 1,
          blockCount: 1,
          taskFocusedSecondsAtStart: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await database
          .into(database.calendarEventRecords)
          .insert(
            CalendarEventRecordsCompanion.insert(
              id: 'event-1',
              title: 'Event',
              scheduledAt: now,
              durationMinutes: 30,
              createdAt: now,
            ),
          );
      await database
          .into(database.syncLocalStateRecords)
          .insert(
            SyncLocalStateRecordsCompanion.insert(
              groupId: 'group-1',
              installationId: 'phone-1',
              protocolVersion: 1,
              logicalCounter: const Value(1),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.syncOutboxRecords)
          .insert(
            SyncOutboxRecordsCompanion.insert(
              operationId: 'local-operation-1',
              groupId: 'group-1',
              originDeviceId: 'phone-1',
              originCounter: 1,
              entityType: 'goal',
              entityId: 'goal-1',
              parentVersionJson: '{}',
              changedFieldsJson: '{}',
              operationKind: 'update',
              protocolVersion: 1,
              payloadSha256:
                  'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
              createdAt: now,
            ),
          );
      await database
          .into(database.syncAppliedOperationRecords)
          .insert(
            SyncAppliedOperationRecordsCompanion.insert(
              operationId: 'remote-operation-1',
              groupId: 'group-1',
              originDeviceId: 'phone-2',
              originCounter: 1,
              payloadSha256:
                  'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
              appliedAt: now,
            ),
          );
      await database
          .into(database.syncEntityVersionRecords)
          .insert(
            SyncEntityVersionRecordsCompanion.insert(
              groupId: 'group-1',
              entityType: 'goal',
              entityId: 'goal-1',
              fieldName: 'title',
              causalVersionJson: '{"phone-1":1}',
              operationId: 'local-operation-1',
              originDeviceId: 'phone-1',
              updatedAt: now,
            ),
          );
      await database
          .into(database.syncTombstoneRecords)
          .insert(
            SyncTombstoneRecordsCompanion.insert(
              groupId: 'group-1',
              entityType: 'task',
              entityId: 'deleted-task',
              causalVersionJson: '{"phone-1":1}',
              operationId: 'delete-operation-1',
              originDeviceId: 'phone-1',
              deletedAt: now,
            ),
          );
      await database
          .into(database.syncConflictRecords)
          .insert(
            SyncConflictRecordsCompanion.insert(
              id: 'conflict-1',
              groupId: 'group-1',
              entityType: 'goal',
              entityId: 'goal-1',
              fieldName: const Value('title'),
              candidatesJson: '[]',
              createdAt: now,
            ),
          );
      await database
          .into(database.syncAcknowledgementRecords)
          .insert(
            SyncAcknowledgementRecordsCompanion.insert(
              groupId: 'group-1',
              observerDeviceId: 'phone-1',
              originDeviceId: 'phone-2',
              acknowledgedCounter: 1,
              updatedAt: now,
            ),
          );

      for (final table in database.allTables) {
        expect(
          await _rowCount(database, table.actualTableName),
          greaterThan(0),
          reason: '${table.actualTableName} should be populated by the fixture',
        );
      }

      await database.clearAllUserData();

      for (final table in database.allTables) {
        expect(
          await _rowCount(database, table.actualTableName),
          0,
          reason: '${table.actualTableName} should be empty after reset',
        );
      }
      expect(
        await database.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
      final version = await database
          .customSelect('PRAGMA user_version')
          .getSingle();
      expect(
        version.read<int>('user_version'),
        MichiFocusDatabase.currentSchemaVersion,
      );
    },
  );
}

Future<int> _rowCount(MichiFocusDatabase database, String tableName) async {
  final row = await database
      .customSelect('SELECT COUNT(*) AS row_count FROM $tableName')
      .getSingle();
  return row.read<int>('row_count');
}
