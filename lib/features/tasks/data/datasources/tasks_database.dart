import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'tasks_database.g.dart';

class TaskRecords extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

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
    required DateTime updatedAt,
  }) async {
    await (update(taskRecords)..where((record) => record.id.equals(id))).write(
      TaskRecordsCompanion(
        isCompleted: Value(isCompleted),
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
  int get schemaVersion => 1;
}
