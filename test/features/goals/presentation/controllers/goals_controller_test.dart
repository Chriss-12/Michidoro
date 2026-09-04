import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';

void main() {
  group('GoalsController', () {
    test('rejects blank goal titles', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());

      final created = await controller.createGoal('   ', 4);

      expect(created, isFalse);
      expect(controller.goals.value, isEmpty);
      expect(
        controller.validationMessage.value,
        'Escribe un titulo para guardar la meta.',
      );
    });

    test('rejects invalid target sessions', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());

      final created = await controller.createGoal('Leer documentacion', 0);

      expect(created, isFalse);
      expect(controller.goals.value, isEmpty);
      expect(
        controller.validationMessage.value,
        'El objetivo debe tener al menos 1 pomodoro.',
      );
    });

    test('trims and stores valid goals', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());

      final targetDate = DateTime(2026, 7, 31);
      final created = await controller.createGoal(
        '  Completar M3  ',
        3,
        targetDate: targetDate,
      );

      final goal = controller.goals.value.single;
      expect(created, isTrue);
      expect(controller.validationMessage.value, isNull);
      expect(goal.title, 'Completar M3');
      expect(goal.targetSessions, 3);
      expect(goal.completedSessions, 0);
      expect(goal.targetDate, targetDate);
    });

    test('edits goal details and keeps planning helpers updated', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());
      await controller.createGoal('Meta inicial', 3);
      final id = controller.goals.value.single.id;

      final saved = await controller.updateGoalDetails(
        id: id,
        rawTitle: '  Meta editada  ',
        targetSessions: 5,
        targetDate: DateTime(2026, 8, 3),
      );

      final goal = controller.goals.value.single;
      expect(saved, isTrue);
      expect(goal.title, 'Meta editada');
      expect(goal.targetSessions, 5);
      expect(goal.targetDate, DateTime(2026, 8, 3));
      expect(controller.goalsForDay(DateTime(2026, 8, 3)), [goal]);
      expect(controller.plannedDaysForMonth(DateTime(2026, 8)), {3});
    });

    test('increments progress without exceeding the target', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());
      await controller.createGoal('Completar flujo', 2);
      final id = controller.goals.value.single.id;

      await controller.incrementProgress(id);
      await controller.incrementProgress(id);
      await controller.incrementProgress(id);

      final goal = controller.goals.value.single;
      expect(goal.completedSessions, 2);
      expect(goal.progress, 1);
      expect(goal.isCompleted, isTrue);
    });

    test('decrements progress without going below zero', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());
      await controller.createGoal('Completar flujo', 2);
      final id = controller.goals.value.single.id;

      await controller.incrementProgress(id);
      await controller.decrementProgress(id);
      await controller.decrementProgress(id);

      final goal = controller.goals.value.single;
      expect(goal.completedSessions, 0);
      expect(goal.progress, 0);
    });

    test('calculates summary metrics from goals', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());
      await controller.createGoal('Primera meta', 2);
      await controller.createGoal('Segunda meta', 4);
      final firstId = controller.goals.value.last.id;
      final secondId = controller.goals.value.first.id;

      await controller.incrementProgress(firstId);
      await controller.incrementProgress(firstId);
      await controller.incrementProgress(secondId);

      expect(controller.totalGoals.value, 2);
      expect(controller.completedGoals.value, 1);
      expect(controller.averageProgress.value, 0.625);
    });

    test('deletes goals by id', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());
      await controller.createGoal('Primera', 2);
      await controller.createGoal('Segunda', 2);
      final id = controller.goals.value.first.id;

      await controller.deleteGoal(id);

      expect(controller.goals.value, hasLength(1));
      expect(controller.goals.value.single.title, 'Primera');
    });

    test('notifies when a goal is deleted', () async {
      String? deletedGoalId;
      final controller = GoalsController(repository: _MemoryGoalsRepository())
        ..onGoalDeleted = (id) {
          deletedGoalId = id;
        };
      await controller.createGoal('Meta activa', 2);
      final id = controller.goals.value.single.id;

      await controller.deleteGoal(id);

      expect(deletedGoalId, id);
    });

    test('restores a deleted goal with its original id', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());
      final targetDate = DateTime(2026, 7, 20);
      await controller.createGoal('Meta con undo', 1, targetDate: targetDate);
      final deletedGoal = controller.goals.value.single;

      await controller.deleteGoal(deletedGoal.id);
      await controller.restoreDeletedGoal(deletedGoal);

      final restoredGoal = controller.goals.value.single;
      expect(restoredGoal.id, deletedGoal.id);
      expect(restoredGoal.title, 'Meta con undo');
      expect(restoredGoal.targetDate, targetDate);
    });

    test('creates planned goals with hidden default target sessions', () async {
      final controller = GoalsController(repository: _MemoryGoalsRepository());

      final created = await controller.createGoal(
        'Objetivo del dia',
        1,
        targetDate: DateTime(2026, 7, 21),
      );

      final goal = controller.goals.value.single;
      expect(created, isTrue);
      expect(goal.title, 'Objetivo del dia');
      expect(goal.targetSessions, 1);
      expect(controller.goalsForDay(DateTime(2026, 7, 21)), [goal]);
    });

    test(
      'exposes only incomplete scheduled goals for Pomodoro selection',
      () async {
        final controller = GoalsController(
          repository: _MemoryGoalsRepository(),
        );
        await controller.createGoal('Sin fecha', 2);
        await controller.createGoal(
          'Con fecha',
          2,
          targetDate: DateTime(2026, 7, 10),
        );
        await controller.createGoal(
          'Completada',
          1,
          targetDate: DateTime(2026, 7, 11),
        );
        final completedGoal = controller.goals.value.firstWhere(
          (goal) => goal.title == 'Completada',
        );
        await controller.incrementProgress(completedGoal.id);

        final scheduledGoals = controller.scheduledGoals();

        expect(scheduledGoals, hasLength(1));
        expect(scheduledGoals.single.title, 'Con fecha');
      },
    );

    test('exposes only dated goals from the requested local day onward', () {
      final controller = GoalsController(repository: _MemoryGoalsRepository())
        ..goals.value = [
          ProductivityGoal(
            id: 'past',
            title: 'Objetivo pasado',
            targetSessions: 1,
            createdAt: DateTime(2026, 8),
            targetDate: DateTime(2026, 8, 29, 23, 59),
          ),
          ProductivityGoal(
            id: 'today',
            title: 'Objetivo de hoy',
            targetSessions: 1,
            createdAt: DateTime(2026, 8),
            targetDate: DateTime(2026, 8, 30),
          ),
          ProductivityGoal(
            id: 'future',
            title: 'Objetivo futuro',
            targetSessions: 1,
            createdAt: DateTime(2026, 8),
            targetDate: DateTime(2026, 9, 2),
          ),
          ProductivityGoal(
            id: 'undated',
            title: 'Objetivo sin fecha',
            targetSessions: 1,
            createdAt: DateTime(2026, 8),
          ),
        ];

      final available = controller.goalsOnOrAfter(
        DateTime(2026, 8, 30, 18),
      );

      expect(available.map((goal) => goal.id), ['today', 'future']);
    });
  });
}

class _MemoryGoalsRepository implements GoalsRepository {
  final List<ProductivityGoal> _goals = [];
  int _nextId = 0;

  @override
  Future<List<ProductivityGoal>> loadGoals() async {
    return List.unmodifiable(_goals);
  }

  @override
  Future<ProductivityGoal> createGoal({
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  }) async {
    final goal = ProductivityGoal(
      id: (_nextId++).toString(),
      title: title,
      targetSessions: targetSessions,
      createdAt: DateTime.now(),
      targetDate: targetDate,
    );
    _goals.insert(0, goal);
    return goal;
  }

  @override
  Future<ProductivityGoal> restoreGoal(ProductivityGoal goal) async {
    _goals.insert(0, goal);
    return goal;
  }

  @override
  Future<ProductivityGoal?> updateGoalDetails({
    required String id,
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  }) async {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index == -1) {
      return null;
    }

    final goal = _goals[index];
    final updatedGoal = goal.copyWith(
      title: title,
      targetSessions: targetSessions,
      targetDate: targetDate,
      clearTargetDate: targetDate == null,
    );
    _goals[index] = updatedGoal;
    return updatedGoal;
  }

  @override
  Future<ProductivityGoal?> updateProgress({
    required String id,
    required int completedSessions,
  }) async {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index == -1) {
      return null;
    }

    final goal = _goals[index];
    final updatedGoal = goal.copyWith(completedSessions: completedSessions);
    _goals[index] = updatedGoal;
    return updatedGoal;
  }

  @override
  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((goal) => goal.id == id);
  }
}
