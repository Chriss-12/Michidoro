import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_source.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';
import 'package:pomodoro_app_v1/main.dart';

void main() {
  late _ControllableStatisticsReportRepository reportRepository;
  late _FakeTasksRepository tasksRepository;
  late TasksController tasksController;
  late PomodoroController pomodoroController;

  setUp(() async {
    await serviceLocator.reset();
    appSettingsController.completedOnboardingVersion.value =
        AppSettingsController.currentOnboardingVersion;
    reportRepository = _ControllableStatisticsReportRepository();
    tasksRepository = _FakeTasksRepository();
    tasksController = TasksController(repository: tasksRepository);
    pomodoroController = PomodoroController(
      repository: _FakePomodoroSessionsRepository(),
    );

    serviceLocator
      ..registerSingleton<TasksRepository>(tasksRepository)
      ..registerSingleton<TasksController>(tasksController)
      ..registerSingleton<PomodoroController>(pomodoroController)
      ..registerSingleton<GoalsController>(
        GoalsController(repository: _FakeGoalsRepository()),
      )
      ..registerSingleton<CalendarController>(
        CalendarController(repository: _FakeCalendarEventsRepository()),
      )
      ..registerSingleton<GenerateStatisticsReport>(
        GenerateStatisticsReport(
          repository: reportRepository,
          clock: () => DateTime(2026, 7, 28, 10),
        ),
      );
  });

  tearDown(() async {
    appSettingsController
      ..themePreset.value = AppThemePreset.natureFocus
      ..fontScale.value = 1
      ..typographyPreset.value = AppTypographyPreset.moderna
      ..language.value = AppLanguage.spanish;
    pomodoroController.dispose();
    await serviceLocator.reset();
  });

  testWidgets(
    'keeps a long routine usable across language theme and large typography',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime.now();
      final routineRepository = _FakeRoutinesRepository(now);
      final routinesController = RoutinesController(
        repository: routineRepository,
        now: () => now,
      );
      serviceLocator.registerSingleton<RoutinesController>(routinesController);
      await Future.wait([
        tasksController.loadTasks(),
        routinesController.load(),
      ]);
      appSettingsController
        ..themePreset.value = AppThemePreset.graphiteNight
        ..fontScale.value = AppTypography.maxFontScale
        ..typographyPreset.value = AppTypographyPreset.serio
        ..language.value = AppLanguage.english;

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('home-routine-today')), findsOneWidget);
      expect(find.text("Today's routine"), findsOneWidget);
      expect(find.text('Continue activity'), findsOneWidget);
      expect(find.textContaining('Next:'), findsOneWidget);
      final settingsParagraph = tester.renderObject<RenderParagraph>(
        find.text('Settings'),
      );
      final settingsPainter = TextPainter(
        text: settingsParagraph.text,
        textDirection: settingsParagraph.textDirection,
        textScaler: settingsParagraph.textScaler,
        maxLines: settingsParagraph.maxLines,
      )..layout(maxWidth: settingsParagraph.size.width);
      expect(settingsPainter.computeLineMetrics(), hasLength(1));
      expect(tester.takeException(), isNull);

      appSettingsController
        ..themePreset.value = AppThemePreset.sunsetTide
        ..typographyPreset.value = AppTypographyPreset.normal
        ..language.value = AppLanguage.spanish;
      await tester.pumpAndSettle();

      expect(find.text('Rutina de hoy'), findsOneWidget);
      expect(find.text('Continuar actividad'), findsOneWidget);
      expect(find.textContaining('Despu'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'uses shared reports and refreshes once per range or source signal',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(480, 3600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      reportRepository.gate = Completer<void>();

      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(milliseconds: 1800));
      expect(
        find.byKey(const ValueKey('performance-loading')),
        findsOneWidget,
      );

      reportRepository.gate!.complete();
      await tester.pumpAndSettle();

      expect(reportRepository.periods, [StatisticsReportPeriod.month]);
      expect(find.textContaining('2 tareas, 3 pomodoros'), findsOneWidget);
      expect(find.text('Ánimo promedio del período'), findsOneWidget);
      expect(find.text('4.5/5 · 2 bloques valorados'), findsOneWidget);
      expect(find.text('Constancia de rutinas'), findsOneWidget);
      expect(find.text('1 de 3 actividades obligatorias'), findsOneWidget);
      expect(find.text('85 / 20 min'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      await tester.ensureVisible(find.text('X/Y'));
      await tester.tap(find.text('X/Y'));
      await tester.pumpAndSettle();
      expect(find.text('Gráfico básico x/y'), findsOneWidget);

      final stableCallCount = reportRepository.periods.length;
      await tester.pump();
      await tester.pump();
      expect(reportRepository.periods, hasLength(stableCallCount));

      await tester.ensureVisible(find.byTooltip('performance-range-day'));
      await tester.tap(find.byTooltip('performance-range-day'));
      await tester.pumpAndSettle();
      expect(reportRepository.periods.last, StatisticsReportPeriod.day);
      expect(find.text('Ánimo promedio del día'), findsOneWidget);

      final callsBeforeTaskChange = reportRepository.periods.length;
      tasksController.tasks.value = [...tasksController.tasks.value];
      await tester.pumpAndSettle();
      expect(reportRepository.periods, hasLength(callsBeforeTaskChange + 1));

      final callsBeforeSessionChange = reportRepository.periods.length;
      pomodoroController.sessions.value = [
        ...pomodoroController.sessions.value,
      ];
      await tester.pumpAndSettle();
      expect(reportRepository.periods, hasLength(callsBeforeSessionChange + 1));

      reportRepository.shouldFail = true;
      tasksController.tasks.value = [...tasksController.tasks.value];
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('performance-error')),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Descargar PDF'));
      await tester.tap(find.text('Descargar PDF'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'No se pudo guardar el PDF. Revisa la carpeta seleccionada.',
        ),
        findsOneWidget,
      );

      reportRepository.shouldFail = false;
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('performance-error')),
        findsNothing,
      );

      reportRepository.isEmpty = true;
      pomodoroController.sessions.value = [
        ...pomodoroController.sessions.value,
      ];
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('performance-empty')),
        findsOneWidget,
      );
    },
  );
}

class _ControllableStatisticsReportRepository
    implements StatisticsReportRepository {
  final List<StatisticsReportPeriod> periods = [];
  Completer<void>? gate;
  bool shouldFail = false;
  bool isEmpty = false;

  @override
  Future<StatisticsReportSource> loadSource(
    ResolvedStatisticsReportRange range,
  ) async {
    periods.add(range.period);
    final currentGate = gate;
    if (currentGate != null) {
      await currentGate.future;
      if (identical(gate, currentGate)) {
        gate = null;
      }
    }
    if (shouldFail) {
      throw StateError('report unavailable');
    }
    if (isEmpty) {
      return _emptySource;
    }

    return StatisticsReportSource(
      tasks: const StatisticsTaskTotals(
        listed: 1,
        inProgress: 0,
        completed: 1,
      ),
      createdTasks: const StatisticsTaskTotals(
        listed: 1,
        inProgress: 0,
        completed: 1,
      ),
      calendarDays: [
        StatisticsCalendarDay(
          day: range.start,
          completionRatio: 0.5,
          isEnded: false,
          totalTasks: 2,
        ),
      ],
      completedPomodoros: 3,
      focusedSeconds: 45 * 60,
      completionEvents: 1,
      legacyUnknownCompletions: 0,
      moodAverage: 4.5,
      moodSampleCount: 2,
      routines: const StatisticsRoutineMetrics(
        scheduledRuns: 3,
        inProgressRuns: 0,
        completedRuns: 1,
        skippedRuns: 1,
        missedRuns: 1,
        scheduledItems: 0,
        inProgressItems: 0,
        completedItems: 1,
        skippedItems: 1,
        missedItems: 1,
        requiredItems: 3,
        completedRequiredItems: 1,
        skippedOptionalItems: 1,
        missedRequiredItems: 1,
        plannedFocusMinutes: 85,
        focusedSeconds: 1200,
        averageStartDelayMinutes: 10,
        startDelaySampleCount: 1,
        moodAverage: 4,
        moodSampleCount: 1,
        typicalAbandonmentItem: 'Lectura',
        typicalAbandonmentCount: 1,
        longestCompletedStreak: 2,
        byRoutine: [],
      ),
    );
  }
}

const _emptySource = StatisticsReportSource(
  tasks: StatisticsTaskTotals(listed: 0, inProgress: 0, completed: 0),
  calendarDays: [],
  completedPomodoros: 0,
  focusedSeconds: 0,
  completionEvents: 0,
  legacyUnknownCompletions: 0,
);

class _FakeTasksRepository extends Fake implements TasksRepository {
  @override
  Future<List<Task>> loadTasks() async {
    return [
      for (var index = 0; index < 4; index++)
        Task(
          id: 'listed-$index',
          title: 'Listed $index',
          createdAt: DateTime(2026, 7, 28),
        ),
      for (var index = 0; index < 2; index++)
        Task(
          id: 'progress-$index',
          title: 'Progress $index',
          status: TaskStatus.inProgress,
          createdAt: DateTime(2026, 7, 28),
        ),
      for (var index = 0; index < 7; index++)
        Task(
          id: 'completed-$index',
          title: 'Completed $index',
          status: TaskStatus.completed,
          createdAt: DateTime(2026, 7, 28),
        ),
    ];
  }
}

class _FakePomodoroSessionsRepository extends Fake
    implements PomodoroSessionsRepository {}

class _FakeGoalsRepository extends Fake implements GoalsRepository {}

class _FakeCalendarEventsRepository extends Fake
    implements CalendarEventsRepository {}

class _FakeRoutinesRepository extends Fake implements RoutinesRepository {
  _FakeRoutinesRepository(this.now);

  final DateTime now;

  late final Routine routine = Routine(
    id: 'routine-dense-home',
    name: 'Rutina de concentraciÃ³n extraordinariamente extensa',
    iconKey: 'routine',
    colorKey: 'primary',
    status: RoutineStatus.active,
    createdAt: now.subtract(const Duration(days: 2)),
    updatedAt: now,
    weekdays: [now.weekday],
    items: [
      for (var index = 0; index < 3; index++)
        RoutineItem(
          id: 'routine-item-$index',
          routineId: 'routine-dense-home',
          position: index,
          title: 'Actividad extensa ${index + 1}',
          scheduledMinute: 8 * 60 + index * 30,
          durationMinutes: 25,
          isOptional: false,
          pomodoroMode: RoutinePomodoroMode.recommended,
          createdAt: now,
          updatedAt: now,
        ),
    ],
  );

  late final RoutineRun run = RoutineRun(
    id: 'routine-run-home',
    routineId: routine.id,
    sourceRoutineId: routine.id,
    localDate: DateTime(now.year, now.month, now.day),
    status: RoutineRunStatus.inProgress,
    nameSnapshot: routine.name,
    iconKeySnapshot: routine.iconKey,
    colorKeySnapshot: routine.colorKey,
    scheduledStartMinuteSnapshot: 8 * 60,
    startedAt: now,
    createdAt: now,
    updatedAt: now,
  );

  late final List<RoutineItemRun> itemRuns = [
    RoutineItemRun(
      id: 'item-run-0',
      routineRunId: run.id,
      routineItemId: routine.items[0].id,
      sourceItemId: routine.items[0].id,
      taskId: 'completed-0',
      positionSnapshot: 0,
      titleSnapshot: routine.items[0].title,
      scheduledAtSnapshot: DateTime(now.year, now.month, now.day, 8),
      durationMinutesSnapshot: 25,
      isOptionalSnapshot: false,
      pomodoroModeSnapshot: RoutinePomodoroMode.recommended,
      status: RoutineRunStatus.completed,
      completedAt: now,
      createdAt: now,
      updatedAt: now,
    ),
    RoutineItemRun(
      id: 'item-run-1',
      routineRunId: run.id,
      routineItemId: routine.items[1].id,
      sourceItemId: routine.items[1].id,
      taskId: 'listed-0',
      positionSnapshot: 1,
      titleSnapshot: 'Actividad actual con un nombre especialmente largo',
      scheduledAtSnapshot: DateTime(now.year, now.month, now.day, 8, 30),
      durationMinutesSnapshot: 25,
      isOptionalSnapshot: false,
      pomodoroModeSnapshot: RoutinePomodoroMode.recommended,
      status: RoutineRunStatus.inProgress,
      startedAt: now,
      createdAt: now,
      updatedAt: now,
    ),
    RoutineItemRun(
      id: 'item-run-2',
      routineRunId: run.id,
      routineItemId: routine.items[2].id,
      sourceItemId: routine.items[2].id,
      taskId: 'listed-1',
      positionSnapshot: 2,
      titleSnapshot: 'Siguiente actividad con descripciÃ³n prolongada',
      scheduledAtSnapshot: DateTime(now.year, now.month, now.day, 9),
      durationMinutesSnapshot: 25,
      isOptionalSnapshot: false,
      pomodoroModeSnapshot: RoutinePomodoroMode.recommended,
      status: RoutineRunStatus.scheduled,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  @override
  Future<List<Routine>> loadRoutines() async => [routine];

  @override
  Future<List<RoutineRun>> loadRuns({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final day = run.localDate;
    return !day.isBefore(startDate) && !day.isAfter(endDate) ? [run] : [];
  }

  @override
  Future<List<RoutineItemRun>> loadItemRuns(String routineRunId) async =>
      routineRunId == run.id ? itemRuns : [];
}
