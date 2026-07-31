import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:pomodoro_app_v1/shared/templates/app_shell.dart';
import 'package:pomodoro_app_v1/shared/templates/page_header.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  static const routePath = '/settings/notifications';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    return AppShell(
      selectedIndex: 4,
      child: ListView(
        padding: AppCardPaddings.detailPage,
        children: [
          PageHeader(
            title: context.tr('Notificaciones', 'Notifications'),
            subtitle: context.tr(
              'Configura avisos, sonido y pruebas.',
              'Configure alerts, sounds, and tests.',
            ),
            showBack: true,
          ),
          Padding(
            padding: AppCardPaddings.standard,
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: settings.notificationsEnabled,
                    onChanged: settings.onNotificationsEnabledChanged,
                    title: Text(
                      context.tr('Notificaciones', 'Notifications'),
                    ),
                    subtitle: Text(
                      context.tr(
                        'Activa los avisos internos y futuros recordatorios locales.',
                        'Enable in-app alerts and future local reminders.',
                      ),
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.breakAlertsEnabled,
                    onChanged: settings.notificationsEnabled
                        ? settings.onBreakAlertsEnabledChanged
                        : null,
                    title: Text(
                      context.tr('Alertas de descanso', 'Break alerts'),
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.focusAlertsEnabled,
                    onChanged: settings.notificationsEnabled
                        ? settings.onFocusAlertsEnabledChanged
                        : null,
                    title: Text(
                      context.tr('Alertas de enfoque', 'Focus alerts'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: AppCardPaddings.standard,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Biblioteca de sonidos', 'Sound library'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<PomodoroCompletionSound>(
                    value: settings.completionSound,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.volume_up_outlined),
                    ),
                    items: [
                      for (final sound in PomodoroCompletionSound.values)
                        DropdownMenuItem(
                          value: sound,
                          child: Text(_soundLabel(context, sound)),
                        ),
                    ],
                    onChanged: settings.notificationsEnabled
                        ? (value) {
                            if (value != null) {
                              settings.onCompletionSoundChanged(value);
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _soundDescription(context, settings.completionSound),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: settings.notificationsEnabled
                          ? settings.onPreviewCompletionSound
                          : null,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        context.tr('Escuchar sonido', 'Preview sound'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.vibration_rounded),
                    value: settings.completionVibrationEnabled,
                    onChanged: settings.onCompletionVibrationChanged,
                    title: Text(
                      context.tr(
                        'Vibrar al finalizar',
                        'Vibrate when finished',
                      ),
                    ),
                    subtitle: Text(
                      context.tr(
                        'Funciona al terminar enfoque o descanso, incluso con sonido silencioso.',
                        'Works after focus or a break, even when sound is silent.',
                      ),
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<PomodoroVibrationPattern>(
                    value: settings.completionVibrationPattern,
                    decoration: InputDecoration(
                      labelText: context.tr(
                        'Patrón de vibración',
                        'Vibration pattern',
                      ),
                      prefixIcon: const Icon(Icons.graphic_eq_rounded),
                    ),
                    items: [
                      for (final pattern in PomodoroVibrationPattern.values)
                        DropdownMenuItem(
                          value: pattern,
                          child: Text(_vibrationPatternLabel(context, pattern)),
                        ),
                    ],
                    onChanged: settings.completionVibrationEnabled
                        ? (value) {
                            if (value != null) {
                              settings.onCompletionVibrationPatternChanged(
                                value,
                              );
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _vibrationPatternDescription(
                      context,
                      settings.completionVibrationPattern,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: settings.completionVibrationEnabled
                          ? settings.onPreviewCompletionVibration
                          : null,
                      icon: const Icon(Icons.touch_app_rounded),
                      label: Text(
                        context.tr('Probar vibración', 'Test vibration'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: settings.notificationsEnabled
                          ? () async {
                              await settings.onTestNotification();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr(
                                        'Tarea programada de prueba enviada.',
                                        'Test scheduled-task alert sent.',
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: Text(
                        context.tr(
                          'Probar tarea programada',
                          'Test scheduled task',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  String _vibrationPatternLabel(
    BuildContext context,
    PomodoroVibrationPattern value,
  ) {
    return switch (value) {
      PomodoroVibrationPattern.light => context.tr('Suave', 'Light'),
      PomodoroVibrationPattern.normal => context.tr('Normal', 'Normal'),
      PomodoroVibrationPattern.double => context.tr('Doble', 'Double'),
      PomodoroVibrationPattern.intense => context.tr('Intensa', 'Intense'),
    };
  }

  String _vibrationPatternDescription(
    BuildContext context,
    PomodoroVibrationPattern value,
  ) {
    return switch (value) {
      PomodoroVibrationPattern.light => context.tr(
        'Un toque ligero y discreto.',
        'One light and subtle tap.',
      ),
      PomodoroVibrationPattern.normal => context.tr(
        'Un toque medio, igual al aviso original.',
        'One medium tap, matching the original alert.',
      ),
      PomodoroVibrationPattern.double => context.tr(
        'Dos toques cortos para distinguir el final.',
        'Two short taps to make completion distinct.',
      ),
      PomodoroVibrationPattern.intense => context.tr(
        'Un toque fuerte para que sea más perceptible.',
        'One strong tap for a more noticeable alert.',
      ),
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
        'A short, subtle signal for quick alerts.',
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
}
