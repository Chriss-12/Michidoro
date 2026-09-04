import 'package:pomodoro_app_v1/features/focus_silence/domain/entities/focus_silence_preferences.dart';

abstract interface class FocusSilencePreferencesRepository {
  Future<FocusSilencePreferences> load();

  Future<void> save(FocusSilencePreferences preferences);
}
