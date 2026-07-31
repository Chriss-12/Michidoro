import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';

enum AppTypographyPreset {
  moderna('Moderna', 'Sora', 'Sora', 'Limpia y actual para dashboards.'),
  serio(
    'Serio',
    'Merriweather',
    'Merriweather',
    'Más formal para reportes y foco profundo.',
  ),
  normal('Normal', 'Roboto', 'Roboto', 'Neutral y familiar para uso diario.');

  const AppTypographyPreset(
    this.label,
    this.familyLabel,
    this.fontFamily,
    this.description,
  );

  final String label;
  final String familyLabel;
  final String fontFamily;
  final String description;
}

class AppFontSizes {
  const AppFontSizes._();

  static const double timer = AppDesignTokens.timerFontSize;
  static const double pageTitle = AppDesignTokens.mainTitleFontSize;
  static const double greeting = AppDesignTokens.mainTitleFontSize;
  static const double sectionTitle = AppDesignTokens.sectionTitleFontSize;
  static const double cardTitle = AppDesignTokens.sectionTitleFontSize;
  static const double taskTitle = AppDesignTokens.sectionTitleFontSize;
  static const double body = AppDesignTokens.bodyFontSize;
  static const double bodySmall = AppDesignTokens.bodyFontSize;
  static const double label = AppDesignTokens.bodyFontSize;
  static const double button = AppDesignTokens.bodyFontSize;
  static const double stat = AppDesignTokens.mainTitleFontSize;
  static const double navigationLabel = AppDesignTokens.navigationLabelFontSize;
}

class AppTypography {
  const AppTypography._();

  static const double minFontScale = 0.90;
  static const double maxFontScale = 1.25;
  static const int fontScaleDivisions = 7;

  static TextTheme textTheme({
    required ColorScheme colorScheme,
    double fontScale = 1,
    AppTypographyPreset preset = AppTypographyPreset.moderna,
  }) {
    final textColor = colorScheme.onSurface;
    final textTheme = TextTheme(
      displayLarge: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.timer * fontScale,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.pageTitle * fontScale,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.greeting * fontScale,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.sectionTitle * fontScale,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.cardTitle * fontScale,
        fontWeight: FontWeight.w700,
        height: 1.22,
      ),
      titleSmall: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.taskTitle * fontScale,
        fontWeight: FontWeight.w600,
        height: 1.22,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.body * fontScale,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.body * fontScale,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: AppFontSizes.bodySmall * fontScale,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: textColor,
        fontSize: AppFontSizes.button * fontScale,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      labelMedium: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: AppFontSizes.label * fontScale,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: AppFontSizes.label * fontScale,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );

    return textTheme.apply(fontFamily: preset.fontFamily);
  }
}
