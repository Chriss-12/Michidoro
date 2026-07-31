import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/reports/data/services/local_statistics_report_file_writer.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';

void main() {
  test(
    'one hundred writes of the same snapshot create distinct files',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'michifocus-report-writer-',
      );
      final writer = LocalStatisticsReportFileWriter(
        clock: () => DateTime(2026, 7, 21, 11),
      );
      const request = StatisticsReportRequest(
        period: StatisticsReportPeriod.year,
      );
      final generatedAt = DateTime(2026, 7, 21, 10, 30);

      addTearDown(() async {
        if (directory.existsSync()) {
          await directory.delete(recursive: true);
        }
      });

      final paths = <String>{};
      for (var index = 0; index < 100; index++) {
        final reportFile = await writer.write(
          bytes: const [1, 2, 3],
          request: request,
          generatedAt: generatedAt,
          configuredDestination: directory.path,
        );
        expect(reportFile.openReference, reportFile.displayPath);
        paths.add(reportFile.displayPath);
      }

      expect(paths, hasLength(100));
      expect(paths.every((path) => File(path).existsSync()), isTrue);
      expect(
        paths.every(
          (path) => path.contains('michifocus-year-20260721-103000-'),
        ),
        isTrue,
      );
    },
  );
}
