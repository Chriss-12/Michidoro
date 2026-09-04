import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/calendar/data/services/raw_weekly_schedule_pdf_renderer.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_document.dart';

void main() {
  test('renders a one-page landscape Letter weekly schedule', () {
    const renderer = RawWeeklySchedulePdfRenderer();
    final bytes = renderer.render(
      WeeklyScheduleExportDocument(
        weekStart: DateTime(2026, 8, 24),
        generatedAt: DateTime(2026, 8, 27, 14, 30),
        isEnglish: false,
        activities: [
          WeeklyScheduleExportActivity(
            localDate: DateTime(2026, 8, 24),
            routineName: 'Rutina física',
            title: 'Hacer ejercicio',
            startMinute: 8 * 60,
            durationMinutes: 60,
            statusLabel: 'Pendiente',
            colorKey: 'secondary',
            customColorArgb: null,
            hasOverlap: true,
          ),
        ],
        goals: [
          WeeklyScheduleExportGoal(
            targetDate: DateTime(2026, 8, 28),
            title: 'Recuperar energía',
            completedTasks: 1,
            totalTasks: 3,
          ),
        ],
      ),
    );
    final pdf = latin1.decode(bytes);

    expect(pdf, startsWith('%PDF-1.4'));
    expect(pdf, endsWith('%%EOF'));
    expect(pdf, contains('/MediaBox [0 0 792 612]'));
    expect(pdf, contains('/Count 1'));
    expect(pdf, contains('Horario semanal de rutinas'));
    expect(pdf, contains('Lun 24'));
    expect(pdf, contains('Dom 30'));
    expect(pdf, contains('Hacer ejercicio'));
    expect(pdf, contains('Recuperar energía'));
    expect(pdf, contains('1/3 tareas'));
  });

  test('replaces unsupported glyphs instead of failing the export', () {
    const renderer = RawWeeklySchedulePdfRenderer();
    final bytes = renderer.render(
      WeeklyScheduleExportDocument(
        weekStart: DateTime(2026, 8, 24),
        generatedAt: DateTime(2026, 8, 27),
        isEnglish: true,
        activities: [
          WeeklyScheduleExportActivity(
            localDate: DateTime(2026, 8, 25),
            routineName: 'Morning 🌞',
            title: 'Focus 🐱',
            startMinute: 9 * 60,
            durationMinutes: 25,
            statusLabel: 'Pending',
            colorKey: 'primary',
            customColorArgb: 0xFF336699,
            hasOverlap: false,
          ),
        ],
        goals: const [],
      ),
    );

    expect(latin1.decode(bytes), contains('Focus ?'));
  });
}
