import 'package:flutter/material.dart';

class LocalAppLockGate extends StatelessWidget {
  const LocalAppLockGate({
    required this.isLocked,
    required this.child,
    this.onUnlockRequested,
    super.key,
  });

  final bool isLocked;
  final Widget child;
  final VoidCallback? onUnlockRequested;

  @override
  Widget build(BuildContext context) {
    if (!isLocked) return child;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ColoredBox(
      color: colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Semantics(
                namesRoute: true,
                label: 'MichiFocus bloqueado',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 56,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'MichiFocus está bloqueado',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Autentícate con la seguridad registrada en este '
                      'dispositivo para ver tus datos.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const ValueKey('local-app-unlock-button'),
                        onPressed: onUnlockRequested,
                        icon: const Icon(Icons.fingerprint_rounded),
                        label: const Text('Desbloquear'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
