import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/routines/data/repositories/drift_routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';

void main() {
  group('DriftRoutinesRepository', () {
    test('persists and transactionally reorders a routine aggregate', () async {
      final directory = Directory.systemTemp.createTempSync(
        'michifocus_routines_repository',
      );
      final file = File('${directory.path}/michifocus.sqlite');
      var database = MichiFocusDatabase(NativeDatabase(file));
      var repository = DriftRoutinesRepository(RoutinesDao(database));
      final now = DateTime(2026, 8, 7, 8);
      final first = _item(
        id: 'item-1',
        position: 0,
        title: 'Preparar materiales',
        minute: 420,
        now: now,
      );
      final second = _item(
        id: 'item-2',
        position: 1,
        title: 'Trabajo profundo',
        minute: 450,
        now: now,
        pomodoroMode: RoutinePomodoroMode.custom,
        focusMinutes: 45,
        breakMinutes: 10,
      );

      addTearDown(() async {
        await database.close();
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      await repository.saveRoutine(
        _routine(now: now, items: [first, second]),
      );
      await expectLater(
        repository.deleteArchivedRoutine('routine-1'),
        throwsA(isA<StateError>()),
      );
      await repository.saveRoutine(
        _routine(
          now: now,
          items: [
            _copyItem(second, position: 0),
            _copyItem(first, position: 1),
          ],
        ),
      );
      await database.close();

      database = MichiFocusDatabase(NativeDatabase(file));
      repository = DriftRoutinesRepository(RoutinesDao(database));
      final routines = await repository.loadRoutines();

      expect(routines, hasLength(1));
      expect(routines.single.name, 'Manana productiva');
      expect(routines.single.weekdays, [1, 2, 3, 4, 5]);
      expect(
        routines.single.items.map((item) => item.id),
        ['item-2', 'item-1'],
      );
      expect(
        routines.single.items.first.pomodoroMode,
        RoutinePomodoroMode.custom,
      );
      expect(routines.single.items.first.customFocusMinutes, 45);
    });

    test('loads routine aggregates with globally grouped children', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftRoutinesRepository(RoutinesDao(database));
      final now = DateTime(2026, 8, 7, 8);

      addTearDown(database.close);

      await repository.saveRoutine(
        _routine(
          now: now,
          items: [
            _item(
              id: 'item-1',
              position: 0,
              title: 'Primero',
              minute: 420,
              now: now,
            ),
          ],
        ),
      );
      await repository.saveRoutine(
        _routine(
          id: 'routine-2',
          name: 'Rutina nocturna',
          now: now.add(const Duration(minutes: 1)),
          weekdays: const [6, 7],
          items: [
            _item(
              id: 'item-2',
              routineId: 'routine-2',
              position: 0,
              title: 'Segundo',
              minute: 1260,
              now: now,
            ),
          ],
        ),
      );

      final routines = await repository.loadRoutines();

      expect(routines.map((routine) => routine.id), ['routine-2', 'routine-1']);
      expect(routines.first.weekdays, [6, 7]);
      expect(routines.first.items.single.id, 'item-2');
      expect(routines.last.weekdays, [1, 2, 3, 4, 5]);
      expect(routines.last.items.single.id, 'item-1');
    });

    test(
      'materializes each due routine item as one ordinary task only once',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final repository = DriftRoutinesRepository(RoutinesDao(database));
        final tasksDao = TasksDao(database);
        final day = DateTime(2026, 8, 7, 9);

        addTearDown(database.close);
        await repository.saveRoutine(
          _routine(
            now: day,
            items: [
              _item(
                id: 'item-1',
                position: 0,
                title: 'Preparar',
                minute: 7 * 60,
                now: day,
              ),
              _item(
                id: 'item-2',
                position: 1,
                title: 'Estudiar',
                minute: 8 * 60 + 30,
                now: day,
              ),
            ],
          ),
        );

        final first = await repository.reconcileLocalDay(day);
        final second = await repository.reconcileLocalDay(day);
        final runs = await repository.loadRuns(startDate: day, endDate: day);
        final itemRuns = await repository.loadItemRuns(runs.single.id);
        final tasks = await tasksDao.getAllTasks();

        expect(first.createdRuns, 1);
        expect(first.createdTasks, 2);
        expect(second.createdRuns, 0);
        expect(second.createdTasks, 0);
        expect(runs, hasLength(1));
        expect(itemRuns, hasLength(2));
        expect(
          itemRuns.every((item) => item.taskId == item.taskIdSnapshot),
          isTrue,
        );
        expect(
          tasks.map((task) => task.title),
          containsAll(['Preparar', 'Estudiar']),
        );
        expect(tasks.map((task) => task.scheduledDate?.day).toSet(), {7});
        expect(tasks.map((task) => task.status).toSet(), {'listed'});
      },
    );

    test('skips optional work and shifts only pending routine tasks', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftRoutinesRepository(RoutinesDao(database));
      final tasksDao = TasksDao(database);
      final day = DateTime(2026, 8, 7, 9);
      addTearDown(database.close);

      await repository.saveRoutine(
        _routine(
          now: day,
          items: [
            _item(
              id: 'required',
              position: 0,
              title: 'Required',
              minute: 480,
              now: day,
            ),
            _item(
              id: 'optional',
              position: 1,
              title: 'Optional',
              minute: 540,
              now: day,
              isOptional: true,
            ),
          ],
        ),
      );
      await repository.reconcileLocalDay(day);
      final run = (await repository.loadRuns(
        startDate: day,
        endDate: day,
      )).single;
      final items = await repository.loadItemRuns(run.id);
      final required = items.firstWhere(
        (item) => item.sourceItemId == 'required',
      );
      final optional = items.firstWhere(
        (item) => item.sourceItemId == 'optional',
      );

      expect(await repository.skipOptionalItemRun(optional.id), isTrue);
      final skipped = (await repository.loadItemRuns(run.id)).firstWhere(
        (item) => item.id == optional.id,
      );
      expect(skipped.status, RoutineRunStatus.skipped);
      expect(skipped.taskId, isNull);
      expect(skipped.taskIdSnapshot, optional.taskId);
      expect(await tasksDao.findById(optional.taskId!), isNull);

      final startAt = day.add(const Duration(hours: 2));
      expect(
        await repository.shiftRemainingRun(
          routineRunId: run.id,
          currentItemRunId: required.id,
          startAt: startAt,
        ),
        isTrue,
      );
      final shifted = (await repository.loadItemRuns(run.id)).firstWhere(
        (item) => item.id == required.id,
      );
      expect(shifted.scheduledAtSnapshot, startAt);
      expect(
        (await tasksDao.findById(required.taskId!))!.scheduledDate,
        startAt,
      );
    });

    test(
      'marks an existing elapsed run missed without creating a past task',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final repository = DriftRoutinesRepository(RoutinesDao(database));
        final thursday = DateTime(2026, 8, 6, 9);
        final friday = DateTime(2026, 8, 7, 9);

        addTearDown(database.close);
        await repository.saveRoutine(
          _routine(
            now: thursday,
            items: [
              _item(
                id: 'item-1',
                position: 0,
                title: 'Preparar',
                minute: 7 * 60,
                now: thursday,
              ),
            ],
          ),
        );
        await repository.reconcileLocalDay(thursday);

        final result = await repository.reconcileLocalDay(friday);
        final yesterday = await repository.loadRuns(
          startDate: thursday,
          endDate: thursday,
        );

        expect(result.missedRuns, 1);
        expect(yesterday.single.status, RoutineRunStatus.missed);
        expect(
          (await repository.loadItemRuns(yesterday.single.id)).single.status,
          RoutineRunStatus.missed,
        );
      },
    );

    test(
      'records unreconciled elapsed dates as missed snapshots across years',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final repository = DriftRoutinesRepository(RoutinesDao(database));
        final tasksDao = TasksDao(database);
        final createdAt = DateTime(2027, 12, 30, 9);
        final currentDay = DateTime(2028, 1, 2, 9);

        addTearDown(database.close);
        await repository.saveRoutine(
          _routine(
            now: createdAt,
            weekdays: const [1, 2, 3, 4, 5, 6, 7],
            items: [
              _item(
                id: 'item-1',
                position: 0,
                title: 'Repasar',
                minute: 7 * 60,
                now: createdAt,
              ),
            ],
          ),
        );

        final first = await repository.reconcileLocalDay(currentDay);
        final second = await repository.reconcileLocalDay(currentDay);
        final runs = await repository.loadRuns(
          startDate: createdAt,
          endDate: currentDay,
        );
        final tasks = await tasksDao.getAllTasks();

        expect(first.missedRuns, 3);
        expect(first.createdRuns, 1);
        expect(first.createdTasks, 1);
        expect(second.missedRuns, 0);
        expect(second.createdRuns, 0);
        expect(second.createdTasks, 0);
        expect(runs, hasLength(4));
        expect(
          runs.take(3).every((run) => run.status == RoutineRunStatus.missed),
          isTrue,
        );
        expect(runs.last.status, RoutineRunStatus.scheduled);
        expect(tasks, hasLength(1));
        expect(tasks.single.scheduledDate?.day, 2);

        for (final missedRun in runs.take(3)) {
          final itemRun = (await repository.loadItemRuns(
            missedRun.id,
          )).single;
          expect(itemRun.status, RoutineRunStatus.missed);
          expect(itemRun.taskId, isNull);
          expect(itemRun.taskIdSnapshot, isNull);
          expect(itemRun.titleSnapshot, 'Repasar');
        }
      },
    );

    test('reconciles leap day without stale or future task rows', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftRoutinesRepository(RoutinesDao(database));
      final tasksDao = TasksDao(database);
      final createdAt = DateTime(2028, 2, 28, 20);
      final currentDay = DateTime(2028, 3, 1, 8);

      addTearDown(database.close);
      await repository.saveRoutine(
        _routine(
          now: createdAt,
          weekdays: const [1, 2, 3, 4, 5, 6, 7],
          items: [
            _item(
              id: 'item-1',
              position: 0,
              title: 'Leer',
              minute: 8 * 60,
              now: createdAt,
            ),
          ],
        ),
      );

      final result = await repository.reconcileLocalDay(currentDay);
      final runs = await repository.loadRuns(
        startDate: createdAt,
        endDate: currentDay.add(const Duration(days: 7)),
      );
      final tasks = await tasksDao.getAllTasks();

      expect(result.missedRuns, 2);
      expect(runs.map((run) => run.localDate.day), [28, 29, 1]);
      expect(
        runs.take(2).every((run) => run.status == RoutineRunStatus.missed),
        isTrue,
      );
      expect(tasks, hasLength(1));
      expect(tasks.single.scheduledDate, DateTime(2028, 3, 1, 8));
    });

    test(
      'serializes concurrent reconciliation without duplicate rows',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final repository = DriftRoutinesRepository(RoutinesDao(database));
        final day = DateTime(2026, 8, 7, 9);

        addTearDown(database.close);
        await repository.saveRoutine(
          _routine(
            now: day,
            items: [
              _item(
                id: 'item-1',
                position: 0,
                title: 'Preparar',
                minute: 8 * 60,
                now: day,
              ),
            ],
          ),
        );

        final results = await Future.wait([
          repository.reconcileLocalDay(day),
          repository.reconcileLocalDay(day),
        ]);
        final runs = await repository.loadRuns(startDate: day, endDate: day);
        final itemRuns = await repository.loadItemRuns(runs.single.id);
        final tasks = await TasksDao(database).getAllTasks();

        expect(results.fold(0, (sum, result) => sum + result.createdRuns), 1);
        expect(results.fold(0, (sum, result) => sum + result.createdTasks), 1);
        expect(runs, hasLength(1));
        expect(itemRuns, hasLength(1));
        expect(tasks, hasLength(1));
      },
    );

    test('uses calendar date across clock and UTC-local adjustments', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftRoutinesRepository(RoutinesDao(database));
      final createdAt = DateTime(2026, 8, 7, 23, 55);
      final adjustedClock = DateTime.utc(2026, 8, 7, 1, 5);

      addTearDown(database.close);
      await repository.saveRoutine(
        _routine(
          now: createdAt,
          items: [
            _item(
              id: 'item-1',
              position: 0,
              title: 'Preparar',
              minute: 8 * 60,
              now: createdAt,
            ),
          ],
        ),
      );

      final first = await repository.reconcileLocalDay(createdAt);
      final second = await repository.reconcileLocalDay(adjustedClock);
      final runs = await repository.loadRuns(
        startDate: DateTime(2026, 8, 7),
        endDate: DateTime(2026, 8, 7),
      );
      final tasks = await TasksDao(database).getAllTasks();

      expect(first.createdRuns, 1);
      expect(second.createdRuns, 0);
      expect(second.createdTasks, 0);
      expect(runs, hasLength(1));
      expect(tasks, hasLength(1));
      expect(tasks.single.scheduledDate, DateTime(2026, 8, 7, 8));
    });

    test('deleting a generated task retains its historical snapshot', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftRoutinesRepository(RoutinesDao(database));
      final tasksDao = TasksDao(database);
      final day = DateTime(2026, 8, 7, 9);

      addTearDown(database.close);
      await repository.saveRoutine(
        _routine(
          now: day,
          items: [
            _item(
              id: 'item-1',
              position: 0,
              title: 'Preparar',
              minute: 8 * 60,
              now: day,
            ),
          ],
        ),
      );
      await repository.reconcileLocalDay(day);
      final run = (await repository.loadRuns(
        startDate: day,
        endDate: day,
      )).single;
      final before = (await repository.loadItemRuns(run.id)).single;

      await tasksDao.deleteById(before.taskId!);
      final after = (await repository.loadItemRuns(run.id)).single;

      expect(after.taskId, isNull);
      expect(after.taskIdSnapshot, before.taskIdSnapshot);
      expect(after.titleSnapshot, 'Preparar');
      expect(after.scheduledAtSnapshot, before.scheduledAtSnapshot);
      expect(after.status, RoutineRunStatus.scheduled);
    });

    test(
      'synchronizes generated task status to the routine occurrence',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final repository = DriftRoutinesRepository(RoutinesDao(database));
        final tasksDao = TasksDao(database);
        final day = DateTime(2028, 2, 29, 9);

        addTearDown(database.close);
        await repository.saveRoutine(
          _routine(
            now: day,
            weekdays: const [DateTime.tuesday],
            items: [
              _item(
                id: 'item-1',
                position: 0,
                title: 'Repasar',
                minute: 9 * 60,
                now: day,
              ),
            ],
          ),
        );
        await repository.reconcileLocalDay(day);
        final run = (await repository.loadRuns(
          startDate: day,
          endDate: day,
        )).single;
        final itemRun = (await repository.loadItemRuns(run.id)).single;

        await tasksDao.updateStatus(
          id: itemRun.taskId!,
          status: 'in_progress',
          isCompleted: false,
          updatedAt: day.add(const Duration(minutes: 5)),
        );
        expect(
          (await repository.loadItemRuns(run.id)).single.status,
          RoutineRunStatus.inProgress,
        );

        await tasksDao.updateStatus(
          id: itemRun.taskId!,
          status: 'completed',
          isCompleted: true,
          updatedAt: day.add(const Duration(minutes: 35)),
        );
        expect(
          (await repository.loadItemRuns(run.id)).single.status,
          RoutineRunStatus.completed,
        );
        expect(
          (await repository.loadRuns(
            startDate: day,
            endDate: day,
          )).single.status,
          RoutineRunStatus.completed,
        );
      },
    );

    test(
      'updates a generated task template only for future occurrences',
      () async {
        final database = MichiFocusDatabase(NativeDatabase.memory());
        final repository = DriftRoutinesRepository(RoutinesDao(database));
        final tasksDao = TasksDao(database);
        final day = DateTime(2026, 8, 7, 9);

        addTearDown(database.close);
        await repository.saveRoutine(
          _routine(
            now: day,
            items: [
              _item(
                id: 'item-1',
                position: 0,
                title: 'Nombre original',
                minute: 8 * 60,
                now: day,
              ),
            ],
          ),
        );
        await repository.reconcileLocalDay(day);
        final run = (await repository.loadRuns(
          startDate: day,
          endDate: day,
        )).single;
        final itemRun = (await repository.loadItemRuns(run.id)).single;

        await tasksDao.updateTitle(
          id: itemRun.taskId!,
          title: 'Nombre de hoy',
          updatedAt: day.add(const Duration(minutes: 10)),
        );
        expect(
          (await repository.loadItemRuns(run.id)).single.titleSnapshot,
          'Nombre de hoy',
        );
        expect(
          (await repository.findRoutineById('routine-1'))!.items.single.title,
          'Nombre original',
        );

        expect(
          await repository.updateFutureTemplateTitleForTask(
            taskId: itemRun.taskId!,
            title: 'Nombre futuro',
          ),
          isTrue,
        );
        expect(
          (await repository.findRoutineById('routine-1'))!.items.single.title,
          'Nombre futuro',
        );
        expect(
          (await repository.loadItemRuns(run.id)).single.titleSnapshot,
          'Nombre de hoy',
        );
      },
    );

    test('changes lifecycle state without rewriting days or items', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final dao = RoutinesDao(database);
      final repository = DriftRoutinesRepository(dao);
      final now = DateTime(2026, 8, 7, 8);
      final pauseUntil = DateTime(2026, 8, 11);

      addTearDown(database.close);

      await repository.saveRoutine(
        _routine(
          now: now,
          items: [
            _item(
              id: 'item-1',
              position: 0,
              title: 'Original',
              minute: 420,
              now: now,
            ),
          ],
        ),
      );
      await (database.update(
        database.routineItemRecords,
      )..where((row) => row.id.equals('item-1'))).write(
        const RoutineItemRecordsCompanion(title: Value('Actualizado')),
      );
      final daysBefore = await dao.getDaysForRoutine('routine-1');
      final itemsBefore = await dao.getItemsForRoutine('routine-1');

      await repository.pauseRoutine('routine-1', until: pauseUntil);
      var routine = await repository.findRoutineById('routine-1');
      expect(routine?.status, RoutineStatus.paused);
      expect(routine?.pausedUntilDate, pauseUntil);
      expect(routine?.archivedAt, isNull);
      expect(await dao.getDaysForRoutine('routine-1'), daysBefore);
      expect(await dao.getItemsForRoutine('routine-1'), itemsBefore);

      await repository.resumeRoutine('routine-1');
      routine = await repository.findRoutineById('routine-1');
      expect(routine?.status, RoutineStatus.active);
      expect(routine?.pausedUntilDate, isNull);

      await repository.archiveRoutine('routine-1');
      routine = await repository.findRoutineById('routine-1');
      expect(routine?.status, RoutineStatus.archived);
      expect(routine?.archivedAt, isNotNull);
      await expectLater(
        repository.pauseRoutine('routine-1'),
        throwsA(isA<StateError>()),
      );

      await repository.restoreRoutine('routine-1');
      routine = await repository.findRoutineById('routine-1');
      expect(routine?.status, RoutineStatus.active);
      expect(routine?.archivedAt, isNull);
      expect(routine?.items.single.title, 'Actualizado');
      expect(await dao.getDaysForRoutine('routine-1'), daysBefore);
      expect(await dao.getItemsForRoutine('routine-1'), itemsBefore);

      await repository.pauseRoutine('routine-1');
      routine = await repository.findRoutineById('routine-1');
      expect(routine?.status, RoutineStatus.paused);
      expect(routine?.pausedUntilDate, isNull);
      expect(await dao.getDaysForRoutine('routine-1'), daysBefore);
      expect(await dao.getItemsForRoutine('routine-1'), itemsBefore);
    });

    test('preserves run snapshots through guarded hard deletes', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final routinesDao = RoutinesDao(database);
      final repository = DriftRoutinesRepository(routinesDao);
      final now = DateTime(2026, 8, 7, 9);
      final completedAt = now.add(const Duration(hours: 1));

      addTearDown(database.close);

      await GoalsDao(database).insertGoal(
        GoalRecordsCompanion.insert(
          id: 'goal-1',
          title: 'Bienestar',
          targetSessions: 4,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await TasksDao(database).insertTask(
        TaskRecordsCompanion.insert(
          id: 'task-1',
          title: 'Ejercicio',
          goalId: const Value('goal-1'),
          createdAt: now,
          updatedAt: now,
        ),
      );
      final item = _item(
        id: 'item-1',
        position: 0,
        title: 'Ejercicio',
        minute: 420,
        now: now,
        goalId: 'goal-1',
      );
      await repository.saveRoutine(
        _routine(
          now: now,
          status: RoutineStatus.archived,
          archivedAt: now,
          items: [item],
        ),
      );
      await GoalsDao(database).deleteById('goal-1');
      final detachedItem = (await routinesDao.getItemsForRoutine(
        'routine-1',
      )).single;
      expect(detachedItem.goalId, isNull);
      await repository.saveRun(
        RoutineRun(
          id: 'run-1',
          routineId: 'routine-1',
          sourceRoutineId: 'routine-1',
          localDate: now,
          status: RoutineRunStatus.completed,
          nameSnapshot: 'Manana productiva',
          iconKeySnapshot: 'sun',
          colorKeySnapshot: 'amber',
          scheduledStartMinuteSnapshot: 420,
          startedAt: now,
          completedAt: completedAt,
          createdAt: now,
          updatedAt: completedAt,
        ),
      );
      await repository.saveItemRun(
        RoutineItemRun(
          id: 'item-run-1',
          routineRunId: 'run-1',
          routineItemId: 'item-1',
          sourceItemId: 'item-1',
          taskId: 'task-1',
          taskIdSnapshot: 'task-1',
          positionSnapshot: 0,
          titleSnapshot: 'Ejercicio',
          scheduledAtSnapshot: now,
          durationMinutesSnapshot: 30,
          goalTitleSnapshot: 'Bienestar',
          isOptionalSnapshot: false,
          pomodoroModeSnapshot: RoutinePomodoroMode.none,
          status: RoutineRunStatus.completed,
          startedAt: now,
          completedAt: completedAt,
          createdAt: now,
          updatedAt: completedAt,
        ),
      );
      await _saveRuntime(database, now);

      await expectLater(
        repository.deleteArchivedRoutine('routine-1'),
        throwsA(isA<StateError>()),
      );
      await PomodoroRuntimeDao(database).clearActive();
      await repository.deleteArchivedRoutine('routine-1');

      final run = await routinesDao.findRun(
        sourceRoutineId: 'routine-1',
        localDate: '2026-08-07',
      );
      var itemRun = (await routinesDao.getItemRuns('run-1')).single;
      expect(await routinesDao.findRoutineById('routine-1'), isNull);
      expect(await routinesDao.getDaysForRoutine('routine-1'), isEmpty);
      expect(await routinesDao.getItemsForRoutine('routine-1'), isEmpty);
      expect(run?.routineId, isNull);
      expect(itemRun.routineItemId, isNull);
      expect(itemRun.taskId, 'task-1');
      expect(itemRun.titleSnapshot, 'Ejercicio');

      await TasksDao(database).deleteById('task-1');
      itemRun = (await routinesDao.getItemRuns('run-1')).single;
      expect(itemRun.taskId, isNull);
      expect(itemRun.taskIdSnapshot, 'task-1');

      await routinesDao.deleteRunById('run-1');
      expect(await routinesDao.getItemRuns('run-1'), isEmpty);
    });

    test('enforces occurrence, task-link, and value constraints', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftRoutinesRepository(RoutinesDao(database));
      final now = DateTime(2026, 8, 7, 7);

      addTearDown(database.close);

      await repository.saveRoutine(
        _routine(
          now: now,
          items: [
            _item(
              id: 'item-1',
              position: 0,
              title: 'Uno',
              minute: 420,
              now: now,
            ),
            _item(
              id: 'item-2',
              position: 1,
              title: 'Dos',
              minute: 450,
              now: now,
            ),
          ],
        ),
      );
      await TasksDao(database).insertTask(
        TaskRecordsCompanion.insert(
          id: 'task-1',
          title: 'Task',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await repository.saveRun(_scheduledRun(now));

      await expectLater(
        repository.saveRun(_scheduledRun(now, id: 'duplicate-run')),
        throwsA(isA<Exception>()),
      );

      await repository.saveItemRun(
        _scheduledItemRun(
          now: now,
          id: 'item-run-1',
          sourceItemId: 'item-1',
          routineItemId: 'item-1',
          taskId: 'task-1',
        ),
      );
      await expectLater(
        repository.saveItemRun(
          _scheduledItemRun(
            now: now,
            id: 'item-run-2',
            sourceItemId: 'item-2',
            routineItemId: 'item-2',
            taskId: 'task-1',
          ),
        ),
        throwsA(isA<Exception>()),
      );
      await repository.saveItemRun(
        _scheduledItemRun(
          now: now,
          id: 'detached-run-1',
          sourceItemId: 'detached-1',
        ),
      );
      await repository.saveItemRun(
        _scheduledItemRun(
          now: now,
          id: 'detached-run-2',
          sourceItemId: 'detached-2',
        ),
      );
      await expectLater(
        database
            .into(database.routineDayRecords)
            .insert(
              const RoutineDayRecordsCompanion(
                routineId: Value('routine-1'),
                weekday: Value(8),
              ),
            ),
        throwsA(isA<Exception>()),
      );

      await expectLater(
        database
            .into(database.routineRunRecords)
            .insert(
              RoutineRunRecordsCompanion.insert(
                id: 'invalid-completed-run',
                routineId: const Value('routine-1'),
                sourceRoutineId: 'routine-invalid',
                localDate: '2026-08-08',
                status: const Value('completed'),
                nameSnapshot: 'Invalid',
                iconKeySnapshot: 'sun',
                colorKeySnapshot: 'amber',
                scheduledStartMinuteSnapshot: 420,
                createdAt: now,
                updatedAt: now,
              ),
            ),
        throwsA(isA<Exception>()),
      );

      await repository.saveRoutine(
        _routine(
          now: now,
          status: RoutineStatus.archived,
          archivedAt: now,
          items: [
            _item(
              id: 'item-1',
              position: 0,
              title: 'Uno',
              minute: 420,
              now: now,
            ),
            _item(
              id: 'item-2',
              position: 1,
              title: 'Dos',
              minute: 450,
              now: now,
            ),
          ],
        ),
      );
      await expectLater(
        repository.deleteArchivedRoutine('routine-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('rolls back the whole aggregate when a child insert fails', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftRoutinesRepository(RoutinesDao(database));
      final now = DateTime(2026, 8, 7, 7);

      addTearDown(database.close);

      await expectLater(
        repository.saveRoutine(
          _routine(
            now: now,
            items: [
              _item(
                id: 'item-invalid-goal',
                position: 0,
                title: 'No debe persistir',
                minute: 420,
                now: now,
                goalId: 'missing-goal',
              ),
            ],
          ),
        ),
        throwsA(isA<Exception>()),
      );

      expect(await database.select(database.routineRecords).get(), isEmpty);
      expect(await database.select(database.routineDayRecords).get(), isEmpty);
      expect(await database.select(database.routineItemRecords).get(), isEmpty);
    });
  });
}

Routine _routine({
  required DateTime now,
  required List<RoutineItem> items,
  String id = 'routine-1',
  String name = 'Manana productiva',
  List<int> weekdays = const [1, 2, 3, 4, 5],
  RoutineStatus status = RoutineStatus.active,
  DateTime? archivedAt,
}) {
  return Routine(
    id: id,
    name: name,
    description: 'Inicio ordenado',
    iconKey: 'sun',
    colorKey: 'amber',
    status: status,
    archivedAt: archivedAt,
    createdAt: now,
    updatedAt: now,
    weekdays: weekdays,
    items: items,
  );
}

RoutineItem _item({
  required String id,
  required int position,
  required String title,
  required int minute,
  required DateTime now,
  String routineId = 'routine-1',
  String? goalId,
  RoutinePomodoroMode pomodoroMode = RoutinePomodoroMode.none,
  int? focusMinutes,
  int? breakMinutes,
  bool isOptional = false,
}) {
  return RoutineItem(
    id: id,
    routineId: routineId,
    position: position,
    title: title,
    scheduledMinute: minute,
    durationMinutes: 30,
    goalId: goalId,
    isOptional: isOptional,
    pomodoroMode: pomodoroMode,
    customFocusMinutes: focusMinutes,
    customBreakMinutes: breakMinutes,
    createdAt: now,
    updatedAt: now,
  );
}

RoutineItem _copyItem(RoutineItem item, {required int position}) {
  return RoutineItem(
    id: item.id,
    routineId: item.routineId,
    position: position,
    title: item.title,
    scheduledMinute: item.scheduledMinute,
    durationMinutes: item.durationMinutes,
    goalId: item.goalId,
    isOptional: item.isOptional,
    reminderMinutesBefore: item.reminderMinutesBefore,
    pomodoroMode: item.pomodoroMode,
    customFocusMinutes: item.customFocusMinutes,
    customBreakMinutes: item.customBreakMinutes,
    createdAt: item.createdAt,
    updatedAt: item.updatedAt,
  );
}

RoutineRun _scheduledRun(DateTime now, {String id = 'run-1'}) {
  return RoutineRun(
    id: id,
    routineId: 'routine-1',
    sourceRoutineId: 'routine-1',
    localDate: now,
    status: RoutineRunStatus.scheduled,
    nameSnapshot: 'Manana productiva',
    iconKeySnapshot: 'sun',
    colorKeySnapshot: 'amber',
    scheduledStartMinuteSnapshot: 420,
    createdAt: now,
    updatedAt: now,
  );
}

RoutineItemRun _scheduledItemRun({
  required DateTime now,
  required String id,
  required String sourceItemId,
  String? routineItemId,
  String? taskId,
}) {
  return RoutineItemRun(
    id: id,
    routineRunId: 'run-1',
    routineItemId: routineItemId,
    sourceItemId: sourceItemId,
    taskId: taskId,
    taskIdSnapshot: taskId,
    positionSnapshot: sourceItemId == 'item-1' ? 0 : 1,
    titleSnapshot: sourceItemId,
    scheduledAtSnapshot: now,
    durationMinutesSnapshot: 30,
    isOptionalSnapshot: false,
    pomodoroModeSnapshot: RoutinePomodoroMode.none,
    status: RoutineRunStatus.scheduled,
    createdAt: now,
    updatedAt: now,
  );
}

Future<void> _saveRuntime(MichiFocusDatabase database, DateTime now) {
  return PomodoroRuntimeDao(database).saveActive(
    PomodoroRuntimeRecordsCompanion.insert(
      id: 'runtime',
      taskId: const Value('task-1'),
      phase: 'focus',
      isRunning: false,
      remainingSeconds: 300,
      phaseTotalSeconds: 1500,
      cadenceFocusMinutes: 25,
      cadenceBreakMinutes: 5,
      longBreakMinutes: 15,
      longBreakFrequency: 4,
      autoStartBreak: true,
      autoStartFocus: false,
      planMode: 'continuous',
      blockIndex: 1,
      blockCount: 1,
      taskFocusedSecondsAtStart: 0,
      createdAt: now,
      updatedAt: now,
    ),
  );
}
