import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/routine_reminder_scheduler.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class RoutineReminderCapabilityTile extends StatelessWidget {
  const RoutineReminderCapabilityTile({
    required this.capability,
    super.key,
  });

  final RoutineReminderCapability capability;

  @override
  Widget build(BuildContext context) {
    final permissionGranted = capability.notificationPermissionGranted;
    final exactAvailable = capability.exactSchedulingAvailable;
    final colorScheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final title = !permissionGranted
        ? context.tr(
            'Recordatorios del sistema desactivados',
            'System reminders are disabled',
          )
        : exactAvailable
        ? context.tr(
            'Recordatorios del sistema listos',
            'System reminders are ready',
          )
        : context.tr('Entrega flexible activa', 'Flexible delivery is active');
    final subtitle = !permissionGranted
        ? context.tr(
            'Activa las notificaciones de MichiDoro en Android. Tus rutinas seguirán funcionando.',
            'Enable MichiDoro notifications in Android. Your routines will keep working.',
          )
        : exactAvailable
        ? context.tr(
            'Android puede entregar los avisos a la hora programada.',
            'Android can deliver alerts at the scheduled time.',
          )
        : context.tr(
            'Android puede retrasar algunos avisos para ahorrar batería. Tus rutinas no se modifican.',
            'Android may delay some alerts to save battery. Your routines are not changed.',
          );
    final (background, border, iconColor) = !permissionGranted
        ? (
            Color.lerp(palette.surface, colorScheme.error, 0.16)!,
            Color.lerp(palette.neutralSoft, colorScheme.error, 0.55)!,
            colorScheme.error,
          )
        : exactAvailable
        ? (
            palette.primaryMuted,
            palette.primary.withValues(alpha: 0.42),
            palette.primary,
          )
        : (
            palette.secondarySoft,
            palette.secondary.withValues(alpha: 0.42),
            palette.secondary,
          );
    final statusKey = !permissionGranted
        ? 'denied'
        : exactAvailable
        ? 'exact'
        : 'flexible';

    return DecoratedBox(
      key: ValueKey('routine-reminder-capability-$statusKey'),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              permissionGranted
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
              color: iconColor,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ),
          if (!permissionGranted)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: RoutineReminderPlatform.openSystemSettings,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(
                    context.tr(
                      'Abrir ajustes de Android',
                      'Open Android settings',
                    ),
                  ),
                  style: TextButton.styleFrom(foregroundColor: iconColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
