import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class PomodoroTimeControls extends StatelessWidget {
  const PomodoroTimeControls({this.showSaveButton = true, super.key});

  final bool showSaveButton;

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return Column(
      children: [
        _FocusCard(settings: settings),
        const SizedBox(height: 24),
        _BreaksCard(settings: settings),
        const SizedBox(height: 24),
        _AtmosphereCard(settings: settings, showSaveButton: showSaveButton),
      ],
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.settings});

  final AppSettingsScope settings;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: palette.secondary),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  context.tr('Tiempo de\nEnfoque', 'Focus\nTime'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: palette.tertiary,
                    fontSize: AppDesignTokens.sectionTitleFontSize,
                  ),
                ),
              ),
              Text(
                '${settings.focusMinutes}m',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: palette.secondary,
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),
          Slider(
            value: settings.focusMinutes.clamp(5, 90).toDouble(),
            min: 5,
            max: 90,
            divisions: 85,
            onChanged: (value) => settings.onFocusMinutesChanged(value.round()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('5 min', style: Theme.of(context).textTheme.bodySmall),
              Text('90 min', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 30),
          Divider(color: palette.neutralSoft),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Auto-iniciar Enfoque', 'Auto-start Focus'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      context.tr(
                        'Comienza el siguiente ciclo\nautomáticamente',
                        'Starts the next cycle\nautomatically',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: settings.autoStartFocus,
                onChanged: settings.onAutoStartFocusChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreaksCard extends StatelessWidget {
  const _BreaksCard({required this.settings});

  final AppSettingsScope settings;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco_outlined, color: palette.secondary),
              const SizedBox(width: 18),
              Text(
                context.tr('Descansos', 'Breaks'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: palette.tertiary,
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _BreakSlider(
            label: context.tr('Descanso Corto', 'Short Break'),
            value: settings.shortBreakMinutes,
            min: 1,
            max: 20,
            onChanged: settings.onShortBreakMinutesChanged,
          ),
          const SizedBox(height: 22),
          _BreakSlider(
            label: context.tr('Descanso Largo', 'Long Break'),
            value: settings.longBreakMinutes,
            min: 5,
            max: 45,
            onChanged: settings.onLongBreakMinutesChanged,
          ),
          const SizedBox(height: 28),
          Divider(color: palette.neutralSoft),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(
                        'Frecuencia de Largo',
                        'Long Break Frequency',
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      context.tr(
                        'Cada ${settings.longBreakFrequency} sesiones de enfoque',
                        'Every ${settings.longBreakFrequency} focus sessions',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _FrequencySelector(
                value: settings.longBreakFrequency,
                onChanged: settings.onLongBreakFrequencyChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakSlider extends StatelessWidget {
  const _BreakSlider({
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleSmall),
            ),
            Text(
              '${value}m',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.palette.secondary,
              ),
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

class _FrequencySelector extends StatelessWidget {
  const _FrequencySelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: palette.primaryMuted.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          for (final option in [3, 4, 5])
            InkWell(
              onTap: () => onChanged(option),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: value == option
                      ? palette.secondary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$option',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: value == option
                        ? colorScheme.onSecondary
                        : palette.textPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AtmosphereCard extends StatelessWidget {
  const _AtmosphereCard({
    required this.settings,
    required this.showSaveButton,
  });

  final AppSettingsScope settings;
  final bool showSaveButton;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      color: palette.primaryMuted.withValues(alpha: 0.36),
      padding: AppCardPaddings.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ForestPreview(),
          const SizedBox(height: 48),
          Text(
            context.tr('Ajustes Atmosféricos', 'Atmosphere Settings'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: palette.tertiary,
              fontSize: AppDesignTokens.sectionTitleFontSize,
            ),
          ),
          const SizedBox(height: 24),
          _AtmosphereTile(
            icon: Icons.volume_up_outlined,
            title: context.tr(
              'Sonido de\nFinalización',
              'Completion\nSound',
            ),
            trailing: _CompletionSoundPicker(
              selectedSound: settings.completionSound,
              onChanged: settings.onCompletionSoundChanged,
              onPreview: settings.onPreviewCompletionSound,
            ),
          ),
          if (showSaveButton) ...[
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: Text(
                  context.tr('Guardar Configuración', 'Save Settings'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompletionSoundPicker extends StatelessWidget {
  const _CompletionSoundPicker({
    required this.selectedSound,
    required this.onChanged,
    required this.onPreview,
  });

  final PomodoroCompletionSound selectedSound;
  final ValueChanged<PomodoroCompletionSound> onChanged;
  final Future<void> Function() onPreview;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          tooltip: context.tr('Escuchar sonido', 'Preview sound'),
          onPressed: () async => onPreview(),
          icon: const Icon(Icons.volume_up_rounded),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<PomodoroCompletionSound>(
          tooltip: context.tr('Seleccionar sonido', 'Select sound'),
          initialValue: selectedSound,
          onSelected: onChanged,
          itemBuilder: (context) {
            return [
              for (final sound in PomodoroCompletionSound.values)
                PopupMenuItem(
                  value: sound,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(_soundLabel(context, sound)),
                    subtitle: Text(_soundDescription(context, sound)),
                  ),
                ),
            ];
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 156),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: palette.primaryMuted.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _soundLabel(context, selectedSound),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ForestPreview extends StatelessWidget {
  const _ForestPreview();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      height: 154,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.secondary.withValues(alpha: 0.62),
            palette.textPrimary,
          ],
        ),
      ),
      child: Stack(
        children: [
          for (var i = 0; i < 14; i++)
            Positioned(
              left: i * 22,
              top: 0,
              bottom: 0,
              child: Container(
                width: 7,
                color: palette.textPrimary.withValues(alpha: 0.34),
              ),
            ),
          Align(
            alignment: const Alignment(-0.15, 0.68),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: palette.secondarySoft,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                context.tr(
                  'Vista Previa del Entorno',
                  'Atmosphere Preview',
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AtmosphereTile extends StatelessWidget {
  const _AtmosphereTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppCardPaddings.compact,
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.palette.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
          trailing,
        ],
      ),
    );
  }
}

String _soundLabel(
  BuildContext context,
  PomodoroCompletionSound sound,
) {
  return switch (sound) {
    PomodoroCompletionSound.softBell => context.tr(
      'Campana suave',
      'Soft bell',
    ),
    PomodoroCompletionSound.lightTap => context.tr(
      'Toque ligero',
      'Light tap',
    ),
    PomodoroCompletionSound.warmChime => context.tr(
      'Campanilla cálida',
      'Warm chime',
    ),
    PomodoroCompletionSound.crystalChime => context.tr(
      'Cristal claro',
      'Crystal chime',
    ),
    PomodoroCompletionSound.calmPulse => context.tr(
      'Pulso calmado',
      'Calm pulse',
    ),
    PomodoroCompletionSound.deepChime => context.tr(
      'Campana profunda',
      'Deep chime',
    ),
    PomodoroCompletionSound.digitalZen => context.tr(
      'Zen digital',
      'Digital zen',
    ),
    PomodoroCompletionSound.silent => context.tr('Silencio', 'Silent'),
  };
}

String _soundDescription(
  BuildContext context,
  PomodoroCompletionSound sound,
) {
  return switch (sound) {
    PomodoroCompletionSound.softBell => context.tr(
      'Campana breve y clara para cerrar el bloque.',
      'A short, clear bell to close the block.',
    ),
    PomodoroCompletionSound.lightTap => context.tr(
      'Señal corta y discreta para avisos rápidos.',
      'A short, discreet cue for quick alerts.',
    ),
    PomodoroCompletionSound.warmChime => context.tr(
      'Notas suaves con un cierre más agradable.',
      'Soft notes with a warmer finish.',
    ),
    PomodoroCompletionSound.crystalChime => context.tr(
      'Secuencia limpia y brillante sin sonar agresiva.',
      'A clean, bright sequence without sounding harsh.',
    ),
    PomodoroCompletionSound.calmPulse => context.tr(
      'Dos pulsos redondos para una alerta tranquila.',
      'Two rounded pulses for a calm alert.',
    ),
    PomodoroCompletionSound.deepChime => context.tr(
      'Tono grave y reposado para descansos largos.',
      'A deep, relaxed tone for long breaks.',
    ),
    PomodoroCompletionSound.digitalZen => context.tr(
      'Secuencia moderna, corta y menos invasiva.',
      'A modern, short, less intrusive sequence.',
    ),
    PomodoroCompletionSound.silent => context.tr(
      'No reproducir sonido al finalizar.',
      'Do not play a sound when finished.',
    ),
  };
}
