import 'dart:async';

import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/pages/goals_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

class ScheduledTaskReminderController {
  ScheduledTaskReminderController({
    required AppSettingsController settingsController,
    required TasksController tasksController,
    GoalsController? goalsController,
    Duration checkInterval = const Duration(minutes: 1),
  }) : _settingsController = settingsController,
       _tasksController = tasksController,
       _goalsController = goalsController,
       _checkInterval = checkInterval;

  final AppSettingsController _settingsController;
  final TasksController _tasksController;
  final GoalsController? _goalsController;
  final Duration _checkInterval;
  final Set<String> _notifiedTaskKeys = {};

  Timer? _timer;
  Timer? _initialCheckTimer;

  void start() {
    _timer?.cancel();
    _initialCheckTimer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) {
      unawaited(checkNow());
    });
    _initialCheckTimer = Timer(const Duration(seconds: 2), () {
      _initialCheckTimer = null;
      unawaited(checkNow());
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _initialCheckTimer?.cancel();
    _initialCheckTimer = null;
  }

  Future<void> checkNow({
    DateTime? now,
    bool playFeedback = true,
  }) async {
    if (!_settingsController.notificationsEnabled.value ||
        !_settingsController.focusAlertsEnabled.value) {
      return;
    }

    final today = _dateOnly(now ?? DateTime.now());
    final pendingTasks = _tasksController
        .tasksForDay(today)
        .where((task) => !task.isCompleted)
        .toList(growable: false);
    final newTasks = pendingTasks
        .where((task) => !_notifiedTaskKeys.contains(_taskKey(task, today)))
        .toList(growable: false);

    if (newTasks.isEmpty) {
      return;
    }

    for (final task in newTasks) {
      _notifiedTaskKeys.add(_taskKey(task, today));
    }

    _publishNotifications(newTasks);

    if (playFeedback) {
      await _settingsController.playCompletionFeedback();
    }
  }

  void _publishNotifications(List<Task> newTasks) {
    final groupedByGoal = <String, List<Task>>{};
    final genericTasks = <Task>[];

    for (final task in newTasks) {
      final goal = _goalsController?.goalById(task.goalId);
      if (goal == null) {
        genericTasks.add(task);
        continue;
      }

      groupedByGoal.putIfAbsent(goal.id, () => <Task>[]).add(task);
    }

    for (final entry in groupedByGoal.entries) {
      final goal = _goalsController?.goalById(entry.key);
      if (goal == null) {
        genericTasks.addAll(entry.value);
        continue;
      }

      final goalTasks = _tasksController.tasks.value
          .where((task) => task.goalId == goal.id)
          .toList(growable: false);
      final firstTask = entry.value.first;
      _settingsController.addNotification(
        title: goal.title,
        body: firstTask.title,
        routePath: Uri(
          path: GoalsPage.routePath,
          queryParameters: {
            'goalId': goal.id,
            'taskId': firstTask.id,
          },
        ).toString(),
        goalId: goal.id,
        taskId: firstTask.id,
        pendingCount: _countStatus(goalTasks, TaskStatus.listed),
        inProgressCount: _countStatus(goalTasks, TaskStatus.inProgress),
        completedCount: _countStatus(goalTasks, TaskStatus.completed),
      );
    }

    if (genericTasks.isNotEmpty) {
      _settingsController.addNotification(
        title: _titleFor(genericTasks.length),
        body: _bodyFor(genericTasks),
        routePath: CalendarPage.routePath,
      );
    }
  }

  int _countStatus(List<Task> tasks, TaskStatus status) {
    return tasks.where((task) => task.status == status).length;
  }

  String _taskKey(Task task, DateTime day) {
    return '${_dateKey(day)}:${task.id}';
  }

  String _titleFor(int count) {
    if (_settingsController.language.value == AppLanguage.english) {
      return count == 1 ? 'Task scheduled for today' : 'Tasks scheduled today';
    }

    return count == 1
        ? 'Tarea programada para hoy'
        : 'Tareas programadas para hoy';
  }

  String _bodyFor(List<Task> tasks) {
    if (_settingsController.language.value == AppLanguage.english) {
      if (tasks.length == 1) {
        return 'Pending: ${tasks.single.title}.';
      }

      return 'You have ${tasks.length} pending tasks. Start with: ${tasks.first.title}.';
    }

    if (tasks.length == 1) {
      return 'Tienes pendiente: ${tasks.single.title}.';
    }

    return 'Tienes ${tasks.length} tareas pendientes. Empieza por: ${tasks.first.title}.';
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _dateKey(DateTime date) {
    final normalized = _dateOnly(date);

    return '${normalized.year}-${normalized.month.toString().padLeft(2, '0')}-${normalized.day.toString().padLeft(2, '0')}';
  }
}
