import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_task_plan.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/start_task_focus_flow.dart';

void main() {
  test(
    'recalculates an unstarted same-task runtime from exact remaining time',
    () async {
      final controller = PomodoroController(
        repository: _UnusedPomodoroSessionsRepository(),
      );
      addTearDown(controller.dispose);

      await controller.prepareTaskPlan(
        taskId: 'task-60',
        taskTitle: 'Terminar informe',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );
      expect(controller.remainingSeconds.value, 25 * 60);
      expect(controller.hasStartedRuntime.value, isFalse);

      controller.sessions.value = [
        PomodoroSession(
          id: 'focused-55',
          startedAt: DateTime(2026, 8, 31, 9),
          endedAt: DateTime(2026, 8, 31, 9, 55),
          plannedSeconds: 55 * 60,
          focusedSeconds: 55 * 60,
          status: PomodoroSessionStatus.partial,
          taskId: 'task-60',
        ),
      ];

      expect(
        await shouldResumeExistingTaskRuntime(
          controller: controller,
          taskId: 'task-60',
        ),
        isFalse,
      );
      expect(controller.hasActiveRuntime.value, isFalse);

      await controller.prepareTaskPlan(
        taskId: 'task-60',
        taskTitle: 'Terminar informe',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );

      expect(controller.remainingSeconds.value, 5 * 60);
      expect(controller.totalBlocks.value, 1);
    },
  );

  test('keeps a same-task runtime that already started', () async {
    final controller = PomodoroController(
      repository: _UnusedPomodoroSessionsRepository(),
    );
    addTearDown(controller.dispose);

    await controller.prepareTaskPlan(
      taskId: 'active-task',
      taskTitle: 'Trabajo activo',
      estimatedMinutes: 60,
      cadence: const PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
      mode: PomodoroPlanMode.continuous,
    );
    controller.start();

    expect(
      await shouldResumeExistingTaskRuntime(
        controller: controller,
        taskId: 'active-task',
      ),
      isTrue,
    );
    expect(controller.hasActiveRuntime.value, isTrue);
    expect(controller.hasStartedRuntime.value, isTrue);
    expect(controller.remainingSeconds.value, 25 * 60);
  });

  test(
    'recalculates a started runtime that exceeds the saved remainder',
    () async {
      var now = DateTime(2026, 8, 31, 10);
      final controller = PomodoroController(
        repository: _UnusedPomodoroSessionsRepository(),
        now: () => now,
      );
      addTearDown(controller.dispose);

      await controller.prepareTaskPlan(
        taskId: 'stale-started-task',
        taskTitle: 'Plan iniciado antiguo',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );
      controller.start();
      now = now.add(const Duration(minutes: 1));
      await controller.synchronizeWithClock();
      controller
        ..pause()
        ..sessions.value = [
          PomodoroSession(
            id: 'focused-55',
            startedAt: DateTime(2026, 8, 31, 9),
            endedAt: DateTime(2026, 8, 31, 9, 55),
            plannedSeconds: 55 * 60,
            focusedSeconds: 55 * 60,
            status: PomodoroSessionStatus.partial,
            taskId: 'stale-started-task',
          ),
        ];

      expect(controller.hasStartedRuntime.value, isTrue);
      expect(controller.remainingSeconds.value, 24 * 60);
      expect(
        await shouldResumeExistingTaskRuntime(
          controller: controller,
          taskId: 'stale-started-task',
        ),
        isFalse,
      );
      expect(
        controller.sessions.value.fold<int>(
          0,
          (total, session) => total + session.focusedSeconds,
        ),
        55 * 60,
      );

      await controller.prepareTaskPlan(
        taskId: 'stale-started-task',
        taskTitle: 'Plan iniciado antiguo',
        estimatedMinutes: 60,
        cadence: const PomodoroCadence(focusMinutes: 25, breakMinutes: 5),
        mode: PomodoroPlanMode.continuous,
      );

      expect(controller.remainingSeconds.value, 5 * 60);
      expect(controller.totalBlocks.value, 1);
    },
  );
}

class _UnusedPomodoroSessionsRepository extends Fake
    implements PomodoroSessionsRepository {}
