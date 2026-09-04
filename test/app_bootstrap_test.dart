import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/splash/presentation/pages/splash_page.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:pomodoro_app_v1/main.dart';

void main() {
  testWidgets(
    'does not show loading or start bootstrap before authentication',
    (
      tester,
    ) async {
      final authentication = Completer<bool>();
      var bootstrapCalls = 0;

      await tester.pumpWidget(
        AppBootstrap(
          startupAuthenticator: _FakeAuthenticator(
            authentication: authentication.future,
          ),
          initializeApp: () async => bootstrapCalls += 1,
        ),
      );
      await tester.pump();

      expect(find.text('MichiFocus está bloqueado'), findsOneWidget);
      expect(find.textContaining('%'), findsNothing);
      expect(bootstrapCalls, 0);

      authentication.complete(false);
      await tester.pump();
    },
  );

  testWidgets('cancelled authentication never starts bootstrap', (
    tester,
  ) async {
    var bootstrapCalls = 0;

    await tester.pumpWidget(
      AppBootstrap(
        startupAuthenticator: _FakeAuthenticator(
          authentication: Future<bool>.value(false),
        ),
        initializeApp: () async => bootstrapCalls += 1,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(bootstrapCalls, 0);
    expect(find.textContaining('%'), findsNothing);
    expect(find.text('Desbloquear'), findsOneWidget);
  });

  testWidgets('successful authentication starts bootstrap exactly once', (
    tester,
  ) async {
    final initialization = Completer<void>();
    var bootstrapCalls = 0;

    await tester.pumpWidget(
      AppBootstrap(
        startupAuthenticator: _FakeAuthenticator(
          authentication: Future<bool>.value(true),
        ),
        initializeApp: () {
          bootstrapCalls += 1;
          return initialization.future;
        },
        initializedApp: const MaterialApp(home: Text('Aplicación lista')),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(bootstrapCalls, 1);
    expect(find.textContaining('%'), findsOneWidget);

    await tester.pump();
    expect(bootstrapCalls, 1);

    initialization.complete();
    await tester.pump();
    expect(find.text('Aplicación lista'), findsOneWidget);
  });

  testWidgets('uses the saved appearance before showing startup loading', (
    tester,
  ) async {
    final initialization = Completer<void>();
    addTearDown(() {
      appSettingsController
        ..themePreset.value = AppThemePreset.natureFocus
        ..isDarkMode.value = false;
    });

    await tester.pumpWidget(
      AppBootstrap(
        startupAuthenticator: _FakeAuthenticator(
          authentication: Future<bool>.value(true),
        ),
        loadStartupPreferences: () async {
          appSettingsController
            ..themePreset.value = AppThemePreset.sunsetTide
            ..isDarkMode.value = true;
        },
        initializeApp: () => initialization.future,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
    final context = tester.element(find.byType(SplashPage));
    final actualPalette = Theme.of(context).extension<AppPalette>();
    final expectedPalette = AppPalette.fromPreset(
      AppThemePreset.sunsetTide,
      isDark: true,
    );
    expect(actualPalette?.background, expectedPalette.background);
    expect(actualPalette?.primary, expectedPalette.primary);

    initialization.complete();
  });
}

class _FakeAuthenticator implements LocalDeviceAuthenticator {
  const _FakeAuthenticator({required this.authentication});

  final Future<bool> authentication;

  @override
  Future<bool> authenticate() => authentication;

  @override
  Future<bool> isAvailable() async => true;
}
