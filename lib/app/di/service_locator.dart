import 'package:get_it/get_it.dart';
import 'package:pomodoro_app_v1/features/tasks/data/datasources/tasks_database.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/drift_tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
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
  await tasksController.loadTasks();
  serviceLocator.registerSingleton<TasksController>(tasksController);
}
