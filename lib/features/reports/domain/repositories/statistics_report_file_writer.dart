import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_file.dart';

// The writer is an infrastructure port with a single deliberate operation.
// ignore: one_member_abstracts
abstract interface class StatisticsReportFileWriter {
  Future<StatisticsReportFile> write({
    required List<int> bytes,
    required StatisticsReportRequest request,
    required DateTime generatedAt,
    required String configuredDestination,
  });
}
