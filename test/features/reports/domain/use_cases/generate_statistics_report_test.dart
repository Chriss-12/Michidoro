import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_source.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';

void main() {
  group('StatisticsReportRequest', () {
    final now = DateTime(2026, 7, 21, 10, 30);

    test('resolves standard periods as half-open local ranges', () {
      final day = const StatisticsReportRequest(
        period: StatisticsReportPeriod.day,
      ).resolve(now);
      final week = const StatisticsReportRequest(
        period: StatisticsReportPeriod.week,
      ).resolve(now);
      final month = const StatisticsReportRequest(
        period: StatisticsReportPeriod.month,
      ).resolve(now);
      final year = const StatisticsReportRequest(
        period: StatisticsReportPeriod.year,
      ).resolve(now);

      expect(day.start, DateTime(2026, 7, 21));
      expect(day.end, DateTime(2026, 7, 22));
      expect(day.contains(DateTime(2026, 7, 21, 23, 59)), isTrue);
      expect(day.contains(day.end), isFalse);
      expect(week.start, DateTime(2026, 7, 20));
      expect(week.end, DateTime(2026, 7, 27));
      expect(month.start, DateTime(2026, 7));
      expect(month.end, DateTime(2026, 8));
      expect(year.start, DateTime(2026));
      expect(year.end, DateTime(2027));
    });

    test('normalizes reversed custom dates and includes the final day', () {
      final range = StatisticsReportRequest(
        period: StatisticsReportPeriod.range,
        from: DateTime(2026, 7, 21),
        to: DateTime(2026, 7, 18),
      ).resolve(now);

      expect(range.start, DateTime(2026, 7, 18));
      expect(range.end, DateTime(2026, 7, 22));
      expect(range.label, '2026-07-18 a 2026-07-21');
    });

    test('rejects custom ranges longer than five years', () {
      expect(
        () => StatisticsReportRequest(
          period: StatisticsReportPeriod.range,
          from: DateTime(2020),
          to: DateTime(2026),
        ).resolve(now),
        throwsArgumentError,
      );
    });

    test('keeps leap-day and future ranges on local midnight boundaries', () {
      final leapDay = const StatisticsReportRequest(
        period: StatisticsReportPeriod.day,
      ).resolve(DateTime(2024, 2, 29, 23, 59));
      final future = StatisticsReportRequest(
        period: StatisticsReportPeriod.range,
        from: DateTime(2027, 1, 3, 18),
        to: DateTime(2027, 1, 4, 2),
      ).resolve(now);

      expect(leapDay.start, DateTime(2024, 2, 29));
      expect(leapDay.end, DateTime(2024, 3));
      expect(future.start, DateTime(2027, 1, 3));
      expect(future.end, DateTime(2027, 1, 5));
    });

    test('resolves standard periods around an explicit selected date', () {
      final month = StatisticsReportRequest(
        period: StatisticsReportPeriod.month,
        anchor: DateTime(2025, 11, 18),
      ).resolve(now);
      final year = StatisticsReportRequest(
        period: StatisticsReportPeriod.year,
        anchor: DateTime(2024, 6),
      ).resolve(now);

      expect(month.start, DateTime(2025, 11));
      expect(month.end, DateTime(2025, 12));
      expect(month.generatedAt, now);
      expect(year.start, DateTime(2024));
      expect(year.end, DateTime(2025));
      expect(year.generatedAt, now);
    });
  });

  test('builds one snapshot from the resolved repository range', () async {
    final repository = _MemoryStatisticsReportRepository(
      StatisticsReportSource(
        tasks: const StatisticsTaskTotals(
          listed: 1,
          inProgress: 1,
          completed: 1,
        ),
        createdTasks: const StatisticsTaskTotals(
          listed: 2,
          inProgress: 1,
          completed: 1,
        ),
        calendarDays: [
          StatisticsCalendarDay(
            day: _reportDay,
            completionRatio: 1 / 3,
            isEnded: false,
            totalTasks: 3,
          ),
        ],
        completedPomodoros: 3,
        focusedSeconds: 3700,
        completionEvents: 1,
        legacyUnknownCompletions: 0,
      ),
    );
    final useCase = GenerateStatisticsReport(
      repository: repository,
      clock: () => DateTime(2026, 7, 21, 10, 30),
    );

    final snapshot = await useCase(
      const StatisticsReportRequest(period: StatisticsReportPeriod.day),
    );

    expect(repository.requestedRange?.start, _reportDay);
    expect(repository.requestedRange?.end, DateTime(2026, 7, 22));
    expect(snapshot.tasks.listed, 1);
    expect(snapshot.tasks.inProgress, 1);
    expect(snapshot.tasks.completed, 1);
    expect(snapshot.createdTasks.total, 4);
    expect(snapshot.completedPomodoros, 3);
    expect(snapshot.focusedSeconds, 3700);
    expect(snapshot.calendarDays, hasLength(1));
    expect(snapshot.calendarDays.single.totalTasks, 3);
    expect(snapshot.completionEvents, 1);
  });
}

final _reportDay = DateTime(2026, 7, 21);

class _MemoryStatisticsReportRepository implements StatisticsReportRepository {
  _MemoryStatisticsReportRepository(this.source);

  final StatisticsReportSource source;
  ResolvedStatisticsReportRange? requestedRange;

  @override
  Future<StatisticsReportSource> loadSource(
    ResolvedStatisticsReportRange range,
  ) async {
    requestedRange = range;
    return source;
  }
}
