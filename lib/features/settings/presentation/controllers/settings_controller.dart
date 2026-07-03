import 'package:pomodoro_app_v1/app/theme/app_typography.dart';

class SettingsController {
  const SettingsController._();

  static double normalizeFontScale(double value) {
    if (value < AppTypography.minFontScale) {
      return AppTypography.minFontScale;
    }
    if (value > AppTypography.maxFontScale) {
      return AppTypography.maxFontScale;
    }
    return value;
  }
}
