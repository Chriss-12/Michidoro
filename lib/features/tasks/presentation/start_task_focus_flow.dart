import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_task_plan.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/services/pomodoro_task_planner.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class TaskFocusPreset {
  const TaskFocusPreset({
    required this.focusSeconds,
    required this.breakSeconds,
    this.isTestPreset = false,
  });

  const TaskFocusPreset.minutes({
    required int focusMinutes,
    required int breakMinutes,
  }) : this(
         focusSeconds: focusMinutes * 60,
         breakSeconds: breakMinutes * 60,
       );

  final int focusSeconds;
  final int breakSeconds;
  final bool isTestPreset;

  int get focusMinutes => focusSeconds ~/ 60;
  int get breakMinutes => breakSeconds ~/ 60;
  PomodoroCadence get cadence => PomodoroCadence(
    focusMinutes: focusMinutes,
    breakMinutes: breakMinutes,
  );

  String label(BuildContext context) =>
      '${_durationLabel(focusSeconds)} ${context.tr('enfoque', 'focus')} / '
      '${_durationLabel(breakSeconds)} ${context.tr('descanso', 'break')}';

  static String _durationLabel(int seconds) {
    if (seconds % 60 == 0) {
      return '${seconds ~/ 60} min';
    }
    return '$seconds s';
  }
}

const taskFocusPresets = [
  TaskFocusPreset(
    focusSeconds: 60,
    breakSeconds: 20,
    isTestPreset: true,
  ),
  TaskFocusPreset.minutes(focusMinutes: 5, breakMinutes: 1),
  TaskFocusPreset.minutes(focusMinutes: 25, breakMinutes: 5),
  TaskFocusPreset.minutes(focusMinutes: 30, breakMinutes: 5),
  TaskFocusPreset.minutes(focusMinutes: 45, breakMinutes: 10),
];

class _TaskFocusSelection {
  const _TaskFocusSelection({
    required this.preset,
    required this.mode,
  });

  final TaskFocusPreset preset;
  final PomodoroPlanMode mode;
}

enum _ConflictAction { returnToTimer, stopAndSwitch }

Future<void> startTaskFocusFlow({
  required BuildContext context,
  required Task task,
  PomodoroCadence? preferredCadence,
}) async {
  final controller = serviceLocator<PomodoroController>();

  if (controller.hasActiveRuntime.value) {
    if (controller.activeTaskId.value == task.id) {
      final shouldResume = await shouldResumeExistingTaskRuntime(
        controller: controller,
        taskId: task.id,
      );
      if (shouldResume) {
        if (context.mounted) {
          context.go(PomodoroPage.routePath);
        }
        return;
      }
    } else {
      final action = await _showOwnershipConflict(
        context: context,
        activeTaskTitle: controller.activeTaskTitle.value,
      );
      if (action == _ConflictAction.returnToTimer) {
        if (context.mounted) {
          context.go(PomodoroPage.routePath);
        }
        return;
      }
      if (action != _ConflictAction.stopAndSwitch) {
        return;
      }
      await controller.stopForNow();
    }
  }

  if (!context.mounted) {
    return;
  }

  final estimatedMinutes = task.durationMinutes ?? 25;
  final focusedSeconds = controller.sessions.value
      .where((session) => session.taskId == task.id)
      .map((session) => session.focusedSeconds);
  final summary = summarizeTaskFocusMinutes(
    plannedMinutes: estimatedMinutes,
    focusedSeconds: focusedSeconds,
  );
  if (summary.remainingMinutes == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.tr(
            'Esta tarea ya completó el tiempo previsto.',
            'This task has already completed its planned time.',
          ),
        ),
      ),
    );
    return;
  }

  final standardPresets = taskFocusPresets
      .where((preset) => !preset.isTestPreset)
      .toList(growable: false);
  final ranking = rankPomodoroPresets(
    remainingMinutes: summary.remainingMinutes,
    presets: standardPresets.map((preset) => preset.cadence),
  );
  final recommendedCadence = ranking.first.cadence;
  final recommendedPreset = preferredCadence == null
      ? standardPresets.firstWhere(
          (preset) =>
              preset.focusMinutes == recommendedCadence.focusMinutes &&
              preset.breakMinutes == recommendedCadence.breakMinutes,
        )
      : TaskFocusPreset.minutes(
          focusMinutes: preferredCadence.focusMinutes,
          breakMinutes: preferredCadence.breakMinutes,
        );

  final selection = await _showFocusOptions(
    context: context,
    task: task,
    remainingMinutes: summary.remainingMinutes,
    ranking: ranking,
    recommendedPreset: recommendedPreset,
  );
  if (selection == null || !context.mounted) {
    return;
  }

  if (selection.preset.isTestPreset) {
    controller
      ..setFocusSeconds(selection.preset.focusSeconds)
      ..setShortBreakSeconds(selection.preset.breakSeconds)
      ..selectTask(
        taskId: task.id,
        taskTitle: task.title,
        goalId: task.goalId,
        estimatedSeconds: task.durationMinutes == null
            ? null
            : task.durationMinutes! * 60,
      );
  } else {
    final prepared = await controller.prepareTaskPlan(
      taskId: task.id,
      taskTitle: task.title,
      goalId: task.goalId,
      estimatedMinutes: estimatedMinutes,
      cadence: selection.preset.cadence,
      mode: selection.mode,
    );
    if (!prepared || !context.mounted) {
      return;
    }
  }

  if (context.mounted) {
    context.go(PomodoroPage.routePath);
  }
}

Future<bool> shouldResumeExistingTaskRuntime({
  required PomodoroController controller,
  required String taskId,
}) async {
  if (!controller.hasActiveRuntime.value ||
      controller.activeTaskId.value != taskId) {
    return false;
  }
  final estimatedSeconds = controller.activeTaskEstimatedSeconds.value;
  if (controller.phase.value == PomodoroPhase.focus &&
      estimatedSeconds != null) {
    final remainingFromHistory =
        estimatedSeconds - controller.activeTaskFocusedSeconds.value;
    if (controller.remainingSeconds.value > remainingFromHistory) {
      await controller.discardActiveRuntimeWithoutSaving();
      return false;
    }
  }

  return true;
}

Future<_ConflictAction?> _showOwnershipConflict({
  required BuildContext context,
  required String? activeTaskTitle,
}) {
  return showDialog<_ConflictAction>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        dialogContext.tr(
          'Hay un Pomodoro activo',
          'There is an active Pomodoro',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            activeTaskTitle == null
                ? dialogContext.tr(
                    'El cronómetro ya está siendo utilizado.',
                    'The timer is already in use.',
                  )
                : dialogContext.tr(
                    'El cronómetro pertenece a “$activeTaskTitle”.',
                    'The timer belongs to “$activeTaskTitle”.',
                  ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.of(
              dialogContext,
            ).pop(_ConflictAction.stopAndSwitch),
            child: Text(
              dialogContext.tr('Finalizar y cambiar', 'Stop and switch'),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(
              dialogContext,
            ).pop(_ConflictAction.returnToTimer),
            child: Text(
              dialogContext.tr('Volver al Pomodoro', 'Return to Pomodoro'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(dialogContext.tr('Cancelar', 'Cancel')),
          ),
        ],
      ),
    ),
  );
}

Future<_TaskFocusSelection?> _showFocusOptions({
  required BuildContext context,
  required Task task,
  required int remainingMinutes,
  required List<PomodoroPresetProjection> ranking,
  required TaskFocusPreset recommendedPreset,
}) {
  return showModalBottomSheet<_TaskFocusSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      final palette = sheetContext.palette;

      return SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 680),
          child: ListView(
            padding: AppCardPaddings.standard,
            shrinkWrap: true,
            children: [
              Text(
                sheetContext.tr('Empezar Pomodoro', 'Start Pomodoro'),
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                sheetContext.tr(
                  '${task.title} · faltan $remainingMinutes min',
                  '${task.title} · $remainingMinutes min remaining',
                ),
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(sheetContext).pop(
                    _TaskFocusSelection(
                      preset: recommendedPreset,
                      mode: PomodoroPlanMode.continuous,
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    task.status == TaskStatus.listed
                        ? sheetContext.tr('Iniciar tarea', 'Start task')
                        : sheetContext.tr('Continuar tarea', 'Continue task'),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                sheetContext.tr(
                  'Usará ${recommendedPreset.label(sheetContext)} y enlazará '
                      'automáticamente todos los bloques restantes.',
                  'It will use ${recommendedPreset.label(sheetContext)} and '
                      'automatically link all remaining blocks.',
                ),
                style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                sheetContext.tr(
                  'Hacer solo un Pomodoro',
                  'Do only one Pomodoro',
                ),
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              for (final option in taskFocusPresets)
                _PresetTile(
                  preset: option,
                  remainingMinutes: remainingMinutes,
                  projection: option.isTestPreset
                      ? null
                      : ranking.firstWhere(
                          (item) =>
                              item.cadence.focusMinutes ==
                                  option.focusMinutes &&
                              item.cadence.breakMinutes == option.breakMinutes,
                        ),
                  onTap: () => Navigator.of(sheetContext).pop(
                    _TaskFocusSelection(
                      preset: option,
                      mode: PomodoroPlanMode.singleBlock,
                    ),
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.tune_rounded),
                title: Text(sheetContext.tr('Personalizado', 'Custom')),
                subtitle: Text(
                  sheetContext.tr(
                    'Define enfoque y descanso en minutos',
                    'Set focus and break in minutes',
                  ),
                ),
                onTap: () async {
                  final selection = await _showCustomFocusDialog(
                    sheetContext,
                    remainingMinutes: remainingMinutes,
                  );
                  if (selection != null && sheetContext.mounted) {
                    Navigator.of(sheetContext).pop(selection);
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _PresetTile extends StatelessWidget {
  const _PresetTile({
    required this.preset,
    required this.remainingMinutes,
    required this.projection,
    required this.onTap,
  });

  final TaskFocusPreset preset;
  final int remainingMinutes;
  final PomodoroPresetProjection? projection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final plan = projection?.plan;
    final supportingLabel = preset.isTestPreset
        ? context.tr(
            'Prueba rápida · un solo bloque',
            'Quick test · one block only',
          )
        : context.tr(
            '${plan!.blockCount} bloques para la tarea · '
                '${plan.elapsedMinutes} min aproximados',
            '${plan.blockCount} blocks for the task · '
                '${plan.elapsedMinutes} min approximately',
          );

    return ListTile(
      leading: Icon(
        preset.isTestPreset ? Icons.science_outlined : Icons.timer_rounded,
      ),
      title: Row(
        children: [
          Expanded(child: Text(preset.label(context))),
          if (projection?.isRecommended ?? false)
            Chip(label: Text(context.tr('Recomendado', 'Recommended'))),
        ],
      ),
      subtitle: Text(supportingLabel),
      onTap: onTap,
    );
  }
}

Future<_TaskFocusSelection?> _showCustomFocusDialog(
  BuildContext context, {
  required int remainingMinutes,
}) {
  return showDialog<_TaskFocusSelection>(
    context: context,
    builder: (_) => _CustomFocusDialog(
      remainingMinutes: remainingMinutes,
    ),
  );
}

class _CustomFocusDialog extends StatefulWidget {
  const _CustomFocusDialog({required this.remainingMinutes});

  final int remainingMinutes;

  @override
  State<_CustomFocusDialog> createState() => _CustomFocusDialogState();
}

class _CustomFocusDialogState extends State<_CustomFocusDialog> {
  late final TextEditingController _focusController;
  late final TextEditingController _breakController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _focusController = TextEditingController(text: '25');
    _breakController = TextEditingController(text: '5');
  }

  @override
  void dispose() {
    _focusController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  PomodoroTaskPlan? get _preview {
    final focus = int.tryParse(_focusController.text);
    final rest = int.tryParse(_breakController.text);
    if (!_isValid(focus, rest)) {
      return null;
    }
    return createPomodoroTaskPlan(
      remainingMinutes: widget.remainingMinutes,
      cadence: PomodoroCadence(
        focusMinutes: focus!,
        breakMinutes: rest!,
      ),
    );
  }

  bool _isValid(int? focus, int? rest) {
    return focus != null &&
        rest != null &&
        focus >= 1 &&
        focus <= 90 &&
        rest >= 1 &&
        rest <= 20;
  }

  void _submit(PomodoroPlanMode mode) {
    final focus = int.tryParse(_focusController.text);
    final rest = int.tryParse(_breakController.text);
    if (!_isValid(focus, rest)) {
      setState(() {
        _error = context.tr(
          'Enfoque: 1-90 min. Descanso: 1-20 min.',
          'Focus: 1-90 min. Break: 1-20 min.',
        );
      });
      return;
    }
    Navigator.of(context).pop(
      _TaskFocusSelection(
        preset: TaskFocusPreset.minutes(
          focusMinutes: focus!,
          breakMinutes: rest!,
        ),
        mode: mode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = _preview;

    return AlertDialog(
      scrollable: true,
      title: Text(
        context.tr('Pomodoro personalizado', 'Custom Pomodoro'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _focusController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: context.tr('Enfoque en minutos', 'Focus in minutes'),
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _breakController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: context.tr('Descanso en minutos', 'Break in minutes'),
              errorText: _error,
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
          if (plan != null) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.tr(
                  '${plan.blockCount} bloques: '
                      '${plan.blocks.map((block) => block.focusMinutes).join(' + ')} min\n'
                      '${plan.breakCount} descansos · '
                      '${plan.elapsedMinutes} min aproximados',
                  '${plan.blockCount} blocks: '
                      '${plan.blocks.map((block) => block.focusMinutes).join(' + ')} min\n'
                      '${plan.breakCount} breaks · '
                      '${plan.elapsedMinutes} min approximately',
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        OutlinedButton(
          onPressed: () => _submit(PomodoroPlanMode.singleBlock),
          child: Text(
            context.tr('Solo este Pomodoro', 'Only this Pomodoro'),
          ),
        ),
        FilledButton(
          onPressed: () => _submit(PomodoroPlanMode.continuous),
          child: Text(
            context.tr('Usar para todo el plan', 'Use for the entire plan'),
          ),
        ),
      ],
    );
  }
}
