import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum StatisticsReportPeriod { day, month, year, range }

class StatisticsReportRequest {
  const StatisticsReportRequest({
    required this.period,
    this.from,
    this.to,
  });

  final StatisticsReportPeriod period;
  final DateTime? from;
  final DateTime? to;

  String get label {
    return switch (period) {
      StatisticsReportPeriod.day => 'Day',
      StatisticsReportPeriod.month => 'Month',
      StatisticsReportPeriod.year => 'Year',
      StatisticsReportPeriod.range => 'Custom range',
    };
  }
}

class PerformanceMetric {
  const PerformanceMetric({
    required this.label,
    required this.focusMinutes,
    required this.breakMinutes,
    required this.advancePercent,
  });

  final String label;
  final int focusMinutes;
  final int breakMinutes;
  final int advancePercent;
}

class AppSettingsController {
  AppSettingsController();

  final FlutterSignal<AppThemePreset> themePreset = signal(
    AppThemePreset.natureFocus,
  );
  final FlutterSignal<bool> isDarkMode = signal(false);
  final FlutterSignal<double> fontScale = signal<double>(1);
  final FlutterSignal<String> profileName = signal('Chriss');
  final FlutterSignal<String> profileImagePath = signal('');
  final FlutterSignal<int> avatarIndex = signal(0);
  final FlutterSignal<int> focusMinutes = signal(25);
  final FlutterSignal<int> shortBreakMinutes = signal(5);
  final FlutterSignal<int> longBreakMinutes = signal(15);
  final FlutterSignal<int> longBreakFrequency = signal(2);
  final FlutterSignal<bool> autoStartBreak = signal(true);
  final FlutterSignal<bool> autoStartFocus = signal(false);
  final FlutterSignal<bool> notificationsEnabled = signal(true);
  final FlutterSignal<bool> breakAlertsEnabled = signal(true);
  final FlutterSignal<bool> focusAlertsEnabled = signal(true);
  final FlutterSignal<bool> isPomodoroRunning = signal(false);
  final FlutterSignal<int> remainingSeconds = signal(25 * 60);
  final FlutterSignal<int> completedTasks = signal(2);
  final FlutterSignal<int> totalTasks = signal(5);
  final FlutterSignal<int> completedPomodoros = signal(0);
  final FlutterSignal<int> totalFocusSeconds = signal(0);
  final FlutterSignal<String> lastReportPath = signal('');

  Timer? _timer;

  void setFocusMinutes(int value) {
    focusMinutes.value = value.clamp(1, 60);
    if (!isPomodoroRunning.value) {
      remainingSeconds.value = focusMinutes.value * 60;
    }
  }

  void setShortBreakMinutes(int value) {
    shortBreakMinutes.value = value.clamp(1, 20);
  }

  void setLongBreakMinutes(int value) {
    longBreakMinutes.value = value.clamp(5, 45);
  }

  void togglePomodoro() {
    if (isPomodoroRunning.value) {
      _timer?.cancel();
      isPomodoroRunning.value = false;
      return;
    }

    isPomodoroRunning.value = true;
    if (remainingSeconds.value <= 0) {
      remainingSeconds.value = focusMinutes.value * 60;
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value <= 1) {
        _timer?.cancel();
        remainingSeconds.value = 0;
        isPomodoroRunning.value = false;
        completedPomodoros.value += 1;
        totalFocusSeconds.value += focusMinutes.value * 60;
        return;
      }

      remainingSeconds.value -= 1;
    });
  }

  void resetPomodoro() {
    _timer?.cancel();
    isPomodoroRunning.value = false;
    remainingSeconds.value = focusMinutes.value * 60;
  }

  Future<void> downloadStatisticsPdf(StatisticsReportRequest request) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/michifocus-statistics.pdf');
    final metrics = _statisticsFor(request.period);
    final totalFocus = metrics.fold<int>(
      0,
      (previous, metric) => previous + metric.focusMinutes,
    );
    final totalBreak = metrics.fold<int>(
      0,
      (previous, metric) => previous + metric.breakMinutes,
    );
    final averageAdvance = metrics.isEmpty
        ? 0
        : metrics.fold<int>(
                0,
                (previous, metric) => previous + metric.advancePercent,
              ) ~/
              metrics.length;

    await file.writeAsBytes(
      _buildStatisticsPdf(
        title: 'MichiFocus Statistics Report',
        period: request.label,
        range: _formatRange(request),
        metrics: metrics,
        totalFocus: totalFocus,
        totalBreak: totalBreak,
        averageAdvance: averageAdvance,
      ),
      flush: true,
    );
    lastReportPath.value = file.path;
  }

  List<PerformanceMetric> _statisticsFor(StatisticsReportPeriod period) {
    return switch (period) {
      StatisticsReportPeriod.day => const [
        PerformanceMetric(
          label: 'Morning',
          focusMinutes: 75,
          breakMinutes: 15,
          advancePercent: 60,
        ),
        PerformanceMetric(
          label: 'Afternoon',
          focusMinutes: 100,
          breakMinutes: 20,
          advancePercent: 80,
        ),
        PerformanceMetric(
          label: 'Night',
          focusMinutes: 50,
          breakMinutes: 10,
          advancePercent: 40,
        ),
      ],
      StatisticsReportPeriod.month => const [
        PerformanceMetric(
          label: 'W1',
          focusMinutes: 420,
          breakMinutes: 90,
          advancePercent: 58,
        ),
        PerformanceMetric(
          label: 'W2',
          focusMinutes: 520,
          breakMinutes: 110,
          advancePercent: 72,
        ),
        PerformanceMetric(
          label: 'W3',
          focusMinutes: 610,
          breakMinutes: 130,
          advancePercent: 84,
        ),
        PerformanceMetric(
          label: 'W4',
          focusMinutes: 560,
          breakMinutes: 120,
          advancePercent: 78,
        ),
      ],
      StatisticsReportPeriod.year => const [
        PerformanceMetric(
          label: 'Q1',
          focusMinutes: 4800,
          breakMinutes: 960,
          advancePercent: 55,
        ),
        PerformanceMetric(
          label: 'Q2',
          focusMinutes: 6200,
          breakMinutes: 1240,
          advancePercent: 71,
        ),
        PerformanceMetric(
          label: 'Q3',
          focusMinutes: 6800,
          breakMinutes: 1360,
          advancePercent: 79,
        ),
        PerformanceMetric(
          label: 'Q4',
          focusMinutes: 7200,
          breakMinutes: 1440,
          advancePercent: 86,
        ),
      ],
      StatisticsReportPeriod.range => const [
        PerformanceMetric(
          label: 'Start',
          focusMinutes: 180,
          breakMinutes: 35,
          advancePercent: 45,
        ),
        PerformanceMetric(
          label: 'Middle',
          focusMinutes: 360,
          breakMinutes: 75,
          advancePercent: 68,
        ),
        PerformanceMetric(
          label: 'End',
          focusMinutes: 430,
          breakMinutes: 85,
          advancePercent: 82,
        ),
      ],
    };
  }

  String _formatRange(StatisticsReportRequest request) {
    String format(DateTime date) =>
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    if (request.period == StatisticsReportPeriod.range &&
        request.from != null &&
        request.to != null) {
      return '${format(request.from!)} to ${format(request.to!)}';
    }

    final now = DateTime.now();
    return switch (request.period) {
      StatisticsReportPeriod.day => format(now),
      StatisticsReportPeriod.month =>
        '${now.year}-${now.month.toString().padLeft(2, '0')}',
      StatisticsReportPeriod.year => '${now.year}',
      StatisticsReportPeriod.range => 'Custom range',
    };
  }

  List<int> _buildStatisticsPdf({
    required String title,
    required String period,
    required String range,
    required List<PerformanceMetric> metrics,
    required int totalFocus,
    required int totalBreak,
    required int averageAdvance,
  }) {
    final content = StringBuffer()
      ..writeln('BT /F1 20 Tf 48 792 Td (${_pdfText(title)}) Tj ET')
      ..writeln('BT /F1 12 Tf 48 764 Td (Period: ${_pdfText(period)}) Tj ET')
      ..writeln('BT /F1 12 Tf 48 746 Td (Range: ${_pdfText(range)}) Tj ET')
      ..writeln(
        'BT /F1 12 Tf 48 724 Td (Focus: $totalFocus min  |  Break: $totalBreak min  |  Progress: $averageAdvance%) Tj ET',
      )
      ..writeln('0.1 0.1 0.1 RG 48 690 m 548 690 l S')
      ..writeln('BT /F1 14 Tf 48 664 Td (Performance by period) Tj ET');

    var x = 70.0;
    for (final metric in metrics) {
      final barHeight = metric.advancePercent * 2.6;
      content
        ..writeln('0.85 0.85 0.85 rg $x 360 34 260 re f')
        ..writeln(
          '0.1 0.1 0.1 rg $x 360 34 ${barHeight.toStringAsFixed(1)} re f',
        )
        ..writeln('BT /F1 9 Tf $x 344 Td (${_pdfText(metric.label)}) Tj ET')
        ..writeln('BT /F1 9 Tf $x 626 Td (${metric.advancePercent}%) Tj ET');
      x += 92;
    }

    content
      ..writeln('BT /F1 14 Tf 48 304 Td (Study time vs rest) Tj ET')
      ..writeln(
        '0.0 0.0 0.0 rg 48 270 ${(totalFocus / (totalFocus + totalBreak).clamp(1, 999999) * 360).toStringAsFixed(1)} 18 re f',
      )
      ..writeln(
        '0.75 0.75 0.75 rg ${(48 + totalFocus / (totalFocus + totalBreak).clamp(1, 999999) * 360).toStringAsFixed(1)} 270 ${(totalBreak / (totalFocus + totalBreak).clamp(1, 999999) * 360).toStringAsFixed(1)} 18 re f',
      )
      ..writeln(
        'BT /F1 10 Tf 48 246 Td (Black: study/focus minutes. Gray: rest minutes.) Tj ET',
      )
      ..writeln(
        'BT /F1 10 Tf 48 220 Td (This report uses local offline statistics and will connect to real persisted sessions when storage is implemented.) Tj ET',
      );

    return _pdfDocument(content.toString());
  }

  String _pdfText(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll('(', r'\(')
        .replaceAll(')', r'\)');
  }

  List<int> _pdfDocument(String stream) {
    final objects = <String>[
      '1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n',
      '2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n',
      '3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >> endobj\n',
      '4 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj\n',
      '5 0 obj << /Length ${latin1.encode(stream).length} >> stream\n$stream\nendstream endobj\n',
    ];
    final buffer = StringBuffer('%PDF-1.4\n');
    final offsets = <int>[0];
    var length = latin1.encode(buffer.toString()).length;

    for (final object in objects) {
      offsets.add(length);
      buffer.write(object);
      length += latin1.encode(object).length;
    }

    final xrefOffset = length;
    buffer
      ..writeln('xref')
      ..writeln('0 ${objects.length + 1}')
      ..writeln('0000000000 65535 f ');
    for (final offset in offsets.skip(1)) {
      buffer.writeln('${offset.toString().padLeft(10, '0')} 00000 n ');
    }
    buffer
      ..writeln('trailer << /Size ${objects.length + 1} /Root 1 0 R >>')
      ..writeln('startxref')
      ..writeln(xrefOffset)
      ..write('%%EOF');

    return latin1.encode(buffer.toString());
  }

  Future<void> downloadReport() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/michidoro-performance-report.txt');
    final minutes = totalFocusSeconds.value ~/ 60;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    final report =
        '''
MichiDoro Performance Report

Completed tasks: ${completedTasks.value} / ${totalTasks.value}
Completed Pomodoros: ${completedPomodoros.value}
Focused time: ${hours}h ${remainingMinutes}m
Focus session length: ${focusMinutes.value} minutes
Short break: ${shortBreakMinutes.value} minutes
Long break: ${longBreakMinutes.value} minutes
''';

    await file.writeAsString(report);
    lastReportPath.value = file.path;
  }
}

final appSettingsController = AppSettingsController();
