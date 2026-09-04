import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/models/routine_schedule_projection.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

void main() {
  final now = DateTime(2026, 8, 10, 8); // Monday.

  test('real runs replace virtual occurrences in a bounded range', () {
    final routine = _routine(
      id: 'morning',
      now: now,
      weekdays: const [DateTime.monday, DateTime.tuesday],
    );
    final run = _run(
      id: 'run-monday',
      routine: routine,
      day: DateTime(2026, 8, 10),
    );
    final itemRun = _itemRun(
      id: 'item-run-monday',
      run: run,
      taskId: 'task-monday',
    );

    final result = projectRoutineSchedule(
      routines: [routine],
      runs: [run],
      itemRuns: {
        run.id: [itemRun],
      },
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 12),
      today: now,
    );

    expect(result, hasLength(2));
    expect(result.first.isVirtual, isFalse);
    expect(result.last.localDate, DateTime(2026, 8, 11));
    expect(result.last.isVirtual, isTrue);
  });

  test('empty routine data keeps the projected range empty', () {
    final result = projectRoutineSchedule(
      routines: const [],
      runs: const [],
      itemRuns: const {},
      startDate: DateTime(2026, 8),
      endDate: DateTime(2026, 8, 31),
      today: now,
    );

    expect(result, isEmpty);
  });

  test('overlapping routine projections are flagged without moving them', () {
    final first = _routine(id: 'first', now: now);
    final second = _routine(id: 'second', now: now);

    final result = projectRoutineSchedule(
      routines: [first, second],
      runs: const [],
      itemRuns: const {},
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 10),
      today: now,
    );

    expect(result, hasLength(2));
    expect(result.every((occurrence) => occurrence.hasOverlap), isTrue);
    expect(result.map((occurrence) => occurrence.startMinute), [
      9 * 60,
      9 * 60,
    ]);
  });

  test('weekly projection obeys inclusive routine validity dates', () {
    final routine = _routine(
      id: 'bounded',
      now: now,
      weekdays: const [
        DateTime.monday,
        DateTime.tuesday,
        DateTime.wednesday,
        DateTime.thursday,
      ],
      validFromDate: DateTime(2026, 8, 11),
      validUntilDate: DateTime(2026, 8, 12),
    );

    final activities = projectRoutineActivities(
      routines: [routine],
      runs: const [],
      itemRuns: const {},
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 13),
      today: now,
    );

    expect(
      activities.map((activity) => activity.localDate),
      [DateTime(2026, 8, 11), DateTime(2026, 8, 12)],
    );
  });

  test('weekly activities preserve snapshot colors and item times', () {
    final routine = _routine(
      id: 'colored',
      now: now,
      customColorArgb: 0xFF112233,
    );
    final run = _run(
      id: 'colored-run',
      routine: routine,
      day: DateTime(2026, 8, 10),
      customColorArgbSnapshot: 0xFFABCDEF,
    );
    final item = _itemRun(
      id: 'colored-item',
      run: run,
      taskId: 'colored-task',
    );

    final activities = projectRoutineActivities(
      routines: [routine],
      runs: [run],
      itemRuns: {
        run.id: [item],
      },
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 16),
      today: now,
    );

    expect(activities, hasLength(1));
    expect(activities.single.isVirtual, isFalse);
    expect(activities.single.customColorArgb, 0xFFABCDEF);
    expect(activities.single.startMinute, 9 * 60);
    expect(activities.single.durationMinutes, 30);
  });

  test('overlapping activity blocks retain their original positions', () {
    final first = _routine(id: 'first-activity', now: now);
    final second = _routine(id: 'second-activity', now: now);

    final activities = projectRoutineActivities(
      routines: [first, second],
      runs: const [],
      itemRuns: const {},
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 10),
      today: now,
    );

    expect(activities, hasLength(2));
    expect(activities.every((activity) => activity.hasOverlap), isTrue);
    expect(activities.map((activity) => activity.startMinute), [
      9 * 60,
      9 * 60,
    ]);
  });

  test('an activity crossing local midnight stays owned by its start day', () {
    final routine = _routine(
      id: 'late',
      now: now,
      scheduledMinute: 23 * 60 + 30,
      durationMinutes: 90,
    );

    final activities = projectRoutineActivities(
      routines: [routine],
      runs: const [],
      itemRuns: const {},
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 11),
      today: now,
    );

    expect(activities, hasLength(1));
    expect(activities.single.localDate, DateTime(2026, 8, 10));
    expect(activities.single.startMinute, 23 * 60 + 30);
    expect(activities.single.endMinute, 25 * 60);
  });

  test('Home projection prioritizes an in-progress item', () {
    final pendingRoutine = _routine(id: 'pending', now: now);
    final activeRoutine = _routine(id: 'active', now: now);
    final pendingRun = _run(
      id: 'pending-run',
      routine: pendingRoutine,
      day: DateTime(2026, 8, 10),
    );
    final activeRun = _run(
      id: 'active-run',
      routine: activeRoutine,
      day: DateTime(2026, 8, 10),
      status: RoutineRunStatus.inProgress,
    );
    final pendingItem = _itemRun(
      id: 'pending-item',
      run: pendingRun,
      taskId: 'pending-task',
    );
    final activeItem = _itemRun(
      id: 'active-item',
      run: activeRun,
      taskId: 'active-task',
      status: RoutineRunStatus.inProgress,
    );

    final result = projectRoutineTodayFocus(
      routines: [pendingRoutine, activeRoutine],
      runs: [pendingRun, activeRun],
      itemRuns: {
        pendingRun.id: [pendingItem],
        activeRun.id: [activeItem],
      },
      tasks: [
        Task(id: 'pending-task', title: 'Pending', createdAt: now),
        Task(
          id: 'active-task',
          title: 'Active',
          status: TaskStatus.inProgress,
          createdAt: now,
        ),
      ],
    );

    expect(result?.routine.id, 'active');
    expect(result?.nextItem?.status, RoutineRunStatus.inProgress);
  });
}

Routine _routine({
  required String id,
  required DateTime now,
  List<int> weekdays = const [DateTime.monday],
  int? customColorArgb,
  DateTime? validFromDate,
  DateTime? validUntilDate,
  int scheduledMinute = 9 * 60,
  int durationMinutes = 30,
}) => Routine(
  id: id,
  name: 'Routine $id',
  iconKey: 'sun',
  colorKey: 'primary',
  customColorArgb: customColorArgb,
  validFromDate: validFromDate,
  validUntilDate: validUntilDate,
  status: RoutineStatus.active,
  createdAt: now.subtract(const Duration(days: 2)),
  updatedAt: now,
  weekdays: weekdays,
  items: [
    RoutineItem(
      id: '$id-item',
      routineId: id,
      position: 0,
      title: 'Activity $id',
      scheduledMinute: scheduledMinute,
      durationMinutes: durationMinutes,
      isOptional: false,
      pomodoroMode: RoutinePomodoroMode.recommended,
      createdAt: now,
      updatedAt: now,
    ),
  ],
);

RoutineRun _run({
  required String id,
  required Routine routine,
  required DateTime day,
  RoutineRunStatus status = RoutineRunStatus.scheduled,
  int? customColorArgbSnapshot,
}) => RoutineRun(
  id: id,
  sourceRoutineId: routine.id,
  routineId: routine.id,
  localDate: day,
  status: status,
  nameSnapshot: routine.name,
  iconKeySnapshot: routine.iconKey,
  colorKeySnapshot: routine.colorKey,
  customColorArgbSnapshot: customColorArgbSnapshot,
  scheduledStartMinuteSnapshot: 9 * 60,
  createdAt: day,
  updatedAt: day,
);

RoutineItemRun _itemRun({
  required String id,
  required RoutineRun run,
  required String taskId,
  RoutineRunStatus status = RoutineRunStatus.scheduled,
}) => RoutineItemRun(
  id: id,
  routineRunId: run.id,
  routineItemId: '${run.sourceRoutineId}-item',
  sourceItemId: '${run.sourceRoutineId}-item',
  taskId: taskId,
  taskIdSnapshot: taskId,
  positionSnapshot: 0,
  titleSnapshot: 'Activity',
  scheduledAtSnapshot: DateTime(
    run.localDate.year,
    run.localDate.month,
    run.localDate.day,
    9,
  ),
  durationMinutesSnapshot: 30,
  isOptionalSnapshot: false,
  pomodoroModeSnapshot: RoutinePomodoroMode.recommended,
  status: status,
  createdAt: run.localDate,
  updatedAt: run.localDate,
);
