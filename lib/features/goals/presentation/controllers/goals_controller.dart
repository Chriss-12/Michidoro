import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class GoalsController {
  GoalsController({required GoalsRepository repository})
    : _repository = repository;

  final GoalsRepository _repository;
  final FlutterSignal<List<ProductivityGoal>> goals = signal(const []);
  final FlutterSignal<String?> validationMessage = signal(null);
  final FlutterSignal<bool> isLoading = signal(false);
  void Function(String id)? onGoalDeleted;
  late final Computed<int> totalGoals = computed<int>(() => goals.value.length);
  late final Computed<int> completedGoals = computed<int>(
    () => goals.value.where((goal) => goal.isCompleted).length,
  );
  late final Computed<double> averageProgress = computed<double>(() {
    final currentGoals = goals.value;
    if (currentGoals.isEmpty) {
      return 0;
    }

    final totalProgress = currentGoals.fold<double>(
      0,
      (total, goal) => total + goal.progress,
    );

    return totalProgress / currentGoals.length;
  });

  Future<void> loadGoals() async {
    isLoading.value = true;
    goals.value = _sortGoals(await _repository.loadGoals());
    isLoading.value = false;
  }

  Future<bool> createGoal(
    String rawTitle,
    int targetSessions, {
    DateTime? targetDate,
  }) async {
    final title = rawTitle.trim();

    if (!_validateGoalDetails(title, targetSessions)) {
      return false;
    }

    final goal = await _repository.createGoal(
      title: title,
      targetSessions: targetSessions,
      targetDate: targetDate,
    );

    goals.value = _sortGoals([goal, ...goals.value]);
    validationMessage.value = null;
    return true;
  }

  Future<bool> updateGoalDetails({
    required String id,
    required String rawTitle,
    required int targetSessions,
    DateTime? targetDate,
  }) async {
    final title = rawTitle.trim();

    if (!_validateGoalDetails(title, targetSessions)) {
      return false;
    }

    final updatedGoal = await _repository.updateGoalDetails(
      id: id,
      title: title,
      targetSessions: targetSessions,
      targetDate: targetDate,
    );

    if (updatedGoal == null) {
      return false;
    }

    _replaceGoal(updatedGoal);
    validationMessage.value = null;
    return true;
  }

  Future<void> incrementProgress(String id) async {
    final goal = _findGoal(id);
    if (goal == null || goal.isCompleted) {
      return;
    }

    final updatedGoal = await _repository.updateProgress(
      id: id,
      completedSessions: goal.completedSessions + 1,
    );

    if (updatedGoal != null) {
      _replaceGoal(updatedGoal);
    }
  }

  Future<void> decrementProgress(String id) async {
    final goal = _findGoal(id);
    if (goal == null || goal.completedSessions == 0) {
      return;
    }

    final updatedGoal = await _repository.updateProgress(
      id: id,
      completedSessions: goal.completedSessions - 1,
    );

    if (updatedGoal != null) {
      _replaceGoal(updatedGoal);
    }
  }

  Future<void> deleteGoal(String id) async {
    await _repository.deleteGoal(id);
    goals.value = goals.value
        .where((goal) => goal.id != id)
        .toList(growable: false);
    onGoalDeleted?.call(id);
  }

  Future<void> restoreDeletedGoal(ProductivityGoal goal) async {
    final restoredGoal = await _repository.restoreGoal(goal);
    goals.value = _sortGoals([restoredGoal, ...goals.value]);
    validationMessage.value = null;
  }

  List<ProductivityGoal> goalsForDay(DateTime day) {
    return goals.value
        .where(
          (goal) => goal.targetDate != null && _sameDate(goal.targetDate!, day),
        )
        .toList(growable: false);
  }

  Set<int> plannedDaysForMonth(DateTime month) {
    return goals.value
        .where(
          (goal) =>
              goal.targetDate != null &&
              goal.targetDate!.year == month.year &&
              goal.targetDate!.month == month.month,
        )
        .map((goal) => goal.targetDate!.day)
        .toSet();
  }

  List<ProductivityGoal> scheduledGoals() {
    return goals.value
        .where((goal) => goal.targetDate != null && !goal.isCompleted)
        .toList(growable: false);
  }

  List<ProductivityGoal> goalsOnOrAfter(DateTime day) {
    final firstAllowedDay = DateTime(day.year, day.month, day.day);
    return _sortGoals(
      goals.value
          .where((goal) {
            final targetDate = goal.targetDate;
            if (targetDate == null) {
              return false;
            }
            final normalizedTarget = DateTime(
              targetDate.year,
              targetDate.month,
              targetDate.day,
            );
            return !normalizedTarget.isBefore(firstAllowedDay);
          })
          .toList(growable: false),
    );
  }

  ProductivityGoal? goalById(String? id) {
    if (id == null) {
      return null;
    }

    return _findGoal(id);
  }

  void clearValidationMessage() {
    if (validationMessage.value == null) {
      return;
    }

    validationMessage.value = null;
  }

  ProductivityGoal? _findGoal(String id) {
    for (final goal in goals.value) {
      if (goal.id == id) {
        return goal;
      }
    }

    return null;
  }

  void _replaceGoal(ProductivityGoal updatedGoal) {
    goals.value = _sortGoals([
      for (final goal in goals.value)
        if (goal.id == updatedGoal.id) updatedGoal else goal,
    ]);
  }

  bool _validateGoalDetails(String title, int targetSessions) {
    if (title.isEmpty) {
      validationMessage.value = 'Escribe un titulo para guardar la meta.';
      return false;
    }

    if (targetSessions < 1) {
      validationMessage.value = 'El objetivo debe tener al menos 1 pomodoro.';
      return false;
    }

    return true;
  }

  List<ProductivityGoal> _sortGoals(List<ProductivityGoal> source) {
    return [...source]..sort((first, second) {
      final firstDate = first.targetDate;
      final secondDate = second.targetDate;

      if (firstDate != null && secondDate != null) {
        final dateComparison = firstDate.compareTo(secondDate);
        if (dateComparison != 0) {
          return dateComparison;
        }
      } else if (firstDate != null) {
        return -1;
      } else if (secondDate != null) {
        return 1;
      }

      return second.createdAt.compareTo(first.createdAt);
    });
  }
}

bool _sameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
