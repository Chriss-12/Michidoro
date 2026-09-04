import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/calendar/data/services/local_weekly_schedule_exporter.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_document.dart';

void main() {
  test(
    'saves unique PDF files without overwriting an earlier export',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'michi-weekly-export-',
      );
      addTearDown(() async {
        if (directory.existsSync()) {
          await directory.delete(recursive: true);
        }
      });
      final exporter = LocalWeeklyScheduleExporter(
        clock: () => DateTime(2026, 8, 27, 15),
        fallbackDirectory: directory,
      );
      final document = WeeklyScheduleExportDocument(
        weekStart: DateTime(2026, 8, 24),
        generatedAt: DateTime(2026, 8, 27),
        isEnglish: false,
        activities: const [],
        goals: const [],
      );

      final first = await exporter.export(document);
      final second = await exporter.export(document);

      expect(first, isNotNull);
      expect(second, isNotNull);
      expect(first!.displayPath, isNot(second!.displayPath));
      expect(File(first.displayPath).existsSync(), isTrue);
      expect(File(second.displayPath).existsSync(), isTrue);
      expect(
        await File(first.displayPath).readAsString(encoding: latin1),
        startsWith('%PDF-1.4'),
      );
    },
  );
}
