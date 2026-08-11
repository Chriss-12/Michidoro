import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/pages/routine_editor_page.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/widgets/routines_view.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  late _MemoryRoutinesRepository repository;
  late RoutinesController controller;

  setUp(() async {
    await serviceLocator.reset();
    repository = _MemoryRoutinesRepository();
    controller = RoutinesController(
      repository: repository,
      now: () => DateTime(2026, 8, 7, 9),
      createId: (scope) => '$scope-test-id',
    );
    serviceLocator
      ..registerSingleton<RoutinesController>(controller)
      ..registerSingleton<GoalsController>(
        GoalsController(repository: _EmptyGoalsRepository()),
      );
  });

  tearDown(serviceLocator.reset);

  testWidgets('walks through the four editor steps in Spanish', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_editorApp(locale: const Locale('es')));
    await tester.pumpAndSettle();

    expect(find.text('Información'), findsOneWidget);
    expect(find.text('Paso 1 de 4'), findsOneWidget);
    await expectLater(
      find.byType(Scaffold).first,
      matchesGoldenFile('goldens/routine_editor_step_1.png'),
    );
    await tester.enterText(find.byType(TextField).first, 'Mañana productiva');
    await tester.tap(find.byKey(const ValueKey('continue-routine')));
    await tester.pumpAndSettle();

    expect(find.text('Días'), findsOneWidget);
    await expectLater(
      find.byType(Scaffold).first,
      matchesGoldenFile('goldens/routine_editor_step_2.png'),
    );
    await tester.tap(find.byKey(const ValueKey('routine-weekday-1')));
    await tester.tap(find.byKey(const ValueKey('continue-routine')));
    await tester.pumpAndSettle();

    expect(find.text('Actividades'), findsOneWidget);
    await expectLater(
      find.byType(Scaffold).first,
      matchesGoldenFile('goldens/routine_editor_step_3.png'),
    );
    await tester.tap(find.byKey(const ValueKey('add-routine-item')));
    await tester.pumpAndSettle();
    expect(find.text('Nueva actividad'), findsOneWidget);
    await expectLater(
      find.byType(Overlay).first,
      matchesGoldenFile('goldens/routine_item_editor.png'),
    );
    await tester.enterText(find.byType(TextField).first, 'Planificar el día');
    await tester.ensureVisible(find.byKey(const ValueKey('save-routine-item')));
    await tester.tap(find.byKey(const ValueKey('save-routine-item')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('add-routine-item')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Revisar agenda');
    await tester.ensureVisible(find.byKey(const ValueKey('save-routine-item')));
    await tester.tap(find.byKey(const ValueKey('save-routine-item')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('continue-routine')));
    await tester.pumpAndSettle();

    expect(find.text('Revisión'), findsOneWidget);
    expect(find.text('Enfoque'), findsOneWidget);
    expect(find.text('30 min'), findsWidgets);
    expect(find.textContaining('cruce(s) de horario'), findsOneWidget);
    await expectLater(
      find.byType(Scaffold).first,
      matchesGoldenFile('goldens/routine_editor_step_4.png'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps English editor usable at 320 px and large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _editorApp(locale: const Locale('en'), textScale: 1.5),
    );
    await tester.pumpAndSettle();

    expect(find.text('New routine'), findsOneWidget);
    expect(find.text('Information'), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Morning routine');
    await tester.tap(find.byKey(const ValueKey('continue-routine')));
    await tester.pumpAndSettle();
    expect(find.text('Days'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('routine-weekday-1')));
    await tester.tap(find.byKey(const ValueKey('continue-routine')));
    await tester.pumpAndSettle();
    expect(find.text('Activities'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('add-routine-item')));
    await tester.tap(find.byKey(const ValueKey('add-routine-item')));
    await tester.pumpAndSettle();
    expect(find.text('New activity'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the identity step usable in dark theme', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _editorApp(locale: const Locale('es'), theme: AppTheme.dark()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tu rutina'), findsOneWidget);
    expect(find.text('Datos principales'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('discards a new routine and returns without a navigation error', (
    tester,
  ) async {
    await tester.pumpWidget(_editorNavigationApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('open-routine-editor')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Rutina temporal');
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();

    expect(find.text('Descartar cambios'), findsOneWidget);
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();

    expect(find.text('Pantalla de rutinas'), findsOneWidget);
    expect(find.byType(RoutineEditorPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty, active and paused routine list states', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await controller.load();
    await tester.pumpWidget(_viewApp(controller));
    await tester.pumpAndSettle();
    expect(find.text('Aún no tienes rutinas'), findsOneWidget);

    repository.routines.addAll([
      _routine(id: 'active', status: RoutineStatus.active),
      _routine(id: 'paused', status: RoutineStatus.paused),
      _routine(id: 'archived', status: RoutineStatus.archived),
    ]);
    await controller.load();
    await tester.pumpAndSettle();
    expect(find.text('Rutina active'), findsOneWidget);
    expect(find.textContaining('Programada hoy'), findsOneWidget);
    expect(find.text('1 paso'), findsOneWidget);
    expect(find.text('Mostrar'), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey('routine-filter'))).width,
      220,
    );
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/routines_active_list.png'),
    );

    await tester.tap(find.byKey(const ValueKey('routine-filter')));
    await tester.pumpAndSettle();
    final pausedMenuItem = find.ancestor(
      of: find.text('Pausadas').last,
      matching: find.byType(PopupMenuItem<RoutineFilter>),
    );
    expect(tester.getSize(pausedMenuItem).width, 220);
    await tester.tap(find.text('Pausadas').last);
    await tester.pumpAndSettle();
    expect(find.text('Rutina paused'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('routine-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archivadas').last);
    await tester.pumpAndSettle();
    expect(find.text('Rutina archived'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the next materialized routine activity', (tester) async {
    final now = DateTime(2026, 8, 7, 9);
    final routine = _routine(id: 'active', status: RoutineStatus.active);
    repository
      ..routines.add(routine)
      ..runs.add(
        RoutineRun(
          id: 'run-active',
          routineId: routine.id,
          sourceRoutineId: routine.id,
          localDate: DateTime(now.year, now.month, now.day),
          status: RoutineRunStatus.scheduled,
          nameSnapshot: routine.name,
          iconKeySnapshot: routine.iconKey,
          colorKeySnapshot: routine.colorKey,
          scheduledStartMinuteSnapshot: 8 * 60,
          createdAt: now,
          updatedAt: now,
        ),
      )
      ..itemRuns['run-active'] = [
        RoutineItemRun(
          id: 'item-run-active',
          routineRunId: 'run-active',
          routineItemId: 'item-active',
          sourceItemId: 'item-active',
          taskId: 'task-active',
          taskIdSnapshot: 'task-active',
          positionSnapshot: 0,
          titleSnapshot: 'Actividad',
          scheduledAtSnapshot: now,
          durationMinutesSnapshot: 30,
          isOptionalSnapshot: false,
          pomodoroModeSnapshot: RoutinePomodoroMode.recommended,
          status: RoutineRunStatus.scheduled,
          createdAt: now,
          updatedAt: now,
        ),
      ];
    final tasksController = TasksController(repository: _EmptyTasksRepository())
      ..tasks.value = [
        Task(
          id: 'task-active',
          title: 'Actividad',
          durationMinutes: 30,
          createdAt: now,
        ),
      ];
    await controller.load();

    await tester.pumpWidget(
      _viewApp(controller, tasksController: tasksController),
    );
    await tester.pumpAndSettle();

    expect(find.text('Actividad'), findsOneWidget);
    expect(find.text('Iniciar actividad'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('start-routine-item-item-run-active')),
      findsOneWidget,
    );
  });

  testWidgets('switches from Tasks to Routines without another destination', (
    tester,
  ) async {
    serviceLocator.registerSingleton<TasksController>(
      TasksController(repository: _EmptyTasksRepository()),
    );
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const Scaffold(body: TasksPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    await tester.tap(find.text('Rutinas'));
    await tester.pumpAndSettle();
    expect(find.text('Mis rutinas'), findsOneWidget);
    expect(find.byKey(const ValueKey('create-routine')), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tap(find.byKey(const ValueKey('create-routine')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('routine-create-dialog')),
      findsOneWidget,
    );
    expect(find.byType(RoutineEditorPage), findsOneWidget);
    await expectLater(
      find.byType(Overlay).first,
      matchesGoldenFile('goldens/routine_create_dialog.png'),
    );

    await tester.enterText(find.byType(TextField).first, 'Rutina modal');
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Descartar cambios'), findsOneWidget);
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();

    expect(find.byType(RoutineEditorPage), findsNothing);
    expect(find.text('Mis rutinas'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _editorApp({
  required Locale locale,
  double textScale = 1,
  ThemeData? theme,
}) {
  final router = GoRouter(
    initialLocation: RoutineEditorPage.routePath,
    routes: [
      GoRoute(
        path: RoutineEditorPage.routePath,
        builder: (context, state) => const RoutineEditorPage(),
      ),
    ],
  );
  return MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: router,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: theme ?? AppTheme.light(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
  );
}

Widget _editorNavigationApp() {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Column(
            children: [
              const Text('Pantalla de rutinas'),
              FilledButton(
                key: const ValueKey('open-routine-editor'),
                onPressed: () => context.push<bool>(
                  RoutineEditorPage.routePath,
                ),
                child: const Text('Crear rutina'),
              ),
            ],
          ),
        ),
      ),
      GoRoute(
        path: RoutineEditorPage.routePath,
        pageBuilder: (context, state) => NoTransitionPage<bool>(
          key: state.pageKey,
          child: const RoutineEditorPage(),
        ),
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
  );
}

Widget _viewApp(
  RoutinesController controller, {
  TasksController? tasksController,
}) => MaterialApp(
  locale: const Locale('es'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: AppTheme.light(),
  home: Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RoutinesView(
          controller: controller,
          tasksController: tasksController,
        ),
      ],
    ),
  ),
);

Routine _routine({required String id, required RoutineStatus status}) {
  final now = DateTime(2026, 8, 7, 9);
  return Routine(
    id: id,
    name: 'Rutina $id',
    iconKey: 'sun',
    colorKey: 'primary',
    status: status,
    createdAt: now,
    updatedAt: now,
    weekdays: const [DateTime.friday],
    items: [
      RoutineItem(
        id: 'item-$id',
        routineId: id,
        position: 0,
        title: 'Actividad',
        scheduledMinute: 8 * 60,
        durationMinutes: 30,
        isOptional: false,
        pomodoroMode: RoutinePomodoroMode.none,
        createdAt: now,
        updatedAt: now,
      ),
    ],
  );
}

class _MemoryRoutinesRepository extends Fake implements RoutinesRepository {
  final List<Routine> routines = [];
  final List<RoutineRun> runs = [];
  final Map<String, List<RoutineItemRun>> itemRuns = {};

  @override
  Future<List<Routine>> loadRoutines() async => [...routines];

  @override
  Future<List<RoutineRun>> loadRuns({
    required DateTime startDate,
    required DateTime endDate,
  }) async => [...runs];

  @override
  Future<List<RoutineItemRun>> loadItemRuns(String routineRunId) async => [
    ...itemRuns[routineRunId] ?? const [],
  ];

  @override
  Future<void> saveRoutine(Routine routine) async {
    routines
      ..removeWhere((current) => current.id == routine.id)
      ..add(routine);
  }
}

class _EmptyGoalsRepository extends Fake implements GoalsRepository {
  @override
  Future<List<ProductivityGoal>> loadGoals() async => const [];
}

class _EmptyTasksRepository extends Fake implements TasksRepository {}
