import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'goals_database.g.dart';

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

@DriftAccessor(tables: [GoalRecords])
class GoalsDao extends DatabaseAccessor<GoalsDatabase> with _$GoalsDaoMixin {
  GoalsDao(super.db);

  Future<List<GoalRecord>> getAllGoals() {
    return (select(goalRecords)..orderBy([
          (record) => OrderingTerm.desc(record.createdAt),
        ]))
        .get();
  }

  Future<GoalRecord?> findById(String id) {
    return (select(
      goalRecords,
    )..where((record) => record.id.equals(id))).getSingleOrNull();
  }

  Future<GoalRecord> insertGoal(GoalRecordsCompanion companion) async {
    await into(goalRecords).insert(companion);
    final goal = await findById(companion.id.value);
    return goal!;
  }

  Future<GoalRecord?> updateProgress({
    required String id,
    required int completedSessions,
    required DateTime updatedAt,
  }) async {
    await (update(goalRecords)..where((record) => record.id.equals(id))).write(
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
    await (update(goalRecords)..where((record) => record.id.equals(id))).write(
      GoalRecordsCompanion(
        title: Value(title),
        targetSessions: Value(targetSessions),
        targetDate: Value(targetDate),
        updatedAt: Value(updatedAt),
      ),
    );

    return findById(id);
  }

  Future<void> deleteById(String id) async {
    await (delete(goalRecords)..where((record) => record.id.equals(id))).go();
  }
}

@DriftDatabase(tables: [GoalRecords], daos: [GoalsDao])
class GoalsDatabase extends _$GoalsDatabase {
  GoalsDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'michifocus_goals'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(goalRecords, goalRecords.targetDate);
      }
    },
  );
}
