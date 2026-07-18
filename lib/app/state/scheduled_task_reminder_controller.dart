import 'dart:async';

import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

class ScheduledTaskReminderController {
  ScheduledTaskReminderController({
    required AppSettingsController settingsController,
    required TasksController tasksController,
    Duration checkInterval = const Duration(minutes: 1),
  }) : _settingsController = settingsController,
       _tasksController = tasksController,
       _checkInterval = checkInterval;

  final AppSettingsController _settingsController;
  final TasksController _tasksController;
  final Duration _checkInterval;
  final Set<String> _notifiedTaskKeys = {};

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) {
      unawaited(checkNow());
    });
    unawaited(
      Future<void>.delayed(const Duration(seconds: 2), checkNow),
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
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

    _settingsController.addNotification(
      title: _titleFor(newTasks.length),
      body: _bodyFor(newTasks),
      routePath: CalendarPage.routePath,
    );

    if (playFeedback) {
      await _settingsController.playCompletionFeedback();
    }
  }

  String _taskKey(Task task, DateTime day) {
    return '${_dateKey(day)}:${task.id}';
  }

  String _titleFor(int count) {
    return count == 1
        ? 'Tarea programada para hoy'
        : 'Tareas programadas para hoy';
  }

  String _bodyFor(List<Task> tasks) {
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
