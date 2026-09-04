import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/entities/focus_silence_preferences.dart';
import 'package:pomodoro_app_v1/features/focus_silence/presentation/controllers/focus_silence_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FocusSilenceSettingsCard extends StatelessWidget {
  const FocusSilenceSettingsCard({
    required this.controller,
    super.key,
  });

  final FocusSilenceController controller;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SignalBuilder(
      builder: (context) {
        final preferences = controller.preferences.value;
        final capability = controller.capability.value;
        final warning = controller.warning.value;

        return GlassCard(
          color: palette.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: palette.primaryMuted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications_paused_rounded,
                      color: palette.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(
                            'Silencio de enfoque',
                            'Focus silence',
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _statusLabel(context, capability),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: capability.isActive
                                    ? palette.primary
                                    : palette.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                context.tr(
                  'Michi Focus usa su propia regla de No molestar solo mientras avanza el tiempo de enfoque. La retira al pausar, descansar o salir de la app.',
                  'Michi Focus uses its own Do Not Disturb rule only while the focus timer is running. It removes it when paused, during breaks, and when you leave the app.',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: preferences.enableWithPomodoro,
                onChanged: capability.isSupported
                    ? (value) => unawaited(
                        _changeAutomaticMode(context, value),
                      )
                    : null,
                title: Text(
                  context.tr(
                    'Activar al iniciar un Pomodoro',
                    'Enable when a Pomodoro starts',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('Qué puede interrumpir', 'Allowed interruptions'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              SegmentedButton<FocusSilenceProfile>(
                segments: [
                  ButtonSegment(
                    value: FocusSilenceProfile.alarmsOnly,
                    icon: const Icon(Icons.alarm_rounded),
                    label: Text(context.tr('Solo alarmas', 'Alarms only')),
                  ),
                  ButtonSegment(
                    value: FocusSilenceProfile.noInterruptions,
                    icon: const Icon(Icons.do_not_disturb_on_rounded),
                    label: Text(
                      context.tr(
                        'Sin interrupciones',
                        'No interruptions',
                      ),
                    ),
                  ),
                ],
                selected: {preferences.profile},
                onSelectionChanged: (selection) =>
                    unawaited(controller.setProfile(selection.first)),
              ),
              if (warning != null) ...[
                const SizedBox(height: 10),
                Text(
                  warning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.accentPeach,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: capability.isAuthorized
                    ? OutlinedButton.icon(
                        onPressed: () => unawaited(
                          controller.requestAuthorization(
                            forCurrentPlan: false,
                          ),
                        ),
                        icon: const Icon(Icons.settings_rounded),
                        label: Text(
                          context.tr(
                            'Abrir ajustes de Android',
                            'Open Android settings',
                          ),
                        ),
                      )
                    : FilledButton.icon(
                        onPressed: capability.isSupported
                            ? () => unawaited(
                                controller.requestAuthorization(
                                  forCurrentPlan: false,
                                ),
                              )
                            : null,
                        icon: const Icon(Icons.admin_panel_settings_rounded),
                        label: Text(
                          context.tr(
                            'Autorizar en Android',
                            'Authorize in Android',
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeAutomaticMode(
    BuildContext context,
    bool value,
  ) async {
    if (!value || controller.capability.value.isAuthorized) {
      await controller.setEnableWithPomodoro(enabled: value);
      return;
    }
    final authorize = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.tr('Autorizar No molestar', 'Authorize Do Not Disturb'),
        ),
        content: Text(
          context.tr(
            'Android mostrará la pantalla protegida donde puedes permitir a Michi Focus controlar solo su propia regla.',
            'Android will show the protected screen where you can allow Michi Focus to control only its own rule.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.tr('Cancelar', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              context.tr('Autorizar en Android', 'Authorize in Android'),
            ),
          ),
        ],
      ),
    );
    if (authorize ?? false) {
      await controller.requestAuthorization(forCurrentPlan: false);
    }
  }

  String _statusLabel(
    BuildContext context,
    FocusSilenceCapability capability,
  ) {
    if (!capability.isSupported) {
      return context.tr('No compatible', 'Not supported');
    }
    if (!capability.isAuthorized) {
      return context.tr(
        'Autorización necesaria',
        'Authorization required',
      );
    }
    if (capability.isActive) {
      return context.tr('Activo', 'Active');
    }
    return context.tr('Disponible', 'Available');
  }
}
