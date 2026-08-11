import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:pomodoro_app_v1/shared/templates/app_shell.dart';
import 'package:pomodoro_app_v1/shared/templates/page_header.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  static const routePath = '/settings/theme';

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return AppShell(
      selectedIndex: 4,
      showHeader: false,
      child: ListView(
        padding: AppCardPaddings.detailPage,
        children: [
          PageHeader(
            title: context.tr('Tema', 'Theme'),
            subtitle: context.tr(
              'Cambia colores, fondo, iconos y navegación.',
              'Change colors, background, icons, and navigation.',
            ),
            showBack: true,
          ),
          Padding(
            padding: AppCardPaddings.standard,
            child: Column(
              children: [
                for (final preset in AppThemePreset.values)
                  _ThemeOption(
                    preset: preset,
                    selected: preset == settings.themePreset,
                    onTap: () => settings.onThemeChanged(preset),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final AppThemePreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final lightPreview = AppPalette.fromPreset(preset, isDark: false);
    final darkPreview = AppPalette.fromPreset(preset, isDark: true);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: GlassCard(
          color: selected
              ? palette.navSelectedBackground.withValues(alpha: 0.82)
              : null,
          child: Row(
            children: [
              Container(
                width: 74,
                height: 54,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              lightPreview.gradientStart,
                              lightPreview.primary,
                              lightPreview.secondary,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              darkPreview.gradientStart,
                              darkPreview.primary,
                              darkPreview.secondary,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _themeLabel(context, preset),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _themeDescription(context, preset),
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected ? palette.primary : palette.neutral,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _themeLabel(BuildContext context, AppThemePreset preset) {
    return switch (preset) {
      AppThemePreset.natureFocus => context.tr(
        'Enfoque natural',
        'Nature Focus',
      ),
      AppThemePreset.forestOperations => context.tr(
        'Bosque operativo',
        'Forest Operations',
      ),
      AppThemePreset.slateIndigo => context.tr(
        'Pizarra índigo',
        'Slate Indigo',
      ),
      AppThemePreset.tealGraphite => context.tr(
        'Verde azulado y grafito',
        'Teal Graphite',
      ),
      AppThemePreset.graphiteNight => context.tr(
        'Noche grafito',
        'Graphite Night',
      ),
      AppThemePreset.sunshineAurora => context.tr(
        'Aurora soleada',
        'Sunshine Aurora',
      ),
      AppThemePreset.sunsetTide => context.tr(
        'Marea al atardecer',
        'Sunset Tide',
      ),
    };
  }

  String _themeDescription(BuildContext context, AppThemePreset preset) {
    return switch (preset) {
      AppThemePreset.natureFocus => context.tr(
        'Tonos botánicos suaves en verde y crema.',
        'Soft botanical green and cream tones.',
      ),
      AppThemePreset.forestOperations => context.tr(
        'Tonos firmes de bosque y cielo.',
        'Grounded forest and sky tones.',
      ),
      AppThemePreset.slateIndigo => context.tr(
        'Tonos intensos de índigo.',
        'Deep indigo command tones.',
      ),
      AppThemePreset.tealGraphite => context.tr(
        'Tonos limpios de verde azulado y grafito.',
        'Clean teal and graphite tones.',
      ),
      AppThemePreset.graphiteNight => context.tr(
        'Tonos oscuros de grafito y esmeralda.',
        'Dark graphite and emerald tones.',
      ),
      AppThemePreset.sunshineAurora => context.tr(
        'Tonos cálidos de sol y agua.',
        'Warm sunshine and aqua tones.',
      ),
      AppThemePreset.sunsetTide => context.tr(
        'Tonos cálidos de atardecer y marea.',
        'Warm sunset and tide tones.',
      ),
    };
  }
}
