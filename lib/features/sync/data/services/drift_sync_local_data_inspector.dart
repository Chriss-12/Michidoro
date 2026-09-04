import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_local_data_summary.dart';

class DriftSyncLocalDataInspector {
  const DriftSyncLocalDataInspector(this._database);

  final MichiFocusDatabase _database;

  Future<SyncLocalDataSummary> call() async {
    final row = await _database.customSelect('''
      SELECT
        (SELECT COUNT(*) FROM goals) AS goals_count,
        (SELECT COUNT(*) FROM tasks) AS tasks_count,
        (SELECT COUNT(*) FROM calendar_events) AS calendar_events_count,
        (SELECT COUNT(*) FROM pomodoro_sessions) AS focus_sessions_count,
        (SELECT COUNT(*) FROM task_completion_events) AS completion_events_count,
        (SELECT COUNT(*) FROM routines) AS routines_count,
        (SELECT COUNT(*) FROM routine_runs) AS routine_runs_count,
        (SELECT COUNT(*) FROM quick_notes) AS quick_notes_count
    ''').getSingle();

    return SyncLocalDataSummary(
      goals: row.read<int>('goals_count'),
      tasks: row.read<int>('tasks_count'),
      calendarEvents: row.read<int>('calendar_events_count'),
      focusSessions: row.read<int>('focus_sessions_count'),
      taskCompletionEvents: row.read<int>('completion_events_count'),
      routines: row.read<int>('routines_count'),
      routineRuns: row.read<int>('routine_runs_count'),
      quickNotes: row.read<int>('quick_notes_count'),
    );
  }
}
