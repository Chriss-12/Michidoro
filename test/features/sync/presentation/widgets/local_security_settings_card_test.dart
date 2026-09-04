import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/local_unlock_policy.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/local_unlock_policy_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/local_app_lock_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/local_security_settings_card.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('enables protection with the recommended five-minute policy', (
    tester,
  ) async {
    final repository = _MemoryPolicyRepository(LocalUnlockPolicy.disabled);
    final authenticator = _FakeAuthenticator(authenticated: true);
    final controller = LocalAppLockController(
      repository: repository,
      authenticator: authenticator,
    );
    await _pumpCard(tester, controller);

    await tester.tap(find.byKey(const ValueKey('local-security-switch')));
    await tester.pumpAndSettle();

    expect(controller.policy.value, LocalUnlockPolicy.afterFiveMinutes);
    expect(repository.policy, LocalUnlockPolicy.afterFiveMinutes);
    expect(authenticator.requests, 1);
    expect(
      find.byKey(const ValueKey('local-security-timeout')),
      findsOneWidget,
    );
    expect(
      find.textContaining('pasa realmente a segundo plano'),
      findsOneWidget,
    );
  });

  testWidgets('does not change protection when authentication is cancelled', (
    tester,
  ) async {
    final repository = _MemoryPolicyRepository(LocalUnlockPolicy.disabled);
    final controller = LocalAppLockController(
      repository: repository,
      authenticator: _FakeAuthenticator(authenticated: false),
    );
    await _pumpCard(tester, controller);

    await tester.tap(find.byKey(const ValueKey('local-security-switch')));
    await tester.pumpAndSettle();

    expect(controller.policy.value, LocalUnlockPolicy.disabled);
    expect(repository.policy, LocalUnlockPolicy.disabled);
    expect(find.textContaining('No se cambió la protección'), findsOneWidget);
  });

  testWidgets('authenticates before changing the timeout', (tester) async {
    final repository = _MemoryPolicyRepository(
      LocalUnlockPolicy.afterFiveMinutes,
    );
    final authenticator = _FakeAuthenticator(authenticated: true);
    final controller = LocalAppLockController(
      initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
      repository: repository,
      authenticator: authenticator,
    )..authenticationSucceeded();
    await _pumpCard(tester, controller);

    await tester.tap(find.byKey(const ValueKey('local-security-timeout')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inmediatamente').last);
    await tester.pumpAndSettle();

    expect(controller.policy.value, LocalUnlockPolicy.immediately);
    expect(repository.policy, LocalUnlockPolicy.immediately);
    expect(authenticator.requests, 1);
  });

  testWidgets('authenticates before disabling protection', (tester) async {
    final repository = _MemoryPolicyRepository(
      LocalUnlockPolicy.afterOneMinute,
    );
    final authenticator = _FakeAuthenticator(authenticated: true);
    final controller = LocalAppLockController(
      initialPolicy: LocalUnlockPolicy.afterOneMinute,
      repository: repository,
      authenticator: authenticator,
    )..authenticationSucceeded();
    await _pumpCard(tester, controller);

    await tester.tap(find.byKey(const ValueKey('local-security-switch')));
    await tester.pumpAndSettle();

    expect(controller.policy.value, LocalUnlockPolicy.disabled);
    expect(repository.policy, LocalUnlockPolicy.disabled);
    expect(authenticator.requests, 1);
  });
}

Future<void> _pumpCard(
  WidgetTester tester,
  LocalAppLockController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.fromPreset(AppThemePreset.natureFocus, isDark: false),
      home: Scaffold(
        body: SingleChildScrollView(
          child: LocalSecuritySettingsCard(controller: controller),
        ),
      ),
    ),
  );
}

class _MemoryPolicyRepository implements LocalUnlockPolicyRepository {
  _MemoryPolicyRepository(this.policy);

  LocalUnlockPolicy policy;

  @override
  Future<LocalUnlockPolicy> load() async => policy;

  @override
  Future<void> save(LocalUnlockPolicy policy) async {
    this.policy = policy;
  }
}

class _FakeAuthenticator implements LocalDeviceAuthenticator {
  _FakeAuthenticator({required this.authenticated});

  final bool authenticated;
  int requests = 0;

  @override
  Future<bool> authenticate() async {
    requests += 1;
    return authenticated;
  }

  @override
  Future<bool> isAvailable() async => true;
}
