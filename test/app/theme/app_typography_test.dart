import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';

void main() {
  group('AppTypography', () {
    for (final preset in AppTypographyPreset.values) {
      test('${preset.label} applies its bundled family to every text role', () {
        final textTheme = AppTypography.textTheme(
          colorScheme: const ColorScheme.light(),
          preset: preset,
        );

        expect(textTheme.bodyMedium?.fontFamily, preset.fontFamily);
        expect(textTheme.titleLarge?.fontFamily, preset.fontFamily);
        expect(textTheme.displayLarge?.fontFamily, preset.fontFamily);
      });

      test('${preset.label} is the global ThemeData family', () {
        final theme = AppTheme.fromPreset(
          AppThemePreset.natureFocus,
          isDark: false,
          typographyPreset: preset,
        );

        expect(theme.textTheme.bodyMedium?.fontFamily, preset.fontFamily);
        expect(
          theme.navigationBarTheme.labelTextStyle
              ?.resolve(<WidgetState>{})
              ?.fontFamily,
          preset.fontFamily,
        );
      });
    }

    test('caps navigation labels while preserving the selected font', () {
      final theme = AppTheme.fromPreset(
        AppThemePreset.graphiteNight,
        isDark: true,
        fontScale: AppTypography.maxFontScale,
        typographyPreset: AppTypographyPreset.serio,
      );
      final style = theme.navigationBarTheme.labelTextStyle?.resolve(
        <WidgetState>{WidgetState.selected},
      );

      expect(style?.fontFamily, AppTypographyPreset.serio.fontFamily);
      expect(style?.fontSize, AppFontSizes.constrainedNavigationLabel);
    });
  });

  test('dark presets use light system status bar icons', () {
    final style = AppTheme.systemOverlayStyle(
      AppThemePreset.graphiteNight,
      isDark: false,
    );

    expect(style.statusBarIconBrightness, Brightness.light);
    expect(style.systemNavigationBarIconBrightness, Brightness.light);
  });

  test('every color preset keeps a distinct dark palette', () {
    final palettes = {
      for (final preset in AppThemePreset.values)
        preset: AppPalette.fromPreset(preset, isDark: true),
    };

    final signatures = palettes.values
        .map(
          (palette) => (
            palette.primary.toARGB32(),
            palette.background.toARGB32(),
            palette.gradientEnd.toARGB32(),
          ),
        )
        .toSet();

    expect(signatures, hasLength(AppThemePreset.values.length));
    for (final palette in palettes.values) {
      expect(
        ThemeData.estimateBrightnessForColor(palette.textPrimary),
        Brightness.light,
      );
      expect(
        ThemeData.estimateBrightnessForColor(palette.surface),
        Brightness.dark,
      );
    }
  });
}
