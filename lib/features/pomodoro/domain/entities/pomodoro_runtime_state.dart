enum PomodoroRuntimePhase { focus, shortBreak, longBreak }

enum PomodoroPlanMode { continuous, singleBlock }

class PomodoroRuntimeState {
  const PomodoroRuntimeState({
    required this.phase,
    required this.isRunning,
    required this.remainingSeconds,
    required this.phaseTotalSeconds,
    required this.cadenceFocusMinutes,
    required this.cadenceBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakFrequency,
    required this.autoStartBreak,
    required this.autoStartFocus,
    required this.planMode,
    required this.blockIndex,
    required this.blockCount,
    required this.taskFocusedSecondsAtStart,
    required this.createdAt,
    required this.updatedAt,
    this.taskId,
    this.taskTitle,
    this.goalId,
    this.taskEstimatedMinutes,
    this.focusStartedAt,
    this.lastTickAt,
  });

  final String? taskId;
  final String? taskTitle;
  final String? goalId;
  final int? taskEstimatedMinutes;
  final PomodoroRuntimePhase phase;
  final bool isRunning;
  final int remainingSeconds;
  final int phaseTotalSeconds;
  final int cadenceFocusMinutes;
  final int cadenceBreakMinutes;
  final int longBreakMinutes;
  final int longBreakFrequency;
  final bool autoStartBreak;
  final bool autoStartFocus;
  final PomodoroPlanMode planMode;
  final int blockIndex;
  final int blockCount;
  final int taskFocusedSecondsAtStart;
  final DateTime? focusStartedAt;
  final DateTime? lastTickAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
