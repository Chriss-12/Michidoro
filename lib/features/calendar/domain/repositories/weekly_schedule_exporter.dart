import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_document.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_file.dart';

abstract interface class WeeklyScheduleExporter {
  Future<WeeklyScheduleExportFile?> export(
    WeeklyScheduleExportDocument document,
  );

  Future<void> open(WeeklyScheduleExportFile file);
}
