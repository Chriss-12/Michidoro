import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

abstract class TasksRepository {
  Future<List<Task>> loadTasks();

  Future<Task> createTask(String title);

  Future<Task?> updateTaskTitle(String id, String title);

  Future<Task?> toggleTaskCompletion(String id);

  Future<void> deleteTask(String id);
}
