import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/state/native_file_manager.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_file.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_file_writer.dart';

class LocalStatisticsReportFileWriter implements StatisticsReportFileWriter {
  LocalStatisticsReportFileWriter({
    Directory? documentsDirectory,
    DateTime Function()? clock,
  }) : _documentsDirectory = documentsDirectory,
       _clock = clock ?? DateTime.now;

  final Directory? _documentsDirectory;
  final DateTime Function() _clock;
  var _sequence = 0;

  @override
  Future<StatisticsReportFile> write({
    required List<int> bytes,
    required StatisticsReportRequest request,
    required DateTime generatedAt,
    required String configuredDestination,
  }) async {
    final fileName = _fileName(request, generatedAt);
    final destination = configuredDestination.trim();

    if (NativeFileManager.isExternalFolderReference(destination)) {
      final savedFile = await NativeFileManager.saveFileToExternalFolder(
        folderUri: destination,
        fileName: fileName,
        mimeType: 'application/pdf',
        bytes: bytes,
      );
      return StatisticsReportFile(
        displayPath: savedFile.displayPath,
        openReference: savedFile.openReference,
      );
    }

    final directory = await _resolveDirectory(destination);
    final file = File('${directory.path}/$fileName');
    final temporary = File('${file.path}.part');
    try {
      await temporary.writeAsBytes(bytes, flush: true);
      await temporary.rename(file.path);
    } on Object {
      if (temporary.existsSync()) {
        await temporary.delete();
      }
      rethrow;
    }
    return StatisticsReportFile(
      displayPath: file.path,
      openReference: file.path,
    );
  }

  String _fileName(
    StatisticsReportRequest request,
    DateTime generatedAt,
  ) {
    final date =
        '${generatedAt.year.toString().padLeft(4, '0')}'
        '${generatedAt.month.toString().padLeft(2, '0')}'
        '${generatedAt.day.toString().padLeft(2, '0')}';
    final time =
        '${generatedAt.hour.toString().padLeft(2, '0')}'
        '${generatedAt.minute.toString().padLeft(2, '0')}'
        '${generatedAt.second.toString().padLeft(2, '0')}';
    final collisionToken = '${_clock().microsecondsSinceEpoch}-${_sequence++}';

    return 'michifocus-${request.period.name}-$date-$time-$collisionToken.pdf';
  }

  Future<Directory> _resolveDirectory(String configuredDestination) async {
    if (configuredDestination.isNotEmpty) {
      final configuredDirectory = Directory(configuredDestination);
      if (!configuredDirectory.existsSync()) {
        configuredDirectory.createSync(recursive: true);
      }
      return configuredDirectory;
    }

    final directory = await _defaultDirectory();
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  Future<Directory> _defaultDirectory() async {
    final downloadsDirectory = await getDownloadsDirectory();
    if (downloadsDirectory != null) {
      return downloadsDirectory;
    }
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    }

    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile != null && userProfile.trim().isNotEmpty) {
      return Directory('$userProfile\\Downloads');
    }

    final home = Platform.environment['HOME'];
    if (home != null && home.trim().isNotEmpty) {
      return Directory('$home/Downloads');
    }

    return _documentsDirectory ?? getApplicationDocumentsDirectory();
  }
}
