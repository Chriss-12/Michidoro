import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';

abstract class PomodoroRuntimeRepository {
  Future<PomodoroRuntimeState?> load();

  Future<void> save(PomodoroRuntimeState state);

  Future<void> clear();
}
