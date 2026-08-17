import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_coordinator.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart'
    as domain;
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';

class DriftTasksRepository implements TasksRepository {
  DriftTasksRepository(
    this._dao, {
    SyncMutationCoordinator? sync,
    SecureSyncIdGenerator? idGenerator,
    DateTime Function()? clock,
  }) : _sync = sync,
       _idGenerator = idGenerator,
       _clock = clock ?? DateTime.now;

  final TasksDao _dao;
  final SyncMutationCoordinator? _sync;
  final SecureSyncIdGenerator? _idGenerator;
  final DateTime Function() _clock;
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
    final now = _clock();
    final id = _createLocalId(now);
    final record = await _run(
      entityId: id,
      operationKind: 'create',
      changedFields: {
        'title': title,
        'status': status._storageValue,
        'isCompleted': status.isCompleted,
        'scheduledDate': scheduledDate?.millisecondsSinceEpoch,
        'goalId': goalId,
        'durationMinutes': durationMinutes,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.insertTask(
        TaskRecordsCompanion.insert(
          id: id,
          title: title,
          status: Value(status._storageValue),
          scheduledDate: Value(scheduledDate),
          goalId: Value(goalId),
          durationMinutes: Value(durationMinutes),
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );

    return _toDomain(record);
  }

  @override
  Future<domain.Task?> updateTaskTitle(String id, String title) async {
    final now = _clock();
    final record = await _runUpdate(
      id: id,
      changedFields: {
        'title': title,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateTitle(id: id, title: title, updatedAt: now),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> toggleTaskCompletion(String id) async {
    final current = await _dao.findById(id);
    if (current == null) {
      return null;
    }

    final now = _clock();
    final isCompleted = !current.isCompleted;
    final status = current.isCompleted
        ? domain.TaskStatus.listed._storageValue
        : domain.TaskStatus.completed._storageValue;
    final record = await _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'isCompleted': isCompleted,
        'status': status,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateCompletion(
        id: id,
        isCompleted: isCompleted,
        status: status,
        updatedAt: now,
      ),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> updateTaskStatus(
    String id,
    domain.TaskStatus status,
  ) async {
    final now = _clock();
    final record = await _runUpdate(
      id: id,
      changedFields: {
        'status': status._storageValue,
        'isCompleted': status.isCompleted,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateStatus(
        id: id,
        status: status._storageValue,
        isCompleted: status.isCompleted,
        updatedAt: now,
      ),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> scheduleTask(String id, DateTime? scheduledDate) async {
    final now = _clock();
    final record = await _runUpdate(
      id: id,
      changedFields: {
        'scheduledDate': scheduledDate?.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateSchedule(
        id: id,
        scheduledDate: scheduledDate,
        updatedAt: now,
      ),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> assignTaskToGoal(String id, String? goalId) async {
    final now = _clock();
    final record = await _runUpdate(
      id: id,
      changedFields: {
        'goalId': goalId,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateGoal(id: id, goalId: goalId, updatedAt: now),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<domain.Task?> updateTaskPlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
  }) async {
    final now = _clock();
    final record = await _runUpdate(
      id: id,
      changedFields: {
        'goalId': goalId,
        'durationMinutes': durationMinutes,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updatePlanning(
        id: id,
        goalId: goalId,
        durationMinutes: durationMinutes,
        updatedAt: now,
      ),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<void> deleteTask(String id) async {
    if (await _dao.findById(id) == null) return;
    await _run<void>(
      entityId: id,
      operationKind: 'delete',
      changedFields: const {},
      mutate: () => _dao.deleteById(id),
    );
  }

  String _createLocalId(DateTime now) {
    return _idGenerator?.create('task') ??
        '${now.microsecondsSinceEpoch}-${_idSequence++}';
  }

  Future<TaskRecord?> _runUpdate({
    required String id,
    required Map<String, Object?> changedFields,
    required Future<TaskRecord?> Function() mutate,
  }) async {
    if (await _dao.findById(id) == null) return null;
    return _run(
      entityId: id,
      operationKind: 'update',
      changedFields: changedFields,
      mutate: mutate,
    );
  }

  Future<T> _run<T>({
    required String entityId,
    required String operationKind,
    required Map<String, Object?> changedFields,
    required Future<T> Function() mutate,
  }) {
    final sync = _sync;
    if (sync == null) return mutate();
    return sync(
      entityType: 'task',
      entityId: entityId,
      operationKind: operationKind,
      changedFields: changedFields,
      mutate: mutate,
    );
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
      legacyCompletionUnknown: record.legacyCompletionUnknown,
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
