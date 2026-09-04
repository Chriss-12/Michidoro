import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/drift_tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

void main() {
  group('DriftTasksRepository', () {
    test('persists tasks in the local SQLite database file', () async {
      final directory = Directory.systemTemp.createTempSync(
        'michifocus_tasks_test',
      );
      final file = File('${directory.path}/tasks.sqlite');
      var database = MichiFocusDatabase(NativeDatabase(file));
      var repository = DriftTasksRepository(TasksDao(database));

      addTearDown(() async {
        await database.close();
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      final createdTask = await repository.createTask(
        'Persistir M2',
        durationMinutes: 25,
      );
      await database.close();

      database = MichiFocusDatabase(NativeDatabase(file));
      repository = DriftTasksRepository(TasksDao(database));

      final tasks = await repository.loadTasks();

      expect(tasks, hasLength(1));
      expect(tasks.single.id, createdTask.id);
      expect(tasks.single.title, 'Persistir M2');
      expect(tasks.single.status, TaskStatus.listed);
      expect(tasks.single.isCompleted, isFalse);
      expect(tasks.single.scheduledDate, isNull);
      expect(tasks.single.goalId, isNull);
      expect(tasks.single.durationMinutes, 25);
    });

    test('persists planned task schedule and goal assignment', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftTasksRepository(TasksDao(database));
      final scheduledDate = DateTime(2026, 7, 11);

      addTearDown(database.close);

      await _insertGoal(database, 'goal-1');

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
      final database = MichiFocusDatabase(NativeDatabase.memory());
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
      await _insertGoal(database, 'goal-2');
      final assignedTask = await repository.assignTaskToGoal(
        createdTask.id,
        'goal-2',
      );
      final plannedTask = await repository.updateTaskPlanning(
        id: createdTask.id,
        goalId: 'goal-2',
        durationMinutes: 73,
      );

      expect(editedTask?.title, 'Editada');
      expect(completedTask?.isCompleted, isTrue);
      expect(completedTask?.status, TaskStatus.completed);
      expect(activeTask?.status, TaskStatus.inProgress);
      expect(scheduledTask?.scheduledDate, DateTime(2026, 7, 11));
      expect(assignedTask?.goalId, 'goal-2');
      expect(plannedTask?.goalId, 'goal-2');
      expect(plannedTask?.durationMinutes, 73);

      await repository.deleteTask(createdTask.id);

      expect(await repository.loadTasks(), isEmpty);
    });

    test(
      'records immutable completion transitions without duplicates',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final repository = DriftTasksRepository(TasksDao(database));
        final reportsDao = ReportsDao(database);

        addTearDown(database.close);

        final task = await repository.createPlannedTask(
          title: 'Historial confiable',
          scheduledDate: DateTime(2026, 7, 28),
        );
        expect(task.legacyCompletionUnknown, isFalse);

        final rangeStart = DateTime.now().subtract(const Duration(minutes: 1));
        await repository.updateTaskStatus(task.id, TaskStatus.completed);
        await repository.updateTaskStatus(task.id, TaskStatus.completed);
        var events = await reportsDao.getCompletionEventsInRange(
          start: rangeStart,
          end: DateTime.now().add(const Duration(minutes: 1)),
        );

        expect(events, hasLength(1));
        expect(events.single.taskId, task.id);
        expect(events.single.taskIdSnapshot, task.id);
        expect(events.single.scheduledDateSnapshot, DateTime(2026, 7, 28));

        await repository.updateTaskStatus(task.id, TaskStatus.inProgress);
        await Future<void>.delayed(const Duration(milliseconds: 1));
        await repository.updateTaskStatus(task.id, TaskStatus.completed);
        events = await reportsDao.getCompletionEventsInRange(
          start: rangeStart,
          end: DateTime.now().add(const Duration(minutes: 1)),
        );

        expect(events, hasLength(2));

        await repository.deleteTask(task.id);
        events = await reportsDao.getCompletionEventsInRange(
          start: rangeStart,
          end: DateTime.now().add(const Duration(minutes: 1)),
        );

        expect(events, hasLength(2));
        expect(events.every((event) => event.taskId == null), isTrue);
        expect(
          events.every((event) => event.taskIdSnapshot == task.id),
          isTrue,
        );
      },
    );

    test(
      'enforces links and preserves history when parents are deleted',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final now = DateTime(2026);
        addTearDown(database.close);

        await expectLater(
          database
              .into(database.taskRecords)
              .insert(
                TaskRecordsCompanion.insert(
                  id: 'invalid-task',
                  title: 'Invalid',
                  goalId: const Value('missing-goal'),
                  createdAt: now,
                  updatedAt: now,
                ),
              ),
          throwsA(isA<Object>()),
        );

        await _insertGoal(database, 'goal-1');
        await database
            .into(database.taskRecords)
            .insert(
              TaskRecordsCompanion.insert(
                id: 'task-1',
                title: 'Linked task',
                goalId: const Value('goal-1'),
                createdAt: now,
                updatedAt: now,
              ),
            );
        await database
            .into(database.pomodoroSessionRecords)
            .insert(
              PomodoroSessionRecordsCompanion.insert(
                id: 'session-1',
                startedAt: now,
                endedAt: now.add(const Duration(minutes: 25)),
                plannedSeconds: 1500,
                focusedSeconds: 1500,
                goalId: const Value('goal-1'),
                taskId: const Value('task-1'),
                status: 'completed',
                createdAt: now,
              ),
            );

        await GoalsDao(database).deleteById('goal-1');
        expect((await TasksDao(database).findById('task-1'))?.goalId, isNull);
        expect(
          (await PomodoroSessionsDao(database).findById('session-1'))?.goalId,
          isNull,
        );

        await TasksDao(database).deleteById('task-1');
        expect(
          (await PomodoroSessionsDao(database).findById('session-1'))?.taskId,
          isNull,
        );
      },
    );

    test('completion event ids remain unique within one timestamp', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final dao = TasksDao(database);
      final now = DateTime(2026, 7, 28, 12);
      addTearDown(database.close);

      await dao.insertTask(
        TaskRecordsCompanion.insert(
          id: 'same-tick',
          title: 'Mismo instante',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await dao.updateStatus(
        id: 'same-tick',
        status: 'completed',
        isCompleted: true,
        updatedAt: now,
      );
      await dao.updateStatus(
        id: 'same-tick',
        status: 'in_progress',
        isCompleted: false,
        updatedAt: now,
      );
      await dao.updateStatus(
        id: 'same-tick',
        status: 'completed',
        isCompleted: true,
        updatedAt: now,
      );

      final events = await ReportsDao(database).getCompletionEventsInRange(
        start: now.subtract(const Duration(seconds: 1)),
        end: now.add(const Duration(seconds: 1)),
      );
      expect(events, hasLength(2));
      expect(events.map((event) => event.id).toSet(), hasLength(2));
    });
  });
}

Future<void> _insertGoal(MichiFocusDatabase database, String id) async {
  final now = DateTime(2026);
  await database
      .into(database.goalRecords)
      .insert(
        GoalRecordsCompanion.insert(
          id: id,
          title: id,
          targetSessions: 1,
          createdAt: now,
          updatedAt: now,
        ),
      );
}
