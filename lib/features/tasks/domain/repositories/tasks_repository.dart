import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

abstract class TasksRepository {
  Future<List<Task>> loadTasks();

  Future<Task> createTask(String title);

  Future<Task> createPlannedTask({
    required String title,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  });

  Future<Task?> updateTaskTitle(String id, String title);

  Future<Task?> toggleTaskCompletion(String id);

  Future<Task?> updateTaskStatus(String id, TaskStatus status);

  Future<Task?> scheduleTask(String id, DateTime? scheduledDate);

  Future<Task?> assignTaskToGoal(String id, String? goalId);

  Future<void> deleteTask(String id);
}
