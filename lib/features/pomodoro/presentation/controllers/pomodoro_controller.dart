import 'dart:async';

import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_task_plan.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_runtime_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/services/pomodoro_task_planner.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum PomodoroPhase { focus, shortBreak, longBreak }

class PomodoroController {
  PomodoroController({
    required PomodoroSessionsRepository repository,
    PomodoroRuntimeRepository? runtimeRepository,
    int focusMinutes = 25,
    int shortBreakMinutes = 5,
    int longBreakMinutes = 15,
    int longBreakFrequency = 4,
    bool autoStartBreak = true,
    bool autoStartFocus = false,
    DateTime Function()? now,
  }) : _repository = repository,
       _runtimeRepository = runtimeRepository,
       _now = now ?? DateTime.now,
       _focusSeconds = focusMinutes.clamp(5, 90) * 60,
       _shortBreakSeconds = shortBreakMinutes.clamp(1, 20) * 60,
       _longBreakSeconds = longBreakMinutes.clamp(5, 45) * 60,
       _longBreakFrequency = longBreakFrequency.clamp(3, 5),
       _autoStartBreak = autoStartBreak,
       _autoStartFocus = autoStartFocus {
    _currentFocusSeconds = _focusSeconds;
    remainingSeconds.value = plannedSeconds;
  }

  final PomodoroSessionsRepository _repository;
  final PomodoroRuntimeRepository? _runtimeRepository;
  final DateTime Function() _now;
  final FlutterSignal<bool> isRunning = signal(false);
  final FlutterSignal<PomodoroPhase> phase = signal(PomodoroPhase.focus);
  final FlutterSignal<int> remainingSeconds = signal(25 * 60);
  final FlutterSignal<List<PomodoroSession>> sessions = signal(const []);
  final FlutterSignal<String?> activeGoalId = signal(null);
  final FlutterSignal<String?> activeTaskId = signal(null);
  final FlutterSignal<String?> activeTaskTitle = signal(null);
  final FlutterSignal<int?> activeTaskEstimatedSeconds = signal(null);
  final FlutterSignal<int?> focusStartMoodScore = signal(null);
  final FlutterSignal<String?> pendingReflectionSessionId = signal(null);
  final FlutterSignal<bool> hasActiveRuntime = signal(false);
  final FlutterSignal<bool> hasStartedRuntime = signal(false);
  final FlutterSignal<bool> maximumConcentrationEnabled = signal(false);
  final FlutterSignal<PomodoroPlanMode> planMode = signal(
    PomodoroPlanMode.singleBlock,
  );
  final FlutterSignal<int> currentBlockIndex = signal(1);
  final FlutterSignal<int> totalBlocks = signal(1);
  Future<void> Function()? onSessionCompleted;
  Future<void> Function()? onBreakCompleted;
  Future<void> Function(String goalId)? onGoalPomodoroCompleted;
  Future<void> Function(String taskId)? onTaskFocusStarted;
  Future<void> Function(String taskId)? onTaskPlanCompleted;
  late final Computed<int> completedPomodoros = computed<int>(
    () => sessions.value
        .where((session) => session.status == PomodoroSessionStatus.completed)
        .length,
  );
  late final Computed<int> totalFocusSeconds = computed<int>(
    () => sessions.value.fold<int>(
      0,
      (total, session) => total + session.focusedSeconds,
    ),
  );
  late final Computed<int> activeTaskFocusedSeconds = computed<int>(() {
    final taskId = activeTaskId.value;
    if (taskId == null) {
      return 0;
    }

    return sessions.value.fold<int>(
      0,
      (total, session) =>
          session.taskId == taskId ? total + session.focusedSeconds : total,
    );
  });

  Timer? _timer;
  DateTime? _startedAt;
  DateTime? _lastTickAt;
  DateTime? _runtimeCreatedAt;
  int _focusSeconds;
  late int _currentFocusSeconds;
  int _shortBreakSeconds;
  int _longBreakSeconds;
  int _longBreakFrequency;
  bool _autoStartBreak;
  bool _autoStartFocus;
  bool _hasStructuredTaskPlan = false;
  final List<String> _pendingReflectionSessionIds = [];

  int get plannedSeconds => _focusSeconds;
  int get cadenceFocusMinutes => _focusSeconds ~/ 60;
  int get cadenceBreakMinutes => _shortBreakSeconds ~/ 60;
  int get breakSeconds => switch (phase.value) {
    PomodoroPhase.focus => 0,
    PomodoroPhase.shortBreak => _shortBreakSeconds,
    PomodoroPhase.longBreak => _longBreakSeconds,
  };
  int get currentPhaseSeconds => switch (phase.value) {
    PomodoroPhase.focus => _currentFocusSeconds,
    PomodoroPhase.shortBreak => _shortBreakSeconds,
    PomodoroPhase.longBreak => _longBreakSeconds,
  };
  int get elapsedFocusSeconds =>
      _clampFocusSeconds(currentPhaseSeconds - remainingSeconds.value);
  int get elapsedTaskFocusSeconds {
    final totalSeconds = activeTaskEstimatedSeconds.value;
    if (activeTaskId.value == null || totalSeconds == null) {
      return 0;
    }

    final currentFocusSeconds =
        phase.value == PomodoroPhase.focus && _startedAt != null
        ? elapsedFocusSeconds
        : 0;
    final elapsedSeconds = activeTaskFocusedSeconds.value + currentFocusSeconds;

    if (elapsedSeconds < 0) {
      return 0;
    }

    if (elapsedSeconds > totalSeconds) {
      return totalSeconds;
    }

    return elapsedSeconds;
  }

  double get timerProgress {
    final totalTaskSeconds = activeTaskEstimatedSeconds.value;
    if (activeTaskId.value != null && totalTaskSeconds != null) {
      if (totalTaskSeconds <= 0) {
        return 0;
      }

      return elapsedTaskFocusSeconds / totalTaskSeconds;
    }

    final totalSeconds = currentPhaseSeconds;
    if (totalSeconds <= 0) {
      return 0;
    }

    return 1 - (remainingSeconds.value / totalSeconds).clamp(0.0, 1.0);
  }

  PomodoroPhase get currentPhase => phase.value;
  String? get selectedGoalId => activeGoalId.value;
  String? get selectedTaskId => activeTaskId.value;
  String? get selectedTaskTitle => activeTaskTitle.value;
  int? get selectedFocusStartMoodScore => focusStartMoodScore.value;

  Future<void> loadSessions() async {
    sessions.value = await _repository.loadSessions();
    final pendingSessions =
        sessions.value.where((session) => session.moodPromptPending).toList()
          ..sort((first, second) => first.endedAt.compareTo(second.endedAt));
    _pendingReflectionSessionIds
      ..clear()
      ..addAll(pendingSessions.map((session) => session.id));
    _showNextPendingReflection();
  }

  Future<void> initialize() async {
    await loadSessions();
    await restoreRuntime();
  }

  Future<void> restoreRuntime() async {
    final restored = await _runtimeRepository?.load();
    if (restored == null) {
      return;
    }

    activeTaskId.value = restored.taskId;
    activeTaskTitle.value = restored.taskTitle;
    activeGoalId.value = restored.goalId;
    activeTaskEstimatedSeconds.value = restored.taskEstimatedMinutes == null
        ? null
        : restored.taskEstimatedMinutes! * 60;
    phase.value = _phaseFromRuntime(restored.phase);
    isRunning.value = restored.isRunning;
    remainingSeconds.value = restored.remainingSeconds;
    _currentFocusSeconds = restored.phase == PomodoroRuntimePhase.focus
        ? restored.phaseTotalSeconds
        : restored.cadenceFocusMinutes * 60;
    _focusSeconds = restored.cadenceFocusMinutes * 60;
    _shortBreakSeconds = restored.cadenceBreakMinutes * 60;
    _longBreakSeconds = restored.longBreakMinutes * 60;
    _longBreakFrequency = restored.longBreakFrequency;
    _autoStartBreak = restored.autoStartBreak;
    _autoStartFocus = restored.autoStartFocus;
    planMode.value = restored.planMode;
    currentBlockIndex.value = restored.blockIndex;
    totalBlocks.value = restored.blockCount;
    _startedAt = restored.focusStartedAt;
    _lastTickAt = restored.lastTickAt;
    _runtimeCreatedAt = restored.createdAt;
    hasActiveRuntime.value = true;
    hasStartedRuntime.value =
        restored.focusStartedAt != null ||
        restored.phase != PomodoroRuntimePhase.focus;
    _hasStructuredTaskPlan = restored.taskId != null;

    if (restored.isRunning) {
      final now = _now();
      final checkpoint = restored.lastTickAt;
      if (checkpoint != null && now.isAfter(checkpoint)) {
        await _advanceBy(
          elapsedSeconds: now.difference(checkpoint).inSeconds,
          elapsedStartedAt: checkpoint,
        );
      }
      if (isRunning.value) {
        _lastTickAt = now;
        _startTicker();
        await checkpointRuntime();
      }
    }
  }

  void setFocusMinutes(int value) {
    setFocusSeconds(value.clamp(5, 90) * 60);
  }

  void setFocusSeconds(int value) {
    _focusSeconds = value.clamp(60, 90 * 60);
    if (!isRunning.value && phase.value == PomodoroPhase.focus) {
      _currentFocusSeconds = _focusSeconds;
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

  bool get maximumConcentrationMode => maximumConcentrationEnabled.value;

  set maximumConcentrationMode(bool enabled) {
    maximumConcentrationEnabled.value = enabled;
  }

  set selectedGoalId(String? goalId) {
    activeGoalId.value = goalId;
  }

  bool selectTask({
    required String taskId,
    required String taskTitle,
    String? goalId,
    int? estimatedSeconds,
  }) {
    if (hasActiveRuntime.value &&
        activeTaskId.value != null &&
        activeTaskId.value != taskId) {
      return false;
    }

    activeTaskId.value = taskId;
    activeTaskTitle.value = taskTitle;
    activeGoalId.value = goalId;
    activeTaskEstimatedSeconds.value =
        estimatedSeconds == null || estimatedSeconds <= 0
        ? null
        : estimatedSeconds;
    return true;
  }

  Future<bool> prepareTaskPlan({
    required String taskId,
    required String taskTitle,
    required int estimatedMinutes,
    required PomodoroCadence cadence,
    required PomodoroPlanMode mode,
    String? goalId,
  }) async {
    if (!selectTask(
      taskId: taskId,
      taskTitle: taskTitle,
      goalId: goalId,
      estimatedSeconds: estimatedMinutes * 60,
    )) {
      return false;
    }

    final summary = summarizeTaskFocusMinutes(
      plannedMinutes: estimatedMinutes,
      focusedSeconds: sessions.value
          .where((session) => session.taskId == taskId)
          .map((session) => session.focusedSeconds),
    );
    if (summary.remainingMinutes == 0) {
      return false;
    }

    final fullPlan = createPomodoroTaskPlan(
      remainingMinutes: summary.remainingMinutes,
      cadence: cadence,
    );
    final selectedBlocks = mode == PomodoroPlanMode.continuous
        ? fullPlan.blocks
        : [fullPlan.blocks.first];

    _focusSeconds = cadence.focusMinutes * 60;
    _shortBreakSeconds = cadence.breakMinutes * 60;
    _currentFocusSeconds = selectedBlocks.first.focusMinutes * 60;
    planMode.value = mode;
    currentBlockIndex.value = 1;
    totalBlocks.value = selectedBlocks.length;
    phase.value = PomodoroPhase.focus;
    remainingSeconds.value = _currentFocusSeconds;
    _startedAt = null;
    _lastTickAt = null;
    _runtimeCreatedAt = _now();
    hasActiveRuntime.value = true;
    hasStartedRuntime.value = false;
    _hasStructuredTaskPlan = true;
    await checkpointRuntime();
    return true;
  }

  void clearSelectedTask() {
    activeTaskId.value = null;
    activeTaskTitle.value = null;
    activeGoalId.value = null;
    activeTaskEstimatedSeconds.value = null;
    hasActiveRuntime.value = false;
    hasStartedRuntime.value = false;
    maximumConcentrationEnabled.value = false;
    _hasStructuredTaskPlan = false;
    _runtimeCreatedAt = null;
    unawaited(_runtimeRepository?.clear());
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

    final now = _now();
    if (remainingSeconds.value <= 0) {
      remainingSeconds.value = currentPhaseSeconds;
    }

    if (phase.value == PomodoroPhase.focus) {
      _startedAt ??= now;
      final taskId = activeTaskId.value;
      final callback = onTaskFocusStarted;
      if (taskId != null && callback != null) {
        unawaited(callback(taskId));
      }
    }
    hasActiveRuntime.value = true;
    hasStartedRuntime.value = true;
    _runtimeCreatedAt ??= now;
    isRunning.value = true;
    _lastTickAt = now;
    _startTicker();
    unawaited(checkpointRuntime());
  }

  void pause() {
    _timer?.cancel();
    _lastTickAt = null;
    isRunning.value = false;
    unawaited(checkpointRuntime());
  }

  void reset() {
    _timer?.cancel();
    isRunning.value = false;
    phase.value = PomodoroPhase.focus;
    remainingSeconds.value = currentPhaseSeconds;
    _startedAt = null;
    _lastTickAt = null;
    hasStartedRuntime.value = false;
    maximumConcentrationEnabled.value = false;
    unawaited(checkpointRuntime());
  }

  void stopForDatabaseReset() {
    _timer?.cancel();
    isRunning.value = false;
    _lastTickAt = null;
  }

  void resetAfterDatabaseClear() {
    _timer?.cancel();
    isRunning.value = false;
    phase.value = PomodoroPhase.focus;
    _currentFocusSeconds = _focusSeconds;
    remainingSeconds.value = _currentFocusSeconds;
    sessions.value = const [];
    activeGoalId.value = null;
    activeTaskId.value = null;
    activeTaskTitle.value = null;
    activeTaskEstimatedSeconds.value = null;
    focusStartMoodScore.value = null;
    pendingReflectionSessionId.value = null;
    hasActiveRuntime.value = false;
    hasStartedRuntime.value = false;
    maximumConcentrationEnabled.value = false;
    planMode.value = PomodoroPlanMode.singleBlock;
    currentBlockIndex.value = 1;
    totalBlocks.value = 1;
    _startedAt = null;
    _lastTickAt = null;
    _runtimeCreatedAt = null;
    _hasStructuredTaskPlan = false;
    _pendingReflectionSessionIds.clear();
  }

  void discardSession() {
    _timer?.cancel();
    isRunning.value = false;
    phase.value = PomodoroPhase.focus;
    _startedAt = null;
    _lastTickAt = null;
    remainingSeconds.value = currentPhaseSeconds;
    hasStartedRuntime.value = false;
    maximumConcentrationEnabled.value = false;
    unawaited(checkpointRuntime());
  }

  void restartSession() {
    reset();
    start();
  }

  Future<void> stopForNow() async {
    if (phase.value == PomodoroPhase.focus && elapsedFocusSeconds > 0) {
      await _saveFocusedSession(
        focusedSeconds: elapsedFocusSeconds,
        endedAt: _now(),
        status: PomodoroSessionStatus.partial,
      );
      if (_hasCompletedActiveTask()) {
        final taskId = activeTaskId.value;
        final callback = onTaskPlanCompleted;
        if (taskId != null && callback != null) {
          await callback(taskId);
        }
      }
    }

    _timer?.cancel();
    isRunning.value = false;
    phase.value = PomodoroPhase.focus;
    _startedAt = null;
    _lastTickAt = null;
    _currentFocusSeconds = _focusSeconds;
    remainingSeconds.value = _currentFocusSeconds;
    clearSelectedTask();
  }

  Future<void> finishEarly() async {
    if (phase.value != PomodoroPhase.focus) {
      await completeBreak();
      return;
    }

    await stopForNow();
  }

  Future<void> tick() async {
    if (!isRunning.value) {
      return;
    }

    final now = _now();
    final lastTickAt = _lastTickAt;
    var elapsedSeconds = lastTickAt == null
        ? 1
        : now.difference(lastTickAt).inSeconds;
    if (elapsedSeconds < 1) {
      elapsedSeconds = 1;
    }

    _lastTickAt = now;
    await _advanceBy(
      elapsedSeconds: elapsedSeconds,
      elapsedStartedAt: lastTickAt ?? now.subtract(const Duration(seconds: 1)),
    );
  }

  Future<void> synchronizeWithClock() async {
    if (!isRunning.value) {
      return;
    }

    final now = _now();
    final lastTickAt = _lastTickAt;
    if (lastTickAt == null || now.isBefore(lastTickAt)) {
      _lastTickAt = now;
      return;
    }

    final elapsedSeconds = now.difference(lastTickAt).inSeconds;
    if (elapsedSeconds <= 0) {
      return;
    }

    _lastTickAt = now;
    await _advanceBy(
      elapsedSeconds: elapsedSeconds,
      elapsedStartedAt: lastTickAt,
    );
  }

  Future<void> completeSession({int? focusedSeconds, DateTime? endedAt}) async {
    final completedAt = endedAt ?? _now();
    _startedAt ??= completedAt;

    _timer?.cancel();
    isRunning.value = false;
    remainingSeconds.value = 0;
    _lastTickAt = null;
    final recordedFocusedSeconds = focusedSeconds == null
        ? elapsedFocusSeconds
        : _clampFocusSeconds(focusedSeconds);

    await _saveFocusedSession(
      focusedSeconds: recordedFocusedSeconds,
      endedAt: completedAt,
    );
    _startedAt = null;
    focusStartMoodScore.value = null;
    if (_hasCompletedActiveTask()) {
      final taskId = activeTaskId.value;
      final callback = onTaskPlanCompleted;
      if (taskId != null && callback != null) {
        await callback(taskId);
      }
      _timer?.cancel();
      isRunning.value = false;
      phase.value = PomodoroPhase.focus;
      _lastTickAt = null;
      clearSelectedTask();
      return;
    }

    _startBreakAfterFocus();
  }

  Future<PomodoroSession> _saveFocusedSession({
    required int focusedSeconds,
    required DateTime endedAt,
    PomodoroSessionStatus status = PomodoroSessionStatus.completed,
  }) async {
    _startedAt ??= endedAt;
    final session = await _repository.saveCompletedSession(
      startedAt: _startedAt!,
      endedAt: endedAt,
      plannedSeconds: currentPhaseSeconds,
      focusedSeconds: _clampFocusSeconds(focusedSeconds),
      goalId: activeGoalId.value,
      taskId: activeTaskId.value,
      startMoodScore: focusStartMoodScore.value,
      status: status,
    );

    final wasAlreadyRecorded = sessions.value.any(
      (existing) => existing.id == session.id,
    );
    sessions.value = [
      session,
      ...sessions.value.where((existing) => existing.id != session.id),
    ];

    if (!wasAlreadyRecorded && status == PomodoroSessionStatus.completed) {
      _pendingReflectionSessionIds.add(session.id);
      _showNextPendingReflection();
    }

    final goalId = session.goalId;
    final goalCompletionCallback = onGoalPomodoroCompleted;
    if (!wasAlreadyRecorded &&
        status == PomodoroSessionStatus.completed &&
        goalId != null &&
        goalCompletionCallback != null) {
      await goalCompletionCallback(goalId);
    }

    final completionCallback = onSessionCompleted;
    if (!wasAlreadyRecorded &&
        status == PomodoroSessionStatus.completed &&
        completionCallback != null) {
      unawaited(completionCallback());
    }

    return session;
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
    _pendingReflectionSessionIds.remove(sessionId);
    _showNextPendingReflection();
  }

  Future<void> completeBreak() async {
    _timer?.cancel();
    isRunning.value = false;

    if (_hasStructuredTaskPlan &&
        activeTaskId.value != null &&
        planMode.value == PomodoroPlanMode.singleBlock) {
      phase.value = PomodoroPhase.focus;
      _lastTickAt = null;
      _startedAt = null;
      clearSelectedTask();
      final completionCallback = onBreakCompleted;
      if (completionCallback != null) {
        unawaited(completionCallback());
      }
      return;
    }

    if (_hasStructuredTaskPlan &&
        activeTaskId.value != null &&
        planMode.value == PomodoroPlanMode.continuous &&
        currentBlockIndex.value < totalBlocks.value) {
      currentBlockIndex.value += 1;
      final remainingMinutes = _remainingActiveTaskMinutes();
      if (remainingMinutes > 0) {
        final nextPlan = createPomodoroTaskPlan(
          remainingMinutes: remainingMinutes,
          cadence: PomodoroCadence(
            focusMinutes: cadenceFocusMinutes,
            breakMinutes: cadenceBreakMinutes,
          ),
        );
        _currentFocusSeconds = nextPlan.blocks.first.focusMinutes * 60;
      }
    } else {
      _currentFocusSeconds = _focusSeconds;
    }

    phase.value = PomodoroPhase.focus;
    remainingSeconds.value = currentPhaseSeconds;
    _lastTickAt = null;

    final completionCallback = onBreakCompleted;
    if (completionCallback != null) {
      unawaited(completionCallback());
    }

    final shouldContinueTask =
        _hasStructuredTaskPlan &&
        activeTaskId.value != null &&
        planMode.value == PomodoroPlanMode.continuous &&
        currentBlockIndex.value <= totalBlocks.value;
    if (shouldContinueTask || _autoStartFocus) {
      start();
    } else {
      hasStartedRuntime.value = false;
      maximumConcentrationEnabled.value = false;
      await checkpointRuntime();
    }
  }

  void dispose() {
    _timer?.cancel();
  }

  Future<void> _advanceBy({
    required int elapsedSeconds,
    required DateTime elapsedStartedAt,
  }) async {
    var remainingElapsedSeconds = elapsedSeconds;
    var cursor = elapsedStartedAt;

    while (isRunning.value && remainingElapsedSeconds > 0) {
      final phaseRemainingSeconds = remainingSeconds.value;

      if (phaseRemainingSeconds > remainingElapsedSeconds) {
        remainingSeconds.value -= remainingElapsedSeconds;
        return;
      }

      remainingSeconds.value = 0;
      remainingElapsedSeconds -= phaseRemainingSeconds;
      cursor = cursor.add(Duration(seconds: phaseRemainingSeconds));

      if (phase.value == PomodoroPhase.focus) {
        await completeSession(endedAt: cursor);
      } else {
        await completeBreak();
        if (isRunning.value && phase.value == PomodoroPhase.focus) {
          _startedAt = cursor;
        }
      }
    }
  }

  int _clampFocusSeconds(int value) {
    if (value < 0) {
      return 0;
    }

    if (value > _currentFocusSeconds) {
      return _currentFocusSeconds;
    }

    return value;
  }

  int _clampMoodScore(int value) {
    return value.clamp(1, 5);
  }

  void _showNextPendingReflection() {
    pendingReflectionSessionId.value = _pendingReflectionSessionIds.isEmpty
        ? null
        : _pendingReflectionSessionIds.first;
  }

  void _startBreakAfterFocus() {
    phase.value = _nextBreakPhase();
    remainingSeconds.value = currentPhaseSeconds;

    if (activeTaskId.value != null || _autoStartBreak) {
      start();
    } else {
      unawaited(checkpointRuntime());
    }
  }

  PomodoroPhase _nextBreakPhase() {
    final completedBlocks = _hasStructuredTaskPlan
        ? currentBlockIndex.value
        : sessions.value.length;
    if (completedBlocks > 0 && completedBlocks % _longBreakFrequency == 0) {
      return PomodoroPhase.longBreak;
    }

    return PomodoroPhase.shortBreak;
  }

  int _remainingActiveTaskMinutes() {
    final taskId = activeTaskId.value;
    final estimatedSeconds = activeTaskEstimatedSeconds.value;
    if (taskId == null || estimatedSeconds == null) {
      return 0;
    }

    return summarizeTaskFocusMinutes(
      plannedMinutes: estimatedSeconds ~/ 60,
      focusedSeconds: sessions.value
          .where((session) => session.taskId == taskId)
          .map((session) => session.focusedSeconds),
    ).remainingMinutes;
  }

  bool _hasCompletedActiveTask() {
    final estimatedSeconds = activeTaskEstimatedSeconds.value;
    return activeTaskId.value != null &&
        estimatedSeconds != null &&
        activeTaskFocusedSeconds.value >= estimatedSeconds;
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      unawaited(tick());
    });
  }

  Future<void> checkpointRuntime() async {
    final repository = _runtimeRepository;
    if (repository == null) {
      return;
    }
    if (!hasActiveRuntime.value) {
      await repository.clear();
      return;
    }

    final now = _now();
    final estimatedSeconds = activeTaskEstimatedSeconds.value;
    await repository.save(
      PomodoroRuntimeState(
        taskId: activeTaskId.value,
        taskTitle: activeTaskTitle.value,
        goalId: activeGoalId.value,
        taskEstimatedMinutes: estimatedSeconds == null
            ? null
            : estimatedSeconds ~/ 60,
        phase: _phaseToRuntime(phase.value),
        isRunning: isRunning.value,
        remainingSeconds: remainingSeconds.value,
        phaseTotalSeconds: currentPhaseSeconds,
        cadenceFocusMinutes: cadenceFocusMinutes,
        cadenceBreakMinutes: cadenceBreakMinutes,
        longBreakMinutes: _longBreakSeconds ~/ 60,
        longBreakFrequency: _longBreakFrequency,
        autoStartBreak: _autoStartBreak,
        autoStartFocus: _autoStartFocus,
        planMode: planMode.value,
        blockIndex: currentBlockIndex.value,
        blockCount: totalBlocks.value,
        taskFocusedSecondsAtStart: activeTaskFocusedSeconds.value,
        focusStartedAt: _startedAt,
        lastTickAt: isRunning.value ? _lastTickAt ?? now : null,
        createdAt: _runtimeCreatedAt ?? now,
        updatedAt: now,
      ),
    );
  }

  PomodoroRuntimePhase _phaseToRuntime(PomodoroPhase value) {
    return switch (value) {
      PomodoroPhase.focus => PomodoroRuntimePhase.focus,
      PomodoroPhase.shortBreak => PomodoroRuntimePhase.shortBreak,
      PomodoroPhase.longBreak => PomodoroRuntimePhase.longBreak,
    };
  }

  PomodoroPhase _phaseFromRuntime(PomodoroRuntimePhase value) {
    return switch (value) {
      PomodoroRuntimePhase.focus => PomodoroPhase.focus,
      PomodoroRuntimePhase.shortBreak => PomodoroPhase.shortBreak,
      PomodoroRuntimePhase.longBreak => PomodoroPhase.longBreak,
    };
  }
}
