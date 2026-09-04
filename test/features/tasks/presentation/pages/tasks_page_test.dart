import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  setUp(() async {
    await serviceLocator.reset();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('applies one month filter to all status counts', (tester) async {
    final controller =
        TasksController(
            repository: _UnusedTasksRepository(),
            now: () => DateTime(2026, 8, 24),
          )
          ..tasks.value = [
            Task(
              id: 'july-active',
              title: 'Julio activa',
              createdAt: DateTime(2026),
              scheduledDate: DateTime(2026, 7, 5),
            ),
            Task(
              id: 'july-completed',
              title: 'Julio hecha',
              createdAt: DateTime(2026),
              scheduledDate: DateTime(2026, 7, 20),
              status: TaskStatus.completed,
            ),
            Task(
              id: 'august-active',
              title: 'Agosto activa',
              createdAt: DateTime(2026),
              scheduledDate: DateTime(2026, 8, 2),
            ),
          ];
    serviceLocator.registerSingleton<TasksController>(controller);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const Scaffold(body: TasksPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('24 agosto 2026'), findsOneWidget);
    expect(find.text('Todas (0)'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('task-temporal-filter-button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Un día'), findsOneWidget);
    expect(find.text('Un mes'), findsOneWidget);
    expect(find.text('Un año'), findsOneWidget);
    expect(find.text('Rango personalizado'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('task-filter-month')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('task-filter-month-7')));
    await tester.pumpAndSettle();

    expect(controller.temporalFilter.value.kind, TaskTemporalFilterKind.month);
    expect(find.text('julio 2026'), findsOneWidget);
    expect(find.text('Todas (2)'), findsOneWidget);
    expect(find.text('Activas (1)'), findsOneWidget);
    expect(find.text('Hechas (1)'), findsOneWidget);
    expect(find.text('Julio activa'), findsOneWidget);
    expect(find.text('Julio hecha'), findsOneWidget);
    expect(find.text('Agosto activa'), findsNothing);

    await tester.drag(
      find.byKey(const ValueKey('task-status-filter-scroll')),
      const Offset(-240, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hechas (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Julio hecha'), findsOneWidget);
    expect(find.text('Julio activa'), findsNothing);
    expect(controller.temporalFilter.value.kind, TaskTemporalFilterKind.month);
  });

  testWidgets('filters tasks by goal and defaults to all goals', (
    tester,
  ) async {
    final now = DateTime(2026, 8, 24);
    final tasksController =
        TasksController(
            repository: _UnusedTasksRepository(),
            now: () => now,
          )
          ..tasks.value = [
            Task(
              id: 'alpha-active',
              title: 'Alfa activa',
              createdAt: now,
              goalId: 'goal-alpha',
            ),
            Task(
              id: 'alpha-done',
              title: 'Alfa hecha',
              createdAt: now,
              goalId: 'goal-alpha',
              status: TaskStatus.completed,
            ),
            Task(
              id: 'beta-active',
              title: 'Beta activa',
              createdAt: now,
              goalId: 'goal-beta',
            ),
            Task(
              id: 'unassigned',
              title: 'Sin objetivo',
              createdAt: now,
            ),
          ];
    final goalsController =
        GoalsController(repository: _UnusedGoalsRepository())
          ..goals.value = [
            ProductivityGoal(
              id: 'goal-alpha',
              title: 'Objetivo Alfa',
              targetSessions: 2,
              createdAt: now,
            ),
            ProductivityGoal(
              id: 'goal-beta',
              title: 'Objetivo Beta',
              targetSessions: 2,
              createdAt: now,
            ),
          ];
    serviceLocator
      ..registerSingleton<TasksController>(tasksController)
      ..registerSingleton<GoalsController>(goalsController);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const Scaffold(body: TasksPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tasksController.selectedGoalId, isNull);
    expect(find.text('Todos los objetivos'), findsOneWidget);
    expect(find.text('Todas (4)'), findsOneWidget);
    expect(find.text('Alfa activa'), findsOneWidget);
    expect(find.text('Beta activa'), findsOneWidget);
    expect(find.text('Sin objetivo'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('task-goal-filter')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('task-goal-filter-goal-alpha')).last,
    );
    await tester.pumpAndSettle();

    expect(tasksController.selectedGoalId, 'goal-alpha');
    expect(find.text('Todas (2)'), findsOneWidget);
    expect(find.text('Activas (1)'), findsOneWidget);
    expect(find.text('Hechas (1)'), findsOneWidget);
    expect(find.text('Alfa activa'), findsOneWidget);
    expect(find.text('Alfa hecha'), findsOneWidget);
    expect(find.text('Beta activa'), findsNothing);
    expect(find.text('Sin objetivo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'shows status duration goal and focused progress in the task card',
    (tester) async {
      final now = DateTime(2026, 8, 24, 10);
      final tasksController =
          TasksController(
              repository: _UnusedTasksRepository(),
              now: () => now,
            )
            ..tasks.value = [
              Task(
                id: 'today-task',
                title: 'Preparar entrega',
                createdAt: now,
                scheduledDate: DateTime(2026, 8, 24),
                status: TaskStatus.inProgress,
                durationMinutes: 50,
                goalId: 'goal-1',
              ),
            ];
      final goalsController =
          GoalsController(
              repository: _UnusedGoalsRepository(),
            )
            ..goals.value = [
              ProductivityGoal(
                id: 'goal-1',
                title: 'Lanzar versión',
                targetSessions: 4,
                createdAt: now,
              ),
            ];
      final pomodoroController =
          PomodoroController(
              repository: _UnusedPomodoroRepository(),
            )
            ..sessions.value = [
              PomodoroSession(
                id: 'session-1',
                startedAt: now.subtract(const Duration(minutes: 25)),
                endedAt: now,
                plannedSeconds: 25 * 60,
                focusedSeconds: 25 * 60,
                status: PomodoroSessionStatus.completed,
                taskId: 'today-task',
              ),
            ];
      addTearDown(pomodoroController.dispose);
      serviceLocator
        ..registerSingleton<TasksController>(tasksController)
        ..registerSingleton<GoalsController>(goalsController)
        ..registerSingleton<PomodoroController>(pomodoroController);
      await tester.binding.setSurfaceSize(const Size(320, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.dark(),
          home: const Scaffold(body: TasksPage()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(ListView).first,
        const Offset(0, -420),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('planned-task-card-today-task')),
        findsOneWidget,
      );
      expect(find.text('En progreso'), findsOneWidget);
      expect(find.text('50 min'), findsOneWidget);
      expect(find.text('Lanzar versión'), findsOneWidget);
      expect(find.text('25/50 min'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.byTooltip('Opciones de tarea'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'searches current and future goals and creates a dated assigned task',
    (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final future = today.add(const Duration(days: 5));
      final repository = _CreatingTasksRepository(now: now);
      final tasksController = TasksController(
        repository: repository,
        now: () => now,
      );
      final goalsController =
          GoalsController(repository: _UnusedGoalsRepository())
            ..goals.value = [
              ProductivityGoal(
                id: 'past',
                title: 'Objetivo pasado',
                targetSessions: 1,
                createdAt: now,
                targetDate: today.subtract(const Duration(days: 1)),
              ),
              ProductivityGoal(
                id: 'today',
                title: 'Objetivo de hoy',
                targetSessions: 1,
                createdAt: now,
                targetDate: today,
              ),
              ProductivityGoal(
                id: 'future',
                title: 'Objetivo Futuro',
                targetSessions: 1,
                createdAt: now,
                targetDate: future,
              ),
              ProductivityGoal(
                id: 'undated',
                title: 'Objetivo sin fecha',
                targetSessions: 1,
                createdAt: now,
              ),
            ];
      serviceLocator
        ..registerSingleton<TasksController>(tasksController)
        ..registerSingleton<GoalsController>(goalsController);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const Scaffold(body: TasksPage()),
        ),
      );
      await tester.pumpAndSettle();

      final taskTitleField = tester.widget<TextField>(
        find.byKey(const ValueKey('task-create-title')),
      );
      expect(taskTitleField.keyboardType, TextInputType.multiline);
      expect(taskTitleField.textInputAction, TextInputAction.newline);
      expect(taskTitleField.minLines, 1);
      expect(taskTitleField.maxLines, 2);

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('task-create-goal-selector')),
          matching: find.text('Sin objetivo'),
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<ChoiceChip>(
              find.byKey(const ValueKey('task-create-duration-25')),
            )
            .selected,
        isTrue,
      );
      await tester.tap(
        find.byKey(const ValueKey('task-create-duration-60')),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('task-create-goal-selector')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Objetivo pasado'), findsNothing);
      expect(find.text('Objetivo sin fecha'), findsNothing);
      expect(find.text('Objetivo de hoy'), findsOneWidget);
      expect(find.text('Objetivo Futuro'), findsOneWidget);
      expect(
        find.byKey(
          const ValueKey('speech-input-task-create-goal-search'),
        ),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const ValueKey('task-create-goal-search')),
        'fúturo',
      );
      await tester.pump();

      expect(find.text('Objetivo de hoy'), findsNothing);
      expect(find.text('Objetivo Futuro'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('task-create-goal-option-future')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('task-create-title')),
        'Preparar lanzamiento',
      );
      await tester.tap(find.text('Agregar tarea'));
      await tester.pumpAndSettle();

      expect(repository.createdTask?.title, 'Preparar lanzamiento');
      expect(repository.createdTask?.goalId, 'future');
      expect(repository.createdTask?.scheduledDate, future);
      expect(repository.createdTask?.durationMinutes, 60);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('task-create-goal-selector')),
          matching: find.text('Sin objetivo'),
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<ChoiceChip>(
              find.byKey(const ValueKey('task-create-duration-25')),
            )
            .selected,
        isTrue,
      );

      await tester.tap(
        find.byKey(const ValueKey('task-create-duration-90')),
      );
      await tester.enterText(
        find.byKey(const ValueKey('task-create-title')),
        'Tarea rápida larga',
      );
      await tester.tap(find.text('Agregar tarea'));
      await tester.pumpAndSettle();

      expect(repository.createdTask?.title, 'Tarea rápida larga');
      expect(repository.createdTask?.goalId, isNull);
      expect(repository.createdTask?.scheduledDate, isNull);
      expect(repository.createdTask?.durationMinutes, 90);
      expect(tester.takeException(), isNull);
    },
  );
}

class _UnusedGoalsRepository extends Fake implements GoalsRepository {}

class _UnusedPomodoroRepository extends Fake
    implements PomodoroSessionsRepository {}

class _UnusedTasksRepository implements TasksRepository {
  Never _unused() => throw UnimplementedError();

  @override
  Future<Task?> assignTaskToGoal(String id, String? goalId) => _unused();

  @override
  Future<Task> createPlannedTask({
    required String title,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) => _unused();

  @override
  Future<Task> createTask(String title, {int? durationMinutes}) => _unused();

  @override
  Future<void> deleteTask(String id) => _unused();

  @override
  Future<List<Task>> loadTasks() => _unused();

  @override
  Future<Task?> scheduleTask(String id, DateTime? scheduledDate) => _unused();

  @override
  Future<Task?> toggleTaskCompletion(String id) => _unused();

  @override
  Future<Task?> updateTaskPlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
  }) => _unused();

  @override
  Future<Task?> updateTaskStatus(String id, TaskStatus status) => _unused();

  @override
  Future<Task?> updateTaskTitle(String id, String title) => _unused();
}

class _CreatingTasksRepository extends _UnusedTasksRepository {
  _CreatingTasksRepository({required this.now});

  final DateTime now;
  Task? createdTask;

  @override
  Future<Task> createTask(String title, {int? durationMinutes}) async {
    return createdTask = Task(
      id: 'created',
      title: title,
      createdAt: now,
      durationMinutes: durationMinutes,
    );
  }

  @override
  Future<Task> createPlannedTask({
    required String title,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) async {
    return createdTask = Task(
      id: 'created',
      title: title,
      createdAt: now,
      scheduledDate: scheduledDate,
      goalId: goalId,
      durationMinutes: durationMinutes,
    );
  }
}
