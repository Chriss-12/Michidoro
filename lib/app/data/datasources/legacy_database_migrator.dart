import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/calendar/data/datasources/calendar_events_database.dart'
    as legacy_calendar;
import 'package:pomodoro_app_v1/features/goals/data/datasources/goals_database.dart'
    as legacy_goals;
import 'package:pomodoro_app_v1/features/pomodoro/data/datasources/pomodoro_sessions_database.dart'
    as legacy_pomodoro;
import 'package:pomodoro_app_v1/features/tasks/data/datasources/tasks_database.dart'
    as legacy_tasks;

class LegacyDatabaseMigrator {
  static const _targetFileName = 'michifocus.sqlite';
  static const _legacyFileNames = [
    'michifocus_goals.sqlite',
    'michifocus_tasks.sqlite',
    'michifocus_pomodoro_sessions.sqlite',
    'michifocus_calendar_events.sqlite',
  ];

  static Future<void> migrateIfNeeded({Directory? directoryOverride}) async {
    final directory =
        directoryOverride ?? await getApplicationDocumentsDirectory();
    final target = File('${directory.path}/$_targetFileName');
    if (target.existsSync()) return;

    final legacyFiles = _legacyFileNames
        .map((name) => File('${directory.path}/$name'))
        .where((file) => file.existsSync())
        .toList(growable: false);
    if (legacyFiles.isEmpty) return;

    final backupDirectory = Directory(
      '${directory.path}/michifocus-legacy-backup',
    );
    if (!backupDirectory.existsSync()) {
      await backupDirectory.create(recursive: true);
      for (final source in legacyFiles) {
        await source.copy('${backupDirectory.path}/${_nameOf(source)}');
      }
    }

    final temporary = File('${target.path}.migrating');
    if (temporary.existsSync()) await temporary.delete();
    final database = MichiFocusDatabase(NativeDatabase(temporary));
    try {
      final goals = await _loadGoals(directory);
      final tasks = await _loadTasks(directory);
      final sessions = await _loadSessions(directory);
      final events = await _loadEvents(directory);
      final goalIds = goals.map((goal) => goal.id).toSet();
      final taskIds = tasks.map((task) => task.id).toSet();

      await database.transaction(() async {
        for (final goal in goals) {
          await database
              .into(database.goalRecords)
              .insert(
                GoalRecordsCompanion.insert(
                  id: goal.id,
                  title: goal.title,
                  targetSessions: goal.targetSessions,
                  completedSessions: Value(goal.completedSessions),
                  targetDate: Value(goal.targetDate),
                  createdAt: goal.createdAt,
                  updatedAt: goal.updatedAt,
                ),
              );
        }
        for (final task in tasks) {
          await database
              .into(database.taskRecords)
              .insert(
                TaskRecordsCompanion.insert(
                  id: task.id,
                  title: task.title,
                  isCompleted: Value(task.isCompleted),
                  status: Value(task.status),
                  legacyCompletionUnknown: Value(task.isCompleted),
                  scheduledDate: Value(task.scheduledDate),
                  goalId: Value(
                    goalIds.contains(task.goalId) ? task.goalId : null,
                  ),
                  durationMinutes: Value(task.durationMinutes),
                  createdAt: task.createdAt,
                  updatedAt: task.updatedAt,
                ),
              );
        }
        for (final session in sessions) {
          await database
              .into(database.pomodoroSessionRecords)
              .insert(
                PomodoroSessionRecordsCompanion.insert(
                  id: session.id,
                  startedAt: session.startedAt,
                  endedAt: session.endedAt,
                  plannedSeconds: session.plannedSeconds,
                  focusedSeconds: session.focusedSeconds,
                  goalId: Value(
                    goalIds.contains(session.goalId) ? session.goalId : null,
                  ),
                  taskId: Value(
                    taskIds.contains(session.taskId) ? session.taskId : null,
                  ),
                  startMoodScore: Value(session.startMoodScore),
                  endMoodScore: Value(session.endMoodScore),
                  wasDistracted: Value(session.wasDistracted),
                  distractionMinutes: Value(session.distractionMinutes),
                  status: session.status,
                  createdAt: session.createdAt,
                ),
              );
        }
        for (final event in events) {
          await database
              .into(database.calendarEventRecords)
              .insert(
                CalendarEventRecordsCompanion.insert(
                  id: event.id,
                  title: event.title,
                  scheduledAt: event.scheduledAt,
                  durationMinutes: event.durationMinutes,
                  createdAt: event.createdAt,
                ),
              );
        }
        await database
            .into(database.reportingMetadataRecords)
            .insertOnConflictUpdate(
              ReportingMetadataRecordsCompanion.insert(
                id: 'completion-history',
                completionTrackingStartedAt: DateTime.now(),
              ),
            );
      });
      await database.close();
      await temporary.rename(target.path);
    } catch (_) {
      await database.close();
      if (temporary.existsSync()) await temporary.delete();
      rethrow;
    }
  }

  static Future<List<legacy_goals.GoalRecord>> _loadGoals(
    Directory directory,
  ) async {
    final file = File('${directory.path}/michifocus_goals.sqlite');
    if (!file.existsSync()) return const [];
    final database = legacy_goals.GoalsDatabase(NativeDatabase(file));
    try {
      return await legacy_goals.GoalsDao(database).getAllGoals();
    } finally {
      await database.close();
    }
  }

  static Future<List<legacy_tasks.TaskRecord>> _loadTasks(
    Directory directory,
  ) async {
    final file = File('${directory.path}/michifocus_tasks.sqlite');
    if (!file.existsSync()) return const [];
    final database = legacy_tasks.TasksDatabase(NativeDatabase(file));
    try {
      return await legacy_tasks.TasksDao(database).getAllTasks();
    } finally {
      await database.close();
    }
  }

  static Future<List<legacy_pomodoro.PomodoroSessionRecord>> _loadSessions(
    Directory directory,
  ) async {
    final file = File('${directory.path}/michifocus_pomodoro_sessions.sqlite');
    if (!file.existsSync()) return const [];
    final database = legacy_pomodoro.PomodoroSessionsDatabase(
      NativeDatabase(file),
    );
    try {
      return await legacy_pomodoro.PomodoroSessionsDao(
        database,
      ).getAllSessions();
    } finally {
      await database.close();
    }
  }

  static Future<List<legacy_calendar.CalendarEventRecord>> _loadEvents(
    Directory directory,
  ) async {
    final file = File('${directory.path}/michifocus_calendar_events.sqlite');
    if (!file.existsSync()) return const [];
    final database = legacy_calendar.CalendarEventsDatabase(
      NativeDatabase(file),
    );
    try {
      return await legacy_calendar.CalendarEventsDao(database).getAllEvents();
    } finally {
      await database.close();
    }
  }

  static String _nameOf(File file) => file.uri.pathSegments.last;
}
