import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

void main() {
  group('TasksController', () {
    test('rejects blank task titles', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());

      await controller.createTask('   ');

      final tasks = controller.tasks.value;
      final validationMessage = controller.validationMessage.value;

      expect(tasks, isEmpty);
      expect(validationMessage, 'Escribe un titulo para guardar la tarea.');
    });

    test('trims and stores valid task titles', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());

      await controller.createTask('  Revisar M2  ');

      final validationMessage = controller.validationMessage.value;
      final tasks = controller.tasks.value;
      final task = tasks.single;

      expect(validationMessage, isNull);
      expect(tasks, hasLength(1));
      expect(task.title, 'Revisar M2');
      expect(task.status, TaskStatus.listed);
      expect(task.isCompleted, isFalse);
      expect(task.scheduledDate, isNull);
      expect(task.goalId, isNull);
    });

    test('creates planned tasks with date and optional goal', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      final scheduledDate = DateTime(2026, 7, 11);

      await controller.createPlannedTask(
        rawTitle: '  Planificar V2  ',
        scheduledDate: scheduledDate,
        goalId: 'goal-1',
        durationMinutes: 45,
      );

      final task = controller.tasks.value.single;

      expect(task.title, 'Planificar V2');
      expect(task.scheduledDate, scheduledDate);
      expect(task.goalId, 'goal-1');
      expect(task.durationMinutes, 45);
      expect(task.status, TaskStatus.listed);
    });

    test('edits task titles after trimming input', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      await controller.createTask('Tarea inicial');
      final id = controller.tasks.value.single.id;

      final saved = await controller.updateTaskTitle(id, '  Tarea editada  ');

      expect(saved, isTrue);
      expect(controller.validationMessage.value, isNull);
      expect(controller.tasks.value.single.title, 'Tarea editada');
    });

    test('rejects blank edits without mutating the task', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      await controller.createTask('Tarea inicial');
      final id = controller.tasks.value.single.id;

      final saved = await controller.updateTaskTitle(id, '   ');

      expect(saved, isFalse);
      expect(controller.tasks.value.single.title, 'Tarea inicial');
      expect(
        controller.validationMessage.value,
        'Escribe un titulo para guardar la tarea.',
      );
    });

    test('toggles task completion', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      await controller.createTask('Cerrar fase 2');
      final id = controller.tasks.value.single.id;

      await controller.toggleTaskCompletion(id);

      expect(controller.tasks.value.single.isCompleted, isTrue);
      expect(controller.tasks.value.single.status, TaskStatus.completed);

      await controller.toggleTaskCompletion(id);

      expect(controller.tasks.value.single.isCompleted, isFalse);
      expect(controller.tasks.value.single.status, TaskStatus.listed);
    });

    test('updates status, schedule, and goal assignment', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      final scheduledDate = DateTime(2026, 7, 11);
      await controller.createTask('Cerrar modelo V2');
      final id = controller.tasks.value.single.id;

      await controller.updateTaskStatus(id, TaskStatus.inProgress);
      await controller.scheduleTask(id, scheduledDate);
      await controller.assignTaskToGoal(id, 'goal-2');

      var task = controller.tasks.value.single;
      expect(task.status, TaskStatus.inProgress);
      expect(task.scheduledDate, scheduledDate);
      expect(task.goalId, 'goal-2');

      await controller.scheduleTask(id, null);
      await controller.assignTaskToGoal(id, null);

      task = controller.tasks.value.single;
      expect(task.scheduledDate, isNull);
      expect(task.goalId, isNull);
    });

    test('updates task planning atomically and validates duration', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      await controller.createPlannedTask(
        rawTitle: 'Plan editable',
        scheduledDate: DateTime(2026, 7, 29),
        goalId: 'goal-1',
        durationMinutes: 45,
      );
      final id = controller.tasks.value.single.id;

      final invalid = await controller.updateTaskPlanning(
        id: id,
        goalId: null,
        durationMinutes: 0,
      );
      expect(invalid, isFalse);
      expect(controller.tasks.value.single.goalId, 'goal-1');
      expect(controller.tasks.value.single.durationMinutes, 45);

      final saved = await controller.updateTaskPlanning(
        id: id,
        goalId: null,
        durationMinutes: 73,
      );
      expect(saved, isTrue);
      expect(controller.tasks.value.single.goalId, isNull);
      expect(controller.tasks.value.single.durationMinutes, 73);
    });

    test('exposes quick tasks and planned tasks by day', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      final scheduledDate = DateTime(2026, 7, 11);

      await controller.createTask('Rapida');
      await controller.createPlannedTask(
        rawTitle: 'Planificada',
        scheduledDate: scheduledDate,
      );

      expect(controller.quickTasks(), hasLength(1));
      expect(controller.quickTasks().single.title, 'Rapida');
      expect(controller.tasksForDay(scheduledDate), hasLength(1));
      expect(controller.tasksForDay(scheduledDate).single.title, 'Planificada');
      expect(controller.plannedDaysForMonth(DateTime(2026, 7)), {11});
    });

    test('moves quick tasks to a selected day with optional goal', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      final scheduledDate = DateTime(2026, 7, 11);
      await controller.createTask('Mover a calendario');
      final id = controller.tasks.value.single.id;

      await controller.moveTaskToDay(
        id: id,
        scheduledDate: scheduledDate,
        goalId: 'goal-3',
      );

      final task = controller.tasks.value.single;
      expect(task.scheduledDate, scheduledDate);
      expect(task.goalId, 'goal-3');
      expect(controller.quickTasks(), isEmpty);
    });

    test('detaches tasks when a goal is removed', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      final scheduledDate = DateTime(2026, 7, 11);
      await controller.createPlannedTask(
        rawTitle: 'Asociada',
        scheduledDate: scheduledDate,
        goalId: 'goal-4',
      );

      expect(controller.tasksForGoal('goal-4'), hasLength(1));

      await controller.detachTasksFromGoal('goal-4');

      expect(controller.tasksForGoal('goal-4'), isEmpty);
      expect(controller.tasks.value.single.goalId, isNull);
      expect(controller.tasks.value.single.scheduledDate, scheduledDate);
    });

    test('deletes tasks by id', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      await controller.createTask('Primera');
      await controller.createTask('Segunda');
      final id = controller.tasks.value.first.id;

      await controller.deleteTask(id);

      expect(controller.tasks.value, hasLength(1));
      expect(controller.tasks.value.single.title, 'Primera');
    });

    test('filters tasks without mutating source tasks', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      await controller.createTask('Activa');
      await controller.createTask('Completada');
      final completedId = controller.tasks.value.first.id;

      await controller.toggleTaskCompletion(completedId);
      controller.selectedFilter = TaskFilter.completed;

      expect(controller.filteredTasks.value, hasLength(1));
      expect(controller.filteredTasks.value.single.title, 'Completada');

      controller.selectedFilter = TaskFilter.active;

      expect(controller.filteredTasks.value, hasLength(1));
      expect(controller.filteredTasks.value.single.title, 'Activa');
      expect(controller.tasks.value, hasLength(2));
    });

    test('summarizes task status totals by goal and unassigned work', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      final scheduledDate = DateTime(2026, 7, 11);

      await controller.createPlannedTask(
        rawTitle: 'Pendiente goal',
        scheduledDate: scheduledDate,
        goalId: 'goal-1',
      );
      await controller.createPlannedTask(
        rawTitle: 'En progreso goal',
        scheduledDate: scheduledDate,
        goalId: 'goal-1',
      );
      await controller.createTask('Completada sin objetivo');

      final inProgressId = controller.tasks.value
          .firstWhere((task) => task.title == 'En progreso goal')
          .id;
      final completedId = controller.tasks.value
          .firstWhere((task) => task.title == 'Completada sin objetivo')
          .id;

      await controller.updateTaskStatus(inProgressId, TaskStatus.inProgress);
      await controller.updateTaskStatus(completedId, TaskStatus.completed);

      final allSummary = controller.allTaskSummary.value;
      final goalSummary = controller.summaryForGoal('goal-1');
      final unassignedSummary = controller.unassignedSummary();

      expect(allSummary.listed, 1);
      expect(allSummary.inProgress, 1);
      expect(allSummary.completed, 1);
      expect(allSummary.total, 3);
      expect(goalSummary.listed, 1);
      expect(goalSummary.inProgress, 1);
      expect(goalSummary.completed, 0);
      expect(unassignedSummary.total, 1);
      expect(unassignedSummary.completionRatio, 1);
    });

    test(
      'calculates daily and weekly progress bands from planned tasks',
      () async {
        final controller = TasksController(
          repository: _MemoryTasksRepository(),
        );
        final monday = DateTime(2026, 7, 6);

        await controller.createPlannedTask(
          rawTitle: 'Lunes pendiente',
          scheduledDate: monday,
        );
        await controller.createPlannedTask(
          rawTitle: 'Lunes completada',
          scheduledDate: monday,
        );
        await controller.createPlannedTask(
          rawTitle: 'Martes completada',
          scheduledDate: monday.add(const Duration(days: 1)),
        );

        final completedIds = controller.tasks.value
            .where((task) => task.title.contains('completada'))
            .map((task) => task.id);
        for (final id in completedIds) {
          await controller.updateTaskStatus(id, TaskStatus.completed);
        }

        final mondayProgress = controller.progressForDay(monday);
        final weekProgress = controller.progressForWeek(monday);

        expect(mondayProgress.completionRatio, 0.5);
        expect(mondayProgress.band, TaskProgressBand.yellow);
        expect(weekProgress, hasLength(7));
        expect(weekProgress.first.day, monday);
        expect(weekProgress.first.summary.total, 2);
        expect(weekProgress[1].band, TaskProgressBand.strongGreen);
        expect(taskProgressBandForRatio(0), TaskProgressBand.red);
        expect(taskProgressBandForRatio(0.7), TaskProgressBand.green);
        expect(taskProgressBandForRatio(0.71), TaskProgressBand.strongGreen);
      },
    );

    test('marks a day as ended without changing task progress', () async {
      final controller = TasksController(repository: _MemoryTasksRepository());
      final day = DateTime(2026, 7, 11);
      await controller.createPlannedTask(
        rawTitle: 'Planificada',
        scheduledDate: day,
      );

      expect(controller.progressForDay(day).isEnded, isFalse);

      controller.endDay(day);

      final progress = controller.progressForDay(day);
      expect(progress.isEnded, isTrue);
      expect(progress.summary.total, 1);
      expect(progress.band, TaskProgressBand.red);
    });
  });
}

class _MemoryTasksRepository implements TasksRepository {
  final List<Task> _tasks = [];
  int _nextId = 0;

  @override
  Future<List<Task>> loadTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> createTask(String title) async {
    final task = Task(
      id: (_nextId++).toString(),
      title: title,
      createdAt: DateTime.now(),
    );
    _tasks.insert(0, task);
    return task;
  }

  @override
  Future<Task> createPlannedTask({
    required String title,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) async {
    final task = Task(
      id: (_nextId++).toString(),
      title: title,
      createdAt: DateTime.now(),
      scheduledDate: scheduledDate,
      goalId: goalId,
      durationMinutes: durationMinutes,
    );
    _tasks.insert(0, task);
    return task;
  }

  @override
  Future<Task?> updateTaskTitle(String id, String title) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return null;
    }

    final updatedTask = _tasks[index].copyWith(title: title);
    _tasks[index] = updatedTask;
    return updatedTask;
  }

  @override
  Future<Task?> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return null;
    }

    final task = _tasks[index];
    final updatedTask = task.copyWith(
      status: task.isCompleted ? TaskStatus.listed : TaskStatus.completed,
    );
    _tasks[index] = updatedTask;
    return updatedTask;
  }

  @override
  Future<Task?> updateTaskStatus(String id, TaskStatus status) async {
    return _updateTask(id, (task) => task.copyWith(status: status));
  }

  @override
  Future<Task?> scheduleTask(String id, DateTime? scheduledDate) async {
    return _updateTask(
      id,
      (task) => task.copyWith(
        scheduledDate: scheduledDate,
        clearScheduledDate: scheduledDate == null,
      ),
    );
  }

  @override
  Future<Task?> assignTaskToGoal(String id, String? goalId) async {
    return _updateTask(
      id,
      (task) => task.copyWith(
        goalId: goalId,
        clearGoalId: goalId == null,
      ),
    );
  }

  @override
  Future<Task?> updateTaskPlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
  }) async {
    return _updateTask(
      id,
      (task) => task.copyWith(
        goalId: goalId,
        clearGoalId: goalId == null,
        durationMinutes: durationMinutes,
      ),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  Task? _updateTask(String id, Task Function(Task task) update) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return null;
    }

    final updatedTask = update(_tasks[index]);
    _tasks[index] = updatedTask;
    return updatedTask;
  }
}
