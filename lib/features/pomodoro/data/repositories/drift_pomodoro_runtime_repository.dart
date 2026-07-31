import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_runtime_repository.dart';

class DriftPomodoroRuntimeRepository implements PomodoroRuntimeRepository {
  DriftPomodoroRuntimeRepository(this._dao);

  static const _runtimeId = 'active';

  final PomodoroRuntimeDao _dao;

  @override
  Future<PomodoroRuntimeState?> load() async {
    final record = await _dao.loadActive();
    if (record == null) {
      return null;
    }

    return PomodoroRuntimeState(
      taskId: record.taskId,
      taskTitle: record.taskTitle,
      goalId: record.goalId,
      taskEstimatedMinutes: record.taskEstimatedMinutes,
      phase: PomodoroRuntimePhase.values.byName(record.phase),
      isRunning: record.isRunning,
      remainingSeconds: record.remainingSeconds,
      phaseTotalSeconds: record.phaseTotalSeconds,
      cadenceFocusMinutes: record.cadenceFocusMinutes,
      cadenceBreakMinutes: record.cadenceBreakMinutes,
      longBreakMinutes: record.longBreakMinutes,
      longBreakFrequency: record.longBreakFrequency,
      autoStartBreak: record.autoStartBreak,
      autoStartFocus: record.autoStartFocus,
      planMode: PomodoroPlanMode.values.byName(record.planMode),
      blockIndex: record.blockIndex,
      blockCount: record.blockCount,
      taskFocusedSecondsAtStart: record.taskFocusedSecondsAtStart,
      focusStartedAt: record.focusStartedAt,
      lastTickAt: record.lastTickAt,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }

  @override
  Future<void> save(PomodoroRuntimeState state) {
    return _dao.saveActive(
      PomodoroRuntimeRecordsCompanion.insert(
        id: _runtimeId,
        taskId: Value(state.taskId),
        taskTitle: Value(state.taskTitle),
        goalId: Value(state.goalId),
        taskEstimatedMinutes: Value(state.taskEstimatedMinutes),
        phase: state.phase.name,
        isRunning: state.isRunning,
        remainingSeconds: state.remainingSeconds,
        phaseTotalSeconds: state.phaseTotalSeconds,
        cadenceFocusMinutes: state.cadenceFocusMinutes,
        cadenceBreakMinutes: state.cadenceBreakMinutes,
        longBreakMinutes: state.longBreakMinutes,
        longBreakFrequency: state.longBreakFrequency,
        autoStartBreak: state.autoStartBreak,
        autoStartFocus: state.autoStartFocus,
        planMode: state.planMode.name,
        blockIndex: state.blockIndex,
        blockCount: state.blockCount,
        taskFocusedSecondsAtStart: state.taskFocusedSecondsAtStart,
        focusStartedAt: Value(state.focusStartedAt),
        lastTickAt: Value(state.lastTickAt),
        createdAt: state.createdAt,
        updatedAt: state.updatedAt,
      ),
    );
  }

  @override
  Future<void> clear() => _dao.clearActive();
}
