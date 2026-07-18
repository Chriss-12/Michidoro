import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';

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
    this.reportsDirectoryPath = '',
    this.profileName = 'Chriss',
    this.profileEmail = '',
    this.profileImagePath = '',
    this.avatarIndex = 0,
    this.typographyPreset = AppTypographyPreset.moderna,
    this.enabledStatisticsCharts = const {...StatisticsChartType.values},
  });

  const TimerPreferences.defaults()
    : focusMinutes = 25,
      shortBreakMinutes = 5,
      longBreakMinutes = 15,
      longBreakFrequency = 3,
      completionSound = PomodoroCompletionSound.softBell,
      completionVibrationEnabled = true,
      autoStartBreak = true,
      autoStartFocus = false,
      reportsDirectoryPath = '',
      profileName = 'Chriss',
      profileEmail = '',
      profileImagePath = '',
      avatarIndex = 0,
      typographyPreset = AppTypographyPreset.moderna,
      enabledStatisticsCharts = const {...StatisticsChartType.values};

  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakFrequency;
  final PomodoroCompletionSound completionSound;
  final bool completionVibrationEnabled;
  final bool autoStartBreak;
  final bool autoStartFocus;
  final String reportsDirectoryPath;
  final String profileName;
  final String profileEmail;
  final String profileImagePath;
  final int avatarIndex;
  final AppTypographyPreset typographyPreset;
  final Set<StatisticsChartType> enabledStatisticsCharts;

  TimerPreferences normalized() {
    return TimerPreferences(
      focusMinutes: focusMinutes.clamp(5, 90),
      shortBreakMinutes: shortBreakMinutes.clamp(1, 20),
      longBreakMinutes: longBreakMinutes.clamp(5, 45),
      longBreakFrequency: longBreakFrequency.clamp(3, 5),
      completionSound: completionSound,
      completionVibrationEnabled: completionVibrationEnabled,
      autoStartBreak: autoStartBreak,
      autoStartFocus: autoStartFocus,
      reportsDirectoryPath: reportsDirectoryPath.trim(),
      profileName: profileName.trim().isEmpty ? 'Chriss' : profileName.trim(),
      profileEmail: profileEmail.trim(),
      profileImagePath: profileImagePath.trim(),
      avatarIndex: avatarIndex.clamp(0, 3),
      typographyPreset: typographyPreset,
      enabledStatisticsCharts: enabledStatisticsCharts.isEmpty
          ? const {...StatisticsChartType.values}
          : {...enabledStatisticsCharts},
    );
  }
}
