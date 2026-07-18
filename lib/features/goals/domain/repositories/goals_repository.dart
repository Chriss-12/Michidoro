import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';

abstract class GoalsRepository {
  Future<List<ProductivityGoal>> loadGoals();

  Future<ProductivityGoal> createGoal({
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  });

  Future<ProductivityGoal> restoreGoal(ProductivityGoal goal);

  Future<ProductivityGoal?> updateGoalDetails({
    required String id,
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  });

  Future<ProductivityGoal?> updateProgress({
    required String id,
    required int completedSessions,
  });

  Future<void> deleteGoal(String id);
}
