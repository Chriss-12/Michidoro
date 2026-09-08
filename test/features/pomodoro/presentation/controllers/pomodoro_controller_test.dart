import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_task_plan.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_runtime_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';

void main() {
  group('PomodoroController', () {
    test('starts and pauses a focus session', () async {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
        focusMinutes: 10,
      )..start();
      await controller.tick();
      controller.pause();

      expect(controller.isRunning.value, isFalse);
      expect(controller.remainingSeconds.value, 599);
      expect(controller.completedPomodoros.value, 0);
    });

    test('resets the current session without saving history', () {
      final controller =
          PomodoroController(
              repository: _MemoryPomodoroSessionsRepository(),
              focusMinutes: 10,
            )
            ..start()
            ..reset();

      expect(controller.isRunning.value, isFalse);
      expect(controller.remainingSeconds.value, 600);
      expect(controller.sessions.value, isEmpty);
    });

    test(
      'resets runtime and history state after the database is cleared',
      () async {
        final repository = _MemoryPomodoroSessionsRepository();
        await repository.saveCompletedSession(
          startedAt: DateTime(2026, 8, 11, 8),
          endedAt: DateTime(2026, 8, 11, 8, 25),
          plannedSeconds: 1500,
          focusedSeconds: 1500,
          taskId: 'task-1',
        );
        final controller = PomodoroController(repository: repository);
        await controller.loadSessions();
        controller
          ..selectTask(
            taskId: 'task-1',
            taskTitle: 'Task',
            estimatedSeconds: 3600,
          )
          ..maximumConcentrationMode = true
          ..start()
          ..stopForDatabaseReset()
          ..resetAfterDatabaseClear();

        expect(controller.isRunning.value, isFalse);
        expect(controller.sessions.value, isEmpty);
        expect(controller.selectedTaskId, isNull);
        expect(controller.selectedGoalId, isNull);
        expect(controller.pendingReflectionSessionId.value, isNull);
        expect(controller.hasActiveRuntime.value, isFalse);
        expect(controller.hasStartedRuntime.value, isFalse);
        expect(controller.maximumConcentrationEnabled.value, isFalse);
        expect(controller.currentBlockIndex.value, 1);
        expect(controller.totalBlocks.value, 1);
      },
    );

    test('discards an interrupted session without saving history', () async {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
        focusMinutes: 10,
      )..start();

      await controller.tick();
      controller.discardSession();

      expect(controller.isRunning.value, isFalse);
      expect(controller.remainingSeconds.value, 600);
      expect(controller.sessions.value, isEmpty);
    });

    test(
      'discarding the active runtime releases its task immediately',
      () async {
        final controller = PomodoroController(
          repository: _MemoryPomodoroSessionsRepository(),
        )..selectTask(taskId: 'task-1', taskTitle: 'Tarea del objetivo');
        addTearDown(controller.dispose);
        controller.start();

        await controller.discardActiveRuntimeWithoutSaving();

        expect(controller.isRunning.value, isFalse);
        expect(controller.hasActiveRuntime.value, isFalse);
        expect(controller.selectedTaskId, isNull);
        expect(controller.sessions.value, isEmpty);
      },
    );

    test('maximum concentration survives pause and clears on discard', () {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
      )..maximumConcentrationMode = true;

      expect(controller.hasStartedRuntime.value, isFalse);
      controller
        ..start()
        ..pause();
      expect(controller.hasStartedRuntime.value, isTrue);
      expect(controller.maximumConcentrationEnabled.value, isTrue);

      controller.discardSession();
      expect(controller.hasStartedRuntime.value, isFalse);
      expect(controller.maximumConcentrationEnabled.value, isFalse);
    });

    test('maximum concentration enables screen awake but allows opt out', () {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
      )..maximumConcentrationMode = true;

      expect(controller.keepScreenAwake, isTrue);

      controller.keepScreenAwake = false;

      expect(controller.maximumConcentrationMode, isTrue);
      expect(controller.keepScreenAwake, isFalse);
    });

    test('maximum concentration clears when the active task is released', () {
      final controller =
          PomodoroController(
              repository: _MemoryPomodoroSessionsRepository(),
            )
            ..selectTask(taskId: 'task-1', taskTitle: 'Task')
            ..maximumConcentrationMode = true
            ..clearSelectedTask();

      expect(controller.maximumConcentrationEnabled.value, isFalse);
    });

    test('restarts a task Pomodoro from zero and keeps it running', () async {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
        focusMinutes: 10,
      )..start();

      await controller.tick();
      controller.restartSession();

      expect(controller.isRunning.value, isTrue);
      expect(controller.remainingSeconds.value, 600);
      expect(controller.sessions.value, isEmpty);
    });

    test('completes focus and starts a short break by default', () async {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
        focusMinutes: 10,
      )..start();

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(controller.isRunning.value, isTrue);
      expect(controller.currentPhase, PomodoroPhase.shortBreak);
      expect(controller.remainingSeconds.value, 300);
      expect(controller.completedPomodoros.value, 1);
      expect(controller.totalFocusSeconds.value, 600);
      expect(
        controller.sessions.value.single.status,
        PomodoroSessionStatus.completed,
      );
    });

    test(
      'synchronizes running focus time after returning from background',
      () async {
        final clock = _FakeClock(DateTime(2026, 1, 1, 9));
        final controller = PomodoroController(
          repository: _MemoryPomodoroSessionsRepository(),
          focusMinutes: 10,
          now: clock.now,
        )..start();

        clock.advance(const Duration(minutes: 2));
        await controller.synchronizeWithClock();

        expect(controller.isRunning.value, isTrue);
        expect(controller.currentPhase, PomodoroPhase.focus);
        expect(controller.remainingSeconds.value, 8 * 60);
        expect(controller.completedPomodoros.value, 0);
      },
    );

    test(
      'completes focus and advances break time after background resume',
      () async {
        final clock = _FakeClock(DateTime(2026, 1, 1, 9));
        final repository = _MemoryPomodoroSessionsRepository();
        final controller =
            PomodoroController(
                repository: repository,
                now: clock.now,
              )
              ..setFocusSeconds(60)
              ..setShortBreakSeconds(20)
              ..start();

        clock.advance(const Duration(seconds: 70));
        await controller.synchronizeWithClock();

        expect(controller.isRunning.value, isTrue);
        expect(controller.currentPhase, PomodoroPhase.shortBreak);
        expect(controller.remainingSeconds.value, 10);
        expect(controller.completedPomodoros.value, 1);
        expect(repository.sessions.single.focusedSeconds, 60);
        expect(repository.sessions.single.startedAt, DateTime(2026, 1, 1, 9));
        expect(
          repository.sessions.single.endedAt,
          DateTime(2026, 1, 1, 9, 1),
        );
      },
    );

    test(
      'continues into the next focus when auto-start focus is enabled',
      () async {
        final clock = _FakeClock(DateTime(2026, 1, 1, 9));
        final repository = _MemoryPomodoroSessionsRepository();
        final controller =
            PomodoroController(
                repository: repository,
                autoStartFocus: true,
                now: clock.now,
              )
              ..setFocusSeconds(60)
              ..setShortBreakSeconds(20)
              ..start();

        clock.advance(const Duration(seconds: 140));
        await controller.synchronizeWithClock();

        expect(controller.currentPhase, PomodoroPhase.shortBreak);
        expect(controller.completedPomodoros.value, 2);
        expect(repository.sessions.last.startedAt, DateTime(2026, 1, 1, 9));
        expect(
          repository.sessions.last.endedAt,
          DateTime(2026, 1, 1, 9, 1),
        );
        expect(
          repository.sessions.first.startedAt,
          DateTime(2026, 1, 1, 9, 1, 20),
        );
        expect(
          repository.sessions.first.endedAt,
          DateTime(2026, 1, 1, 9, 2, 20),
        );
      },
    );

    test('stops for now and stores only elapsed focus seconds', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final controller = PomodoroController(
        repository: repository,
        focusMinutes: 10,
      )..start();

      controller.remainingSeconds.value = 540;
      await controller.finishEarly();

      expect(controller.isRunning.value, isFalse);
      expect(controller.currentPhase, PomodoroPhase.focus);
      expect(controller.remainingSeconds.value, 600);
      expect(controller.completedPomodoros.value, 0);
      expect(controller.totalFocusSeconds.value, 60);
      expect(repository.sessions.single.focusedSeconds, 60);
      expect(repository.sessions.single.plannedSeconds, 600);
      expect(repository.sessions.single.status, PomodoroSessionStatus.partial);
      expect(controller.pendingReflectionSessionId.value, isNull);
    });

    test('finishes a break and returns to the next focus', () async {
      var breakNotifications = 0;
      final controller =
          PomodoroController(
              repository: _MemoryPomodoroSessionsRepository(),
              focusMinutes: 10,
            )
            ..onBreakCompleted = () async {
              breakNotifications += 1;
            }
            ..start();

      controller.remainingSeconds.value = 1;
      await controller.tick();
      controller.remainingSeconds.value = 1;
      await controller.tick();
      await Future<void>.delayed(Duration.zero);

      expect(controller.isRunning.value, isFalse);
      expect(controller.currentPhase, PomodoroPhase.focus);
      expect(controller.remainingSeconds.value, 600);
      expect(controller.completedPomodoros.value, 1);
      expect(breakNotifications, 1);
    });

    test('uses a long break after the configured focus frequency', () async {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
        focusMinutes: 10,
        longBreakFrequency: 3,
        autoStartBreak: false,
      )..start();

      for (var index = 0; index < 3; index += 1) {
        controller.remainingSeconds.value = 1;
        await controller.tick();
        if (index < 2) {
          await controller.completeBreak();
          controller.start();
        }
      }

      expect(controller.currentPhase, PomodoroPhase.longBreak);
      expect(controller.remainingSeconds.value, 900);
      expect(controller.isRunning.value, isFalse);
      expect(controller.completedPomodoros.value, 3);
    });

    test('notifies when a session completes', () async {
      var completionNotifications = 0;
      final controller =
          PomodoroController(
              repository: _MemoryPomodoroSessionsRepository(),
              focusMinutes: 10,
            )
            ..onSessionCompleted = () async {
              completionNotifications += 1;
            }
            ..start();

      controller.remainingSeconds.value = 1;
      await controller.tick();
      await Future<void>.delayed(Duration.zero);

      expect(completionNotifications, 1);
    });

    test('updates planned focus duration only when stopped', () async {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
      )..setFocusMinutes(45);

      expect(controller.plannedSeconds, 45 * 60);
      expect(controller.remainingSeconds.value, 45 * 60);

      controller.start();
      await controller.tick();
      controller.setFocusMinutes(30);

      expect(controller.plannedSeconds, 30 * 60);
      expect(controller.remainingSeconds.value, (45 * 60) - 1);

      controller
        ..pause()
        ..setFocusMinutes(30);

      expect(controller.remainingSeconds.value, 30 * 60);
    });

    test('supports five-minute focus duration', () {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
      )..setFocusMinutes(5);

      expect(controller.plannedSeconds, 5 * 60);
      expect(controller.remainingSeconds.value, 5 * 60);
    });

    test('supports one-minute focus and twenty-second test break', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final controller =
          PomodoroController(
              repository: repository,
              autoStartBreak: false,
            )
            ..setFocusSeconds(60)
            ..setShortBreakSeconds(20)
            ..start();

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(controller.currentPhase, PomodoroPhase.shortBreak);
      expect(controller.remainingSeconds.value, 20);
      expect(controller.completedPomodoros.value, 1);
      expect(repository.sessions.single.plannedSeconds, 60);
      expect(repository.sessions.single.focusedSeconds, 60);
    });

    test('loads persisted session history', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 1, 1, 9),
        endedAt: DateTime(2026, 1, 1, 9, 25),
        plannedSeconds: 1500,
        focusedSeconds: 1500,
      );
      final controller = PomodoroController(repository: repository);

      await controller.loadSessions();

      expect(controller.completedPomodoros.value, 1);
      expect(controller.totalFocusSeconds.value, 1500);
    });

    test('calculates today focus and sessions without older history', () async {
      final clock = _FakeClock(DateTime(2026, 9, 7, 12));
      final repository = _MemoryPomodoroSessionsRepository();
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 9, 6, 9),
        endedAt: DateTime(2026, 9, 6, 9, 25),
        plannedSeconds: 25 * 60,
        focusedSeconds: 25 * 60,
      );
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 9, 7, 10),
        endedAt: DateTime(2026, 9, 7, 10, 25),
        plannedSeconds: 25 * 60,
        focusedSeconds: 25 * 60,
      );
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 9, 7, 11),
        endedAt: DateTime(2026, 9, 7, 11, 10),
        plannedSeconds: 25 * 60,
        focusedSeconds: 10 * 60,
        status: PomodoroSessionStatus.partial,
      );
      final controller = PomodoroController(
        repository: repository,
        now: clock.now,
      );
      addTearDown(controller.dispose);

      await controller.loadSessions();

      expect(controller.todayCompletedPomodoros, 1);
      expect(controller.todayFocusSeconds, 35 * 60);
      expect(controller.completedPomodoros.value, 2);
      expect(controller.totalFocusSeconds.value, 60 * 60);
    });

    test('today focus updates while the current block advances', () async {
      final clock = _FakeClock(DateTime(2026, 9, 7, 12));
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
        focusMinutes: 10,
        now: clock.now,
      );
      addTearDown(controller.dispose);
      controller.start();

      clock.advance(const Duration(minutes: 2));
      await controller.synchronizeWithClock();

      expect(controller.todayFocusSeconds, 2 * 60);
      expect(controller.todayCompletedPomodoros, 0);
    });

    test('associates completed sessions with the selected goal', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final completedGoalIds = <String>[];
      final controller =
          PomodoroController(repository: repository, focusMinutes: 10)
            ..onGoalPomodoroCompleted = (goalId) async {
              completedGoalIds.add(goalId);
            }
            ..selectedGoalId = 'goal-1'
            ..start();

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(controller.sessions.value.single.goalId, 'goal-1');
      expect(repository.sessions.single.goalId, 'goal-1');
      expect(completedGoalIds, ['goal-1']);
    });

    test('associates completed sessions with the selected task', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final controller =
          PomodoroController(repository: repository, focusMinutes: 10)
            ..selectTask(
              taskId: 'task-1',
              taskTitle: 'Escribir reporte',
              goalId: 'goal-1',
            )
            ..start();

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(controller.sessions.value.single.taskId, 'task-1');
      expect(repository.sessions.single.taskId, 'task-1');
    });

    test('tracks timer progress against active task estimate', () async {
      final controller =
          PomodoroController(repository: _MemoryPomodoroSessionsRepository())
            ..selectTask(
              taskId: 'task-1',
              taskTitle: 'Preparar informe',
              estimatedSeconds: 90 * 60,
            )
            ..start();

      controller.remainingSeconds.value = 20 * 60;

      expect(controller.elapsedTaskFocusSeconds, 5 * 60);
      expect(controller.timerProgress, closeTo(5 / 90, 0.001));
    });

    test(
      'keeps estimated task progress across focus and break cycles',
      () async {
        final controller =
            PomodoroController(
                repository: _MemoryPomodoroSessionsRepository(),
                autoStartBreak: false,
              )
              ..selectTask(
                taskId: 'task-1',
                taskTitle: 'Preparar informe',
                estimatedSeconds: 90 * 60,
              )
              ..start();

        controller.remainingSeconds.value = 1;
        await controller.tick();

        expect(controller.currentPhase, PomodoroPhase.shortBreak);
        expect(controller.elapsedTaskFocusSeconds, 25 * 60);
        expect(controller.timerProgress, closeTo(25 / 90, 0.001));

        await controller.completeBreak();

        expect(controller.currentPhase, PomodoroPhase.focus);
        expect(controller.remainingSeconds.value, 25 * 60);
        expect(controller.timerProgress, closeTo(25 / 90, 0.001));
      },
    );

    test('stores focus reflection without a distraction note', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final controller =
          PomodoroController(repository: repository, focusMinutes: 10)
            ..setFocusStartMoodScore(4)
            ..start();

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(controller.sessions.value.single.startMoodScore, 4);
      expect(controller.pendingReflectionSessionId.value, isNotNull);

      await controller.submitCompletionReflection(
        endMoodScore: 2,
        wasDistracted: true,
        distractionMinutes: 7,
      );

      expect(controller.pendingReflectionSessionId.value, isNull);
      expect(controller.sessions.value.single.endMoodScore, 2);
      expect(controller.sessions.value.single.wasDistracted, isTrue);
      expect(controller.sessions.value.single.distractionMinutes, 7);
      expect(repository.sessions.single.endMoodScore, 2);
    });

    test('restores and answers pending block reflections in order', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 1, 1, 9),
        endedAt: DateTime(2026, 1, 1, 9, 25),
        plannedSeconds: 1500,
        focusedSeconds: 1500,
        taskId: 'task-1',
      );
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 1, 1, 9, 30),
        endedAt: DateTime(2026, 1, 1, 9, 55),
        plannedSeconds: 1500,
        focusedSeconds: 1500,
        taskId: 'task-1',
      );
      final controller = PomodoroController(repository: repository);

      await controller.loadSessions();

      expect(controller.pendingReflectionSessionId.value, '0');
      await controller.submitCompletionReflection(
        endMoodScore: 4,
        wasDistracted: false,
        distractionMinutes: 5,
      );
      expect(controller.pendingReflectionSessionId.value, '1');
      await controller.submitCompletionReflection(
        endMoodScore: 5,
        wasDistracted: false,
        distractionMinutes: 5,
      );
      expect(controller.pendingReflectionSessionId.value, isNull);
    });

    test('selects a task context with optional goal', () {
      final controller =
          PomodoroController(
            repository: _MemoryPomodoroSessionsRepository(),
          )..selectTask(
            taskId: 'task-1',
            taskTitle: 'Escribir reporte',
            goalId: 'goal-1',
          );

      expect(controller.selectedTaskId, 'task-1');
      expect(controller.selectedTaskTitle, 'Escribir reporte');
      expect(controller.selectedGoalId, 'goal-1');
    });

    test('clears selected task context', () {
      final controller =
          PomodoroController(
              repository: _MemoryPomodoroSessionsRepository(),
            )
            ..selectTask(
              taskId: 'task-1',
              taskTitle: 'Escribir reporte',
              goalId: 'goal-1',
            )
            ..clearSelectedTask();

      expect(controller.selectedTaskId, isNull);
      expect(controller.selectedTaskTitle, isNull);
      expect(controller.selectedGoalId, isNull);
    });

    test('clears the selected goal when it is deleted elsewhere', () {
      final controller =
          PomodoroController(
              repository: _MemoryPomodoroSessionsRepository(),
            )
            ..selectedGoalId = 'goal-1'
            ..clearSelectedGoal('another-goal')
            ..clearSelectedGoal('goal-1');

      expect(controller.selectedGoalId, isNull);
    });

    test('runs a continuous 120 minute task as 45, 45, and 30', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final completedTasks = <String>[];
      final controller = PomodoroController(repository: repository)
        ..onTaskPlanCompleted = (taskId) async {
          completedTasks.add(taskId);
        };

      final prepared = await controller.prepareTaskPlan(
        taskId: 'task-120',
        taskTitle: 'Trabajo largo',
        estimatedMinutes: 120,
        cadence: const PomodoroCadence(
          focusMinutes: 45,
          breakMinutes: 10,
        ),
        mode: PomodoroPlanMode.continuous,
      );

      expect(prepared, isTrue);
      expect(controller.totalBlocks.value, 3);
      expect(controller.currentBlockIndex.value, 1);
      expect(controller.completedPlanPomodoros.value, 0);
      expect(controller.remainingSeconds.value, 45 * 60);

      controller.start();
      controller.remainingSeconds.value = 1;
      await controller.tick();
      expect(controller.currentPhase, PomodoroPhase.shortBreak);
      expect(controller.completedPlanPomodoros.value, 1);

      controller.remainingSeconds.value = 1;
      await controller.tick();
      expect(controller.currentBlockIndex.value, 2);
      expect(controller.currentPhase, PomodoroPhase.focus);
      expect(controller.completedPlanPomodoros.value, 1);
      expect(controller.remainingSeconds.value, 45 * 60);

      controller.remainingSeconds.value = 1;
      await controller.tick();
      expect(controller.completedPlanPomodoros.value, 2);
      controller.remainingSeconds.value = 1;
      await controller.tick();
      expect(controller.currentBlockIndex.value, 3);
      expect(controller.completedPlanPomodoros.value, 2);
      expect(controller.remainingSeconds.value, 30 * 60);

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(repository.sessions, hasLength(3));
      expect(
        repository.sessions.map((session) => session.focusedSeconds).toSet(),
        {45 * 60, 30 * 60},
      );
      expect(
        repository.sessions.fold<int>(
          0,
          (total, session) => total + session.focusedSeconds,
        ),
        120 * 60,
      );
      expect(completedTasks, ['task-120']);
      expect(controller.currentPhase, PomodoroPhase.shortBreak);
      expect(controller.remainingSeconds.value, 10 * 60);
      expect(controller.hasActiveRuntime.value, isTrue);

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(controller.hasActiveRuntime.value, isFalse);
      expect(controller.selectedTaskId, isNull);
    });

    test('single block stops after its associated break', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final controller = PomodoroController(repository: repository);

      await controller.prepareTaskPlan(
        taskId: 'task-1',
        taskTitle: 'Un bloque',
        estimatedMinutes: 120,
        cadence: const PomodoroCadence(
          focusMinutes: 45,
          breakMinutes: 10,
        ),
        mode: PomodoroPlanMode.singleBlock,
      );
      controller.start();
      controller.remainingSeconds.value = 1;
      await controller.tick();
      expect(controller.currentPhase, PomodoroPhase.shortBreak);

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(repository.sessions.single.focusedSeconds, 45 * 60);
      expect(controller.isRunning.value, isFalse);
      expect(controller.hasActiveRuntime.value, isFalse);
      expect(controller.selectedTaskId, isNull);
    });

    test(
      'skips an intermediate break and starts the next focus block',
      () async {
        final repository = _MemoryPomodoroSessionsRepository();
        final controller = PomodoroController(repository: repository);
        addTearDown(controller.dispose);

        await controller.prepareTaskPlan(
          taskId: 'task-60',
          taskTitle: 'Trabajo por bloques',
          estimatedMinutes: 60,
          cadence: const PomodoroCadence(
            focusMinutes: 25,
            breakMinutes: 5,
          ),
          mode: PomodoroPlanMode.continuous,
        );
        controller.start();
        controller.remainingSeconds.value = 1;
        await controller.tick();

        expect(controller.currentPhase, PomodoroPhase.shortBreak);
        expect(controller.remainingSeconds.value, 5 * 60);

        await controller.finishEarly();

        expect(controller.currentPhase, PomodoroPhase.focus);
        expect(controller.currentBlockIndex.value, 2);
        expect(controller.remainingSeconds.value, 25 * 60);
        expect(controller.isRunning.value, isTrue);
        expect(repository.sessions, hasLength(1));
      },
    );

    test(
      'skips the final break without starting another focus block',
      () async {
        final repository = _MemoryPomodoroSessionsRepository();
        final controller = PomodoroController(repository: repository);
        addTearDown(controller.dispose);

        await controller.prepareTaskPlan(
          taskId: 'task-25',
          taskTitle: 'Un bloque completo',
          estimatedMinutes: 25,
          cadence: const PomodoroCadence(
            focusMinutes: 25,
            breakMinutes: 5,
          ),
          mode: PomodoroPlanMode.continuous,
        );
        controller.start();
        controller.remainingSeconds.value = 1;
        await controller.tick();

        expect(controller.currentPhase, PomodoroPhase.shortBreak);
        expect(controller.selectedTaskId, 'task-25');

        await controller.finishEarly();

        expect(controller.isRunning.value, isFalse);
        expect(controller.hasActiveRuntime.value, isFalse);
        expect(controller.selectedTaskId, isNull);
        expect(repository.sessions, hasLength(1));
      },
    );

    test('completed continuation keeps its final recovery break', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 9, 4, 9),
        endedAt: DateTime(2026, 9, 4, 9, 25),
        plannedSeconds: 25 * 60,
        focusedSeconds: 25 * 60,
        taskId: 'task-60',
      );
      final completedTasks = <String>[];
      final controller = PomodoroController(repository: repository)
        ..onTaskPlanCompleted = (taskId) async {
          completedTasks.add(taskId);
        };
      addTearDown(controller.dispose);
      await controller.loadSessions();

      await controller.prepareTaskPlan(
        taskId: 'task-60',
        taskTitle: 'Finalizar sin fragmentos',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(focusMinutes: 35, breakMinutes: 5),
        mode: PomodoroPlanMode.singleBlock,
      );

      expect(controller.remainingSeconds.value, 35 * 60);
      expect(controller.totalBlocks.value, 1);

      controller.start();
      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(completedTasks, ['task-60']);
      expect(controller.currentPhase, PomodoroPhase.shortBreak);
      expect(controller.remainingSeconds.value, 5 * 60);
      expect(controller.selectedTaskId, 'task-60');

      controller.remainingSeconds.value = 1;
      await controller.tick();

      expect(controller.hasActiveRuntime.value, isFalse);
      expect(controller.selectedTaskId, isNull);
    });

    test(
      'finishes an interrupted block, rests, then runs the next block',
      () async {
        final repository = _MemoryPomodoroSessionsRepository();
        await repository.saveCompletedSession(
          startedAt: DateTime(2026, 9, 7, 9),
          endedAt: DateTime(2026, 9, 7, 9, 25),
          plannedSeconds: 25 * 60,
          focusedSeconds: 25 * 60,
          taskId: 'task-60',
        );
        await repository.saveCompletedSession(
          startedAt: DateTime(2026, 9, 7, 10),
          endedAt: DateTime(2026, 9, 7, 10, 20),
          plannedSeconds: 25 * 60,
          focusedSeconds: 20 * 60,
          taskId: 'task-60',
          status: PomodoroSessionStatus.partial,
        );
        final controller = PomodoroController(repository: repository);
        addTearDown(controller.dispose);
        await controller.loadSessions();

        await controller.prepareTaskPlan(
          taskId: 'task-60',
          taskTitle: 'Continuar por bloques',
          estimatedMinutes: 60,
          cadence: const PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
          mode: PomodoroPlanMode.continuous,
        );

        expect(controller.remainingSeconds.value, 5 * 60);
        expect(controller.totalBlocks.value, 2);

        controller.start();
        controller.remainingSeconds.value = 1;
        await controller.tick();
        expect(controller.currentPhase, PomodoroPhase.shortBreak);
        expect(controller.remainingSeconds.value, 5 * 60);

        controller.remainingSeconds.value = 1;
        await controller.tick();
        expect(controller.currentPhase, PomodoroPhase.focus);
        expect(controller.remainingSeconds.value, 10 * 60);

        controller.remainingSeconds.value = 1;
        await controller.tick();
        expect(controller.currentPhase, PomodoroPhase.shortBreak);
        expect(controller.remainingSeconds.value, 5 * 60);

        controller.remainingSeconds.value = 1;
        await controller.tick();
        expect(controller.hasActiveRuntime.value, isFalse);
      },
    );

    test('does not replace another task that owns the timer', () async {
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
      );
      await controller.prepareTaskPlan(
        taskId: 'task-1',
        taskTitle: 'Primera',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(
          focusMinutes: 25,
          breakMinutes: 5,
        ),
        mode: PomodoroPlanMode.continuous,
      );

      final secondPrepared = await controller.prepareTaskPlan(
        taskId: 'task-2',
        taskTitle: 'Segunda',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(
          focusMinutes: 25,
          breakMinutes: 5,
        ),
        mode: PomodoroPlanMode.continuous,
      );

      expect(secondPrepared, isFalse);
      expect(controller.selectedTaskId, 'task-1');
    });

    test(
      'continues only the exact five minutes left after reopening',
      () async {
        final sessionsRepository = _MemoryPomodoroSessionsRepository();
        final runtimeRepository = _MemoryPomodoroRuntimeRepository();
        final first = PomodoroController(
          repository: sessionsRepository,
          runtimeRepository: runtimeRepository,
        );
        addTearDown(first.dispose);
        await first.prepareTaskPlan(
          taskId: 'task-60',
          taskTitle: 'Trabajo de una hora',
          estimatedMinutes: 60,
          cadence: const PomodoroCadence(focusMinutes: 30, breakMinutes: 5),
          mode: PomodoroPlanMode.continuous,
        );

        first.start();
        first.remainingSeconds.value = 1;
        await first.tick();
        first.remainingSeconds.value = 1;
        await first.tick();
        first.remainingSeconds.value = 5 * 60;
        await first.stopForNow();

        expect(
          sessionsRepository.sessions.map((session) => session.focusedSeconds),
          containsAll(<int>[30 * 60, 25 * 60]),
        );
        expect(runtimeRepository.state, isNull);

        final restored = PomodoroController(
          repository: sessionsRepository,
          runtimeRepository: runtimeRepository,
        );
        addTearDown(restored.dispose);
        await restored.initialize();
        final prepared = await restored.prepareTaskPlan(
          taskId: 'task-60',
          taskTitle: 'Trabajo de una hora',
          estimatedMinutes: 60,
          cadence: const PomodoroCadence(focusMinutes: 30, breakMinutes: 5),
          mode: PomodoroPlanMode.continuous,
        );

        expect(prepared, isTrue);
        expect(restored.remainingSeconds.value, 5 * 60);
        expect(restored.totalBlocks.value, 1);
      },
    );

    test('restores a stale completed focus at its break', () async {
      final sessionsRepository = _MemoryPomodoroSessionsRepository();
      final runtimeRepository = _MemoryPomodoroRuntimeRepository();
      final first = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
      );
      addTearDown(first.dispose);
      await first.prepareTaskPlan(
        taskId: 'task-stale',
        taskTitle: 'Bloque persistido',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(focusMinutes: 30, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );
      first.start();
      await first.checkpointRuntime();
      final staleFocus = runtimeRepository.state;

      first.remainingSeconds.value = 1;
      await first.tick();
      runtimeRepository.state = staleFocus;
      first.dispose();

      final restored = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
      );
      addTearDown(restored.dispose);
      await restored.initialize();

      expect(restored.currentPhase, PomodoroPhase.shortBreak);
      expect(restored.isRunning.value, isFalse);
      expect(restored.remainingSeconds.value, 5 * 60);
      expect(restored.currentBlockIndex.value, 1);
      expect(restored.totalBlocks.value, 2);
      expect(restored.elapsedTaskFocusSeconds, 30 * 60);
    });

    test('replans a stale partial focus from its exact remainder', () async {
      final sessionsRepository = _MemoryPomodoroSessionsRepository();
      final runtimeRepository = _MemoryPomodoroRuntimeRepository();
      final first = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
      );
      addTearDown(first.dispose);
      await first.prepareTaskPlan(
        taskId: 'task-partial-stale',
        taskTitle: 'Parcial persistido',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(focusMinutes: 30, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );
      first.start();
      first.remainingSeconds.value = 1;
      await first.tick();
      first.remainingSeconds.value = 1;
      await first.tick();
      await first.checkpointRuntime();
      final staleSecondFocus = runtimeRepository.state;

      first.remainingSeconds.value = 5 * 60;
      await first.stopForNow();
      runtimeRepository.state = staleSecondFocus;
      first.dispose();

      final restored = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
      );
      addTearDown(restored.dispose);
      await restored.initialize();

      expect(restored.currentPhase, PomodoroPhase.focus);
      expect(restored.isRunning.value, isFalse);
      expect(restored.remainingSeconds.value, 5 * 60);
      expect(restored.currentBlockIndex.value, 1);
      expect(restored.totalBlocks.value, 1);
      expect(restored.elapsedTaskFocusSeconds, 55 * 60);
    });

    test('stop waits until the obsolete runtime is cleared', () async {
      final runtimeRepository = _BlockingClearRuntimeRepository();
      final controller = PomodoroController(
        repository: _MemoryPomodoroSessionsRepository(),
        runtimeRepository: runtimeRepository,
      );
      addTearDown(controller.dispose);
      await controller.prepareTaskPlan(
        taskId: 'task-clear',
        taskTitle: 'Salida segura',
        estimatedMinutes: 30,
        cadence: const PomodoroCadence(focusMinutes: 30, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );
      controller.start();
      controller.remainingSeconds.value = 5 * 60;

      var finished = false;
      final stopping = controller.stopForNow().then((_) => finished = true);
      await Future<void>.delayed(Duration.zero);

      expect(runtimeRepository.clearCalled, isTrue);
      expect(finished, isFalse);
      runtimeRepository.allowClear();
      await stopping;
      expect(finished, isTrue);
      expect(runtimeRepository.state, isNull);
    });

    test('restores a running task and reconciles elapsed time', () async {
      final clock = _FakeClock(DateTime(2026, 7, 29, 9));
      final sessionsRepository = _MemoryPomodoroSessionsRepository();
      final runtimeRepository = _MemoryPomodoroRuntimeRepository();
      final first = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
        now: clock.now,
      );
      await first.prepareTaskPlan(
        taskId: 'task-1',
        taskTitle: 'Recuperable',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(
          focusMinutes: 25,
          breakMinutes: 5,
        ),
        mode: PomodoroPlanMode.continuous,
      );
      first.start();
      await first.checkpointRuntime();
      first.dispose();

      clock.advance(const Duration(seconds: 75));
      final restored = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
        now: clock.now,
      );
      addTearDown(restored.dispose);
      await restored.initialize();

      expect(restored.selectedTaskId, 'task-1');
      expect(restored.isRunning.value, isTrue);
      expect(restored.remainingSeconds.value, (25 * 60) - 75);
      expect(restored.currentBlockIndex.value, 1);
      expect(restored.totalBlocks.value, 3);
    });

    test('restores an imported pause without counting hidden time', () async {
      final clock = _FakeClock(DateTime(2026, 8, 9, 9));
      final sessionsRepository = _MemoryPomodoroSessionsRepository();
      final runtimeRepository = _MemoryPomodoroRuntimeRepository();
      final first = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
        now: clock.now,
      );
      await first.prepareTaskPlan(
        taskId: 'routine-task',
        taskTitle: 'Routine task',
        estimatedMinutes: 45,
        cadence: const PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );
      first.start();
      clock.advance(const Duration(seconds: 30));
      await first.synchronizeWithClock();
      first.pause();
      await first.checkpointRuntime();
      final pausedSeconds = first.remainingSeconds.value;
      first.dispose();

      clock.advance(const Duration(hours: 6));
      final restored = PomodoroController(
        repository: sessionsRepository,
        runtimeRepository: runtimeRepository,
        now: clock.now,
      );
      addTearDown(restored.dispose);
      await restored.initialize();

      expect(restored.selectedTaskId, 'routine-task');
      expect(restored.isRunning.value, isFalse);
      expect(restored.remainingSeconds.value, pausedSeconds);

      restored.start();
      clock.advance(const Duration(seconds: 10));
      await restored.synchronizeWithClock();
      expect(restored.remainingSeconds.value, pausedSeconds - 10);
    });
  });
}

class _FakeClock {
  _FakeClock(this._now);

  DateTime _now;

  DateTime now() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

class _MemoryPomodoroSessionsRepository implements PomodoroSessionsRepository {
  final List<PomodoroSession> _sessions = [];
  int _nextId = 0;

  List<PomodoroSession> get sessions => List.unmodifiable(_sessions);

  @override
  Future<List<PomodoroSession>> loadSessions() async {
    return List.unmodifiable(_sessions);
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
    final session = PomodoroSession(
      id: (_nextId++).toString(),
      startedAt: startedAt,
      endedAt: endedAt,
      plannedSeconds: plannedSeconds,
      focusedSeconds: focusedSeconds,
      status: status,
      goalId: goalId,
      taskId: taskId,
      startMoodScore: startMoodScore,
      moodPromptPending: status == PomodoroSessionStatus.completed,
    );
    _sessions.insert(0, session);
    return session;
  }

  @override
  Future<PomodoroSession> updateSessionReflection({
    required String sessionId,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) async {
    final index = _sessions.indexWhere((session) => session.id == sessionId);
    final updated = _sessions[index].copyWith(
      endMoodScore: endMoodScore.clamp(1, 5),
      moodPromptPending: false,
      wasDistracted: wasDistracted,
      distractionMinutes: wasDistracted ? distractionMinutes.clamp(1, 600) : 0,
    );
    _sessions[index] = updated;
    return updated;
  }
}

class _MemoryPomodoroRuntimeRepository implements PomodoroRuntimeRepository {
  PomodoroRuntimeState? state;

  @override
  Future<void> clear() async {
    state = null;
  }

  @override
  Future<PomodoroRuntimeState?> load() async => state;

  @override
  Future<void> save(PomodoroRuntimeState state) async {
    this.state = state;
  }
}

class _BlockingClearRuntimeRepository extends _MemoryPomodoroRuntimeRepository {
  final Completer<void> _clearGate = Completer<void>();
  bool clearCalled = false;

  void allowClear() => _clearGate.complete();

  @override
  Future<void> clear() async {
    clearCalled = true;
    await _clearGate.future;
    await super.clear();
  }
}
