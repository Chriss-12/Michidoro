import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';

abstract interface class TaskTemporalFilterRepository {
  Future<TaskTemporalFilter> load();

  Future<void> save(TaskTemporalFilter filter);
}
