import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_document.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_file.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/weekly_schedule_exporter.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'omits the separate daily agenda in both languages',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime.now();
      final routinesRepository = _DenseRoutinesRepository(now);
      final calendarController = CalendarController(
        repository: _DenseCalendarRepository(now),
      );
      final goalsController = GoalsController(
        repository: _DenseGoalsRepository(now),
      );
      final tasksController = TasksController(
        repository: _DenseTasksRepository(now),
      );
      final pomodoroController = PomodoroController(
        repository: _EmptyPomodoroRepository(),
      );
      final routinesController = RoutinesController(
        repository: routinesRepository,
        now: () => now,
      );
      addTearDown(pomodoroController.dispose);

      await tester.pumpWidget(
        _CalendarTestApp(
          locale: const Locale('es'),
          theme: AppTheme.fromPreset(
            AppThemePreset.natureFocus,
            isDark: false,
          ),
          calendarController: calendarController,
          goalsController: goalsController,
          tasksController: tasksController,
          pomodoroController: pomodoroController,
          routinesController: routinesController,
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('goal-period-card')),
        320,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Rutinas'), findsNothing);
      expect(find.text('Tareas del día'), findsNothing);
      expect(find.text('Agenda local de planificación'), findsNothing);
      expect(find.text('Sin eventos planificados'), findsNothing);
      expect(find.textContaining('Rutina 0'), findsNothing);
      expect(find.textContaining('Evento de calendario'), findsNothing);
      final spanishLayoutException = tester.takeException();
      expect(
        spanishLayoutException,
        isNull,
        reason: spanishLayoutException is FlutterError
            ? spanishLayoutException.toStringDeep()
            : '$spanishLayoutException',
      );

      await tester.binding.setSurfaceSize(const Size(320, 1100));
      await tester.pumpWidget(
        _CalendarTestApp(
          locale: const Locale('en'),
          theme: AppTheme.fromPreset(
            AppThemePreset.graphiteNight,
            isDark: true,
            fontScale: AppTypography.maxFontScale,
            typographyPreset: AppTypographyPreset.serio,
          ),
          calendarController: calendarController,
          goalsController: goalsController,
          tasksController: tasksController,
          pomodoroController: pomodoroController,
          routinesController: routinesController,
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('goal-period-card')),
        320,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Routines'), findsNothing);
      expect(find.text('Local planning agenda'), findsNothing);
      expect(find.text('No events planned'), findsNothing);
      expect(find.textContaining('Rutina 0'), findsNothing);
      expect(find.textContaining('Evento de calendario'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'renders the weekly school timetable with goals and activity blocks',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime.now();
      final routinesRepository = _DenseRoutinesRepository(now);
      final weeklyScheduleExporter = _FakeWeeklyScheduleExporter();
      final pomodoroController = PomodoroController(
        repository: _EmptyPomodoroRepository(),
      );
      addTearDown(pomodoroController.dispose);

      await tester.pumpWidget(
        _CalendarTestApp(
          locale: const Locale('es'),
          theme: AppTheme.fromPreset(
            AppThemePreset.natureFocus,
            isDark: false,
          ),
          calendarController: CalendarController(
            repository: _DenseCalendarRepository(now),
          ),
          goalsController: GoalsController(
            repository: _DenseGoalsRepository(now),
          ),
          tasksController: TasksController(
            repository: _DenseTasksRepository(now),
          ),
          pomodoroController: pomodoroController,
          routinesController: RoutinesController(
            repository: routinesRepository,
            now: () => now,
          ),
          weeklyScheduleExporter: weeklyScheduleExporter,
        ),
      );
      await tester.pumpAndSettle();

      final selector = find.byKey(const ValueKey('planning-view-selector'));
      await tester.tap(
        find.descendant(of: selector, matching: find.text('Semana')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('weekly-schedule-card')),
        findsOneWidget,
      );
      expect(find.text('Horario semanal'), findsOneWidget);
      expect(find.text('Objetivos de la semana'), findsOneWidget);
      expect(find.textContaining('1 objetivos · 1/3 tareas'), findsOneWidget);
      expect(find.text('1/3 tareas'), findsNothing);
      expect(
        find.byKey(const ValueKey('weekly-layout-selector')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('weekly-horizontal-scroll')),
        findsNothing,
      );
      expect(
        find.byKey(ValueKey('compact-week-day-${_dateKey(now)}')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          ValueKey(
            'compact-week-activity-routine-0-'
            '${_dateKey(now)}-${8 * 60}',
          ),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.layers_rounded), findsWidgets);

      await tester.tap(find.byKey(const ValueKey('weekly-goals-toggle')));
      await tester.pumpAndSettle();
      expect(find.text('1/3 tareas'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('export-week-pdf')));
      await tester.pumpAndSettle();
      expect(weeklyScheduleExporter.exportedDocuments, hasLength(1));
      expect(
        weeklyScheduleExporter.exportedDocuments.single.activities,
        isNotEmpty,
      );
      expect(find.textContaining('PDF guardado en:'), findsOneWidget);

      final layoutSelector = find.byKey(
        const ValueKey('weekly-layout-selector'),
      );
      await tester.tap(
        find.descendant(
          of: layoutSelector,
          matching: find.text('Cuadrícula'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('weekly-horizontal-scroll')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          ValueKey(
            'week-activity-routine-0-'
            '${_dateKey(now)}-${8 * 60}',
          ),
        ),
        findsOneWidget,
      );
      final weeklyException = tester.takeException();
      expect(
        weeklyException,
        isNull,
        reason: weeklyException is FlutterError
            ? weeklyException.toStringDeep()
            : '$weeklyException',
      );
    },
  );

  testWidgets(
    'reveals a routed goal, groups its tasks, and exposes contextual creation',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime.now();
      final pomodoroController = PomodoroController(
        repository: _EmptyPomodoroRepository(),
      );
      addTearDown(pomodoroController.dispose);

      await tester.pumpWidget(
        _CalendarTestApp(
          locale: const Locale('es'),
          theme: AppTheme.fromPreset(
            AppThemePreset.natureFocus,
            isDark: false,
          ),
          calendarController: CalendarController(
            repository: _DenseCalendarRepository(now),
          ),
          goalsController: GoalsController(
            repository: _DenseGoalsRepository(now),
          ),
          tasksController: TasksController(
            repository: _DenseTasksRepository(now),
          ),
          pomodoroController: pomodoroController,
          routinesController: RoutinesController(
            repository: _DenseRoutinesRepository(now),
            now: () => now,
          ),
          initialGoalId: 'goal-1',
          initialTaskId: 'task-1',
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('period-goal-tasks-goal-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('period-goal-task-highlight-task-1')),
        findsOneWidget,
      );
      expect(find.text('Pendiente'), findsWidgets);
      expect(find.text('En progreso'), findsWidgets);
      expect(find.text('Completada'), findsWidgets);

      final toggle = find.byKey(
        const ValueKey('period-goal-toggle-goal-1'),
      );
      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('period-goal-tasks-goal-1')),
        findsNothing,
      );

      final createButton = find.byKey(
        const ValueKey('planning-create-button'),
      );
      final goalCard = find.byKey(const ValueKey('goal-period-card'));
      await tester.scrollUntilVisible(
        createButton,
        -280,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        find.descendant(of: goalCard, matching: createButton),
        findsOneWidget,
      );
      expect(
        tester.getSize(createButton).width,
        closeTo(
          tester.getSize(find.byKey(const ValueKey('pick-goal-period'))).width,
          0.1,
        ),
      );
      await tester.tap(createButton);
      await tester.pumpAndSettle();
      expect(find.text('Nueva tarea'), findsWidgets);
      expect(find.text('Nuevo objetivo'), findsOneWidget);

      await tester.tap(find.text('Nuevo objetivo'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(
          const ValueKey('speech-input-calendar-goal-create-title'),
        ),
        findsOneWidget,
      );
      Navigator.of(tester.element(find.byType(AlertDialog))).pop();
      await tester.pumpAndSettle();

      await tester.tap(createButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nueva tarea').last);
      await tester.pumpAndSettle();
      expect(
        find.byKey(
          const ValueKey('speech-input-calendar-task-create-title'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

class _CalendarTestApp extends StatelessWidget {
  const _CalendarTestApp({
    required this.locale,
    required this.theme,
    required this.calendarController,
    required this.goalsController,
    required this.tasksController,
    required this.pomodoroController,
    required this.routinesController,
    this.weeklyScheduleExporter,
    this.initialGoalId,
    this.initialTaskId,
  });

  final Locale locale;
  final ThemeData theme;
  final CalendarController calendarController;
  final GoalsController goalsController;
  final TasksController tasksController;
  final PomodoroController pomodoroController;
  final RoutinesController routinesController;
  final WeeklyScheduleExporter? weeklyScheduleExporter;
  final String? initialGoalId;
  final String? initialTaskId;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: theme,
    home: Scaffold(
      body: CalendarPage(
        controller: calendarController,
        goalsController: goalsController,
        tasksController: tasksController,
        pomodoroController: pomodoroController,
        routinesController: routinesController,
        weeklyScheduleExporter:
            weeklyScheduleExporter ?? _FakeWeeklyScheduleExporter(),
        initialGoalId: initialGoalId,
        initialTaskId: initialTaskId,
      ),
    ),
  );
}

class _FakeWeeklyScheduleExporter implements WeeklyScheduleExporter {
  final exportedDocuments = <WeeklyScheduleExportDocument>[];
  final openedFiles = <WeeklyScheduleExportFile>[];

  @override
  Future<WeeklyScheduleExportFile?> export(
    WeeklyScheduleExportDocument document,
  ) async {
    exportedDocuments.add(document);
    return const WeeklyScheduleExportFile(
      displayPath: 'Descargas/michi-focus.pdf',
      openReference: 'content://michi-focus.pdf',
    );
  }

  @override
  Future<void> open(WeeklyScheduleExportFile file) async {
    openedFiles.add(file);
  }
}

class _DenseCalendarRepository extends Fake
    implements CalendarEventsRepository {
  _DenseCalendarRepository(this.now);

  final DateTime now;

  @override
  Future<List<CalendarEvent>> loadEvents() async => [
    for (var index = 0; index < 3; index++)
      CalendarEvent(
        id: 'event-$index',
        title: 'Evento de calendario con un nombre muy extenso $index',
        scheduledAt: DateTime(now.year, now.month, now.day, 10 + index),
        durationMinutes: 45,
        createdAt: now,
      ),
  ];
}

class _DenseGoalsRepository extends Fake implements GoalsRepository {
  _DenseGoalsRepository(this.now);

  final DateTime now;

  @override
  Future<List<ProductivityGoal>> loadGoals() async => [
    ProductivityGoal(
      id: 'goal-1',
      title: 'Objetivo con una descripciÃ³n considerablemente extensa',
      targetSessions: 8,
      targetDate: DateTime(now.year, now.month, now.day),
      createdAt: now,
    ),
  ];
}

class _DenseTasksRepository extends Fake implements TasksRepository {
  _DenseTasksRepository(this.now);

  final DateTime now;

  @override
  Future<List<Task>> loadTasks() async => [
    for (var index = 0; index < 5; index++)
      Task(
        id: 'task-$index',
        title: 'Tarea planificada con un nombre especialmente largo $index',
        status: TaskStatus.values[index % TaskStatus.values.length],
        scheduledDate: DateTime(now.year, now.month, now.day),
        goalId: index < 3 ? 'goal-1' : null,
        durationMinutes: 30 + index * 5,
        createdAt: now,
      ),
  ];
}

class _EmptyPomodoroRepository extends Fake
    implements PomodoroSessionsRepository {}

class _DenseRoutinesRepository extends Fake implements RoutinesRepository {
  _DenseRoutinesRepository(this.now);

  final DateTime now;

  late final List<Routine> routines = [
    for (var index = 0; index < 4; index++) _routine(index),
  ];

  late final List<RoutineRun> runs = [
    for (var index = 0; index < 3; index++) _run(index),
  ];

  late final Map<String, List<RoutineItemRun>> itemRuns = {
    for (var index = 0; index < 3; index++) 'run-$index': _itemRuns(index),
  };

  Routine _routine(int index) => Routine(
    id: 'routine-$index',
    name: 'Rutina $index con un nombre deliberadamente muy prolongado',
    iconKey: 'routine',
    colorKey: 'primary',
    status: RoutineStatus.active,
    createdAt: now.subtract(const Duration(days: 2)),
    updatedAt: now,
    weekdays: [now.weekday],
    items: [
      RoutineItem(
        id: 'routine-$index-item-0',
        routineId: 'routine-$index',
        position: 0,
        title: 'Actividad obligatoria extensa',
        scheduledMinute: 8 * 60 + index * 5,
        durationMinutes: 40,
        isOptional: false,
        pomodoroMode: RoutinePomodoroMode.recommended,
        createdAt: now,
        updatedAt: now,
      ),
      RoutineItem(
        id: 'routine-$index-item-1',
        routineId: 'routine-$index',
        position: 1,
        title: 'Actividad opcional extensa',
        scheduledMinute: 8 * 60 + 20 + index * 5,
        durationMinutes: 30,
        isOptional: true,
        pomodoroMode: RoutinePomodoroMode.none,
        createdAt: now,
        updatedAt: now,
      ),
    ],
  );

  RoutineRun _run(int index) {
    final routine = routines[index];
    return RoutineRun(
      id: 'run-$index',
      routineId: routine.id,
      sourceRoutineId: routine.id,
      localDate: DateTime(now.year, now.month, now.day),
      status: switch (index) {
        0 => RoutineRunStatus.completed,
        1 => RoutineRunStatus.skipped,
        _ => RoutineRunStatus.missed,
      },
      nameSnapshot: routine.name,
      iconKeySnapshot: routine.iconKey,
      colorKeySnapshot: routine.colorKey,
      scheduledStartMinuteSnapshot: 8 * 60 + index * 5,
      createdAt: now,
      updatedAt: now,
    );
  }

  List<RoutineItemRun> _itemRuns(int index) {
    final routine = routines[index];
    final run = runs[index];
    final requiredStatus = index == 0
        ? RoutineRunStatus.completed
        : index == 2
        ? RoutineRunStatus.missed
        : RoutineRunStatus.skipped;
    return [
      RoutineItemRun(
        id: 'run-$index-item-0',
        routineRunId: run.id,
        routineItemId: routine.items[0].id,
        sourceItemId: routine.items[0].id,
        taskId: 'task-$index',
        positionSnapshot: 0,
        titleSnapshot: routine.items[0].title,
        scheduledAtSnapshot: DateTime(now.year, now.month, now.day, 8),
        durationMinutesSnapshot: 40,
        isOptionalSnapshot: false,
        pomodoroModeSnapshot: RoutinePomodoroMode.recommended,
        status: requiredStatus,
        createdAt: now,
        updatedAt: now,
      ),
      RoutineItemRun(
        id: 'run-$index-item-1',
        routineRunId: run.id,
        routineItemId: routine.items[1].id,
        sourceItemId: routine.items[1].id,
        positionSnapshot: 1,
        titleSnapshot: routine.items[1].title,
        scheduledAtSnapshot: DateTime(now.year, now.month, now.day, 8, 20),
        durationMinutesSnapshot: 30,
        isOptionalSnapshot: true,
        pomodoroModeSnapshot: RoutinePomodoroMode.none,
        status: index == 1
            ? RoutineRunStatus.skipped
            : RoutineRunStatus.scheduled,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  @override
  Future<List<Routine>> loadRoutines() async => routines;

  @override
  Future<List<RoutineRun>> loadRuns({
    required DateTime startDate,
    required DateTime endDate,
  }) async => runs
      .where(
        (run) =>
            !run.localDate.isBefore(startDate) &&
            !run.localDate.isAfter(endDate),
      )
      .toList(growable: false);

  @override
  Future<List<RoutineItemRun>> loadItemRuns(String routineRunId) async =>
      itemRuns[routineRunId] ?? const [];
}
