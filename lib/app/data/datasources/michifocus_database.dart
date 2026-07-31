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
  }) => _update(
    id,
    TaskRecordsCompanion(title: Value(title), updatedAt: Value(updatedAt)),
  );
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

      return findById(id);
    });
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

@DriftAccessor(
  tables: [
    TaskRecords,
    TaskCompletionEventRecords,
    ReportingMetadataRecords,
    PomodoroSessionRecords,
  ],
)
class ReportsDao extends DatabaseAccessor<MichiFocusDatabase>
    with _$ReportsDaoMixin {
  ReportsDao(super.db);

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
        AVG(COALESCE(end_mood_score, start_mood_score)) AS mood_average,
        COUNT(COALESCE(end_mood_score, start_mood_score)) AS mood_sample_count,
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
    CalendarEventRecords,
  ],
  daos: [
    GoalsDao,
    TasksDao,
    PomodoroSessionsDao,
    PomodoroRuntimeDao,
    CalendarEventsDao,
    ReportsDao,
  ],
)
class MichiFocusDatabase extends _$MichiFocusDatabase {
  MichiFocusDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'michifocus'));
  @override
  int get schemaVersion => 3;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
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
}
