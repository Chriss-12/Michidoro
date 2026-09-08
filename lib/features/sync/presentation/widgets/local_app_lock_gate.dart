import 'dart:ui';

import 'package:flutter/material.dart';

class LocalAppPrivacyShield extends StatelessWidget {
  const LocalAppPrivacyShield({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: 'Contenido protegido y difuminado',
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.surface,
                    colorScheme.secondaryContainer,
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.7, -0.55),
              child: _PrivacyGlow(color: colorScheme.primary),
            ),
            Align(
              alignment: const Alignment(0.75, 0.55),
              child: _PrivacyGlow(color: colorScheme.secondary),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: ColoredBox(
                color: colorScheme.surface.withValues(alpha: 0.28),
              ),
            ),
            Center(
              child: Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: colorScheme.primary.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyGlow extends StatelessWidget {
  const _PrivacyGlow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.5),
      ),
    );
  }
}

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
