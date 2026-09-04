import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pomodoro_app_v1/app/theme/app_typography.dart';

enum AppThemePreset {
  natureFocus('Nature Focus', 'Soft botanical green and cream tones'),
  forestOperations('Forest Operations', 'Grounded forest and sky tones'),
  slateIndigo('Slate Indigo', 'Deep indigo command tones'),
  tealGraphite('Teal Graphite', 'Clean teal and graphite tones'),
  graphiteNight('Graphite Night', 'Dark graphite and emerald tones'),
  sunshineAurora('Sunshine Aurora', 'Warm sunshine and aqua tones'),
  sunsetTide('Sunset Tide', 'Warm sunset and tide tones');

  const AppThemePreset(this.label, this.description);

  final String label;
  final String description;
}

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.primaryMuted,
    required this.secondary,
    required this.secondarySoft,
    required this.tertiary,
    required this.neutral,
    required this.neutralSoft,
    required this.background,
    required this.surface,
    required this.glass,
    required this.textPrimary,
    required this.textSecondary,
    required this.accentPeach,
    required this.navSelectedBackground,
    required this.navSelectedIcon,
    required this.navUnselectedIcon,
    required this.gradientStart,
    required this.gradientEnd,
  });

  factory AppPalette.fromPreset(
    AppThemePreset preset, {
    required bool isDark,
  }) {
    if (isDark && preset == AppThemePreset.graphiteNight) {
      return graphiteNight;
    }

    final palette = switch (preset) {
      AppThemePreset.natureFocus => natureFocus,
      AppThemePreset.forestOperations => forestOperations,
      AppThemePreset.slateIndigo => slateIndigo,
      AppThemePreset.tealGraphite => tealGraphite,
      AppThemePreset.graphiteNight => graphiteNight,
      AppThemePreset.sunshineAurora => sunshineAurora,
      AppThemePreset.sunsetTide => sunsetTide,
    };

    return isDark ? AppPalette._darkVariant(palette) : palette;
  }

  factory AppPalette._darkVariant(AppPalette source) {
    final primary = _withMinimumLightness(source.primary, 0.58);
    final secondary = _withMinimumLightness(source.secondary, 0.62);
    final background = _darkTone(source.gradientEnd, 0.07);
    final surface = _darkTone(source.primary, 0.13);
    final textPrimary = Color.lerp(source.textPrimary, Colors.white, 0.88)!;
    final textSecondary = Color.lerp(textPrimary, primary, 0.22)!;
    final neutral = Color.lerp(surface, Colors.white, 0.22)!;
    final neutralSoft = Color.lerp(surface, Colors.white, 0.13)!;

    return AppPalette(
      primary: primary,
      primaryMuted: Color.lerp(surface, primary, 0.28)!,
      secondary: secondary,
      secondarySoft: Color.lerp(surface, secondary, 0.18)!,
      tertiary: _withMinimumLightness(source.tertiary, 0.76),
      neutral: neutral,
      neutralSoft: neutralSoft,
      background: background,
      surface: surface,
      glass: surface.withValues(alpha: 0.9),
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      accentPeach: _withMinimumLightness(source.accentPeach, 0.7),
      navSelectedBackground: Color.lerp(surface, primary, 0.4)!,
      navSelectedIcon: Colors.white,
      navUnselectedIcon: textPrimary,
      gradientStart: _darkTone(source.gradientStart, 0.1),
      gradientEnd: _darkTone(source.gradientEnd, 0.15),
    );
  }

  final Color primary;
  final Color primaryMuted;
  final Color secondary;
  final Color secondarySoft;
  final Color tertiary;
  final Color neutral;
  final Color neutralSoft;
  final Color background;
  final Color surface;
  final Color glass;
  final Color textPrimary;
  final Color textSecondary;
  final Color accentPeach;
  final Color navSelectedBackground;
  final Color navSelectedIcon;
  final Color navUnselectedIcon;
  final Color gradientStart;
  final Color gradientEnd;

  Color get statusDanger => Color.lerp(const Color(0xFFE05252), primary, 0.22)!;
  Color get statusWarning =>
      Color.lerp(const Color(0xFFE3B341), secondary, 0.32)!;
  Color get statusSuccess =>
      Color.lerp(const Color(0xFF5EAD68), primary, 0.38)!;
  Color get statusSuccessStrong => primary;

  static const natureFocus = AppPalette(
    primary: Color(0xFF789B5F),
    primaryMuted: Color(0xFFE8F0DF),
    secondary: Color(0xFF8BB7C2),
    secondarySoft: Color(0xFFEDF4E8),
    tertiary: Color(0xFF3A2418),
    neutral: Color(0xFFE0D1BC),
    neutralSoft: Color(0xFFE0D1BC),
    background: Color(0xFFFFF8E8),
    surface: Color(0xFFFFFDF8),
    glass: Color(0xD6FFFDF8),
    textPrimary: Color(0xFF2D1E16),
    textSecondary: Color(0xFF6F5B4D),
    accentPeach: Color(0xFFF7E3B6),
    navSelectedBackground: Color(0xFFE8F0DF),
    navSelectedIcon: Color(0xFF3A2418),
    navUnselectedIcon: Color(0xFF3A2418),
    gradientStart: Color.fromARGB(255, 193, 220, 169),
    gradientEnd: Color(0xFFFFE7B8),
  );

  static const forestOperations = AppPalette(
    primary: Color(0xFF557C58),
    primaryMuted: Color(0xFFE1ECDC),
    secondary: Color(0xFF86B6C6),
    secondarySoft: Color(0xFFE8F1E5),
    tertiary: Color(0xFF3A2418),
    neutral: Color(0xFFD8DDD2),
    neutralSoft: Color(0xFFD8DDD2),
    background: Color(0xFFF5F7F0),
    surface: Color(0xFFFFFDF8),
    glass: Color(0xD6FFFDF8),
    textPrimary: Color(0xFF2F2F2F),
    textSecondary: Color(0xFF6F766F),
    accentPeach: Color(0xFFEAD7B3),
    navSelectedBackground: Color(0xFFE1ECDC),
    navSelectedIcon: Color(0xFF2F5136),
    navUnselectedIcon: Color(0xFF2F2F2F),
    gradientStart: Color(0xFFE1ECDC),
    gradientEnd: Color(0xFFEAD7B3),
  );

  static const slateIndigo = AppPalette(
    primary: Color(0xFF6366F1),
    primaryMuted: Color(0xFF1F2A5C),
    secondary: Color(0xFF38BDF8),
    secondarySoft: Color(0xFF172554),
    tertiary: Color(0xFFCBD5E1),
    neutral: Color(0xFF334155),
    neutralSoft: Color(0xFF334155),
    background: Color(0xFF33529A),
    surface: Color(0xFF1E293B),
    glass: Color(0xDC1E293B),
    textPrimary: Color(0xFFE2E8F0),
    textSecondary: Color(0xFFC0CDE0),
    accentPeach: Color(0xFFCBD5E1),
    navSelectedBackground: Color(0x3D38BDF8),
    navSelectedIcon: Color(0xFFF8FAFC),
    navUnselectedIcon: Color(0xFFE2E8F0),
    gradientStart: Color(0xFF111827),
    gradientEnd: Color(0xFF172554),
  );

  static const tealGraphite = AppPalette(
    primary: Color(0xFF0F766E),
    primaryMuted: Color(0xFFCCFBF1),
    secondary: Color(0xFF14B8A6),
    secondarySoft: Color(0xFFD1FAE5),
    tertiary: Color(0xFF334155),
    neutral: Color(0xFFCFE3DF),
    neutralSoft: Color(0xFFCFE3DF),
    background: Color(0xFFF7FBFA),
    surface: Color(0xFFFFFFFF),
    glass: Color(0xDBFFFFFF),
    textPrimary: Color(0xFF10201F),
    textSecondary: Color(0xFF5F6F6D),
    accentPeach: Color(0xFFD1FAE5),
    navSelectedBackground: Color(0xFFCCFBF1),
    navSelectedIcon: Color(0xFF134E4A),
    navUnselectedIcon: Color(0xFF10201F),
    gradientStart: Color(0xFFCCFBF1),
    gradientEnd: Color(0xFFFFFFFF),
  );

  static const graphiteNight = AppPalette(
    primary: Color(0xFF158974),
    primaryMuted: Color(0xFF252A33),
    secondary: Color(0xFF2DD4BF),
    secondarySoft: Color(0xFF111419),
    tertiary: Color(0xFFD1D5DB),
    neutral: Color(0xFF303641),
    neutralSoft: Color(0xFF303641),
    background: Color(0xFF090B0F),
    surface: Color(0xFF161A21),
    glass: Color(0xE6161A21),
    textPrimary: Color(0xFFF3F4F6),
    textSecondary: Color(0xFF9CA3AF),
    accentPeach: Color(0xFFD1D5DB),
    navSelectedBackground: Color(0x4D158974),
    navSelectedIcon: Color(0xFFFFFFFF),
    navUnselectedIcon: Color(0xFFF3F4F6),
    gradientStart: Color(0xFF050608),
    gradientEnd: Color(0xFF252B34),
  );

  static const sunshineAurora = AppPalette(
    primary: Color(0xFFF59E0B),
    primaryMuted: Color(0xFFFFF0B8),
    secondary: Color(0xFF22D3EE),
    secondarySoft: Color(0xFFFFD6A8),
    tertiary: Color(0xFFF97316),
    neutral: Color(0xFFF6C56C),
    neutralSoft: Color(0xFFF6C56C),
    background: Color(0xFFFFF7D6),
    surface: Color(0xFFFFFDF4),
    glass: Color(0xE0FFFDF4),
    textPrimary: Color(0xFF3B2112),
    textSecondary: Color(0xFF8A5A2B),
    accentPeach: Color(0xFFFFD6A8),
    navSelectedBackground: Color(0xFFFFF0B8),
    navSelectedIcon: Color(0xFF7C2D12),
    navUnselectedIcon: Color(0xFF3B2112),
    gradientStart: Color(0xFFFFF7D6),
    gradientEnd: Color(0xFFBFF7F1),
  );

  static const sunsetTide = AppPalette(
    primary: Color(0xFFD15B7E),
    primaryMuted: Color(0xFFFFD875),
    secondary: Color(0xFF6F83BD),
    secondarySoft: Color(0xFFF2A0AD),
    tertiary: Color(0xFFFF716D),
    neutral: Color(0xFFD39AAE),
    neutralSoft: Color(0xFFD39AAE),
    background: Color(0xFF263456),
    surface: Color(0xFFFFF0E1),
    glass: Color(0xF0FFF0E1),
    textPrimary: Color(0xFF1A2036),
    textSecondary: Color(0xFF574D74),
    accentPeach: Color(0xFFF2A0AD),
    navSelectedBackground: Color(0xFFFFD875),
    navSelectedIcon: Color(0xFF182340),
    navUnselectedIcon: Color(0xFFFFF3DF),
    gradientStart: Color(0xFF6F83BD),
    gradientEnd: Color(0xFF263456),
  );

  static Color _withMinimumLightness(Color color, double minimum) {
    final hsl = HSLColor.fromColor(color);
    if (hsl.lightness >= minimum) {
      return color;
    }
    return hsl.withLightness(minimum).toColor();
  }

  static Color _darkTone(Color color, double lightness) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withSaturation(hsl.saturation.clamp(0.18, 0.48))
        .withLightness(lightness)
        .toColor();
  }

  BoxDecoration get appBackgroundDecoration {
    return BoxDecoration(
      color: background,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          secondary,
          gradientStart,
          gradientEnd,
        ],
      ),
    );
  }

  @override
  AppPalette copyWith({
    Color? primary,
    Color? primaryMuted,
    Color? secondary,
    Color? secondarySoft,
    Color? tertiary,
    Color? neutral,
    Color? neutralSoft,
    Color? background,
    Color? surface,
    Color? glass,
    Color? textPrimary,
    Color? textSecondary,
    Color? accentPeach,
    Color? navSelectedBackground,
    Color? navSelectedIcon,
    Color? navUnselectedIcon,
    Color? gradientStart,
    Color? gradientEnd,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      secondary: secondary ?? this.secondary,
      secondarySoft: secondarySoft ?? this.secondarySoft,
      tertiary: tertiary ?? this.tertiary,
      neutral: neutral ?? this.neutral,
      neutralSoft: neutralSoft ?? this.neutralSoft,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      glass: glass ?? this.glass,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accentPeach: accentPeach ?? this.accentPeach,
      navSelectedBackground:
          navSelectedBackground ?? this.navSelectedBackground,
      navSelectedIcon: navSelectedIcon ?? this.navSelectedIcon,
      navUnselectedIcon: navUnselectedIcon ?? this.navUnselectedIcon,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondarySoft: Color.lerp(secondarySoft, other.secondarySoft, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      neutralSoft: Color.lerp(neutralSoft, other.neutralSoft, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accentPeach: Color.lerp(accentPeach, other.accentPeach, t)!,
      navSelectedBackground: Color.lerp(
        navSelectedBackground,
        other.navSelectedBackground,
        t,
      )!,
      navSelectedIcon: Color.lerp(navSelectedIcon, other.navSelectedIcon, t)!,
      navUnselectedIcon: Color.lerp(
        navUnselectedIcon,
        other.navUnselectedIcon,
        t,
      )!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
    );
  }
}

class AppTheme {
  const AppTheme._();

  static ThemeData fromPreset(
    AppThemePreset preset, {
    required bool isDark,
    double fontScale = 1,
    AppTypographyPreset typographyPreset = AppTypographyPreset.moderna,
  }) {
    final palette = AppPalette.fromPreset(preset, isDark: isDark);
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return _buildTheme(
      palette: palette,
      brightness: brightness,
      fontScale: fontScale,
      typographyPreset: typographyPreset,
    );
  }

  static ThemeData light() =>
      fromPreset(AppThemePreset.natureFocus, isDark: false);

  static ThemeData dark() =>
      fromPreset(AppThemePreset.natureFocus, isDark: true);

  static SystemUiOverlayStyle systemOverlayStyle(
    AppThemePreset preset, {
    required bool isDark,
  }) {
    final palette = AppPalette.fromPreset(preset, isDark: isDark);
    final statusIcons = _iconBrightnessFor(palette.gradientStart);
    final navigationIcons = _iconBrightnessFor(palette.surface);

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: statusIcons,
      statusBarBrightness: statusIcons == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarColor: palette.surface,
      systemNavigationBarIconBrightness: navigationIcons,
      systemNavigationBarDividerColor: palette.neutralSoft,
    );
  }

  static ThemeData _buildTheme({
    required AppPalette palette,
    required Brightness brightness,
    required double fontScale,
    required AppTypographyPreset typographyPreset,
  }) {
    final onPrimary = _higherContrastForeground(
      palette.primary,
      palette.textPrimary,
      Colors.white,
    );
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: brightness,
      primary: palette.primary,
      onPrimary: onPrimary,
      secondary: palette.secondary,
      tertiary: palette.tertiary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      onSurfaceVariant: palette.textSecondary,
      outline: palette.neutral,
      outlineVariant: palette.neutralSoft,
      primaryContainer: palette.primaryMuted,
      onPrimaryContainer: palette.textPrimary,
      secondaryContainer: palette.secondarySoft,
      onSecondaryContainer: palette.secondary,
    );

    final roundedRectangle = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: typographyPreset.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      textTheme:
          AppTypography.textTheme(
            colorScheme: colorScheme,
            fontScale: fontScale,
            preset: typographyPreset,
          ).apply(
            bodyColor: palette.textPrimary,
            displayColor: palette.tertiary,
          ),
      iconTheme: IconThemeData(color: palette.tertiary),
      extensions: <ThemeExtension<dynamic>>[palette],
      dividerTheme: DividerThemeData(color: palette.neutralSoft),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: roundedRectangle.copyWith(
          side: BorderSide(color: palette.neutralSoft),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: roundedRectangle,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        modalBackgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        textStyle: TextStyle(color: palette.textPrimary),
        shape: roundedRectangle,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surface,
        contentTextStyle: TextStyle(color: palette.textPrimary),
        actionTextColor: palette.primary,
        elevation: 2,
        shape: roundedRectangle,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surface,
        selectedColor: palette.primaryMuted,
        disabledColor: palette.neutralSoft.withValues(alpha: 0.45),
        side: BorderSide(color: palette.neutralSoft),
        labelStyle: TextStyle(color: palette.textPrimary),
        secondaryLabelStyle: TextStyle(color: palette.textPrimary),
        shape: roundedRectangle,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: palette.primaryMuted,
        circularTrackColor: palette.primaryMuted,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: roundedRectangle,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary),
          shape: roundedRectangle,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.neutralSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.neutralSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: palette.primary,
        inactiveTrackColor: palette.primaryMuted,
        thumbColor: palette.secondary,
        overlayColor: palette.primary.withValues(alpha: 0.12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.white
              : palette.neutralSoft;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? palette.primary
              : palette.neutral.withValues(alpha: 0.28);
        }),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: palette.navSelectedBackground,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? palette.navSelectedIcon
              : palette.navUnselectedIcon;

          return TextStyle(
            color: color,
            fontFamily: typographyPreset.fontFamily,
            fontSize: fontScale > 1
                ? AppFontSizes.constrainedNavigationLabel
                : AppFontSizes.navigationLabel * fontScale,
            fontWeight: FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? palette.navSelectedIcon
              : palette.navUnselectedIcon;

          return IconThemeData(color: color, size: 25);
        }),
      ),
    );
  }

  static Color _higherContrastForeground(
    Color background,
    Color first,
    Color second,
  ) {
    final firstContrast = _contrastRatio(background, first);
    final secondContrast = _contrastRatio(background, second);
    return firstContrast >= secondContrast ? first : second;
  }

  static double _contrastRatio(Color first, Color second) {
    final lighter = first.computeLuminance() >= second.computeLuminance()
        ? first
        : second;
    final darker = identical(lighter, first) ? second : first;
    return (lighter.computeLuminance() + 0.05) /
        (darker.computeLuminance() + 0.05);
  }

  static Brightness _iconBrightnessFor(Color background) {
    return background.computeLuminance() > 0.36
        ? Brightness.dark
        : Brightness.light;
  }
}

extension AppThemeContext on BuildContext {
  AppPalette get palette {
    return Theme.of(this).extension<AppPalette>() ?? AppPalette.natureFocus;
  }
}
