import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

import 'package:pomodoro_app_v1/main.dart';

void main() {
  testWidgets('App shows stitched views', (tester) async {
    await tester.binding.setSurfaceSize(const Size(480, 1800));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    if (!serviceLocator.isRegistered<GoalsController>()) {
      serviceLocator.registerSingleton<GoalsController>(
        GoalsController(repository: _MemoryGoalsRepository()),
      );
    }
    if (!serviceLocator.isRegistered<PomodoroController>()) {
      serviceLocator.registerSingleton<PomodoroController>(
        PomodoroController(repository: _MemoryPomodoroSessionsRepository()),
      );
    }
    if (!serviceLocator.isRegistered<CalendarController>()) {
      serviceLocator.registerSingleton<CalendarController>(
        CalendarController(repository: _MemoryCalendarEventsRepository()),
      );
    }
    if (!serviceLocator.isRegistered<TasksController>()) {
      serviceLocator.registerSingleton<TasksController>(
        TasksController(repository: _MemoryTasksRepository()),
      );
    }
    await serviceLocator<TasksController>().createTask('Tarea rapida V2');

    await tester.pumpWidget(const MyApp());

    expect(find.text('MichiDoro'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Chriss'), findsOneWidget);
    expect(find.text('Planificacion'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Completadas'), findsWidgets);

    await tester.tap(find.byTooltip('Abrir calendario'));
    await tester.pumpAndSettle();
    expect(find.text('Calendario'), findsOneWidget);
    expect(find.byTooltip('Mes siguiente'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Hola, Chriss'), findsOneWidget);
    expect(find.text('Planificacion'), findsOneWidget);

    await tester.tap(find.byTooltip('Abrir calendario'));
    await tester.pumpAndSettle();
    expect(find.text('Calendario'), findsOneWidget);

    await tester.tap(find.byTooltip('Mas acciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear objetivo'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Objetivo para'), findsOneWidget);
    expect(find.textContaining('pomodoros'), findsNothing);
    await tester.enterText(find.byType(TextField).last, 'Objetivo V2');
    await tester.tap(find.text('Crear'));
    await tester.pumpAndSettle();
    expect(find.text('Objetivo V2'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    expect(find.text('Crear nueva tarea'), findsOneWidget);
    expect(find.text('Duracion'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'Tarea V2');
    await tester.tap(find.text('Crear'));
    await tester.pumpAndSettle();
    expect(find.text('Tarea V2'), findsOneWidget);
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.text('25 min'), findsOneWidget);
    expect(find.text('0/1'), findsOneWidget);
    await tester.tap(find.text('0/1'));
    await tester.pumpAndSettle();
    expect(find.text('En progreso'), findsWidgets);
    expect(find.text('Completada'), findsWidgets);
    await tester.tap(find.text('Pendiente').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Mas acciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Asignar tarea rapida'));
    await tester.pumpAndSettle();
    expect(find.text('Asignar tarea rapida'), findsOneWidget);
    await tester.tap(find.text('Asignar'));
    await tester.pumpAndSettle();
    expect(find.text('Tarea rapida V2'), findsOneWidget);
    expect(find.text('0/2'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byTooltip('Opciones de tarea').first);
    await tester.tap(find.byTooltip('Opciones de tarea').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar tarea').last);
    await tester.pumpAndSettle();
    expect(find.text('Eliminar tarea'), findsOneWidget);
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(find.text('Tarea V2'), findsNothing);
    expect(find.text('Tarea rapida V2'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Opciones de objetivo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar objetivo'));
    await tester.pumpAndSettle();
    expect(find.text('Eliminar objetivo'), findsOneWidget);
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(find.text('Deshacer'), findsOneWidget);
    await tester.tap(find.text('Deshacer'));
    await tester.pumpAndSettle();
    expect(find.text('Objetivo V2'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byTooltip('Opciones de tarea').first);
    await tester.tap(find.byTooltip('Opciones de tarea').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empezar Pomodoro'));
    await tester.pumpAndSettle();
    expect(find.text('Empezar Pomodoro'), findsOneWidget);
    await tester.tap(find.text('25 min enfoque / 5 min descanso'));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('MODO ENFOQUE'), findsOneWidget);
    expect(find.text('Enfoque actual'), findsOneWidget);
    expect(find.textContaining('Tarea'), findsWidgets);

    await tester.tap(find.text('Goals'));
    await tester.pumpAndSettle();
    expect(find.text('Mis metas'), findsOneWidget);
    expect(find.text('Progreso general'), findsOneWidget);
    expect(find.text('Tareas sin objetivo'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(find.text('Apariencia'), findsOneWidget);
    expect(find.textContaining('Nature Focus'), findsWidgets);
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
      id: 'test-goal-${_nextId++}',
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

    final updatedGoal = ProductivityGoal(
      id: id,
      title: title,
      targetSessions: targetSessions,
      createdAt: DateTime.now(),
      targetDate: targetDate,
    );
    _goals[index] = updatedGoal;
    return updatedGoal;
  }

  @override
  Future<ProductivityGoal?> updateProgress({
    required String id,
    required int completedSessions,
  }) async {
    return null;
  }

  @override
  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((goal) => goal.id == id);
  }
}

class _MemoryPomodoroSessionsRepository implements PomodoroSessionsRepository {
  @override
  Future<List<PomodoroSession>> loadSessions() async {
    return const [];
  }

  @override
  Future<PomodoroSession> saveCompletedSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedSeconds,
    required int focusedSeconds,
    String? goalId,
    String? taskId,
    int? startMoodScore,
  }) async {
    return PomodoroSession(
      id: 'test-session',
      startedAt: startedAt,
      endedAt: endedAt,
      plannedSeconds: plannedSeconds,
      focusedSeconds: focusedSeconds,
      status: PomodoroSessionStatus.completed,
      goalId: goalId,
      taskId: taskId,
      startMoodScore: startMoodScore,
    );
  }

  @override
  Future<PomodoroSession> updateSessionReflection({
    required String sessionId,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) async {
    return PomodoroSession(
      id: sessionId,
      startedAt: DateTime(2026),
      endedAt: DateTime(2026),
      plannedSeconds: 1500,
      focusedSeconds: 1500,
      status: PomodoroSessionStatus.completed,
      endMoodScore: endMoodScore,
      wasDistracted: wasDistracted,
      distractionMinutes: distractionMinutes,
    );
  }
}

class _MemoryCalendarEventsRepository implements CalendarEventsRepository {
  @override
  Future<List<CalendarEvent>> loadEvents() async {
    return const [];
  }

  @override
  Future<CalendarEvent> createEvent({
    required String title,
    required DateTime scheduledAt,
    required int durationMinutes,
  }) async {
    return CalendarEvent(
      id: 'test-calendar-event',
      title: title,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      createdAt: DateTime.now(),
    );
  }
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
      id: 'test-task-${_nextId++}',
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
      id: 'test-task-${_nextId++}',
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
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<Task?> updateTaskTitle(String id, String title) async {
    return _updateTask(id, (task) => task.copyWith(title: title));
  }

  @override
  Future<Task?> toggleTaskCompletion(String id) async {
    return _updateTask(
      id,
      (task) => task.copyWith(
        status: task.isCompleted ? TaskStatus.listed : TaskStatus.completed,
      ),
    );
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
