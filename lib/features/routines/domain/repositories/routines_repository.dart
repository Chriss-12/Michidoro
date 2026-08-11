import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';

abstract class RoutinesRepository {
  Future<List<Routine>> loadRoutines();

  Future<Routine?> findRoutineById(String id);

  Future<void> saveRoutine(Routine routine);

  Future<void> pauseRoutine(String id, {DateTime? until});

  Future<void> resumeRoutine(String id);

  Future<void> archiveRoutine(String id);

  Future<void> restoreRoutine(String id);

  Future<void> deleteArchivedRoutine(String id);

  Future<RoutineReconciliationResult> reconcileLocalDay(DateTime localDay);

  Future<bool> isGeneratedTask(String taskId);

  Future<bool> updateFutureTemplateTitleForTask({
    required String taskId,
    required String title,
  });

  Future<List<RoutineRun>> loadRuns({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<RoutineRun?> findRun({
    required String sourceRoutineId,
    required DateTime localDate,
  });

  Future<void> saveRun(RoutineRun run);

  Future<List<RoutineItemRun>> loadItemRuns(String routineRunId);

  Future<void> saveItemRun(RoutineItemRun itemRun);

  Future<bool> skipOptionalItemRun(String itemRunId);

  Future<bool> skipRoutineRun(String routineRunId);

  Future<bool> shiftRemainingRun({
    required String routineRunId,
    required String currentItemRunId,
    required DateTime startAt,
  });
}
