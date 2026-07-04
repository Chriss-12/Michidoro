import 'package:pomodoro_app_v1/features/tasks/data/datasources/tasks_database.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart'
    as domain;
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';

class DriftTasksRepository implements TasksRepository {
  DriftTasksRepository(this._dao);

  final TasksDao _dao;
  int _idSequence = 0;

  @override
  Future<List<domain.Task>> loadTasks() async {
    final records = await _dao.getAllTasks();
    return records.map(_toDomain).toList(growable: false);
  }

  @override
  Future<domain.Task> createTask(String title) async {
    final now = DateTime.now();
    final record = await _dao.insertTask(
      TaskRecordsCompanion.insert(
        id: _createLocalId(now),
        title: title,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return _toDomain(record);
  }

  @override
  Future<domain.Task?> updateTaskTitle(String id, String title) async {
    final record = await _dao.updateTitle(
      id: id,
      title: title,
      updatedAt: DateTime.now(),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> toggleTaskCompletion(String id) async {
    final current = await _dao.findById(id);
    if (current == null) {
      return null;
    }

    final record = await _dao.updateCompletion(
      id: id,
      isCompleted: !current.isCompleted,
      updatedAt: DateTime.now(),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<void> deleteTask(String id) {
    return _dao.deleteById(id);
  }

  String _createLocalId(DateTime now) {
    return '${now.microsecondsSinceEpoch}-${_idSequence++}';
  }

  domain.Task _toDomain(TaskRecord record) {
    return domain.Task(
      id: record.id,
      title: record.title,
      createdAt: record.createdAt,
      isCompleted: record.isCompleted,
    );
  }
}
