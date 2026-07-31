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

  test('large fixture range plans use timestamp indexes', () async {
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
  });

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
    expect(snapshot.moodAverage, 4);
    expect(snapshot.moodSampleCount, 2);
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
  int? startMoodScore,
  int? endMoodScore,
  bool? wasDistracted,
  int? distractionMinutes,
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
          startMoodScore: Value(startMoodScore),
          endMoodScore: Value(endMoodScore),
          wasDistracted: Value(wasDistracted),
          distractionMinutes: Value(distractionMinutes),
          status: 'completed',
          createdAt: endedAt,
        ),
      );
}
