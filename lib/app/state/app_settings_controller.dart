import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/app/state/native_file_manager.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/reports/data/services/local_statistics_report_file_writer.dart';
import 'package:pomodoro_app_v1/features/reports/data/services/raw_statistics_pdf_renderer.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_document.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_file.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_document_renderer.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_file_writer.dart';
import 'package:pomodoro_app_v1/features/settings/domain/entities/timer_preferences.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';
import 'package:signals_flutter/signals_flutter.dart';

export 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';

enum PomodoroCompletionSound {
  softBell(
    'Campana suave',
    'Campana breve y clara para cerrar el bloque.',
    SystemSoundType.alert,
  ),
  lightTap(
    'Toque ligero',
    'Senal corta y discreta para avisos rapidos.',
    SystemSoundType.click,
  ),
  warmChime(
    'Campanilla calida',
    'Notas suaves con un cierre mas agradable.',
    SystemSoundType.alert,
  ),
  crystalChime(
    'Cristal claro',
    'Secuencia limpia y brillante sin sonar agresiva.',
    SystemSoundType.alert,
  ),
  calmPulse(
    'Pulso calmado',
    'Dos pulsos redondos para una alerta tranquila.',
    SystemSoundType.alert,
  ),
  deepChime(
    'Campana profunda',
    'Tono grave y reposado para descansos largos.',
    SystemSoundType.alert,
  ),
  digitalZen(
    'Zen digital',
    'Secuencia moderna, corta y menos invasiva.',
    SystemSoundType.alert,
  ),
  silent('Silencio', 'No reproducir sonido al finalizar.', null);

  const PomodoroCompletionSound(this.label, this.description, this.systemSound);

  final String label;
  final String description;
  final SystemSoundType? systemSound;

  bool get isAudible => systemSound != null;
}

enum PomodoroVibrationPattern {
  light,
  normal,
  double,
  intense,
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

class AppSettingsController {
  AppSettingsController({
    Directory? documentsDirectory,
    StatisticsReportDocumentRenderer? statisticsReportRenderer,
    StatisticsReportFileWriter? statisticsReportFileWriter,
  }) : _documentsDirectoryOverride = documentsDirectory,
       _statisticsReportRenderer =
           statisticsReportRenderer ?? const RawStatisticsPdfRenderer(),
       _statisticsReportFileWriter =
           statisticsReportFileWriter ??
           LocalStatisticsReportFileWriter(
             documentsDirectory: documentsDirectory,
           );

  static const databaseBackupFileNames = [
    'michifocus.sqlite',
  ];

  static const _legacyDatabaseBackupFileNames = [
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
  final FlutterSignal<AppLanguage> language = signal(AppLanguage.spanish);
  final FlutterSignal<int> focusMinutes = signal(25);
  final FlutterSignal<int> shortBreakMinutes = signal(5);
  final FlutterSignal<int> longBreakMinutes = signal(15);
  final FlutterSignal<int> longBreakFrequency = signal(2);
  final FlutterSignal<PomodoroCompletionSound> completionSound = signal(
    PomodoroCompletionSound.softBell,
  );
  final FlutterSignal<bool> completionVibrationEnabled = signal(true);
  final FlutterSignal<PomodoroVibrationPattern> completionVibrationPattern =
      signal(PomodoroVibrationPattern.normal);
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
  final StatisticsReportDocumentRenderer _statisticsReportRenderer;
  final StatisticsReportFileWriter _statisticsReportFileWriter;

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
    completionVibrationPattern.value = normalized.completionVibrationPattern;
    autoStartBreak.value = normalized.autoStartBreak;
    autoStartFocus.value = normalized.autoStartFocus;
    reportsDirectoryPath.value = normalized.reportsDirectoryPath;
    profileName.value = normalized.profileName;
    profileEmail.value = normalized.profileEmail;
    profileImagePath.value = normalized.profileImagePath;
    avatarIndex.value = normalized.avatarIndex;
    themePreset.value = normalized.themePreset;
    isDarkMode.value = normalized.isDarkMode;
    fontScale.value = normalized.fontScale;
    typographyPreset.value = normalized.typographyPreset;
    language.value = normalized.language;
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
      completionVibrationPattern: completionVibrationPattern.value,
      autoStartBreak: autoStartBreak.value,
      autoStartFocus: autoStartFocus.value,
      reportsDirectoryPath: reportsDirectoryPath.value,
      profileName: profileName.value,
      profileEmail: profileEmail.value,
      profileImagePath: profileImagePath.value,
      avatarIndex: avatarIndex.value,
      themePreset: themePreset.value,
      isDarkMode: isDarkMode.value,
      fontScale: fontScale.value,
      typographyPreset: typographyPreset.value,
      enabledStatisticsCharts: enabledStatisticsCharts.value,
      language: language.value,
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
    if (profileName.value == value) {
      return;
    }
    profileName.value = value;
  }

  void setProfileEmail(String value) {
    if (profileEmail.value == value) {
      return;
    }
    profileEmail.value = value;
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

  PomodoroVibrationPattern get selectedCompletionVibrationPattern =>
      completionVibrationPattern.value;

  set selectedCompletionVibrationPattern(PomodoroVibrationPattern value) {
    completionVibrationPattern.value = value;
  }

  Future<void> previewCompletionSound() {
    return playCompletionSound();
  }

  Future<void> previewCompletionVibration() {
    return playCompletionVibration();
  }

  Future<void> sendTestNotification({bool playFeedback = true}) async {
    final scheduledAt = DateTime.now().add(const Duration(minutes: 25));
    addNotification(
      title: 'Tarea programada',
      body:
          'Hoy a ${_formatTime(scheduledAt)} - Revisar tu siguiente bloque de enfoque.',
      routePath: '/tasks',
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

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> playCompletionFeedback() async {
    await Future.wait([
      playCompletionSound(),
      playCompletionVibration(),
    ]);
  }

  Future<void> playCompletionSound() async {
    final selectedSound = completionSound.value;
    if (!selectedSound.isAudible) {
      return;
    }

    if (NativeFileManager.isAndroidExternalPickerAvailable) {
      await NativeFileManager.playCompletionSound(selectedSound.name);
      return;
    }

    await SystemSound.play(selectedSound.systemSound ?? SystemSoundType.alert);
  }

  Future<void> playCompletionVibration() async {
    if (!completionVibrationEnabled.value) {
      return;
    }

    switch (completionVibrationPattern.value) {
      case PomodoroVibrationPattern.light:
        await HapticFeedback.lightImpact();
      case PomodoroVibrationPattern.normal:
        await HapticFeedback.mediumImpact();
      case PomodoroVibrationPattern.double:
        await HapticFeedback.lightImpact();
        await Future<void>.delayed(const Duration(milliseconds: 140));
        await HapticFeedback.mediumImpact();
      case PomodoroVibrationPattern.intense:
        await HapticFeedback.heavyImpact();
    }
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

  Future<StatisticsReportFile> downloadStatisticsPdf(
    StatisticsReportRequest request,
    StatisticsReportData data,
  ) async {
    final bytes = _statisticsReportRenderer.render(
      StatisticsReportDocument(
        title: language.value == AppLanguage.english
            ? 'MichiFocus Performance Report'
            : 'Reporte de rendimiento MichiFocus',
        profileName: profileName.value,
        profileEmail: profileEmail.value,
        periodLabel: _reportPeriodLabel(request),
        enabledCharts: enabledStatisticsCharts.value,
        data: data,
        language: language.value,
      ),
    );
    final reportFile = await _statisticsReportFileWriter.write(
      bytes: bytes,
      request: request,
      generatedAt: data.generatedAt,
      configuredDestination: reportsDirectoryPath.value,
    );
    lastReportPath.value = reportFile.displayPath;
    return reportFile;
  }

  String _reportPeriodLabel(StatisticsReportRequest request) {
    if (language.value != AppLanguage.english) {
      return request.label;
    }

    return switch (request.period) {
      StatisticsReportPeriod.day => 'Day',
      StatisticsReportPeriod.week => 'Week',
      StatisticsReportPeriod.month => 'Month',
      StatisticsReportPeriod.year => 'Year',
      StatisticsReportPeriod.range => 'Custom range',
    };
  }

  Future<void> openReport(String path) {
    return NativeFileManager.openFile(path: path);
  }

  Future<String> exportDatabaseBackup({
    Future<void> Function(String targetPath)? createDatabaseSnapshot,
  }) async {
    final appDirectory = await _applicationDocumentsDirectory();
    final snapshot = File(
      '${appDirectory.path}/.michifocus-export.sqlite',
    );
    if (snapshot.existsSync()) {
      await snapshot.delete();
    }
    if (createDatabaseSnapshot != null) {
      await createDatabaseSnapshot(snapshot.path);
    }

    final externalFolder = _externalReportsFolderReference();
    if (externalFolder != null) {
      if (snapshot.existsSync()) {
        final saved = await NativeFileManager.saveFileToExternalFolder(
          folderUri: externalFolder,
          fileName: 'michifocus.sqlite',
          mimeType: 'application/vnd.sqlite3',
          bytes: await snapshot.readAsBytes(),
        );
        await snapshot.delete();
        lastReportPath.value = saved.displayPath;
      } else {
        lastReportPath.value =
            await NativeFileManager.exportBackupToExternalFolder(
              folderUri: externalFolder,
              fileNames: databaseBackupFileNames,
            );
      }
      return lastReportPath.value;
    }

    final directory = await _reportsDirectory();
    final backupDirectory = Directory('${directory.path}/michifocus-backup');
    if (!backupDirectory.existsSync()) {
      backupDirectory.createSync(recursive: true);
    }

    if (snapshot.existsSync()) {
      await snapshot.copy('${backupDirectory.path}/michifocus.sqlite');
      await snapshot.delete();
    } else {
      for (final fileName in databaseBackupFileNames) {
        final source = File('${appDirectory.path}/$fileName');
        if (!source.existsSync()) {
          continue;
        }
        await source.copy('${backupDirectory.path}/$fileName');
      }
    }

    lastReportPath.value = backupDirectory.path;
    return backupDirectory.path;
  }

  Future<void> stageDatabaseBackupImport(String directoryPath) async {
    final sourceDirectory = Directory(directoryPath.trim());
    if (!sourceDirectory.existsSync()) {
      throw const FileSystemException('La carpeta de backup no existe.');
    }

    final importFiles =
        [...databaseBackupFileNames, ..._legacyDatabaseBackupFileNames]
            .map((fileName) => File('${sourceDirectory.path}/$fileName'))
            .where((file) => file.existsSync())
            .toList(growable: false);

    if (importFiles.isEmpty) {
      throw const FileSystemException(
        'La carpeta no contiene archivos de backup de MichiFocus.',
      );
    }

    final sourceUnifiedDatabase = File(
      '${sourceDirectory.path}/michifocus.sqlite',
    );
    if (sourceUnifiedDatabase.existsSync() &&
        !await _isSQLiteDatabase(sourceUnifiedDatabase)) {
      throw FileSystemException(
        'La base de datos de backup no es un archivo SQLite valido.',
        sourceUnifiedDatabase.path,
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

    final pendingUnifiedDatabase = File(
      '${pendingDirectory.path}/michifocus.sqlite',
    );
    if (pendingUnifiedDatabase.existsSync()) {
      try {
        await _validateUnifiedDatabase(pendingUnifiedDatabase);
      } on Object catch (error) {
        await pendingDirectory.delete(recursive: true);
        throw FileSystemException(
          'La base de datos no es compatible o esta danada: $error',
          sourceUnifiedDatabase.path,
        );
      }
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

    final importsLegacyDatabases = _legacyDatabaseBackupFileNames.any(
      (fileName) => File('${pendingDirectory.path}/$fileName').existsSync(),
    );
    final importsUnifiedDatabase = File(
      '${pendingDirectory.path}/michifocus.sqlite',
    ).existsSync();
    if (importsLegacyDatabases && !importsUnifiedDatabase) {
      final unifiedDatabase = File('${appDirectory.path}/michifocus.sqlite');
      if (unifiedDatabase.existsSync()) {
        await unifiedDatabase.delete();
      }
    }

    for (final fileName in [
      ...databaseBackupFileNames,
      ..._legacyDatabaseBackupFileNames,
    ]) {
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
    if (configuredPath.isNotEmpty &&
        !NativeFileManager.isExternalFolderReference(configuredPath)) {
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

  String? _externalReportsFolderReference() {
    final configuredPath = reportsDirectoryPath.value.trim();
    if (NativeFileManager.isExternalFolderReference(configuredPath)) {
      return configuredPath;
    }

    return null;
  }

  Future<Directory> _applicationDocumentsDirectory() async {
    return _documentsDirectoryOverride ?? getApplicationDocumentsDirectory();
  }

  String _fileName(String path) {
    final normalized = path.replaceAll(r'\', '/');
    return normalized.substring(normalized.lastIndexOf('/') + 1);
  }

  Future<bool> _isSQLiteDatabase(File file) async {
    final randomAccessFile = await file.open();
    try {
      if (await randomAccessFile.length() < 16) {
        return false;
      }

      final header = await randomAccessFile.read(16);
      return ascii.decode(header, allowInvalid: true) ==
          'SQLite format 3\u0000';
    } finally {
      await randomAccessFile.close();
    }
  }

  Future<void> _validateUnifiedDatabase(File file) async {
    final database = MichiFocusDatabase(NativeDatabase(file));
    try {
      final quickCheck = await database
          .customSelect('PRAGMA quick_check')
          .get();
      if (quickCheck.length != 1 ||
          quickCheck.single.data.values.single != 'ok') {
        throw const FormatException('PRAGMA quick_check fallo.');
      }

      final foreignKeyIssues = await database
          .customSelect('PRAGMA foreign_key_check')
          .get();
      if (foreignKeyIssues.isNotEmpty) {
        throw const FormatException('Existen claves foraneas invalidas.');
      }

      final tableRows = await database
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table'",
          )
          .get();
      final tableNames = tableRows
          .map((row) => row.read<String>('name'))
          .toSet();
      const requiredTables = {
        'goals',
        'tasks',
        'pomodoro_sessions',
        'pomodoro_runtime',
        'calendar_events',
        'task_completion_events',
        'reporting_metadata',
      };
      if (!tableNames.containsAll(requiredTables)) {
        throw const FormatException('Faltan tablas requeridas.');
      }

      final versionRow = await database
          .customSelect('PRAGMA user_version')
          .getSingle();
      if (versionRow.read<int>('user_version') != database.schemaVersion) {
        throw const FormatException('Version de esquema no compatible.');
      }

      await database.customStatement(
        'UPDATE pomodoro_runtime '
        'SET is_running = 0, last_tick_at = NULL',
      );
    } finally {
      await database.close();
    }
  }
}

final appSettingsController = AppSettingsController();
