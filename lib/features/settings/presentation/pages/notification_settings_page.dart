import 'package:flutter/material.dart';
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
            title: 'Notifications',
            subtitle: 'Configure app visual alerts.',
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
                    title: const Text('Notifications'),
                    subtitle: Text(
                      'Enable local reminders when they are integrated.',
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.breakAlertsEnabled,
                    onChanged: settings.notificationsEnabled
                        ? settings.onBreakAlertsEnabledChanged
                        : null,
                    title: const Text('Break alerts'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.focusAlertsEnabled,
                    onChanged: settings.notificationsEnabled
                        ? settings.onFocusAlertsEnabledChanged
                        : null,
                    title: const Text('Focus alerts'),
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
