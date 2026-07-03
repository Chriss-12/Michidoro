import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routePath = '/settings';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppCardPaddings.page,
      children: const [
        SizedBox(height: 24),
        _ProfileCard(),
        SizedBox(height: 26),
        _AppearanceCard(),
        SizedBox(height: 26),
        _FocusTimesCard(),
        SizedBox(height: 26),
        _NotificationsCard(),
        SizedBox(height: 26),
        _TypographyCard(),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: palette.primaryMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: palette.primary,
                    size: 58,
                  ),
                ),
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: palette.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 38),
            const _FieldLabel('Nombre de usuario'),
            TextFormField(
              initialValue: 'Michi User',
              onChanged: settings.onProfileNameChanged,
            ),
            const SizedBox(height: 18),
            const _FieldLabel('Correo electrónico'),
            TextFormField(initialValue: 'hello@michifocus.com'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {},
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.palette_outlined,
            title: 'Apariencia',
          ),
          const SizedBox(height: 18),
          _ModeTile(
            label: 'Modo Claro',
            value: !settings.isDarkMode,
            onChanged: (value) => settings.onDarkModeChanged(!value),
          ),
          const SizedBox(height: 14),
          _ModeTile(
            label: 'Modo Oscuro',
            value: settings.isDarkMode,
            onChanged: settings.onDarkModeChanged,
            disabled: true,
          ),
          const SizedBox(height: 18),
          _TextScaleControl(settings: settings),
          const SizedBox(height: 18),
          Text(
            'Tema de color',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in AppThemePreset.values)
                ChoiceChip(
                  label: Text(preset.label),
                  selected: settings.themePreset == preset,
                  onSelected: (_) => settings.onThemeChanged(preset),
                  selectedColor: palette.primaryMuted,
                  checkmarkColor: palette.primary,
                  labelStyle: TextStyle(
                    color: settings.themePreset == preset
                        ? palette.primary
                        : palette.textSecondary,
                    fontWeight: settings.themePreset == preset
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tema actual: ${settings.themePreset.label}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextScaleControl extends StatelessWidget {
  const _TextScaleControl({required this.settings});

  final AppSettingsScope settings;

  @override
  Widget build(BuildContext context) {
    final percent = (settings.fontScale * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tamaño general',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Text(
              '$percent%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.palette.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: settings.fontScale,
          min: AppTypography.minFontScale,
          max: AppTypography.maxFontScale,
          divisions: AppTypography.fontScaleDivisions,
          label: '$percent%',
          onChanged: settings.onFontScaleChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Compacto', style: Theme.of(context).textTheme.labelSmall),
            Text('Normal', style: Theme.of(context).textTheme.labelSmall),
            Text('Grande', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}

class _FocusTimesCard extends StatelessWidget {
  const _FocusTimesCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.timer_outlined,
            title: 'Tiempos de Enfoque',
          ),
          const SizedBox(height: 22),
          _InlineSlider(
            label: 'Sesión de Enfoque',
            value: settings.focusMinutes,
            min: 10,
            max: 90,
            onChanged: settings.onFocusMinutesChanged,
          ),
          const SizedBox(height: 20),
          _InlineSlider(
            label: 'Descanso Corto',
            value: settings.shortBreakMinutes,
            min: 1,
            max: 20,
            onChanged: settings.onShortBreakMinutesChanged,
          ),
          const SizedBox(height: 20),
          _InlineSlider(
            label: 'Descanso Largo',
            value: settings.longBreakMinutes,
            min: 5,
            max: 45,
            onChanged: settings.onLongBreakMinutesChanged,
          ),
        ],
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.notifications_active_outlined,
            title: 'Notificaciones',
          ),
          const SizedBox(height: 18),
          _NotificationTile(
            icon: Icons.volume_up_outlined,
            title: 'Alertas Sonoras',
            subtitle: 'Sonido suave al terminar ciclo',
            value: settings.focusAlertsEnabled,
            onChanged: settings.onFocusAlertsEnabledChanged,
          ),
          const SizedBox(height: 14),
          _NotificationTile(
            icon: Icons.desktop_windows_outlined,
            title: 'Escritorio',
            subtitle: 'Notificaciones nativas del sistema',
            value: settings.notificationsEnabled,
            onChanged: settings.onNotificationsEnabledChanged,
          ),
        ],
      ),
    );
  }
}

class _TypographyCard extends StatelessWidget {
  const _TypographyCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 64,
            decoration: BoxDecoration(
              color: palette.secondarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.text_fields_rounded,
              color: palette.secondary,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipografía',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: palette.tertiary,
                        fontSize: AppDesignTokens.sectionTitleFontSize,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sora (Sans-Serif) - Diseñada para legibilidad en estados de flujo.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: palette.textSecondary),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Restablecer'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        child: const Text('Aplicar Todo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Icon(icon, color: palette.tertiary, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: palette.tertiary,
              fontSize: AppDesignTokens.sectionTitleFontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.label,
    required this.value,
    required this.onChanged,
    this.disabled = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: disabled
            ? palette.background.withValues(alpha: 0.5)
            : palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: disabled ? palette.neutral : palette.textPrimary,
              ),
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _InlineSlider extends StatelessWidget {
  const _InlineSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleSmall),
            ),
            Text(
              '$value min',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: palette.primary),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max).toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Icon(icon, color: palette.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: context.palette.textSecondary),
      ),
    );
  }
}
