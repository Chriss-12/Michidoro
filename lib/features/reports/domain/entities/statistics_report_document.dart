import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

class StatisticsReportDocument {
  const StatisticsReportDocument({
    required this.title,
    required this.profileName,
    required this.profileEmail,
    required this.periodLabel,
    required this.enabledCharts,
    required this.data,
    this.language = AppLanguage.spanish,
  });

  final String title;
  final String profileName;
  final String profileEmail;
  final String periodLabel;
  final Set<StatisticsChartType> enabledCharts;
  final StatisticsReportData data;
  final AppLanguage language;
}
