enum PomodoroSessionStatus { completed }

class PomodoroSession {
  const PomodoroSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.plannedSeconds,
    required this.focusedSeconds,
    required this.status,
    this.goalId,
    this.taskId,
    this.startMoodScore,
    this.endMoodScore,
    this.wasDistracted,
    this.distractionMinutes,
  });

  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final int plannedSeconds;
  final int focusedSeconds;
  final PomodoroSessionStatus status;
  final String? goalId;
  final String? taskId;
  final int? startMoodScore;
  final int? endMoodScore;
  final bool? wasDistracted;
  final int? distractionMinutes;

  PomodoroSession copyWith({
    int? startMoodScore,
    int? endMoodScore,
    bool? wasDistracted,
    int? distractionMinutes,
  }) {
    return PomodoroSession(
      id: id,
      startedAt: startedAt,
      endedAt: endedAt,
      plannedSeconds: plannedSeconds,
      focusedSeconds: focusedSeconds,
      status: status,
      goalId: goalId,
      taskId: taskId,
      startMoodScore: startMoodScore ?? this.startMoodScore,
      endMoodScore: endMoodScore ?? this.endMoodScore,
      wasDistracted: wasDistracted ?? this.wasDistracted,
      distractionMinutes: distractionMinutes ?? this.distractionMinutes,
    );
  }
}
