import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_task_plan.dart';

const _moderateFocusMinutes = 30;

PomodoroTaskPlan createPomodoroTaskPlan({
  required int remainingMinutes,
  required PomodoroCadence cadence,
}) {
  _validatePlanInput(
    remainingMinutes: remainingMinutes,
    cadence: cadence,
  );

  if (remainingMinutes == 0) {
    return PomodoroTaskPlan(
      remainingMinutes: remainingMinutes,
      cadence: cadence,
      blocks: const [],
    );
  }

  final blockCount =
      (remainingMinutes + cadence.focusMinutes - 1) ~/ cadence.focusMinutes;
  final blocks = <PomodoroTaskBlock>[];

  for (var index = 0; index < blockCount; index++) {
    final remainingForBlock = remainingMinutes - (index * cadence.focusMinutes);
    final focusMinutes = remainingForBlock < cadence.focusMinutes
        ? remainingForBlock
        : cadence.focusMinutes;

    blocks.add(
      PomodoroTaskBlock(
        number: index + 1,
        focusMinutes: focusMinutes,
        breakAfterMinutes: index < blockCount - 1 ? cadence.breakMinutes : 0,
      ),
    );
  }

  return PomodoroTaskPlan(
    remainingMinutes: remainingMinutes,
    cadence: cadence,
    blocks: blocks,
  );
}

List<PomodoroPresetProjection> rankPomodoroPresets({
  required int remainingMinutes,
  required Iterable<PomodoroCadence> presets,
}) {
  if (remainingMinutes < 0) {
    throw ArgumentError.value(
      remainingMinutes,
      'remainingMinutes',
      'must not be negative',
    );
  }

  final candidates =
      presets
          .map(
            (cadence) => _RankedCandidate(
              cadence: cadence,
              plan: createPomodoroTaskPlan(
                remainingMinutes: remainingMinutes,
                cadence: cadence,
              ),
            ),
          )
          .toList()
        ..sort(_compareCandidates);

  return List.unmodifiable([
    for (var index = 0; index < candidates.length; index++)
      PomodoroPresetProjection(
        cadence: candidates[index].cadence,
        plan: candidates[index].plan,
        rank: index + 1,
      ),
  ]);
}

TaskFocusMinuteSummary summarizeTaskFocusMinutes({
  required int plannedMinutes,
  required Iterable<int> focusedSeconds,
}) {
  if (plannedMinutes < 0) {
    throw ArgumentError.value(
      plannedMinutes,
      'plannedMinutes',
      'must not be negative',
    );
  }

  var totalFocusedSeconds = 0;
  for (final seconds in focusedSeconds) {
    if (seconds < 0) {
      throw ArgumentError.value(
        seconds,
        'focusedSeconds',
        'must not contain negative values',
      );
    }
    totalFocusedSeconds += seconds;
  }

  final completedWholeMinutes = totalFocusedSeconds ~/ 60;
  final pendingMinutes = plannedMinutes - completedWholeMinutes;

  return TaskFocusMinuteSummary(
    totalFocusedSeconds: totalFocusedSeconds,
    completedWholeMinutes: completedWholeMinutes,
    remainingMinutes: pendingMinutes > 0 ? pendingMinutes : 0,
  );
}

void _validatePlanInput({
  required int remainingMinutes,
  required PomodoroCadence cadence,
}) {
  if (remainingMinutes < 0) {
    throw ArgumentError.value(
      remainingMinutes,
      'remainingMinutes',
      'must not be negative',
    );
  }
  if (cadence.focusMinutes <= 0) {
    throw ArgumentError.value(
      cadence.focusMinutes,
      'cadence.focusMinutes',
      'must be greater than zero',
    );
  }
  if (cadence.breakMinutes < 0) {
    throw ArgumentError.value(
      cadence.breakMinutes,
      'cadence.breakMinutes',
      'must not be negative',
    );
  }
}

int _compareCandidates(_RankedCandidate left, _RankedCandidate right) {
  var comparison = left.plan.totalBreakMinutes.compareTo(
    right.plan.totalBreakMinutes,
  );
  if (comparison != 0) {
    return comparison;
  }

  comparison = _falseFirst(
    !left.plan.isExactDivision,
    !right.plan.isExactDivision,
  );
  if (comparison != 0) {
    return comparison;
  }

  comparison = _falseFirst(
    left.plan.hasVeryShortFinalBlock,
    right.plan.hasVeryShortFinalBlock,
  );
  if (comparison != 0) {
    return comparison;
  }

  comparison = _distanceFromModerate(left.cadence.focusMinutes).compareTo(
    _distanceFromModerate(right.cadence.focusMinutes),
  );
  if (comparison != 0) {
    return comparison;
  }

  comparison = left.cadence.focusMinutes.compareTo(
    right.cadence.focusMinutes,
  );
  if (comparison != 0) {
    return comparison;
  }

  return left.cadence.breakMinutes.compareTo(right.cadence.breakMinutes);
}

int _falseFirst(bool left, bool right) {
  if (left == right) {
    return 0;
  }
  return left ? 1 : -1;
}

int _distanceFromModerate(int focusMinutes) =>
    (focusMinutes - _moderateFocusMinutes).abs();

class _RankedCandidate {
  const _RankedCandidate({
    required this.cadence,
    required this.plan,
  });

  final PomodoroCadence cadence;
  final PomodoroTaskPlan plan;
}
