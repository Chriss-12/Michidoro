import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/scheduled_task_reminder_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

void main() {
  group('ScheduledTaskReminderController', () {
    test('notifies pending planned tasks for today', () async {
      final settingsController = AppSettingsController();
      final tasksController =
          TasksController(repository: _FakeTasksRepository())
            ..tasks.value = [
              Task(
                id: 'task-1',
                title: 'Preparar informe',
                createdAt: DateTime(2026, 7, 17),
                scheduledDate: DateTime(2026, 7, 18),
              ),
            ];
      final reminderController = ScheduledTaskReminderController(
        settingsController: settingsController,
        tasksController: tasksController,
      );

      await reminderController.checkNow(
        now: DateTime(2026, 7, 18, 9),
        playFeedback: false,
      );

      expect(settingsController.notifications.value, hasLength(1));
      expect(
        settingsController.notifications.value.single.title,
        'Tarea programada para hoy',
      );
      expect(
        settingsController.notifications.value.single.body,
        contains('Preparar informe'),
      );
      expect(
        settingsController.notifications.value.single.routePath,
        CalendarPage.routePath,
      );
    });

    test('does not duplicate reminders for the same day and task', () async {
      final settingsController = AppSettingsController();
      final tasksController =
          TasksController(repository: _FakeTasksRepository())
            ..tasks.value = [
              Task(
                id: 'task-1',
                title: 'Preparar informe',
                createdAt: DateTime(2026, 7, 17),
                scheduledDate: DateTime(2026, 7, 18),
              ),
            ];
      final reminderController = ScheduledTaskReminderController(
        settingsController: settingsController,
        tasksController: tasksController,
      );

      await reminderController.checkNow(
        now: DateTime(2026, 7, 18, 9),
        playFeedback: false,
      );
      await reminderController.checkNow(
        now: DateTime(2026, 7, 18, 10),
        playFeedback: false,
      );

      expect(settingsController.notifications.value, hasLength(1));
    });

    test('does not notify when notifications are disabled', () async {
      final settingsController = AppSettingsController()
        ..notificationsEnabled.value = false;
      final tasksController =
          TasksController(repository: _FakeTasksRepository())
            ..tasks.value = [
              Task(
                id: 'task-1',
                title: 'Preparar informe',
                createdAt: DateTime(2026, 7, 17),
                scheduledDate: DateTime(2026, 7, 18),
              ),
            ];
      final reminderController = ScheduledTaskReminderController(
        settingsController: settingsController,
        tasksController: tasksController,
      );

      await reminderController.checkNow(
        now: DateTime(2026, 7, 18, 9),
        playFeedback: false,
      );

      expect(settingsController.notifications.value, isEmpty);
    });
  });
}

class _FakeTasksRepository implements TasksRepository {
  @override
  Future<Task?> assignTaskToGoal(String id, String? goalId) {
    throw UnimplementedError();
  }

  @override
  Future<Task> createPlannedTask({
    required String title,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Task> createTask(String title) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> loadTasks() {
    throw UnimplementedError();
  }

  @override
  Future<Task?> scheduleTask(String id, DateTime? scheduledDate) {
    throw UnimplementedError();
  }

  @override
  Future<Task?> toggleTaskCompletion(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Task?> updateTaskStatus(String id, TaskStatus status) {
    throw UnimplementedError();
  }

  @override
  Future<Task?> updateTaskTitle(String id, String title) {
    throw UnimplementedError();
  }
}
