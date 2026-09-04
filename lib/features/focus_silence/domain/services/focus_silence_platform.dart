import 'package:pomodoro_app_v1/features/focus_silence/domain/entities/focus_silence_preferences.dart';

abstract interface class FocusSilencePlatform {
  Future<FocusSilenceCapability> getCapability();

  Future<void> openPolicyAccessSettings();

  Future<FocusSilenceCapability> setActive({
    required bool active,
    required FocusSilenceProfile profile,
    DateTime? endsAt,
  });
}
