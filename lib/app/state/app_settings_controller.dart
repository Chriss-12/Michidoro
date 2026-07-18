import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/settings/domain/entities/timer_preferences.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum StatisticsReportPeriod { day, week, month, year, range }

enum StatisticsChartType {
  circular('Circular'),
  stackedBars('Barras apiladas'),
  groupedBars('Barras agrupadas'),
  horizontalBars('Grafico horizontal'),
  standardBars('Grafico de barras'),
  xy('X/Y');

  const StatisticsChartType(this.label);

  final String label;
}

enum PomodoroCompletionSound {
  softBell(
    'Campana suave',
    'Alerta serena para cerrar la sesión',
    SystemSoundType.alert,
  ),
  lightTap('Toque breve', 'Señal corta y discreta', SystemSoundType.click),
  silent('Silencio', 'No reproducir sonido al finalizar', null);

  const PomodoroCompletionSound(this.label, this.description, this.systemSound);

  final String label;
  final String description;
  final SystemSoundType? systemSound;
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.routePath,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? routePath;
}

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
      StatisticsReportPeriod.week => 'Week',
      StatisticsReportPeriod.month => 'Month',
      StatisticsReportPeriod.year => 'Year',
      StatisticsReportPeriod.range => 'Custom range',
    };
  }
}

class StatisticsTaskTotals {
  const StatisticsTaskTotals({
    required this.listed,
    required this.inProgress,
    required this.completed,
  });

  final int listed;
  final int inProgress;
  final int completed;

  int get total => listed + inProgress + completed;
  double get completionRatio => total == 0 ? 0 : completed / total;
}

class StatisticsCalendarDay {
  const StatisticsCalendarDay({
    required this.day,
    required this.completionRatio,
    required this.isEnded,
    required this.totalTasks,
  });

  final DateTime day;
  final double completionRatio;
  final bool isEnded;
  final int totalTasks;
}

class StatisticsReportData {
  const StatisticsReportData({
    required this.tasks,
    required this.calendarDays,
    required this.completedPomodoros,
    required this.focusedSeconds,
  });

  final StatisticsTaskTotals tasks;
  final List<StatisticsCalendarDay> calendarDays;
  final int completedPomodoros;
  final int focusedSeconds;

  int get focusedMinutes => focusedSeconds ~/ 60;
  int get progressPercent => (tasks.completionRatio * 100).round();
}

class AppSettingsController {
  AppSettingsController({Directory? documentsDirectory})
    : _documentsDirectoryOverride = documentsDirectory;

  static const databaseBackupFileNames = [
    'michidoro-settings.json',
    'michifocus_goals.sqlite',
    'michifocus_tasks.sqlite',
    'michifocus_pomodoro_sessions.sqlite',
    'michifocus_calendar_events.sqlite',
  ];

  static const _pendingImportDirectoryName = 'michifocus-pending-import';

  final FlutterSignal<AppThemePreset> themePreset = signal(
    AppThemePreset.natureFocus,
  );
  final FlutterSignal<bool> isDarkMode = signal(false);
  final FlutterSignal<double> fontScale = signal<double>(1);
  final FlutterSignal<String> profileName = signal('Chriss');
  final FlutterSignal<String> profileEmail = signal('');
  final FlutterSignal<String> profileImagePath = signal('');
  final FlutterSignal<int> avatarIndex = signal(0);
  final FlutterSignal<AppTypographyPreset> typographyPreset = signal(
    AppTypographyPreset.moderna,
  );
  final FlutterSignal<int> focusMinutes = signal(25);
  final FlutterSignal<int> shortBreakMinutes = signal(5);
  final FlutterSignal<int> longBreakMinutes = signal(15);
  final FlutterSignal<int> longBreakFrequency = signal(2);
  final FlutterSignal<PomodoroCompletionSound> completionSound = signal(
    PomodoroCompletionSound.softBell,
  );
  final FlutterSignal<bool> completionVibrationEnabled = signal(true);
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
  final FlutterSignal<String> reportsDirectoryPath = signal('');
  final FlutterSignal<Set<StatisticsChartType>> enabledStatisticsCharts =
      signal({...StatisticsChartType.values});
  final FlutterSignal<List<AppNotification>> notifications = signal(const []);

  Timer? _timer;
  SettingsRepository? _settingsRepository;
  final Directory? _documentsDirectoryOverride;

  Future<void> loadTimerPreferences(SettingsRepository repository) async {
    _settingsRepository = repository;
    applyTimerPreferences(await repository.loadTimerPreferences());
  }

  void applyTimerPreferences(TimerPreferences preferences) {
    final normalized = preferences.normalized();
    focusMinutes.value = normalized.focusMinutes;
    shortBreakMinutes.value = normalized.shortBreakMinutes;
    longBreakMinutes.value = normalized.longBreakMinutes;
    longBreakFrequency.value = normalized.longBreakFrequency;
    completionSound.value = normalized.completionSound;
    completionVibrationEnabled.value = normalized.completionVibrationEnabled;
    autoStartBreak.value = normalized.autoStartBreak;
    autoStartFocus.value = normalized.autoStartFocus;
    reportsDirectoryPath.value = normalized.reportsDirectoryPath;
    profileName.value = normalized.profileName;
    profileEmail.value = normalized.profileEmail;
    profileImagePath.value = normalized.profileImagePath;
    avatarIndex.value = normalized.avatarIndex;
    typographyPreset.value = normalized.typographyPreset;
    enabledStatisticsCharts.value = normalized.enabledStatisticsCharts;
    if (!isPomodoroRunning.value) {
      remainingSeconds.value = normalized.focusMinutes * 60;
    }
  }

  TimerPreferences get timerPreferences {
    return TimerPreferences(
      focusMinutes: focusMinutes.value,
      shortBreakMinutes: shortBreakMinutes.value,
      longBreakMinutes: longBreakMinutes.value,
      longBreakFrequency: longBreakFrequency.value,
      completionSound: completionSound.value,
      completionVibrationEnabled: completionVibrationEnabled.value,
      autoStartBreak: autoStartBreak.value,
      autoStartFocus: autoStartFocus.value,
      reportsDirectoryPath: reportsDirectoryPath.value,
      profileName: profileName.value,
      profileEmail: profileEmail.value,
      profileImagePath: profileImagePath.value,
      avatarIndex: avatarIndex.value,
      typographyPreset: typographyPreset.value,
      enabledStatisticsCharts: enabledStatisticsCharts.value,
    ).normalized();
  }

  Future<void> saveTimerPreferences() async {
    await _settingsRepository?.saveTimerPreferences(timerPreferences);
  }

  void setFocusMinutes(int value) {
    focusMinutes.value = value.clamp(5, 90);
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

  void setLongBreakFrequency(int value) {
    longBreakFrequency.value = value.clamp(3, 5);
  }

  void setReportsDirectoryPath(String value) {
    reportsDirectoryPath.value = value.trim();
  }

  void setProfileName(String value) {
    final trimmed = value.trim();
    profileName.value = trimmed.isEmpty ? 'Chriss' : trimmed;
  }

  void setProfileEmail(String value) {
    profileEmail.value = value.trim();
  }

  void setProfileImagePath(String value) {
    profileImagePath.value = value.trim();
  }

  void setAvatarIndex(int value) {
    avatarIndex.value = value.clamp(0, 3);
  }

  void setStatisticsChartEnabled(
    StatisticsChartType chart, {
    required bool enabled,
  }) {
    final next = {...enabledStatisticsCharts.value};
    if (enabled) {
      next.add(chart);
    } else if (next.length > 1) {
      next.remove(chart);
    }
    enabledStatisticsCharts.value = next;
  }

  AppTypographyPreset get selectedTypographyPreset => typographyPreset.value;

  set selectedTypographyPreset(AppTypographyPreset value) {
    typographyPreset.value = value;
  }

  Future<void> useDefaultReportsDirectory() async {
    reportsDirectoryPath.value = (await _defaultReportsDirectory()).path;
    await saveTimerPreferences();
  }

  PomodoroCompletionSound get selectedCompletionSound => completionSound.value;

  set selectedCompletionSound(PomodoroCompletionSound value) {
    completionSound.value = value;
  }

  bool get isCompletionVibrationEnabled => completionVibrationEnabled.value;

  set isCompletionVibrationEnabled(bool value) {
    completionVibrationEnabled.value = value;
  }

  Future<void> previewCompletionSound() {
    return playCompletionSound();
  }

  Future<void> previewCompletionVibration() {
    return playCompletionVibration();
  }

  Future<void> sendTestNotification({bool playFeedback = true}) async {
    addNotification(
      title: 'Notificacion de prueba',
      body: 'El tono seleccionado esta listo para tus recordatorios.',
      routePath: '/settings/notifications',
    );

    if (playFeedback) {
      await playCompletionFeedback();
    }
  }

  void addNotification({
    required String title,
    required String body,
    String? routePath,
  }) {
    final createdAt = DateTime.now();
    final next = AppNotification(
      id: createdAt.microsecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: createdAt,
      routePath: routePath,
    );

    notifications.value = [
      next,
      ...notifications.value,
    ].take(12).toList(growable: false);
  }

  void clearNotifications() {
    notifications.value = const [];
  }

  Future<void> playCompletionFeedback() async {
    await Future.wait([
      playCompletionSound(),
      playCompletionVibration(),
    ]);
  }

  Future<void> playCompletionSound() async {
    final sound = completionSound.value.systemSound;
    if (sound == null) {
      return;
    }

    await SystemSound.play(sound);
  }

  Future<void> playCompletionVibration() async {
    if (!completionVibrationEnabled.value) {
      return;
    }

    await HapticFeedback.mediumImpact();
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

  Future<void> downloadStatisticsPdf(
    StatisticsReportRequest request,
    StatisticsReportData data,
  ) async {
    final directory = await _reportsDirectory();
    final file = File('${directory.path}/michifocus-statistics.pdf');

    await file.writeAsBytes(
      _buildStatisticsPdf(
        title: 'Reporte de rendimiento MichiFocus',
        profileName: profileName.value,
        profileEmail: profileEmail.value,
        period: request.label,
        range: _formatRange(request),
        enabledCharts: enabledStatisticsCharts.value,
        data: data,
      ),
      flush: true,
    );
    lastReportPath.value = file.path;
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
      StatisticsReportPeriod.week =>
        '${format(now.subtract(Duration(days: now.weekday - 1)))} to ${format(now.add(Duration(days: DateTime.sunday - now.weekday)))}',
      StatisticsReportPeriod.month =>
        '${now.year}-${now.month.toString().padLeft(2, '0')}',
      StatisticsReportPeriod.year => '${now.year}',
      StatisticsReportPeriod.range => 'Custom range',
    };
  }

  List<int> _buildStatisticsPdf({
    required String title,
    required String profileName,
    required String profileEmail,
    required String period,
    required String range,
    required Set<StatisticsChartType> enabledCharts,
    required StatisticsReportData data,
  }) {
    final taskTotal = data.tasks.total;
    final progress = data.progressPercent;
    final focusedMinutes = data.focusedMinutes;
    final coaching = _coachingPhrase(data.tasks.completionRatio);
    final listedWidth = _chartWidth(data.tasks.listed, taskTotal);
    final inProgressWidth = _chartWidth(data.tasks.inProgress, taskTotal);
    final completedWidth = _chartWidth(data.tasks.completed, taskTotal);
    final owner = profileName.trim().isEmpty ? 'Usuario' : profileName.trim();
    final email = profileEmail.trim().isEmpty
        ? 'Sin correo configurado'
        : profileEmail.trim();
    final chartNames = enabledCharts.map((chart) => chart.label).join(', ');
    final content = StringBuffer()
      ..writeln('0.95 0.98 0.91 rg 0 0 595 842 re f')
      ..writeln('0.18 0.13 0.09 rg 0 760 595 82 re f')
      ..writeln('0.47 0.61 0.37 rg 0 752 595 8 re f')
      ..writeln('1 1 1 rg 44 786 12 12 re f')
      ..writeln('BT /F1 20 Tf 68 792 Td (${_pdfText(title)}) Tj ET')
      ..writeln(
        'BT /F1 10 Tf 68 772 Td (${_pdfText(owner)} | ${_pdfText(email)}) Tj ET',
      )
      ..writeln('0.18 0.13 0.09 rg')
      ..writeln(
        'BT /F1 11 Tf 48 728 Td (Periodo: ${_pdfText(period)} | Rango: ${_pdfText(range)}) Tj ET',
      )
      ..writeln('0.99 0.99 0.97 rg 38 646 519 62 re f')
      ..writeln('0.84 0.81 0.74 RG 38 646 519 62 re S')
      ..writeln(
        'BT /F1 12 Tf 52 686 Td (Tareas: $taskTotal  |  Completadas: ${data.tasks.completed}  |  Avance: $progress%) Tj ET',
      )
      ..writeln(
        'BT /F1 12 Tf 52 666 Td (Pomodoros: ${data.completedPomodoros}  |  Minutos enfocados: $focusedMinutes) Tj ET',
      )
      ..writeln(
        'BT /F1 9 Tf 52 650 Td (Graficos incluidos: ${_pdfText(chartNames)}) Tj ET',
      );

    var y = 612.0;
    if (enabledCharts.contains(StatisticsChartType.circular)) {
      content
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln('BT /F1 14 Tf 48 $y Td (Avance general) Tj ET')
        ..writeln('0.90 0.90 0.86 rg 48 ${y - 28} 200 16 re f')
        ..writeln(
          '0.47 0.61 0.37 rg 48 ${y - 28} ${(progress.clamp(0, 100) / 100 * 200).toStringAsFixed(1)} 16 re f',
        )
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln(
          'BT /F1 10 Tf 262 ${y - 24} Td ($progress% completado) Tj ET',
        );
      y -= 58;
    }

    if (enabledCharts.intersection({
      StatisticsChartType.stackedBars,
      StatisticsChartType.horizontalBars,
      StatisticsChartType.standardBars,
    }).isNotEmpty) {
      content
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln('BT /F1 14 Tf 48 $y Td (Estado de tareas) Tj ET')
        ..writeln('BT /F1 10 Tf 48 ${y - 28} Td (Pendientes) Tj ET')
        ..writeln('0.88 0.88 0.84 rg 150 ${y - 36} 260 14 re f')
        ..writeln('0.90 0.32 0.32 rg 150 ${y - 36} $listedWidth 14 re f')
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln('BT /F1 10 Tf 426 ${y - 28} Td (${data.tasks.listed}) Tj ET')
        ..writeln('BT /F1 10 Tf 48 ${y - 58} Td (En progreso) Tj ET')
        ..writeln('0.88 0.88 0.84 rg 150 ${y - 66} 260 14 re f')
        ..writeln('0.89 0.70 0.25 rg 150 ${y - 66} $inProgressWidth 14 re f')
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln(
          'BT /F1 10 Tf 426 ${y - 58} Td (${data.tasks.inProgress}) Tj ET',
        )
        ..writeln('BT /F1 10 Tf 48 ${y - 88} Td (Completadas) Tj ET')
        ..writeln('0.88 0.88 0.84 rg 150 ${y - 96} 260 14 re f')
        ..writeln('0.10 0.56 0.33 rg 150 ${y - 96} $completedWidth 14 re f')
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln(
          'BT /F1 10 Tf 426 ${y - 88} Td (${data.tasks.completed}) Tj ET',
        );
      y -= 126;
    }

    if (enabledCharts.contains(StatisticsChartType.groupedBars)) {
      content
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln('BT /F1 14 Tf 48 $y Td (Foco y finalizacion) Tj ET')
        ..writeln(
          '0.20 0.20 0.20 rg 48 ${y - 34} ${(focusedMinutes.clamp(0, 600) / 600 * 220).toStringAsFixed(1)} 16 re f',
        )
        ..writeln(
          '0.47 0.61 0.37 rg 48 ${y - 62} ${(data.completedPomodoros.clamp(0, 24) / 24 * 220).toStringAsFixed(1)} 16 re f',
        )
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln(
          'BT /F1 10 Tf 284 ${y - 30} Td ($focusedMinutes min de foco) Tj ET',
        )
        ..writeln(
          'BT /F1 10 Tf 284 ${y - 58} Td (${data.completedPomodoros} pomodoros) Tj ET',
        );
      y -= 94;
    }

    if (enabledCharts.contains(StatisticsChartType.xy)) {
      content
        ..writeln('0.18 0.13 0.09 rg')
        ..writeln('BT /F1 14 Tf 48 $y Td (Tendencia por calendario) Tj ET');
      y -= 24;
      for (final day in data.calendarDays.take(10)) {
        final percent = (day.completionRatio * 100).round();
        final barWidth = (day.completionRatio.clamp(0.0, 1.0) * 130)
            .toStringAsFixed(1);
        final status = day.isEnded ? 'cerrado' : 'abierto';
        content
          ..writeln(
            'BT /F1 9 Tf 48 $y Td (${_pdfText(_formatDate(day.day))}: $percent% | ${day.totalTasks} tareas | $status) Tj ET',
          )
          ..writeln('0.90 0.90 0.86 rg 260 ${y - 3} 130 8 re f')
          ..writeln('0.10 0.56 0.33 rg 260 ${y - 3} $barWidth 8 re f')
          ..writeln('0.18 0.13 0.09 rg');
        y -= 18;
      }
    }

    content
      ..writeln('0.18 0.13 0.09 rg 38 54 519 62 re f')
      ..writeln('1 1 1 rg')
      ..writeln('BT /F1 14 Tf 52 92 Td (Recomendacion) Tj ET')
      ..writeln(
        'BT /F1 10 Tf 52 72 Td (${_pdfText(coaching)}) Tj ET',
      );

    return _pdfDocument(content.toString());
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _chartWidth(int value, int total) {
    if (total <= 0) {
      return '0.0';
    }

    return (value / total * 260).toStringAsFixed(1);
  }

  String _coachingPhrase(double ratio) {
    if (ratio <= 0.2) {
      return 'Empieza pequeno: elige una tarea pendiente y protege el siguiente bloque de foco.';
    }

    if (ratio <= 0.5) {
      return 'Buen avance: manten una tarea en progreso y cierrala antes de sumar mas trabajo.';
    }

    if (ratio <= 0.7) {
      return 'Progreso solido: tu plan funciona, ahora cierra la tarea de mayor valor.';
    }

    return 'Excelente ritmo: conserva este paso y programa una pausa de recuperacion.';
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
    final directory = await _reportsDirectory();
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

  Future<void> exportDatabaseBackup() async {
    final directory = await _reportsDirectory();
    final backupDirectory = Directory('${directory.path}/michifocus-backup');
    if (!backupDirectory.existsSync()) {
      backupDirectory.createSync(recursive: true);
    }

    final appDirectory = await _applicationDocumentsDirectory();

    for (final fileName in databaseBackupFileNames) {
      final source = File('${appDirectory.path}/$fileName');
      if (!source.existsSync()) {
        continue;
      }

      await source.copy('${backupDirectory.path}/$fileName');
    }

    lastReportPath.value = backupDirectory.path;
  }

  Future<void> stageDatabaseBackupImport(String directoryPath) async {
    final sourceDirectory = Directory(directoryPath.trim());
    if (!sourceDirectory.existsSync()) {
      throw const FileSystemException('La carpeta de backup no existe.');
    }

    final importFiles = databaseBackupFileNames
        .map((fileName) => File('${sourceDirectory.path}/$fileName'))
        .where((file) => file.existsSync())
        .toList(growable: false);

    if (importFiles.isEmpty) {
      throw const FileSystemException(
        'La carpeta no contiene archivos de backup de MichiFocus.',
      );
    }

    final appDirectory = await _applicationDocumentsDirectory();
    final pendingDirectory = Directory(
      '${appDirectory.path}/$_pendingImportDirectoryName',
    );
    if (pendingDirectory.existsSync()) {
      await pendingDirectory.delete(recursive: true);
    }
    pendingDirectory.createSync(recursive: true);

    for (final source in importFiles) {
      await source.copy('${pendingDirectory.path}/${_fileName(source.path)}');
    }

    lastReportPath.value = pendingDirectory.path;
  }

  Future<bool> applyPendingDatabaseImport() async {
    final appDirectory = await _applicationDocumentsDirectory();
    final pendingDirectory = Directory(
      '${appDirectory.path}/$_pendingImportDirectoryName',
    );
    if (!pendingDirectory.existsSync()) {
      return false;
    }

    for (final fileName in databaseBackupFileNames) {
      final source = File('${pendingDirectory.path}/$fileName');
      if (!source.existsSync()) {
        continue;
      }

      await source.copy('${appDirectory.path}/$fileName');
    }

    await pendingDirectory.delete(recursive: true);
    return true;
  }

  Future<Directory> _reportsDirectory() async {
    final configuredPath = reportsDirectoryPath.value.trim();
    if (configuredPath.isNotEmpty) {
      final configuredDirectory = Directory(configuredPath);
      try {
        if (!configuredDirectory.existsSync()) {
          configuredDirectory.createSync(recursive: true);
        }

        return configuredDirectory;
      } on FileSystemException {
        // Fall back to the platform default if the selected directory is not writable.
      }
    }

    final defaultDirectory = await _defaultReportsDirectory();
    if (!defaultDirectory.existsSync()) {
      defaultDirectory.createSync(recursive: true);
    }

    return defaultDirectory;
  }

  Future<Directory> _defaultReportsDirectory() async {
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

    return getApplicationDocumentsDirectory();
  }

  Future<Directory> _applicationDocumentsDirectory() async {
    return _documentsDirectoryOverride ?? getApplicationDocumentsDirectory();
  }

  String _fileName(String path) {
    final normalized = path.replaceAll(r'\', '/');
    return normalized.substring(normalized.lastIndexOf('/') + 1);
  }
}

final appSettingsController = AppSettingsController();
