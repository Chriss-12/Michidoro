import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/features/goals/data/datasources/goals_database.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';

class DriftGoalsRepository implements GoalsRepository {
  DriftGoalsRepository(this._dao);

  final GoalsDao _dao;
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
    final now = DateTime.now();
    final record = await _dao.insertGoal(
      GoalRecordsCompanion.insert(
        id: _createLocalId(now),
        title: title,
        targetSessions: targetSessions,
        targetDate: Value(_dateOnlyOrNull(targetDate)),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return _toDomain(record);
  }

  @override
  Future<ProductivityGoal> restoreGoal(ProductivityGoal goal) async {
    final now = DateTime.now();
    final record = await _dao.insertGoal(
      GoalRecordsCompanion.insert(
        id: goal.id,
        title: goal.title,
        targetSessions: goal.targetSessions,
        completedSessions: Value(goal.completedSessions),
        targetDate: Value(_dateOnlyOrNull(goal.targetDate)),
        createdAt: goal.createdAt,
        updatedAt: now,
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
    final record = await _dao.updateDetails(
      id: id,
      title: title,
      targetSessions: targetSessions,
      targetDate: _dateOnlyOrNull(targetDate),
      updatedAt: DateTime.now(),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<ProductivityGoal?> updateProgress({
    required String id,
    required int completedSessions,
  }) async {
    final record = await _dao.updateProgress(
      id: id,
      completedSessions: completedSessions,
      updatedAt: DateTime.now(),
    );

    return record == null ? null : _toDomain(record);
  }

  @override
  Future<void> deleteGoal(String id) {
    return _dao.deleteById(id);
  }

  String _createLocalId(DateTime now) {
    return '${now.microsecondsSinceEpoch}-${_idSequence++}';
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
