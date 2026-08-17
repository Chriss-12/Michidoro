import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/router/app_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/state/pomodoro_runtime_scope.dart';
import 'package:pomodoro_app_v1/app/state/routine_reminder_scheduler.dart';
import 'package:pomodoro_app_v1/app/state/scheduled_task_reminder_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_file.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pomodoro_app_v1/features/splash/presentation/pages/splash_page.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/device_identity_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/local_app_lock_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/device_identity_scope.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/local_app_lock_gate.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/local_app_lock_scope.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_group_enrollment_scope.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_storage_scope.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:signals_flutter/signals_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({
    this.startupAuthenticator,
    this.initializeApp,
    this.initializedApp,
    super.key,
  });

  final LocalDeviceAuthenticator? startupAuthenticator;
  final Future<void> Function()? initializeApp;
  final Widget? initializedApp;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final LocalDeviceAuthenticator _startupAuthenticator;
  Future<void>? _initialization;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _startupAuthenticator =
        widget.startupAuthenticator ?? const AndroidLocalDeviceAuthenticator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_requestStartupAuthentication());
    });
  }

  Future<void> _startInitialization() {
    return (widget.initializeApp ?? _initializeApp)().timeout(
      const Duration(seconds: 30),
    );
  }

  Future<void> _requestStartupAuthentication() async {
    if (_isAuthenticating || _initialization != null) return;

    setState(() => _isAuthenticating = true);
    var authenticated = false;
    try {
      if (await _startupAuthenticator.isAvailable()) {
        authenticated = await _startupAuthenticator.authenticate();
      }
    } on Object {
      authenticated = false;
    }

    if (!mounted) return;
    setState(() {
      _isAuthenticating = false;
      if (authenticated) {
        _initialization = _startInitialization();
      }
    });
  }

  Future<void> _initializeApp() async {
    await appSettingsController.applyPendingDatabaseImport();
    await configureDependencies();
    final localAppLockController = serviceLocator<LocalAppLockController>();
    await localAppLockController.loadPolicy();
    localAppLockController.authenticationSucceeded();
    await serviceLocator<SyncStorageController>().load();
    await serviceLocator<DeviceIdentityController>().initialize();
    await serviceLocator<SyncGroupEnrollmentController>().load();
    final routinesController = serviceLocator<RoutinesController>();
    final reconciliation = await routinesController.reconcileToday();
    if (reconciliation == null) {
      throw StateError('Routine reconciliation failed during startup.');
    }
    await serviceLocator<TasksController>().loadTasks();
    await appSettingsController.loadTimerPreferences(
      serviceLocator<SettingsRepository>(),
    );
    serviceLocator<PomodoroController>().setFocusMinutes(
      appSettingsController.focusMinutes.value,
    );
    _syncPomodoroBreakSettings(
      pomodoroController: serviceLocator<PomodoroController>(),
      settingsController: appSettingsController,
    );
  }

  void _retry() {
    setState(() => _initialization = _startInitialization());
  }

  @override
  Widget build(BuildContext context) {
    final initialization = _initialization;
    if (initialization == null) {
      return _StartupAuthenticationApp(
        isAuthenticating: _isAuthenticating,
        onUnlockRequested: () => unawaited(_requestStartupAuthentication()),
      );
    }

    return FutureBuilder<void>(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _StartupFailureApp(onRetry: _retry);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return widget.initializedApp ?? const MyApp();
        }

        return const _StartupSplashApp();
      },
    );
  }
}

class _StartupAuthenticationApp extends StatelessWidget {
  const _StartupAuthenticationApp({
    required this.isAuthenticating,
    required this.onUnlockRequested,
  });

  final bool isAuthenticating;
  final VoidCallback onUnlockRequested;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: appSettingsController.language.value.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: AppTheme.fromPreset(AppThemePreset.natureFocus, isDark: false),
      home: LocalAppLockGate(
        isLocked: true,
        onUnlockRequested: isAuthenticating ? null : onUnlockRequested,
        child: const SizedBox.shrink(),
      ),
    );
  }
}

class _StartupSplashApp extends StatelessWidget {
  const _StartupSplashApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: appSettingsController.language.value.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: AppTheme.fromPreset(AppThemePreset.natureFocus, isDark: false),
      home: const SplashPage(autoNavigate: false),
    );
  }
}

class _StartupFailureApp extends StatelessWidget {
  const _StartupFailureApp({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromPreset(
      AppThemePreset.natureFocus,
      isDark: false,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: appSettingsController.language.value.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: theme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.tr(
                    'No se pudo iniciar MichiDoro',
                    'MichiDoro could not start',
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  context.tr(
                    'Reintenta el arranque. Si vuelve a pasar, revisamos el log del dispositivo.',
                    'Try starting again. If it happens again, check the device log.',
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: onRetry,
                  child: Text(context.tr('Reintentar', 'Try again')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    this.localAppLockController,
    this.deviceIdentityController,
    this.syncGroupEnrollmentController,
    this.syncStorageController,
    super.key,
  });

  final LocalAppLockController? localAppLockController;
  final DeviceIdentityController? deviceIdentityController;
  final SyncGroupEnrollmentController? syncGroupEnrollmentController;
  final SyncStorageController? syncStorageController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final ScheduledTaskReminderController _scheduledTaskReminders;
  RoutineReminderScheduler? _routineReminders;
  Timer? _routineRolloverTimer;
  late final LocalAppLockController _localAppLockController;
  late final DeviceIdentityController _deviceIdentityController;
  late final SyncGroupEnrollmentController _syncGroupEnrollmentController;
  late final SyncStorageController _syncStorageController;

  @override
  void initState() {
    super.initState();
    _localAppLockController =
        widget.localAppLockController ??
        serviceLocator<LocalAppLockController>();
    _syncStorageController =
        widget.syncStorageController ??
        (serviceLocator.isRegistered<SyncStorageController>()
            ? serviceLocator<SyncStorageController>()
            : SyncStorageController());
    _deviceIdentityController =
        widget.deviceIdentityController ??
        (serviceLocator.isRegistered<DeviceIdentityController>()
            ? serviceLocator<DeviceIdentityController>()
            : DeviceIdentityController());
    _syncGroupEnrollmentController =
        widget.syncGroupEnrollmentController ??
        (serviceLocator.isRegistered<SyncGroupEnrollmentController>()
            ? serviceLocator<SyncGroupEnrollmentController>()
            : SyncGroupEnrollmentController());
    WidgetsBinding.instance.addObserver(this);
    _scheduledTaskReminders = ScheduledTaskReminderController(
      settingsController: appSettingsController,
      tasksController: serviceLocator<TasksController>(),
    )..start();
    if (serviceLocator.isRegistered<RoutinesController>()) {
      final routinesController = serviceLocator<RoutinesController>();
      _routineReminders = RoutineReminderScheduler(
        routinesController: routinesController,
        settingsController: appSettingsController,
      );
      routinesController.onReminderScheduleChanged =
          _routineReminders!.synchronize;
      unawaited(_routineReminders!.synchronize());
      _scheduleRoutineRollover();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scheduledTaskReminders.stop();
    _routineRolloverTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final pomodoroController = serviceLocator<PomodoroController>();
    if (state != AppLifecycleState.resumed) {
      _localAppLockController.onBackgrounded();
      unawaited(pomodoroController.checkpointRuntime());
      return;
    }

    _localAppLockController.onResumed();
    unawaited(pomodoroController.synchronizeWithClock());
    unawaited(_reconcileRoutineTasks());
    _scheduleRoutineRollover();
  }

  Future<void> _reconcileRoutineTasks() async {
    if (!serviceLocator.isRegistered<RoutinesController>()) return;
    await serviceLocator<RoutinesController>().reconcileToday();
    await serviceLocator<TasksController>().loadTasks();
    await _routineReminders?.synchronize();
  }

  Future<void> _requestLocalUnlock() async {
    await _localAppLockController.requestUnlock();
  }

  Future<void> _deleteAllDatabaseData() async {
    final pomodoroController = serviceLocator<PomodoroController>()
      ..stopForDatabaseReset();

    try {
      await serviceLocator<MichiFocusDatabase>().clearAllUserData();
    } on Object {
      await pomodoroController.initialize();
      rethrow;
    }

    pomodoroController.resetAfterDatabaseClear();
    await Future.wait([
      serviceLocator<GoalsController>().loadGoals(),
      serviceLocator<TasksController>().loadTasks(),
      serviceLocator<CalendarController>().loadEvents(),
      if (serviceLocator.isRegistered<RoutinesController>())
        serviceLocator<RoutinesController>().load(),
    ]);
    await _routineReminders?.synchronize();
  }

  void _scheduleRoutineRollover() {
    _routineRolloverTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _routineRolloverTimer = Timer(nextMidnight.difference(now), () async {
      await _reconcileRoutineTasks();
      if (mounted) _scheduleRoutineRollover();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = appSettingsController;
    final goalsController = serviceLocator<GoalsController>();
    final tasksController = serviceLocator<TasksController>();
    final routinesController = serviceLocator.isRegistered<RoutinesController>()
        ? serviceLocator<RoutinesController>()
        : null;
    final pomodoroController = serviceLocator<PomodoroController>()
      ..onSessionCompleted = controller.playCompletionFeedback
      ..onBreakCompleted = controller.playCompletionFeedback
      ..onGoalPomodoroCompleted = goalsController.incrementProgress
      ..onTaskFocusStarted = (String taskId) async {
        await tasksController.updateTaskStatus(taskId, TaskStatus.inProgress);
        await routinesController?.refreshTodayProgress();
      }
      ..onTaskPlanCompleted = (String taskId) async {
        await tasksController.updateTaskStatus(taskId, TaskStatus.completed);
        await routinesController?.refreshTodayProgress();
      };
    goalsController.onGoalDeleted = pomodoroController.clearSelectedGoal;

    return SignalBuilder(
      builder: (context) {
        final themePreset = controller.themePreset.value;
        final isDarkMode = controller.isDarkMode.value;
        final fontScale = controller.fontScale.value;
        final typographyPreset = controller.typographyPreset.value;
        final language = controller.language.value;
        final isLocallyLocked = _localAppLockController.isLocked.value;

        return MaterialApp.router(
          locale: language.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            final routeChild = child ?? const SizedBox.shrink();

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: AppTheme.systemOverlayStyle(
                themePreset,
                isDark: isDarkMode,
              ),
              child: ResponsiveBreakpoints.builder(
                child: SignalBuilder(
                  builder: (context) {
                    if (isLocallyLocked) {
                      return LocalAppLockGate(
                        isLocked: true,
                        onUnlockRequested: () => unawaited(
                          _requestLocalUnlock(),
                        ),
                        child: const SizedBox.shrink(),
                      );
                    }

                    final settingsScope = AppSettingsScope(
                      themePreset: controller.themePreset.value,
                      isDarkMode: controller.isDarkMode.value,
                      fontScale: controller.fontScale.value,
                      profileName: controller.profileName.value,
                      profileEmail: controller.profileEmail.value,
                      profileImagePath: controller.profileImagePath.value,
                      avatarIndex: controller.avatarIndex.value,
                      typographyPreset: controller.typographyPreset.value,
                      language: controller.language.value,
                      completedOnboardingVersion:
                          controller.completedOnboardingVersion.value,
                      focusMinutes: controller.focusMinutes.value,
                      shortBreakMinutes: controller.shortBreakMinutes.value,
                      longBreakMinutes: controller.longBreakMinutes.value,
                      longBreakFrequency: controller.longBreakFrequency.value,
                      completionSound: controller.completionSound.value,
                      completionVibrationEnabled:
                          controller.completionVibrationEnabled.value,
                      completionVibrationPattern:
                          controller.completionVibrationPattern.value,
                      autoStartBreak: controller.autoStartBreak.value,
                      autoStartFocus: controller.autoStartFocus.value,
                      notificationsEnabled:
                          controller.notificationsEnabled.value,
                      breakAlertsEnabled: controller.breakAlertsEnabled.value,
                      focusAlertsEnabled: controller.focusAlertsEnabled.value,
                      completedTasks: controller.completedTasks.value,
                      totalTasks: controller.totalTasks.value,
                      lastReportPath: controller.lastReportPath.value,
                      reportsDirectoryPath:
                          controller.reportsDirectoryPath.value,
                      enabledStatisticsCharts:
                          controller.enabledStatisticsCharts.value,
                      notifications: controller.notifications.value,
                      onThemeChanged: (value) {
                        controller.themePreset.value = value;
                        unawaited(controller.saveTimerPreferences());
                      },
                      onDarkModeChanged: (value) {
                        controller.isDarkMode.value = value;
                        unawaited(controller.saveTimerPreferences());
                      },
                      onFontScaleChanged: (value) {
                        controller.fontScale.value =
                            SettingsController.normalizeFontScale(value);
                        unawaited(controller.saveTimerPreferences());
                      },
                      onProfileNameChanged: (value) {
                        controller.setProfileName(value);
                        unawaited(controller.saveTimerPreferences());
                      },
                      onProfileEmailChanged: (value) {
                        controller.setProfileEmail(value);
                        unawaited(controller.saveTimerPreferences());
                      },
                      onProfileImagePathChanged: (value) {
                        controller.setProfileImagePath(value);
                        unawaited(controller.saveTimerPreferences());
                      },
                      onAvatarChanged: (value) {
                        controller.setAvatarIndex(value);
                        unawaited(controller.saveTimerPreferences());
                      },
                      onTypographyPresetChanged: (value) {
                        controller.selectedTypographyPreset = value;
                        unawaited(controller.saveTimerPreferences());
                      },
                      onLanguageChanged: (value) {
                        controller.language.value = value;
                        unawaited(controller.saveTimerPreferences());
                      },
                      onCompleteOnboarding: controller.completeOnboarding,
                      onFocusMinutesChanged: (value) {
                        controller.setFocusMinutes(value);
                        pomodoroController.setFocusMinutes(value);
                        unawaited(controller.saveTimerPreferences());
                      },
                      onShortBreakMinutesChanged: (value) {
                        controller.setShortBreakMinutes(value);
                        _syncPomodoroBreakSettings(
                          pomodoroController: pomodoroController,
                          settingsController: controller,
                        );
                        unawaited(controller.saveTimerPreferences());
                      },
                      onLongBreakMinutesChanged: (value) {
                        controller.setLongBreakMinutes(value);
                        _syncPomodoroBreakSettings(
                          pomodoroController: pomodoroController,
                          settingsController: controller,
                        );
                        unawaited(controller.saveTimerPreferences());
                      },
                      onLongBreakFrequencyChanged: (value) {
                        controller.setLongBreakFrequency(value);
                        _syncPomodoroBreakSettings(
                          pomodoroController: pomodoroController,
                          settingsController: controller,
                        );
                        unawaited(controller.saveTimerPreferences());
                      },
                      onCompletionSoundChanged: (value) {
                        controller.selectedCompletionSound = value;
                        unawaited(controller.saveTimerPreferences());
                      },
                      onPreviewCompletionSound:
                          controller.previewCompletionSound,
                      onCompletionVibrationChanged: (value) {
                        controller.isCompletionVibrationEnabled = value;
                        unawaited(controller.saveTimerPreferences());
                      },
                      onCompletionVibrationPatternChanged: (value) {
                        controller.selectedCompletionVibrationPattern = value;
                        unawaited(controller.saveTimerPreferences());
                      },
                      onPreviewCompletionVibration:
                          controller.previewCompletionVibration,
                      onAutoStartBreakChanged: (value) {
                        controller.autoStartBreak.value = value;
                        _syncPomodoroBreakSettings(
                          pomodoroController: pomodoroController,
                          settingsController: controller,
                        );
                        unawaited(controller.saveTimerPreferences());
                      },
                      onAutoStartFocusChanged: (value) {
                        controller.autoStartFocus.value = value;
                        _syncPomodoroBreakSettings(
                          pomodoroController: pomodoroController,
                          settingsController: controller,
                        );
                        unawaited(controller.saveTimerPreferences());
                      },
                      onReportsDirectoryPathChanged: (value) {
                        controller.setReportsDirectoryPath(value);
                        unawaited(controller.saveTimerPreferences());
                      },
                      onUseDefaultReportsDirectory:
                          controller.useDefaultReportsDirectory,
                      onStatisticsChartVisibilityChanged:
                          (chart, {required enabled}) {
                            controller.setStatisticsChartEnabled(
                              chart,
                              enabled: enabled,
                            );
                            unawaited(controller.saveTimerPreferences());
                          },
                      onNotificationsEnabledChanged: (value) {
                        controller.notificationsEnabled.value = value;
                        unawaited(_routineReminders?.synchronize());
                      },
                      onBreakAlertsEnabledChanged: (value) =>
                          controller.breakAlertsEnabled.value = value,
                      onFocusAlertsEnabledChanged: (value) {
                        controller.focusAlertsEnabled.value = value;
                        unawaited(_routineReminders?.synchronize());
                      },
                      onDownloadReport: () => _downloadStatisticsPdf(
                        settingsController: controller,
                        request: const StatisticsReportRequest(
                          period: StatisticsReportPeriod.month,
                        ),
                      ),
                      onDownloadStatisticsPdf: (request) =>
                          _downloadStatisticsPdf(
                            settingsController: controller,
                            request: request,
                          ),
                      onOpenReport: controller.openReport,
                      onExportDatabaseBackup: () async {
                        await pomodoroController.checkpointRuntime();
                        return controller.exportDatabaseBackup(
                          createDatabaseSnapshot:
                              serviceLocator<MichiFocusDatabase>()
                                  .createBackupSnapshot,
                        );
                      },
                      onImportDatabaseBackup:
                          controller.stageDatabaseBackupImport,
                      onDeleteAllDatabaseData: _deleteAllDatabaseData,
                      onTestNotification: controller.sendTestNotification,
                      onClearNotifications: controller.clearNotifications,
                      child: SyncStorageScope(
                        controller: _syncStorageController,
                        child: SyncGroupEnrollmentScope(
                          controller: _syncGroupEnrollmentController,
                          child: DeviceIdentityScope(
                            controller: _deviceIdentityController,
                            child: LocalAppLockScope(
                              controller: _localAppLockController,
                              child: routeChild,
                            ),
                          ),
                        ),
                      ),
                    );

                    return SignalBuilder(
                      builder: (context) {
                        return PomodoroRuntimeScope(
                          isRunning: pomodoroController.isRunning.value,
                          phase: pomodoroController.phase.value,
                          remainingSeconds:
                              pomodoroController.remainingSeconds.value,
                          currentPhaseSeconds:
                              pomodoroController.currentPhaseSeconds,
                          timerProgress: pomodoroController.timerProgress,
                          completedPomodoros:
                              pomodoroController.completedPomodoros.value,
                          totalFocusSeconds:
                              pomodoroController.totalFocusSeconds.value,
                          hasActiveRuntime:
                              pomodoroController.hasActiveRuntime.value,
                          hasStartedRuntime:
                              pomodoroController.hasStartedRuntime.value,
                          planMode: pomodoroController.planMode.value,
                          currentBlockIndex:
                              pomodoroController.currentBlockIndex.value,
                          totalBlocks: pomodoroController.totalBlocks.value,
                          taskFocusedSeconds:
                              pomodoroController.elapsedTaskFocusSeconds,
                          taskEstimatedSeconds: pomodoroController
                              .activeTaskEstimatedSeconds
                              .value,
                          cadenceBreakMinutes:
                              pomodoroController.cadenceBreakMinutes,
                          onPlayPause: () {
                            if (pomodoroController.isRunning.value) {
                              pomodoroController.pause();
                              return;
                            }
                            pomodoroController.start();
                          },
                          onReset: pomodoroController.reset,
                          onDiscard: pomodoroController.discardSession,
                          onRestart: pomodoroController.restartSession,
                          onFinishEarly: pomodoroController.finishEarly,
                          onStopForNow: pomodoroController.stopForNow,
                          child: settingsScope,
                        );
                      },
                    );
                  },
                ),
                breakpoints: const [
                  Breakpoint(start: 0, end: 450, name: MOBILE),
                  Breakpoint(start: 451, end: 800, name: TABLET),
                  Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                ],
              ),
            );
          },
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: AppTheme.fromPreset(
            themePreset,
            isDark: isDarkMode,
            fontScale: fontScale,
            typographyPreset: typographyPreset,
          ),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

void _syncPomodoroBreakSettings({
  required PomodoroController pomodoroController,
  required AppSettingsController settingsController,
}) {
  pomodoroController.configureBreaks(
    shortBreakMinutes: settingsController.shortBreakMinutes.value,
    longBreakMinutes: settingsController.longBreakMinutes.value,
    longBreakFrequency: settingsController.longBreakFrequency.value,
    autoStartBreak: settingsController.autoStartBreak.value,
    autoStartFocus: settingsController.autoStartFocus.value,
  );
}

Future<StatisticsReportFile> _downloadStatisticsPdf({
  required AppSettingsController settingsController,
  required StatisticsReportRequest request,
}) async {
  return settingsController.downloadStatisticsPdf(
    request,
    await serviceLocator<GenerateStatisticsReport>()(request),
  );
}
