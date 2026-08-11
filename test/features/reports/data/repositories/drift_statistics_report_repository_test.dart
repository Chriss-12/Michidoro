import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/reports/data/repositories/drift_statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/data/services/raw_statistics_pdf_renderer.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_document.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';

void main() {
  test('loads only task and session rows inside the half-open range', () async {
    final database = MichiFocusDatabase(NativeDatabase.memory());
    final repository = DriftStatisticsReportRepository(ReportsDao(database));
    final generatedAt = DateTime(2026, 7, 21, 10);
    final range = const StatisticsReportRequest(
      period: StatisticsReportPeriod.day,
    ).resolve(generatedAt);

    addTearDown(database.close);

    await _insertTask(
      database,
      id: 'before',
      status: 'completed',
      scheduledDate: range.start.subtract(const Duration(days: 1)),
    );
    await _insertTask(
      database,
      id: 'inside',
      status: 'in_progress',
      scheduledDate: range.start,
    );
    await _insertTask(
      database,
      id: 'at-end',
      status: 'completed',
      scheduledDate: range.end,
    );
    await _insertSession(
      database,
      id: 'inside',
      endedAt: range.end.subtract(const Duration(seconds: 1)),
      focusedSeconds: 1200,
    );
    await _insertSession(
      database,
      id: 'at-end',
      endedAt: range.end,
      focusedSeconds: 1800,
    );

    final source = await repository.loadSource(range);

    expect(source.tasks.total, 1);
    expect(source.createdTasks.total, 1);
    expect(source.tasks.inProgress, 1);
    expect(source.completedPomodoros, 1);
    expect(source.focusedSeconds, 1200);
    expect(source.calendarDays, hasLength(24));
    expect(
      source.calendarDays.fold<int>(
        0,
        (total, bucket) => total + bucket.totalTasks,
      ),
      1,
    );
    expect(
      source.calendarDays.fold<int>(
        0,
        (total, bucket) => total + bucket.completedPomodoros,
      ),
      source.completedPomodoros,
    );
    expect(
      source.calendarDays.fold<int>(
        0,
        (total, bucket) => total + bucket.focusedSeconds,
      ),
      source.focusedSeconds,
    );
  });

  test(
    'large fixture uses indexes and stays within report p95 budget',
    () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      addTearDown(database.close);

      await database.customStatement('''
      WITH RECURSIVE sequence(value) AS (
        SELECT 1
        UNION ALL
        SELECT value + 1 FROM sequence WHERE value < 20000
      )
      INSERT INTO tasks (
        id,
        title,
        is_completed,
        status,
        legacy_completion_unknown,
        scheduled_date,
        created_at,
        updated_at
      )
      SELECT
        'task-' || value,
        'Task ' || value,
        value % 2,
        CASE WHEN value % 2 = 0 THEN 'completed' ELSE 'listed' END,
        0,
        1609459200 + (value % 157680000),
        1609459200 + (value % 157680000),
        1609459200 + (value % 157680000)
      FROM sequence
    ''');
      await database.customStatement('''
      WITH RECURSIVE sequence(value) AS (
        SELECT 1
        UNION ALL
        SELECT value + 1 FROM sequence WHERE value < 20000
      )
      INSERT INTO routine_runs (
        id,
        source_routine_id,
        local_date,
        status,
        name_snapshot,
        icon_key_snapshot,
        color_key_snapshot,
        scheduled_start_minute_snapshot,
        created_at,
        updated_at
      )
      SELECT
        'run-' || value,
        'routine-' || ((value - 1) % 100),
        date('2022-01-01', '+' || ((value - 1) / 100) || ' days'),
        'scheduled',
        'Routine ' || ((value - 1) % 100),
        'sun',
        'primary',
        540,
        1640995200 + (((value - 1) / 100) * 86400),
        1640995200 + (((value - 1) / 100) * 86400)
      FROM sequence
    ''');
      await database.customStatement('''
      WITH RECURSIVE sequence(value) AS (
        SELECT 1
        UNION ALL
        SELECT value + 1 FROM sequence WHERE value < 20000
      )
      INSERT INTO routine_item_runs (
        id,
        routine_run_id,
        source_item_id,
        position_snapshot,
        title_snapshot,
        scheduled_at_snapshot,
        duration_minutes_snapshot,
        pomodoro_mode_snapshot,
        status,
        created_at,
        updated_at
      )
      SELECT
        'run-item-' || value,
        'run-' || value,
        'source-item-' || value,
        0,
        'Activity ' || value,
        1640995200 + (((value - 1) / 100) * 86400) + 32400,
        25,
        'recommended',
        'scheduled',
        1640995200 + (((value - 1) / 100) * 86400),
        1640995200 + (((value - 1) / 100) * 86400)
      FROM sequence
    ''');
      await database.customStatement('''
      WITH RECURSIVE sequence(value) AS (
        SELECT 1
        UNION ALL
        SELECT value + 1 FROM sequence WHERE value < 50000
      )
      INSERT INTO pomodoro_sessions (
        id,
        started_at,
        ended_at,
        planned_seconds,
        focused_seconds,
        status,
        created_at
      )
      SELECT
        'session-' || value,
        1609459200 + (value % 157680000) - 1500,
        1609459200 + (value % 157680000),
        1500,
        1200,
        'completed',
        1609459200 + (value % 157680000)
      FROM sequence
    ''');

      final taskPlan = await database
          .customSelect(
            '''
      EXPLAIN QUERY PLAN
      SELECT count(*) FROM tasks
      WHERE scheduled_date >= ? AND scheduled_date < ?
      ''',
            variables: [
              Variable.withDateTime(DateTime(2022)),
              Variable.withDateTime(DateTime(2023)),
            ],
          )
          .get();
      final createdPlan = await database
          .customSelect(
            '''
      EXPLAIN QUERY PLAN
      SELECT count(*) FROM tasks
      WHERE created_at >= ? AND created_at < ?
      ''',
            variables: [
              Variable.withDateTime(DateTime(2022)),
              Variable.withDateTime(DateTime(2023)),
            ],
          )
          .get();
      final sessionPlan = await database
          .customSelect(
            '''
      EXPLAIN QUERY PLAN
      SELECT count(*), sum(focused_seconds) FROM pomodoro_sessions
      WHERE ended_at >= ? AND ended_at < ?
      ''',
            variables: [
              Variable.withDateTime(DateTime(2022)),
              Variable.withDateTime(DateTime(2023)),
            ],
          )
          .get();
      final routinePlan = await database
          .customSelect(
            '''
      EXPLAIN QUERY PLAN
      SELECT count(*) FROM routine_runs
      WHERE local_date >= ? AND local_date < ?
      ''',
            variables: [
              Variable.withString('2022-01-01'),
              Variable.withString('2023-01-01'),
            ],
          )
          .get();

      expect(
        _planDetails(taskPlan),
        contains('tasks_scheduled_date_idx'),
      );
      expect(
        _planDetails(createdPlan),
        contains('tasks_created_at_idx'),
      );
      expect(
        _planDetails(sessionPlan),
        contains('pomodoro_sessions_ended_at_idx'),
      );
      expect(
        _planDetails(routinePlan),
        contains('routine_runs_date_status_idx'),
      );

      final repository = DriftStatisticsReportRepository(ReportsDao(database));
      final range = const StatisticsReportRequest(
        period: StatisticsReportPeriod.year,
      ).resolve(DateTime(2022, 12, 31, 23));
      await repository.loadSource(range);
      final durations = <int>[];
      for (var run = 0; run < 10; run++) {
        final stopwatch = Stopwatch()..start();
        final source = await repository.loadSource(range);
        stopwatch.stop();
        durations.add(stopwatch.elapsedMilliseconds);
        expect(source.routines?.scheduledRuns, 20000);
        expect(source.routines?.byRoutine, hasLength(100));
      }
      durations.sort();
      final p95Milliseconds = durations[9];
      expect(
        p95Milliseconds,
        lessThanOrEqualTo(1000),
        reason: 'Measured durations: $durations ms',
      );
    },
  );

  test('empty ranges keep every bounded period bucket', () async {
    final database = MichiFocusDatabase(NativeDatabase.memory());
    final repository = DriftStatisticsReportRepository(ReportsDao(database));
    final now = DateTime(2026, 7, 21, 10);
    addTearDown(database.close);

    final cases = <StatisticsReportRequest, int>{
      const StatisticsReportRequest(period: StatisticsReportPeriod.day): 24,
      const StatisticsReportRequest(period: StatisticsReportPeriod.week): 7,
      const StatisticsReportRequest(period: StatisticsReportPeriod.month): 31,
      const StatisticsReportRequest(period: StatisticsReportPeriod.year): 12,
      StatisticsReportRequest(
        period: StatisticsReportPeriod.range,
        from: DateTime(2026),
        to: DateTime(2026, 12, 31),
      ): 53,
      StatisticsReportRequest(
        period: StatisticsReportPeriod.range,
        from: DateTime(2022),
        to: DateTime(2026, 12, 31),
      ): 60,
      StatisticsReportRequest(
        period: StatisticsReportPeriod.range,
        from: DateTime(2022, 1, 31),
        to: DateTime(2027, 1, 30),
      ): 60,
    };

    for (final entry in cases.entries) {
      final source = await repository.loadSource(entry.key.resolve(now));
      expect(
        source.calendarDays,
        hasLength(entry.value),
        reason: entry.key.period.name,
      );
      expect(source.tasks.total, 0);
      expect(
        source.calendarDays.every((bucket) => bucket.totalTasks == 0),
        isTrue,
      );
    }
  });

  test('production use case generates exact SQLite metrics and PDF', () async {
    final database = MichiFocusDatabase(NativeDatabase.memory());
    final repository = DriftStatisticsReportRepository(ReportsDao(database));
    final generatedAt = DateTime(2026, 7, 21, 20);
    final useCase = GenerateStatisticsReport(
      repository: repository,
      clock: () => generatedAt,
    );
    const request = StatisticsReportRequest(
      period: StatisticsReportPeriod.day,
    );
    addTearDown(database.close);

    await _insertTask(
      database,
      id: 'planned',
      status: 'completed',
      scheduledDate: DateTime(2026, 7, 21, 9),
    );
    await _insertSession(
      database,
      id: 'focused',
      endedAt: DateTime(2026, 7, 21, 10),
      focusedSeconds: 1350,
      taskId: 'planned',
      startMoodScore: 3,
      endMoodScore: 5,
      wasDistracted: true,
      distractionMinutes: 7,
    );
    await _insertSession(
      database,
      id: 'mood-fallback',
      endedAt: DateTime(2026, 7, 21, 11),
      focusedSeconds: 150,
      taskId: 'planned',
      startMoodScore: 3,
      wasDistracted: false,
      distractionMinutes: 99,
    );
    await database
        .into(database.taskCompletionEventRecords)
        .insert(
          TaskCompletionEventRecordsCompanion.insert(
            id: 'completion-planned',
            taskId: const Value('planned'),
            taskIdSnapshot: 'planned',
            completedAt: DateTime(2026, 7, 21, 9, 30),
          ),
        );

    final snapshot = await useCase(request);
    final pdf = const RawStatisticsPdfRenderer().render(
      StatisticsReportDocument(
        title: 'Reporte de rendimiento MichiFocus',
        profileName: 'Ana',
        profileEmail: 'ana@example.com',
        periodLabel: request.label,
        enabledCharts: {...StatisticsChartType.values},
        data: snapshot,
      ),
    );

    expect(snapshot.tasks.completed, 1);
    expect(snapshot.createdTasks.completed, 1);
    expect(snapshot.completedPomodoros, 2);
    expect(snapshot.focusedSeconds, 1500);
    expect(snapshot.completionEvents, 1);
    expect(snapshot.moodAverage, 5);
    expect(snapshot.moodSampleCount, 1);
    expect(snapshot.distractionMinutes, 7);
    expect(
      snapshot.calendarDays.fold<int>(
        0,
        (total, bucket) => total + bucket.totalTasks,
      ),
      snapshot.tasks.total,
    );
    expect(latin1.decode(pdf), startsWith('%PDF-1.4'));
    expect(latin1.decode(pdf), endsWith('%%EOF'));
  });

  test(
    'mood average uses valid final scores from completed task blocks',
    () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final day = DateTime(2026, 8, 4);
      await _insertTask(
        database,
        id: 'task-mood',
        status: 'in_progress',
        scheduledDate: day,
      );
      await _insertSession(
        database,
        id: 'valid-3',
        endedAt: day.add(const Duration(hours: 9)),
        focusedSeconds: 1500,
        taskId: 'task-mood',
        startMoodScore: 1,
        endMoodScore: 3,
      );
      await _insertSession(
        database,
        id: 'valid-5',
        endedAt: day.add(const Duration(hours: 10)),
        focusedSeconds: 1500,
        taskId: 'task-mood',
        endMoodScore: 5,
      );
      await _insertSession(
        database,
        id: 'partial',
        endedAt: day.add(const Duration(hours: 11)),
        focusedSeconds: 300,
        taskId: 'task-mood',
        endMoodScore: 1,
        status: 'partial',
      );
      await _insertSession(
        database,
        id: 'free',
        endedAt: day.add(const Duration(hours: 12)),
        focusedSeconds: 1500,
        endMoodScore: 1,
      );
      await _insertSession(
        database,
        id: 'invalid',
        endedAt: day.add(const Duration(hours: 13)),
        focusedSeconds: 1500,
        taskId: 'task-mood',
        endMoodScore: 9,
      );

      final totals = await ReportsDao(database).loadSessionTotals(
        start: day,
        end: day.add(const Duration(days: 1)),
      );

      expect(totals.moodAverage, 4);
      expect(totals.moodSampleCount, 2);
    },
  );

  test(
    'routine metrics use bounded runs, linked sessions and honest denominators',
    () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftStatisticsReportRepository(ReportsDao(database));
      final day = DateTime(2026, 8, 3);
      addTearDown(database.close);

      await _insertTask(
        database,
        id: 'routine-task',
        status: 'completed',
        scheduledDate: day,
      );
      await _insertRoutineRun(
        database,
        id: 'run-completed',
        day: day,
        status: 'completed',
        completedAt: day.add(const Duration(hours: 10)),
      );
      await _insertRoutineItemRun(
        database,
        id: 'item-completed',
        runId: 'run-completed',
        title: 'Deep work',
        scheduledAt: day.add(const Duration(hours: 9)),
        durationMinutes: 30,
        status: 'completed',
        taskId: 'routine-task',
        startedAt: day.add(const Duration(hours: 9, minutes: 10)),
        completedAt: day.add(const Duration(hours: 10)),
      );
      await _insertSession(
        database,
        id: 'routine-focus',
        endedAt: day.add(const Duration(hours: 10)),
        focusedSeconds: 1200,
        taskId: 'routine-task',
        endMoodScore: 4,
      );
      await _insertSession(
        database,
        id: 'routine-partial',
        endedAt: day.add(const Duration(hours: 10, minutes: 30)),
        focusedSeconds: 300,
        taskId: 'routine-task',
        endMoodScore: 1,
        status: 'partial',
      );

      final missedDay = day.add(const Duration(days: 1));
      await _insertRoutineRun(
        database,
        id: 'run-missed',
        day: missedDay,
        status: 'missed',
      );
      await _insertRoutineItemRun(
        database,
        id: 'item-missed',
        runId: 'run-missed',
        title: 'Missed activity',
        scheduledAt: missedDay.add(const Duration(hours: 9)),
        durationMinutes: 25,
        status: 'missed',
      );

      final skippedDay = day.add(const Duration(days: 2));
      await _insertRoutineRun(
        database,
        id: 'run-skipped',
        day: skippedDay,
        status: 'skipped',
        skippedAt: skippedDay.add(const Duration(hours: 8)),
      );
      await _insertRoutineItemRun(
        database,
        id: 'item-required-skipped',
        runId: 'run-skipped',
        title: 'Required skipped',
        scheduledAt: skippedDay.add(const Duration(hours: 9)),
        durationMinutes: 20,
        status: 'skipped',
        skippedAt: skippedDay.add(const Duration(hours: 8)),
      );
      await _insertRoutineItemRun(
        database,
        id: 'item-optional-skipped',
        runId: 'run-skipped',
        title: 'Optional skipped',
        scheduledAt: skippedDay.add(const Duration(hours: 10)),
        durationMinutes: 10,
        status: 'skipped',
        isOptional: true,
        skippedAt: skippedDay.add(const Duration(hours: 8)),
      );

      final source = await repository.loadSource(
        StatisticsReportRequest(
          period: StatisticsReportPeriod.range,
          from: day,
          to: skippedDay,
        ).resolve(day.add(const Duration(days: 4))),
      );
      final routines = source.routines!;

      expect(routines.scheduledRuns, 3);
      expect(routines.completedRuns, 1);
      expect(routines.skippedRuns, 1);
      expect(routines.missedRuns, 1);
      expect(routines.scheduledItems, 0);
      expect(routines.inProgressItems, 0);
      expect(routines.completedItems, 1);
      expect(routines.skippedItems, 2);
      expect(routines.missedItems, 1);
      expect(routines.requiredItems, 3);
      expect(routines.completedRequiredItems, 1);
      expect(routines.consistency, closeTo(1 / 3, 0.0001));
      expect(routines.skippedOptionalItems, 1);
      expect(routines.missedRequiredItems, 1);
      expect(routines.plannedFocusMinutes, 85);
      expect(routines.focusedSeconds, 1200);
      expect(routines.averageStartDelayMinutes, closeTo(10, 0.01));
      expect(routines.startDelaySampleCount, 1);
      expect(routines.moodAverage, 4);
      expect(routines.moodSampleCount, 1);
      expect(routines.typicalAbandonmentItem, 'Missed activity');
      expect(routines.typicalAbandonmentCount, 1);
      expect(routines.longestCompletedStreak, 1);
      expect(routines.byRoutine.single.name, 'Morning routine');
    },
  );

  test('optional-only routines expose unavailable consistency', () async {
    final database = MichiFocusDatabase(NativeDatabase.memory());
    final repository = DriftStatisticsReportRepository(ReportsDao(database));
    final day = DateTime(2026, 8, 7);
    addTearDown(database.close);

    await _insertRoutineRun(
      database,
      id: 'optional-run',
      day: day,
      status: 'scheduled',
    );
    await _insertRoutineItemRun(
      database,
      id: 'optional-item',
      runId: 'optional-run',
      title: 'Optional walk',
      scheduledAt: day.add(const Duration(hours: 9)),
      durationMinutes: 20,
      status: 'scheduled',
      isOptional: true,
    );

    final source = await repository.loadSource(
      const StatisticsReportRequest(
        period: StatisticsReportPeriod.day,
      ).resolve(day),
    );

    expect(source.routines, isA<StatisticsRoutineMetrics>());
    expect(source.routines!.requiredItems, 0);
    expect(source.routines!.scheduledItems, 1);
    expect(source.routines!.consistency, null);
  });

  test('routine focus is attributed by session end across midnight', () async {
    final database = MichiFocusDatabase(NativeDatabase.memory());
    final repository = DriftStatisticsReportRepository(ReportsDao(database));
    final previousDay = DateTime(2026, 12, 31);
    final reportDay = DateTime(2027);
    addTearDown(database.close);

    await _insertTask(
      database,
      id: 'crossing-task',
      status: 'completed',
      scheduledDate: previousDay,
    );
    await _insertRoutineRun(
      database,
      id: 'crossing-run',
      day: previousDay,
      status: 'completed',
      completedAt: reportDay.add(const Duration(minutes: 10)),
    );
    await _insertRoutineItemRun(
      database,
      id: 'crossing-item',
      runId: 'crossing-run',
      title: 'Year boundary focus',
      scheduledAt: previousDay.add(const Duration(hours: 23, minutes: 45)),
      durationMinutes: 25,
      status: 'completed',
      taskId: 'crossing-task',
      completedAt: reportDay.add(const Duration(minutes: 10)),
    );
    await _insertSession(
      database,
      id: 'crossing-session',
      endedAt: reportDay.add(const Duration(minutes: 10)),
      focusedSeconds: 600,
      taskId: 'crossing-task',
      endMoodScore: 5,
    );

    final source = await repository.loadSource(
      const StatisticsReportRequest(
        period: StatisticsReportPeriod.day,
      ).resolve(reportDay),
    );

    expect(source.routines, isA<StatisticsRoutineMetrics>());
    expect(source.routines!.scheduledRuns, 0);
    expect(source.routines!.focusedSeconds, 600);
    expect(source.routines!.moodAverage, 5);
    expect(source.routines!.consistency, null);
  });

  test(
    'routine streak follows scheduled occurrences instead of calendar days',
    () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftStatisticsReportRepository(ReportsDao(database));
      final firstMonday = DateTime(2026, 8, 3);
      addTearDown(database.close);

      await _insertRoutineRun(
        database,
        id: 'weekly-1',
        day: firstMonday,
        status: 'completed',
        completedAt: firstMonday.add(const Duration(hours: 10)),
        sourceRoutineId: 'weekly-routine',
      );
      await _insertRoutineRun(
        database,
        id: 'weekly-2',
        day: firstMonday.add(const Duration(days: 7)),
        status: 'completed',
        completedAt: firstMonday.add(const Duration(days: 7, hours: 10)),
        sourceRoutineId: 'weekly-routine',
      );
      await _insertRoutineRun(
        database,
        id: 'weekly-3',
        day: firstMonday.add(const Duration(days: 14)),
        status: 'missed',
        sourceRoutineId: 'weekly-routine',
      );
      await _insertRoutineRun(
        database,
        id: 'weekly-4',
        day: firstMonday.add(const Duration(days: 21)),
        status: 'completed',
        completedAt: firstMonday.add(const Duration(days: 21, hours: 10)),
        sourceRoutineId: 'weekly-routine',
      );

      final source = await repository.loadSource(
        StatisticsReportRequest(
          period: StatisticsReportPeriod.range,
          from: firstMonday,
          to: firstMonday.add(const Duration(days: 21)),
        ).resolve(firstMonday.add(const Duration(days: 22))),
      );

      expect(source.routines?.longestCompletedStreak, 2);
    },
  );
}

String _planDetails(List<QueryRow> rows) {
  return rows.map((row) => row.read<String>('detail')).join('\n');
}

Future<void> _insertTask(
  MichiFocusDatabase database, {
  required String id,
  required String status,
  required DateTime scheduledDate,
}) async {
  await database
      .into(database.taskRecords)
      .insert(
        TaskRecordsCompanion.insert(
          id: id,
          title: id,
          status: Value(status),
          isCompleted: Value(status == 'completed'),
          scheduledDate: Value(scheduledDate),
          createdAt: scheduledDate,
          updatedAt: scheduledDate,
        ),
      );
}

Future<void> _insertSession(
  MichiFocusDatabase database, {
  required String id,
  required DateTime endedAt,
  required int focusedSeconds,
  String? taskId,
  int? startMoodScore,
  int? endMoodScore,
  bool? wasDistracted,
  int? distractionMinutes,
  String status = 'completed',
}) async {
  await database
      .into(database.pomodoroSessionRecords)
      .insert(
        PomodoroSessionRecordsCompanion.insert(
          id: id,
          startedAt: endedAt.subtract(const Duration(minutes: 25)),
          endedAt: endedAt,
          plannedSeconds: 1500,
          focusedSeconds: focusedSeconds,
          taskId: Value(taskId),
          startMoodScore: Value(startMoodScore),
          endMoodScore: Value(endMoodScore),
          wasDistracted: Value(wasDistracted),
          distractionMinutes: Value(distractionMinutes),
          status: status,
          createdAt: endedAt,
        ),
      );
}

Future<void> _insertRoutineRun(
  MichiFocusDatabase database, {
  required String id,
  required DateTime day,
  required String status,
  String sourceRoutineId = 'morning-routine',
  DateTime? completedAt,
  DateTime? skippedAt,
}) async {
  await database
      .into(database.routineRunRecords)
      .insert(
        RoutineRunRecordsCompanion.insert(
          id: id,
          sourceRoutineId: sourceRoutineId,
          localDate:
              '${day.year.toString().padLeft(4, '0')}-'
              '${day.month.toString().padLeft(2, '0')}-'
              '${day.day.toString().padLeft(2, '0')}',
          status: Value(status),
          nameSnapshot: sourceRoutineId == 'morning-routine'
              ? 'Morning routine'
              : 'Weekly routine',
          iconKeySnapshot: 'sun',
          colorKeySnapshot: 'primary',
          scheduledStartMinuteSnapshot: 9 * 60,
          completedAt: Value(completedAt),
          skippedAt: Value(skippedAt),
          createdAt: day,
          updatedAt: day,
        ),
      );
}

Future<void> _insertRoutineItemRun(
  MichiFocusDatabase database, {
  required String id,
  required String runId,
  required String title,
  required DateTime scheduledAt,
  required int durationMinutes,
  required String status,
  String? taskId,
  bool isOptional = false,
  DateTime? startedAt,
  DateTime? completedAt,
  DateTime? skippedAt,
}) async {
  await database
      .into(database.routineItemRunRecords)
      .insert(
        RoutineItemRunRecordsCompanion.insert(
          id: id,
          routineRunId: runId,
          sourceItemId: id,
          taskId: Value(taskId),
          taskIdSnapshot: Value(taskId),
          positionSnapshot: 0,
          titleSnapshot: title,
          scheduledAtSnapshot: scheduledAt,
          durationMinutesSnapshot: durationMinutes,
          isOptionalSnapshot: Value(isOptional),
          pomodoroModeSnapshot: 'recommended',
          status: Value(status),
          startedAt: Value(startedAt),
          completedAt: Value(completedAt),
          skippedAt: Value(skippedAt),
          createdAt: scheduledAt,
          updatedAt: scheduledAt,
        ),
      );
}
