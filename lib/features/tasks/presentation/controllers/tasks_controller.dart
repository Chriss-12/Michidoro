import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum TaskFilter { all, active, completed }

class TasksController {
  TasksController({required TasksRepository repository})
    : _repository = repository;

  final TasksRepository _repository;
  final FlutterSignal<List<Task>> tasks = signal(const []);
  final FlutterSignal<TaskFilter> filter = signal(TaskFilter.all);
  final FlutterSignal<String?> validationMessage = signal(null);
  final FlutterSignal<bool> isLoading = signal(false);
  late final Computed<List<Task>> filteredTasks = computed<List<Task>>(() {
    final currentTasks = tasks.value;

    return switch (filter.value) {
      TaskFilter.all => currentTasks,
      TaskFilter.active =>
        currentTasks.where((task) => !task.isCompleted).toList(growable: false),
      TaskFilter.completed =>
        currentTasks.where((task) => task.isCompleted).toList(growable: false),
    };
  });

  TaskFilter get selectedFilter => filter.value;

  Future<void> loadTasks() async {
    isLoading.value = true;
    tasks.value = await _repository.loadTasks();
    isLoading.value = false;
  }

  Future<bool> createTask(String rawTitle) async {
    final title = rawTitle.trim();

    if (title.isEmpty) {
      validationMessage.value = 'Escribe un titulo para guardar la tarea.';
      return false;
    }

    final task = await _repository.createTask(title);

    tasks.value = [task, ...tasks.value];
    validationMessage.value = null;
    return true;
  }

  Future<bool> updateTaskTitle(String id, String rawTitle) async {
    final title = rawTitle.trim();

    if (title.isEmpty) {
      validationMessage.value = 'Escribe un titulo para guardar la tarea.';
      return false;
    }

    final updatedTask = await _repository.updateTaskTitle(id, title);
    if (updatedTask == null) {
      return false;
    }

    _replaceTask(updatedTask);
    validationMessage.value = null;
    return true;
  }

  Future<void> toggleTaskCompletion(String id) async {
    final updatedTask = await _repository.toggleTaskCompletion(id);
    if (updatedTask == null) {
      return;
    }

    _replaceTask(updatedTask);
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    tasks.value = tasks.value
        .where((task) => task.id != id)
        .toList(growable: false);
  }

  set selectedFilter(TaskFilter value) {
    filter.value = value;
  }

  void clearValidationMessage() {
    if (validationMessage.value == null) {
      return;
    }

    validationMessage.value = null;
  }

  void _replaceTask(Task updatedTask) {
    tasks.value = [
      for (final task in tasks.value)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }
}
