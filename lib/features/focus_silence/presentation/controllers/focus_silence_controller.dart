import 'dart:async';

import 'package:pomodoro_app_v1/features/focus_silence/domain/entities/focus_silence_preferences.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/repositories/focus_silence_preferences_repository.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/services/focus_silence_platform.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FocusSilenceController {
  FocusSilenceController({
    required FocusSilencePreferencesRepository repository,
    required FocusSilencePlatform platform,
  }) : _repository = repository,
       _platform = platform;

  final FocusSilencePreferencesRepository _repository;
  final FocusSilencePlatform _platform;

  final FlutterSignal<FocusSilencePreferences> preferences = signal(
    const FocusSilencePreferences(),
  );
  final FlutterSignal<FocusSilenceCapability> capability = signal(
    const FocusSilenceCapability.unsupported(),
  );
  final FlutterSignal<bool?> currentPlanOverride = signal(null);
  final FlutterSignal<bool> isBusy = signal(false);
  final FlutterSignal<String?> warning = signal(null);

  bool _hadPlan = false;
  bool _lastHasActiveRuntime = false;
  bool _lastHasStartedRuntime = false;
  bool _lastIsRunning = false;
  PomodoroPhase _lastPhase = PomodoroPhase.focus;
  int _lastRemainingSeconds = 0;
  bool _isAppForeground = true;
  bool _pendingPlanEnable = false;
  bool _pendingGlobalEnable = false;
  Future<void> _operation = Future<void>.value();

  bool get effectivePlanEnabled =>
      currentPlanOverride.value ?? preferences.value.enableWithPomodoro;

  Future<void> initialize() async {
    preferences.value = await _repository.load();
    await refreshCapability();
  }

  Future<void> refreshCapability() async {
    try {
      capability.value = await _platform.getCapability();
      warning.value = null;
      if (capability.value.isAuthorized) {
        if (_pendingGlobalEnable) {
          _pendingGlobalEnable = false;
          await setEnableWithPomodoro(enabled: true);
        }
        if (_pendingPlanEnable && _lastHasActiveRuntime) {
          _pendingPlanEnable = false;
          currentPlanOverride.value = true;
        }
      } else {
        _pendingGlobalEnable = false;
        _pendingPlanEnable = false;
      }
      await _queueReconcile();
    } on Object {
      warning.value = 'No se pudo consultar No molestar en Android.';
    }
  }

  Future<void> requestAuthorization({required bool forCurrentPlan}) async {
    if (forCurrentPlan) {
      _pendingPlanEnable = true;
    } else {
      _pendingGlobalEnable = true;
    }
    await _platform.openPolicyAccessSettings();
  }

  Future<void> setEnableWithPomodoro({required bool enabled}) async {
    preferences.value = preferences.value.copyWith(
      enableWithPomodoro: enabled,
    );
    await _repository.save(preferences.value);
    await _queueReconcile();
  }

  Future<void> setProfile(FocusSilenceProfile value) async {
    preferences.value = preferences.value.copyWith(profile: value);
    await _repository.save(preferences.value);
    await _queueReconcile();
  }

  Future<void> setCurrentPlanEnabled({required bool enabled}) async {
    currentPlanOverride.value = enabled;
    await _queueReconcile();
  }

  Future<void> reconcilePomodoro(PomodoroController pomodoro) {
    final hasPlan = pomodoro.hasActiveRuntime.value;
    if (hasPlan && !_hadPlan) {
      currentPlanOverride.value = null;
    } else if (!hasPlan && _hadPlan) {
      currentPlanOverride.value = null;
      _pendingPlanEnable = false;
    }
    _hadPlan = hasPlan;
    _lastHasActiveRuntime = hasPlan;
    _lastHasStartedRuntime = pomodoro.hasStartedRuntime.value;
    _lastIsRunning = pomodoro.isRunning.value;
    _lastPhase = pomodoro.phase.value;
    _lastRemainingSeconds = pomodoro.remainingSeconds.value;
    return _queueReconcile();
  }

  Future<void> setAppForeground({required bool isForeground}) {
    _isAppForeground = isForeground;
    return _queueReconcile();
  }

  Future<void> stop() async {
    currentPlanOverride.value = false;
    await _queueReconcile(forceInactive: true);
  }

  Future<void> _queueReconcile({bool forceInactive = false}) {
    return _operation = _operation.then(
      (_) => _applyDesiredState(forceInactive: forceInactive),
      onError: (_) => _applyDesiredState(forceInactive: forceInactive),
    );
  }

  Future<void> _applyDesiredState({required bool forceInactive}) async {
    final shouldBeActive =
        !forceInactive &&
        _lastHasActiveRuntime &&
        _lastHasStartedRuntime &&
        _isAppForeground &&
        _lastPhase == PomodoroPhase.focus &&
        effectivePlanEnabled &&
        _lastIsRunning;

    if (shouldBeActive && !capability.value.isAuthorized) {
      warning.value = 'Autoriza No molestar para activar la protección.';
      return;
    }
    if (!capability.value.isSupported ||
        (!shouldBeActive && !capability.value.isActive)) {
      return;
    }

    isBusy.value = true;
    try {
      capability.value = await _platform.setActive(
        active: shouldBeActive,
        profile: preferences.value.profile,
        endsAt: shouldBeActive
            ? DateTime.now().add(
                Duration(
                  seconds: _lastRemainingSeconds.clamp(1, 12 * 60 * 60),
                ),
              )
            : null,
      );
      warning.value = null;
    } on Object {
      warning.value = shouldBeActive
          ? 'Android no pudo activar el silencio de enfoque.'
          : 'Android no pudo finalizar el silencio de enfoque.';
    } finally {
      isBusy.value = false;
    }
  }
}
