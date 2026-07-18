import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/router/app_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/state/pomodoro_runtime_scope.dart';
import 'package:pomodoro_app_v1/app/state/scheduled_task_reminder_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pomodoro_app_v1/features/splash/presentation/pages/splash_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:signals_flutter/signals_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late Future<void> _initialization = _startInitialization();

  Future<void> _startInitialization() {
    return _initializeApp().timeout(const Duration(seconds: 30));
  }

  Future<void> _initializeApp() async {
    await appSettingsController.applyPendingDatabaseImport();
    await configureDependencies();
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
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _StartupFailureApp(onRetry: _retry);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        return const _StartupSplashApp();
      },
    );
  }
}

class _StartupSplashApp extends StatelessWidget {
  const _StartupSplashApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro',
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
      title: 'Pomodoro',
      theme: theme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No se pudo iniciar MichiDoro',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Reintenta el arranque. Si vuelve a pasar, revisamos el log del dispositivo.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ScheduledTaskReminderController _scheduledTaskReminders;

  @override
  void initState() {
    super.initState();
    _scheduledTaskReminders = ScheduledTaskReminderController(
      settingsController: appSettingsController,
      tasksController: serviceLocator<TasksController>(),
    )..start();
  }

  @override
  void dispose() {
    _scheduledTaskReminders.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = appSettingsController;
    final goalsController = serviceLocator<GoalsController>();
    final tasksController = serviceLocator<TasksController>();
    final pomodoroController = serviceLocator<PomodoroController>()
      ..onSessionCompleted = controller.playCompletionFeedback
      ..onBreakCompleted = controller.playCompletionFeedback
      ..onGoalPomodoroCompleted = goalsController.incrementProgress;
    goalsController.onGoalDeleted = pomodoroController.clearSelectedGoal;

    return SignalBuilder(
      builder: (context) {
        final themePreset = controller.themePreset.value;
        final isDarkMode = controller.isDarkMode.value;
        final fontScale = controller.fontScale.value;
        final typographyPreset = controller.typographyPreset.value;

        return MaterialApp.router(
          builder: (context, child) {
            final routeChild = child ?? const SizedBox.shrink();

            return ResponsiveBreakpoints.builder(
              child: SignalBuilder(
                builder: (context) {
                  final settingsScope = AppSettingsScope(
                    themePreset: controller.themePreset.value,
                    isDarkMode: controller.isDarkMode.value,
                    fontScale: controller.fontScale.value,
                    profileName: controller.profileName.value,
                    profileEmail: controller.profileEmail.value,
                    profileImagePath: controller.profileImagePath.value,
                    avatarIndex: controller.avatarIndex.value,
                    typographyPreset: controller.typographyPreset.value,
                    focusMinutes: controller.focusMinutes.value,
                    shortBreakMinutes: controller.shortBreakMinutes.value,
                    longBreakMinutes: controller.longBreakMinutes.value,
                    longBreakFrequency: controller.longBreakFrequency.value,
                    completionSound: controller.completionSound.value,
                    completionVibrationEnabled:
                        controller.completionVibrationEnabled.value,
                    autoStartBreak: controller.autoStartBreak.value,
                    autoStartFocus: controller.autoStartFocus.value,
                    notificationsEnabled: controller.notificationsEnabled.value,
                    breakAlertsEnabled: controller.breakAlertsEnabled.value,
                    focusAlertsEnabled: controller.focusAlertsEnabled.value,
                    completedTasks: controller.completedTasks.value,
                    totalTasks: controller.totalTasks.value,
                    lastReportPath: controller.lastReportPath.value,
                    reportsDirectoryPath: controller.reportsDirectoryPath.value,
                    enabledStatisticsCharts:
                        controller.enabledStatisticsCharts.value,
                    notifications: controller.notifications.value,
                    onThemeChanged: (value) =>
                        controller.themePreset.value = value,
                    onDarkModeChanged: (value) =>
                        controller.isDarkMode.value = value,
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
                    onPreviewCompletionSound: controller.previewCompletionSound,
                    onCompletionVibrationChanged: (value) {
                      controller.isCompletionVibrationEnabled = value;
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
                    onNotificationsEnabledChanged: (value) =>
                        controller.notificationsEnabled.value = value,
                    onBreakAlertsEnabledChanged: (value) =>
                        controller.breakAlertsEnabled.value = value,
                    onFocusAlertsEnabledChanged: (value) =>
                        controller.focusAlertsEnabled.value = value,
                    onDownloadReport: controller.downloadReport,
                    onDownloadStatisticsPdf: (request) =>
                        _downloadStatisticsPdf(
                          settingsController: controller,
                          tasksController: tasksController,
                          pomodoroController: pomodoroController,
                          request: request,
                        ),
                    onExportDatabaseBackup: controller.exportDatabaseBackup,
                    onImportDatabaseBackup:
                        controller.stageDatabaseBackupImport,
                    onTestNotification: controller.sendTestNotification,
                    onClearNotifications: controller.clearNotifications,
                    child: routeChild,
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
                        completedPomodoros:
                            pomodoroController.completedPomodoros.value,
                        totalFocusSeconds:
                            pomodoroController.totalFocusSeconds.value,
                        onPlayPause: () {
                          if (pomodoroController.isRunning.value) {
                            pomodoroController.pause();
                            return;
                          }

                          if (pomodoroController.currentPhase ==
                              PomodoroPhase.focus) {
                            unawaited(
                              _updateActiveTaskStatus(
                                pomodoroController: pomodoroController,
                                tasksController: tasksController,
                                status: TaskStatus.inProgress,
                              ),
                            );
                          }
                          pomodoroController.start();
                        },
                        onReset: pomodoroController.reset,
                        onDiscard: pomodoroController.discardSession,
                        onRestart: () {
                          unawaited(
                            _updateActiveTaskStatus(
                              pomodoroController: pomodoroController,
                              tasksController: tasksController,
                              status: TaskStatus.inProgress,
                            ),
                          );
                          pomodoroController.restartSession();
                        },
                        onFinishEarly: () async {
                          final wasFocus =
                              pomodoroController.currentPhase ==
                              PomodoroPhase.focus;
                          await pomodoroController.finishEarly();
                          if (wasFocus) {
                            await _updateActiveTaskStatus(
                              pomodoroController: pomodoroController,
                              tasksController: tasksController,
                              status: TaskStatus.completed,
                            );
                          }
                        },
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
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Pomodoro',
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

Future<void> _updateActiveTaskStatus({
  required PomodoroController pomodoroController,
  required TasksController tasksController,
  required TaskStatus status,
}) async {
  final taskId = pomodoroController.selectedTaskId;
  if (taskId == null) {
    return;
  }

  await tasksController.updateTaskStatus(taskId, status);
}

Future<void> _downloadStatisticsPdf({
  required AppSettingsController settingsController,
  required TasksController tasksController,
  required PomodoroController pomodoroController,
  required StatisticsReportRequest request,
}) async {
  final range = _statisticsRangeForRequest(request, DateTime.now());
  final tasks = tasksController.tasks.value
      .where((task) => _taskFallsInRange(task, range.start, range.end))
      .toList(growable: false);
  final taskSummary = TaskStatusSummary.fromTasks(tasks);
  final sessions = pomodoroController.sessions.value.where(
    (session) => _sessionFallsInRange(session, range.start, range.end),
  );
  final focusedSeconds = sessions.fold<int>(
    0,
    (total, session) => total + session.focusedSeconds,
  );
  final calendarDays = _daysInRange(range.start, range.end)
      .map((day) {
        final progress = tasksController.progressForDay(day);

        return StatisticsCalendarDay(
          day: day,
          completionRatio: progress.completionRatio,
          isEnded: progress.isEnded,
          totalTasks: progress.summary.total,
        );
      })
      .toList(growable: false);

  await settingsController.downloadStatisticsPdf(
    request,
    StatisticsReportData(
      tasks: StatisticsTaskTotals(
        listed: taskSummary.listed,
        inProgress: taskSummary.inProgress,
        completed: taskSummary.completed,
      ),
      calendarDays: calendarDays,
      completedPomodoros: sessions.length,
      focusedSeconds: focusedSeconds,
    ),
  );
}

DateTimeRange _statisticsRangeForRequest(
  StatisticsReportRequest request,
  DateTime now,
) {
  final today = _dateOnly(now);

  return switch (request.period) {
    StatisticsReportPeriod.day => DateTimeRange(start: today, end: today),
    StatisticsReportPeriod.week => DateTimeRange(
      start: today.subtract(Duration(days: today.weekday - 1)),
      end: today.add(Duration(days: DateTime.sunday - today.weekday)),
    ),
    StatisticsReportPeriod.month => DateTimeRange(
      start: DateTime(today.year, today.month),
      end: DateTime(today.year, today.month + 1, 0),
    ),
    StatisticsReportPeriod.year => DateTimeRange(
      start: DateTime(today.year),
      end: DateTime(today.year, 12, 31),
    ),
    StatisticsReportPeriod.range => _normalizedCustomRange(request, today),
  };
}

DateTimeRange _normalizedCustomRange(
  StatisticsReportRequest request,
  DateTime fallback,
) {
  final from = _dateOnly(request.from ?? fallback);
  final to = _dateOnly(request.to ?? request.from ?? fallback);

  if (from.isAfter(to)) {
    return DateTimeRange(start: to, end: from);
  }

  return DateTimeRange(start: from, end: to);
}

Iterable<DateTime> _daysInRange(DateTime start, DateTime end) sync* {
  var cursor = _dateOnly(start);
  final last = _dateOnly(end);

  while (!cursor.isAfter(last)) {
    yield cursor;
    cursor = cursor.add(const Duration(days: 1));
  }
}

bool _taskFallsInRange(Task task, DateTime start, DateTime end) {
  final reportDate = _dateOnly(task.scheduledDate ?? task.createdAt);

  return !reportDate.isBefore(start) && !reportDate.isAfter(end);
}

bool _sessionFallsInRange(
  PomodoroSession session,
  DateTime start,
  DateTime end,
) {
  final reportDate = _dateOnly(session.endedAt);

  return !reportDate.isBefore(start) && !reportDate.isAfter(end);
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
