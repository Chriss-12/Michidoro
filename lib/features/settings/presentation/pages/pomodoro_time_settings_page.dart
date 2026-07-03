import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/widgets/pomodoro_time_controls.dart';
import 'package:pomodoro_app_v1/shared/templates/app_shell.dart';
import 'package:pomodoro_app_v1/shared/templates/page_header.dart';

class PomodoroTimeSettingsPage extends StatelessWidget {
  const PomodoroTimeSettingsPage({super.key});

  static const routePath = '/settings/timers';

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 2,
      child: ListView(
        padding: AppCardPaddings.page,
        children: const [
          PageHeader(
            title: 'Configuración\nde Intervalos',
            subtitle: 'Personaliza el ritmo de tu bosque interior.',
          ),
          SizedBox(height: 48),
          PomodoroTimeControls(),
        ],
      ),
    );
  }
}
