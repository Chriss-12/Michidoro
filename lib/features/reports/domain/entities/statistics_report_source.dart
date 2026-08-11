import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';

class StatisticsReportSource {
  const StatisticsReportSource({
    required this.tasks,
    required this.calendarDays,
    required this.completedPomodoros,
    required this.focusedSeconds,
    required this.completionEvents,
    required this.legacyUnknownCompletions,
    this.moodAverage,
    this.moodSampleCount = 0,
    this.distractionMinutes = 0,
    this.createdTasks = const StatisticsTaskTotals(
      listed: 0,
      inProgress: 0,
      completed: 0,
    ),
    this.routines,
  });

  final StatisticsTaskTotals tasks;
  final StatisticsTaskTotals createdTasks;
  final List<StatisticsCalendarDay> calendarDays;
  final int completedPomodoros;
  final int focusedSeconds;
  final int completionEvents;
  final int legacyUnknownCompletions;
  final double? moodAverage;
  final int moodSampleCount;
  final int distractionMinutes;
  final StatisticsRoutineMetrics? routines;
}
