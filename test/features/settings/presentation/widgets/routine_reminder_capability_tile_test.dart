import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/routine_reminder_scheduler.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/widgets/routine_reminder_capability_tile.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('shows denied permission without blocking routine use', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const RoutineReminderCapability(
          notificationPermissionGranted: false,
          exactSchedulingAvailable: false,
        ),
      ),
    );

    expect(find.text('Recordatorios del sistema desactivados'), findsOneWidget);
    expect(
      find.textContaining('Tus rutinas seguirán funcionando'),
      findsOneWidget,
    );
    expect(find.text('Abrir ajustes de Android'), findsOneWidget);
  });

  testWidgets('explains inexact delivery while reminders remain enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const RoutineReminderCapability(
          notificationPermissionGranted: true,
          exactSchedulingAvailable: false,
        ),
      ),
    );

    expect(find.text('Entrega flexible activa'), findsOneWidget);
    expect(find.textContaining('Android puede retrasar'), findsOneWidget);
    expect(find.text('Abrir ajustes de Android'), findsNothing);
  });
}

Widget _app(RoutineReminderCapability capability) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: RoutineReminderCapabilityTile(capability: capability),
    ),
  );
}
