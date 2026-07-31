import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_file.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

class AppSettingsScope extends InheritedWidget {
  const AppSettingsScope({
    required this.themePreset,
    required this.isDarkMode,
    required this.fontScale,
    required this.profileName,
    required this.profileEmail,
    required this.profileImagePath,
    required this.avatarIndex,
    required this.typographyPreset,
    required this.language,
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakFrequency,
    required this.completionSound,
    required this.completionVibrationEnabled,
    required this.completionVibrationPattern,
    required this.autoStartBreak,
    required this.autoStartFocus,
    required this.notificationsEnabled,
    required this.breakAlertsEnabled,
    required this.focusAlertsEnabled,
    required this.completedTasks,
    required this.totalTasks,
    required this.lastReportPath,
    required this.reportsDirectoryPath,
    required this.enabledStatisticsCharts,
    required this.notifications,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
    required this.onFontScaleChanged,
    required this.onProfileNameChanged,
    required this.onProfileEmailChanged,
    required this.onProfileImagePathChanged,
    required this.onAvatarChanged,
    required this.onTypographyPresetChanged,
    required this.onLanguageChanged,
    required this.onFocusMinutesChanged,
    required this.onShortBreakMinutesChanged,
    required this.onLongBreakMinutesChanged,
    required this.onLongBreakFrequencyChanged,
    required this.onCompletionSoundChanged,
    required this.onPreviewCompletionSound,
    required this.onCompletionVibrationChanged,
    required this.onCompletionVibrationPatternChanged,
    required this.onPreviewCompletionVibration,
    required this.onAutoStartBreakChanged,
    required this.onAutoStartFocusChanged,
    required this.onReportsDirectoryPathChanged,
    required this.onUseDefaultReportsDirectory,
    required this.onStatisticsChartVisibilityChanged,
    required this.onNotificationsEnabledChanged,
    required this.onBreakAlertsEnabledChanged,
    required this.onFocusAlertsEnabledChanged,
    required this.onDownloadReport,
    required this.onDownloadStatisticsPdf,
    required this.onOpenReport,
    required this.onExportDatabaseBackup,
    required this.onImportDatabaseBackup,
    required this.onTestNotification,
    required this.onClearNotifications,
    required super.child,
    super.key,
  });

  final AppThemePreset themePreset;
  final bool isDarkMode;
  final double fontScale;
  final String profileName;
  final String profileEmail;
  final String profileImagePath;
  final int avatarIndex;
  final AppTypographyPreset typographyPreset;
  final AppLanguage language;
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakFrequency;
  final PomodoroCompletionSound completionSound;
  final bool completionVibrationEnabled;
  final PomodoroVibrationPattern completionVibrationPattern;
  final bool autoStartBreak;
  final bool autoStartFocus;
  final bool notificationsEnabled;
  final bool breakAlertsEnabled;
  final bool focusAlertsEnabled;
  final int completedTasks;
  final int totalTasks;
  final String lastReportPath;
  final String reportsDirectoryPath;
  final Set<StatisticsChartType> enabledStatisticsCharts;
  final List<AppNotification> notifications;
  final ValueChanged<AppThemePreset> onThemeChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<String> onProfileNameChanged;
  final ValueChanged<String> onProfileEmailChanged;
  final ValueChanged<String> onProfileImagePathChanged;
  final ValueChanged<int> onAvatarChanged;
  final ValueChanged<AppTypographyPreset> onTypographyPresetChanged;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<int> onFocusMinutesChanged;
  final ValueChanged<int> onShortBreakMinutesChanged;
  final ValueChanged<int> onLongBreakMinutesChanged;
  final ValueChanged<int> onLongBreakFrequencyChanged;
  final ValueChanged<PomodoroCompletionSound> onCompletionSoundChanged;
  final Future<void> Function() onPreviewCompletionSound;
  final ValueChanged<bool> onCompletionVibrationChanged;
  final ValueChanged<PomodoroVibrationPattern>
  onCompletionVibrationPatternChanged;
  final Future<void> Function() onPreviewCompletionVibration;
  final ValueChanged<bool> onAutoStartBreakChanged;
  final ValueChanged<bool> onAutoStartFocusChanged;
  final ValueChanged<String> onReportsDirectoryPathChanged;
  final Future<void> Function() onUseDefaultReportsDirectory;
  final void Function(StatisticsChartType chart, {required bool enabled})
  onStatisticsChartVisibilityChanged;
  final ValueChanged<bool> onNotificationsEnabledChanged;
  final ValueChanged<bool> onBreakAlertsEnabledChanged;
  final ValueChanged<bool> onFocusAlertsEnabledChanged;
  final Future<void> Function() onDownloadReport;
  final Future<StatisticsReportFile> Function(StatisticsReportRequest request)
  onDownloadStatisticsPdf;
  final Future<void> Function(String path) onOpenReport;
  final Future<String> Function() onExportDatabaseBackup;
  final Future<void> Function(String directoryPath) onImportDatabaseBackup;
  final Future<void> Function() onTestNotification;
  final VoidCallback onClearNotifications;

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
        profileEmail != oldWidget.profileEmail ||
        profileImagePath != oldWidget.profileImagePath ||
        avatarIndex != oldWidget.avatarIndex ||
        typographyPreset != oldWidget.typographyPreset ||
        language != oldWidget.language ||
        focusMinutes != oldWidget.focusMinutes ||
        shortBreakMinutes != oldWidget.shortBreakMinutes ||
        longBreakMinutes != oldWidget.longBreakMinutes ||
        longBreakFrequency != oldWidget.longBreakFrequency ||
        completionSound != oldWidget.completionSound ||
        completionVibrationEnabled != oldWidget.completionVibrationEnabled ||
        completionVibrationPattern != oldWidget.completionVibrationPattern ||
        autoStartBreak != oldWidget.autoStartBreak ||
        autoStartFocus != oldWidget.autoStartFocus ||
        notificationsEnabled != oldWidget.notificationsEnabled ||
        breakAlertsEnabled != oldWidget.breakAlertsEnabled ||
        focusAlertsEnabled != oldWidget.focusAlertsEnabled ||
        completedTasks != oldWidget.completedTasks ||
        totalTasks != oldWidget.totalTasks ||
        lastReportPath != oldWidget.lastReportPath ||
        reportsDirectoryPath != oldWidget.reportsDirectoryPath ||
        enabledStatisticsCharts != oldWidget.enabledStatisticsCharts ||
        notifications != oldWidget.notifications;
  }
}
