import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_coordinator.dart';

class DriftGoalsRepository implements GoalsRepository {
  DriftGoalsRepository(
    this._dao, {
    SyncMutationCoordinator? sync,
    SecureSyncIdGenerator? idGenerator,
    DateTime Function()? clock,
  }) : _sync = sync,
       _idGenerator = idGenerator,
       _clock = clock ?? DateTime.now;

  final GoalsDao _dao;
  final SyncMutationCoordinator? _sync;
  final SecureSyncIdGenerator? _idGenerator;
  final DateTime Function() _clock;
  int _idSequence = 0;

  @override
  Future<List<ProductivityGoal>> loadGoals() async {
    final records = await _dao.getAllGoals();
    return records.map(_toDomain).toList(growable: false);
  }

  @override
  Future<ProductivityGoal> createGoal({
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  }) async {
    final now = _clock();
    final id = _createLocalId(now);
    final normalizedTargetDate = _dateOnlyOrNull(targetDate);
    final record = await _run(
      entityId: id,
      operationKind: 'create',
      changedFields: {
        'title': title,
        'targetSessions': targetSessions,
        'completedSessions': 0,
        'targetDate': normalizedTargetDate?.millisecondsSinceEpoch,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.insertGoal(
        GoalRecordsCompanion.insert(
          id: id,
          title: title,
          targetSessions: targetSessions,
          targetDate: Value(normalizedTargetDate),
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );

    return _toDomain(record);
  }

  @override
  Future<ProductivityGoal> restoreGoal(ProductivityGoal goal) async {
    final now = _clock();
    final targetDate = _dateOnlyOrNull(goal.targetDate);
    final record = await _run(
      entityId: goal.id,
      operationKind: 'create',
      changedFields: {
        'title': goal.title,
        'targetSessions': goal.targetSessions,
        'completedSessions': goal.completedSessions,
        'targetDate': targetDate?.millisecondsSinceEpoch,
        'createdAt': goal.createdAt.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.insertGoal(
        GoalRecordsCompanion.insert(
          id: goal.id,
          title: goal.title,
          targetSessions: goal.targetSessions,
          completedSessions: Value(goal.completedSessions),
          targetDate: Value(targetDate),
          createdAt: goal.createdAt,
          updatedAt: now,
        ),
      ),
    );

    return _toDomain(record);
  }

  @override
  Future<ProductivityGoal?> updateGoalDetails({
    required String id,
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  }) async {
    final now = _clock();
    final normalizedTargetDate = _dateOnlyOrNull(targetDate);
    final record = await _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'title': title,
        'targetSessions': targetSessions,
        'targetDate': normalizedTargetDate?.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateDetails(
        id: id,
        title: title,
        targetSessions: targetSessions,
        targetDate: normalizedTargetDate,
        updatedAt: now,
      ),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<ProductivityGoal?> updateProgress({
    required String id,
    required int completedSessions,
  }) async {
    final now = _clock();
    final record = await _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'completedSessions': completedSessions,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateProgress(
        id: id,
        completedSessions: completedSessions,
        updatedAt: now,
      ),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<void> deleteGoal(String id) => _run(
    entityId: id,
    operationKind: 'delete',
    changedFields: const {},
    mutate: () => _dao.deleteById(id),
  );

  String _createLocalId(DateTime now) {
    return _idGenerator?.create('goal') ??
        '${now.microsecondsSinceEpoch}-${_idSequence++}';
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
      entityType: 'goal',
      entityId: entityId,
      operationKind: operationKind,
      changedFields: changedFields,
      mutate: mutate,
    );
  }

  ProductivityGoal _toDomain(GoalRecord record) {
    return ProductivityGoal(
      id: record.id,
      title: record.title,
      targetSessions: record.targetSessions,
      completedSessions: record.completedSessions,
      createdAt: record.createdAt,
      targetDate: record.targetDate,
    );
  }

  DateTime? _dateOnlyOrNull(DateTime? date) {
    if (date == null) {
      return null;
    }

    return DateTime(date.year, date.month, date.day);
  }
}
