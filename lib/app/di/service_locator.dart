import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:pomodoro_app_v1/app/data/datasources/legacy_database_migrator.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/calendar/data/repositories/drift_calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/data/repositories/drift_goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/repositories/drift_pomodoro_runtime_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/repositories/drift_pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_runtime_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/reports/data/repositories/drift_statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
import 'package:pomodoro_app_v1/features/routines/data/repositories/drift_routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/settings/data/repositories/file_settings_repository.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/drift_tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  await LegacyDatabaseMigrator.migrateIfNeeded();
  if (!serviceLocator.isRegistered<SettingsRepository>()) {
    serviceLocator.registerLazySingleton<SettingsRepository>(
      FileSettingsRepository.new,
    );
  }

  if (!serviceLocator.isRegistered<MichiFocusDatabase>()) {
    serviceLocator.registerSingleton<MichiFocusDatabase>(MichiFocusDatabase());
  }

  if (!serviceLocator.isRegistered<GoalsDao>()) {
    serviceLocator
      ..registerLazySingleton<GoalsDao>(
        () => GoalsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<GoalsRepository>(
        () => DriftGoalsRepository(serviceLocator<GoalsDao>()),
      );
  }

  if (!serviceLocator.isRegistered<GoalsController>()) {
    final goalsController = GoalsController(
      repository: serviceLocator<GoalsRepository>(),
    );
    serviceLocator.registerSingleton<GoalsController>(goalsController);
    _loadInBackground(goalsController.loadGoals());
  }

  if (!serviceLocator.isRegistered<PomodoroSessionsDao>()) {
    serviceLocator
      ..registerLazySingleton<PomodoroSessionsDao>(
        () => PomodoroSessionsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<PomodoroSessionsRepository>(
        () => DriftPomodoroSessionsRepository(
          serviceLocator<PomodoroSessionsDao>(),
        ),
      )
      ..registerLazySingleton<PomodoroRuntimeDao>(
        () => PomodoroRuntimeDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<PomodoroRuntimeRepository>(
        () => DriftPomodoroRuntimeRepository(
          serviceLocator<PomodoroRuntimeDao>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<PomodoroController>()) {
    final pomodoroController = PomodoroController(
      repository: serviceLocator<PomodoroSessionsRepository>(),
      runtimeRepository: serviceLocator<PomodoroRuntimeRepository>(),
    );
    serviceLocator.registerSingleton<PomodoroController>(pomodoroController);
    _loadInBackground(pomodoroController.initialize());
  }

  if (!serviceLocator.isRegistered<CalendarEventsDao>()) {
    serviceLocator
      ..registerLazySingleton<CalendarEventsDao>(
        () => CalendarEventsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<CalendarEventsRepository>(
        () => DriftCalendarEventsRepository(
          serviceLocator<CalendarEventsDao>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<CalendarController>()) {
    final calendarController = CalendarController(
      repository: serviceLocator<CalendarEventsRepository>(),
    );
    serviceLocator.registerSingleton<CalendarController>(calendarController);
    _loadInBackground(calendarController.loadEvents());
  }

  if (!serviceLocator.isRegistered<TasksDao>()) {
    serviceLocator
      ..registerLazySingleton<TasksDao>(
        () => TasksDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<TasksRepository>(
        () => DriftTasksRepository(serviceLocator<TasksDao>()),
      );
  }

  if (!serviceLocator.isRegistered<RoutinesDao>()) {
    serviceLocator.registerLazySingleton<RoutinesDao>(
      () => RoutinesDao(serviceLocator<MichiFocusDatabase>()),
    );
  }
  if (!serviceLocator.isRegistered<RoutinesRepository>()) {
    serviceLocator.registerLazySingleton<RoutinesRepository>(
      () => DriftRoutinesRepository(serviceLocator<RoutinesDao>()),
    );
  }
  if (!serviceLocator.isRegistered<RoutinesController>()) {
    final routinesController = RoutinesController(
      repository: serviceLocator<RoutinesRepository>(),
    );
    serviceLocator.registerSingleton<RoutinesController>(routinesController);
    _loadInBackground(routinesController.load());
  }

  if (!serviceLocator.isRegistered<GenerateStatisticsReport>()) {
    serviceLocator
      ..registerLazySingleton<ReportsDao>(
        () => ReportsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<StatisticsReportRepository>(
        () => DriftStatisticsReportRepository(serviceLocator<ReportsDao>()),
      )
      ..registerLazySingleton<GenerateStatisticsReport>(
        () => GenerateStatisticsReport(
          repository: serviceLocator<StatisticsReportRepository>(),
        ),
      );
  }

  if (serviceLocator.isRegistered<TasksController>()) {
    return;
  }

  final tasksController = TasksController(
    repository: serviceLocator<TasksRepository>(),
  );
  serviceLocator.registerSingleton<TasksController>(tasksController);
  _loadInBackground(tasksController.loadTasks());
}

void _loadInBackground(Future<void> load) {
  unawaited(
    load.catchError((Object error, StackTrace stackTrace) {
      Zone.current.handleUncaughtError(error, stackTrace);
    }),
  );
}
