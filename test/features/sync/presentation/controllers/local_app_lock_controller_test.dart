import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/local_unlock_policy.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/local_unlock_policy_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/local_app_lock_controller.dart';

void main() {
  group('LocalAppLockController', () {
    test('starts unlocked when local protection is disabled', () {
      final clock = _MonotonicClock();
      final controller = LocalAppLockController(monotonicNow: clock.call);

      expect(controller.policy.value, LocalUnlockPolicy.disabled);
      expect(controller.isLocked.value, isFalse);
    });

    test(
      'starts locked after a process restart when protection is enabled',
      () {
        final clock = _MonotonicClock();
        final controller = LocalAppLockController(
          initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
          monotonicNow: clock.call,
        );

        expect(controller.isLocked.value, isTrue);
      },
    );

    test(
      'enables a policy only after the setup authentication succeeded',
      () async {
        final clock = _MonotonicClock();
        final controller = LocalAppLockController(monotonicNow: clock.call);

        await controller.applyPolicyAfterAuthentication(
          LocalUnlockPolicy.afterFiveMinutes,
        );

        expect(controller.policy.value, LocalUnlockPolicy.afterFiveMinutes);
        expect(controller.isLocked.value, isFalse);
      },
    );

    test('locks immediately when configured to do so', () {
      final clock = _MonotonicClock();
      final controller =
          LocalAppLockController(
              initialPolicy: LocalUnlockPolicy.immediately,
              monotonicNow: clock.call,
            )
            ..authenticationSucceeded()
            ..onBackgrounded();

      expect(controller.isLocked.value, isTrue);
    });

    test('keeps the app unlocked inside the configured grace period', () {
      final clock = _MonotonicClock();
      final controller =
          LocalAppLockController(
              initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
              monotonicNow: clock.call,
            )
            ..authenticationSucceeded()
            ..onBackgrounded();

      clock.advance(const Duration(minutes: 4, seconds: 59));
      controller.onResumed();

      expect(controller.isLocked.value, isFalse);
    });

    test('locks at the configured grace-period boundary', () {
      final clock = _MonotonicClock();
      final controller =
          LocalAppLockController(
              initialPolicy: LocalUnlockPolicy.afterOneMinute,
              monotonicNow: clock.call,
            )
            ..authenticationSucceeded()
            ..onBackgrounded();

      clock.advance(const Duration(minutes: 1));
      controller.onResumed();

      expect(controller.isLocked.value, isTrue);
    });

    test('does not extend the grace period on repeated lifecycle events', () {
      final clock = _MonotonicClock();
      final controller =
          LocalAppLockController(
              initialPolicy: LocalUnlockPolicy.afterOneMinute,
              monotonicNow: clock.call,
            )
            ..authenticationSucceeded()
            ..onBackgrounded();

      clock.advance(const Duration(seconds: 40));
      controller.onBackgrounded();
      clock.advance(const Duration(seconds: 20));
      controller.onResumed();

      expect(controller.isLocked.value, isTrue);
    });

    test('inactive does not start the background grace period', () {
      final clock = _MonotonicClock();
      final controller = LocalAppLockController(
        initialPolicy: LocalUnlockPolicy.afterOneMinute,
        monotonicNow: clock.call,
      )..authenticationSucceeded();
      final changeLifecycle = controller.onLifecycleStateChanged;

      changeLifecycle(AppLifecycleState.inactive);
      expect(controller.isContentObscured.value, isTrue);
      clock.advance(const Duration(minutes: 2));
      changeLifecycle(AppLifecycleState.resumed);

      expect(controller.isLocked.value, isFalse);
      expect(controller.isContentObscured.value, isFalse);
    });

    test('hidden starts one grace period until the app resumes', () {
      final clock = _MonotonicClock();
      final controller = LocalAppLockController(
        initialPolicy: LocalUnlockPolicy.afterOneMinute,
        monotonicNow: clock.call,
      )..authenticationSucceeded();
      final changeLifecycle = controller.onLifecycleStateChanged;

      changeLifecycle(AppLifecycleState.inactive);
      changeLifecycle(AppLifecycleState.hidden);
      clock.advance(const Duration(seconds: 40));
      changeLifecycle(AppLifecycleState.paused);
      clock.advance(const Duration(seconds: 20));
      changeLifecycle(AppLifecycleState.resumed);

      expect(controller.isLocked.value, isTrue);
      expect(controller.isContentObscured.value, isTrue);
    });

    test('fails closed when the monotonic source moves backwards', () {
      final clock = _MonotonicClock()..elapsed = const Duration(minutes: 5);
      final controller =
          LocalAppLockController(
              initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
              monotonicNow: clock.call,
            )
            ..authenticationSucceeded()
            ..onBackgrounded();

      clock.elapsed = const Duration(minutes: 4);
      controller.onResumed();

      expect(controller.isLocked.value, isTrue);
    });

    test('a failed or cancelled authentication remains locked', () {
      final clock = _MonotonicClock();
      final controller = LocalAppLockController(
        initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
        monotonicNow: clock.call,
      )..authenticationFailedOrCancelled();

      expect(controller.isLocked.value, isTrue);
    });

    test('disabling protection clears an existing lock', () async {
      final clock = _MonotonicClock();
      final controller = LocalAppLockController(
        initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
        monotonicNow: clock.call,
      );

      await controller.applyPolicyAfterAuthentication(
        LocalUnlockPolicy.disabled,
      );

      expect(controller.policy.value, LocalUnlockPolicy.disabled);
      expect(controller.isLocked.value, isFalse);
      expect(controller.isContentObscured.value, isFalse);
    });

    test(
      'updates native recent-app protection with the stored policy',
      () async {
        final repository = _FakeLocalUnlockPolicyRepository(
          LocalUnlockPolicy.afterFiveMinutes,
        );
        final protectionStates = <bool>[];
        final controller = LocalAppLockController(
          repository: repository,
          setContentProtection: ({required enabled}) async {
            protectionStates.add(enabled);
          },
        );

        await controller.loadPolicy();
        await controller.applyPolicyAfterAuthentication(
          LocalUnlockPolicy.disabled,
        );

        expect(protectionStates, [true, false]);
      },
    );

    test('loads a persisted enabled policy in the locked state', () async {
      final repository = _FakeLocalUnlockPolicyRepository(
        LocalUnlockPolicy.afterOneMinute,
      );
      final controller = LocalAppLockController(repository: repository);

      await controller.loadPolicy();

      expect(controller.policy.value, LocalUnlockPolicy.afterOneMinute);
      expect(controller.isLocked.value, isTrue);
    });

    test(
      'persists an authenticated policy change before applying it',
      () async {
        final repository = _FakeLocalUnlockPolicyRepository(
          LocalUnlockPolicy.disabled,
        );
        final controller = LocalAppLockController(repository: repository);

        await controller.applyPolicyAfterAuthentication(
          LocalUnlockPolicy.afterFiveMinutes,
        );

        expect(repository.policy, LocalUnlockPolicy.afterFiveMinutes);
        expect(controller.policy.value, LocalUnlockPolicy.afterFiveMinutes);
        expect(controller.isLocked.value, isFalse);
      },
    );

    test('unlocks only after trusted device authentication succeeds', () async {
      final authenticator = _FakeLocalDeviceAuthenticator(
        available: true,
        authenticated: true,
      );
      final controller = LocalAppLockController(
        initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
        authenticator: authenticator,
      );

      expect(await controller.requestUnlock(), isTrue);
      expect(controller.isLocked.value, isFalse);
      expect(controller.isContentObscured.value, isFalse);
    });

    test('stays locked when device authentication is unavailable', () async {
      final authenticator = _FakeLocalDeviceAuthenticator(
        available: false,
        authenticated: true,
      );
      final controller = LocalAppLockController(
        initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
        authenticator: authenticator,
      );

      expect(await controller.requestUnlock(), isFalse);
      expect(controller.isLocked.value, isTrue);
      expect(authenticator.authenticationRequests, 0);
    });

    test('stays locked when device authentication is cancelled', () async {
      final authenticator = _FakeLocalDeviceAuthenticator(
        available: true,
        authenticated: false,
      );
      final controller = LocalAppLockController(
        initialPolicy: LocalUnlockPolicy.afterFiveMinutes,
        authenticator: authenticator,
      );

      expect(await controller.requestUnlock(), isFalse);
      expect(controller.isLocked.value, isTrue);
    });
  });
}

class _MonotonicClock {
  Duration elapsed = Duration.zero;

  Duration call() => elapsed;

  void advance(Duration duration) {
    elapsed += duration;
  }
}

class _FakeLocalUnlockPolicyRepository implements LocalUnlockPolicyRepository {
  _FakeLocalUnlockPolicyRepository(this.policy);

  LocalUnlockPolicy policy;

  @override
  Future<LocalUnlockPolicy> load() async => policy;

  @override
  Future<void> save(LocalUnlockPolicy policy) async {
    this.policy = policy;
  }
}

class _FakeLocalDeviceAuthenticator implements LocalDeviceAuthenticator {
  _FakeLocalDeviceAuthenticator({
    required this.available,
    required this.authenticated,
  });

  final bool available;
  final bool authenticated;
  int authenticationRequests = 0;

  @override
  Future<bool> authenticate() async {
    authenticationRequests += 1;
    return authenticated;
  }

  @override
  Future<bool> isAvailable() async => available;
}
