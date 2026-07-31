import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';

class GenerateStatisticsReport {
  const GenerateStatisticsReport({
    required StatisticsReportRepository repository,
    DateTime Function()? clock,
  }) : _repository = repository,
       _clock = clock ?? DateTime.now;

  final StatisticsReportRepository _repository;
  final DateTime Function() _clock;

  Future<StatisticsReportData> call(StatisticsReportRequest request) async {
    final range = request.resolve(_clock());
    final source = await _repository.loadSource(range);

    return StatisticsReportData(
      range: range,
      tasks: source.tasks,
      createdTasks: source.createdTasks,
      calendarDays: source.calendarDays,
      completedPomodoros: source.completedPomodoros,
      focusedSeconds: source.focusedSeconds,
      completionEvents: source.completionEvents,
      legacyUnknownCompletions: source.legacyUnknownCompletions,
      moodAverage: source.moodAverage,
      moodSampleCount: source.moodSampleCount,
      distractionMinutes: source.distractionMinutes,
    );
  }
}
