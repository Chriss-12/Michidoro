import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';

class PomodoroRuntimeScope extends InheritedWidget {
  const PomodoroRuntimeScope({
    required this.isRunning,
    required this.phase,
    required this.remainingSeconds,
    required this.currentPhaseSeconds,
    required this.completedPomodoros,
    required this.totalFocusSeconds,
    required this.onPlayPause,
    required this.onReset,
    required this.onDiscard,
    required this.onRestart,
    required this.onFinishEarly,
    required super.child,
    super.key,
  });

  final bool isRunning;
  final PomodoroPhase phase;
  final int remainingSeconds;
  final int currentPhaseSeconds;
  final int completedPomodoros;
  final int totalFocusSeconds;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onDiscard;
  final VoidCallback onRestart;
  final Future<void> Function() onFinishEarly;

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
        completedPomodoros != oldWidget.completedPomodoros ||
        totalFocusSeconds != oldWidget.totalFocusSeconds;
  }
}
