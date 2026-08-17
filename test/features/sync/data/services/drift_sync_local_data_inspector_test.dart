import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_local_data_inspector.dart';

void main() {
  test('reports an empty productivity database', () async {
    final database = MichiFocusDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final summary = await DriftSyncLocalDataInspector(database)();

    expect(summary.hasUserData, isFalse);
    expect(summary.totalRecords, 0);
  });

  test(
    'counts user-authored rows without treating runtime metadata as data',
    () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final now = DateTime(2026, 8, 14, 12);
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
      await database
          .into(database.taskRecords)
          .insert(
            TaskRecordsCompanion.insert(
              id: 'task-1',
              title: 'Task',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.reportingMetadataRecords)
          .insert(
            ReportingMetadataRecordsCompanion.insert(
              id: 'reporting',
              completionTrackingStartedAt: now,
            ),
          );

      final summary = await DriftSyncLocalDataInspector(database)();

      expect(summary.goals, 1);
      expect(summary.tasks, 1);
      expect(summary.totalRecords, 2);
      expect(summary.hasUserData, isTrue);
    },
  );
}
