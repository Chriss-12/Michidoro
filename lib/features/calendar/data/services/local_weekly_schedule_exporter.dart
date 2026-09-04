import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/state/native_file_manager.dart';
import 'package:pomodoro_app_v1/features/calendar/data/services/raw_weekly_schedule_pdf_renderer.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_document.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_file.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/weekly_schedule_exporter.dart';

class LocalWeeklyScheduleExporter implements WeeklyScheduleExporter {
  LocalWeeklyScheduleExporter({
    RawWeeklySchedulePdfRenderer renderer =
        const RawWeeklySchedulePdfRenderer(),
    DateTime Function()? clock,
    Directory? fallbackDirectory,
  }) : _renderer = renderer,
       _clock = clock ?? DateTime.now,
       _fallbackDirectory = fallbackDirectory;

  final RawWeeklySchedulePdfRenderer _renderer;
  final DateTime Function() _clock;
  final Directory? _fallbackDirectory;
  var _sequence = 0;

  @override
  Future<WeeklyScheduleExportFile?> export(
    WeeklyScheduleExportDocument document,
  ) async {
    final bytes = _renderer.render(document);
    final fileName = _fileName(document.weekStart);

    if (Platform.isAndroid) {
      final folder = await NativeFileManager.pickExportFolder();
      if (folder == null) return null;
      final saved = await NativeFileManager.saveFileToExternalFolder(
        folderUri: folder.uri,
        fileName: fileName,
        mimeType: 'application/pdf',
        bytes: bytes,
      );
      return WeeklyScheduleExportFile(
        displayPath: saved.displayPath,
        openReference: saved.openReference,
      );
    }

    final directory = await _resolveFallbackDirectory();
    if (!directory.existsSync()) directory.createSync(recursive: true);
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    final temporary = File('${file.path}.part');
    try {
      await temporary.writeAsBytes(bytes, flush: true);
      await temporary.rename(file.path);
    } on Object {
      if (temporary.existsSync()) await temporary.delete();
      rethrow;
    }
    return WeeklyScheduleExportFile(
      displayPath: file.path,
      openReference: file.path,
    );
  }

  @override
  Future<void> open(WeeklyScheduleExportFile file) =>
      NativeFileManager.openFile(
        path: file.openReference,
      );

  String _fileName(DateTime weekStart) {
    final date =
        '${weekStart.year.toString().padLeft(4, '0')}'
        '${weekStart.month.toString().padLeft(2, '0')}'
        '${weekStart.day.toString().padLeft(2, '0')}';
    final token = '${_clock().microsecondsSinceEpoch}-${_sequence++}';
    return 'michifocus-horario-semanal-$date-$token.pdf';
  }

  Future<Directory> _resolveFallbackDirectory() async {
    if (_fallbackDirectory != null) return _fallbackDirectory;
    return await getDownloadsDirectory() ?? getApplicationDocumentsDirectory();
  }
}
