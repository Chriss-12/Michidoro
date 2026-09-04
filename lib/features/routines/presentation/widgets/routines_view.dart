import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_identity_color.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/pages/routine_editor_page.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/start_routine_focus_flow.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/date_period_filter_control.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class RoutinesView extends StatelessWidget {
  const RoutinesView({
    required this.controller,
    this.tasksController,
    super.key,
  });

  final RoutinesController controller;
  final TasksController? tasksController;

  Future<void> _openEditor(BuildContext context, {String? routineId}) async {
    final Future<bool?> result;
    if (routineId == null) {
      result = _openCreateDialog(context);
    } else {
      result = context.push<bool>(
        '${RoutineEditorPage.routePath}?id=$routineId',
      );
    }
    final saved = await result;
    if (saved ?? false) {
      await controller.load();
    }
  }

  Future<bool?> _openCreateDialog(BuildContext context) {
    final palette = context.palette;
    return showGeneralDialog<bool>(
      context: context,
      barrierLabel: context.tr('Crear rutina', 'Create routine'),
      barrierColor: Theme.of(
        context,
      ).colorScheme.scrim.withValues(alpha: 0.46),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, _, _) {
        final size = MediaQuery.sizeOf(dialogContext);
        return SizedBox.expand(
          child: SafeArea(
            minimum: const EdgeInsets.all(12),
            child: Center(
              child: Material(
                key: const ValueKey('routine-create-dialog'),
                color: palette.surface,
                elevation: 10,
                shadowColor: palette.textPrimary.withValues(alpha: 0.22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: palette.neutralSoft),
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: math.min(size.width - 24, 560),
                  height: math.min(size.height - 48, 840),
                  child: RoutineEditorPage(
                    onResult: (saved) => Navigator.of(
                      dialogContext,
                      rootNavigator: true,
                    ).pop(saved),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final routines = controller.filteredRoutines.value;
        final isLoading = controller.isLoading.value;
        final error = controller.operationError.value;
        final showTodayState = controller.selectedDateFilter.includes(
          controller.currentLocalTime,
        );
        final tasksById = {
          for (final task in tasksController?.tasks.value ?? const <Task>[])
            task.id: task,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              key: const ValueKey('create-routine'),
              onPressed: () => _openEditor(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(context.tr('Crear rutina', 'Create routine')),
            ),
            const SizedBox(height: 16),
            DatePeriodFilterControl(
              value: controller.selectedDateFilter,
              onChanged: (value) => controller.selectedDateFilter = value,
            ),
            const SizedBox(height: 16),
            _RoutineFilterMenu(
              value: controller.selectedFilter,
              onChanged: (value) => controller.selectedFilter = value,
            ),
            const SizedBox(height: 16),
            if (isLoading && controller.routines.value.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (error != null && controller.routines.value.isEmpty)
              _RoutineLoadError(onRetry: controller.load)
            else if (routines.isEmpty)
              _EmptyRoutinesState(filter: controller.selectedFilter)
            else
              for (var index = 0; index < routines.length; index++) ...[
                _RoutineCard(
                  routine: routines[index],
                  now: controller.currentLocalTime,
                  execution: showTodayState
                      ? _executionFor(routines[index], tasksById)
                      : null,
                  progress: controller.progressForToday(routines[index].id),
                  showTodayState: showTodayState,
                  onEdit: () => _openEditor(
                    context,
                    routineId: routines[index].id,
                  ),
                  onAction: (action) =>
                      _handleAction(context, routines[index], action),
                  onStartFocus: (execution) =>
                      _startExecution(context, execution),
                  onSkipOptional: (execution) => _skipOptional(
                    context,
                    execution,
                  ),
                ),
                if (index != routines.length - 1) const SizedBox(height: 12),
              ],
          ],
        );
      },
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    Routine routine,
    _RoutineAction action,
  ) async {
    var succeeded = false;
    switch (action) {
      case _RoutineAction.edit:
        await _openEditor(context, routineId: routine.id);
        return;
      case _RoutineAction.duplicate:
        succeeded =
            await controller.duplicate(
              routine.id,
              copyLabel: context.tr('copia', 'copy'),
            ) !=
            null;
      case _RoutineAction.pause:
        final until = await _showPauseDialog(context);
        if (!context.mounted || identical(until, _pauseCancelled)) return;
        succeeded = await controller.pause(
          routine.id,
          untilDate: until is DateTime ? until : null,
        );
      case _RoutineAction.resume:
        succeeded = await controller.resume(routine.id);
      case _RoutineAction.archive:
        if (!await _confirmArchive(context, routine.name)) return;
        succeeded = await controller.archive(routine.id);
      case _RoutineAction.restore:
        succeeded = await controller.restore(routine.id);
      case _RoutineAction.skipToday:
        RoutineRun? run;
        for (final candidate in controller.todayRuns.value) {
          if (candidate.sourceRoutineId == routine.id) {
            run = candidate;
            break;
          }
        }
        succeeded = run != null && await controller.skipTodayRun(run);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded
              ? context.tr('Rutina actualizada', 'Routine updated')
              : context.tr(
                  'No se pudo actualizar la rutina',
                  'The routine could not be updated',
                ),
        ),
      ),
    );
  }

  Future<void> _startExecution(
    BuildContext context,
    _RoutineExecution execution,
  ) async {
    await startRoutineTaskFocusFlow(
      context: context,
      task: execution.task,
      run: execution.run,
      item: execution.item,
      controller: controller,
    );
  }

  _RoutineExecution? _executionFor(
    Routine routine,
    Map<String, Task> tasksById,
  ) {
    if (routine.status != RoutineStatus.active) return null;
    RoutineRun? run;
    for (final candidate in controller.todayRuns.value) {
      if (candidate.sourceRoutineId == routine.id) {
        run = candidate;
        break;
      }
    }
    if (run == null) return null;
    final items = controller.todayItemRuns.value[run.id] ?? const [];
    final candidates =
        items
            .where(
              (item) =>
                  item.status == RoutineRunStatus.inProgress ||
                  item.status == RoutineRunStatus.scheduled,
            )
            .toList()
          ..sort((first, second) {
            final statusOrder = first.status == RoutineRunStatus.inProgress
                ? 0
                : 1;
            final otherStatusOrder =
                second.status == RoutineRunStatus.inProgress ? 0 : 1;
            final byStatus = statusOrder.compareTo(otherStatusOrder);
            return byStatus != 0
                ? byStatus
                : first.positionSnapshot.compareTo(second.positionSnapshot);
          });
    for (final item in candidates) {
      final taskId = item.taskId;
      final task = taskId == null ? null : tasksById[taskId];
      if (task == null || task.status == TaskStatus.completed) continue;
      return _RoutineExecution(task: task, item: item, run: run);
    }
    return null;
  }

  Future<void> _skipOptional(
    BuildContext context,
    _RoutineExecution execution,
  ) async {
    final skipped = await controller.skipOptionalItem(execution.item);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          skipped
              ? context.tr('Actividad omitida', 'Activity skipped')
              : context.tr(
                  'No se pudo omitir la actividad',
                  'Could not skip activity',
                ),
        ),
      ),
    );
  }
}

class _RoutineFilterMenu extends StatelessWidget {
  const _RoutineFilterMenu({required this.value, required this.onChanged});

  static const double _menuWidth = 220;

  final RoutineFilter value;
  final ValueChanged<RoutineFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return PopupMenuButton<RoutineFilter>(
      key: const ValueKey('routine-filter'),
      tooltip: context.tr('Filtrar rutinas', 'Filter routines'),
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints.tightFor(width: _menuWidth),
      color: palette.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: palette.neutralSoft),
      ),
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final filter in RoutineFilter.values)
          PopupMenuItem<RoutineFilter>(
            value: filter,
            child: Row(
              children: [
                Icon(
                  filter == value ? Icons.check_rounded : _filterIcon(filter),
                  size: 20,
                  color: filter == value
                      ? palette.primary
                      : palette.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _filterLabel(context, filter),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: palette.neutralSoft),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list_rounded, color: palette.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _filterLabel(context, value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: palette.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.routine,
    required this.now,
    required this.execution,
    required this.progress,
    required this.showTodayState,
    required this.onEdit,
    required this.onAction,
    required this.onStartFocus,
    required this.onSkipOptional,
  });

  final Routine routine;
  final DateTime now;
  final _RoutineExecution? execution;
  final RoutineTodayProgress progress;
  final bool showTodayState;
  final VoidCallback onEdit;
  final ValueChanged<_RoutineAction> onAction;
  final ValueChanged<_RoutineExecution> onStartFocus;
  final ValueChanged<_RoutineExecution> onSkipOptional;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = _routineColor(
      routine.colorKey,
      customColorArgb: routine.customColorArgb,
    );
    final firstMinute = routine.items.isEmpty
        ? null
        : routine.items
              .map((item) => item.scheduledMinute)
              .reduce((first, second) => first < second ? first : second);
    final progressTotal = progress.totalRequiredItems > 0
        ? progress.totalRequiredItems
        : progress.totalItems;
    final progressCompleted = progress.totalRequiredItems > 0
        ? progress.completedRequiredItems
        : progress.completedItems;
    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_routineIcon(routine.iconKey), color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _routineSummary(context, routine, firstMinute, now),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_RoutineAction>(
                tooltip: context.tr('Opciones de rutina', 'Routine options'),
                onSelected: onAction,
                itemBuilder: (context) => _actionsFor(context, routine.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: _statusIcon(routine.status),
                label: _statusLabel(context, routine.status),
                color: accent,
              ),
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: _weekdaySummary(context, routine.weekdays),
              ),
              _InfoChip(
                icon: Icons.format_list_numbered_rounded,
                label: context.tr(
                  '${routine.items.length} '
                      '${routine.items.length == 1 ? 'paso' : 'pasos'}',
                  '${routine.items.length} '
                      '${routine.items.length == 1 ? 'step' : 'steps'}',
                ),
              ),
              if (showTodayState && progress.run != null)
                _InfoChip(
                  icon: _runStatusIcon(progress.run!.status),
                  label: context.tr(
                    'Hoy: ${_runStatusLabel(context, progress.run!.status)}',
                    'Today: ${_runStatusLabel(context, progress.run!.status)}',
                  ),
                  color: accent,
                ),
              if (showTodayState && progressTotal > 0)
                _InfoChip(
                  icon: Icons.donut_small_rounded,
                  label: '$progressCompleted/$progressTotal',
                  color: accent,
                ),
            ],
          ),
          if (execution != null) ...[
            const SizedBox(height: 12),
            Text(
              execution!.item.titleSnapshot,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: ValueKey('start-routine-item-${execution!.item.id}'),
                onPressed: () => onStartFocus(execution!),
                icon: Icon(
                  execution!.item.status == RoutineRunStatus.inProgress
                      ? Icons.play_arrow_rounded
                      : Icons.timer_outlined,
                ),
                label: Text(
                  execution!.item.status == RoutineRunStatus.inProgress
                      ? context.tr('Continuar actividad', 'Continue activity')
                      : context.tr('Iniciar actividad', 'Start activity'),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('routine-edit-button'),
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded),
                  label: Text(context.tr('Editar', 'Edit')),
                ),
              ),
              if (execution != null &&
                  execution!.item.isOptionalSnapshot &&
                  execution!.item.status == RoutineRunStatus.scheduled) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    key: ValueKey('routine-skip-button-${execution!.item.id}'),
                    onPressed: () => onSkipOptional(execution!),
                    icon: const Icon(Icons.skip_next_rounded),
                    label: Text(context.tr('Omitir', 'Skip')),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutineExecution {
  const _RoutineExecution({
    required this.task,
    required this.item,
    required this.run,
  });

  final Task task;
  final RoutineItemRun item;
  final RoutineRun run;
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.palette.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyRoutinesState extends StatelessWidget {
  const _EmptyRoutinesState({required this.filter});
  final RoutineFilter filter;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      children: [
        Icon(
          Icons.event_repeat_rounded,
          size: 48,
          color: context.palette.primary,
        ),
        const SizedBox(height: 14),
        Text(
          _emptyTitle(context, filter),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppDesignTokens.sectionTitleFontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _emptyBody(context, filter),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.palette.textSecondary,
          ),
        ),
      ],
    ),
  );
}

class _RoutineLoadError extends StatelessWidget {
  const _RoutineLoadError({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      children: [
        const Icon(Icons.error_outline_rounded, size: 42),
        const SizedBox(height: 10),
        Text(
          context.tr(
            'No se pudieron cargar las rutinas',
            'Routines could not be loaded',
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.tr('Reintentar', 'Retry')),
        ),
      ],
    ),
  );
}

enum _RoutineAction {
  edit,
  duplicate,
  pause,
  resume,
  archive,
  restore,
  skipToday,
}

const Object _pauseCancelled = Object();

Future<Object?> _showPauseDialog(BuildContext context) => showDialog<Object?>(
  context: context,
  barrierDismissible: false,
  builder: (dialogContext) => AlertDialog(
    title: Text(context.tr('Pausar rutina', 'Pause routine')),
    content: Text(
      context.tr(
        'Puedes pausarla hasta que decidas reactivarla o elegir una fecha.',
        'Pause it until you resume it or choose a date.',
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(dialogContext, _pauseCancelled),
        child: Text(context.tr('Cancelar', 'Cancel')),
      ),
      TextButton(
        onPressed: () => Navigator.pop(dialogContext),
        child: Text(context.tr('Sin fecha', 'No date')),
      ),
      FilledButton(
        onPressed: () async {
          final now = DateTime.now();
          final date = await showDatePicker(
            context: dialogContext,
            firstDate: now,
            lastDate: DateTime(now.year + 5),
            initialDate: now,
          );
          if (date != null && dialogContext.mounted) {
            Navigator.pop(dialogContext, date);
          }
        },
        child: Text(context.tr('Elegir fecha', 'Choose date')),
      ),
    ],
  ),
);

Future<bool> _confirmArchive(BuildContext context, String name) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.tr('Archivar rutina', 'Archive routine')),
        content: Text(
          context.tr(
            '“$name” dejará de programarse, pero conservará su historial.',
            '“$name” will stop being scheduled, but its history is kept.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.tr('Cancelar', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.tr('Archivar', 'Archive')),
          ),
        ],
      ),
    ) ??
    false;

List<PopupMenuEntry<_RoutineAction>> _actionsFor(
  BuildContext context,
  RoutineStatus status,
) {
  final entries = <PopupMenuEntry<_RoutineAction>>[
    _menuItem(
      context,
      _RoutineAction.edit,
      Icons.edit_rounded,
      'Editar',
      'Edit',
    ),
    _menuItem(
      context,
      _RoutineAction.duplicate,
      Icons.copy_rounded,
      'Duplicar',
      'Duplicate',
    ),
  ];
  switch (status) {
    case RoutineStatus.active:
      entries.addAll([
        _menuItem(
          context,
          _RoutineAction.skipToday,
          Icons.skip_next_rounded,
          'Omitir rutina de hoy',
          "Skip today's routine",
        ),
        _menuItem(
          context,
          _RoutineAction.pause,
          Icons.pause_rounded,
          'Pausar',
          'Pause',
        ),
        _menuItem(
          context,
          _RoutineAction.archive,
          Icons.archive_outlined,
          'Archivar',
          'Archive',
        ),
      ]);
    case RoutineStatus.paused:
      entries.addAll([
        _menuItem(
          context,
          _RoutineAction.resume,
          Icons.play_arrow_rounded,
          'Reactivar',
          'Resume',
        ),
        _menuItem(
          context,
          _RoutineAction.archive,
          Icons.archive_outlined,
          'Archivar',
          'Archive',
        ),
      ]);
    case RoutineStatus.archived:
      entries.add(
        _menuItem(
          context,
          _RoutineAction.restore,
          Icons.unarchive_rounded,
          'Restaurar',
          'Restore',
        ),
      );
  }
  return entries;
}

PopupMenuItem<_RoutineAction> _menuItem(
  BuildContext context,
  _RoutineAction action,
  IconData icon,
  String spanish,
  String english,
) => PopupMenuItem(
  value: action,
  child: Row(
    children: [
      Icon(icon, size: 20),
      const SizedBox(width: 10),
      Text(context.tr(spanish, english)),
    ],
  ),
);

String _routineSummary(
  BuildContext context,
  Routine routine,
  int? minute,
  DateTime now,
) {
  if (routine.status == RoutineStatus.archived) {
    return context.tr(
      'Archivada · no se programará',
      'Archived · not scheduled',
    );
  }
  if (routine.status == RoutineStatus.paused) {
    final until = routine.pausedUntilDate;
    return until == null
        ? context.tr('Pausada sin fecha', 'Paused indefinitely')
        : context.tr(
            'Pausada hasta ${_dateLabel(until)}',
            'Paused until ${_dateLabel(until)}',
          );
  }
  if (minute == null) {
    return context.tr('Sin pasos programados', 'No scheduled steps');
  }
  final time = MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
  );
  if (routine.status == RoutineStatus.active &&
      routine.weekdays.contains(now.weekday)) {
    return context.tr('Programada hoy · $time', 'Scheduled today · $time');
  }
  final next = _nextWeekday(routine.weekdays, now.weekday);
  return context.tr(
    'Próxima: ${_weekdayName(context, next)} · $time',
    'Next: ${_weekdayName(context, next)} · $time',
  );
}

String _dateLabel(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

int _nextWeekday(List<int> weekdays, int today) {
  for (var offset = 0; offset < 7; offset++) {
    final candidate = ((today - 1 + offset) % 7) + 1;
    if (weekdays.contains(candidate)) return candidate;
  }
  return today;
}

String _weekdaySummary(BuildContext context, List<int> days) {
  final sorted = [...days]..sort();
  if (sorted.length == 7) return context.tr('Todos los días', 'Every day');
  if (_sameDays(sorted, const [1, 2, 3, 4, 5])) {
    return context.tr('Lun a vie', 'Mon to Fri');
  }
  return sorted
      .map((day) => _weekdayName(context, day, short: true))
      .join(', ');
}

bool _sameDays(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}

String _weekdayName(BuildContext context, int day, {bool short = false}) {
  final spanish = short
      ? const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
      : const [
          'lunes',
          'martes',
          'miércoles',
          'jueves',
          'viernes',
          'sábado',
          'domingo',
        ];
  final english = short
      ? const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
      : const [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ];
  final index = day.clamp(1, 7) - 1;
  return context.tr(spanish[index], english[index]);
}

String _filterLabel(BuildContext context, RoutineFilter filter) =>
    switch (filter) {
      RoutineFilter.active => context.tr('Activas', 'Active'),
      RoutineFilter.paused => context.tr('Pausadas', 'Paused'),
      RoutineFilter.archived => context.tr('Archivadas', 'Archived'),
    };

IconData _filterIcon(RoutineFilter filter) => switch (filter) {
  RoutineFilter.active => Icons.play_circle_outline_rounded,
  RoutineFilter.paused => Icons.pause_circle_outline_rounded,
  RoutineFilter.archived => Icons.archive_outlined,
};

String _statusLabel(BuildContext context, RoutineStatus status) =>
    switch (status) {
      RoutineStatus.active => context.tr('Activa', 'Active'),
      RoutineStatus.paused => context.tr('Pausada', 'Paused'),
      RoutineStatus.archived => context.tr('Archivada', 'Archived'),
    };

IconData _statusIcon(RoutineStatus status) => switch (status) {
  RoutineStatus.active => Icons.play_circle_outline_rounded,
  RoutineStatus.paused => Icons.pause_circle_outline_rounded,
  RoutineStatus.archived => Icons.archive_outlined,
};

String _runStatusLabel(BuildContext context, RoutineRunStatus status) =>
    switch (status) {
      RoutineRunStatus.scheduled => context.tr('Pendiente', 'Pending'),
      RoutineRunStatus.inProgress => context.tr('En progreso', 'In progress'),
      RoutineRunStatus.completed => context.tr('Completada', 'Completed'),
      RoutineRunStatus.skipped => context.tr('Omitida', 'Skipped'),
      RoutineRunStatus.missed => context.tr('Perdida', 'Missed'),
    };

IconData _runStatusIcon(RoutineRunStatus status) => switch (status) {
  RoutineRunStatus.scheduled => Icons.schedule_rounded,
  RoutineRunStatus.inProgress => Icons.timelapse_rounded,
  RoutineRunStatus.completed => Icons.check_circle_rounded,
  RoutineRunStatus.skipped => Icons.skip_next_rounded,
  RoutineRunStatus.missed => Icons.event_busy_rounded,
};

String _emptyTitle(BuildContext context, RoutineFilter filter) =>
    switch (filter) {
      RoutineFilter.active => context.tr(
        'Aún no tienes rutinas',
        'No routines yet',
      ),
      RoutineFilter.paused => context.tr(
        'No hay rutinas pausadas',
        'No paused routines',
      ),
      RoutineFilter.archived => context.tr(
        'No hay rutinas archivadas',
        'No archived routines',
      ),
    };

String _emptyBody(BuildContext context, RoutineFilter filter) =>
    switch (filter) {
      RoutineFilter.active => context.tr(
        'Agrupa actividades repetitivas y programa tus días con claridad.',
        'Group repeating activities and plan your days clearly.',
      ),
      RoutineFilter.paused => context.tr(
        'Las rutinas que pauses aparecerán aquí.',
        'Routines you pause will appear here.',
      ),
      RoutineFilter.archived => context.tr(
        'Las rutinas archivadas conservarán su historial.',
        'Archived routines will keep their history.',
      ),
    };

IconData _routineIcon(String key) => switch (key) {
  'sun' => Icons.wb_sunny_outlined,
  'work' => Icons.work_outline_rounded,
  'fitness' => Icons.fitness_center_rounded,
  'book' => Icons.menu_book_rounded,
  _ => Icons.event_repeat_rounded,
};

Color _routineColor(
  String key, {
  int? customColorArgb,
}) => Color(
  effectiveRoutineIdentityColorArgb(
    colorKey: key,
    customColorArgb: customColorArgb,
  ),
);
