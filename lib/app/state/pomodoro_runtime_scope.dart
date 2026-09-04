import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';

class PomodoroRuntimeScope extends InheritedWidget {
  const PomodoroRuntimeScope({
    required this.isRunning,
    required this.phase,
    required this.remainingSeconds,
    required this.currentPhaseSeconds,
    required this.timerProgress,
    required this.completedPomodoros,
    required this.completedPlanPomodoros,
    required this.totalFocusSeconds,
    required this.hasActiveRuntime,
    required this.hasStartedRuntime,
    required this.planMode,
    required this.currentBlockIndex,
    required this.totalBlocks,
    required this.taskFocusedSeconds,
    required this.taskEstimatedSeconds,
    required this.cadenceBreakMinutes,
    required this.onPlayPause,
    required this.onReset,
    required this.onDiscard,
    required this.onRestart,
    required this.onFinishEarly,
    required this.onStopForNow,
    required super.child,
    super.key,
  });

  final bool isRunning;
  final PomodoroPhase phase;
  final int remainingSeconds;
  final int currentPhaseSeconds;
  final double timerProgress;
  final int completedPomodoros;
  final int completedPlanPomodoros;
  final int totalFocusSeconds;
  final bool hasActiveRuntime;
  final bool hasStartedRuntime;
  final PomodoroPlanMode planMode;
  final int currentBlockIndex;
  final int totalBlocks;
  final int taskFocusedSeconds;
  final int? taskEstimatedSeconds;
  final int cadenceBreakMinutes;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onDiscard;
  final VoidCallback onRestart;
  final Future<void> Function() onFinishEarly;
  final Future<void> Function() onStopForNow;

  static PomodoroRuntimeScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<PomodoroRuntimeScope>();

    assert(scope != null, 'PomodoroRuntimeScope was not found in the tree.');
    return scope!;
  }

  @override
  bool updateShouldNotify(PomodoroRuntimeScope oldWidget) {
    return isRunning != oldWidget.isRunning ||
        phase != oldWidget.phase ||
        remainingSeconds != oldWidget.remainingSeconds ||
        currentPhaseSeconds != oldWidget.currentPhaseSeconds ||
        timerProgress != oldWidget.timerProgress ||
        completedPomodoros != oldWidget.completedPomodoros ||
        completedPlanPomodoros != oldWidget.completedPlanPomodoros ||
        totalFocusSeconds != oldWidget.totalFocusSeconds ||
        hasActiveRuntime != oldWidget.hasActiveRuntime ||
        hasStartedRuntime != oldWidget.hasStartedRuntime ||
        planMode != oldWidget.planMode ||
        currentBlockIndex != oldWidget.currentBlockIndex ||
        totalBlocks != oldWidget.totalBlocks ||
        taskFocusedSeconds != oldWidget.taskFocusedSeconds ||
        taskEstimatedSeconds != oldWidget.taskEstimatedSeconds ||
        cadenceBreakMinutes != oldWidget.cadenceBreakMinutes;
  }
}
