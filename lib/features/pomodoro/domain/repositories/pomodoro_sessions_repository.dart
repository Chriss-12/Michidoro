import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';

abstract class PomodoroSessionsRepository {
  Future<List<PomodoroSession>> loadSessions();

  Future<PomodoroSession> saveCompletedSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedSeconds,
    required int focusedSeconds,
    String? goalId,
    String? taskId,
    int? startMoodScore,
    PomodoroSessionStatus status = PomodoroSessionStatus.completed,
  });

  Future<PomodoroSession> updateSessionReflection({
    required String sessionId,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  });
}
