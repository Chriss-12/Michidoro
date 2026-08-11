import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';

void main() {
  final now = DateTime(2026, 8, 7, 9);

  group('RoutinesController', () {
    test('loads routines, filters and required progress for today', () async {
      final repository = _MemoryRoutinesRepository(
        routines: [
          _routine(now: now),
          _routine(
            now: now,
            id: 'paused',
            status: RoutineStatus.paused,
          ),
          _routine(
            now: now,
            id: 'archived',
            status: RoutineStatus.archived,
            archivedAt: now,
          ),
        ],
        runs: [_run(now)],
        itemRuns: {
          'run-1': [
            _itemRun(now: now, id: 'required', completed: true),
            _itemRun(
              now: now,
              id: 'optional',
              sourceItemId: 'item-2',
              optional: true,
            ),
          ],
        },
      );
      final controller = RoutinesController(
        repository: repository,
        now: () => now,
      );

      await controller.load();

      expect(controller.filteredRoutines.value, hasLength(1));
      expect(controller.filteredRoutines.value.single.id, 'routine-1');
      controller.selectedFilter = RoutineFilter.paused;
      expect(controller.filteredRoutines.value.single.id, 'paused');
      controller.selectedFilter = RoutineFilter.archived;
      expect(controller.filteredRoutines.value.single.id, 'archived');

      final progress = controller.progressForToday('routine-1');
      expect(progress.completedItems, 1);
      expect(progress.totalItems, 2);
      expect(progress.completedRequiredItems, 1);
      expect(progress.totalRequiredItems, 1);
      expect(progress.completionRatio, 1);
      expect(repository.lastStartDate, DateTime(2026, 8, 7));
      expect(repository.lastEndDate, DateTime(2026, 8, 7));
    });

    test('creates wizard drafts and converts existing routines', () {
      var sequence = 0;
      final controller = RoutinesController(
        repository: _MemoryRoutinesRepository(),
        now: () => now,
        createId: (scope) => '$scope-${++sequence}',
      );

      final fresh = controller.newDraft(iconKey: 'sun', colorKey: 'yellow');
      final existing = controller.draftFor(_routine(now: now));

      expect(fresh.id, 'routine-1');
      expect(fresh.isNew, isTrue);
      expect(fresh.status, RoutineStatus.active);
      expect(fresh.iconKey, 'sun');
      expect(existing.isNew, isFalse);
      expect(existing.items.single.id, 'item-1-routine-1');
      expect(existing.weekdays, [DateTime.monday]);
    });

    test('validates identity, recurrence, items, positions and Pomodoro', () {
      final controller = RoutinesController(
        repository: _MemoryRoutinesRepository(),
        now: () => now,
      );
      const draft = RoutineEditorDraft(
        id: 'routine-1',
        name: ' ',
        iconKey: '',
        colorKey: '',
        status: RoutineStatus.active,
        weekdays: [0, 1, 1],
        items: [
          RoutineItemDraft(
            position: 2,
            title: '',
            scheduledMinute: 1440,
            durationMinutes: 0,
            reminderMinutesBefore: -1,
            pomodoroMode: RoutinePomodoroMode.custom,
            customFocusMinutes: 0,
            customBreakMinutes: 61,
          ),
        ],
      );

      final codes = controller.validate(draft).map((issue) => issue.code);

      expect(
        codes,
        containsAll(<String>[
          'name.required',
          'icon.required',
          'color.required',
          'weekdays.invalid',
          'item.position.invalid',
          'item.title.required',
          'item.schedule.invalid',
          'item.duration.invalid',
          'item.reminder.invalid',
          'item.pomodoro.focus.invalid',
          'item.pomodoro.break.invalid',
        ]),
      );
    });

    test('validates lifecycle combinations', () {
      final controller = RoutinesController(
        repository: _MemoryRoutinesRepository(),
        now: () => now,
      );
      final base = controller.draftFor(_routine(now: now));

      expect(
        controller
            .validate(base.copyWith(pausedUntilDate: now))
            .map((issue) => issue.code),
        contains('lifecycle.active.invalid'),
      );
      expect(
        controller
            .validate(
              base.copyWith(
                status: RoutineStatus.archived,
                clearArchivedAt: true,
              ),
            )
            .map((issue) => issue.code),
        contains('lifecycle.archived.invalid'),
      );
    });

    test(
      'reviews breaks, expected finish and overlap without blocking save',
      () {
        final controller = RoutinesController(
          repository: _MemoryRoutinesRepository(),
          now: () => now,
        );
        const draft = RoutineEditorDraft(
          id: 'routine-1',
          name: 'Morning',
          iconKey: 'sun',
          colorKey: 'yellow',
          status: RoutineStatus.active,
          weekdays: [DateTime.monday],
          items: [
            RoutineItemDraft(
              id: 'one',
              position: 0,
              title: 'Deep work',
              scheduledMinute: 8 * 60,
              durationMinutes: 50,
              pomodoroMode: RoutinePomodoroMode.recommended,
            ),
            RoutineItemDraft(
              id: 'two',
              position: 1,
              title: 'Review',
              scheduledMinute: 8 * 60 + 45,
              durationMinutes: 30,
              pomodoroMode: RoutinePomodoroMode.custom,
              customFocusMinutes: 15,
              customBreakMinutes: 3,
            ),
          ],
        );

        final review = controller.review(draft);

        expect(review.totalFocusMinutes, 80);
        expect(review.projectedBreakMinutes, 8);
        expect(review.totalOccupiedMinutes, 88);
        expect(review.expectedFinishMinute, 558);
        expect(review.scheduledSpanMinutes, 78);
        expect(review.overlaps.single.overlapMinutes, 10);
        expect(review.issues.single.code, 'items.overlap');
        expect(
          review.issues.single.severity,
          RoutineValidationSeverity.warning,
        );
        expect(review.canSave, isTrue);
      },
    );

    test(
      'saveDraft assigns local item IDs, trims values and persists',
      () async {
        var sequence = 0;
        final repository = _MemoryRoutinesRepository();
        final controller = RoutinesController(
          repository: repository,
          now: () => now,
          createId: (scope) => '$scope-${++sequence}',
        );
        final draft = controller.newDraft().copyWith(
          name: '  Morning  ',
          description: '  Start well  ',
          weekdays: [DateTime.monday],
          items: const [
            RoutineItemDraft(
              position: 0,
              title: '  Exercise  ',
              scheduledMinute: 420,
              durationMinutes: 30,
            ),
          ],
        );

        expect(await controller.saveDraft(draft), isTrue);

        final saved = repository.routines.single;
        expect(saved.id, 'routine-1');
        expect(saved.name, 'Morning');
        expect(saved.description, 'Start well');
        expect(saved.items.single.id, 'routine-item-2');
        expect(saved.items.single.title, 'Exercise');
        expect(controller.validationIssues.value, isEmpty);
      },
    );

    test('saveDraft rejects errors but allows overlap warnings', () async {
      final repository = _MemoryRoutinesRepository();
      final controller = RoutinesController(
        repository: repository,
        now: () => now,
      );

      final invalid = controller.newDraft();
      expect(await controller.saveDraft(invalid), isFalse);
      expect(repository.saveCalls, 0);

      const overlapping = RoutineEditorDraft(
        id: 'routine-overlap',
        name: 'Overlap',
        iconKey: 'clock',
        colorKey: 'red',
        status: RoutineStatus.active,
        weekdays: [1],
        items: [
          RoutineItemDraft(
            position: 0,
            title: 'One',
            scheduledMinute: 60,
            durationMinutes: 30,
          ),
          RoutineItemDraft(
            position: 1,
            title: 'Two',
            scheduledMinute: 75,
            durationMinutes: 30,
          ),
        ],
      );
      expect(await controller.saveDraft(overlapping), isTrue);
      expect(repository.saveCalls, 1);
    });

    test(
      'duplicates with independent local IDs and paused lifecycle',
      () async {
        var sequence = 0;
        final source = _routine(now: now);
        final repository = _MemoryRoutinesRepository(routines: [source]);
        final controller = RoutinesController(
          repository: repository,
          now: () => now,
          createId: (scope) => '$scope-${++sequence}',
        );
        await controller.load();

        final duplicate = await controller.duplicate(source.id);

        expect(duplicate, isNotNull);
        expect(duplicate!.id, 'routine-2');
        expect(duplicate.items.single.id, 'routine-item-3');
        expect(duplicate.items.single.routineId, duplicate.id);
        expect(duplicate.status, RoutineStatus.paused);
        expect(duplicate.name, 'Morning (copy)');
        expect(repository.routines, hasLength(2));
      },
    );

    test('pauses, resumes, archives and restores safely', () async {
      final repository = _MemoryRoutinesRepository(
        routines: [_routine(now: now)],
      );
      final controller = RoutinesController(
        repository: repository,
        now: () => now,
      );
      await controller.load();

      expect(
        await controller.pause('routine-1', untilDate: DateTime(2026, 8, 10)),
        isTrue,
      );
      expect(repository.routines.single.status, RoutineStatus.paused);
      expect(
        repository.routines.single.pausedUntilDate,
        DateTime(2026, 8, 10),
      );

      expect(await controller.resume('routine-1'), isTrue);
      expect(repository.routines.single.status, RoutineStatus.active);
      expect(repository.routines.single.pausedUntilDate, isNull);

      expect(await controller.archive('routine-1'), isTrue);
      expect(repository.routines.single.status, RoutineStatus.archived);
      expect(repository.routines.single.archivedAt, now);

      expect(await controller.restore('routine-1'), isTrue);
      expect(repository.routines.single.status, RoutineStatus.active);
      expect(repository.routines.single.archivedAt, isNull);
    });
  });
}

class _MemoryRoutinesRepository implements RoutinesRepository {
  _MemoryRoutinesRepository({
    List<Routine> routines = const [],
    List<RoutineRun> runs = const [],
    Map<String, List<RoutineItemRun>> itemRuns = const {},
  }) : routines = [...routines],
       runs = [...runs],
       itemRuns = {
         for (final entry in itemRuns.entries) entry.key: [...entry.value],
       };

  final List<Routine> routines;
  final List<RoutineRun> runs;
  final Map<String, List<RoutineItemRun>> itemRuns;
  int saveCalls = 0;

  @override
  Future<RoutineReconciliationResult> reconcileLocalDay(
    DateTime localDay,
  ) async => const RoutineReconciliationResult(
    createdRuns: 0,
    createdTasks: 0,
    missedRuns: 0,
  );

  @override
  Future<bool> isGeneratedTask(String taskId) async => false;

  @override
  Future<bool> updateFutureTemplateTitleForTask({
    required String taskId,
    required String title,
  }) async => false;

  @override
  Future<bool> skipOptionalItemRun(String itemRunId) async => false;

  @override
  Future<bool> skipRoutineRun(String routineRunId) async => false;

  @override
  Future<bool> shiftRemainingRun({
    required String routineRunId,
    required String currentItemRunId,
    required DateTime startAt,
  }) async => false;
  DateTime? lastStartDate;
  DateTime? lastEndDate;

  @override
  Future<void> deleteArchivedRoutine(String id) async {
    routines.removeWhere((routine) => routine.id == id);
  }

  @override
  Future<void> archiveRoutine(String id) async {
    _replaceLifecycle(id, RoutineStatus.archived, archivedAt: _testNow);
  }

  @override
  Future<Routine?> findRoutineById(String id) async {
    for (final routine in routines) {
      if (routine.id == id) {
        return routine;
      }
    }
    return null;
  }

  @override
  Future<RoutineRun?> findRun({
    required String sourceRoutineId,
    required DateTime localDate,
  }) async {
    for (final run in runs) {
      if (run.sourceRoutineId == sourceRoutineId &&
          _sameDate(run.localDate, localDate)) {
        return run;
      }
    }
    return null;
  }

  @override
  Future<List<RoutineItemRun>> loadItemRuns(String routineRunId) async => [
    ...itemRuns[routineRunId] ?? const [],
  ];

  @override
  Future<List<Routine>> loadRoutines() async => [...routines];

  @override
  Future<void> pauseRoutine(String id, {DateTime? until}) async {
    _replaceLifecycle(id, RoutineStatus.paused, pausedUntilDate: until);
  }

  @override
  Future<void> restoreRoutine(String id) async {
    _replaceLifecycle(id, RoutineStatus.active);
  }

  @override
  Future<void> resumeRoutine(String id) async {
    _replaceLifecycle(id, RoutineStatus.active);
  }

  @override
  Future<List<RoutineRun>> loadRuns({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    lastStartDate = startDate;
    lastEndDate = endDate;
    return runs
        .where(
          (run) =>
              !run.localDate.isBefore(startDate) &&
              !run.localDate.isAfter(endDate),
        )
        .toList();
  }

  @override
  Future<void> saveItemRun(RoutineItemRun itemRun) async {
    itemRuns.putIfAbsent(itemRun.routineRunId, () => [])
      ..removeWhere((existing) => existing.id == itemRun.id)
      ..add(itemRun);
  }

  @override
  Future<void> saveRoutine(Routine routine) async {
    saveCalls += 1;
    routines
      ..removeWhere((existing) => existing.id == routine.id)
      ..add(routine);
  }

  @override
  Future<void> saveRun(RoutineRun run) async {
    runs
      ..removeWhere((existing) => existing.id == run.id)
      ..add(run);
  }

  void _replaceLifecycle(
    String id,
    RoutineStatus status, {
    DateTime? pausedUntilDate,
    DateTime? archivedAt,
  }) {
    final index = routines.indexWhere((routine) => routine.id == id);
    if (index < 0) {
      throw StateError('Routine not found.');
    }
    final current = routines[index];
    routines[index] = Routine(
      id: current.id,
      name: current.name,
      description: current.description,
      iconKey: current.iconKey,
      colorKey: current.colorKey,
      status: status,
      pausedUntilDate: status == RoutineStatus.paused ? pausedUntilDate : null,
      archivedAt: status == RoutineStatus.archived ? archivedAt : null,
      createdAt: current.createdAt,
      updatedAt: _testNow,
      weekdays: current.weekdays,
      items: current.items,
    );
  }
}

final _testNow = DateTime(2026, 8, 7, 9);

Routine _routine({
  required DateTime now,
  String id = 'routine-1',
  RoutineStatus status = RoutineStatus.active,
  DateTime? archivedAt,
}) {
  return Routine(
    id: id,
    name: 'Morning',
    iconKey: 'sun',
    colorKey: 'yellow',
    status: status,
    archivedAt: archivedAt,
    createdAt: now,
    updatedAt: now,
    weekdays: const [DateTime.monday],
    items: [
      RoutineItem(
        id: 'item-1-$id',
        routineId: id,
        position: 0,
        title: 'Exercise',
        scheduledMinute: 420,
        durationMinutes: 30,
        isOptional: false,
        pomodoroMode: RoutinePomodoroMode.none,
        createdAt: now,
        updatedAt: now,
      ),
    ],
  );
}

RoutineRun _run(DateTime now) {
  return RoutineRun(
    id: 'run-1',
    routineId: 'routine-1',
    sourceRoutineId: 'routine-1',
    localDate: DateTime(now.year, now.month, now.day),
    status: RoutineRunStatus.inProgress,
    nameSnapshot: 'Morning',
    iconKeySnapshot: 'sun',
    colorKeySnapshot: 'yellow',
    scheduledStartMinuteSnapshot: 420,
    startedAt: now,
    createdAt: now,
    updatedAt: now,
  );
}

RoutineItemRun _itemRun({
  required DateTime now,
  required String id,
  String sourceItemId = 'item-1',
  bool optional = false,
  bool completed = false,
}) {
  return RoutineItemRun(
    id: id,
    routineRunId: 'run-1',
    routineItemId: sourceItemId,
    sourceItemId: sourceItemId,
    positionSnapshot: optional ? 1 : 0,
    titleSnapshot: id,
    scheduledAtSnapshot: now,
    durationMinutesSnapshot: 30,
    isOptionalSnapshot: optional,
    pomodoroModeSnapshot: RoutinePomodoroMode.none,
    status: completed ? RoutineRunStatus.completed : RoutineRunStatus.scheduled,
    completedAt: completed ? now : null,
    createdAt: now,
    updatedAt: now,
  );
}

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
