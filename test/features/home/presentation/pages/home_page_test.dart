import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_source.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/main.dart';

void main() {
  late _ControllableStatisticsReportRepository reportRepository;
  late TasksController tasksController;
  late PomodoroController pomodoroController;

  setUp(() async {
    await serviceLocator.reset();
    reportRepository = _ControllableStatisticsReportRepository();
    tasksController = TasksController(repository: _FakeTasksRepository());
    pomodoroController = PomodoroController(
      repository: _FakePomodoroSessionsRepository(),
    );

    serviceLocator
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
    pomodoroController.dispose();
    await serviceLocator.reset();
  });

  testWidgets(
    'uses shared reports and refreshes once per range or source signal',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(480, 1800));
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

      final stableCallCount = reportRepository.periods.length;
      await tester.pump();
      await tester.pump();
      expect(reportRepository.periods, hasLength(stableCallCount));

      await tester.ensureVisible(find.text('Rendimiento del mes'));
      await tester.tap(find.text('Día'));
      await tester.pumpAndSettle();
      expect(reportRepository.periods.last, StatisticsReportPeriod.day);

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

class _FakeTasksRepository extends Fake implements TasksRepository {}

class _FakePomodoroSessionsRepository extends Fake
    implements PomodoroSessionsRepository {}

class _FakeGoalsRepository extends Fake implements GoalsRepository {}

class _FakeCalendarEventsRepository extends Fake
    implements CalendarEventsRepository {}
