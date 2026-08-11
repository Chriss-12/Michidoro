import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/models/routine_schedule_projection.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum RoutineFilter { active, paused, archived }

enum RoutineValidationSeverity { error, warning }

enum RoutineEditorSection { identity, recurrence, items, review, lifecycle }

typedef RoutineLocalIdFactory = String Function(String scope);

class RoutineValidationIssue {
  const RoutineValidationIssue({
    required this.code,
    required this.section,
    required this.field,
    this.severity = RoutineValidationSeverity.error,
    this.itemIndex,
    this.conflictingItemIndex,
  });

  final String code;
  final RoutineEditorSection section;
  final String field;
  final RoutineValidationSeverity severity;
  final int? itemIndex;
  final int? conflictingItemIndex;

  bool get isError => severity == RoutineValidationSeverity.error;
}

class RoutineItemDraft {
  const RoutineItemDraft({
    required this.position,
    required this.title,
    required this.scheduledMinute,
    required this.durationMinutes,
    this.id = '',
    this.goalId,
    this.isOptional = false,
    this.reminderMinutesBefore,
    this.pomodoroMode = RoutinePomodoroMode.none,
    this.customFocusMinutes,
    this.customBreakMinutes,
    this.createdAt,
  });

  factory RoutineItemDraft.fromItem(RoutineItem item) => RoutineItemDraft(
    id: item.id,
    position: item.position,
    title: item.title,
    scheduledMinute: item.scheduledMinute,
    durationMinutes: item.durationMinutes,
    goalId: item.goalId,
    isOptional: item.isOptional,
    reminderMinutesBefore: item.reminderMinutesBefore,
    pomodoroMode: item.pomodoroMode,
    customFocusMinutes: item.customFocusMinutes,
    customBreakMinutes: item.customBreakMinutes,
    createdAt: item.createdAt,
  );

  final String id;
  final int position;
  final String title;
  final int scheduledMinute;
  final int durationMinutes;
  final String? goalId;
  final bool isOptional;
  final int? reminderMinutesBefore;
  final RoutinePomodoroMode pomodoroMode;
  final int? customFocusMinutes;
  final int? customBreakMinutes;
  final DateTime? createdAt;

  RoutineItemDraft copyWith({
    String? id,
    int? position,
    String? title,
    int? scheduledMinute,
    int? durationMinutes,
    String? goalId,
    bool clearGoalId = false,
    bool? isOptional,
    int? reminderMinutesBefore,
    bool clearReminder = false,
    RoutinePomodoroMode? pomodoroMode,
    int? customFocusMinutes,
    int? customBreakMinutes,
    bool clearCustomPomodoro = false,
    DateTime? createdAt,
  }) {
    return RoutineItemDraft(
      id: id ?? this.id,
      position: position ?? this.position,
      title: title ?? this.title,
      scheduledMinute: scheduledMinute ?? this.scheduledMinute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      goalId: clearGoalId ? null : goalId ?? this.goalId,
      isOptional: isOptional ?? this.isOptional,
      reminderMinutesBefore: clearReminder
          ? null
          : reminderMinutesBefore ?? this.reminderMinutesBefore,
      pomodoroMode: pomodoroMode ?? this.pomodoroMode,
      customFocusMinutes: clearCustomPomodoro
          ? null
          : customFocusMinutes ?? this.customFocusMinutes,
      customBreakMinutes: clearCustomPomodoro
          ? null
          : customBreakMinutes ?? this.customBreakMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RoutineEditorDraft {
  const RoutineEditorDraft({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorKey,
    required this.status,
    required this.weekdays,
    required this.items,
    this.description,
    this.pausedUntilDate,
    this.archivedAt,
    this.createdAt,
  });

  final String id;
  final String name;
  final String? description;
  final String iconKey;
  final String colorKey;
  final RoutineStatus status;
  final DateTime? pausedUntilDate;
  final DateTime? archivedAt;
  final DateTime? createdAt;
  final List<int> weekdays;
  final List<RoutineItemDraft> items;

  bool get isNew => createdAt == null;

  RoutineEditorDraft copyWith({
    String? id,
    String? name,
    String? description,
    bool clearDescription = false,
    String? iconKey,
    String? colorKey,
    RoutineStatus? status,
    DateTime? pausedUntilDate,
    bool clearPausedUntilDate = false,
    DateTime? archivedAt,
    bool clearArchivedAt = false,
    DateTime? createdAt,
    List<int>? weekdays,
    List<RoutineItemDraft>? items,
  }) {
    return RoutineEditorDraft(
      id: id ?? this.id,
      name: name ?? this.name,
      description: clearDescription ? null : description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      colorKey: colorKey ?? this.colorKey,
      status: status ?? this.status,
      pausedUntilDate: clearPausedUntilDate
          ? null
          : pausedUntilDate ?? this.pausedUntilDate,
      archivedAt: clearArchivedAt ? null : archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      weekdays: weekdays ?? this.weekdays,
      items: items ?? this.items,
    );
  }
}

class RoutineOverlap {
  const RoutineOverlap({
    required this.firstItemIndex,
    required this.secondItemIndex,
    required this.overlapMinutes,
  });

  final int firstItemIndex;
  final int secondItemIndex;
  final int overlapMinutes;
}

class RoutineReview {
  const RoutineReview({
    required this.totalFocusMinutes,
    required this.projectedBreakMinutes,
    required this.totalOccupiedMinutes,
    required this.scheduledSpanMinutes,
    required this.expectedFinishMinute,
    required this.overlaps,
    required this.issues,
  });

  final int totalFocusMinutes;
  final int projectedBreakMinutes;
  final int totalOccupiedMinutes;
  final int scheduledSpanMinutes;
  final int? expectedFinishMinute;
  final List<RoutineOverlap> overlaps;
  final List<RoutineValidationIssue> issues;

  bool get canSave => issues.every((issue) => !issue.isError);
  bool get crossesMidnight => (expectedFinishMinute ?? 0) > 24 * 60;
}

class RoutineTodayProgress {
  const RoutineTodayProgress({
    required this.routineId,
    required this.completedItems,
    required this.totalItems,
    required this.completedRequiredItems,
    required this.totalRequiredItems,
    this.run,
  });

  final String routineId;
  final RoutineRun? run;
  final int completedItems;
  final int totalItems;
  final int completedRequiredItems;
  final int totalRequiredItems;

  double get completionRatio =>
      totalRequiredItems == 0 ? 0 : completedRequiredItems / totalRequiredItems;
}

class RoutinesController {
  RoutinesController({
    required RoutinesRepository repository,
    DateTime Function()? now,
    RoutineLocalIdFactory? createId,
  }) : _repository = repository,
       _now = now ?? DateTime.now,
       _externalIdFactory = createId;

  static const int recommendedFocusMinutes = 25;
  static const int recommendedBreakMinutes = 5;

  final RoutinesRepository _repository;
  final DateTime Function() _now;
  final RoutineLocalIdFactory? _externalIdFactory;
  var _idSequence = 0;

  Future<void> Function()? onReminderScheduleChanged;

  final FlutterSignal<List<Routine>> routines = signal(const []);
  final FlutterSignal<List<RoutineRun>> todayRuns = signal(const []);
  final FlutterSignal<Map<String, List<RoutineItemRun>>> todayItemRuns = signal(
    const {},
  );
  final FlutterSignal<RoutineFilter> filter = signal(RoutineFilter.active);
  final FlutterSignal<List<RoutineValidationIssue>> validationIssues = signal(
    const [],
  );
  final FlutterSignal<bool> isLoading = signal(false);
  final FlutterSignal<String?> operationError = signal(null);

  late final Computed<List<Routine>> filteredRoutines = computed(() {
    final expectedStatus = switch (filter.value) {
      RoutineFilter.active => RoutineStatus.active,
      RoutineFilter.paused => RoutineStatus.paused,
      RoutineFilter.archived => RoutineStatus.archived,
    };
    return routines.value
        .where((routine) => routine.status == expectedStatus)
        .toList(growable: false);
  });

  late final Computed<Map<String, RoutineTodayProgress>> todayProgress =
      computed(() {
        final runsByRoutine = {
          for (final run in todayRuns.value) run.sourceRoutineId: run,
        };
        return {
          for (final routine in routines.value)
            routine.id: _progressFor(
              routine.id,
              runsByRoutine[routine.id],
              todayItemRuns.value,
            ),
        };
      });

  RoutineFilter get selectedFilter => filter.value;

  DateTime get currentLocalTime => _now();

  set selectedFilter(RoutineFilter value) => filter.value = value;

  Future<void> load({DateTime? day}) async {
    isLoading.value = true;
    operationError.value = null;
    try {
      final localDay = _dateOnly(day ?? _now());
      final loadedRoutines = await _repository.loadRoutines();
      final loadedRuns = await _repository.loadRuns(
        startDate: localDay,
        endDate: localDay,
      );
      final entries = await Future.wait(
        loadedRuns.map((run) async {
          final itemRuns = await _repository.loadItemRuns(run.id);
          return MapEntry(run.id, itemRuns);
        }),
      );
      routines.value = _sortRoutines(loadedRoutines);
      todayRuns.value = loadedRuns;
      todayItemRuns.value = Map.unmodifiable(Map.fromEntries(entries));
    } on Object catch (error) {
      operationError.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<RoutineReconciliationResult?> reconcileToday({DateTime? day}) async {
    final localDay = _dateOnly(day ?? _now());
    operationError.value = null;
    try {
      final result = await _repository.reconcileLocalDay(localDay);
      await load(day: localDay);
      await onReminderScheduleChanged?.call();
      return result;
    } on Object catch (error) {
      operationError.value = error.toString();
      return null;
    }
  }

  Future<List<RoutineScheduleOccurrence>> scheduleBetween({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final loadedRuns = await _repository.loadRuns(
      startDate: _dateOnly(startDate),
      endDate: _dateOnly(endDate),
    );
    final entries = await Future.wait(
      loadedRuns.map(
        (run) async => MapEntry(run.id, await _repository.loadItemRuns(run.id)),
      ),
    );
    return projectRoutineSchedule(
      routines: routines.value,
      runs: loadedRuns,
      itemRuns: Map.fromEntries(entries),
      startDate: startDate,
      endDate: endDate,
      today: _now(),
    );
  }

  RoutineEditorDraft newDraft({
    String iconKey = 'routine',
    String colorKey = 'primary',
  }) {
    return RoutineEditorDraft(
      id: _nextUniqueId(
        'routine',
        routines.value.map((routine) => routine.id).toSet(),
      ),
      name: '',
      iconKey: iconKey,
      colorKey: colorKey,
      status: RoutineStatus.active,
      weekdays: const [],
      items: const [],
    );
  }

  RoutineEditorDraft draftFor(Routine routine) => RoutineEditorDraft(
    id: routine.id,
    name: routine.name,
    description: routine.description,
    iconKey: routine.iconKey,
    colorKey: routine.colorKey,
    status: routine.status,
    pausedUntilDate: routine.pausedUntilDate,
    archivedAt: routine.archivedAt,
    createdAt: routine.createdAt,
    weekdays: List.unmodifiable(routine.weekdays),
    items: List.unmodifiable(routine.items.map(RoutineItemDraft.fromItem)),
  );

  List<RoutineValidationIssue> validate(RoutineEditorDraft draft) {
    final issues = _validateDraft(draft);
    validationIssues.value = issues;
    return issues;
  }

  List<RoutineValidationIssue> validateRoutine(Routine routine) {
    return validate(draftFor(routine));
  }

  RoutineReview review(RoutineEditorDraft draft) {
    final issues = _validateDraft(draft);
    final overlaps = <RoutineOverlap>[];
    var totalFocus = 0;
    var totalBreaks = 0;
    var totalOccupied = 0;
    int? firstStart;
    int? lastFinish;

    final scheduled = <_ScheduledDraft>[];
    for (var index = 0; index < draft.items.length; index++) {
      final item = draft.items[index];
      if (!_hasCalculableSchedule(item)) {
        continue;
      }
      final breaks = _projectedBreakMinutes(item);
      final occupied = item.durationMinutes + breaks;
      final finish = item.scheduledMinute + occupied;
      totalFocus += item.durationMinutes;
      totalBreaks += breaks;
      totalOccupied += occupied;
      firstStart = firstStart == null
          ? item.scheduledMinute
          : _min(firstStart, item.scheduledMinute);
      lastFinish = lastFinish == null ? finish : _max(lastFinish, finish);
      scheduled.add(_ScheduledDraft(index, item.scheduledMinute, finish));
    }

    scheduled.sort((first, second) => first.start.compareTo(second.start));
    for (var index = 0; index < scheduled.length; index++) {
      final first = scheduled[index];
      for (var next = index + 1; next < scheduled.length; next++) {
        final second = scheduled[next];
        if (second.start >= first.finish) {
          break;
        }
        overlaps.add(
          RoutineOverlap(
            firstItemIndex: first.index,
            secondItemIndex: second.index,
            overlapMinutes: _min(first.finish, second.finish) - second.start,
          ),
        );
      }
    }
    issues.addAll(
      overlaps.map(
        (overlap) => RoutineValidationIssue(
          code: 'items.overlap',
          section: RoutineEditorSection.review,
          field: 'scheduledMinute',
          severity: RoutineValidationSeverity.warning,
          itemIndex: overlap.firstItemIndex,
          conflictingItemIndex: overlap.secondItemIndex,
        ),
      ),
    );
    validationIssues.value = List.unmodifiable(issues);

    return RoutineReview(
      totalFocusMinutes: totalFocus,
      projectedBreakMinutes: totalBreaks,
      totalOccupiedMinutes: totalOccupied,
      scheduledSpanMinutes: firstStart == null ? 0 : lastFinish! - firstStart,
      expectedFinishMinute: lastFinish,
      overlaps: List.unmodifiable(overlaps),
      issues: List.unmodifiable(issues),
    );
  }

  Future<bool> saveDraft(RoutineEditorDraft draft) async {
    final draftReview = review(draft);
    if (!draftReview.canSave) {
      return false;
    }

    final now = _now();
    final routine = _routineFromDraft(draft, now);
    operationError.value = null;
    try {
      await _repository.saveRoutine(routine);
      final reconciliation = await reconcileToday();
      if (reconciliation == null) return false;
      validationIssues.value = const [];
      return true;
    } on Object catch (error) {
      operationError.value = error.toString();
      return false;
    }
  }

  Future<Routine?> duplicate(
    String routineId, {
    String copyLabel = 'copy',
  }) async {
    final source =
        _findRoutine(routineId) ?? await _repository.findRoutineById(routineId);
    if (source == null) {
      return null;
    }
    final now = _now();
    final duplicateId = _nextUniqueId(
      'routine',
      routines.value.map((routine) => routine.id).toSet(),
    );
    final occupiedItemIds = routines.value
        .expand((routine) => routine.items)
        .map((item) => item.id)
        .toSet();
    final duplicate = Routine(
      id: duplicateId,
      name: '${source.name} ($copyLabel)',
      description: source.description,
      iconKey: source.iconKey,
      colorKey: source.colorKey,
      status: RoutineStatus.paused,
      createdAt: now,
      updatedAt: now,
      weekdays: List.unmodifiable(source.weekdays),
      items: List.unmodifiable([
        for (var index = 0; index < source.items.length; index++)
          _copyItemForRoutine(
            source.items[index],
            duplicateId,
            index,
            now,
            occupiedItemIds,
          ),
      ]),
    );
    await _repository.saveRoutine(duplicate);
    _replaceRoutine(duplicate);
    await onReminderScheduleChanged?.call();
    return duplicate;
  }

  Future<bool> pause(String id, {DateTime? untilDate}) => _changeLifecycle(
    id,
    RoutineStatus.paused,
    pausedUntilDate: untilDate == null ? null : _dateOnly(untilDate),
  );

  Future<bool> resume(String id) => _changeLifecycle(id, RoutineStatus.active);

  Future<bool> archive(String id) =>
      _changeLifecycle(id, RoutineStatus.archived);

  Future<bool> restore(String id) =>
      _changeLifecycle(id, RoutineStatus.active, isRestore: true);

  RoutineTodayProgress progressForToday(String routineId) {
    return todayProgress.value[routineId] ??
        RoutineTodayProgress(
          routineId: routineId,
          completedItems: 0,
          totalItems: 0,
          completedRequiredItems: 0,
          totalRequiredItems: 0,
        );
  }

  Future<bool> skipOptionalItem(RoutineItemRun itemRun) async {
    operationError.value = null;
    try {
      final skipped = await _repository.skipOptionalItemRun(itemRun.id);
      if (skipped) await refreshTodayProgress();
      return skipped;
    } on Object catch (error) {
      operationError.value = error.toString();
      return false;
    }
  }

  Future<bool> skipTodayRun(RoutineRun run) async {
    operationError.value = null;
    try {
      final skipped = await _repository.skipRoutineRun(run.id);
      if (skipped) await refreshTodayProgress();
      return skipped;
    } on Object catch (error) {
      operationError.value = error.toString();
      return false;
    }
  }

  Future<bool> shiftRemainingRun({
    required RoutineRun run,
    required RoutineItemRun currentItem,
  }) async {
    operationError.value = null;
    try {
      final shifted = await _repository.shiftRemainingRun(
        routineRunId: run.id,
        currentItemRunId: currentItem.id,
        startAt: _now(),
      );
      if (shifted) await refreshTodayProgress();
      return shifted;
    } on Object catch (error) {
      operationError.value = error.toString();
      return false;
    }
  }

  void clearMessages() {
    validationIssues.value = const [];
    operationError.value = null;
  }

  Future<bool> _changeLifecycle(
    String id,
    RoutineStatus status, {
    DateTime? pausedUntilDate,
    bool isRestore = false,
  }) async {
    final current = _findRoutine(id) ?? await _repository.findRoutineById(id);
    if (current == null) {
      return false;
    }
    operationError.value = null;
    try {
      if (isRestore) {
        await _repository.restoreRoutine(id);
      } else {
        switch (status) {
          case RoutineStatus.active:
            await _repository.resumeRoutine(id);
          case RoutineStatus.paused:
            await _repository.pauseRoutine(id, until: pausedUntilDate);
          case RoutineStatus.archived:
            await _repository.archiveRoutine(id);
        }
      }
      final updated = await _repository.findRoutineById(id);
      if (updated == null) {
        operationError.value = 'Routine was not found after lifecycle update.';
        return false;
      }
      _replaceRoutine(updated);
      await onReminderScheduleChanged?.call();
      return true;
    } on Object catch (error) {
      operationError.value = error.toString();
      return false;
    }
  }

  List<RoutineValidationIssue> _validateDraft(RoutineEditorDraft draft) {
    final issues = <RoutineValidationIssue>[];
    void add(
      String code,
      RoutineEditorSection section,
      String field, {
      int? itemIndex,
    }) {
      issues.add(
        RoutineValidationIssue(
          code: code,
          section: section,
          field: field,
          itemIndex: itemIndex,
        ),
      );
    }

    final name = draft.name.trim();
    if (name.isEmpty) {
      add('name.required', RoutineEditorSection.identity, 'name');
    } else if (name.length > 80) {
      add('name.tooLong', RoutineEditorSection.identity, 'name');
    }
    if ((draft.description?.trim().length ?? 0) > 500) {
      add('description.tooLong', RoutineEditorSection.identity, 'description');
    }
    if (draft.iconKey.trim().isEmpty) {
      add('icon.required', RoutineEditorSection.identity, 'iconKey');
    }
    if (draft.colorKey.trim().isEmpty) {
      add('color.required', RoutineEditorSection.identity, 'colorKey');
    }

    final days = draft.weekdays.toSet();
    if (draft.weekdays.isEmpty) {
      add('weekdays.required', RoutineEditorSection.recurrence, 'weekdays');
    }
    if (days.length != draft.weekdays.length ||
        days.any((day) => day < DateTime.monday || day > DateTime.sunday)) {
      add('weekdays.invalid', RoutineEditorSection.recurrence, 'weekdays');
    }
    if (draft.items.isEmpty) {
      add('items.required', RoutineEditorSection.items, 'items');
    }

    final itemIds = <String>{};
    for (var index = 0; index < draft.items.length; index++) {
      final item = draft.items[index];
      if (item.position != index) {
        add(
          'item.position.invalid',
          RoutineEditorSection.items,
          'position',
          itemIndex: index,
        );
      }
      if (item.id.isNotEmpty && !itemIds.add(item.id)) {
        add(
          'item.id.duplicate',
          RoutineEditorSection.items,
          'id',
          itemIndex: index,
        );
      }
      if (item.title.trim().isEmpty) {
        add(
          'item.title.required',
          RoutineEditorSection.items,
          'title',
          itemIndex: index,
        );
      } else if (item.title.trim().length > 160) {
        add(
          'item.title.tooLong',
          RoutineEditorSection.items,
          'title',
          itemIndex: index,
        );
      }
      if (item.scheduledMinute < 0 || item.scheduledMinute > 1439) {
        add(
          'item.schedule.invalid',
          RoutineEditorSection.items,
          'scheduledMinute',
          itemIndex: index,
        );
      }
      if (item.durationMinutes < 1 || item.durationMinutes > 1440) {
        add(
          'item.duration.invalid',
          RoutineEditorSection.items,
          'durationMinutes',
          itemIndex: index,
        );
      }
      final reminder = item.reminderMinutesBefore;
      if (reminder != null && (reminder < 0 || reminder > 10080)) {
        add(
          'item.reminder.invalid',
          RoutineEditorSection.items,
          'reminderMinutesBefore',
          itemIndex: index,
        );
      }
      _validatePomodoro(item, index, add);
    }

    switch (draft.status) {
      case RoutineStatus.active:
        if (draft.pausedUntilDate != null || draft.archivedAt != null) {
          add(
            'lifecycle.active.invalid',
            RoutineEditorSection.lifecycle,
            'status',
          );
        }
      case RoutineStatus.paused:
        if (draft.archivedAt != null) {
          add(
            'lifecycle.paused.invalid',
            RoutineEditorSection.lifecycle,
            'status',
          );
        }
      case RoutineStatus.archived:
        if (draft.archivedAt == null || draft.pausedUntilDate != null) {
          add(
            'lifecycle.archived.invalid',
            RoutineEditorSection.lifecycle,
            'status',
          );
        }
    }
    return issues;
  }

  void _validatePomodoro(
    RoutineItemDraft item,
    int index,
    void Function(
      String code,
      RoutineEditorSection section,
      String field, {
      int? itemIndex,
    })
    add,
  ) {
    if (item.pomodoroMode == RoutinePomodoroMode.custom) {
      final focus = item.customFocusMinutes;
      final rest = item.customBreakMinutes;
      if (focus == null || focus < 1 || focus > 240) {
        add(
          'item.pomodoro.focus.invalid',
          RoutineEditorSection.items,
          'customFocusMinutes',
          itemIndex: index,
        );
      }
      if (rest == null || rest < 1 || rest > 60) {
        add(
          'item.pomodoro.break.invalid',
          RoutineEditorSection.items,
          'customBreakMinutes',
          itemIndex: index,
        );
      }
    } else if (item.customFocusMinutes != null ||
        item.customBreakMinutes != null) {
      add(
        'item.pomodoro.unexpectedCustomValues',
        RoutineEditorSection.items,
        'pomodoroMode',
        itemIndex: index,
      );
    }
  }

  Routine _routineFromDraft(RoutineEditorDraft draft, DateTime now) {
    final occupiedItemIds = routines.value
        .expand((routine) => routine.items)
        .where((item) => item.routineId != draft.id)
        .map((item) => item.id)
        .toSet();
    return Routine(
      id: draft.id,
      name: draft.name.trim(),
      description: _trimmedOrNull(draft.description),
      iconKey: draft.iconKey.trim(),
      colorKey: draft.colorKey.trim(),
      status: draft.status,
      pausedUntilDate: draft.pausedUntilDate,
      archivedAt: draft.archivedAt,
      createdAt: draft.createdAt ?? now,
      updatedAt: now,
      weekdays: List.unmodifiable(draft.weekdays),
      items: List.unmodifiable([
        for (var index = 0; index < draft.items.length; index++)
          _itemFromDraft(
            draft.items[index],
            draft.id,
            index,
            now,
            occupiedItemIds,
          ),
      ]),
    );
  }

  RoutineItem _itemFromDraft(
    RoutineItemDraft draft,
    String routineId,
    int position,
    DateTime now,
    Set<String> occupiedIds,
  ) {
    final id = draft.id.isEmpty
        ? _nextUniqueId('routine-item', occupiedIds)
        : draft.id;
    occupiedIds.add(id);
    return RoutineItem(
      id: id,
      routineId: routineId,
      position: position,
      title: draft.title.trim(),
      scheduledMinute: draft.scheduledMinute,
      durationMinutes: draft.durationMinutes,
      goalId: _trimmedOrNull(draft.goalId),
      isOptional: draft.isOptional,
      reminderMinutesBefore: draft.reminderMinutesBefore,
      pomodoroMode: draft.pomodoroMode,
      customFocusMinutes: draft.customFocusMinutes,
      customBreakMinutes: draft.customBreakMinutes,
      createdAt: draft.createdAt ?? now,
      updatedAt: now,
    );
  }

  RoutineItem _copyItemForRoutine(
    RoutineItem source,
    String routineId,
    int position,
    DateTime now,
    Set<String> occupiedIds,
  ) {
    final id = _nextUniqueId('routine-item', occupiedIds);
    occupiedIds.add(id);
    return RoutineItem(
      id: id,
      routineId: routineId,
      position: position,
      title: source.title,
      scheduledMinute: source.scheduledMinute,
      durationMinutes: source.durationMinutes,
      goalId: source.goalId,
      isOptional: source.isOptional,
      reminderMinutesBefore: source.reminderMinutesBefore,
      pomodoroMode: source.pomodoroMode,
      customFocusMinutes: source.customFocusMinutes,
      customBreakMinutes: source.customBreakMinutes,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> refreshTodayProgress({DateTime? day}) async {
    final localDay = _dateOnly(day ?? _now());
    final loadedRuns = await _repository.loadRuns(
      startDate: localDay,
      endDate: localDay,
    );
    final entries = await Future.wait(
      loadedRuns.map((run) async {
        return MapEntry(run.id, await _repository.loadItemRuns(run.id));
      }),
    );
    todayRuns.value = loadedRuns;
    todayItemRuns.value = Map.unmodifiable(Map.fromEntries(entries));
  }

  RoutineTodayProgress _progressFor(
    String routineId,
    RoutineRun? run,
    Map<String, List<RoutineItemRun>> itemRuns,
  ) {
    final items = run == null
        ? const <RoutineItemRun>[]
        : itemRuns[run.id] ?? const <RoutineItemRun>[];
    final required = items.where((item) => !item.isOptionalSnapshot);
    return RoutineTodayProgress(
      routineId: routineId,
      run: run,
      completedItems: items
          .where((item) => item.status == RoutineRunStatus.completed)
          .length,
      totalItems: items.length,
      completedRequiredItems: required
          .where((item) => item.status == RoutineRunStatus.completed)
          .length,
      totalRequiredItems: required.length,
    );
  }

  int _projectedBreakMinutes(RoutineItemDraft item) {
    final (focus, rest) = switch (item.pomodoroMode) {
      RoutinePomodoroMode.none => (0, 0),
      RoutinePomodoroMode.recommended => (
        recommendedFocusMinutes,
        recommendedBreakMinutes,
      ),
      RoutinePomodoroMode.custom => (
        item.customFocusMinutes ?? 0,
        item.customBreakMinutes ?? 0,
      ),
    };
    if (focus <= 0 || rest <= 0 || item.durationMinutes <= 0) {
      return 0;
    }
    return ((item.durationMinutes - 1) ~/ focus) * rest;
  }

  bool _hasCalculableSchedule(RoutineItemDraft item) {
    if (item.scheduledMinute < 0 || item.scheduledMinute > 1439) {
      return false;
    }
    if (item.durationMinutes < 1 || item.durationMinutes > 1440) {
      return false;
    }
    if (item.pomodoroMode != RoutinePomodoroMode.custom) {
      return true;
    }
    return (item.customFocusMinutes ?? 0) > 0 &&
        (item.customBreakMinutes ?? 0) > 0;
  }

  Routine? _findRoutine(String id) {
    for (final routine in routines.value) {
      if (routine.id == id) {
        return routine;
      }
    }
    return null;
  }

  void _replaceRoutine(Routine updated) {
    routines.value = _sortRoutines([
      for (final routine in routines.value)
        if (routine.id != updated.id) routine,
      updated,
    ]);
  }

  List<Routine> _sortRoutines(Iterable<Routine> source) {
    final result = source.toList()
      ..sort((first, second) {
        final firstStart = first.items.isEmpty
            ? 24 * 60
            : first.items.map((item) => item.scheduledMinute).reduce(_min);
        final secondStart = second.items.isEmpty
            ? 24 * 60
            : second.items.map((item) => item.scheduledMinute).reduce(_min);
        final scheduleComparison = firstStart.compareTo(secondStart);
        return scheduleComparison != 0
            ? scheduleComparison
            : first.name.toLowerCase().compareTo(second.name.toLowerCase());
      });
    return List.unmodifiable(result);
  }

  String _createId(String scope) {
    final factory = _externalIdFactory;
    if (factory != null) {
      return factory(scope);
    }
    _idSequence += 1;
    return '$scope-${_now().microsecondsSinceEpoch}-$_idSequence';
  }

  String _nextUniqueId(String scope, Set<String> occupiedIds) {
    for (var attempt = 0; attempt < 100; attempt++) {
      final candidate = _createId(scope);
      if (!occupiedIds.contains(candidate)) {
        return candidate;
      }
    }
    throw StateError('Could not create a unique local $scope ID.');
  }
}

class _ScheduledDraft {
  const _ScheduledDraft(this.index, this.start, this.finish);

  final int index;
  final int start;
  final int finish;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String? _trimmedOrNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

int _min(int first, int second) => first < second ? first : second;

int _max(int first, int second) => first > second ? first : second;
