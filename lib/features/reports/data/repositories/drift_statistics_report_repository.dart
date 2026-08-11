import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_source.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';

class DriftStatisticsReportRepository implements StatisticsReportRepository {
  const DriftStatisticsReportRepository(this._dao);

  final ReportsDao _dao;

  @override
  Future<StatisticsReportSource> loadSource(
    ResolvedStatisticsReportRange range,
  ) async {
    final buckets = _bucketsFor(range);
    final taskTotals = await Future.wait([
      _dao.countScheduledTasks(start: range.start, end: range.end),
      _dao.countCreatedTasks(start: range.start, end: range.end),
    ]);
    final bucketRanges = [
      for (final bucket in buckets)
        ReportRangeRecord(start: bucket.start, end: bucket.end),
    ];
    final scheduledBuckets = await _dao.countScheduledTaskBuckets(
      bucketRanges,
    );
    final sessionBuckets = await _dao.loadSessionBucketTotals(
      bucketRanges,
    );
    final sessionTotals = await _dao.loadSessionTotals(
      start: range.start,
      end: range.end,
    );
    final completionEvents = await _dao.countCompletionEvents(
      start: range.start,
      end: range.end,
    );
    final routineTotals = await _dao.loadRoutineTotals(
      start: range.start,
      end: range.end,
    );
    final hasRoutineData =
        routineTotals.scheduledRuns > 0 ||
        routineTotals.focusedSeconds > 0 ||
        routineTotals.moodSampleCount > 0;
    final routineBreakdown = routineTotals.scheduledRuns == 0
        ? const <ReportRoutineBreakdownRecord>[]
        : await _dao.loadRoutineBreakdown(
            start: range.start,
            end: range.end,
          );
    final plannedTasks = taskTotals[0];
    final createdTasks = taskTotals[1];

    return StatisticsReportSource(
      tasks: StatisticsTaskTotals(
        listed: plannedTasks.listed,
        inProgress: plannedTasks.inProgress,
        completed: plannedTasks.completed,
      ),
      createdTasks: StatisticsTaskTotals(
        listed: createdTasks.listed,
        inProgress: createdTasks.inProgress,
        completed: createdTasks.completed,
      ),
      calendarDays: [
        for (var index = 0; index < buckets.length; index++)
          StatisticsCalendarDay(
            day: buckets[index].start,
            completionRatio: _completionRatio(scheduledBuckets[index]),
            isEnded: !buckets[index].end.isAfter(range.generatedAt),
            totalTasks:
                scheduledBuckets[index].listed +
                scheduledBuckets[index].inProgress +
                scheduledBuckets[index].completed,
            completedPomodoros: sessionBuckets[index].completedPomodoros,
            focusedSeconds: sessionBuckets[index].focusedSeconds,
          ),
      ],
      completedPomodoros: sessionTotals.completedPomodoros,
      focusedSeconds: sessionTotals.focusedSeconds,
      completionEvents: completionEvents,
      legacyUnknownCompletions: plannedTasks.legacyUnknown,
      moodAverage: sessionTotals.moodAverage,
      moodSampleCount: sessionTotals.moodSampleCount,
      distractionMinutes: sessionTotals.distractionMinutes,
      routines: !hasRoutineData
          ? null
          : StatisticsRoutineMetrics(
              scheduledRuns: routineTotals.scheduledRuns,
              inProgressRuns: routineTotals.inProgressRuns,
              completedRuns: routineTotals.completedRuns,
              skippedRuns: routineTotals.skippedRuns,
              missedRuns: routineTotals.missedRuns,
              scheduledItems: routineTotals.scheduledItems,
              inProgressItems: routineTotals.inProgressItems,
              completedItems: routineTotals.completedItems,
              skippedItems: routineTotals.skippedItems,
              missedItems: routineTotals.missedItems,
              requiredItems: routineTotals.requiredItems,
              completedRequiredItems: routineTotals.completedRequiredItems,
              skippedOptionalItems: routineTotals.skippedOptionalItems,
              missedRequiredItems: routineTotals.missedRequiredItems,
              plannedFocusMinutes: routineTotals.plannedFocusMinutes,
              focusedSeconds: routineTotals.focusedSeconds,
              averageStartDelayMinutes: routineTotals.averageStartDelayMinutes,
              startDelaySampleCount: routineTotals.startDelaySampleCount,
              moodAverage: routineTotals.moodAverage,
              moodSampleCount: routineTotals.moodSampleCount,
              typicalAbandonmentItem: routineTotals.typicalAbandonmentItem,
              typicalAbandonmentCount: routineTotals.typicalAbandonmentCount,
              longestCompletedStreak: routineTotals.longestCompletedStreak,
              byRoutine: [
                for (final routine in routineBreakdown)
                  StatisticsRoutineBreakdown(
                    sourceRoutineId: routine.sourceRoutineId,
                    name: routine.name,
                    scheduledRuns: routine.scheduledRuns,
                    completedRuns: routine.completedRuns,
                    requiredItems: routine.requiredItems,
                    completedRequiredItems: routine.completedRequiredItems,
                  ),
              ],
            ),
    );
  }

  double _completionRatio(ReportTaskCountsRecord counts) {
    final total = counts.listed + counts.inProgress + counts.completed;
    return total == 0 ? 0 : counts.completed / total;
  }

  List<_ReportBucket> _bucketsFor(ResolvedStatisticsReportRange range) {
    return switch (range.period) {
      StatisticsReportPeriod.day => _fixedBuckets(
        start: range.start,
        end: range.end,
        advance: _nextHour,
      ),
      StatisticsReportPeriod.week ||
      StatisticsReportPeriod.month => _fixedBuckets(
        start: range.start,
        end: range.end,
        advance: _nextDay,
      ),
      StatisticsReportPeriod.year => _monthlyBuckets(range.start, range.end),
      StatisticsReportPeriod.range => _customBuckets(range.start, range.end),
    };
  }

  List<_ReportBucket> _customBuckets(DateTime start, DateTime end) {
    final days = end.difference(start).inDays;
    if (days <= 31) {
      return _fixedBuckets(
        start: start,
        end: end,
        advance: _nextDay,
      );
    }
    if (days <= 366) {
      return _fixedBuckets(
        start: start,
        end: end,
        advance: _nextWeek,
      );
    }
    return _monthlyBuckets(start, end);
  }

  List<_ReportBucket> _fixedBuckets({
    required DateTime start,
    required DateTime end,
    required DateTime Function(DateTime) advance,
  }) {
    final buckets = <_ReportBucket>[];
    var cursor = start;
    while (cursor.isBefore(end)) {
      final candidate = advance(cursor);
      final bucketEnd = candidate.isAfter(end) ? end : candidate;
      buckets.add(_ReportBucket(start: cursor, end: bucketEnd));
      cursor = bucketEnd;
    }
    return buckets;
  }

  List<_ReportBucket> _monthlyBuckets(DateTime start, DateTime end) {
    final buckets = <_ReportBucket>[];
    var cursor = start;
    var monthOffset = 1;
    while (cursor.isBefore(end)) {
      final candidate = _addMonthsClamped(start, monthOffset);
      final bucketEnd = candidate.isAfter(end) ? end : candidate;
      buckets.add(_ReportBucket(start: cursor, end: bucketEnd));
      cursor = bucketEnd;
      monthOffset += 1;
    }
    return buckets;
  }

  DateTime _addMonthsClamped(DateTime date, int months) {
    final firstOfTarget = DateTime(date.year, date.month + months);
    final targetYear = firstOfTarget.year;
    final targetMonth = firstOfTarget.month;
    final lastDay = DateTime(targetYear, targetMonth + 1, 0).day;
    return DateTime(
      targetYear,
      targetMonth,
      date.day.clamp(1, lastDay),
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  DateTime _nextHour(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour + 1,
    );
  }

  DateTime _nextDay(DateTime date) {
    return DateTime(date.year, date.month, date.day + 1);
  }

  DateTime _nextWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day + 7);
  }
}

class _ReportBucket {
  const _ReportBucket({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}
