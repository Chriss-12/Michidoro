import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
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

    test('finishes early and stores only elapsed focus seconds', () async {
      final repository = _MemoryPomodoroSessionsRepository();
      final controller = PomodoroController(
        repository: repository,
        focusMinutes: 10,
      )..start();

      controller.remainingSeconds.value = 540;
      await controller.finishEarly();

      expect(controller.isRunning.value, isTrue);
      expect(controller.currentPhase, PomodoroPhase.shortBreak);
      expect(controller.remainingSeconds.value, 300);
      expect(controller.completedPomodoros.value, 1);
      expect(controller.totalFocusSeconds.value, 60);
      expect(repository.sessions.single.focusedSeconds, 60);
      expect(repository.sessions.single.plannedSeconds, 600);
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
  });
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
  }) async {
    final session = PomodoroSession(
      id: (_nextId++).toString(),
      startedAt: startedAt,
      endedAt: endedAt,
      plannedSeconds: plannedSeconds,
      focusedSeconds: focusedSeconds,
      status: PomodoroSessionStatus.completed,
      goalId: goalId,
      taskId: taskId,
      startMoodScore: startMoodScore,
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
      wasDistracted: wasDistracted,
      distractionMinutes: wasDistracted ? distractionMinutes.clamp(1, 600) : 0,
    );
    _sessions[index] = updated;
    return updated;
  }
}
