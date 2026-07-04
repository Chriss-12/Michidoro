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
      expect(task.isCompleted, isFalse);
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

      await controller.toggleTaskCompletion(id);

      expect(controller.tasks.value.single.isCompleted, isFalse);
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
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    _tasks[index] = updatedTask;
    return updatedTask;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
}
