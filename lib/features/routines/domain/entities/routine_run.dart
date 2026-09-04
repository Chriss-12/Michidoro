import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';

enum RoutineRunStatus { scheduled, inProgress, completed, skipped, missed }

class RoutineReconciliationResult {
  const RoutineReconciliationResult({
    required this.createdRuns,
    required this.createdTasks,
    required this.missedRuns,
  });

  final int createdRuns;
  final int createdTasks;
  final int missedRuns;
}

class RoutineRun {
  const RoutineRun({
    required this.id,
    required this.sourceRoutineId,
    required this.localDate,
    required this.status,
    required this.nameSnapshot,
    required this.iconKeySnapshot,
    required this.colorKeySnapshot,
    required this.scheduledStartMinuteSnapshot,
    required this.createdAt,
    required this.updatedAt,
    this.routineId,
    this.customColorArgbSnapshot,
    this.startedAt,
    this.completedAt,
    this.skippedAt,
  });

  final String id;
  final String? routineId;
  final String sourceRoutineId;
  final DateTime localDate;
  final RoutineRunStatus status;
  final String nameSnapshot;
  final String iconKeySnapshot;
  final String colorKeySnapshot;
  final int? customColorArgbSnapshot;
  final int scheduledStartMinuteSnapshot;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class RoutineItemRun {
  const RoutineItemRun({
    required this.id,
    required this.routineRunId,
    required this.sourceItemId,
    required this.positionSnapshot,
    required this.titleSnapshot,
    required this.scheduledAtSnapshot,
    required this.durationMinutesSnapshot,
    required this.isOptionalSnapshot,
    required this.pomodoroModeSnapshot,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.routineItemId,
    this.taskId,
    this.taskIdSnapshot,
    this.goalTitleSnapshot,
    this.reminderMinutesSnapshot,
    this.customFocusMinutesSnapshot,
    this.customBreakMinutesSnapshot,
    this.startedAt,
    this.completedAt,
    this.skippedAt,
  });

  final String id;
  final String routineRunId;
  final String? routineItemId;
  final String sourceItemId;
  final String? taskId;
  final String? taskIdSnapshot;
  final int positionSnapshot;
  final String titleSnapshot;
  final DateTime scheduledAtSnapshot;
  final int durationMinutesSnapshot;
  final String? goalTitleSnapshot;
  final bool isOptionalSnapshot;
  final int? reminderMinutesSnapshot;
  final RoutinePomodoroMode pomodoroModeSnapshot;
  final int? customFocusMinutesSnapshot;
  final int? customBreakMinutesSnapshot;
  final RoutineRunStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
