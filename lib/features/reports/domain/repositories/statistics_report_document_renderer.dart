import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_document.dart';

// The renderer is an infrastructure port with a single deliberate operation.
// ignore: one_member_abstracts
abstract interface class StatisticsReportDocumentRenderer {
  List<int> render(StatisticsReportDocument document);
}
