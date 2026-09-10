import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/data/datasources/legacy_database_migrator.dart';
import 'package:pomodoro_app_v1/app/data/datasources/unified_database_validator.dart';
import 'package:pomodoro_app_v1/app/security/encrypted_database_backup_codec.dart';
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
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_bound_key_protector.dart';
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
    this.goalId,
    this.taskId,
    this.pendingCount,
    this.inProgressCount,
    this.completedCount,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? routePath;
  final String? goalId;
  final String? taskId;
  final int? pendingCount;
  final int? inProgressCount;
  final int? completedCount;

  bool get isGoalSummary => goalId != null;
}

class _BackupMasterKeyRecord {
  const _BackupMasterKeyRecord({
    required this.recoveryEnvelope,
    required this.deviceEnvelope,
  });

  final Map<String, Object> recoveryEnvelope;
  final DeviceBoundKeyEnvelope deviceEnvelope;
}

class AppSettingsController {
  AppSettingsController({
    Directory? documentsDirectory,
    EncryptedDatabaseBackupCodec? encryptedDatabaseBackupCodec,
    StatisticsReportDocumentRenderer? statisticsReportRenderer,
    StatisticsReportFileWriter? statisticsReportFileWriter,
  }) : _documentsDirectoryOverride = documentsDirectory,
       _encryptedDatabaseBackupCodec =
           encryptedDatabaseBackupCodec ?? EncryptedDatabaseBackupCodec(),
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
  static const encryptedDatabaseBackupFileName = 'michifocus-backup.michi';
  static const encryptedDatabaseBackupFilePrefix = 'michifocus-backup-';
  static const backupMasterKeyId = 'group_6261636b75705f6d61737465725f7631';

  static const currentOnboardingVersion = 1;

  static const _legacyDatabaseBackupFileNames = [
    'michifocus_goals.sqlite',
    'michifocus_tasks.sqlite',
    'michifocus_pomodoro_sessions.sqlite',
    'michifocus_calendar_events.sqlite',
  ];

  static const _pendingImportDirectoryName = 'michifocus-pending-import';
  static const _stagingImportDirectoryName = 'michifocus-staging-import';
  static const _importCandidateFileName = '.michifocus-import.sqlite';
  static const _preImportFileName = '.michifocus-before-import.sqlite';
  static const _backupMasterKeyFileName = 'michifocus-backup-master-key.json';

  final FlutterSignal<AppThemePreset> themePreset = signal(
    AppThemePreset.natureFocus,
  );
  final FlutterSignal<bool> hasBackupMasterPassword = signal(false);
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
  final FlutterSignal<int> completedOnboardingVersion = signal(0);
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
  final FlutterSignal<double> maximumConcentrationOpacity = signal(1);

  Timer? _timer;
  SettingsRepository? _settingsRepository;
  final Directory? _documentsDirectoryOverride;
  final EncryptedDatabaseBackupCodec _encryptedDatabaseBackupCodec;
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
    completedOnboardingVersion.value = normalized.completedOnboardingVersion;
    enabledStatisticsCharts.value = normalized.enabledStatisticsCharts;
    maximumConcentrationOpacity.value = normalized.maximumConcentrationOpacity;
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
      completedOnboardingVersion: completedOnboardingVersion.value,
      maximumConcentrationOpacity: maximumConcentrationOpacity.value,
    ).normalized();
  }

  Future<void> saveTimerPreferences() async {
    await _settingsRepository?.saveTimerPreferences(timerPreferences);
  }

  bool get shouldShowOnboarding =>
      completedOnboardingVersion.value < currentOnboardingVersion;

  Future<void> completeOnboarding() async {
    completedOnboardingVersion.value = currentOnboardingVersion;
    await saveTimerPreferences();
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

  void setMaximumConcentrationOpacity(double value) {
    maximumConcentrationOpacity.value = value.clamp(0.2, 1);
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
    String? goalId,
    String? taskId,
    int? pendingCount,
    int? inProgressCount,
    int? completedCount,
  }) {
    final createdAt = DateTime.now();
    final next = AppNotification(
      id: createdAt.microsecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: createdAt,
      routePath: routePath,
      goalId: goalId,
      taskId: taskId,
      pendingCount: pendingCount,
      inProgressCount: inProgressCount,
      completedCount: completedCount,
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

    final selectedPattern = completionVibrationPattern.value;
    if (Platform.isAndroid) {
      await NativeFileManager.playCompletionVibration(selectedPattern.name);
      return;
    }

    switch (selectedPattern) {
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
    required Future<void> Function(String targetPath) createDatabaseSnapshot,
  }) async {
    final appDirectory = await _applicationDocumentsDirectory();
    final snapshot = File(
      '${appDirectory.path}/.michifocus-export.sqlite',
    );
    if (snapshot.existsSync()) {
      await snapshot.delete();
    }
    await createDatabaseSnapshot(snapshot.path);
    if (!snapshot.existsSync() || !await _isSQLiteDatabase(snapshot)) {
      throw const FileSystemException(
        'No se pudo crear una instantanea valida de la base de datos.',
      );
    }

    final externalFolder = _externalReportsFolderReference();
    if (externalFolder != null) {
      final saved = await NativeFileManager.saveFileToExternalFolder(
        folderUri: externalFolder,
        fileName: 'michifocus.sqlite',
        mimeType: 'application/vnd.sqlite3',
        bytes: await snapshot.readAsBytes(),
      );
      await snapshot.delete();
      lastReportPath.value = saved.displayPath;
      return lastReportPath.value;
    }

    final directory = await _reportsDirectory();
    final backupDirectory = Directory('${directory.path}/michifocus-backup');
    if (!backupDirectory.existsSync()) {
      backupDirectory.createSync(recursive: true);
    }

    await snapshot.copy('${backupDirectory.path}/michifocus.sqlite');
    await snapshot.delete();

    lastReportPath.value = backupDirectory.path;
    return backupDirectory.path;
  }

  Future<void> loadBackupMasterPasswordState(
    DeviceBoundKeyProtector keyProtector,
  ) async {
    final record = await _readBackupMasterKeyRecord();
    hasBackupMasterPassword.value =
        record != null && await keyProtector.hasKey(backupMasterKeyId);
  }

  Future<void> createBackupMasterPassword({
    required String password,
    required String confirmation,
    required DeviceBoundKeyProtector keyProtector,
  }) async {
    if (password.length < EncryptedDatabaseBackupCodec.minimumPasswordLength) {
      throw const FileSystemException(
        'La clave maestra debe tener al menos 12 caracteres.',
      );
    }
    if (password != confirmation) {
      throw const FileSystemException('Las claves maestras no coinciden.');
    }
    final material = await _encryptedDatabaseBackupCodec.createMasterKey(
      password,
    );
    try {
      final deviceEnvelope = await keyProtector.wrap(
        groupId: backupMasterKeyId,
        clearKey: material.clearKey,
      );
      await _writeBackupMasterKeyRecord(
        recoveryEnvelope: material.recoveryEnvelope,
        deviceEnvelope: deviceEnvelope,
      );
      hasBackupMasterPassword.value = true;
    } on Object {
      hasBackupMasterPassword.value = false;
      rethrow;
    } finally {
      _eraseBytes(material.clearKey);
    }
  }

  Future<String> exportEncryptedDatabaseBackup({
    required Future<void> Function(String targetPath) createDatabaseSnapshot,
    String? password,
    DeviceBoundKeyProtector? keyProtector,
  }) async {
    final record = password == null ? await _readBackupMasterKeyRecord() : null;
    if (password == null && (record == null || keyProtector == null)) {
      throw const FileSystemException(
        'Primero crea la clave maestra de MichiDoro.',
      );
    }
    final appDirectory = await _applicationDocumentsDirectory();
    final snapshot = File('${appDirectory.path}/.michifocus-export.sqlite');
    var clearBytes = <int>[];
    var masterKey = <int>[];
    try {
      if (snapshot.existsSync()) await snapshot.delete();
      await createDatabaseSnapshot(snapshot.path);
      if (!snapshot.existsSync() || !await _isSQLiteDatabase(snapshot)) {
        throw const FileSystemException(
          'No se pudo crear una instantánea válida de la base de datos.',
        );
      }
      clearBytes = await snapshot.readAsBytes();
      final List<int> encryptedBytes;
      if (password != null) {
        encryptedBytes = await _encryptedDatabaseBackupCodec.encrypt(
          databaseBytes: clearBytes,
          password: password,
        );
      } else {
        masterKey = await keyProtector!.unwrap(
          groupId: backupMasterKeyId,
          envelope: record!.deviceEnvelope,
        );
        encryptedBytes = await _encryptedDatabaseBackupCodec
            .encryptWithMasterKey(
              databaseBytes: clearBytes,
              clearKey: masterKey,
              recoveryEnvelope: record.recoveryEnvelope,
            );
      }
      final backupFileName = _newEncryptedBackupFileName();

      final externalFolder = _externalReportsFolderReference();
      if (externalFolder != null) {
        final saved = await NativeFileManager.saveFileToExternalFolder(
          folderUri: externalFolder,
          fileName: backupFileName,
          mimeType: 'application/octet-stream',
          bytes: encryptedBytes,
        );
        lastReportPath.value = saved.displayPath;
        return lastReportPath.value;
      }

      final directory = await _reportsDirectory();
      final backupDirectory = Directory('${directory.path}/michifocus-backup');
      if (!backupDirectory.existsSync()) {
        backupDirectory.createSync(recursive: true);
      }
      await File(
        '${backupDirectory.path}/$backupFileName',
      ).writeAsBytes(encryptedBytes, flush: true);
      lastReportPath.value = backupDirectory.path;
      return backupDirectory.path;
    } finally {
      _eraseBytes(clearBytes);
      _eraseBytes(masterKey);
      if (snapshot.existsSync()) await snapshot.delete();
    }
  }

  Future<void> stageEncryptedDatabaseBackupImport(
    String directoryPath, {
    required String password,
    DeviceBoundKeyProtector? keyProtector,
  }) async {
    final sourceDirectory = Directory(directoryPath.trim());
    final source = _latestEncryptedBackup(sourceDirectory);
    if (!sourceDirectory.existsSync() || source == null) {
      throw const FileSystemException(
        'La carpeta no contiene una copia cifrada de Michi Focus.',
      );
    }

    final appDirectory = await _applicationDocumentsDirectory();
    final pendingDirectory = Directory(
      '${appDirectory.path}/$_pendingImportDirectoryName',
    );
    final stagingDirectory = Directory(
      '${appDirectory.path}/$_stagingImportDirectoryName',
    );
    var clearBytes = <int>[];
    var importedMasterKey = <int>[];
    try {
      DecryptedMasterDatabaseBackup? decrypted;
      if (keyProtector == null) {
        clearBytes = await _encryptedDatabaseBackupCodec.decrypt(
          encryptedBytes: await source.readAsBytes(),
          password: password,
        );
      } else {
        final encryptedBytes = await source.readAsBytes();
        try {
          decrypted = await _encryptedDatabaseBackupCodec
              .decryptWithMasterPassword(
                encryptedBytes: encryptedBytes,
                password: password,
              );
        } on EncryptedDatabaseBackupException {
          final legacyDatabase = await _encryptedDatabaseBackupCodec.decrypt(
            encryptedBytes: encryptedBytes,
            password: password,
          );
          final migratedMaterial = await _encryptedDatabaseBackupCodec
              .createMasterKey(password);
          decrypted = DecryptedMasterDatabaseBackup(
            clearKey: migratedMaterial.clearKey,
            recoveryEnvelope: migratedMaterial.recoveryEnvelope,
            databaseBytes: legacyDatabase,
          );
        }
        clearBytes = decrypted.databaseBytes;
        importedMasterKey = decrypted.clearKey;
      }
      if (stagingDirectory.existsSync()) {
        await stagingDirectory.delete(recursive: true);
      }
      stagingDirectory.createSync(recursive: true);
      final stagedDatabase = File(
        '${stagingDirectory.path}/michifocus.sqlite',
      );
      await stagedDatabase.writeAsBytes(clearBytes, flush: true);
      await const UnifiedDatabaseValidator().validateForImport(stagedDatabase);
      if (keyProtector != null && decrypted != null) {
        final deviceEnvelope = await keyProtector.wrap(
          groupId: backupMasterKeyId,
          clearKey: importedMasterKey,
        );
        await _writeBackupMasterKeyRecord(
          recoveryEnvelope: decrypted.recoveryEnvelope,
          deviceEnvelope: deviceEnvelope,
        );
      }
      if (pendingDirectory.existsSync()) {
        await pendingDirectory.delete(recursive: true);
      }
      await stagingDirectory.rename(pendingDirectory.path);
      if (keyProtector != null) hasBackupMasterPassword.value = true;
      lastReportPath.value = pendingDirectory.path;
    } on EncryptedDatabaseBackupException {
      if (stagingDirectory.existsSync()) {
        await stagingDirectory.delete(recursive: true);
      }
      throw const FileSystemException(
        'Contraseña incorrecta o copia de seguridad alterada.',
      );
    } on FileSystemException {
      if (stagingDirectory.existsSync()) {
        await stagingDirectory.delete(recursive: true);
      }
      rethrow;
    } on Object catch (error) {
      if (stagingDirectory.existsSync()) {
        await stagingDirectory.delete(recursive: true);
      }
      throw FileSystemException(
        'La copia no es compatible o está dañada: $error',
        source.path,
      );
    } finally {
      _eraseBytes(clearBytes);
      _eraseBytes(importedMasterKey);
    }
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

    final hasUnifiedDatabase = importFiles.any(
      (file) => _fileName(file.path) == 'michifocus.sqlite',
    );
    final legacyFileCount = importFiles
        .where(
          (file) =>
              _legacyDatabaseBackupFileNames.contains(_fileName(file.path)),
        )
        .length;
    if (!hasUnifiedDatabase &&
        legacyFileCount != _legacyDatabaseBackupFileNames.length) {
      throw const FileSystemException(
        'El backup legacy esta incompleto: se requieren sus cuatro bases de datos.',
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
    final stagingDirectory = Directory(
      '${appDirectory.path}/$_stagingImportDirectoryName',
    );
    if (stagingDirectory.existsSync()) {
      await stagingDirectory.delete(recursive: true);
    }
    stagingDirectory.createSync(recursive: true);

    for (final source in importFiles) {
      await source.copy('${stagingDirectory.path}/${_fileName(source.path)}');
    }

    final stagedUnifiedDatabase = File(
      '${stagingDirectory.path}/michifocus.sqlite',
    );
    try {
      if (!stagedUnifiedDatabase.existsSync()) {
        await LegacyDatabaseMigrator.migrateIfNeeded(
          directoryOverride: stagingDirectory,
        );
      }
      if (!stagedUnifiedDatabase.existsSync()) {
        throw const FormatException(
          'No se pudo convertir el backup legacy.',
        );
      }
      await const UnifiedDatabaseValidator().validateForImport(
        stagedUnifiedDatabase,
      );
    } on Object catch (error) {
      await stagingDirectory.delete(recursive: true);
      throw FileSystemException(
        'La base de datos no es compatible o esta danada: $error',
        sourceUnifiedDatabase.path,
      );
    }

    if (pendingDirectory.existsSync()) {
      await pendingDirectory.delete(recursive: true);
    }
    await stagingDirectory.rename(pendingDirectory.path);

    lastReportPath.value = pendingDirectory.path;
  }

  void _eraseBytes(List<int> bytes) {
    for (var index = 0; index < bytes.length; index++) {
      bytes[index] = 0;
    }
  }

  String _newEncryptedBackupFileName() {
    final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
    return '$encryptedDatabaseBackupFilePrefix$timestamp.michi';
  }

  File? _latestEncryptedBackup(Directory directory) {
    if (!directory.existsSync()) return null;
    final candidates =
        directory
            .listSync()
            .whereType<File>()
            .where((file) {
              final name = _fileName(file.path);
              return name == encryptedDatabaseBackupFileName ||
                  (name.startsWith(encryptedDatabaseBackupFilePrefix) &&
                      name.endsWith('.michi'));
            })
            .toList(growable: false)
          ..sort((left, right) => right.path.compareTo(left.path));
    return candidates.firstOrNull;
  }

  Future<bool> applyPendingDatabaseImport() async {
    final appDirectory = await _applicationDocumentsDirectory();
    final liveDatabase = File('${appDirectory.path}/michifocus.sqlite');
    final candidateDatabase = File(
      '${appDirectory.path}/$_importCandidateFileName',
    );
    final previousDatabase = File(
      '${appDirectory.path}/$_preImportFileName',
    );
    final pendingDirectory = Directory(
      '${appDirectory.path}/$_pendingImportDirectoryName',
    );
    final stagingDirectory = Directory(
      '${appDirectory.path}/$_stagingImportDirectoryName',
    );
    if (stagingDirectory.existsSync()) {
      await stagingDirectory.delete(recursive: true);
    }

    if (previousDatabase.existsSync()) {
      if (liveDatabase.existsSync()) {
        await previousDatabase.delete();
        if (pendingDirectory.existsSync()) {
          await pendingDirectory.delete(recursive: true);
        }
        if (candidateDatabase.existsSync()) {
          await candidateDatabase.delete();
        }
        return true;
      }
      await previousDatabase.rename(liveDatabase.path);
    }
    if (candidateDatabase.existsSync()) {
      await candidateDatabase.delete();
    }
    if (!pendingDirectory.existsSync()) {
      return false;
    }

    final pendingDatabase = File(
      '${pendingDirectory.path}/michifocus.sqlite',
    );
    if (!pendingDatabase.existsSync()) {
      throw const FileSystemException(
        'La importacion preparada no contiene michifocus.sqlite.',
      );
    }

    await pendingDatabase.copy(candidateDatabase.path);
    await const UnifiedDatabaseValidator().validateForImport(
      candidateDatabase,
    );

    try {
      if (liveDatabase.existsSync()) {
        await liveDatabase.rename(previousDatabase.path);
      }
      await candidateDatabase.rename(liveDatabase.path);
    } on Object {
      if (!liveDatabase.existsSync() && previousDatabase.existsSync()) {
        await previousDatabase.rename(liveDatabase.path);
      }
      if (candidateDatabase.existsSync()) {
        await candidateDatabase.delete();
      }
      rethrow;
    }

    if (previousDatabase.existsSync()) {
      await previousDatabase.delete();
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

  Future<_BackupMasterKeyRecord?> _readBackupMasterKeyRecord() async {
    try {
      final directory = await _applicationDocumentsDirectory();
      final file = File('${directory.path}/$_backupMasterKeyFileName');
      if (!file.existsSync()) return null;
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic> ||
          decoded['version'] != 1 ||
          decoded['recovery'] is! Map<String, dynamic> ||
          decoded['deviceEnvelope'] is! Map<String, dynamic>) {
        return null;
      }
      return _BackupMasterKeyRecord(
        recoveryEnvelope: Map<String, Object>.from(
          decoded['recovery'] as Map<String, dynamic>,
        ),
        deviceEnvelope: DeviceBoundKeyEnvelope.fromJson(
          decoded['deviceEnvelope'] as Map<String, dynamic>,
        ),
      );
    } on Object {
      return null;
    }
  }

  Future<void> _writeBackupMasterKeyRecord({
    required Map<String, Object> recoveryEnvelope,
    required DeviceBoundKeyEnvelope deviceEnvelope,
  }) async {
    final directory = await _applicationDocumentsDirectory();
    directory.createSync(recursive: true);
    final destination = File(
      '${directory.path}/$_backupMasterKeyFileName',
    );
    final temporary = File('${destination.path}.pending');
    final previous = File('${destination.path}.previous');
    if (temporary.existsSync()) await temporary.delete();
    if (previous.existsSync()) await previous.delete();
    await temporary.writeAsString(
      jsonEncode(<String, Object>{
        'version': 1,
        'recovery': recoveryEnvelope,
        'deviceEnvelope': deviceEnvelope.toJson(),
      }),
      flush: true,
    );
    try {
      if (destination.existsSync()) await destination.rename(previous.path);
      await temporary.rename(destination.path);
      if (previous.existsSync()) await previous.delete();
    } on Object {
      if (!destination.existsSync() && previous.existsSync()) {
        await previous.rename(destination.path);
      }
      if (temporary.existsSync()) await temporary.delete();
      rethrow;
    }
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
}

final appSettingsController = AppSettingsController();
