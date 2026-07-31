import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_task_plan.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/services/pomodoro_task_planner.dart';

void main() {
  group('createPomodoroTaskPlan', () {
    test(
      'truncates the final block and inserts breaks only between blocks',
      () {
        final plan = createPomodoroTaskPlan(
          remainingMinutes: 120,
          cadence: const PomodoroCadence(
            focusMinutes: 45,
            breakMinutes: 10,
          ),
        );

        expect(plan.blockCount, 3);
        expect(
          plan.blocks.map((block) => block.number),
          orderedEquals([1, 2, 3]),
        );
        expect(
          plan.blocks.map((block) => block.focusMinutes),
          orderedEquals([45, 45, 30]),
        );
        expect(
          plan.blocks.map((block) => block.breakAfterMinutes),
          orderedEquals([10, 10, 0]),
        );
        expect(plan.finalFocusMinutes, 30);
        expect(plan.breakCount, 2);
        expect(plan.totalBreakMinutes, 20);
        expect(plan.elapsedMinutes, 140);
        expect(plan.isExactDivision, isFalse);
        expect(plan.hasVeryShortFinalBlock, isFalse);
      },
    );

    test('projects exact divisions without a trailing break', () {
      final plan = createPomodoroTaskPlan(
        remainingMinutes: 120,
        cadence: const PomodoroCadence(
          focusMinutes: 30,
          breakMinutes: 5,
        ),
      );

      expect(
        plan.blocks.map((block) => block.focusMinutes),
        orderedEquals([30, 30, 30, 30]),
      );
      expect(
        plan.blocks.map((block) => block.breakAfterMinutes),
        orderedEquals([5, 5, 5, 0]),
      );
      expect(plan.isExactDivision, isTrue);
      expect(plan.totalBreakMinutes, 15);
      expect(plan.elapsedMinutes, 135);
    });

    test(
      'uses one shortened block with no break when focus exceeds pending',
      () {
        final plan = createPomodoroTaskPlan(
          remainingMinutes: 20,
          cadence: const PomodoroCadence(
            focusMinutes: 45,
            breakMinutes: 10,
          ),
        );

        expect(plan.blockCount, 1);
        expect(plan.finalFocusMinutes, 20);
        expect(plan.breakCount, 0);
        expect(plan.totalBreakMinutes, 0);
        expect(plan.elapsedMinutes, 20);
        expect(plan.hasVeryShortFinalBlock, isFalse);
      },
    );

    test('returns an empty completed plan for zero remaining minutes', () {
      final plan = createPomodoroTaskPlan(
        remainingMinutes: 0,
        cadence: const PomodoroCadence(
          focusMinutes: 25,
          breakMinutes: 5,
        ),
      );

      expect(plan.blocks, isEmpty);
      expect(plan.blockCount, 0);
      expect(plan.finalFocusMinutes, 0);
      expect(plan.breakCount, 0);
      expect(plan.elapsedMinutes, 0);
      expect(plan.isExactDivision, isTrue);
    });

    test('rejects invalid minute inputs', () {
      expect(
        () => createPomodoroTaskPlan(
          remainingMinutes: -1,
          cadence: const PomodoroCadence(
            focusMinutes: 25,
            breakMinutes: 5,
          ),
        ),
        throwsArgumentError,
      );
      expect(
        () => createPomodoroTaskPlan(
          remainingMinutes: 30,
          cadence: const PomodoroCadence(
            focusMinutes: 0,
            breakMinutes: 5,
          ),
        ),
        throwsArgumentError,
      );
      expect(
        () => createPomodoroTaskPlan(
          remainingMinutes: 30,
          cadence: const PomodoroCadence(
            focusMinutes: 25,
            breakMinutes: -1,
          ),
        ),
        throwsArgumentError,
      );
    });
  });

  group('rankPomodoroPresets', () {
    const standardPresets = [
      PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
      PomodoroCadence(focusMinutes: 30, breakMinutes: 5),
      PomodoroCadence(focusMinutes: 45, breakMinutes: 10),
    ];

    test('prioritizes the least break overhead', () {
      final ranking = rankPomodoroPresets(
        remainingMinutes: 120,
        presets: standardPresets,
      );

      expect(ranking.singleWhere((item) => item.isRecommended).rank, 1);
      expect(ranking.first.cadence.focusMinutes, 30);
      expect(ranking.first.plan.totalBreakMinutes, 15);
      expect(
        ranking.where((item) => item.isRecommended),
        hasLength(1),
      );
    });

    test('prioritizes exact division when overhead is tied', () {
      final ranking = rankPomodoroPresets(
        remainingMinutes: 75,
        presets: standardPresets,
      );

      expect(ranking.first.cadence.focusMinutes, 25);
      expect(ranking.first.plan.isExactDivision, isTrue);
      expect(ranking.first.plan.totalBreakMinutes, 10);
    });

    test('avoids a very short final block after previous criteria tie', () {
      final ranking = rankPomodoroPresets(
        remainingMinutes: 70,
        presets: const [
          PomodoroCadence(focusMinutes: 30, breakMinutes: 5),
          PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
        ],
      );

      expect(ranking.first.cadence.focusMinutes, 25);
      expect(ranking.first.plan.finalFocusMinutes, 20);
      expect(ranking.first.plan.hasVeryShortFinalBlock, isFalse);
      expect(ranking.last.plan.hasVeryShortFinalBlock, isTrue);
    });

    test('uses moderate focus duration after higher priorities tie', () {
      final ranking = rankPomodoroPresets(
        remainingMinutes: 225,
        presets: const [
          PomodoroCadence(focusMinutes: 45, breakMinutes: 10),
          PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
        ],
      );

      expect(ranking.first.plan.totalBreakMinutes, 40);
      expect(ranking.last.plan.totalBreakMinutes, 40);
      expect(ranking.first.plan.isExactDivision, isTrue);
      expect(ranking.last.plan.isExactDivision, isTrue);
      expect(ranking.first.cadence.focusMinutes, 25);
    });

    test('uses stable numeric tie breakers independent of input order', () {
      const first = PomodoroCadence(focusMinutes: 25, breakMinutes: 5);
      const second = PomodoroCadence(focusMinutes: 35, breakMinutes: 15);

      final forward = rankPomodoroPresets(
        remainingMinutes: 175,
        presets: const [second, first],
      );
      final reversed = rankPomodoroPresets(
        remainingMinutes: 175,
        presets: const [first, second],
      );

      expect(forward.first.cadence.focusMinutes, 25);
      expect(reversed.first.cadence.focusMinutes, 25);
    });

    test('returns an empty ranking for an empty preset list', () {
      final ranking = rankPomodoroPresets(
        remainingMinutes: 30,
        presets: const [],
      );

      expect(ranking, isEmpty);
    });
  });

  group('summarizeTaskFocusMinutes', () {
    test('sums all seconds before flooring completed minutes', () {
      final summary = summarizeTaskFocusMinutes(
        plannedMinutes: 120,
        focusedSeconds: [59, 59],
      );

      expect(summary.totalFocusedSeconds, 118);
      expect(summary.completedWholeMinutes, 1);
      expect(summary.remainingMinutes, 119);
    });

    test('floors partial minutes for recommendation calculations', () {
      final summary = summarizeTaskFocusMinutes(
        plannedMinutes: 120,
        focusedSeconds: [45 * 60 + 50],
      );

      expect(summary.totalFocusedSeconds, 2750);
      expect(summary.completedWholeMinutes, 45);
      expect(summary.remainingMinutes, 75);
    });

    test('clamps remaining minutes at zero without losing exact seconds', () {
      final summary = summarizeTaskFocusMinutes(
        plannedMinutes: 25,
        focusedSeconds: [25 * 60 + 30],
      );

      expect(summary.totalFocusedSeconds, 1530);
      expect(summary.completedWholeMinutes, 25);
      expect(summary.remainingMinutes, 0);
    });

    test('rejects negative planned minutes or focused seconds', () {
      expect(
        () => summarizeTaskFocusMinutes(
          plannedMinutes: -1,
          focusedSeconds: const [],
        ),
        throwsArgumentError,
      );
      expect(
        () => summarizeTaskFocusMinutes(
          plannedMinutes: 30,
          focusedSeconds: const [60, -1],
        ),
        throwsArgumentError,
      );
    });
  });
}
