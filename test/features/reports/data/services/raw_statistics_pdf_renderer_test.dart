import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/reports/data/services/raw_statistics_pdf_renderer.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_document.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

void main() {
  test('renders every bucket in a paginated, WinAnsi PDF', () {
    final start = DateTime(2026, 7);
    final generatedAt = DateTime(2026, 8, 30, 18, 45);
    final buckets = List.generate(60, (index) {
      final day = start.add(Duration(days: index));
      return StatisticsCalendarDay(
        day: day,
        completionRatio: index.isEven ? 0.5 : 1,
        isEnded: true,
        totalTasks: 2,
      );
    });
    final data = StatisticsReportData(
      range: ResolvedStatisticsReportRange(
        period: StatisticsReportPeriod.range,
        start: start,
        end: start.add(const Duration(days: 60)),
        generatedAt: generatedAt,
      ),
      tasks: const StatisticsTaskTotals(
        listed: 8,
        inProgress: 3,
        completed: 19,
      ),
      calendarDays: buckets,
      completedPomodoros: 24,
      focusedSeconds: 36000,
      completionEvents: 21,
      legacyUnknownCompletions: 2,
      routines: const StatisticsRoutineMetrics(
        scheduledRuns: 3,
        inProgressRuns: 0,
        completedRuns: 1,
        skippedRuns: 1,
        missedRuns: 1,
        scheduledItems: 0,
        inProgressItems: 0,
        completedItems: 1,
        skippedItems: 1,
        missedItems: 1,
        requiredItems: 3,
        completedRequiredItems: 1,
        skippedOptionalItems: 1,
        missedRequiredItems: 1,
        plannedFocusMinutes: 85,
        focusedSeconds: 1200,
        averageStartDelayMinutes: 10,
        startDelaySampleCount: 1,
        moodAverage: 4,
        moodSampleCount: 1,
        typicalAbandonmentItem: 'Lectura',
        typicalAbandonmentCount: 1,
        longestCompletedStreak: 2,
        byRoutine: [
          StatisticsRoutineBreakdown(
            sourceRoutineId: 'routine-1',
            name: 'Mañana',
            scheduledRuns: 3,
            completedRuns: 1,
            requiredItems: 3,
            completedRequiredItems: 1,
          ),
        ],
      ),
    );
    final profileName = 'María ${List.filled(114, 'Á').join()}';
    final profileEmail = '${List.filled(242, 'a').join()}@example.com';

    final bytes = const RawStatisticsPdfRenderer().render(
      StatisticsReportDocument(
        title: 'Reporte de rendimiento MichiFocus',
        profileName: profileName,
        profileEmail: profileEmail,
        periodLabel: 'Rango personalizado',
        enabledCharts: {...StatisticsChartType.values},
        data: data,
      ),
    );
    final pdf = latin1.decode(bytes);

    expect(pdf, startsWith('%PDF-1.4'));
    expect(pdf, endsWith('%%EOF'));
    expect(pdf, contains('/Encoding /WinAnsiEncoding'));
    expect(pdf, contains('/MediaBox [0 0 612 792]'));
    expect(RegExp('/Type /Page ').allMatches(pdf).length, greaterThan(1));
    expect(pdf, contains('2026-08-29'));
    expect(profileName.length, 120);
    expect(profileEmail.length, 254);
    expect(pdf, contains('María'));
    expect(pdf, isNot(contains('Ã')));
    expect(pdf, contains('Constancia de rutinas'));
    expect(pdf, contains('Foco planificado / real: 85 / 20 min'));
    expect(pdf, contains('Lectura'));
    expect(pdf, contains('Detalle por rutina'));
  });

  test('renders report copy in English', () {
    final generatedAt = DateTime(2026, 7, 29, 9);
    final data = StatisticsReportData(
      range: ResolvedStatisticsReportRange(
        period: StatisticsReportPeriod.day,
        start: DateTime(2026, 7, 29),
        end: DateTime(2026, 7, 30),
        generatedAt: generatedAt,
      ),
      tasks: const StatisticsTaskTotals(
        listed: 1,
        inProgress: 0,
        completed: 2,
      ),
      calendarDays: const [],
      completedPomodoros: 3,
      focusedSeconds: 4500,
      completionEvents: 2,
    );

    final bytes = const RawStatisticsPdfRenderer().render(
      StatisticsReportDocument(
        title: 'MichiFocus Performance Report',
        profileName: 'Chris',
        profileEmail: '',
        periodLabel: 'Day',
        enabledCharts: const {StatisticsChartType.circular},
        data: data,
        language: AppLanguage.english,
      ),
    );
    final pdf = latin1.decode(bytes);

    expect(pdf, contains('Current task progress'));
    expect(pdf, contains('Recommendation'));
    expect(pdf, contains('Page 1 of 1'));
    expect(pdf, isNot(contains('Recomendaci')));
    expect(pdf, isNot(contains('Routine consistency')));
  });

  test('does not fabricate zero consistency without required items', () {
    final generatedAt = DateTime(2026, 8, 9, 9);
    final data = StatisticsReportData(
      range: ResolvedStatisticsReportRange(
        period: StatisticsReportPeriod.day,
        start: DateTime(2026, 8, 9),
        end: DateTime(2026, 8, 10),
        generatedAt: generatedAt,
      ),
      tasks: const StatisticsTaskTotals(
        listed: 0,
        inProgress: 0,
        completed: 0,
      ),
      calendarDays: const [],
      completedPomodoros: 0,
      focusedSeconds: 0,
      routines: const StatisticsRoutineMetrics(
        scheduledRuns: 1,
        inProgressRuns: 0,
        completedRuns: 0,
        skippedRuns: 0,
        missedRuns: 0,
        scheduledItems: 1,
        inProgressItems: 0,
        completedItems: 0,
        skippedItems: 0,
        missedItems: 0,
        requiredItems: 0,
        completedRequiredItems: 0,
        skippedOptionalItems: 0,
        missedRequiredItems: 0,
        plannedFocusMinutes: 20,
        focusedSeconds: 0,
        longestCompletedStreak: 0,
        byRoutine: [],
      ),
    );

    final pdf = latin1.decode(
      const RawStatisticsPdfRenderer().render(
        StatisticsReportDocument(
          title: 'Reporte',
          profileName: 'Chris',
          profileEmail: '',
          periodLabel: 'Día',
          enabledCharts: const {},
          data: data,
        ),
      ),
    );

    expect(pdf, contains('Sin datos: el período no contiene'));
    expect(pdf, isNot(contains('0% · 0 de 0')));
  });
}
