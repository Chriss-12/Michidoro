import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/settings/domain/entities/timer_preferences.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

class FileSettingsRepository implements SettingsRepository {
  const FileSettingsRepository();

  static const _fileName = 'michidoro-settings.json';

  @override
  Future<TimerPreferences> loadTimerPreferences() async {
    final file = await _settingsFile();
    if (!file.existsSync()) {
      return const TimerPreferences.defaults();
    }

    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return const TimerPreferences.defaults(
          completedOnboardingVersion:
              AppSettingsController.currentOnboardingVersion,
        );
      }

      return TimerPreferences(
        focusMinutes: _readInt(decoded, 'focusMinutes', 25),
        shortBreakMinutes: _readInt(decoded, 'shortBreakMinutes', 5),
        longBreakMinutes: _readInt(decoded, 'longBreakMinutes', 15),
        longBreakFrequency: _readInt(decoded, 'longBreakFrequency', 3),
        completionSound: _readSound(decoded['completionSound']),
        completionVibrationEnabled: _readBool(
          decoded,
          'completionVibrationEnabled',
          fallback: true,
        ),
        completionVibrationPattern: _readVibrationPattern(
          decoded['completionVibrationPattern'],
        ),
        autoStartBreak: _readBool(decoded, 'autoStartBreak', fallback: true),
        autoStartFocus: _readBool(decoded, 'autoStartFocus'),
        reportsDirectoryPath: _readString(decoded, 'reportsDirectoryPath'),
        profileName: _readString(decoded, 'profileName', fallback: 'Chriss'),
        profileEmail: _readString(decoded, 'profileEmail'),
        profileImagePath: _readString(decoded, 'profileImagePath'),
        avatarIndex: _readInt(decoded, 'avatarIndex', 0),
        themePreset: _readThemePreset(decoded['themePreset']),
        isDarkMode: _readBool(decoded, 'isDarkMode'),
        fontScale: _readDouble(decoded, 'fontScale', 1),
        typographyPreset: _readTypographyPreset(decoded['typographyPreset']),
        enabledStatisticsCharts: _readStatisticsCharts(
          decoded['enabledStatisticsCharts'],
        ),
        language: AppLanguage.fromCode(decoded['languageCode']),
        completedOnboardingVersion: _readOnboardingVersion(
          decoded['completedOnboardingVersion'],
        ),
      ).normalized();
    } on FormatException {
      return const TimerPreferences.defaults(
        completedOnboardingVersion:
            AppSettingsController.currentOnboardingVersion,
      );
    } on FileSystemException {
      return const TimerPreferences.defaults(
        completedOnboardingVersion:
            AppSettingsController.currentOnboardingVersion,
      );
    }
  }

  @override
  Future<void> saveTimerPreferences(TimerPreferences preferences) async {
    final normalized = preferences.normalized();
    final file = await _settingsFile();
    await file.writeAsString(
      jsonEncode({
        'focusMinutes': normalized.focusMinutes,
        'shortBreakMinutes': normalized.shortBreakMinutes,
        'longBreakMinutes': normalized.longBreakMinutes,
        'longBreakFrequency': normalized.longBreakFrequency,
        'completionSound': normalized.completionSound.name,
        'completionVibrationEnabled': normalized.completionVibrationEnabled,
        'completionVibrationPattern':
            normalized.completionVibrationPattern.name,
        'autoStartBreak': normalized.autoStartBreak,
        'autoStartFocus': normalized.autoStartFocus,
        'reportsDirectoryPath': normalized.reportsDirectoryPath,
        'profileName': normalized.profileName,
        'profileEmail': normalized.profileEmail,
        'profileImagePath': normalized.profileImagePath,
        'avatarIndex': normalized.avatarIndex,
        'themePreset': normalized.themePreset.name,
        'isDarkMode': normalized.isDarkMode,
        'fontScale': normalized.fontScale,
        'typographyPreset': normalized.typographyPreset.name,
        'enabledStatisticsCharts': [
          for (final chart in normalized.enabledStatisticsCharts) chart.name,
        ],
        'languageCode': normalized.language.code,
        'completedOnboardingVersion': normalized.completedOnboardingVersion,
      }),
      flush: true,
    );
  }

  Future<File> _settingsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  static int _readInt(
    Map<String, dynamic> source,
    String key,
    int fallback,
  ) {
    final value = source[key];
    return value is int ? value : fallback;
  }

  static bool _readBool(
    Map<String, dynamic> source,
    String key, {
    bool fallback = false,
  }) {
    final value = source[key];
    return value is bool ? value : fallback;
  }

  static double _readDouble(
    Map<String, dynamic> source,
    String key,
    double fallback,
  ) {
    final value = source[key];
    return value is num ? value.toDouble() : fallback;
  }

  static String _readString(
    Map<String, dynamic> source,
    String key, {
    String fallback = '',
  }) {
    final value = source[key];
    return value is String ? value : fallback;
  }

  static PomodoroCompletionSound _readSound(Object? value) {
    if (value is! String) {
      return PomodoroCompletionSound.softBell;
    }

    return PomodoroCompletionSound.values.firstWhere(
      (sound) => sound.name == value,
      orElse: () => PomodoroCompletionSound.softBell,
    );
  }

  static PomodoroVibrationPattern _readVibrationPattern(Object? value) {
    if (value is! String) {
      return PomodoroVibrationPattern.normal;
    }

    return PomodoroVibrationPattern.values.firstWhere(
      (pattern) => pattern.name == value,
      orElse: () => PomodoroVibrationPattern.normal,
    );
  }

  static int _readOnboardingVersion(Object? value) {
    if (value is int && value >= 0) {
      return value;
    }

    return AppSettingsController.currentOnboardingVersion;
  }

  static AppTypographyPreset _readTypographyPreset(Object? value) {
    if (value is! String) {
      return AppTypographyPreset.moderna;
    }

    return AppTypographyPreset.values.firstWhere(
      (preset) => preset.name == value,
      orElse: () => AppTypographyPreset.moderna,
    );
  }

  static AppThemePreset _readThemePreset(Object? value) {
    if (value is! String) {
      return AppThemePreset.natureFocus;
    }

    return AppThemePreset.values.firstWhere(
      (preset) => preset.name == value,
      orElse: () => AppThemePreset.natureFocus,
    );
  }

  static Set<StatisticsChartType> _readStatisticsCharts(Object? value) {
    if (value is! List) {
      return {...StatisticsChartType.values};
    }

    final charts = <StatisticsChartType>{};
    for (final name in value.whereType<String>()) {
      for (final chart in StatisticsChartType.values) {
        if (chart.name == name) {
          charts.add(chart);
          break;
        }
      }
    }

    return charts.isEmpty ? {...StatisticsChartType.values} : charts;
  }
}
