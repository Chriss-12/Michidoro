import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
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
      child: ListView(
        padding: AppCardPaddings.detailPage,
        children: [
          const PageHeader(
            title: 'Theme',
            subtitle: 'Change colors, background, icons, and navbar.',
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
                      preset.label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preset.description,
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
}
