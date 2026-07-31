import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_source.dart';

// The interface keeps persistence details outside report use cases.
// ignore: one_member_abstracts
abstract interface class StatisticsReportRepository {
  Future<StatisticsReportSource> loadSource(
    ResolvedStatisticsReportRange range,
  );
}
