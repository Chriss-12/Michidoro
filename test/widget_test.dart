import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_source.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
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
    if (!serviceLocator.isRegistered<GenerateStatisticsReport>()) {
      serviceLocator.registerSingleton<GenerateStatisticsReport>(
        GenerateStatisticsReport(
          repository: _EmptyStatisticsReportRepository(),
        ),
      );
    }
    final tasksController = serviceLocator<TasksController>();
    final pomodoroController = serviceLocator<PomodoroController>();
    await tasksController.createTask('Tarea rapida V2');
    await tasksController.updateTaskPlanning(
      id: tasksController.tasks.value.single.id,
      goalId: null,
      durationMinutes: 120,
    );

    await tester.pumpWidget(const MyApp());

    expect(find.text('MichiDoro'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Chriss'), findsOneWidget);
    expect(find.text('Planificación'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Completadas'), findsWidgets);

    expect(find.text('Chriss'), findsOneWidget);
    await tester.tap(find.text('Chriss'));
    await tester.pumpAndSettle();
    expect(find.text('Día'), findsWidgets);
    expect(find.text('Día del mes actual'), findsOneWidget);
    await tester.tap(find.text('Mes').last);
    await tester.pumpAndSettle();
    expect(find.text('Mes del año actual'), findsOneWidget);
    await tester.tap(find.text('Año').last);
    await tester.pumpAndSettle();
    expect(find.text('Año'), findsWidgets);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Abrir calendario'));
    await tester.pumpAndSettle();
    expect(find.text('Calendario'), findsOneWidget);
    expect(find.byTooltip('Mes siguiente'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Hola, Chriss'), findsOneWidget);
    expect(find.text('Planificación'), findsOneWidget);

    await tester.tap(find.byTooltip('Abrir calendario'));
    await tester.pumpAndSettle();
    expect(find.text('Calendario'), findsOneWidget);

    await tester.tap(find.byTooltip('Más acciones'));
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
    expect(find.text('Duración'), findsOneWidget);
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

    await tester.tap(find.byTooltip('Más acciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Asignar tarea rápida'));
    await tester.pumpAndSettle();
    expect(find.text('Asignar tarea rápida'), findsOneWidget);
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
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Personalizado'),
      240,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .last,
    );
    await tester.tap(find.text('Personalizado'));
    await tester.pumpAndSettle();
    expect(find.text('Pomodoro personalizado'), findsOneWidget);
    expect(find.text('Solo este Pomodoro'), findsOneWidget);
    expect(find.text('Usar para todo el plan'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '45');
    await tester.enterText(find.byType(TextField).last, '10');
    await tester.pumpAndSettle();
    expect(find.textContaining('3 bloques: 45 + 45 + 30 min'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(AlertDialog),
      matchesGoldenFile('goldens/custom_task_plan_dialog.png'),
    );
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    await tester.binding.setSurfaceSize(const Size(480, 1800));
    await tester.pumpAndSettle();
    await tester.tap(find.text('25 min enfoque / 5 min descanso'));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('MODO ENFOQUE'), findsOneWidget);
    expect(find.text('Enfoque actual'), findsOneWidget);
    expect(find.textContaining('Tarea'), findsWidgets);
    expect(find.byTooltip('Opciones de visualización'), findsOneWidget);
    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Ver en pantalla completa'), findsOneWidget);
    expect(find.text('Tiempos Pomodoro'), findsNothing);
    await tester.tap(find.text('Ver en pantalla completa'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.byTooltip('Opciones de visualización'), findsOneWidget);
    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Salir de pantalla completa'), findsOneWidget);
    await tester.tap(find.text('Salir de pantalla completa'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Enfoque actual'), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    expect(find.text('Máxima concentración'), findsOneWidget);
    expect(
      tester.widget<Switch>(find.byType(Switch)).value,
      isFalse,
    );
    await tester.tap(find.text('Máxima concentración'));
    await tester.pumpAndSettle();
    expect(pomodoroController.maximumConcentrationEnabled.value, isTrue);
    expect(pomodoroController.hasStartedRuntime.value, isFalse);
    expect(find.byKey(const Key('maximumConcentrationSurface')), findsNothing);

    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar normal'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(pomodoroController.hasStartedRuntime.value, isTrue);
    expect(
      find.byKey(const Key('maximumConcentrationSurface')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.byKey(const Key('maximumConcentrationSurface')),
          )
          .color,
      const Color(0xFF000000),
    );
    expect(find.byTooltip('Ver detalles del plan'), findsNothing);
    await expectLater(
      find.byKey(const Key('maximumConcentrationSurface')),
      matchesGoldenFile('goldens/maximum_concentration.png'),
    );

    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final pausedSeconds = pomodoroController.remainingSeconds.value;
    expect(pomodoroController.maximumConcentrationEnabled.value, isTrue);
    expect(
      find.byKey(const Key('maximumConcentrationSurface')),
      findsOneWidget,
    );

    final exitArea = find.byKey(const Key('maximumConcentrationExitArea'));
    await tester.tap(exitArea);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(exitArea);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(pomodoroController.maximumConcentrationEnabled.value, isFalse);
    expect(pomodoroController.isRunning.value, isFalse);
    expect(pomodoroController.remainingSeconds.value, pausedSeconds);
    expect(find.byKey(const Key('maximumConcentrationSurface')), findsNothing);

    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Máxima concentración'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('maximumConcentrationSurface')),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    expect(find.text('Salir de pantalla completa'), findsNothing);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(pomodoroController.maximumConcentrationEnabled.value, isFalse);
    expect(find.byKey(const Key('maximumConcentrationSurface')), findsNothing);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle();
    expect(find.text('BLOQUE 1 DE 1'), findsNothing);
    expect(find.text('0/120 min · 0%'), findsNothing);
    expect(find.text('Después: descanso de 5 min'), findsNothing);
    expect(find.text('Sesión restante: ~30 min de reloj'), findsNothing);
    expect(find.byTooltip('Ver detalles del plan'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(
      find
          .ancestor(
            of: find.text('25:00'),
            matching: find.byType(AspectRatio),
          )
          .first,
      matchesGoldenFile('goldens/task_plan_timer_ring.png'),
    );
    await tester.tap(find.byTooltip('Ver detalles del plan'));
    await tester.pumpAndSettle();
    expect(find.text('Detalles del plan'), findsOneWidget);
    expect(find.text('BLOQUE 1 DE 1'), findsOneWidget);
    expect(find.text('0/120 min · 0%'), findsOneWidget);
    expect(find.text('Después: descanso de 5 min'), findsOneWidget);
    expect(find.text('Sesión restante: ~30 min de reloj'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(BottomSheet),
      matchesGoldenFile('goldens/task_plan_details_sheet.png'),
    );
    await tester.tapAt(const Offset(12, 12));
    await tester.pumpAndSettle();
    await tester.binding.setSurfaceSize(const Size(480, 1800));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Objetivos'));
    await tester.pumpAndSettle();
    expect(find.text('Mis metas'), findsOneWidget);
    expect(find.text('Progreso general'), findsOneWidget);
    expect(find.text('Tareas sin objetivo'), findsOneWidget);

    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(find.text('Apariencia'), findsOneWidget);
    expect(find.textContaining('Enfoque natural'), findsWidgets);
    final appearanceContext = tester.element(find.text('Apariencia'));
    final lightPalette = Theme.of(
      appearanceContext,
    ).extension<AppPalette>()!;
    final darkModeTile = find
        .ancestor(
          of: find.text('Modo oscuro'),
          matching: find.byType(Container),
        )
        .first;
    await tester.tap(
      find.descendant(of: darkModeTile, matching: find.byType(Switch)),
    );
    await tester.pumpAndSettle();
    final graphitePalette = Theme.of(
      tester.element(find.text('Apariencia')),
    ).extension<AppPalette>()!;
    expect(graphitePalette.background, isNot(lightPalette.background));

    await tester.tap(find.text('Aurora soleada'));
    await tester.pumpAndSettle();
    final sunshineDarkPalette = Theme.of(
      tester.element(find.text('Apariencia')),
    ).extension<AppPalette>()!;
    expect(sunshineDarkPalette.primary, isNot(graphitePalette.primary));
    expect(sunshineDarkPalette.background, isNot(graphitePalette.background));
    expect(find.text('Tema actual: Aurora soleada'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Vibrar al finalizar'),
      500,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    final vibrationTile = find
        .ancestor(
          of: find.text('Vibrar al finalizar'),
          matching: find.byType(Container),
        )
        .first;
    final vibrationSwitch = find.descendant(
      of: vibrationTile,
      matching: find.byType(Switch),
    );
    await tester.ensureVisible(vibrationSwitch);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(vibrationSwitch).value, isTrue);
    expect(find.byTooltip('Probar vibración'), findsOneWidget);
    expect(find.text('Patrón de vibración'), findsOneWidget);
    final vibrationPatternSelector = find.descendant(
      of: vibrationTile,
      matching: find.byType(
        DropdownButtonFormField<PomodoroVibrationPattern>,
      ),
    );
    await tester.tap(vibrationPatternSelector);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Doble').last);
    await tester.pumpAndSettle();
    expect(
      appSettingsController.completionVibrationPattern.value,
      PomodoroVibrationPattern.double,
    );
    expect(
      find.text('Dos toques cortos para distinguir el final.'),
      findsOneWidget,
    );
    await tester.tap(vibrationSwitch);
    await tester.pumpAndSettle();
    expect(pomodoroController.isRunning.value, isFalse);
    expect(appSettingsController.completionVibrationEnabled.value, isFalse);
    await tester.tap(vibrationSwitch);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Idioma'),
      -500,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    expect(
      Localizations.localeOf(tester.element(find.text('Idioma'))).languageCode,
      'es',
    );
    await tester.ensureVisible(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Language'), findsOneWidget);
    expect(
      find.text('Choose the language used throughout the app.'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Appearance'),
      -400,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    expect(find.text('Sunshine Aurora'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(
      Localizations.localeOf(
        tester.element(find.text('Appearance')),
      ).languageCode,
      'en',
    );

    await tester.scrollUntilVisible(
      find.text('Vibrate when finished'),
      500,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    expect(find.text('Vibrate when finished'), findsOneWidget);
    expect(find.byTooltip('Test vibration'), findsOneWidget);
    expect(find.text('Vibration pattern'), findsOneWidget);
    expect(find.text('Double'), findsOneWidget);
    await tester.tap(
      find.byType(DropdownButtonFormField<PomodoroVibrationPattern>),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Normal').last);
    await tester.pumpAndSettle();
    expect(
      appSettingsController.completionVibrationPattern.value,
      PomodoroVibrationPattern.normal,
    );

    await tester.scrollUntilVisible(
      find.text('Typography'),
      500,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    expect(find.textContaining('Applied: Modern'), findsOneWidget);
    await tester.tap(find.text('Serious · Merriweather'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Applied: Modern'), findsOneWidget);
    expect(find.text('MichiDoro adapts to your daily rhythm.'), findsOneWidget);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Applied: Serious'), findsOneWidget);
  });
}

class _EmptyStatisticsReportRepository implements StatisticsReportRepository {
  @override
  Future<StatisticsReportSource> loadSource(
    ResolvedStatisticsReportRange range,
  ) async {
    return const StatisticsReportSource(
      tasks: StatisticsTaskTotals(listed: 0, inProgress: 0, completed: 0),
      calendarDays: [],
      completedPomodoros: 0,
      focusedSeconds: 0,
      completionEvents: 0,
      legacyUnknownCompletions: 0,
    );
  }
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
    PomodoroSessionStatus status = PomodoroSessionStatus.completed,
  }) async {
    return PomodoroSession(
      id: 'test-session',
      startedAt: startedAt,
      endedAt: endedAt,
      plannedSeconds: plannedSeconds,
      focusedSeconds: focusedSeconds,
      status: status,
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

  @override
  Future<Task?> updateTaskPlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
  }) async {
    return _updateTask(
      id,
      (task) => task.copyWith(
        goalId: goalId,
        clearGoalId: goalId == null,
        durationMinutes: durationMinutes,
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
