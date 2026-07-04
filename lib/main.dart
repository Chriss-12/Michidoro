import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/router/app_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/controllers/settings_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = appSettingsController;

    return SignalBuilder(
      builder: (context) {
        return AppSettingsScope(
          themePreset: controller.themePreset.value,
          isDarkMode: controller.isDarkMode.value,
          fontScale: controller.fontScale.value,
          profileName: controller.profileName.value,
          profileImagePath: controller.profileImagePath.value,
          avatarIndex: controller.avatarIndex.value,
          focusMinutes: controller.focusMinutes.value,
          shortBreakMinutes: controller.shortBreakMinutes.value,
          longBreakMinutes: controller.longBreakMinutes.value,
          longBreakFrequency: controller.longBreakFrequency.value,
          autoStartBreak: controller.autoStartBreak.value,
          autoStartFocus: controller.autoStartFocus.value,
          notificationsEnabled: controller.notificationsEnabled.value,
          breakAlertsEnabled: controller.breakAlertsEnabled.value,
          focusAlertsEnabled: controller.focusAlertsEnabled.value,
          isPomodoroRunning: controller.isPomodoroRunning.value,
          remainingSeconds: controller.remainingSeconds.value,
          completedTasks: controller.completedTasks.value,
          totalTasks: controller.totalTasks.value,
          completedPomodoros: controller.completedPomodoros.value,
          totalFocusSeconds: controller.totalFocusSeconds.value,
          lastReportPath: controller.lastReportPath.value,
          onThemeChanged: (value) => controller.themePreset.value = value,
          onDarkModeChanged: (value) => controller.isDarkMode.value = value,
          onFontScaleChanged: (value) => controller.fontScale.value =
              SettingsController.normalizeFontScale(value),
          onProfileNameChanged: (value) {
            final trimmed = value.trim();
            controller.profileName.value = trimmed.isEmpty ? 'Chriss' : trimmed;
          },
          onProfileImagePathChanged: (value) =>
              controller.profileImagePath.value = value.trim(),
          onAvatarChanged: (value) => controller.avatarIndex.value = value,
          onFocusMinutesChanged: controller.setFocusMinutes,
          onShortBreakMinutesChanged: controller.setShortBreakMinutes,
          onLongBreakMinutesChanged: controller.setLongBreakMinutes,
          onLongBreakFrequencyChanged: (value) =>
              controller.longBreakFrequency.value = value,
          onAutoStartBreakChanged: (value) =>
              controller.autoStartBreak.value = value,
          onAutoStartFocusChanged: (value) =>
              controller.autoStartFocus.value = value,
          onNotificationsEnabledChanged: (value) =>
              controller.notificationsEnabled.value = value,
          onBreakAlertsEnabledChanged: (value) =>
              controller.breakAlertsEnabled.value = value,
          onFocusAlertsEnabledChanged: (value) =>
              controller.focusAlertsEnabled.value = value,
          onPomodoroPlayPause: controller.togglePomodoro,
          onPomodoroReset: controller.resetPomodoro,
          onDownloadReport: controller.downloadReport,
          onDownloadStatisticsPdf: controller.downloadStatisticsPdf,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Pomodoro',
            theme: AppTheme.fromPreset(
              controller.themePreset.value,
              isDark: controller.isDarkMode.value,
              fontScale: controller.fontScale.value,
            ),
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
