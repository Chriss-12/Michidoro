import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/local_unlock_policy.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/local_app_lock_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class LocalSecuritySettingsCard extends StatefulWidget {
  const LocalSecuritySettingsCard({required this.controller, super.key});

  final LocalAppLockController controller;

  @override
  State<LocalSecuritySettingsCard> createState() =>
      _LocalSecuritySettingsCardState();
}

class _LocalSecuritySettingsCardState extends State<LocalSecuritySettingsCard> {
  bool _isChanging = false;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final policy = widget.controller.policy.value;
        final enabled = policy.isEnabled;

        return GlassCard(
          key: const ValueKey('local-security-settings-card'),
          padding: AppCardPaddings.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: context.palette.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.tr('Seguridad local', 'Local security'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.tr(
                  'Protege tus tareas, rutinas y objetivos con la seguridad '
                      'registrada en este dispositivo.',
                  'Protect your tasks, routines, and goals with the security '
                      'registered on this device.',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                key: const ValueKey('local-security-switch'),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  context.tr(
                    'Bloquear MichiFocus',
                    'Lock MichiFocus',
                  ),
                ),
                subtitle: Text(
                  context.tr(
                    'Para cambiar esta opción, Android solicitará tu huella, '
                        'rostro, PIN, patrón o contraseña.',
                    'Android will request your fingerprint, face, PIN, pattern, '
                        'or password before changing this option.',
                  ),
                ),
                value: enabled,
                onChanged: _isChanging
                    ? null
                    : (value) => _changePolicy(
                        value
                            ? LocalUnlockPolicy.afterFiveMinutes
                            : LocalUnlockPolicy.disabled,
                      ),
              ),
              if (enabled) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<LocalUnlockPolicy>(
                  key: const ValueKey('local-security-timeout'),
                  value: policy,
                  decoration: InputDecoration(
                    labelText: context.tr(
                      'Solicitar desbloqueo',
                      'Require unlock',
                    ),
                    prefixIcon: const Icon(Icons.timer_outlined),
                  ),
                  items: [
                    for (final option in LocalUnlockPolicy.values)
                      if (option.isEnabled)
                        DropdownMenuItem(
                          value: option,
                          child: Text(_policyLabel(context, option)),
                        ),
                  ],
                  onChanged: _isChanging
                      ? null
                      : (value) {
                          if (value != null && value != policy) {
                            _changePolicy(value);
                          }
                        },
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr(
                    'Recomendado: después de 5 minutos.',
                    'Recommended: after 5 minutes.',
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _changePolicy(LocalUnlockPolicy nextPolicy) async {
    final authenticationMessage = context.tr(
      'No se cambió la protección. Completa la autenticación de Android.',
      'Protection was not changed. Complete Android authentication.',
    );
    final enabledMessage = context.tr(
      'Protección local activada.',
      'Local protection enabled.',
    );
    final disabledMessage = context.tr(
      'Protección local desactivada.',
      'Local protection disabled.',
    );
    final saveFailureMessage = context.tr(
      'No se pudo guardar la configuración de seguridad.',
      'The security setting could not be saved.',
    );
    setState(() => _isChanging = true);
    try {
      final authenticated = await widget.controller.requestUnlock();
      if (!authenticated) {
        _showMessage(authenticationMessage);
        return;
      }

      await widget.controller.applyPolicyAfterAuthentication(nextPolicy);
      _showMessage(
        nextPolicy.isEnabled ? enabledMessage : disabledMessage,
      );
    } on Object {
      _showMessage(saveFailureMessage);
    } finally {
      if (mounted) setState(() => _isChanging = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _policyLabel(BuildContext context, LocalUnlockPolicy policy) {
    return switch (policy) {
      LocalUnlockPolicy.disabled => context.tr('Nunca', 'Never'),
      LocalUnlockPolicy.immediately => context.tr(
        'Inmediatamente',
        'Immediately',
      ),
      LocalUnlockPolicy.afterOneMinute => context.tr(
        'Después de 1 minuto',
        'After 1 minute',
      ),
      LocalUnlockPolicy.afterFiveMinutes => context.tr(
        'Después de 5 minutos',
        'After 5 minutes',
      ),
    };
  }
}
