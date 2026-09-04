import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/entities/focus_silence_preferences.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/repositories/focus_silence_preferences_repository.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/services/focus_silence_platform.dart';
import 'package:pomodoro_app_v1/features/focus_silence/presentation/controllers/focus_silence_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';

void main() {
  group('FocusSilenceController', () {
    late _MemoryPreferencesRepository repository;
    late _FakeFocusSilencePlatform platform;
    late FocusSilenceController controller;
    late PomodoroController pomodoro;

    setUp(() async {
      repository = _MemoryPreferencesRepository();
      platform = _FakeFocusSilencePlatform();
      controller = FocusSilenceController(
        repository: repository,
        platform: platform,
      );
      pomodoro = PomodoroController(repository: _MemorySessionsRepository());
      await controller.initialize();
    });

    test(
      'is disabled by default and does not activate at focus start',
      () async {
        _setRunningFocus(pomodoro);

        await controller.reconcilePomodoro(pomodoro);

        expect(platform.activeChanges, isEmpty);
        expect(controller.effectivePlanEnabled, isFalse);
      },
    );

    test('activates on focus and restores during break', () async {
      await controller.setEnableWithPomodoro(enabled: true);
      _setRunningFocus(pomodoro);
      await controller.reconcilePomodoro(pomodoro);

      expect(platform.activeChanges, <bool>[true]);

      pomodoro.phase.value = PomodoroPhase.shortBreak;
      await controller.reconcilePomodoro(pomodoro);

      expect(platform.activeChanges, <bool>[true, false]);
    });

    test(
      'plan override is temporary and pausing always restores notifications',
      () async {
        await controller.setEnableWithPomodoro(enabled: true);
        _setRunningFocus(pomodoro);
        await controller.reconcilePomodoro(pomodoro);

        pomodoro.isRunning.value = false;
        await controller.reconcilePomodoro(pomodoro);
        expect(platform.activeChanges.last, isFalse);

        pomodoro.isRunning.value = true;
        await controller.setCurrentPlanEnabled(enabled: false);
        await controller.reconcilePomodoro(pomodoro);
        expect(controller.effectivePlanEnabled, isFalse);
        expect(repository.value.enableWithPomodoro, isTrue);

        pomodoro.hasActiveRuntime.value = false;
        await controller.reconcilePomodoro(pomodoro);
        expect(controller.currentPlanOverride.value, isNull);
        expect(controller.effectivePlanEnabled, isTrue);
      },
    );

    test('leaving the app restores notifications until returning', () async {
      await controller.setEnableWithPomodoro(enabled: true);
      _setRunningFocus(pomodoro);
      await controller.reconcilePomodoro(pomodoro);

      await controller.setAppForeground(isForeground: false);
      expect(platform.activeChanges, <bool>[true, false]);

      await controller.setAppForeground(isForeground: true);
      expect(platform.activeChanges, <bool>[true, false, true]);
    });
  });
}

void _setRunningFocus(PomodoroController pomodoro) {
  pomodoro
    ..hasActiveRuntime.value = true
    ..hasStartedRuntime.value = true
    ..isRunning.value = true
    ..phase.value = PomodoroPhase.focus
    ..remainingSeconds.value = 300;
}

class _MemoryPreferencesRepository
    implements FocusSilencePreferencesRepository {
  FocusSilencePreferences value = const FocusSilencePreferences();

  @override
  Future<FocusSilencePreferences> load() async => value;

  @override
  Future<void> save(FocusSilencePreferences preferences) async {
    value = preferences;
  }
}

class _FakeFocusSilencePlatform implements FocusSilencePlatform {
  bool active = false;
  final List<bool> activeChanges = [];

  @override
  Future<FocusSilenceCapability> getCapability() async =>
      FocusSilenceCapability(
        isSupported: true,
        isAuthorized: true,
        isActive: active,
        apiLevel: 35,
      );

  @override
  Future<void> openPolicyAccessSettings() async {}

  @override
  Future<FocusSilenceCapability> setActive({
    required bool active,
    required FocusSilenceProfile profile,
    DateTime? endsAt,
  }) async {
    this.active = active;
    activeChanges.add(active);
    return getCapability();
  }
}

class _MemorySessionsRepository implements PomodoroSessionsRepository {
  @override
  Future<List<PomodoroSession>> loadSessions() async => const [];

  @override
  Future<PomodoroSession> saveCompletedSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedSeconds,
    required int focusedSeconds,
    String? goalId,
    String? taskId,
    int? startMoodScore,
    PomodoroSessionStatus status = PomodoroSessionStatus.completed,
  }) async {
    return PomodoroSession(
      id: 'session',
      startedAt: startedAt,
      endedAt: endedAt,
      plannedSeconds: plannedSeconds,
      focusedSeconds: focusedSeconds,
      status: status,
      goalId: goalId,
      taskId: taskId,
      startMoodScore: startMoodScore,
    );
  }

  @override
  Future<PomodoroSession> updateSessionReflection({
    required String sessionId,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) {
    throw UnimplementedError();
  }
}
