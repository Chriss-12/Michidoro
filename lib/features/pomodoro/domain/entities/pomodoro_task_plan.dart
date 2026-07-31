class PomodoroCadence {
  const PomodoroCadence({
    required this.focusMinutes,
    required this.breakMinutes,
  });

  final int focusMinutes;
  final int breakMinutes;
}

class PomodoroTaskBlock {
  const PomodoroTaskBlock({
    required this.number,
    required this.focusMinutes,
    required this.breakAfterMinutes,
  });

  final int number;
  final int focusMinutes;
  final int breakAfterMinutes;
}

class PomodoroTaskPlan {
  PomodoroTaskPlan({
    required this.remainingMinutes,
    required this.cadence,
    required List<PomodoroTaskBlock> blocks,
  }) : blocks = List.unmodifiable(blocks);

  final int remainingMinutes;
  final PomodoroCadence cadence;
  final List<PomodoroTaskBlock> blocks;

  int get blockCount => blocks.length;

  int get breakCount => blockCount == 0 ? 0 : blockCount - 1;

  int get finalFocusMinutes => blocks.isEmpty ? 0 : blocks.last.focusMinutes;

  int get totalBreakMinutes => blocks.fold(
    0,
    (total, block) => total + block.breakAfterMinutes,
  );

  int get elapsedMinutes => remainingMinutes + totalBreakMinutes;

  bool get isExactDivision =>
      remainingMinutes == 0 || finalFocusMinutes == cadence.focusMinutes;

  bool get hasVeryShortFinalBlock =>
      blockCount > 1 && finalFocusMinutes * 2 < cadence.focusMinutes;
}

class PomodoroPresetProjection {
  const PomodoroPresetProjection({
    required this.cadence,
    required this.plan,
    required this.rank,
  });

  final PomodoroCadence cadence;
  final PomodoroTaskPlan plan;
  final int rank;

  bool get isRecommended => rank == 1;
}

class TaskFocusMinuteSummary {
  const TaskFocusMinuteSummary({
    required this.totalFocusedSeconds,
    required this.completedWholeMinutes,
    required this.remainingMinutes,
  });

  final int totalFocusedSeconds;
  final int completedWholeMinutes;
  final int remainingMinutes;
}
