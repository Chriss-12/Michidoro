import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'michifocus_database.g.dart';

class GoalRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get targetSessions => integer()();
  IntColumn get completedSessions => integer().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  String get tableName => 'goals';
}

@TableIndex(name: 'tasks_goal_id_idx', columns: {#goalId})
@TableIndex(name: 'tasks_scheduled_date_idx', columns: {#scheduledDate})
@TableIndex(name: 'tasks_created_at_idx', columns: {#createdAt})
class TaskRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('listed'))();
  DateTimeColumn get scheduledDate => dateTime().nullable()();
  TextColumn get goalId => text().nullable().references(
    GoalRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get durationMinutes => integer().nullable()();
  BoolColumn get legacyCompletionUnknown =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  String get tableName => 'tasks';
}

@TableIndex(
  name: 'task_completion_events_completed_at_idx',
  columns: {#completedAt},
)
@TableIndex(
  name: 'task_completion_events_task_completed_idx',
  columns: {#taskId, #completedAt},
)
class TaskCompletionEventRecords extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable().references(
    TaskRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get taskIdSnapshot => text()();
  DateTimeColumn get completedAt => dateTime()();
  DateTimeColumn get scheduledDateSnapshot => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  String get tableName => 'task_completion_events';
}

class ReportingMetadataRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get completionTrackingStartedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  String get tableName => 'reporting_metadata';
}

@TableIndex(name: 'pomodoro_sessions_goal_id_idx', columns: {#goalId})
@TableIndex(name: 'pomodoro_sessions_task_id_idx', columns: {#taskId})
@TableIndex(name: 'pomodoro_sessions_started_at_idx', columns: {#startedAt})
@TableIndex(name: 'pomodoro_sessions_ended_at_idx', columns: {#endedAt})
class PomodoroSessionRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get plannedSeconds => integer()();
  IntColumn get focusedSeconds => integer()();
  TextColumn get goalId => text().nullable().references(
    GoalRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get taskId => text().nullable().references(
    TaskRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get startMoodScore => integer().nullable()();
  IntColumn get endMoodScore => integer().nullable()();
  BoolColumn get moodPromptPending =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get wasDistracted => boolean().nullable()();
  IntColumn get distractionMinutes => integer().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  String get tableName => 'pomodoro_sessions';
}

class PomodoroRuntimeRecords extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable().references(
    TaskRecords,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get taskTitle => text().nullable()();
  TextColumn get goalId => text().nullable().references(
    GoalRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get taskEstimatedMinutes => integer().nullable()();
  TextColumn get phase => text()();
  BoolColumn get isRunning => boolean()();
  IntColumn get remainingSeconds => integer()();
  IntColumn get phaseTotalSeconds => integer()();
  IntColumn get cadenceFocusMinutes => integer()();
  IntColumn get cadenceBreakMinutes => integer()();
  IntColumn get longBreakMinutes => integer()();
  IntColumn get longBreakFrequency => integer()();
  BoolColumn get autoStartBreak => boolean()();
  BoolColumn get autoStartFocus => boolean()();
  TextColumn get planMode => text()();
  IntColumn get blockIndex => integer()();
  IntColumn get blockCount => integer()();
  IntColumn get taskFocusedSecondsAtStart => integer()();
  DateTimeColumn get focusStartedAt => dateTime().nullable()();
  DateTimeColumn get lastTickAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  String get tableName => 'pomodoro_runtime';
}

@TableIndex(name: 'routines_status_idx', columns: {#status})
@TableIndex(name: 'routines_updated_at_idx', columns: {#updatedAt})
class RoutineRecords extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get iconKey => text().withDefault(const Constant('routine'))();
  TextColumn get colorKey => text().withDefault(const Constant('primary'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get pausedUntilLocalDate => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    '''CHECK (status IN ('active', 'paused', 'archived'))''',
    'CHECK (length(trim(name)) BETWEEN 1 AND 80)',
    'CHECK (description IS NULL OR length(trim(description)) <= 500)',
    '''CHECK (paused_until_local_date IS NULL OR paused_until_local_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')''',
    '''CHECK ((status = 'active' AND paused_until_local_date IS NULL AND archived_at IS NULL) OR (status = 'paused' AND archived_at IS NULL) OR (status = 'archived' AND paused_until_local_date IS NULL AND archived_at IS NOT NULL))''',
  ];
  @override
  String get tableName => 'routines';
}

@TableIndex(
  name: 'routine_days_weekday_routine_idx',
  columns: {#weekday, #routineId},
)
class RoutineDayRecords extends Table {
  TextColumn get routineId => text().references(
    RoutineRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get weekday => integer()();
  @override
  Set<Column<Object>> get primaryKey => {routineId, weekday};
  @override
  List<String> get customConstraints => [
    'CHECK (weekday BETWEEN 1 AND 7)',
  ];
  @override
  String get tableName => 'routine_days';
}

@TableIndex(
  name: 'routine_items_routine_position_uq',
  columns: {#routineId, #position},
  unique: true,
)
@TableIndex(
  name: 'routine_items_routine_time_idx',
  columns: {#routineId, #scheduledMinute},
)
@TableIndex(name: 'routine_items_goal_id_idx', columns: {#goalId})
class RoutineItemRecords extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text().references(
    RoutineRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get position => integer()();
  TextColumn get title => text()();
  IntColumn get scheduledMinute => integer()();
  IntColumn get durationMinutes => integer()();
  TextColumn get goalId => text().nullable().references(
    GoalRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  BoolColumn get isOptional => boolean().withDefault(const Constant(false))();
  IntColumn get reminderMinutesBefore => integer().nullable()();
  TextColumn get pomodoroMode => text().withDefault(const Constant('none'))();
  IntColumn get customFocusMinutes => integer().nullable()();
  IntColumn get customBreakMinutes => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (position >= 0)',
    'CHECK (length(trim(title)) BETWEEN 1 AND 160)',
    'CHECK (scheduled_minute BETWEEN 0 AND 1439)',
    'CHECK (duration_minutes BETWEEN 1 AND 1440)',
    'CHECK (reminder_minutes_before IS NULL OR reminder_minutes_before BETWEEN 0 AND 10080)',
    '''CHECK (pomodoro_mode IN ('none', 'recommended', 'custom'))''',
    '''CHECK ((pomodoro_mode = 'custom' AND custom_focus_minutes BETWEEN 1 AND 240 AND custom_break_minutes BETWEEN 1 AND 60) OR (pomodoro_mode IN ('none', 'recommended') AND custom_focus_minutes IS NULL AND custom_break_minutes IS NULL))''',
  ];
  @override
  String get tableName => 'routine_items';
}

@TableIndex(
  name: 'routine_runs_occurrence_uq',
  columns: {#sourceRoutineId, #localDate},
  unique: true,
)
@TableIndex(
  name: 'routine_runs_date_status_idx',
  columns: {#localDate, #status},
)
@TableIndex(
  name: 'routine_runs_routine_date_idx',
  columns: {#routineId, #localDate},
)
class RoutineRunRecords extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text().nullable().references(
    RoutineRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get sourceRoutineId => text()();
  TextColumn get localDate => text()();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  TextColumn get nameSnapshot => text()();
  TextColumn get iconKeySnapshot => text()();
  TextColumn get colorKeySnapshot => text()();
  IntColumn get scheduledStartMinuteSnapshot => integer()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get skippedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (routine_id IS NULL OR routine_id = source_routine_id)',
    '''CHECK (local_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')''',
    '''CHECK (status IN ('scheduled', 'inProgress', 'completed', 'skipped', 'missed'))''',
    'CHECK (scheduled_start_minute_snapshot BETWEEN 0 AND 1439)',
    '''CHECK ((status = 'completed' AND completed_at IS NOT NULL AND skipped_at IS NULL) OR (status = 'skipped' AND skipped_at IS NOT NULL AND completed_at IS NULL) OR (status NOT IN ('completed', 'skipped') AND completed_at IS NULL AND skipped_at IS NULL))''',
  ];
  @override
  String get tableName => 'routine_runs';
}

@TableIndex(
  name: 'routine_item_runs_materialization_uq',
  columns: {#routineRunId, #sourceItemId},
  unique: true,
)
@TableIndex(
  name: 'routine_item_runs_task_id_uq',
  columns: {#taskId},
  unique: true,
)
@TableIndex(
  name: 'routine_item_runs_routine_item_id_idx',
  columns: {#routineItemId},
)
@TableIndex(
  name: 'routine_item_runs_schedule_status_idx',
  columns: {#scheduledAtSnapshot, #status},
)
@TableIndex(
  name: 'routine_item_runs_run_position_idx',
  columns: {#routineRunId, #positionSnapshot},
)
class RoutineItemRunRecords extends Table {
  TextColumn get id => text()();
  TextColumn get routineRunId => text().references(
    RoutineRunRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get routineItemId => text().nullable().references(
    RoutineItemRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get sourceItemId => text()();
  TextColumn get taskId => text().nullable().references(
    TaskRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get taskIdSnapshot => text().nullable()();
  IntColumn get positionSnapshot => integer()();
  TextColumn get titleSnapshot => text()();
  DateTimeColumn get scheduledAtSnapshot => dateTime()();
  IntColumn get durationMinutesSnapshot => integer()();
  TextColumn get goalTitleSnapshot => text().nullable()();
  BoolColumn get isOptionalSnapshot =>
      boolean().withDefault(const Constant(false))();
  IntColumn get reminderMinutesSnapshot => integer().nullable()();
  TextColumn get pomodoroModeSnapshot => text()();
  IntColumn get customFocusMinutesSnapshot => integer().nullable()();
  IntColumn get customBreakMinutesSnapshot => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get skippedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (routine_item_id IS NULL OR routine_item_id = source_item_id)',
    'CHECK (position_snapshot >= 0)',
    'CHECK (length(trim(title_snapshot)) BETWEEN 1 AND 160)',
    'CHECK (duration_minutes_snapshot BETWEEN 1 AND 1440)',
    'CHECK (reminder_minutes_snapshot IS NULL OR reminder_minutes_snapshot BETWEEN 0 AND 10080)',
    '''CHECK (pomodoro_mode_snapshot IN ('none', 'recommended', 'custom'))''',
    '''CHECK ((pomodoro_mode_snapshot = 'custom' AND custom_focus_minutes_snapshot BETWEEN 1 AND 240 AND custom_break_minutes_snapshot BETWEEN 1 AND 60) OR (pomodoro_mode_snapshot IN ('none', 'recommended') AND custom_focus_minutes_snapshot IS NULL AND custom_break_minutes_snapshot IS NULL))''',
    '''CHECK (status IN ('scheduled', 'inProgress', 'completed', 'skipped', 'missed'))''',
    'CHECK (task_id IS NULL OR task_id_snapshot IS NOT NULL)',
    '''CHECK ((status = 'completed' AND completed_at IS NOT NULL AND skipped_at IS NULL) OR (status = 'skipped' AND skipped_at IS NOT NULL AND completed_at IS NULL) OR (status NOT IN ('completed', 'skipped') AND completed_at IS NULL AND skipped_at IS NULL))''',
  ];
  @override
  String get tableName => 'routine_item_runs';
}

@TableIndex(name: 'calendar_events_scheduled_at_idx', columns: {#scheduledAt})
class CalendarEventRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get durationMinutes => integer()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  String get tableName => 'calendar_events';
}

@DriftAccessor(tables: [GoalRecords])
class GoalsDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$GoalsDaoMixin {
  GoalsDao(super.db);
  Future<List<GoalRecord>> getAllGoals() => (select(
    goalRecords,
  )..orderBy([(row) => OrderingTerm.desc(row.createdAt)])).get();
  Future<GoalRecord?> findById(String id) => (select(
    goalRecords,
  )..where((row) => row.id.equals(id))).getSingleOrNull();
  Future<GoalRecord> insertGoal(GoalRecordsCompanion companion) async {
    await into(goalRecords).insert(companion);
    return (await findById(companion.id.value))!;
  }

  Future<GoalRecord?> updateProgress({
    required String id,
    required int completedSessions,
    required DateTime updatedAt,
  }) async {
    await (update(goalRecords)..where((row) => row.id.equals(id))).write(
      GoalRecordsCompanion(
        completedSessions: Value(completedSessions),
        updatedAt: Value(updatedAt),
      ),
    );
    return findById(id);
  }

  Future<GoalRecord?> updateDetails({
    required String id,
    required String title,
    required int targetSessions,
    required DateTime? targetDate,
    required DateTime updatedAt,
  }) async {
    await (update(goalRecords)..where((row) => row.id.equals(id))).write(
      GoalRecordsCompanion(
        title: Value(title),
        targetSessions: Value(targetSessions),
        targetDate: Value(targetDate),
        updatedAt: Value(updatedAt),
      ),
    );
    return findById(id);
  }

  Future<void> deleteById(String id) =>
      (delete(goalRecords)..where((row) => row.id.equals(id))).go();
}

@DriftAccessor(tables: [TaskRecords, TaskCompletionEventRecords])
class TasksDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$TasksDaoMixin {
  TasksDao(super.db);
  Future<List<TaskRecord>> getAllTasks() => (select(
    taskRecords,
  )..orderBy([(row) => OrderingTerm.desc(row.createdAt)])).get();
  Future<TaskRecord?> findById(String id) => (select(
    taskRecords,
  )..where((row) => row.id.equals(id))).getSingleOrNull();
  Future<TaskRecord> insertTask(TaskRecordsCompanion companion) async {
    await into(taskRecords).insert(companion);
    return (await findById(companion.id.value))!;
  }

  Future<TaskRecord?> updateTitle({
    required String id,
    required String title,
    required DateTime updatedAt,
  }) => transaction(() async {
    await (update(taskRecords)..where((row) => row.id.equals(id))).write(
      TaskRecordsCompanion(title: Value(title), updatedAt: Value(updatedAt)),
    );
    await _synchronizeRoutineItemRunTitle(
      taskId: id,
      title: title,
      updatedAt: updatedAt,
    );
    return findById(id);
  });
  Future<TaskRecord?> updateCompletion({
    required String id,
    required bool isCompleted,
    required String status,
    required DateTime updatedAt,
  }) => _updateStatusWithCompletionEvent(
    id: id,
    status: status,
    isCompleted: isCompleted,
    updatedAt: updatedAt,
  );
  Future<TaskRecord?> updateStatus({
    required String id,
    required String status,
    required bool isCompleted,
    required DateTime updatedAt,
  }) => _updateStatusWithCompletionEvent(
    id: id,
    status: status,
    isCompleted: isCompleted,
    updatedAt: updatedAt,
  );
  Future<TaskRecord?> updateSchedule({
    required String id,
    required DateTime? scheduledDate,
    required DateTime updatedAt,
  }) => _update(
    id,
    TaskRecordsCompanion(
      scheduledDate: Value(scheduledDate),
      updatedAt: Value(updatedAt),
    ),
  );
  Future<TaskRecord?> updateGoal({
    required String id,
    required String? goalId,
    required DateTime updatedAt,
  }) => _update(
    id,
    TaskRecordsCompanion(goalId: Value(goalId), updatedAt: Value(updatedAt)),
  );
  Future<TaskRecord?> updatePlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
    required DateTime updatedAt,
  }) => _update(
    id,
    TaskRecordsCompanion(
      goalId: Value(goalId),
      durationMinutes: Value(durationMinutes),
      updatedAt: Value(updatedAt),
    ),
  );
  Future<TaskRecord?> _update(String id, TaskRecordsCompanion companion) async {
    await (update(
      taskRecords,
    )..where((row) => row.id.equals(id))).write(companion);
    return findById(id);
  }

  Future<TaskRecord?> _updateStatusWithCompletionEvent({
    required String id,
    required String status,
    required bool isCompleted,
    required DateTime updatedAt,
  }) {
    return transaction(() async {
      final current = await findById(id);
      if (current == null) {
        return null;
      }

      final becameCompleted = !current.isCompleted && isCompleted;
      await (update(taskRecords)..where((row) => row.id.equals(id))).write(
        TaskRecordsCompanion(
          status: Value(status),
          isCompleted: Value(isCompleted),
          updatedAt: Value(updatedAt),
        ),
      );

      if (becameCompleted) {
        final sameTimestampEvents =
            await (select(taskCompletionEventRecords)..where(
                  (row) =>
                      row.taskIdSnapshot.equals(id) &
                      row.completedAt.equals(updatedAt),
                ))
                .get();
        await into(taskCompletionEventRecords).insert(
          TaskCompletionEventRecordsCompanion.insert(
            id:
                '$id-${updatedAt.microsecondsSinceEpoch}-'
                '${sameTimestampEvents.length}',
            taskId: Value(id),
            taskIdSnapshot: id,
            completedAt: updatedAt,
            scheduledDateSnapshot: Value(current.scheduledDate),
          ),
        );
      }

      await _synchronizeRoutineItemRun(
        taskId: id,
        taskStatus: status,
        updatedAt: updatedAt,
      );

      return findById(id);
    });
  }

  Future<void> _synchronizeRoutineItemRun({
    required String taskId,
    required String taskStatus,
    required DateTime updatedAt,
  }) async {
    final itemRun = await (attachedDatabase.select(
      attachedDatabase.routineItemRunRecords,
    )..where((row) => row.taskId.equals(taskId))).getSingleOrNull();
    if (itemRun == null ||
        itemRun.status == 'missed' ||
        itemRun.status == 'skipped') {
      return;
    }

    final itemStatus = switch (taskStatus) {
      'completed' => 'completed',
      'in_progress' => 'inProgress',
      _ => 'scheduled',
    };
    final startedAt = switch (itemStatus) {
      'scheduled' => null,
      _ => itemRun.startedAt ?? updatedAt,
    };
    final completedAt = itemStatus == 'completed' ? updatedAt : null;
    await (attachedDatabase.update(
      attachedDatabase.routineItemRunRecords,
    )..where((row) => row.id.equals(itemRun.id))).write(
      RoutineItemRunRecordsCompanion(
        status: Value(itemStatus),
        startedAt: Value(startedAt),
        completedAt: Value(completedAt),
        updatedAt: Value(updatedAt),
      ),
    );

    final itemRuns = await (attachedDatabase.select(
      attachedDatabase.routineItemRunRecords,
    )..where((row) => row.routineRunId.equals(itemRun.routineRunId))).get();
    final requiredCompleted = itemRuns
        .where((item) => !item.isOptionalSnapshot)
        .every((item) => item.status == 'completed');
    final hasStartedItem = itemRuns.any(
      (item) => item.status == 'inProgress' || item.status == 'completed',
    );
    final runStatus = requiredCompleted
        ? 'completed'
        : hasStartedItem
        ? 'inProgress'
        : 'scheduled';
    final routineRun = await (attachedDatabase.select(
      attachedDatabase.routineRunRecords,
    )..where((row) => row.id.equals(itemRun.routineRunId))).getSingle();
    await (attachedDatabase.update(
      attachedDatabase.routineRunRecords,
    )..where((row) => row.id.equals(itemRun.routineRunId))).write(
      RoutineRunRecordsCompanion(
        status: Value(runStatus),
        startedAt: Value(
          hasStartedItem ? routineRun.startedAt ?? updatedAt : null,
        ),
        completedAt: Value(
          runStatus == 'completed' ? updatedAt : null,
        ),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<void> _synchronizeRoutineItemRunTitle({
    required String taskId,
    required String title,
    required DateTime updatedAt,
  }) async {
    await (attachedDatabase.update(
      attachedDatabase.routineItemRunRecords,
    )..where((row) => row.taskId.equals(taskId))).write(
      RoutineItemRunRecordsCompanion(
        titleSnapshot: Value(title),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<void> deleteById(String id) =>
      (delete(taskRecords)..where((row) => row.id.equals(id))).go();
}

@DriftAccessor(tables: [PomodoroSessionRecords])
class PomodoroSessionsDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$PomodoroSessionsDaoMixin {
  PomodoroSessionsDao(super.db);
  Future<List<PomodoroSessionRecord>> getAllSessions() => (select(
    pomodoroSessionRecords,
  )..orderBy([(row) => OrderingTerm.desc(row.startedAt)])).get();
  Future<PomodoroSessionRecord?> findById(String id) => (select(
    pomodoroSessionRecords,
  )..where((row) => row.id.equals(id))).getSingleOrNull();
  Future<PomodoroSessionRecord> insertSession(
    PomodoroSessionRecordsCompanion companion,
  ) async {
    await into(
      pomodoroSessionRecords,
    ).insert(companion, mode: InsertMode.insertOrIgnore);
    return (await findById(companion.id.value))!;
  }

  Future<PomodoroSessionRecord> updateReflection({
    required String id,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) async {
    await (update(
      pomodoroSessionRecords,
    )..where((row) => row.id.equals(id))).write(
      PomodoroSessionRecordsCompanion(
        endMoodScore: Value(endMoodScore),
        moodPromptPending: const Value(false),
        wasDistracted: Value(wasDistracted),
        distractionMinutes: Value(distractionMinutes),
      ),
    );
    return (await findById(id))!;
  }
}

@DriftAccessor(tables: [PomodoroRuntimeRecords])
class PomodoroRuntimeDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$PomodoroRuntimeDaoMixin {
  PomodoroRuntimeDao(super.db);

  Future<PomodoroRuntimeRecord?> loadActive() =>
      select(pomodoroRuntimeRecords).getSingleOrNull();

  Future<void> saveActive(PomodoroRuntimeRecordsCompanion companion) async {
    await into(
      pomodoroRuntimeRecords,
    ).insertOnConflictUpdate(companion);
  }

  Future<void> clearActive() => delete(pomodoroRuntimeRecords).go();
}

@DriftAccessor(
  tables: [
    RoutineRecords,
    RoutineDayRecords,
    RoutineItemRecords,
    RoutineRunRecords,
    RoutineItemRunRecords,
    PomodoroRuntimeRecords,
  ],
)
class RoutinesDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$RoutinesDaoMixin {
  RoutinesDao(super.db);

  Future<({int createdRuns, int createdTasks, int missedRuns})>
  reconcileLocalDay({
    required DateTime localDay,
    required DateTime reconciledAt,
    required String Function(String scope) createId,
  }) {
    final day = DateTime(localDay.year, localDay.month, localDay.day);
    final localDate = _dateToStorage(day);
    return transaction(() async {
      var missedRuns = await _markElapsedRunsMissed(
        beforeLocalDate: localDate,
        reconciledAt: reconciledAt,
      );
      final activeRoutines = await (select(
        routineRecords,
      )..where((row) => row.status.equals('active'))).get();
      final allDays = await getAllRoutineDays();
      final allItems = await getAllRoutineItems();
      final goalRows = await attachedDatabase
          .select(
            attachedDatabase.goalRecords,
          )
          .get();
      final goalsById = {for (final goal in goalRows) goal.id: goal.title};
      final daysByRoutine = <String, Set<int>>{};
      for (final routineDay in allDays) {
        (daysByRoutine[routineDay.routineId] ??= <int>{}).add(
          routineDay.weekday,
        );
      }
      final itemsByRoutine = <String, List<RoutineItemRecord>>{};
      for (final item in allItems) {
        (itemsByRoutine[item.routineId] ??= <RoutineItemRecord>[]).add(item);
      }

      missedRuns += await _materializeMissingElapsedOccurrences(
        currentDay: day,
        activeRoutines: activeRoutines,
        daysByRoutine: daysByRoutine,
        itemsByRoutine: itemsByRoutine,
        goalsById: goalsById,
        reconciledAt: reconciledAt,
        createId: createId,
      );

      var createdRuns = 0;
      var createdTasks = 0;
      for (final routine in activeRoutines) {
        if (!(daysByRoutine[routine.id]?.contains(day.weekday) ?? false)) {
          continue;
        }
        final items = itemsByRoutine[routine.id] ?? const <RoutineItemRecord>[];
        if (items.isEmpty) continue;

        final existing = await findRun(
          sourceRoutineId: routine.id,
          localDate: localDate,
        );
        if (existing != null) continue;

        final runId = createId('routine-run');
        final firstMinute = items
            .map((item) => item.scheduledMinute)
            .reduce((first, next) => first < next ? first : next);
        await into(routineRunRecords).insert(
          RoutineRunRecordsCompanion.insert(
            id: runId,
            routineId: Value(routine.id),
            sourceRoutineId: routine.id,
            localDate: localDate,
            nameSnapshot: routine.name,
            iconKeySnapshot: routine.iconKey,
            colorKeySnapshot: routine.colorKey,
            scheduledStartMinuteSnapshot: firstMinute,
            createdAt: reconciledAt,
            updatedAt: reconciledAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
        final committedRun = await findRun(
          sourceRoutineId: routine.id,
          localDate: localDate,
        );
        if (committedRun == null) {
          throw StateError('Routine run could not be materialized.');
        }
        if (committedRun.id != runId) continue;
        createdRuns += 1;

        for (final item in items) {
          final taskId = createId('routine-task');
          final scheduledAt = DateTime(
            day.year,
            day.month,
            day.day,
            item.scheduledMinute ~/ 60,
            item.scheduledMinute % 60,
          );
          await attachedDatabase
              .into(attachedDatabase.taskRecords)
              .insert(
                TaskRecordsCompanion.insert(
                  id: taskId,
                  title: item.title,
                  scheduledDate: Value(scheduledAt),
                  goalId: Value(item.goalId),
                  durationMinutes: Value(item.durationMinutes),
                  createdAt: reconciledAt,
                  updatedAt: reconciledAt,
                ),
              );
          await into(routineItemRunRecords).insert(
            RoutineItemRunRecordsCompanion.insert(
              id: createId('routine-item-run'),
              routineRunId: committedRun.id,
              routineItemId: Value(item.id),
              sourceItemId: item.id,
              taskId: Value(taskId),
              taskIdSnapshot: Value(taskId),
              positionSnapshot: item.position,
              titleSnapshot: item.title,
              scheduledAtSnapshot: scheduledAt,
              durationMinutesSnapshot: item.durationMinutes,
              goalTitleSnapshot: Value(
                item.goalId == null ? null : goalsById[item.goalId],
              ),
              isOptionalSnapshot: Value(item.isOptional),
              reminderMinutesSnapshot: Value(item.reminderMinutesBefore),
              pomodoroModeSnapshot: item.pomodoroMode,
              customFocusMinutesSnapshot: Value(item.customFocusMinutes),
              customBreakMinutesSnapshot: Value(item.customBreakMinutes),
              createdAt: reconciledAt,
              updatedAt: reconciledAt,
            ),
          );
          createdTasks += 1;
        }
      }
      return (
        createdRuns: createdRuns,
        createdTasks: createdTasks,
        missedRuns: missedRuns,
      );
    });
  }

  Future<int> _materializeMissingElapsedOccurrences({
    required DateTime currentDay,
    required List<RoutineRecord> activeRoutines,
    required Map<String, Set<int>> daysByRoutine,
    required Map<String, List<RoutineItemRecord>> itemsByRoutine,
    required Map<String, String> goalsById,
    required DateTime reconciledAt,
    required String Function(String scope) createId,
  }) async {
    var createdMissedRuns = 0;
    final elapsedEnd = DateTime(
      currentDay.year,
      currentDay.month,
      currentDay.day - 1,
    );

    for (final routine in activeRoutines) {
      final weekdays = daysByRoutine[routine.id] ?? const <int>{};
      final items = itemsByRoutine[routine.id] ?? const <RoutineItemRecord>[];
      if (weekdays.isEmpty || items.isEmpty) continue;

      final activeStart = _dateOnly(routine.updatedAt);
      if (activeStart.isAfter(elapsedEnd)) continue;
      final startLocalDate = _dateToStorage(activeStart);
      final endLocalDate = _dateToStorage(elapsedEnd);
      final existingRuns =
          await (select(routineRunRecords)..where(
                (row) =>
                    row.sourceRoutineId.equals(routine.id) &
                    row.localDate.isBiggerOrEqualValue(startLocalDate) &
                    row.localDate.isSmallerOrEqualValue(endLocalDate),
              ))
              .get();
      final existingDates = existingRuns.map((run) => run.localDate).toSet();

      for (
        var occurrenceDay = activeStart;
        !occurrenceDay.isAfter(elapsedEnd);
        occurrenceDay = DateTime(
          occurrenceDay.year,
          occurrenceDay.month,
          occurrenceDay.day + 1,
        )
      ) {
        final occurrenceDate = _dateToStorage(occurrenceDay);
        if (!weekdays.contains(occurrenceDay.weekday) ||
            existingDates.contains(occurrenceDate)) {
          continue;
        }

        final runId = createId('routine-run');
        final firstMinute = items
            .map((item) => item.scheduledMinute)
            .reduce((first, next) => first < next ? first : next);
        await into(routineRunRecords).insert(
          RoutineRunRecordsCompanion.insert(
            id: runId,
            routineId: Value(routine.id),
            sourceRoutineId: routine.id,
            localDate: occurrenceDate,
            status: const Value('missed'),
            nameSnapshot: routine.name,
            iconKeySnapshot: routine.iconKey,
            colorKeySnapshot: routine.colorKey,
            scheduledStartMinuteSnapshot: firstMinute,
            createdAt: reconciledAt,
            updatedAt: reconciledAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
        final committedRun = await findRun(
          sourceRoutineId: routine.id,
          localDate: occurrenceDate,
        );
        if (committedRun == null) {
          throw StateError('Missed routine run could not be recorded.');
        }
        existingDates.add(occurrenceDate);
        if (committedRun.id != runId) continue;

        for (final item in items) {
          final scheduledAt = DateTime(
            occurrenceDay.year,
            occurrenceDay.month,
            occurrenceDay.day,
            item.scheduledMinute ~/ 60,
            item.scheduledMinute % 60,
          );
          await into(routineItemRunRecords).insert(
            RoutineItemRunRecordsCompanion.insert(
              id: createId('routine-item-run'),
              routineRunId: committedRun.id,
              routineItemId: Value(item.id),
              sourceItemId: item.id,
              positionSnapshot: item.position,
              titleSnapshot: item.title,
              scheduledAtSnapshot: scheduledAt,
              durationMinutesSnapshot: item.durationMinutes,
              goalTitleSnapshot: Value(
                item.goalId == null ? null : goalsById[item.goalId],
              ),
              isOptionalSnapshot: Value(item.isOptional),
              reminderMinutesSnapshot: Value(item.reminderMinutesBefore),
              pomodoroModeSnapshot: item.pomodoroMode,
              customFocusMinutesSnapshot: Value(item.customFocusMinutes),
              customBreakMinutesSnapshot: Value(item.customBreakMinutes),
              status: const Value('missed'),
              createdAt: reconciledAt,
              updatedAt: reconciledAt,
            ),
          );
        }
        createdMissedRuns += 1;
      }
    }
    return createdMissedRuns;
  }

  Future<int> _markElapsedRunsMissed({
    required String beforeLocalDate,
    required DateTime reconciledAt,
  }) async {
    final elapsedRuns =
        await (select(routineRunRecords)..where(
              (row) =>
                  row.localDate.isSmallerThanValue(beforeLocalDate) &
                  row.status.isIn(const ['scheduled', 'inProgress']),
            ))
            .get();
    var missedRuns = 0;
    for (final run in elapsedRuns) {
      final itemRuns = await getItemRuns(run.id);
      final hasRequiredUnfinished = itemRuns.any(
        (item) => !item.isOptionalSnapshot && item.status != 'completed',
      );
      if (!hasRequiredUnfinished) continue;
      for (final itemRun in itemRuns) {
        if (itemRun.status == 'completed' || itemRun.status == 'skipped') {
          continue;
        }
        await (update(
          routineItemRunRecords,
        )..where((row) => row.id.equals(itemRun.id))).write(
          RoutineItemRunRecordsCompanion(
            status: const Value('missed'),
            updatedAt: Value(reconciledAt),
          ),
        );
      }
      await (update(
        routineRunRecords,
      )..where((row) => row.id.equals(run.id))).write(
        RoutineRunRecordsCompanion(
          status: const Value('missed'),
          updatedAt: Value(reconciledAt),
        ),
      );
      missedRuns += 1;
    }
    return missedRuns;
  }

  Future<bool> isGeneratedTask(String taskId) async {
    final itemRun =
        await (select(routineItemRunRecords)
              ..where((row) => row.taskId.equals(taskId))
              ..limit(1))
            .getSingleOrNull();
    return itemRun != null;
  }

  Future<bool> updateFutureTemplateTitleForTask({
    required String taskId,
    required String title,
    required DateTime updatedAt,
  }) {
    return transaction(() async {
      final itemRun =
          await (select(routineItemRunRecords)
                ..where((row) => row.taskId.equals(taskId))
                ..limit(1))
              .getSingleOrNull();
      if (itemRun == null ||
          itemRun.routineItemId == null ||
          itemRun.status == 'completed' ||
          itemRun.status == 'skipped' ||
          itemRun.status == 'missed') {
        return false;
      }
      final updated =
          await (update(
            routineItemRecords,
          )..where((row) => row.id.equals(itemRun.routineItemId!))).write(
            RoutineItemRecordsCompanion(
              title: Value(title),
              updatedAt: Value(updatedAt),
            ),
          );
      return updated == 1;
    });
  }

  String _dateToStorage(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<List<RoutineRecord>> getAllRoutines() =>
      (select(routineRecords)..orderBy([
            (row) => OrderingTerm.desc(row.updatedAt),
            (row) => OrderingTerm.asc(row.name),
          ]))
          .get();

  Future<RoutineRecord?> findRoutineById(String id) => (select(
    routineRecords,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<List<RoutineDayRecord>> getDaysForRoutine(String routineId) =>
      (select(routineDayRecords)
            ..where((row) => row.routineId.equals(routineId))
            ..orderBy([(row) => OrderingTerm.asc(row.weekday)]))
          .get();

  Future<List<RoutineDayRecord>> getAllRoutineDays() =>
      (select(routineDayRecords)..orderBy([
            (row) => OrderingTerm.asc(row.routineId),
            (row) => OrderingTerm.asc(row.weekday),
          ]))
          .get();

  Future<List<RoutineItemRecord>> getItemsForRoutine(String routineId) =>
      (select(routineItemRecords)
            ..where((row) => row.routineId.equals(routineId))
            ..orderBy([(row) => OrderingTerm.asc(row.position)]))
          .get();

  Future<List<RoutineItemRecord>> getAllRoutineItems() =>
      (select(routineItemRecords)..orderBy([
            (row) => OrderingTerm.asc(row.routineId),
            (row) => OrderingTerm.asc(row.position),
          ]))
          .get();

  Future<void> saveRoutineAggregate({
    required RoutineRecordsCompanion routine,
    required List<RoutineDayRecordsCompanion> days,
    required List<RoutineItemRecordsCompanion> items,
  }) {
    return transaction(() async {
      final routineId = routine.id.value;
      await into(routineRecords).insertOnConflictUpdate(routine);

      await (delete(
        routineDayRecords,
      )..where((row) => row.routineId.equals(routineId))).go();
      if (days.isNotEmpty) {
        await batch((batch) => batch.insertAll(routineDayRecords, days));
      }

      final existingItems = await getItemsForRoutine(routineId);
      final incomingIds = items.map((item) => item.id.value).toSet();
      for (final item in existingItems) {
        if (!incomingIds.contains(item.id)) {
          await (delete(
            routineItemRecords,
          )..where((row) => row.id.equals(item.id))).go();
        }
      }

      final retainedItems = existingItems
          .where((item) => incomingIds.contains(item.id))
          .toList(growable: false);
      for (var index = 0; index < retainedItems.length; index++) {
        await (update(routineItemRecords)..where(
              (row) => row.id.equals(retainedItems[index].id),
            ))
            .write(
              RoutineItemRecordsCompanion(
                position: Value(1000000 + index),
              ),
            );
      }

      for (final item in items) {
        final existing = await (select(
          routineItemRecords,
        )..where((row) => row.id.equals(item.id.value))).getSingleOrNull();
        if (existing != null && existing.routineId != routineId) {
          throw StateError('Routine item belongs to another routine.');
        }
        await into(routineItemRecords).insertOnConflictUpdate(item);
      }
    });
  }

  Future<void> pauseRoutine({
    required String id,
    required String? untilLocalDate,
    required DateTime updatedAt,
  }) {
    return transaction(() async {
      final routine = await _requireRoutine(id);
      if (routine.status == 'archived') {
        throw StateError('An archived routine cannot be paused.');
      }
      await (update(routineRecords)..where((row) => row.id.equals(id))).write(
        RoutineRecordsCompanion(
          status: const Value('paused'),
          pausedUntilLocalDate: Value(untilLocalDate),
          archivedAt: const Value(null),
          updatedAt: Value(updatedAt),
        ),
      );
    });
  }

  Future<void> resumeRoutine({
    required String id,
    required DateTime updatedAt,
  }) {
    return transaction(() async {
      final routine = await _requireRoutine(id);
      if (routine.status != 'paused') {
        throw StateError('Only paused routines can be resumed.');
      }
      await _requireSchedulableRoutine(id);
      await (update(routineRecords)..where((row) => row.id.equals(id))).write(
        RoutineRecordsCompanion(
          status: const Value('active'),
          pausedUntilLocalDate: const Value(null),
          archivedAt: const Value(null),
          updatedAt: Value(updatedAt),
        ),
      );
    });
  }

  Future<void> archiveRoutine({
    required String id,
    required DateTime archivedAt,
  }) {
    return transaction(() async {
      final routine = await _requireRoutine(id);
      if (routine.status == 'archived') {
        throw StateError('Routine is already archived.');
      }
      await (update(routineRecords)..where((row) => row.id.equals(id))).write(
        RoutineRecordsCompanion(
          status: const Value('archived'),
          pausedUntilLocalDate: const Value(null),
          archivedAt: Value(archivedAt),
          updatedAt: Value(archivedAt),
        ),
      );
    });
  }

  Future<void> restoreRoutine({
    required String id,
    required DateTime updatedAt,
  }) {
    return transaction(() async {
      final routine = await _requireRoutine(id);
      if (routine.status != 'archived') {
        throw StateError('Only archived routines can be restored.');
      }
      await _requireSchedulableRoutine(id);
      await (update(routineRecords)..where((row) => row.id.equals(id))).write(
        RoutineRecordsCompanion(
          status: const Value('active'),
          pausedUntilLocalDate: const Value(null),
          archivedAt: const Value(null),
          updatedAt: Value(updatedAt),
        ),
      );
    });
  }

  Future<RoutineRecord> _requireRoutine(String id) async {
    final routine = await findRoutineById(id);
    if (routine == null) {
      throw StateError('Routine does not exist.');
    }
    return routine;
  }

  Future<void> _requireSchedulableRoutine(String id) async {
    final day =
        await (select(routineDayRecords)
              ..where((row) => row.routineId.equals(id))
              ..limit(1))
            .getSingleOrNull();
    final item =
        await (select(routineItemRecords)
              ..where((row) => row.routineId.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (day == null || item == null) {
      throw StateError('An active routine requires days and items.');
    }
  }

  Future<void> deleteArchivedRoutine(String id) {
    return transaction(() async {
      final routine = await findRoutineById(id);
      if (routine == null) {
        return;
      }
      if (routine.status != 'archived') {
        throw StateError('Only archived routines can be hard deleted.');
      }

      final activeRun =
          await (select(routineRunRecords)
                ..where(
                  (row) =>
                      row.sourceRoutineId.equals(id) &
                      row.status.isIn(const ['scheduled', 'inProgress']),
                )
                ..limit(1))
              .getSingleOrNull();
      if (activeRun != null) {
        throw StateError('Routine has an active dated run.');
      }

      final runtimeOwner = await customSelect(
        'SELECT 1 FROM pomodoro_runtime AS runtime '
        'INNER JOIN routine_item_runs AS item_run '
        'ON item_run.task_id = runtime.task_id '
        'INNER JOIN routine_runs AS run '
        'ON run.id = item_run.routine_run_id '
        'WHERE run.source_routine_id = ? LIMIT 1',
        variables: [Variable<String>(id)],
        readsFrom: {
          pomodoroRuntimeRecords,
          routineItemRunRecords,
          routineRunRecords,
        },
      ).getSingleOrNull();
      if (runtimeOwner != null) {
        throw StateError('Routine task owns the Pomodoro runtime.');
      }

      await (delete(routineRecords)..where((row) => row.id.equals(id))).go();
    });
  }

  Future<List<RoutineRunRecord>> getRunsInRange({
    required String startLocalDate,
    required String endLocalDate,
  }) =>
      (select(routineRunRecords)
            ..where(
              (row) =>
                  row.localDate.isBiggerOrEqualValue(startLocalDate) &
                  row.localDate.isSmallerOrEqualValue(endLocalDate),
            )
            ..orderBy([
              (row) => OrderingTerm.asc(row.localDate),
              (row) => OrderingTerm.asc(row.scheduledStartMinuteSnapshot),
            ]))
          .get();

  Future<RoutineRunRecord?> findRun({
    required String sourceRoutineId,
    required String localDate,
  }) =>
      (select(routineRunRecords)..where(
            (row) =>
                row.sourceRoutineId.equals(sourceRoutineId) &
                row.localDate.equals(localDate),
          ))
          .getSingleOrNull();

  Future<void> saveRun(RoutineRunRecordsCompanion run) =>
      into(routineRunRecords).insertOnConflictUpdate(run);

  Future<List<RoutineItemRunRecord>> getItemRuns(String routineRunId) =>
      (select(routineItemRunRecords)
            ..where((row) => row.routineRunId.equals(routineRunId))
            ..orderBy([(row) => OrderingTerm.asc(row.positionSnapshot)]))
          .get();

  Future<void> saveItemRun(RoutineItemRunRecordsCompanion itemRun) =>
      into(routineItemRunRecords).insertOnConflictUpdate(itemRun);

  Future<bool> skipOptionalItemRun({
    required String itemRunId,
    required DateTime skippedAt,
  }) => transaction(() async {
    final itemRun = await (select(
      routineItemRunRecords,
    )..where((row) => row.id.equals(itemRunId))).getSingleOrNull();
    if (itemRun == null ||
        !itemRun.isOptionalSnapshot ||
        itemRun.status != 'scheduled') {
      return false;
    }
    await _skipItemRun(itemRun, skippedAt);
    await _recalculateRunStatus(itemRun.routineRunId, skippedAt);
    return true;
  });

  Future<bool> skipRoutineRun({
    required String routineRunId,
    required DateTime skippedAt,
  }) => transaction(() async {
    final run = await (select(
      routineRunRecords,
    )..where((row) => row.id.equals(routineRunId))).getSingleOrNull();
    if (run == null || run.status == 'completed' || run.status == 'missed') {
      return false;
    }
    final itemRuns = await getItemRuns(routineRunId);
    if (itemRuns.any((item) => item.status == 'inProgress')) return false;
    for (final itemRun in itemRuns) {
      if (itemRun.status == 'scheduled') await _skipItemRun(itemRun, skippedAt);
    }
    await (update(
      routineRunRecords,
    )..where((row) => row.id.equals(run.id))).write(
      RoutineRunRecordsCompanion(
        status: const Value('skipped'),
        completedAt: const Value(null),
        skippedAt: Value(skippedAt),
        updatedAt: Value(skippedAt),
      ),
    );
    return true;
  });

  Future<bool> shiftRemainingRun({
    required String routineRunId,
    required String currentItemRunId,
    required DateTime startAt,
    required DateTime updatedAt,
  }) => transaction(() async {
    final current = await (select(
      routineItemRunRecords,
    )..where((row) => row.id.equals(currentItemRunId))).getSingleOrNull();
    if (current == null ||
        current.routineRunId != routineRunId ||
        current.status != 'scheduled') {
      return false;
    }
    final delta = startAt.difference(current.scheduledAtSnapshot);
    final pending = await getItemRuns(routineRunId);
    for (final itemRun in pending.where((item) => item.status == 'scheduled')) {
      final scheduledAt = itemRun.scheduledAtSnapshot.add(delta);
      await (update(
        routineItemRunRecords,
      )..where((row) => row.id.equals(itemRun.id))).write(
        RoutineItemRunRecordsCompanion(
          scheduledAtSnapshot: Value(scheduledAt),
          updatedAt: Value(updatedAt),
        ),
      );
      if (itemRun.taskId != null) {
        await (update(
          attachedDatabase.taskRecords,
        )..where((row) => row.id.equals(itemRun.taskId!))).write(
          TaskRecordsCompanion(
            scheduledDate: Value(scheduledAt),
            updatedAt: Value(updatedAt),
          ),
        );
      }
    }
    return true;
  });

  Future<void> _skipItemRun(
    RoutineItemRunRecord itemRun,
    DateTime skippedAt,
  ) async {
    if (itemRun.taskId != null) {
      await (delete(
        attachedDatabase.taskRecords,
      )..where((row) => row.id.equals(itemRun.taskId!))).go();
    }
    await (update(
      routineItemRunRecords,
    )..where((row) => row.id.equals(itemRun.id))).write(
      RoutineItemRunRecordsCompanion(
        status: const Value('skipped'),
        completedAt: const Value(null),
        skippedAt: Value(skippedAt),
        updatedAt: Value(skippedAt),
      ),
    );
  }

  Future<void> _recalculateRunStatus(
    String routineRunId,
    DateTime updatedAt,
  ) async {
    final itemRuns = await getItemRuns(routineRunId);
    final required = itemRuns.where((item) => !item.isOptionalSnapshot);
    final completed =
        required.isNotEmpty &&
        required.every(
          (item) => item.status == 'completed',
        );
    final started = itemRuns.any(
      (item) => item.status == 'inProgress' || item.status == 'completed',
    );
    await (update(
      routineRunRecords,
    )..where((row) => row.id.equals(routineRunId))).write(
      RoutineRunRecordsCompanion(
        status: Value(
          completed
              ? 'completed'
              : started
              ? 'inProgress'
              : 'scheduled',
        ),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<void> deleteRunById(String id) =>
      (delete(routineRunRecords)..where((row) => row.id.equals(id))).go();
}

@DriftAccessor(tables: [CalendarEventRecords])
class CalendarEventsDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$CalendarEventsDaoMixin {
  CalendarEventsDao(super.db);
  Future<List<CalendarEventRecord>> getAllEvents() =>
      (select(calendarEventRecords)..orderBy([
            (row) => OrderingTerm.asc(row.scheduledAt),
            (row) => OrderingTerm.desc(row.createdAt),
          ]))
          .get();
  Future<CalendarEventRecord?> findById(String id) => (select(
    calendarEventRecords,
  )..where((row) => row.id.equals(id))).getSingleOrNull();
  Future<CalendarEventRecord> insertEvent(
    CalendarEventRecordsCompanion companion,
  ) async {
    await into(calendarEventRecords).insert(companion);
    return (await findById(companion.id.value))!;
  }
}

class ReportTaskCountsRecord {
  const ReportTaskCountsRecord({
    required this.listed,
    required this.inProgress,
    required this.completed,
    required this.legacyUnknown,
  });

  final int listed;
  final int inProgress;
  final int completed;
  final int legacyUnknown;

  ReportTaskCountsRecord operator +(ReportTaskCountsRecord other) {
    return ReportTaskCountsRecord(
      listed: listed + other.listed,
      inProgress: inProgress + other.inProgress,
      completed: completed + other.completed,
      legacyUnknown: legacyUnknown + other.legacyUnknown,
    );
  }
}

class ReportSessionTotalsRecord {
  const ReportSessionTotalsRecord({
    required this.completedPomodoros,
    required this.focusedSeconds,
    required this.moodAverage,
    required this.moodSampleCount,
    required this.distractionMinutes,
  });

  final int completedPomodoros;
  final int focusedSeconds;
  final double? moodAverage;
  final int moodSampleCount;
  final int distractionMinutes;
}

class ReportRangeRecord {
  const ReportRangeRecord({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

String _reportDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

class ReportRoutineTotalsRecord {
  const ReportRoutineTotalsRecord({
    required this.scheduledRuns,
    required this.inProgressRuns,
    required this.completedRuns,
    required this.skippedRuns,
    required this.missedRuns,
    required this.scheduledItems,
    required this.inProgressItems,
    required this.completedItems,
    required this.skippedItems,
    required this.missedItems,
    required this.requiredItems,
    required this.completedRequiredItems,
    required this.skippedOptionalItems,
    required this.missedRequiredItems,
    required this.plannedFocusMinutes,
    required this.focusedSeconds,
    required this.averageStartDelayMinutes,
    required this.startDelaySampleCount,
    required this.moodAverage,
    required this.moodSampleCount,
    required this.typicalAbandonmentItem,
    required this.typicalAbandonmentCount,
    required this.longestCompletedStreak,
  });

  final int scheduledRuns;
  final int inProgressRuns;
  final int completedRuns;
  final int skippedRuns;
  final int missedRuns;
  final int scheduledItems;
  final int inProgressItems;
  final int completedItems;
  final int skippedItems;
  final int missedItems;
  final int requiredItems;
  final int completedRequiredItems;
  final int skippedOptionalItems;
  final int missedRequiredItems;
  final int plannedFocusMinutes;
  final int focusedSeconds;
  final double? averageStartDelayMinutes;
  final int startDelaySampleCount;
  final double? moodAverage;
  final int moodSampleCount;
  final String? typicalAbandonmentItem;
  final int typicalAbandonmentCount;
  final int longestCompletedStreak;
}

class ReportRoutineBreakdownRecord {
  const ReportRoutineBreakdownRecord({
    required this.sourceRoutineId,
    required this.name,
    required this.scheduledRuns,
    required this.completedRuns,
    required this.requiredItems,
    required this.completedRequiredItems,
  });

  final String sourceRoutineId;
  final String name;
  final int scheduledRuns;
  final int completedRuns;
  final int requiredItems;
  final int completedRequiredItems;
}

@DriftAccessor(
  tables: [
    TaskRecords,
    TaskCompletionEventRecords,
    ReportingMetadataRecords,
    PomodoroSessionRecords,
    RoutineRunRecords,
    RoutineItemRunRecords,
  ],
)
class ReportsDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$ReportsDaoMixin {
  ReportsDao(super.db);

  Future<ReportRoutineTotalsRecord> loadRoutineTotals({
    required DateTime start,
    required DateTime end,
  }) async {
    final startKey = _reportDateKey(start);
    final endKey = _reportDateKey(end);
    final row = await customSelect(
      '''
      WITH selected_runs AS (
        SELECT * FROM routine_runs
        WHERE local_date >= ? AND local_date < ?
      ),
      selected_items AS (
        SELECT rir.*
        FROM routine_item_runs rir
        INNER JOIN selected_runs rr ON rr.id = rir.routine_run_id
      ),
      run_totals AS (
        SELECT
          COUNT(*) AS scheduled_runs,
          SUM(CASE WHEN status = 'inProgress' THEN 1 ELSE 0 END) AS in_progress_runs,
          SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_runs,
          SUM(CASE WHEN status = 'skipped' THEN 1 ELSE 0 END) AS skipped_runs,
          SUM(CASE WHEN status = 'missed' THEN 1 ELSE 0 END) AS missed_runs
        FROM selected_runs
      ),
      item_totals AS (
        SELECT
          SUM(CASE WHEN status = 'scheduled' THEN 1 ELSE 0 END) AS scheduled_items,
          SUM(CASE WHEN status = 'inProgress' THEN 1 ELSE 0 END) AS in_progress_items,
          SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_items,
          SUM(CASE WHEN status = 'skipped' THEN 1 ELSE 0 END) AS skipped_items,
          SUM(CASE WHEN status = 'missed' THEN 1 ELSE 0 END) AS missed_items,
          SUM(CASE WHEN is_optional_snapshot = 0 THEN 1 ELSE 0 END) AS required_items,
          SUM(CASE WHEN is_optional_snapshot = 0 AND status = 'completed' THEN 1 ELSE 0 END) AS completed_required_items,
          SUM(CASE WHEN is_optional_snapshot = 1 AND status = 'skipped' THEN 1 ELSE 0 END) AS skipped_optional_items,
          SUM(CASE WHEN is_optional_snapshot = 0 AND status = 'missed' THEN 1 ELSE 0 END) AS missed_required_items,
          COALESCE(SUM(duration_minutes_snapshot), 0) AS planned_focus_minutes,
          AVG(
            CASE WHEN started_at IS NOT NULL THEN
              MAX((started_at - scheduled_at_snapshot) / 60.0, 0)
            END
          ) AS average_start_delay_minutes,
          COUNT(CASE WHEN started_at IS NOT NULL THEN 1 END) AS start_delay_sample_count
        FROM selected_items
      ),
      session_totals AS (
        SELECT
          COALESCE(SUM(ps.focused_seconds), 0) AS focused_seconds,
          AVG(CASE WHEN ps.end_mood_score BETWEEN 1 AND 5 THEN ps.end_mood_score END) AS mood_average,
          COUNT(CASE WHEN ps.end_mood_score BETWEEN 1 AND 5 THEN 1 END) AS mood_sample_count
        FROM pomodoro_sessions ps
        INNER JOIN routine_item_runs rir ON rir.task_id = ps.task_id
        WHERE ps.status = 'completed' AND ps.ended_at >= ? AND ps.ended_at < ?
      ),
      sequenced_runs AS (
        SELECT
          source_routine_id,
          local_date,
          status,
          SUM(CASE WHEN status = 'completed' THEN 0 ELSE 1 END) OVER (
            PARTITION BY source_routine_id
            ORDER BY local_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
          ) AS break_group
        FROM selected_runs
      ),
      streak_groups AS (
        SELECT
          source_routine_id,
          break_group,
          COUNT(*) AS streak
        FROM sequenced_runs
        WHERE status = 'completed'
        GROUP BY source_routine_id, break_group
      )
      SELECT
        COALESCE(rt.scheduled_runs, 0) AS scheduled_runs,
        COALESCE(rt.in_progress_runs, 0) AS in_progress_runs,
        COALESCE(rt.completed_runs, 0) AS completed_runs,
        COALESCE(rt.skipped_runs, 0) AS skipped_runs,
        COALESCE(rt.missed_runs, 0) AS missed_runs,
        COALESCE(it.scheduled_items, 0) AS scheduled_items,
        COALESCE(it.in_progress_items, 0) AS in_progress_items,
        COALESCE(it.completed_items, 0) AS completed_items,
        COALESCE(it.skipped_items, 0) AS skipped_items,
        COALESCE(it.missed_items, 0) AS missed_items,
        COALESCE(it.required_items, 0) AS required_items,
        COALESCE(it.completed_required_items, 0) AS completed_required_items,
        COALESCE(it.skipped_optional_items, 0) AS skipped_optional_items,
        COALESCE(it.missed_required_items, 0) AS missed_required_items,
        COALESCE(it.planned_focus_minutes, 0) AS planned_focus_minutes,
        COALESCE(st.focused_seconds, 0) AS focused_seconds,
        it.average_start_delay_minutes AS average_start_delay_minutes,
        COALESCE(it.start_delay_sample_count, 0) AS start_delay_sample_count,
        st.mood_average AS mood_average,
        COALESCE(st.mood_sample_count, 0) AS mood_sample_count,
        COALESCE((SELECT MAX(streak) FROM streak_groups), 0) AS longest_completed_streak
      FROM run_totals rt
      CROSS JOIN item_totals it
      CROSS JOIN session_totals st
      ''',
      variables: [
        Variable.withString(startKey),
        Variable.withString(endKey),
        Variable.withDateTime(start),
        Variable.withDateTime(end),
      ],
      readsFrom: {
        routineRunRecords,
        routineItemRunRecords,
        pomodoroSessionRecords,
      },
    ).getSingle();
    final abandonment = await customSelect(
      '''
      SELECT rir.title_snapshot, COUNT(*) AS occurrence_count
      FROM routine_item_runs rir
      INNER JOIN routine_runs rr ON rr.id = rir.routine_run_id
      WHERE rr.local_date >= ? AND rr.local_date < ?
        AND rir.is_optional_snapshot = 0
        AND rir.status = 'missed'
      GROUP BY rir.title_snapshot
      ORDER BY occurrence_count DESC, rir.title_snapshot ASC
      LIMIT 1
      ''',
      variables: [
        Variable.withString(startKey),
        Variable.withString(endKey),
      ],
      readsFrom: {routineRunRecords, routineItemRunRecords},
    ).getSingleOrNull();

    return ReportRoutineTotalsRecord(
      scheduledRuns: row.read<int>('scheduled_runs'),
      inProgressRuns: row.read<int>('in_progress_runs'),
      completedRuns: row.read<int>('completed_runs'),
      skippedRuns: row.read<int>('skipped_runs'),
      missedRuns: row.read<int>('missed_runs'),
      scheduledItems: row.read<int>('scheduled_items'),
      inProgressItems: row.read<int>('in_progress_items'),
      completedItems: row.read<int>('completed_items'),
      skippedItems: row.read<int>('skipped_items'),
      missedItems: row.read<int>('missed_items'),
      requiredItems: row.read<int>('required_items'),
      completedRequiredItems: row.read<int>('completed_required_items'),
      skippedOptionalItems: row.read<int>('skipped_optional_items'),
      missedRequiredItems: row.read<int>('missed_required_items'),
      plannedFocusMinutes: row.read<int>('planned_focus_minutes'),
      focusedSeconds: row.read<int>('focused_seconds'),
      averageStartDelayMinutes: row.readNullable<double>(
        'average_start_delay_minutes',
      ),
      startDelaySampleCount: row.read<int>('start_delay_sample_count'),
      moodAverage: row.readNullable<double>('mood_average'),
      moodSampleCount: row.read<int>('mood_sample_count'),
      typicalAbandonmentItem: abandonment?.read<String>('title_snapshot'),
      typicalAbandonmentCount: abandonment?.read<int>('occurrence_count') ?? 0,
      longestCompletedStreak: row.read<int>('longest_completed_streak'),
    );
  }

  Future<List<ReportRoutineBreakdownRecord>> loadRoutineBreakdown({
    required DateTime start,
    required DateTime end,
  }) async {
    final rows = await customSelect(
      '''
      WITH selected_runs AS (
        SELECT * FROM routine_runs
        WHERE local_date >= ? AND local_date < ?
      ),
      per_run AS (
        SELECT
          rr.id,
          rr.source_routine_id,
          rr.name_snapshot,
          rr.local_date,
          rr.status,
          SUM(CASE WHEN rir.is_optional_snapshot = 0 THEN 1 ELSE 0 END) AS required_items,
          SUM(CASE WHEN rir.is_optional_snapshot = 0 AND rir.status = 'completed' THEN 1 ELSE 0 END) AS completed_required_items
        FROM selected_runs rr
        LEFT JOIN routine_item_runs rir ON rir.routine_run_id = rr.id
        GROUP BY rr.id
      )
      SELECT
        source_routine_id,
        (
          SELECT latest.name_snapshot
          FROM per_run latest
          WHERE latest.source_routine_id = current.source_routine_id
          ORDER BY latest.local_date DESC
          LIMIT 1
        ) AS name_snapshot,
        COUNT(*) AS scheduled_runs,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_runs,
        COALESCE(SUM(required_items), 0) AS required_items,
        COALESCE(SUM(completed_required_items), 0) AS completed_required_items
      FROM per_run current
      GROUP BY source_routine_id
      ORDER BY completed_required_items DESC, name_snapshot ASC
      ''',
      variables: [
        Variable.withString(_reportDateKey(start)),
        Variable.withString(_reportDateKey(end)),
      ],
      readsFrom: {routineRunRecords, routineItemRunRecords},
    ).get();
    return [
      for (final row in rows)
        ReportRoutineBreakdownRecord(
          sourceRoutineId: row.read<String>('source_routine_id'),
          name: row.read<String>('name_snapshot'),
          scheduledRuns: row.read<int>('scheduled_runs'),
          completedRuns: row.read<int>('completed_runs'),
          requiredItems: row.read<int>('required_items'),
          completedRequiredItems: row.read<int>('completed_required_items'),
        ),
    ];
  }

  Future<ReportTaskCountsRecord> countScheduledTasks({
    required DateTime start,
    required DateTime end,
  }) {
    return _countTasks(
      taskRecords.scheduledDate.isBiggerOrEqualValue(start) &
          taskRecords.scheduledDate.isSmallerThanValue(end),
    );
  }

  Future<ReportTaskCountsRecord> countCreatedTasks({
    required DateTime start,
    required DateTime end,
  }) {
    return _countTasks(
      taskRecords.createdAt.isBiggerOrEqualValue(start) &
          taskRecords.createdAt.isSmallerThanValue(end),
    );
  }

  Future<List<ReportTaskCountsRecord>> countScheduledTaskBuckets(
    List<ReportRangeRecord> ranges,
  ) async {
    if (ranges.isEmpty) {
      return const [];
    }
    final bucketCase = [
      for (var index = 0; index < ranges.length; index++)
        'WHEN scheduled_date < ? THEN $index',
    ].join(' ');
    final rows = await customSelect(
      '''
      SELECT
        CASE $bucketCase END AS bucket_index,
        status,
        COUNT(*) AS row_count,
        SUM(CASE WHEN legacy_completion_unknown = 1 THEN 1 ELSE 0 END)
          AS legacy_count
      FROM tasks
      WHERE scheduled_date >= ? AND scheduled_date < ?
      GROUP BY bucket_index, status
      ''',
      variables: [
        for (final range in ranges) Variable.withDateTime(range.end),
        Variable.withDateTime(ranges.first.start),
        Variable.withDateTime(ranges.last.end),
      ],
      readsFrom: {taskRecords},
    ).get();
    final listed = List<int>.filled(ranges.length, 0);
    final inProgress = List<int>.filled(ranges.length, 0);
    final completed = List<int>.filled(ranges.length, 0);
    final legacyUnknown = List<int>.filled(ranges.length, 0);

    for (final row in rows) {
      final index = row.read<int>('bucket_index');
      final count = row.read<int>('row_count');
      switch (row.read<String>('status')) {
        case 'listed':
          listed[index] += count;
        case 'in_progress':
          inProgress[index] += count;
        case 'completed':
          completed[index] += count;
      }
      legacyUnknown[index] += row.read<int>('legacy_count');
    }

    return [
      for (var index = 0; index < ranges.length; index++)
        ReportTaskCountsRecord(
          listed: listed[index],
          inProgress: inProgress[index],
          completed: completed[index],
          legacyUnknown: legacyUnknown[index],
        ),
    ];
  }

  Future<ReportTaskCountsRecord> _countTasks(Expression<bool> predicate) async {
    final listed = taskRecords.id.count(
      filter: taskRecords.status.equals('listed'),
    );
    final inProgress = taskRecords.id.count(
      filter: taskRecords.status.equals('in_progress'),
    );
    final completed = taskRecords.id.count(
      filter: taskRecords.status.equals('completed'),
    );
    final legacyUnknown = taskRecords.id.count(
      filter: taskRecords.legacyCompletionUnknown.equals(true),
    );
    final row =
        await (selectOnly(taskRecords)
              ..addColumns([listed, inProgress, completed, legacyUnknown])
              ..where(predicate))
            .getSingle();

    return ReportTaskCountsRecord(
      listed: row.read(listed) ?? 0,
      inProgress: row.read(inProgress) ?? 0,
      completed: row.read(completed) ?? 0,
      legacyUnknown: row.read(legacyUnknown) ?? 0,
    );
  }

  Future<ReportSessionTotalsRecord> loadSessionTotals({
    required DateTime start,
    required DateTime end,
  }) async {
    final row = await customSelect(
      '''
      SELECT
        COALESCE(
          SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END),
          0
        ) AS completed_pomodoros,
        COALESCE(SUM(focused_seconds), 0) AS focused_seconds,
        AVG(
          CASE
            WHEN status = 'completed'
              AND task_id IS NOT NULL
              AND end_mood_score BETWEEN 1 AND 5
              THEN end_mood_score
          END
        ) AS mood_average,
        COUNT(
          CASE
            WHEN status = 'completed'
              AND task_id IS NOT NULL
              AND end_mood_score BETWEEN 1 AND 5
              THEN end_mood_score
          END
        ) AS mood_sample_count,
        COALESCE(
          SUM(
            CASE
              WHEN was_distracted = 1 THEN COALESCE(distraction_minutes, 0)
              ELSE 0
            END
          ),
          0
        ) AS distraction_minutes
      FROM pomodoro_sessions
      WHERE ended_at >= ? AND ended_at < ?
      ''',
      variables: [
        Variable.withDateTime(start),
        Variable.withDateTime(end),
      ],
      readsFrom: {pomodoroSessionRecords},
    ).getSingle();

    return ReportSessionTotalsRecord(
      completedPomodoros: row.read<int>('completed_pomodoros'),
      focusedSeconds: row.read<int>('focused_seconds'),
      moodAverage: row.readNullable<double>('mood_average'),
      moodSampleCount: row.read<int>('mood_sample_count'),
      distractionMinutes: row.read<int>('distraction_minutes'),
    );
  }

  Future<List<ReportSessionTotalsRecord>> loadSessionBucketTotals(
    List<ReportRangeRecord> ranges,
  ) async {
    if (ranges.isEmpty) {
      return const [];
    }
    final bucketCase = [
      for (var index = 0; index < ranges.length; index++)
        'WHEN ended_at < ? THEN $index',
    ].join(' ');
    final rows = await customSelect(
      '''
      SELECT
        CASE $bucketCase END AS bucket_index,
        COALESCE(
          SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END),
          0
        ) AS completed_pomodoros,
        COALESCE(SUM(focused_seconds), 0) AS focused_seconds
      FROM pomodoro_sessions
      WHERE ended_at >= ? AND ended_at < ?
      GROUP BY bucket_index
      ''',
      variables: [
        for (final range in ranges) Variable.withDateTime(range.end),
        Variable.withDateTime(ranges.first.start),
        Variable.withDateTime(ranges.last.end),
      ],
      readsFrom: {pomodoroSessionRecords},
    ).get();
    final totals = List<ReportSessionTotalsRecord>.generate(
      ranges.length,
      (_) => const ReportSessionTotalsRecord(
        completedPomodoros: 0,
        focusedSeconds: 0,
        moodAverage: null,
        moodSampleCount: 0,
        distractionMinutes: 0,
      ),
    );
    for (final row in rows) {
      totals[row.read<int>('bucket_index')] = ReportSessionTotalsRecord(
        completedPomodoros: row.read<int>('completed_pomodoros'),
        focusedSeconds: row.read<int>('focused_seconds'),
        moodAverage: null,
        moodSampleCount: 0,
        distractionMinutes: 0,
      );
    }
    return totals;
  }

  Future<int> countCompletionEvents({
    required DateTime start,
    required DateTime end,
  }) async {
    final count = taskCompletionEventRecords.id.count();
    final row =
        await (selectOnly(taskCompletionEventRecords)
              ..addColumns([count])
              ..where(
                taskCompletionEventRecords.completedAt.isBiggerOrEqualValue(
                      start,
                    ) &
                    taskCompletionEventRecords.completedAt.isSmallerThanValue(
                      end,
                    ),
              ))
            .getSingle();

    return row.read(count) ?? 0;
  }

  Future<List<TaskCompletionEventRecord>> getCompletionEventsInRange({
    required DateTime start,
    required DateTime end,
  }) {
    return (select(taskCompletionEventRecords)
          ..where(
            (row) =>
                row.completedAt.isBiggerOrEqualValue(start) &
                row.completedAt.isSmallerThanValue(end),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.completedAt)]))
        .get();
  }
}

@DriftDatabase(
  tables: [
    GoalRecords,
    TaskRecords,
    TaskCompletionEventRecords,
    ReportingMetadataRecords,
    PomodoroSessionRecords,
    PomodoroRuntimeRecords,
    RoutineRecords,
    RoutineDayRecords,
    RoutineItemRecords,
    RoutineRunRecords,
    RoutineItemRunRecords,
    CalendarEventRecords,
  ],
  daos: [
    GoalsDao,
    TasksDao,
    PomodoroSessionsDao,
    PomodoroRuntimeDao,
    RoutinesDao,
    CalendarEventsDao,
    ReportsDao,
  ],
)
class MichiFocusDatabase extends _$MichiFocusDatabase {
  MichiFocusDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'michifocus'));

  static const currentSchemaVersion = 5;
  @override
  int get schemaVersion => currentSchemaVersion;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from > to) {
        throw StateError('Database downgrade is not supported.');
      }
      if (from < 2) {
        await migrator.addColumn(
          taskRecords,
          taskRecords.legacyCompletionUnknown,
        );
        await migrator.createTable(taskCompletionEventRecords);
        await migrator.createTable(reportingMetadataRecords);
        await migrator.createIndex(tasksCreatedAtIdx);
        await migrator.createIndex(pomodoroSessionsEndedAtIdx);
        await migrator.createIndex(taskCompletionEventsCompletedAtIdx);
        await migrator.createIndex(taskCompletionEventsTaskCompletedIdx);
        await customStatement(
          'UPDATE tasks SET legacy_completion_unknown = 1 '
          "WHERE status = 'completed' OR is_completed = 1",
        );
        await into(reportingMetadataRecords).insert(
          ReportingMetadataRecordsCompanion.insert(
            id: 'completion-history',
            completionTrackingStartedAt: DateTime.now(),
          ),
        );
      }
      if (from < 3) {
        await migrator.createTable(pomodoroRuntimeRecords);
      }
      if (from < 4) {
        await migrator.addColumn(
          pomodoroSessionRecords,
          pomodoroSessionRecords.moodPromptPending,
        );
      }
      if (from < 5) {
        for (final statement in const [
          'CREATE INDEX IF NOT EXISTS tasks_goal_id_idx ON tasks (goal_id)',
          'CREATE INDEX IF NOT EXISTS tasks_scheduled_date_idx ON tasks (scheduled_date)',
          'CREATE INDEX IF NOT EXISTS tasks_created_at_idx ON tasks (created_at)',
          'CREATE INDEX IF NOT EXISTS task_completion_events_completed_at_idx ON task_completion_events (completed_at)',
          'CREATE INDEX IF NOT EXISTS task_completion_events_task_completed_idx ON task_completion_events (task_id, completed_at)',
          'CREATE INDEX IF NOT EXISTS pomodoro_sessions_goal_id_idx ON pomodoro_sessions (goal_id)',
          'CREATE INDEX IF NOT EXISTS pomodoro_sessions_task_id_idx ON pomodoro_sessions (task_id)',
          'CREATE INDEX IF NOT EXISTS pomodoro_sessions_started_at_idx ON pomodoro_sessions (started_at)',
          'CREATE INDEX IF NOT EXISTS pomodoro_sessions_ended_at_idx ON pomodoro_sessions (ended_at)',
          'CREATE INDEX IF NOT EXISTS calendar_events_scheduled_at_idx ON calendar_events (scheduled_at)',
        ]) {
          await customStatement(statement);
        }
        await migrator.createTable(routineRecords);
        await migrator.createTable(routineDayRecords);
        await migrator.createTable(routineItemRecords);
        await migrator.createTable(routineRunRecords);
        await migrator.createTable(routineItemRunRecords);
        await migrator.createIndex(routinesStatusIdx);
        await migrator.createIndex(routinesUpdatedAtIdx);
        await migrator.createIndex(routineDaysWeekdayRoutineIdx);
        await migrator.createIndex(routineItemsRoutinePositionUq);
        await migrator.createIndex(routineItemsRoutineTimeIdx);
        await migrator.createIndex(routineItemsGoalIdIdx);
        await migrator.createIndex(routineRunsOccurrenceUq);
        await migrator.createIndex(routineRunsDateStatusIdx);
        await migrator.createIndex(routineRunsRoutineDateIdx);
        await migrator.createIndex(routineItemRunsMaterializationUq);
        await migrator.createIndex(routineItemRunsTaskIdUq);
        await migrator.createIndex(routineItemRunsRoutineItemIdIdx);
        await migrator.createIndex(routineItemRunsScheduleStatusIdx);
        await migrator.createIndex(routineItemRunsRunPositionIdx);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA journal_mode = DELETE');
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> createBackupSnapshot(String targetPath) async {
    final escapedPath = targetPath.replaceAll("'", "''");
    await customStatement("VACUUM INTO '$escapedPath'");
  }

  Future<void> clearAllUserData() async {
    await transaction(() async {
      await delete(pomodoroRuntimeRecords).go();
      await delete(routineItemRunRecords).go();
      await delete(routineRunRecords).go();
      await delete(routineItemRecords).go();
      await delete(routineDayRecords).go();
      await delete(routineRecords).go();
      await delete(taskCompletionEventRecords).go();
      await delete(pomodoroSessionRecords).go();
      await delete(taskRecords).go();
      await delete(goalRecords).go();
      await delete(calendarEventRecords).go();
      await delete(reportingMetadataRecords).go();
    });
  }
}
