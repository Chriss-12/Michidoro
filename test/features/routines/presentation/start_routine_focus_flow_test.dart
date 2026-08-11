import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/start_routine_focus_flow.dart';

void main() {
  group('routineItemCadence', () {
    test('leaves ordinary task recommendation available for none mode', () {
      expect(routineItemCadence(_item()), isNull);
    });

    test('uses the standard routine cadence for recommended mode', () {
      final cadence = routineItemCadence(
        _item(mode: RoutinePomodoroMode.recommended),
      );

      expect(cadence?.focusMinutes, 25);
      expect(cadence?.breakMinutes, 5);
    });

    test('preserves the routine custom cadence', () {
      final cadence = routineItemCadence(
        _item(
          mode: RoutinePomodoroMode.custom,
          customFocusMinutes: 45,
          customBreakMinutes: 10,
        ),
      );

      expect(cadence?.focusMinutes, 45);
      expect(cadence?.breakMinutes, 10);
    });
  });

  group('routineItemNeedsLateStartChoice', () {
    final scheduledAt = DateTime(2026, 8, 9, 9);

    test('asks only when a scheduled item starts after its planned time', () {
      expect(
        routineItemNeedsLateStartChoice(
          item: _item(scheduledAt: scheduledAt),
          now: scheduledAt.add(const Duration(minutes: 1)),
        ),
        isTrue,
      );
    });

    test('does not ask at the exact planned time', () {
      expect(
        routineItemNeedsLateStartChoice(
          item: _item(scheduledAt: scheduledAt),
          now: scheduledAt,
        ),
        isFalse,
      );
    });

    test('does not ask again while continuing an in-progress item', () {
      expect(
        routineItemNeedsLateStartChoice(
          item: _item(
            scheduledAt: scheduledAt,
            status: RoutineRunStatus.inProgress,
          ),
          now: scheduledAt.add(const Duration(hours: 1)),
        ),
        isFalse,
      );
    });
  });
}

RoutineItemRun _item({
  RoutinePomodoroMode mode = RoutinePomodoroMode.none,
  RoutineRunStatus status = RoutineRunStatus.scheduled,
  DateTime? scheduledAt,
  int? customFocusMinutes,
  int? customBreakMinutes,
}) {
  final now = scheduledAt ?? DateTime(2026, 8, 9, 9);
  return RoutineItemRun(
    id: 'item-run',
    routineRunId: 'run',
    sourceItemId: 'item',
    taskId: 'task',
    taskIdSnapshot: 'task',
    positionSnapshot: 0,
    titleSnapshot: 'Activity',
    scheduledAtSnapshot: now,
    durationMinutesSnapshot: 60,
    isOptionalSnapshot: false,
    pomodoroModeSnapshot: mode,
    customFocusMinutesSnapshot: customFocusMinutes,
    customBreakMinutesSnapshot: customBreakMinutes,
    status: status,
    createdAt: now,
    updatedAt: now,
  );
}
