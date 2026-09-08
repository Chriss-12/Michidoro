import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/local_app_lock_gate.dart';

void main() {
  testWidgets('shows a themed blurred surface without sensitive content', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: LocalAppPrivacyShield()),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.text('Contenido sensible'), findsNothing);
  });

  testWidgets('shows application content while unlocked', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LocalAppLockGate(
          isLocked: false,
          child: Text('Contenido sensible'),
        ),
      ),
    );

    expect(find.text('Contenido sensible'), findsOneWidget);
    expect(find.text('MichiFocus está bloqueado'), findsNothing);
  });

  testWidgets('removes sensitive content from the tree while locked', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LocalAppLockGate(
          isLocked: true,
          child: Text('Contenido sensible'),
        ),
      ),
    );

    expect(find.text('Contenido sensible'), findsNothing);
    expect(find.text('MichiFocus está bloqueado'), findsOneWidget);
  });

  testWidgets('cannot request an unlock without a trusted authenticator', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LocalAppLockGate(
          isLocked: true,
          child: SizedBox.shrink(),
        ),
      ),
    );

    final button = tester.widget<ButtonStyleButton>(
      find.byKey(const ValueKey('local-app-unlock-button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('delegates unlock requests without changing lock state itself', (
    tester,
  ) async {
    var requests = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: LocalAppLockGate(
          isLocked: true,
          onUnlockRequested: () => requests += 1,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.tap(find.text('Desbloquear'));

    expect(requests, 1);
    expect(find.text('MichiFocus está bloqueado'), findsOneWidget);
  });
}
