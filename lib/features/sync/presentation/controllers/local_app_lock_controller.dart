import 'package:pomodoro_app_v1/features/sync/domain/entities/local_unlock_policy.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/local_unlock_policy_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:signals_flutter/signals_flutter.dart';

typedef MonotonicNow = Duration Function();

class LocalAppLockController {
  factory LocalAppLockController({
    LocalUnlockPolicy initialPolicy = LocalUnlockPolicy.disabled,
    MonotonicNow? monotonicNow,
    LocalUnlockPolicyRepository? repository,
    LocalDeviceAuthenticator? authenticator,
  }) {
    final stopwatch = Stopwatch()..start();
    return LocalAppLockController._(
      initialPolicy: initialPolicy,
      monotonicNow: monotonicNow ?? () => stopwatch.elapsed,
      repository: repository,
      authenticator: authenticator,
    );
  }

  LocalAppLockController._({
    required LocalUnlockPolicy initialPolicy,
    required MonotonicNow monotonicNow,
    required LocalUnlockPolicyRepository? repository,
    required LocalDeviceAuthenticator? authenticator,
  }) : policy = signal(initialPolicy),
       isLocked = signal(initialPolicy.isEnabled),
       _monotonicNow = monotonicNow,
       _repository = repository,
       _authenticator = authenticator;

  final FlutterSignal<LocalUnlockPolicy> policy;
  final FlutterSignal<bool> isLocked;
  final MonotonicNow _monotonicNow;
  final LocalUnlockPolicyRepository? _repository;
  final LocalDeviceAuthenticator? _authenticator;

  Duration? _backgroundedAt;

  Future<void> loadPolicy() async {
    final repository = _repository;
    if (repository == null) return;

    final storedPolicy = await repository.load();
    policy.value = storedPolicy;
    isLocked.value = storedPolicy.isEnabled;
    _backgroundedAt = null;
  }

  Future<void> applyPolicyAfterAuthentication(
    LocalUnlockPolicy nextPolicy,
  ) async {
    await _repository?.save(nextPolicy);
    policy.value = nextPolicy;
    isLocked.value = false;
    _backgroundedAt = null;
  }

  void onBackgrounded() {
    if (!policy.value.isEnabled || _backgroundedAt != null) return;
    _backgroundedAt = _monotonicNow();
    if (policy.value == LocalUnlockPolicy.immediately) {
      isLocked.value = true;
    }
  }

  void onResumed() {
    final activePolicy = policy.value;
    if (!activePolicy.isEnabled) {
      isLocked.value = false;
      _backgroundedAt = null;
      return;
    }

    final backgroundedAt = _backgroundedAt;
    if (backgroundedAt == null) return;

    final elapsed = _monotonicNow() - backgroundedAt;
    final gracePeriod = activePolicy.gracePeriod!;
    if (elapsed.isNegative || elapsed >= gracePeriod) {
      isLocked.value = true;
    }
    _backgroundedAt = null;
  }

  void authenticationSucceeded() {
    isLocked.value = false;
    _backgroundedAt = null;
  }

  void authenticationFailedOrCancelled() {
    if (policy.value.isEnabled) isLocked.value = true;
  }

  Future<bool> requestUnlock() async {
    final authenticator = _authenticator;
    if (authenticator == null || !await authenticator.isAvailable()) {
      authenticationFailedOrCancelled();
      return false;
    }

    final authenticated = await authenticator.authenticate();
    if (authenticated) {
      authenticationSucceeded();
    } else {
      authenticationFailedOrCancelled();
    }
    return authenticated;
  }

  void lockNow() {
    if (policy.value.isEnabled) isLocked.value = true;
  }
}
