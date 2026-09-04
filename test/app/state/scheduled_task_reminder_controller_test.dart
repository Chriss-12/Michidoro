import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/scheduled_task_reminder_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/pages/goals_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

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

    test('groups a reminder by goal with all task status counts', () async {
      final settingsController = AppSettingsController();
      final goalsController =
          GoalsController(repository: _FakeGoalsRepository())
            ..goals.value = [
              ProductivityGoal(
                id: 'goal-1',
                title: 'Preparar lanzamiento',
                targetSessions: 8,
                createdAt: DateTime(2026, 7),
              ),
            ];
      final tasksController =
          TasksController(repository: _FakeTasksRepository())
            ..tasks.value = [
              Task(
                id: 'task-pending',
                title: 'Revisar alcance',
                createdAt: DateTime(2026, 7, 17),
                scheduledDate: DateTime(2026, 7, 18),
                goalId: 'goal-1',
              ),
              Task(
                id: 'task-progress',
                title: 'Preparar versión',
                createdAt: DateTime(2026, 7, 17),
                scheduledDate: DateTime(2026, 7, 18),
                goalId: 'goal-1',
                status: TaskStatus.inProgress,
              ),
              Task(
                id: 'task-completed',
                title: 'Definir objetivo',
                createdAt: DateTime(2026, 7, 16),
                scheduledDate: DateTime(2026, 7, 17),
                goalId: 'goal-1',
                status: TaskStatus.completed,
              ),
            ];
      final reminderController = ScheduledTaskReminderController(
        settingsController: settingsController,
        tasksController: tasksController,
        goalsController: goalsController,
      );

      await reminderController.checkNow(
        now: DateTime(2026, 7, 18, 9),
        playFeedback: false,
      );

      final notification = settingsController.notifications.value.single;
      expect(notification.title, 'Preparar lanzamiento');
      expect(notification.goalId, 'goal-1');
      expect(notification.taskId, 'task-pending');
      expect(notification.pendingCount, 1);
      expect(notification.inProgressCount, 1);
      expect(notification.completedCount, 1);
      expect(notification.routePath, contains(GoalsPage.routePath));
      expect(notification.routePath, contains('goalId=goal-1'));
      expect(notification.routePath, contains('taskId=task-pending'));
    });

    test('uses English without translating user task titles', () async {
      final settingsController = AppSettingsController()
        ..language.value = AppLanguage.english;
      final tasksController =
          TasksController(repository: _FakeTasksRepository())
            ..tasks.value = [
              Task(
                id: 'task-english',
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

      final notification = settingsController.notifications.value.single;
      expect(notification.title, 'Task scheduled for today');
      expect(notification.body, 'Pending: Preparar informe.');
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

class _FakeGoalsRepository implements GoalsRepository {
  @override
  Future<ProductivityGoal> createGoal({
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteGoal(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductivityGoal>> loadGoals() async => const [];

  @override
  Future<ProductivityGoal> restoreGoal(ProductivityGoal goal) {
    throw UnimplementedError();
  }

  @override
  Future<ProductivityGoal?> updateGoalDetails({
    required String id,
    required String title,
    required int targetSessions,
    DateTime? targetDate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ProductivityGoal?> updateProgress({
    required String id,
    required int completedSessions,
  }) {
    throw UnimplementedError();
  }
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
  Future<Task> createTask(String title, {int? durationMinutes}) {
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

  @override
  Future<Task?> updateTaskPlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
  }) {
    throw UnimplementedError();
  }
}
