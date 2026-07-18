import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
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
          const PageHeader(
            title: 'Notificaciones',
            subtitle: 'Configura avisos, sonido y pruebas.',
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
                    title: const Text('Notificaciones'),
                    subtitle: Text(
                      'Activa los avisos internos y futuros recordatorios locales.',
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.breakAlertsEnabled,
                    onChanged: settings.notificationsEnabled
                        ? settings.onBreakAlertsEnabledChanged
                        : null,
                    title: const Text('Alertas de descanso'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.focusAlertsEnabled,
                    onChanged: settings.notificationsEnabled
                        ? settings.onFocusAlertsEnabledChanged
                        : null,
                    title: const Text('Alertas de enfoque'),
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
                    'Tono de notificacion',
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
                          child: Text(sound.label),
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
                    settings.completionSound.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
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
                                  const SnackBar(
                                    content: Text(
                                      'Notificacion de prueba enviada.',
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: const Text('Probar notificacion'),
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
}
