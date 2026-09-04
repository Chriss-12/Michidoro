import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

class TimerPreferences {
  const TimerPreferences({
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakFrequency,
    required this.completionSound,
    required this.completionVibrationEnabled,
    required this.autoStartBreak,
    required this.autoStartFocus,
    this.completedOnboardingVersion = 0,
    this.completionVibrationPattern = PomodoroVibrationPattern.normal,
    this.reportsDirectoryPath = '',
    this.profileName = 'Chriss',
    this.profileEmail = '',
    this.profileImagePath = '',
    this.avatarIndex = 0,
    this.themePreset = AppThemePreset.natureFocus,
    this.isDarkMode = false,
    this.fontScale = 1,
    this.typographyPreset = AppTypographyPreset.moderna,
    this.enabledStatisticsCharts = const {...StatisticsChartType.values},
    this.language = AppLanguage.spanish,
    this.maximumConcentrationOpacity = 1,
  });

  const TimerPreferences.defaults({this.completedOnboardingVersion = 0})
    : focusMinutes = 25,
      shortBreakMinutes = 5,
      longBreakMinutes = 15,
      longBreakFrequency = 3,
      completionSound = PomodoroCompletionSound.softBell,
      completionVibrationEnabled = true,
      completionVibrationPattern = PomodoroVibrationPattern.normal,
      autoStartBreak = true,
      autoStartFocus = false,
      reportsDirectoryPath = '',
      profileName = 'Chriss',
      profileEmail = '',
      profileImagePath = '',
      avatarIndex = 0,
      themePreset = AppThemePreset.natureFocus,
      isDarkMode = false,
      fontScale = 1,
      typographyPreset = AppTypographyPreset.moderna,
      enabledStatisticsCharts = const {...StatisticsChartType.values},
      language = AppLanguage.spanish,
      maximumConcentrationOpacity = 1;

  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakFrequency;
  final PomodoroCompletionSound completionSound;
  final bool completionVibrationEnabled;
  final PomodoroVibrationPattern completionVibrationPattern;
  final bool autoStartBreak;
  final bool autoStartFocus;
  final int completedOnboardingVersion;
  final String reportsDirectoryPath;
  final String profileName;
  final String profileEmail;
  final String profileImagePath;
  final int avatarIndex;
  final AppThemePreset themePreset;
  final bool isDarkMode;
  final double fontScale;
  final AppTypographyPreset typographyPreset;
  final Set<StatisticsChartType> enabledStatisticsCharts;
  final AppLanguage language;
  final double maximumConcentrationOpacity;

  TimerPreferences normalized() {
    return TimerPreferences(
      focusMinutes: focusMinutes.clamp(5, 90),
      shortBreakMinutes: shortBreakMinutes.clamp(1, 20),
      longBreakMinutes: longBreakMinutes.clamp(5, 45),
      longBreakFrequency: longBreakFrequency.clamp(3, 5),
      completionSound: completionSound,
      completionVibrationEnabled: completionVibrationEnabled,
      completionVibrationPattern: completionVibrationPattern,
      autoStartBreak: autoStartBreak,
      autoStartFocus: autoStartFocus,
      completedOnboardingVersion: completedOnboardingVersion < 0
          ? 0
          : completedOnboardingVersion,
      reportsDirectoryPath: reportsDirectoryPath.trim(),
      profileName: profileName.trim().isEmpty ? 'Chriss' : profileName.trim(),
      profileEmail: profileEmail.trim(),
      profileImagePath: profileImagePath.trim(),
      avatarIndex: avatarIndex.clamp(0, 3),
      themePreset: themePreset,
      isDarkMode: isDarkMode,
      fontScale: fontScale.clamp(
        AppTypography.minFontScale,
        AppTypography.maxFontScale,
      ),
      typographyPreset: typographyPreset,
      enabledStatisticsCharts: enabledStatisticsCharts.isEmpty
          ? const {...StatisticsChartType.values}
          : {...enabledStatisticsCharts},
      language: language,
      maximumConcentrationOpacity: maximumConcentrationOpacity.clamp(0.2, 1),
    );
  }
}
