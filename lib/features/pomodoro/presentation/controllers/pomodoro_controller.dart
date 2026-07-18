import 'dart:async';

import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum PomodoroPhase { focus, shortBreak, longBreak }

class PomodoroController {
  PomodoroController({
    required PomodoroSessionsRepository repository,
    int focusMinutes = 25,
    int shortBreakMinutes = 5,
    int longBreakMinutes = 15,
    int longBreakFrequency = 4,
    bool autoStartBreak = true,
    bool autoStartFocus = false,
  }) : _repository = repository,
       _focusSeconds = focusMinutes.clamp(5, 90) * 60,
       _shortBreakSeconds = shortBreakMinutes.clamp(1, 20) * 60,
       _longBreakSeconds = longBreakMinutes.clamp(5, 45) * 60,
       _longBreakFrequency = longBreakFrequency.clamp(3, 5),
       _autoStartBreak = autoStartBreak,
       _autoStartFocus = autoStartFocus {
    remainingSeconds.value = plannedSeconds;
  }

  final PomodoroSessionsRepository _repository;
  final FlutterSignal<bool> isRunning = signal(false);
  final FlutterSignal<PomodoroPhase> phase = signal(PomodoroPhase.focus);
  final FlutterSignal<int> remainingSeconds = signal(25 * 60);
  final FlutterSignal<List<PomodoroSession>> sessions = signal(const []);
  final FlutterSignal<String?> activeGoalId = signal(null);
  final FlutterSignal<String?> activeTaskId = signal(null);
  final FlutterSignal<String?> activeTaskTitle = signal(null);
  final FlutterSignal<int?> focusStartMoodScore = signal(null);
  final FlutterSignal<String?> pendingReflectionSessionId = signal(null);
  Future<void> Function()? onSessionCompleted;
  Future<void> Function()? onBreakCompleted;
  Future<void> Function(String goalId)? onGoalPomodoroCompleted;
  late final Computed<int> completedPomodoros = computed<int>(
    () => sessions.value.length,
  );
  late final Computed<int> totalFocusSeconds = computed<int>(
    () => sessions.value.fold<int>(
      0,
      (total, session) => total + session.focusedSeconds,
    ),
  );

  Timer? _timer;
  DateTime? _startedAt;
  int _focusSeconds;
  int _shortBreakSeconds;
  int _longBreakSeconds;
  int _longBreakFrequency;
  bool _autoStartBreak;
  bool _autoStartFocus;

  int get plannedSeconds => _focusSeconds;
  int get breakSeconds => switch (phase.value) {
    PomodoroPhase.focus => 0,
    PomodoroPhase.shortBreak => _shortBreakSeconds,
    PomodoroPhase.longBreak => _longBreakSeconds,
  };
  int get currentPhaseSeconds => switch (phase.value) {
    PomodoroPhase.focus => plannedSeconds,
    PomodoroPhase.shortBreak => _shortBreakSeconds,
    PomodoroPhase.longBreak => _longBreakSeconds,
  };
  int get elapsedFocusSeconds =>
      _clampFocusSeconds(plannedSeconds - remainingSeconds.value);

  PomodoroPhase get currentPhase => phase.value;
  String? get selectedGoalId => activeGoalId.value;
  String? get selectedTaskId => activeTaskId.value;
  String? get selectedTaskTitle => activeTaskTitle.value;
  int? get selectedFocusStartMoodScore => focusStartMoodScore.value;

  Future<void> loadSessions() async {
    sessions.value = await _repository.loadSessions();
  }

  void setFocusMinutes(int value) {
    setFocusSeconds(value.clamp(5, 90) * 60);
  }

  void setFocusSeconds(int value) {
    _focusSeconds = value.clamp(60, 90 * 60);
    if (!isRunning.value && phase.value == PomodoroPhase.focus) {
      remainingSeconds.value = plannedSeconds;
    }
  }

  void configureBreaks({
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int longBreakFrequency,
    required bool autoStartBreak,
    required bool autoStartFocus,
  }) {
    _shortBreakSeconds = shortBreakMinutes.clamp(1, 20) * 60;
    _longBreakSeconds = longBreakMinutes.clamp(5, 45) * 60;
    _longBreakFrequency = longBreakFrequency.clamp(3, 5);
    _autoStartBreak = autoStartBreak;
    _autoStartFocus = autoStartFocus;

    if (!isRunning.value && phase.value != PomodoroPhase.focus) {
      remainingSeconds.value = currentPhaseSeconds;
    }
  }

  void setShortBreakSeconds(int value) {
    _shortBreakSeconds = value.clamp(20, 20 * 60);
    if (!isRunning.value && phase.value == PomodoroPhase.shortBreak) {
      remainingSeconds.value = currentPhaseSeconds;
    }
  }

  void setFocusStartMoodScore(int? value) {
    focusStartMoodScore.value = value == null ? null : _clampMoodScore(value);
  }

  set selectedGoalId(String? goalId) {
    activeGoalId.value = goalId;
  }

  void selectTask({
    required String taskId,
    required String taskTitle,
    String? goalId,
  }) {
    activeTaskId.value = taskId;
    activeTaskTitle.value = taskTitle;
    activeGoalId.value = goalId;
  }

  void clearSelectedTask() {
    activeTaskId.value = null;
    activeTaskTitle.value = null;
    activeGoalId.value = null;
  }

  void clearSelectedGoal(String goalId) {
    if (activeGoalId.value != goalId) {
      return;
    }

    activeGoalId.value = null;
  }

  void start() {
    if (isRunning.value) {
      return;
    }

    if (remainingSeconds.value <= 0) {
      remainingSeconds.value = currentPhaseSeconds;
    }

    if (phase.value == PomodoroPhase.focus) {
      _startedAt ??= DateTime.now();
    }
    isRunning.value = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      unawaited(tick());
    });
  }

  void pause() {
    _timer?.cancel();
    isRunning.value = false;
  }

  void reset() {
    _timer?.cancel();
    isRunning.value = false;
    phase.value = PomodoroPhase.focus;
    remainingSeconds.value = plannedSeconds;
    _startedAt = null;
  }

  void discardSession() {
    reset();
  }

  void restartSession() {
    reset();
    start();
  }

  Future<void> finishEarly() async {
    if (phase.value != PomodoroPhase.focus) {
      await completeBreak();
      return;
    }

    final focusedSeconds = elapsedFocusSeconds;
    if (focusedSeconds <= 0) {
      reset();
      return;
    }

    await completeSession(focusedSeconds: focusedSeconds);
  }

  Future<void> tick() async {
    if (!isRunning.value) {
      return;
    }

    if (remainingSeconds.value <= 1) {
      remainingSeconds.value = 0;
      if (phase.value == PomodoroPhase.focus) {
        await completeSession();
      } else {
        await completeBreak();
      }
      return;
    }

    remainingSeconds.value -= 1;
  }

  Future<void> completeSession({int? focusedSeconds}) async {
    _startedAt ??= DateTime.now();

    _timer?.cancel();
    isRunning.value = false;
    remainingSeconds.value = 0;
    final recordedFocusedSeconds = focusedSeconds == null
        ? elapsedFocusSeconds
        : _clampFocusSeconds(focusedSeconds);

    final session = await _repository.saveCompletedSession(
      startedAt: _startedAt!,
      endedAt: DateTime.now(),
      plannedSeconds: plannedSeconds,
      focusedSeconds: recordedFocusedSeconds,
      goalId: activeGoalId.value,
      taskId: activeTaskId.value,
      startMoodScore: focusStartMoodScore.value,
    );

    sessions.value = [session, ...sessions.value];
    _startedAt = null;
    focusStartMoodScore.value = null;
    pendingReflectionSessionId.value = session.id;

    final goalId = session.goalId;
    final goalCompletionCallback = onGoalPomodoroCompleted;
    if (goalId != null && goalCompletionCallback != null) {
      await goalCompletionCallback(goalId);
    }

    final completionCallback = onSessionCompleted;
    if (completionCallback != null) {
      unawaited(completionCallback());
    }

    _startBreakAfterFocus();
  }

  Future<void> submitCompletionReflection({
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) async {
    final sessionId = pendingReflectionSessionId.value;
    if (sessionId == null) {
      return;
    }

    final updatedSession = await _repository.updateSessionReflection(
      sessionId: sessionId,
      endMoodScore: _clampMoodScore(endMoodScore),
      wasDistracted: wasDistracted,
      distractionMinutes: wasDistracted ? distractionMinutes.clamp(1, 600) : 0,
    );

    sessions.value = sessions.value
        .map((session) => session.id == sessionId ? updatedSession : session)
        .toList(growable: false);
    pendingReflectionSessionId.value = null;
  }

  Future<void> completeBreak() async {
    _timer?.cancel();
    isRunning.value = false;
    phase.value = PomodoroPhase.focus;
    remainingSeconds.value = plannedSeconds;

    final completionCallback = onBreakCompleted;
    if (completionCallback != null) {
      unawaited(completionCallback());
    }

    if (_autoStartFocus) {
      start();
    }
  }

  void dispose() {
    _timer?.cancel();
  }

  int _clampFocusSeconds(int value) {
    if (value < 0) {
      return 0;
    }

    if (value > plannedSeconds) {
      return plannedSeconds;
    }

    return value;
  }

  int _clampMoodScore(int value) {
    return value.clamp(1, 5);
  }

  void _startBreakAfterFocus() {
    phase.value = _nextBreakPhase();
    remainingSeconds.value = currentPhaseSeconds;

    if (_autoStartBreak) {
      start();
    }
  }

  PomodoroPhase _nextBreakPhase() {
    if (sessions.value.isNotEmpty &&
        sessions.value.length % _longBreakFrequency == 0) {
      return PomodoroPhase.longBreak;
    }

    return PomodoroPhase.shortBreak;
  }
}
