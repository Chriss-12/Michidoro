import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/router/app_router.dart';
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
import 'package:pomodoro_app_v1/features/settings/presentation/pages/notification_settings_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/settings_page.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/local_app_lock_controller.dart';
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
    if (!serviceLocator.isRegistered<TasksRepository>()) {
      serviceLocator.registerSingleton<TasksRepository>(
        _MemoryTasksRepository(),
      );
    }
    if (!serviceLocator.isRegistered<TasksController>()) {
      serviceLocator.registerSingleton<TasksController>(
        TasksController(repository: serviceLocator<TasksRepository>()),
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
    final goalsController = serviceLocator<GoalsController>();
    final pomodoroController = serviceLocator<PomodoroController>();
    appSettingsController.completedOnboardingVersion.value =
        AppSettingsController.currentOnboardingVersion;
    await tasksController.createTask('Tarea rapida V2');
    await tasksController.updateTaskPlanning(
      id: tasksController.tasks.value.single.id,
      goalId: null,
      durationMinutes: 120,
    );

    await tester.pumpWidget(
      MyApp(
        requireBackupMasterPassword: false,
        localAppLockController: LocalAppLockController(),
      ),
    );

    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeAnimationDuration, Duration.zero);

    expect(find.text('Hola, Chriss'), findsOneWidget);
    expect(find.text('Planificación'), findsNothing);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Completadas'), findsWidgets);

    expect(find.text('Chriss'), findsOneWidget);
    await tester.tap(find.text('Chriss'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Text>(
            find.byKey(const ValueKey('profile-pending-task-count')),
          )
          .data,
      '1',
    );
    expect(find.text('Día'), findsWidgets);
    expect(find.text('Día del mes actual'), findsOneWidget);
    await tester.tap(find.text('Mes').last);
    await tester.pumpAndSettle();
    expect(find.text('Mes del año actual'), findsOneWidget);
    await tester.tap(find.text('Año').last);
    await tester.pumpAndSettle();
    expect(find.text('Año'), findsWidgets);
    expect(
      tester
          .widget<Text>(
            find.byKey(const ValueKey('profile-pending-task-count')),
          )
          .data,
      '1',
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    AppRouter.router.go('/calendar');
    await tester.pumpAndSettle();
    expect(
      AppRouter.router.routeInformationProvider.value.uri.path,
      '/goals',
    );
    expect(find.text('Planificación'), findsOneWidget);
    AppRouter.router.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Objetivos').last);
    await tester.pumpAndSettle();
    expect(find.text('Planificación'), findsOneWidget);
    final goalPeriodCard = find.byKey(const ValueKey('goal-period-card'));
    expect(goalPeriodCard, findsOneWidget);
    expect(find.text('Todos'), findsOneWidget);
    expect(
      find.descendant(of: goalPeriodCard, matching: find.text('Semana')),
      findsOneWidget,
    );
    expect(find.text('Rango'), findsOneWidget);
    await tester.ensureVisible(find.text('Rango'));
    await tester.tap(find.text('Rango'));
    await tester.pumpAndSettle();
    final rangeDialog = find.byKey(
      const ValueKey('goal-date-range-dialog'),
    );
    expect(rangeDialog, findsOneWidget);
    expect(
      find.descendant(of: rangeDialog, matching: find.text('Inicio')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: rangeDialog, matching: find.text('Fin')),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Mes siguiente'), findsOneWidget);

    final planningCreateButton = find.byKey(
      const ValueKey('planning-create-button'),
    );
    await tester.ensureVisible(planningCreateButton);
    await tester.tap(planningCreateButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nuevo objetivo'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Objetivo para'), findsOneWidget);
    expect(find.textContaining('pomodoros'), findsNothing);
    await tester.enterText(find.byType(TextField).last, 'Objetivo V2');
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Crear')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Objetivo V2'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(planningCreateButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    expect(find.text('Crear nueva tarea'), findsOneWidget);
    expect(find.text('Duración'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'Tarea V2');
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Crear')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tarea V2'), findsNothing);
    expect(find.text('Tareas del día'), findsNothing);
    expect(tester.takeException(), isNull);

    expect(find.text('Tarea rapida V2'), findsNothing);
    expect(tester.takeException(), isNull);

    final today = DateTime.now();
    final quickTask = tasksController.tasks.value.firstWhere(
      (task) => task.title == 'Tarea rapida V2',
    );
    await tasksController.moveTaskToDay(
      id: quickTask.id,
      scheduledDate: DateTime(today.year, today.month, today.day),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tareas').last);
    await tester.pumpAndSettle();
    expect(find.text('Tarea V2'), findsOneWidget);
    expect(find.text('Tarea rapida V2'), findsOneWidget);
    expect(find.text('Pendiente'), findsNWidgets(2));
    expect(find.text('25 min'), findsNWidgets(2));
    expect(find.text('Sin objetivo'), findsNWidgets(3));

    final taskDraftField = find.byKey(const ValueKey('task-create-title'));
    await tester.ensureVisible(taskDraftField);
    await tester.enterText(taskDraftField, 'Borrador persistente');
    tester.testTextInput.hide();
    await tester.tap(find.text('Objetivos').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tareas').last);
    await tester.pumpAndSettle();
    expect(find.text('Borrador persistente'), findsOneWidget);
    await tester.enterText(taskDraftField, '');

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

    await tester.tap(find.text('Objetivos').last);
    await tester.pumpAndSettle();
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

    final focusGoal = goalsController.goals.value.firstWhere(
      (goal) => goal.title == 'Objetivo V2',
    );

    await tester.tap(find.text('Tareas').last);
    await tester.pumpAndSettle();
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
    final customPlanDialog = find.byType(AlertDialog);
    final customPlanFields = find.descendant(
      of: customPlanDialog,
      matching: find.byType(TextField),
    );
    await tester.enterText(customPlanFields.first, '45');
    await tester.enterText(customPlanFields.last, '10');
    await tester.pumpAndSettle();
    expect(find.textContaining('3 bloques: 45 + 45 + 30 min'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(AlertDialog),
      matchesGoldenFile('goldens/custom_task_plan_dialog.png'),
    );
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.setSurfaceSize(const Size(480, 1800));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('Opciones de tarea').first);
    await tester.tap(find.byTooltip('Opciones de tarea').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empezar Pomodoro'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.text('25 min enfoque / 5 min descanso'),
    );
    await tester.pumpAndSettle();
    final presetTile = tester.widget<ListTile>(
      find
          .ancestor(
            of: find.text('25 min enfoque / 5 min descanso'),
            matching: find.byType(ListTile),
          )
          .first,
    );
    presetTile.onTap!();
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    expect(find.text('Empezar Pomodoro'), findsNothing);
    expect(pomodoroController.hasActiveRuntime.value, isTrue);
    pomodoroController.selectedGoalId = focusGoal.id;
    await tester.pumpAndSettle();
    final activePlanTotal = pomodoroController.totalBlocks.value;
    expect(activePlanTotal, greaterThan(0));
    expect(
      AppRouter.router.routeInformationProvider.value.uri.path,
      '/pomodoro',
    );
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('MODO ENFOQUE'), findsOneWidget);
    expect(find.text('Enfoque actual'), findsOneWidget);
    expect(
      find.text('Tarea rapida V2 - Objetivo V2'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Descartar'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<OutlinedButton>(
            find
                .ancestor(
                  of: find.text('Descartar'),
                  matching: find.byWidgetPredicate(
                    (widget) => widget is OutlinedButton,
                  ),
                )
                .first,
          )
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<OutlinedButton>(
            find
                .ancestor(
                  of: find.text('Reiniciar'),
                  matching: find.byWidgetPredicate(
                    (widget) => widget is OutlinedButton,
                  ),
                )
                .first,
          )
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<FilledButton>(
            find
                .ancestor(
                  of: find.text('Terminar'),
                  matching: find.byWidgetPredicate(
                    (widget) => widget is FilledButton,
                  ),
                )
                .first,
          )
          .onPressed,
      isNotNull,
    );
    expect(
      find.text('0/$activePlanTotal'),
      findsOneWidget,
    );
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
    expect(
      find.text('0/$activePlanTotal'),
      findsOneWidget,
    );
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
      tester
          .widget<Switch>(find.byKey(const Key('maximumConcentrationSwitch')))
          .value,
      isFalse,
    );
    await tester.tap(find.text('Máxima concentración'));
    await tester.pumpAndSettle();
    expect(pomodoroController.maximumConcentrationEnabled.value, isTrue);
    expect(pomodoroController.keepScreenAwake, isTrue);
    expect(
      pomodoroController.maximumConcentrationDisplayStyle,
      MaximumConcentrationStyle.oled,
    );
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
    expect(
      find.text('0/$activePlanTotal'),
      findsOneWidget,
    );
    expect(pomodoroController.amoledProtection, isTrue);
    final oledTimerColor = tester
        .widget<Text>(find.byKey(const Key('pomodoroTimeLabel')))
        .style!
        .color!;
    expect(oledTimerColor, const Color(0xFFC8C8C8));
    await expectLater(
      find.byKey(const Key('maximumConcentrationSurface')),
      matchesGoldenFile('goldens/maximum_concentration.png'),
    );

    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    expect(find.text('Claro'), findsOneWidget);
    expect(find.text('OLED'), findsOneWidget);
    expect(find.text('Mantener pantalla encendida'), findsOneWidget);
    expect(
      tester
          .widget<Switch>(find.byKey(const Key('keepScreenAwakeSwitch')))
          .value,
      isTrue,
    );
    await tester.tap(find.text('Claro'));
    await tester.pumpAndSettle();
    expect(
      pomodoroController.maximumConcentrationDisplayStyle,
      MaximumConcentrationStyle.clear,
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.byKey(const Key('maximumConcentrationSurface')),
          )
          .color,
      const Color(0xFFFFFFFF),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('pomodoroTimeLabel')))
          .style
          ?.color,
      const Color(0xFF000000),
    );

    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OLED'));
    await tester.pumpAndSettle();
    expect(
      pomodoroController.maximumConcentrationDisplayStyle,
      MaximumConcentrationStyle.oled,
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.byKey(const Key('maximumConcentrationSurface')),
          )
          .color,
      const Color(0xFF000000),
    );

    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    final opacitySlider = find.byKey(
      const Key('maximumConcentrationOpacitySlider'),
    );
    expect(opacitySlider, findsOneWidget);
    expect(appSettingsController.maximumConcentrationOpacity.value, 1);
    final initialMenuForeground = tester
        .widget<Text>(find.text('OLED'))
        .style
        ?.color;
    await tester.drag(opacitySlider, const Offset(-80, 0));
    await tester.pumpAndSettle();
    expect(
      appSettingsController.maximumConcentrationOpacity.value,
      lessThan(1),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('pomodoroTimeLabel')))
          .style
          ?.color,
      isNot(const Color(0xFFC8C8C8)),
    );
    expect(
      tester.widget<Text>(find.text('OLED')).style?.color,
      isNot(initialMenuForeground),
    );
    expect(find.text('OLED'), findsOneWidget);
    await tester.tap(find.text('OLED'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final pausedSeconds = pomodoroController.remainingSeconds.value;
    expect(pomodoroController.maximumConcentrationEnabled.value, isTrue);
    expect(
      find.byKey(const Key('maximumConcentrationSurface')),
      findsOneWidget,
    );
    final initialProtectedOffset = tester
        .widget<AnimatedSlide>(
          find.byKey(const Key('amoledProtectedContent')),
        )
        .offset;
    await tester.pump(const Duration(seconds: 60));
    await tester.pump(const Duration(milliseconds: 700));
    final movedProtectedOffset = tester
        .widget<AnimatedSlide>(
          find.byKey(const Key('amoledProtectedContent')),
        )
        .offset;
    expect(movedProtectedOffset, isNot(initialProtectedOffset));

    await tester.tap(find.byTooltip('Opciones de visualización'));
    await tester.pumpAndSettle();
    expect(find.text('Protección AMOLED'), findsOneWidget);
    final protectionItem = find
        .ancestor(
          of: find.text('Protección AMOLED'),
          matching: find.byType(Row),
        )
        .first;
    await tester.tap(
      find.descendant(of: protectionItem, matching: find.byType(Switch)),
    );
    await tester.pumpAndSettle();
    expect(pomodoroController.amoledProtection, isFalse);
    expect(
      tester
          .widget<AnimatedSlide>(
            find.byKey(const Key('amoledProtectedContent')),
          )
          .offset,
      Offset.zero,
    );

    final exitArea = find.byKey(const Key('maximumConcentrationExitArea'));
    await tester.tap(exitArea);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(exitArea);
    await tester.pump();
    expect(pomodoroController.maximumConcentrationEnabled.value, isFalse);
    expect(
      find.byKey(const Key('maximumConcentrationSurface')),
      findsOneWidget,
      reason: 'La salida debe conservar el fondo negro mientras se desvanece.',
    );
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
    final maximumSwitchRow = find
        .ancestor(
          of: find.text('Máxima concentración'),
          matching: find.byType(Row),
        )
        .first;
    final maximumSwitch = find.descendant(
      of: maximumSwitchRow,
      matching: find.byType(Switch),
    );
    expect(tester.widget<Switch>(maximumSwitch).value, isTrue);
    await tester.tap(maximumSwitch);
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
            of: find.byKey(const Key('pomodoroTimeLabel')),
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
    Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    await tester.pumpAndSettle();
    pomodoroController.pendingReflectionSessionId.value = 'test-reflection';
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Cierre de enfoque'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester.getTopLeft(find.text('Cierre de enfoque')).dy,
      greaterThan(tester.getTopLeft(find.text('Terminar')).dy),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('focus-reflection-card'))).width,
      greaterThan(300),
    );
    expect(
      find.byIcon(Icons.sentiment_very_dissatisfied_rounded),
      findsNothing,
    );
    final reflectionToggle = find.byKey(
      const ValueKey('focus-reflection-toggle'),
    );
    await tester.scrollUntilVisible(
      reflectionToggle,
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(
      find.byType(Scrollable).first,
      const Offset(0, -180),
    );
    await tester.pumpAndSettle();
    await tester.tap(reflectionToggle);
    await tester.pumpAndSettle();
    expect(
      find.byIcon(Icons.sentiment_very_dissatisfied_rounded),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.sentiment_dissatisfied_rounded), findsOneWidget);
    expect(find.byIcon(Icons.sentiment_neutral_rounded), findsOneWidget);
    expect(find.byIcon(Icons.sentiment_satisfied_rounded), findsOneWidget);
    expect(find.byIcon(Icons.sentiment_very_satisfied_rounded), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('focus-reflection-card')),
        matching: find.text('1'),
      ),
      findsNothing,
    );
    expect(find.text('Este Pomodoro suma a'), findsNothing);
    pomodoroController.pendingReflectionSessionId.value = null;
    pomodoroController.selectedGoalId = null;
    await tester.pumpAndSettle();
    await tester.binding.setSurfaceSize(const Size(480, 1800));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Objetivos'));
    await tester.pumpAndSettle();
    expect(find.text('Planificación'), findsOneWidget);
    expect(find.byKey(const ValueKey('goal-period-card')), findsOneWidget);
    expect(find.text('Todos los objetivos'), findsOneWidget);
    final createButton = find.byKey(
      const ValueKey('planning-create-button'),
    );
    await tester.scrollUntilVisible(
      createButton,
      320,
      scrollable: find.byType(Scrollable).first,
    );
    expect(createButton, findsOneWidget);
    expect(find.text('Agenda local de planificación'), findsNothing);

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

    await tester.tap(
      find.byKey(const ValueKey('settings-theme-selector')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find
          .byKey(
            const ValueKey(
              'settings-theme-option-sunshineAurora',
            ),
          )
          .last,
    );
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
      find.text('Dos vibraciones separadas para distinguir el final.'),
      findsOneWidget,
    );
    await tester.tap(vibrationSwitch);
    await tester.pumpAndSettle();
    expect(pomodoroController.isRunning.value, isFalse);
    expect(appSettingsController.completionVibrationEnabled.value, isFalse);
    await tester.tap(vibrationSwitch);
    await tester.pumpAndSettle();

    AppRouter.router.go(NotificationSettingsPage.routePath);
    await tester.pumpAndSettle();
    final soundSelectorFinder = find.byKey(
      const ValueKey('notification-sound-selector'),
    );
    var soundSelector = tester
        .widget<DropdownButtonFormField<PomodoroCompletionSound>>(
          soundSelectorFinder,
        );
    var expectedPalette = AppPalette.fromPreset(
      appSettingsController.themePreset.value,
      isDark: appSettingsController.isDarkMode.value,
    );
    expect(soundSelector.decoration.fillColor, expectedPalette.primaryMuted);
    final previousPreset = appSettingsController.themePreset.value;
    final comparisonPreset = previousPreset == AppThemePreset.sunsetTide
        ? AppThemePreset.natureFocus
        : AppThemePreset.sunsetTide;
    appSettingsController.themePreset.value = comparisonPreset;
    await tester.pumpAndSettle();
    soundSelector = tester
        .widget<DropdownButtonFormField<PomodoroCompletionSound>>(
          soundSelectorFinder,
        );
    expectedPalette = AppPalette.fromPreset(
      comparisonPreset,
      isDark: appSettingsController.isDarkMode.value,
    );
    expect(soundSelector.decoration.fillColor, expectedPalette.primaryMuted);
    appSettingsController.themePreset.value = previousPreset;
    await tester.pumpAndSettle();
    appSettingsController
      ..addNotification(
        title: 'Preparar lanzamiento',
        body: 'Revisar alcance',
        routePath: '/goals?goalId=goal-1&taskId=task-1',
        goalId: 'goal-1',
        taskId: 'task-1',
        pendingCount: 3,
        inProgressCount: 1,
        completedCount: 4,
      )
      ..addNotification(
        title: 'Rutina lista',
        body: 'Rutina: Mañana productiva',
        routePath: '/tasks',
      );
    await tester.pumpAndSettle();
    expect(find.text('Notificaciones'), findsWidgets);
    expect(find.text('Chriss'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('notification-kind-goal')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('notification-kind-routine')),
      findsOneWidget,
    );
    expect(find.text('Preparar lanzamiento'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('notification-goal-goal-1-listed')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('notification-goal-goal-1-inProgress')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('notification-goal-goal-1-completed')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('notification-goal-goal-1-listed')),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(
          const ValueKey('notification-goal-goal-1-inProgress'),
        ),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('notification-goal-goal-1-completed')),
        matching: find.text('4'),
      ),
      findsOneWidget,
    );
    expect(find.text('Revisar alcance'), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''),
      ),
      findsAtLeastNWidgets(2),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(widget.data ?? ''),
      ),
      findsAtLeastNWidgets(2),
    );
    final goalIcon = find.byKey(const ValueKey('notification-kind-goal'));
    final goalTime = find.byKey(const ValueKey('notification-time-goal'));
    final goalDate = find.byKey(const ValueKey('notification-date-goal'));
    final goalCard = find.byKey(const ValueKey('notification-card-goal'));
    expect(tester.getTopLeft(goalTime).dx, tester.getTopLeft(goalIcon).dx);
    expect(
      tester.getBottomRight(goalDate).dx,
      closeTo(tester.getBottomRight(goalCard).dx - 12, 1.1),
    );
    await tester.tapAt(const Offset(12, 700));
    await tester.pumpAndSettle();
    AppRouter.router.go(SettingsPage.routePath);
    await tester.pumpAndSettle();

    final settingsScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );
    await tester.scrollUntilVisible(
      find.text('Borrar todos los datos'),
      600,
      scrollable: settingsScrollable,
    );
    final deleteAllDataButton = find.byKey(
      const ValueKey('delete-all-database-data'),
    );
    await tester.ensureVisible(deleteAllDataButton);
    await tester.pumpAndSettle();
    await tester.tap(deleteAllDataButton);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('delete-database-data-dialog')),
      findsOneWidget,
    );
    var deleteButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('confirm-delete-database-data')),
    );
    expect(deleteButton.onPressed, isNull);
    await tester.enterText(
      find.byKey(const ValueKey('database-delete-confirmation-field')),
      'BORRAR',
    );
    await tester.pumpAndSettle();
    deleteButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('confirm-delete-database-data')),
    );
    expect(deleteButton.onPressed, isNotNull);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Idioma'),
      -500,
      scrollable: settingsScrollable,
    );
    expect(
      Localizations.localeOf(tester.element(find.text('Idioma'))).languageCode,
      'es',
    );
    await tester.ensureVisible(find.text('English'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Ver onboarding'),
      500,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    await tester.tap(find.text('Ver onboarding'));
    await tester.pumpAndSettle();
    expect(find.text('Todo tu día, en un lugar'), findsOneWidget);
    await tester.tap(find.text('Omitir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('English'),
      500,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
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
    final englishVibrationPatternSelector = find.byType(
      DropdownButtonFormField<PomodoroVibrationPattern>,
    );
    await tester.ensureVisible(englishVibrationPatternSelector);
    await tester.pumpAndSettle();
    await tester.tap(englishVibrationPatternSelector);
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

    await tester.scrollUntilVisible(
      find.text('Delete all data'),
      600,
      scrollable: settingsScrollable,
    );
    await tester.ensureVisible(deleteAllDataButton);
    await tester.pumpAndSettle();
    await tester.tap(deleteAllDataButton);
    await tester.pumpAndSettle();
    expect(find.text('Delete all data?'), findsOneWidget);
    expect(find.textContaining('Type DELETE to confirm'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
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
  Future<Task> createTask(String title, {int? durationMinutes}) async {
    final task = Task(
      id: 'test-task-${_nextId++}',
      title: title,
      createdAt: DateTime.now(),
      durationMinutes: durationMinutes,
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
