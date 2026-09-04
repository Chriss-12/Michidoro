import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_coordinator.dart';

class DriftRoutinesRepository implements RoutinesRepository {
  DriftRoutinesRepository(this._dao, {SyncMutationCoordinator? sync})
    : _sync = sync;

  final RoutinesDao _dao;
  final SyncMutationCoordinator? _sync;
  var _idSequence = 0;

  @override
  Future<List<Routine>> loadRoutines() async {
    final records = await _dao.getAllRoutines();
    final days = await _dao.getAllRoutineDays();
    final items = await _dao.getAllRoutineItems();
    final daysByRoutine = <String, List<RoutineDayRecord>>{};
    final itemsByRoutine = <String, List<RoutineItemRecord>>{};
    for (final day in days) {
      daysByRoutine.putIfAbsent(day.routineId, () => []).add(day);
    }
    for (final item in items) {
      itemsByRoutine.putIfAbsent(item.routineId, () => []).add(item);
    }
    return records
        .map(
          (record) => _toRoutine(
            record,
            days: daysByRoutine[record.id] ?? const [],
            items: itemsByRoutine[record.id] ?? const [],
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<Routine?> findRoutineById(String id) async {
    final record = await _dao.findRoutineById(id);
    if (record == null) {
      return null;
    }
    final days = await _dao.getDaysForRoutine(id);
    final items = await _dao.getItemsForRoutine(id);
    return _toRoutine(record, days: days, items: items);
  }

  @override
  Future<void> saveRoutine(Routine routine) async {
    _validateRoutine(routine);
    final operationKind = await _dao.findRoutineById(routine.id) == null
        ? 'create'
        : 'update';
    await _run(
      entityId: routine.id,
      operationKind: operationKind,
      changedFields: {'aggregate': _routineAggregate(routine)},
      mutate: () => _dao.saveRoutineAggregate(
        routine: RoutineRecordsCompanion.insert(
          id: routine.id,
          name: routine.name.trim(),
          description: Value(_trimmedOrNull(routine.description)),
          iconKey: Value(routine.iconKey),
          colorKey: Value(routine.colorKey),
          customColorArgb: Value(routine.customColorArgb),
          validFromLocalDate: Value(
            routine.validFromDate == null
                ? null
                : _dateToStorage(routine.validFromDate!),
          ),
          validUntilLocalDate: Value(
            routine.validUntilDate == null
                ? null
                : _dateToStorage(routine.validUntilDate!),
          ),
          status: Value(routine.status.name),
          pausedUntilLocalDate: Value(
            routine.pausedUntilDate == null
                ? null
                : _dateToStorage(routine.pausedUntilDate!),
          ),
          archivedAt: Value(routine.archivedAt),
          createdAt: routine.createdAt,
          updatedAt: routine.updatedAt,
        ),
        days: routine.weekdays
            .map(
              (weekday) => RoutineDayRecordsCompanion.insert(
                routineId: routine.id,
                weekday: weekday,
              ),
            )
            .toList(growable: false),
        items: routine.items
            .map(
              (item) => RoutineItemRecordsCompanion.insert(
                id: item.id,
                routineId: routine.id,
                position: item.position,
                title: item.title.trim(),
                scheduledMinute: item.scheduledMinute,
                durationMinutes: item.durationMinutes,
                goalId: Value(item.goalId),
                isOptional: Value(item.isOptional),
                reminderMinutesBefore: Value(item.reminderMinutesBefore),
                pomodoroMode: Value(item.pomodoroMode.name),
                customFocusMinutes: Value(item.customFocusMinutes),
                customBreakMinutes: Value(item.customBreakMinutes),
                createdAt: item.createdAt,
                updatedAt: item.updatedAt,
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  @override
  Future<void> pauseRoutine(String id, {DateTime? until}) {
    final now = DateTime.now();
    return _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'status': RoutineStatus.paused.name,
        'pausedUntilLocalDate': until == null ? null : _dateToStorage(until),
        'archivedAt': null,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.pauseRoutine(
        id: id,
        untilLocalDate: until == null ? null : _dateToStorage(until),
        updatedAt: now,
      ),
    );
  }

  @override
  Future<void> resumeRoutine(String id) {
    final now = DateTime.now();
    return _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'status': RoutineStatus.active.name,
        'pausedUntilLocalDate': null,
        'archivedAt': null,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.resumeRoutine(id: id, updatedAt: now),
    );
  }

  @override
  Future<void> archiveRoutine(String id) {
    final now = DateTime.now();
    return _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'status': RoutineStatus.archived.name,
        'pausedUntilLocalDate': null,
        'archivedAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.archiveRoutine(id: id, archivedAt: now),
    );
  }

  @override
  Future<void> restoreRoutine(String id) {
    final now = DateTime.now();
    return _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'status': RoutineStatus.active.name,
        'pausedUntilLocalDate': null,
        'archivedAt': null,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.restoreRoutine(id: id, updatedAt: now),
    );
  }

  @override
  Future<void> deleteArchivedRoutine(String id) => _run(
    entityId: id,
    operationKind: 'delete',
    changedFields: const {},
    mutate: () => _dao.deleteArchivedRoutine(id),
  );

  Future<T> _run<T>({
    required String entityId,
    required String operationKind,
    required Map<String, Object?> changedFields,
    required Future<T> Function() mutate,
  }) {
    final sync = _sync;
    if (sync == null) return mutate();
    return sync(
      entityType: 'routine',
      entityId: entityId,
      operationKind: operationKind,
      changedFields: changedFields,
      mutate: mutate,
    );
  }

  Map<String, Object?> _routineAggregate(Routine routine) => {
    'name': routine.name.trim(),
    'description': _trimmedOrNull(routine.description),
    'iconKey': routine.iconKey,
    'colorKey': routine.colorKey,
    'customColorArgb': routine.customColorArgb,
    'validFromLocalDate': routine.validFromDate == null
        ? null
        : _dateToStorage(routine.validFromDate!),
    'validUntilLocalDate': routine.validUntilDate == null
        ? null
        : _dateToStorage(routine.validUntilDate!),
    'status': routine.status.name,
    'pausedUntilLocalDate': routine.pausedUntilDate == null
        ? null
        : _dateToStorage(routine.pausedUntilDate!),
    'archivedAt': routine.archivedAt?.millisecondsSinceEpoch,
    'createdAt': routine.createdAt.millisecondsSinceEpoch,
    'updatedAt': routine.updatedAt.millisecondsSinceEpoch,
    'weekdays': routine.weekdays,
    'items': routine.items
        .map(
          (item) => {
            'id': item.id,
            'position': item.position,
            'title': item.title.trim(),
            'scheduledMinute': item.scheduledMinute,
            'durationMinutes': item.durationMinutes,
            'goalId': item.goalId,
            'isOptional': item.isOptional,
            'reminderMinutesBefore': item.reminderMinutesBefore,
            'pomodoroMode': item.pomodoroMode.name,
            'customFocusMinutes': item.customFocusMinutes,
            'customBreakMinutes': item.customBreakMinutes,
            'createdAt': item.createdAt.millisecondsSinceEpoch,
            'updatedAt': item.updatedAt.millisecondsSinceEpoch,
          },
        )
        .toList(growable: false),
  };

  @override
  Future<RoutineReconciliationResult> reconcileLocalDay(
    DateTime localDay,
  ) async {
    final now = DateTime.now();
    final result = await _dao.reconcileLocalDay(
      localDay: localDay,
      reconciledAt: now,
      createId: _createLocalId,
    );
    return RoutineReconciliationResult(
      createdRuns: result.createdRuns,
      createdTasks: result.createdTasks,
      missedRuns: result.missedRuns,
    );
  }

  @override
  Future<bool> isGeneratedTask(String taskId) => _dao.isGeneratedTask(taskId);

  @override
  Future<bool> updateFutureTemplateTitleForTask({
    required String taskId,
    required String title,
  }) => _dao.updateFutureTemplateTitleForTask(
    taskId: taskId,
    title: title.trim(),
    updatedAt: DateTime.now(),
  );

  @override
  Future<List<RoutineRun>> loadRuns({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final records = await _dao.getRunsInRange(
      startLocalDate: _dateToStorage(startDate),
      endLocalDate: _dateToStorage(endDate),
    );
    return records.map(_toRun).toList(growable: false);
  }

  @override
  Future<RoutineRun?> findRun({
    required String sourceRoutineId,
    required DateTime localDate,
  }) async {
    final record = await _dao.findRun(
      sourceRoutineId: sourceRoutineId,
      localDate: _dateToStorage(localDate),
    );
    return record == null ? null : _toRun(record);
  }

  @override
  Future<void> saveRun(RoutineRun run) async {
    _validateRun(run);
    await _dao.saveRun(
      RoutineRunRecordsCompanion.insert(
        id: run.id,
        routineId: Value(run.routineId),
        sourceRoutineId: run.sourceRoutineId,
        localDate: _dateToStorage(run.localDate),
        status: Value(run.status.name),
        nameSnapshot: run.nameSnapshot,
        iconKeySnapshot: run.iconKeySnapshot,
        colorKeySnapshot: run.colorKeySnapshot,
        customColorArgbSnapshot: Value(run.customColorArgbSnapshot),
        scheduledStartMinuteSnapshot: run.scheduledStartMinuteSnapshot,
        startedAt: Value(run.startedAt),
        completedAt: Value(run.completedAt),
        skippedAt: Value(run.skippedAt),
        createdAt: run.createdAt,
        updatedAt: run.updatedAt,
      ),
    );
  }

  @override
  Future<List<RoutineItemRun>> loadItemRuns(String routineRunId) async {
    final records = await _dao.getItemRuns(routineRunId);
    return records.map(_toItemRun).toList(growable: false);
  }

  @override
  Future<void> saveItemRun(RoutineItemRun itemRun) async {
    _validateItemRun(itemRun);
    await _dao.saveItemRun(
      RoutineItemRunRecordsCompanion.insert(
        id: itemRun.id,
        routineRunId: itemRun.routineRunId,
        routineItemId: Value(itemRun.routineItemId),
        sourceItemId: itemRun.sourceItemId,
        taskId: Value(itemRun.taskId),
        taskIdSnapshot: Value(itemRun.taskIdSnapshot),
        positionSnapshot: itemRun.positionSnapshot,
        titleSnapshot: itemRun.titleSnapshot,
        scheduledAtSnapshot: itemRun.scheduledAtSnapshot,
        durationMinutesSnapshot: itemRun.durationMinutesSnapshot,
        goalTitleSnapshot: Value(itemRun.goalTitleSnapshot),
        isOptionalSnapshot: Value(itemRun.isOptionalSnapshot),
        reminderMinutesSnapshot: Value(itemRun.reminderMinutesSnapshot),
        pomodoroModeSnapshot: itemRun.pomodoroModeSnapshot.name,
        customFocusMinutesSnapshot: Value(
          itemRun.customFocusMinutesSnapshot,
        ),
        customBreakMinutesSnapshot: Value(
          itemRun.customBreakMinutesSnapshot,
        ),
        status: Value(itemRun.status.name),
        startedAt: Value(itemRun.startedAt),
        completedAt: Value(itemRun.completedAt),
        skippedAt: Value(itemRun.skippedAt),
        createdAt: itemRun.createdAt,
        updatedAt: itemRun.updatedAt,
      ),
    );
  }

  @override
  Future<bool> skipOptionalItemRun(String itemRunId) =>
      _dao.skipOptionalItemRun(
        itemRunId: itemRunId,
        skippedAt: DateTime.now(),
      );

  @override
  Future<bool> skipRoutineRun(String routineRunId) => _dao.skipRoutineRun(
    routineRunId: routineRunId,
    skippedAt: DateTime.now(),
  );

  @override
  Future<bool> shiftRemainingRun({
    required String routineRunId,
    required String currentItemRunId,
    required DateTime startAt,
  }) => _dao.shiftRemainingRun(
    routineRunId: routineRunId,
    currentItemRunId: currentItemRunId,
    startAt: startAt,
    updatedAt: DateTime.now(),
  );

  Routine _toRoutine(
    RoutineRecord record, {
    required List<RoutineDayRecord> days,
    required List<RoutineItemRecord> items,
  }) {
    return Routine(
      id: record.id,
      name: record.name,
      description: record.description,
      iconKey: record.iconKey,
      colorKey: record.colorKey,
      customColorArgb: record.customColorArgb,
      validFromDate: record.validFromLocalDate == null
          ? null
          : DateTime.parse(record.validFromLocalDate!),
      validUntilDate: record.validUntilLocalDate == null
          ? null
          : DateTime.parse(record.validUntilLocalDate!),
      status: _routineStatus(record.status),
      pausedUntilDate: record.pausedUntilLocalDate == null
          ? null
          : DateTime.parse(record.pausedUntilLocalDate!),
      archivedAt: record.archivedAt,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      weekdays: days.map((day) => day.weekday).toList(growable: false),
      items: items.map(_toRoutineItem).toList(growable: false),
    );
  }

  RoutineItem _toRoutineItem(RoutineItemRecord record) {
    return RoutineItem(
      id: record.id,
      routineId: record.routineId,
      position: record.position,
      title: record.title,
      scheduledMinute: record.scheduledMinute,
      durationMinutes: record.durationMinutes,
      goalId: record.goalId,
      isOptional: record.isOptional,
      reminderMinutesBefore: record.reminderMinutesBefore,
      pomodoroMode: _pomodoroMode(record.pomodoroMode),
      customFocusMinutes: record.customFocusMinutes,
      customBreakMinutes: record.customBreakMinutes,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }

  RoutineRun _toRun(RoutineRunRecord record) {
    return RoutineRun(
      id: record.id,
      routineId: record.routineId,
      sourceRoutineId: record.sourceRoutineId,
      localDate: DateTime.parse(record.localDate),
      status: _runStatus(record.status),
      nameSnapshot: record.nameSnapshot,
      iconKeySnapshot: record.iconKeySnapshot,
      colorKeySnapshot: record.colorKeySnapshot,
      customColorArgbSnapshot: record.customColorArgbSnapshot,
      scheduledStartMinuteSnapshot: record.scheduledStartMinuteSnapshot,
      startedAt: record.startedAt,
      completedAt: record.completedAt,
      skippedAt: record.skippedAt,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }

  RoutineItemRun _toItemRun(RoutineItemRunRecord record) {
    return RoutineItemRun(
      id: record.id,
      routineRunId: record.routineRunId,
      routineItemId: record.routineItemId,
      sourceItemId: record.sourceItemId,
      taskId: record.taskId,
      taskIdSnapshot: record.taskIdSnapshot,
      positionSnapshot: record.positionSnapshot,
      titleSnapshot: record.titleSnapshot,
      scheduledAtSnapshot: record.scheduledAtSnapshot,
      durationMinutesSnapshot: record.durationMinutesSnapshot,
      goalTitleSnapshot: record.goalTitleSnapshot,
      isOptionalSnapshot: record.isOptionalSnapshot,
      reminderMinutesSnapshot: record.reminderMinutesSnapshot,
      pomodoroModeSnapshot: _pomodoroMode(record.pomodoroModeSnapshot),
      customFocusMinutesSnapshot: record.customFocusMinutesSnapshot,
      customBreakMinutesSnapshot: record.customBreakMinutesSnapshot,
      status: _runStatus(record.status),
      startedAt: record.startedAt,
      completedAt: record.completedAt,
      skippedAt: record.skippedAt,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }

  String _createLocalId(String scope) {
    return '$scope-${DateTime.now().microsecondsSinceEpoch}-${_idSequence++}';
  }

  void _validateRoutine(Routine routine) {
    if (routine.id.trim().isEmpty ||
        routine.name.trim().isEmpty ||
        routine.name.trim().length > 80 ||
        routine.iconKey.trim().isEmpty ||
        routine.colorKey.trim().isEmpty) {
      throw ArgumentError('Routine identity is invalid.');
    }
    _validateCustomColor(routine.customColorArgb);
    if ((routine.validFromDate != null &&
            !_isCanonicalLocalDate(routine.validFromDate!)) ||
        (routine.validUntilDate != null &&
            !_isCanonicalLocalDate(routine.validUntilDate!)) ||
        (routine.validFromDate != null &&
            routine.validUntilDate != null &&
            routine.validFromDate!.isAfter(routine.validUntilDate!))) {
      throw ArgumentError('Routine validity range is invalid.');
    }
    final descriptionLength = routine.description?.trim().length;
    if (descriptionLength != null && descriptionLength > 500) {
      throw ArgumentError('Routine description is too long.');
    }
    final uniqueDays = routine.weekdays.toSet();
    if (uniqueDays.length != routine.weekdays.length ||
        uniqueDays.any(
          (day) => day < DateTime.monday || day > DateTime.sunday,
        )) {
      throw ArgumentError('Routine weekdays are invalid.');
    }
    if (routine.status == RoutineStatus.active &&
        (routine.weekdays.isEmpty || routine.items.isEmpty)) {
      throw ArgumentError('An active routine requires days and items.');
    }
    if (routine.status == RoutineStatus.active &&
        (routine.pausedUntilDate != null || routine.archivedAt != null)) {
      throw ArgumentError('Active routine lifecycle fields are invalid.');
    }
    if (routine.status == RoutineStatus.paused && routine.archivedAt != null) {
      throw ArgumentError('Paused routine cannot be archived.');
    }
    if (routine.status == RoutineStatus.archived &&
        (routine.archivedAt == null || routine.pausedUntilDate != null)) {
      throw ArgumentError('Archived routine lifecycle fields are invalid.');
    }
    for (var index = 0; index < routine.items.length; index++) {
      final item = routine.items[index];
      if (item.routineId != routine.id || item.position != index) {
        throw ArgumentError('Routine item ownership or order is invalid.');
      }
      _validateItem(item);
    }
  }

  void _validateItem(RoutineItem item) {
    if (item.id.trim().isEmpty ||
        item.title.trim().isEmpty ||
        item.title.trim().length > 160 ||
        item.scheduledMinute < 0 ||
        item.scheduledMinute > 1439 ||
        item.durationMinutes < 1 ||
        item.durationMinutes > 1440 ||
        (item.reminderMinutesBefore != null &&
            (item.reminderMinutesBefore! < 0 ||
                item.reminderMinutesBefore! > 10080))) {
      throw ArgumentError('Routine item is invalid.');
    }
    _validatePomodoro(
      item.pomodoroMode,
      item.customFocusMinutes,
      item.customBreakMinutes,
    );
  }

  void _validateRun(RoutineRun run) {
    if (run.id.trim().isEmpty ||
        run.sourceRoutineId.trim().isEmpty ||
        (run.routineId != null && run.routineId != run.sourceRoutineId) ||
        run.nameSnapshot.trim().isEmpty ||
        run.scheduledStartMinuteSnapshot < 0 ||
        run.scheduledStartMinuteSnapshot > 1439) {
      throw ArgumentError('Routine run is invalid.');
    }
    _validateCustomColor(run.customColorArgbSnapshot);
    _validateTerminalState(
      status: run.status,
      completedAt: run.completedAt,
      skippedAt: run.skippedAt,
    );
  }

  void _validateItemRun(RoutineItemRun run) {
    if (run.id.trim().isEmpty ||
        run.routineRunId.trim().isEmpty ||
        run.sourceItemId.trim().isEmpty ||
        (run.routineItemId != null && run.routineItemId != run.sourceItemId) ||
        run.titleSnapshot.trim().isEmpty ||
        run.positionSnapshot < 0 ||
        run.durationMinutesSnapshot < 1 ||
        run.durationMinutesSnapshot > 1440 ||
        (run.taskId != null && run.taskIdSnapshot == null) ||
        (run.reminderMinutesSnapshot != null &&
            (run.reminderMinutesSnapshot! < 0 ||
                run.reminderMinutesSnapshot! > 10080))) {
      throw ArgumentError('Routine item run is invalid.');
    }
    _validatePomodoro(
      run.pomodoroModeSnapshot,
      run.customFocusMinutesSnapshot,
      run.customBreakMinutesSnapshot,
    );
    _validateTerminalState(
      status: run.status,
      completedAt: run.completedAt,
      skippedAt: run.skippedAt,
    );
  }

  void _validatePomodoro(
    RoutinePomodoroMode mode,
    int? focusMinutes,
    int? breakMinutes,
  ) {
    final isValidCustom =
        mode == RoutinePomodoroMode.custom &&
        focusMinutes != null &&
        focusMinutes >= 1 &&
        focusMinutes <= 240 &&
        breakMinutes != null &&
        breakMinutes >= 1 &&
        breakMinutes <= 60;
    final isValidDefault =
        mode != RoutinePomodoroMode.custom &&
        focusMinutes == null &&
        breakMinutes == null;
    if (!isValidCustom && !isValidDefault) {
      throw ArgumentError('Routine Pomodoro preference is invalid.');
    }
  }

  void _validateTerminalState({
    required RoutineRunStatus status,
    required DateTime? completedAt,
    required DateTime? skippedAt,
  }) {
    final valid = switch (status) {
      RoutineRunStatus.completed => completedAt != null && skippedAt == null,
      RoutineRunStatus.skipped => skippedAt != null && completedAt == null,
      _ => completedAt == null && skippedAt == null,
    };
    if (!valid) {
      throw ArgumentError('Routine terminal state is invalid.');
    }
  }

  RoutineStatus _routineStatus(String value) => switch (value) {
    'active' => RoutineStatus.active,
    'paused' => RoutineStatus.paused,
    'archived' => RoutineStatus.archived,
    _ => throw StateError('Unknown routine status: $value'),
  };

  RoutinePomodoroMode _pomodoroMode(String value) => switch (value) {
    'none' => RoutinePomodoroMode.none,
    'recommended' => RoutinePomodoroMode.recommended,
    'custom' => RoutinePomodoroMode.custom,
    _ => throw StateError('Unknown routine Pomodoro mode: $value'),
  };

  RoutineRunStatus _runStatus(String value) => switch (value) {
    'scheduled' => RoutineRunStatus.scheduled,
    'inProgress' => RoutineRunStatus.inProgress,
    'completed' => RoutineRunStatus.completed,
    'skipped' => RoutineRunStatus.skipped,
    'missed' => RoutineRunStatus.missed,
    _ => throw StateError('Unknown routine run status: $value'),
  };

  void _validateCustomColor(int? color) {
    if (color != null && (color < 0xFF000000 || color > 0xFFFFFFFF)) {
      throw ArgumentError('Routine custom color must be opaque ARGB.');
    }
  }

  bool _isCanonicalLocalDate(DateTime date) =>
      date.hour == 0 &&
      date.minute == 0 &&
      date.second == 0 &&
      date.millisecond == 0 &&
      date.microsecond == 0;

  String _dateToStorage(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String? _trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
