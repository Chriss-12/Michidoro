import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro_app_v1/main.dart';

void main() {
  testWidgets('App shows stitched views', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MichiDoro'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Chriss'), findsOneWidget);

    await tester.tap(find.text('Focus'));
    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('MODO ENFOQUE'), findsOneWidget);

    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Octubre'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(find.text('Apariencia'), findsOneWidget);
    expect(find.textContaining('Nature Focus'), findsWidgets);
  });
}
