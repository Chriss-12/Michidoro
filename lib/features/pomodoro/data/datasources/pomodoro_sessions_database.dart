import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'pomodoro_sessions_database.g.dart';

class PomodoroSessionRecords extends Table {
  TextColumn get id => text()();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime()();

  IntColumn get plannedSeconds => integer()();

  IntColumn get focusedSeconds => integer()();

  TextColumn get goalId => text().nullable()();

  TextColumn get taskId => text().nullable()();

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

@DriftAccessor(tables: [PomodoroSessionRecords])
class PomodoroSessionsDao extends DatabaseAccessor<PomodoroSessionsDatabase>
    with _$PomodoroSessionsDaoMixin {
  PomodoroSessionsDao(super.db);

  Future<List<PomodoroSessionRecord>> getAllSessions() {
    return (select(pomodoroSessionRecords)..orderBy([
          (record) => OrderingTerm.desc(record.startedAt),
        ]))
        .get();
  }

  Future<PomodoroSessionRecord?> findById(String id) {
    return (select(
      pomodoroSessionRecords,
    )..where((record) => record.id.equals(id))).getSingleOrNull();
  }

  Future<PomodoroSessionRecord> insertSession(
    PomodoroSessionRecordsCompanion companion,
  ) async {
    await into(pomodoroSessionRecords).insert(companion);
    final session = await findById(companion.id.value);
    return session!;
  }

  Future<PomodoroSessionRecord> updateReflection({
    required String id,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) async {
    await (update(
      pomodoroSessionRecords,
    )..where((record) => record.id.equals(id))).write(
      PomodoroSessionRecordsCompanion(
        endMoodScore: Value(endMoodScore),
        wasDistracted: Value(wasDistracted),
        distractionMinutes: Value(distractionMinutes),
      ),
    );
    final session = await findById(id);
    return session!;
  }
}

@DriftDatabase(
  tables: [PomodoroSessionRecords],
  daos: [PomodoroSessionsDao],
)
class PomodoroSessionsDatabase extends _$PomodoroSessionsDatabase {
  PomodoroSessionsDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'michifocus_pomodoro_sessions'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(
          pomodoroSessionRecords,
          pomodoroSessionRecords.goalId,
        );
      }
      if (from < 3) {
        await migrator.addColumn(
          pomodoroSessionRecords,
          pomodoroSessionRecords.taskId,
        );
      }
      if (from < 4) {
        await migrator.addColumn(
          pomodoroSessionRecords,
          pomodoroSessionRecords.startMoodScore,
        );
        await migrator.addColumn(
          pomodoroSessionRecords,
          pomodoroSessionRecords.endMoodScore,
        );
        await migrator.addColumn(
          pomodoroSessionRecords,
          pomodoroSessionRecords.wasDistracted,
        );
        await migrator.addColumn(
          pomodoroSessionRecords,
          pomodoroSessionRecords.distractionMinutes,
        );
      }
    },
  );
}
