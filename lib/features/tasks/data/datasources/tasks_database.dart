import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'tasks_database.g.dart';

class TaskRecords extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  TextColumn get status => text().withDefault(const Constant('listed'))();

  DateTimeColumn get scheduledDate => dateTime().nullable()();

  TextColumn get goalId => text().nullable()();

  IntColumn get durationMinutes => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String get tableName => 'tasks';
}

@DriftAccessor(tables: [TaskRecords])
class TasksDao extends DatabaseAccessor<TasksDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Future<List<TaskRecord>> getAllTasks() {
    return (select(taskRecords)..orderBy([
          (record) => OrderingTerm.desc(record.createdAt),
        ]))
        .get();
  }

  Future<TaskRecord?> findById(String id) {
    return (select(
      taskRecords,
    )..where((record) => record.id.equals(id))).getSingleOrNull();
  }

  Future<TaskRecord> insertTask(TaskRecordsCompanion companion) async {
    await into(taskRecords).insert(companion);
    final task = await findById(companion.id.value);
    return task!;
  }

  Future<TaskRecord?> updateTitle({
    required String id,
    required String title,
    required DateTime updatedAt,
  }) async {
    await (update(taskRecords)..where((record) => record.id.equals(id))).write(
      TaskRecordsCompanion(
        title: Value(title),
        updatedAt: Value(updatedAt),
      ),
    );

    return findById(id);
  }

  Future<TaskRecord?> updateCompletion({
    required String id,
    required bool isCompleted,
    required String status,
    required DateTime updatedAt,
  }) async {
    await (update(taskRecords)..where((record) => record.id.equals(id))).write(
      TaskRecordsCompanion(
        isCompleted: Value(isCompleted),
        status: Value(status),
        updatedAt: Value(updatedAt),
      ),
    );

    return findById(id);
  }

  Future<TaskRecord?> updateStatus({
    required String id,
    required String status,
    required bool isCompleted,
    required DateTime updatedAt,
  }) async {
    await (update(taskRecords)..where((record) => record.id.equals(id))).write(
      TaskRecordsCompanion(
        status: Value(status),
        isCompleted: Value(isCompleted),
        updatedAt: Value(updatedAt),
      ),
    );

    return findById(id);
  }

  Future<TaskRecord?> updateSchedule({
    required String id,
    required DateTime? scheduledDate,
    required DateTime updatedAt,
  }) async {
    await (update(taskRecords)..where((record) => record.id.equals(id))).write(
      TaskRecordsCompanion(
        scheduledDate: Value(scheduledDate),
        updatedAt: Value(updatedAt),
      ),
    );

    return findById(id);
  }

  Future<TaskRecord?> updateGoal({
    required String id,
    required String? goalId,
    required DateTime updatedAt,
  }) async {
    await (update(taskRecords)..where((record) => record.id.equals(id))).write(
      TaskRecordsCompanion(
        goalId: Value(goalId),
        updatedAt: Value(updatedAt),
      ),
    );

    return findById(id);
  }

  Future<void> deleteById(String id) async {
    await (delete(taskRecords)..where((record) => record.id.equals(id))).go();
  }
}

@DriftDatabase(tables: [TaskRecords], daos: [TasksDao])
class TasksDatabase extends _$TasksDatabase {
  TasksDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'michifocus_tasks'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.addColumn(taskRecords, taskRecords.status);
          await migrator.addColumn(taskRecords, taskRecords.scheduledDate);
          await migrator.addColumn(taskRecords, taskRecords.goalId);
        }
        if (from < 3) {
          await migrator.addColumn(taskRecords, taskRecords.durationMinutes);
        }
      },
    );
  }
}
