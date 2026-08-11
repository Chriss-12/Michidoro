import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_task_plan.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/start_task_focus_flow.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

enum RoutineLateStartChoice { keepSchedule, shiftRemaining }

class RoutineTaskExecution {
  const RoutineTaskExecution({required this.run, required this.item});

  final RoutineRun run;
  final RoutineItemRun item;
}

RoutineTaskExecution? findRoutineTaskExecution({
  required RoutinesController controller,
  required String taskId,
}) {
  for (final run in controller.todayRuns.value) {
    for (final item
        in controller.todayItemRuns.value[run.id] ?? const <RoutineItemRun>[]) {
      if (item.taskId == taskId) {
        return RoutineTaskExecution(run: run, item: item);
      }
    }
  }
  return null;
}

PomodoroCadence? routineItemCadence(RoutineItemRun item) =>
    switch (item.pomodoroModeSnapshot) {
      RoutinePomodoroMode.none => null,
      RoutinePomodoroMode.recommended => const PomodoroCadence(
        focusMinutes: RoutinesController.recommendedFocusMinutes,
        breakMinutes: RoutinesController.recommendedBreakMinutes,
      ),
      RoutinePomodoroMode.custom => PomodoroCadence(
        focusMinutes: item.customFocusMinutesSnapshot!,
        breakMinutes: item.customBreakMinutesSnapshot!,
      ),
    };

bool routineItemNeedsLateStartChoice({
  required RoutineItemRun item,
  required DateTime now,
}) =>
    item.status == RoutineRunStatus.scheduled &&
    now.isAfter(item.scheduledAtSnapshot);

Future<void> startRoutineTaskFocusFlow({
  required BuildContext context,
  required Task task,
  required RoutineRun run,
  required RoutineItemRun item,
  required RoutinesController controller,
}) async {
  if (routineItemNeedsLateStartChoice(
    item: item,
    now: controller.currentLocalTime,
  )) {
    final choice = await _showLateStartChoice(context);
    if (choice == null) return;
    if (choice == RoutineLateStartChoice.shiftRemaining) {
      final shifted = await controller.shiftRemainingRun(
        run: run,
        currentItem: item,
      );
      if (!shifted || !context.mounted) return;
    }
  }

  if (!context.mounted) return;
  await startTaskFocusFlow(
    context: context,
    task: task,
    preferredCadence: routineItemCadence(item),
  );
}

Future<RoutineLateStartChoice?> _showLateStartChoice(BuildContext context) {
  return showDialog<RoutineLateStartChoice>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(dialogContext.tr('Empezar más tarde', 'Starting late')),
      content: Text(
        dialogContext.tr(
          'Puedes conservar el horario original o desplazar solo las actividades pendientes de hoy.',
          "Keep the original times or move only today's remaining activities.",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(dialogContext.tr('Cancelar', 'Cancel')),
        ),
        OutlinedButton(
          onPressed: () => Navigator.of(
            dialogContext,
          ).pop(RoutineLateStartChoice.keepSchedule),
          child: Text(dialogContext.tr('Mantener horario', 'Keep times')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(
            dialogContext,
          ).pop(RoutineLateStartChoice.shiftRemaining),
          child: Text(
            dialogContext.tr('Desplazar pendientes', 'Move remaining'),
          ),
        ),
      ],
    ),
  );
}
