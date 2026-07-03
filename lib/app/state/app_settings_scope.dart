import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';

class AppSettingsScope extends InheritedWidget {
  const AppSettingsScope({
    required this.themePreset,
    required this.isDarkMode,
    required this.fontScale,
    required this.profileName,
    required this.profileImagePath,
    required this.avatarIndex,
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakFrequency,
    required this.autoStartBreak,
    required this.autoStartFocus,
    required this.notificationsEnabled,
    required this.breakAlertsEnabled,
    required this.focusAlertsEnabled,
    required this.isPomodoroRunning,
    required this.remainingSeconds,
    required this.completedTasks,
    required this.totalTasks,
    required this.completedPomodoros,
    required this.totalFocusSeconds,
    required this.lastReportPath,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
    required this.onFontScaleChanged,
    required this.onProfileNameChanged,
    required this.onProfileImagePathChanged,
    required this.onAvatarChanged,
    required this.onFocusMinutesChanged,
    required this.onShortBreakMinutesChanged,
    required this.onLongBreakMinutesChanged,
    required this.onLongBreakFrequencyChanged,
    required this.onAutoStartBreakChanged,
    required this.onAutoStartFocusChanged,
    required this.onNotificationsEnabledChanged,
    required this.onBreakAlertsEnabledChanged,
    required this.onFocusAlertsEnabledChanged,
    required this.onPomodoroPlayPause,
    required this.onPomodoroReset,
    required this.onDownloadReport,
    required this.onDownloadStatisticsPdf,
    required super.child,
    super.key,
  });

  final AppThemePreset themePreset;
  final bool isDarkMode;
  final double fontScale;
  final String profileName;
  final String profileImagePath;
  final int avatarIndex;
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakFrequency;
  final bool autoStartBreak;
  final bool autoStartFocus;
  final bool notificationsEnabled;
  final bool breakAlertsEnabled;
  final bool focusAlertsEnabled;
  final bool isPomodoroRunning;
  final int remainingSeconds;
  final int completedTasks;
  final int totalTasks;
  final int completedPomodoros;
  final int totalFocusSeconds;
  final String lastReportPath;
  final ValueChanged<AppThemePreset> onThemeChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<String> onProfileNameChanged;
  final ValueChanged<String> onProfileImagePathChanged;
  final ValueChanged<int> onAvatarChanged;
  final ValueChanged<int> onFocusMinutesChanged;
  final ValueChanged<int> onShortBreakMinutesChanged;
  final ValueChanged<int> onLongBreakMinutesChanged;
  final ValueChanged<int> onLongBreakFrequencyChanged;
  final ValueChanged<bool> onAutoStartBreakChanged;
  final ValueChanged<bool> onAutoStartFocusChanged;
  final ValueChanged<bool> onNotificationsEnabledChanged;
  final ValueChanged<bool> onBreakAlertsEnabledChanged;
  final ValueChanged<bool> onFocusAlertsEnabledChanged;
  final VoidCallback onPomodoroPlayPause;
  final VoidCallback onPomodoroReset;
  final Future<void> Function() onDownloadReport;
  final Future<void> Function(StatisticsReportRequest request)
  onDownloadStatisticsPdf;

  static AppSettingsScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppSettingsScope>();

    assert(scope != null, 'AppSettingsScope was not found in the tree.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppSettingsScope oldWidget) {
    return themePreset != oldWidget.themePreset ||
        isDarkMode != oldWidget.isDarkMode ||
        fontScale != oldWidget.fontScale ||
        profileName != oldWidget.profileName ||
        profileImagePath != oldWidget.profileImagePath ||
        avatarIndex != oldWidget.avatarIndex ||
        focusMinutes != oldWidget.focusMinutes ||
        shortBreakMinutes != oldWidget.shortBreakMinutes ||
        longBreakMinutes != oldWidget.longBreakMinutes ||
        longBreakFrequency != oldWidget.longBreakFrequency ||
        autoStartBreak != oldWidget.autoStartBreak ||
        autoStartFocus != oldWidget.autoStartFocus ||
        notificationsEnabled != oldWidget.notificationsEnabled ||
        breakAlertsEnabled != oldWidget.breakAlertsEnabled ||
        focusAlertsEnabled != oldWidget.focusAlertsEnabled ||
        isPomodoroRunning != oldWidget.isPomodoroRunning ||
        remainingSeconds != oldWidget.remainingSeconds ||
        completedTasks != oldWidget.completedTasks ||
        totalTasks != oldWidget.totalTasks ||
        completedPomodoros != oldWidget.completedPomodoros ||
        totalFocusSeconds != oldWidget.totalFocusSeconds ||
        lastReportPath != oldWidget.lastReportPath;
  }
}
