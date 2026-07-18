import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:pomodoro_app_v1/features/calendar/data/datasources/calendar_events_database.dart';
import 'package:pomodoro_app_v1/features/calendar/data/repositories/drift_calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/data/datasources/goals_database.dart';
import 'package:pomodoro_app_v1/features/goals/data/repositories/drift_goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/datasources/pomodoro_sessions_database.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/repositories/drift_pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/settings/data/repositories/file_settings_repository.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/data/datasources/tasks_database.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/drift_tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  if (!serviceLocator.isRegistered<SettingsRepository>()) {
    serviceLocator.registerLazySingleton<SettingsRepository>(
      FileSettingsRepository.new,
    );
  }

  if (!serviceLocator.isRegistered<GoalsDatabase>()) {
    serviceLocator
      ..registerSingleton<GoalsDatabase>(GoalsDatabase())
      ..registerLazySingleton<GoalsDao>(
        () => GoalsDao(serviceLocator<GoalsDatabase>()),
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

  if (!serviceLocator.isRegistered<PomodoroSessionsDatabase>()) {
    serviceLocator
      ..registerSingleton<PomodoroSessionsDatabase>(
        PomodoroSessionsDatabase(),
      )
      ..registerLazySingleton<PomodoroSessionsDao>(
        () => PomodoroSessionsDao(
          serviceLocator<PomodoroSessionsDatabase>(),
        ),
      )
      ..registerLazySingleton<PomodoroSessionsRepository>(
        () => DriftPomodoroSessionsRepository(
          serviceLocator<PomodoroSessionsDao>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<PomodoroController>()) {
    final pomodoroController = PomodoroController(
      repository: serviceLocator<PomodoroSessionsRepository>(),
    );
    serviceLocator.registerSingleton<PomodoroController>(pomodoroController);
    _loadInBackground(pomodoroController.loadSessions());
  }

  if (!serviceLocator.isRegistered<CalendarEventsDatabase>()) {
    serviceLocator
      ..registerSingleton<CalendarEventsDatabase>(CalendarEventsDatabase())
      ..registerLazySingleton<CalendarEventsDao>(
        () => CalendarEventsDao(serviceLocator<CalendarEventsDatabase>()),
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

  if (serviceLocator.isRegistered<TasksController>()) {
    return;
  }

  serviceLocator
    ..registerSingleton<TasksDatabase>(TasksDatabase())
    ..registerLazySingleton<TasksDao>(
      () => TasksDao(serviceLocator<TasksDatabase>()),
    )
    ..registerLazySingleton<TasksRepository>(
      () => DriftTasksRepository(serviceLocator<TasksDao>()),
    );

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
