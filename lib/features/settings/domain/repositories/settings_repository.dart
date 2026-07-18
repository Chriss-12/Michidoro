import 'package:pomodoro_app_v1/features/settings/domain/entities/timer_preferences.dart';

abstract interface class SettingsRepository {
  Future<TimerPreferences> loadTimerPreferences();

  Future<void> saveTimerPreferences(TimerPreferences preferences);
}
