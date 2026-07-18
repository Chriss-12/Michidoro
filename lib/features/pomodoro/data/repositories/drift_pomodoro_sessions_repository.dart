import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/datasources/pomodoro_sessions_database.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';

class DriftPomodoroSessionsRepository implements PomodoroSessionsRepository {
  DriftPomodoroSessionsRepository(this._dao);

  final PomodoroSessionsDao _dao;
  int _idSequence = 0;

  @override
  Future<List<PomodoroSession>> loadSessions() async {
    final records = await _dao.getAllSessions();
    return records.map(_toDomain).toList(growable: false);
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
    final now = DateTime.now();
    final record = await _dao.insertSession(
      PomodoroSessionRecordsCompanion.insert(
        id: _createLocalId(now),
        startedAt: startedAt,
        endedAt: endedAt,
        plannedSeconds: plannedSeconds,
        focusedSeconds: focusedSeconds,
        goalId: Value(goalId),
        taskId: Value(taskId),
        startMoodScore: Value(startMoodScore),
        status: PomodoroSessionStatus.completed.name,
        createdAt: now,
      ),
    );

    return _toDomain(record);
  }

  @override
  Future<PomodoroSession> updateSessionReflection({
    required String sessionId,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) async {
    final record = await _dao.updateReflection(
      id: sessionId,
      endMoodScore: endMoodScore.clamp(1, 5),
      wasDistracted: wasDistracted,
      distractionMinutes: wasDistracted ? distractionMinutes.clamp(1, 600) : 0,
    );

    return _toDomain(record);
  }

  String _createLocalId(DateTime now) {
    return '${now.microsecondsSinceEpoch}-${_idSequence++}';
  }

  PomodoroSession _toDomain(PomodoroSessionRecord record) {
    return PomodoroSession(
      id: record.id,
      startedAt: record.startedAt,
      endedAt: record.endedAt,
      plannedSeconds: record.plannedSeconds,
      focusedSeconds: record.focusedSeconds,
      status: PomodoroSessionStatus.completed,
      goalId: record.goalId,
      taskId: record.taskId,
      startMoodScore: record.startMoodScore,
      endMoodScore: record.endMoodScore,
      wasDistracted: record.wasDistracted,
      distractionMinutes: record.distractionMinutes,
    );
  }
}
