import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/tasks/data/datasources/tasks_database.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/drift_tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

void main() {
  group('DriftTasksRepository', () {
    test('persists tasks in the local SQLite database file', () async {
      final directory = Directory.systemTemp.createTempSync(
        'michifocus_tasks_test',
      );
      final file = File('${directory.path}/tasks.sqlite');
      var database = TasksDatabase(NativeDatabase(file));
      var repository = DriftTasksRepository(TasksDao(database));

      addTearDown(() async {
        await database.close();
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      final createdTask = await repository.createTask('Persistir M2');
      await database.close();

      database = TasksDatabase(NativeDatabase(file));
      repository = DriftTasksRepository(TasksDao(database));

      final tasks = await repository.loadTasks();

      expect(tasks, hasLength(1));
      expect(tasks.single.id, createdTask.id);
      expect(tasks.single.title, 'Persistir M2');
      expect(tasks.single.status, TaskStatus.listed);
      expect(tasks.single.isCompleted, isFalse);
      expect(tasks.single.scheduledDate, isNull);
      expect(tasks.single.goalId, isNull);
    });

    test('persists planned task schedule and goal assignment', () async {
      final database = TasksDatabase(NativeDatabase.memory());
      final repository = DriftTasksRepository(TasksDao(database));
      final scheduledDate = DateTime(2026, 7, 11);

      addTearDown(database.close);

      final task = await repository.createPlannedTask(
        title: 'Planificada',
        scheduledDate: scheduledDate,
        goalId: 'goal-1',
        durationMinutes: 45,
      );

      expect(task.title, 'Planificada');
      expect(task.scheduledDate, scheduledDate);
      expect(task.goalId, 'goal-1');
      expect(task.durationMinutes, 45);
      expect(task.status, TaskStatus.listed);
    });

    test('updates and deletes tasks through the repository boundary', () async {
      final database = TasksDatabase(NativeDatabase.memory());
      final repository = DriftTasksRepository(TasksDao(database));

      addTearDown(database.close);

      final createdTask = await repository.createTask('Inicial');
      final editedTask = await repository.updateTaskTitle(
        createdTask.id,
        'Editada',
      );
      final completedTask = await repository.toggleTaskCompletion(
        createdTask.id,
      );
      final activeTask = await repository.updateTaskStatus(
        createdTask.id,
        TaskStatus.inProgress,
      );
      final scheduledTask = await repository.scheduleTask(
        createdTask.id,
        DateTime(2026, 7, 11),
      );
      final assignedTask = await repository.assignTaskToGoal(
        createdTask.id,
        'goal-2',
      );

      expect(editedTask?.title, 'Editada');
      expect(completedTask?.isCompleted, isTrue);
      expect(completedTask?.status, TaskStatus.completed);
      expect(activeTask?.status, TaskStatus.inProgress);
      expect(scheduledTask?.scheduledDate, DateTime(2026, 7, 11));
      expect(assignedTask?.goalId, 'goal-2');

      await repository.deleteTask(createdTask.id);

      expect(await repository.loadTasks(), isEmpty);
    });
  });
}
