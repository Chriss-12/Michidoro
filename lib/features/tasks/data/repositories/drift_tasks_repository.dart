import 'package:drift/drift.dart';
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
    return _createTask(
      title: title,
      status: domain.TaskStatus.listed,
    );
  }

  @override
  Future<domain.Task> createPlannedTask({
    required String title,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) {
    return _createTask(
      title: title,
      status: domain.TaskStatus.listed,
      scheduledDate: scheduledDate,
      goalId: goalId,
      durationMinutes: durationMinutes,
    );
  }

  Future<domain.Task> _createTask({
    required String title,
    required domain.TaskStatus status,
    DateTime? scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) async {
    final now = DateTime.now();
    final record = await _dao.insertTask(
      TaskRecordsCompanion.insert(
        id: _createLocalId(now),
        title: title,
        status: Value(status._storageValue),
        scheduledDate: Value(scheduledDate),
        goalId: Value(goalId),
        durationMinutes: Value(durationMinutes),
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
      status: current.isCompleted
          ? domain.TaskStatus.listed._storageValue
          : domain.TaskStatus.completed._storageValue,
      updatedAt: DateTime.now(),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> updateTaskStatus(
    String id,
    domain.TaskStatus status,
  ) async {
    final record = await _dao.updateStatus(
      id: id,
      status: status._storageValue,
      isCompleted: status.isCompleted,
      updatedAt: DateTime.now(),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> scheduleTask(String id, DateTime? scheduledDate) async {
    final record = await _dao.updateSchedule(
      id: id,
      scheduledDate: scheduledDate,
      updatedAt: DateTime.now(),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> assignTaskToGoal(String id, String? goalId) async {
    final record = await _dao.updateGoal(
      id: id,
      goalId: goalId,
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
      status: _statusFromStorage(record.status, record.isCompleted),
      scheduledDate: record.scheduledDate,
      goalId: record.goalId,
      durationMinutes: record.durationMinutes,
    );
  }

  domain.TaskStatus _statusFromStorage(String value, bool isCompleted) {
    return switch (value) {
      'listed' => domain.TaskStatus.listed,
      'in_progress' => domain.TaskStatus.inProgress,
      'completed' => domain.TaskStatus.completed,
      _ => isCompleted ? domain.TaskStatus.completed : domain.TaskStatus.listed,
    };
  }
}

extension on domain.TaskStatus {
  String get _storageValue {
    return switch (this) {
      domain.TaskStatus.listed => 'listed',
      domain.TaskStatus.inProgress => 'in_progress',
      domain.TaskStatus.completed => 'completed',
    };
  }
}
