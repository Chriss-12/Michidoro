import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class PlannedTaskCard extends StatelessWidget {
  const PlannedTaskCard({
    required this.task,
    required this.goal,
    required this.focusedSeconds,
    required this.onStatusChanged,
    required this.onEditTitle,
    required this.onEditPlanning,
    required this.onDelete,
    required this.onStartFocus,
    super.key,
  });

  final Task task;
  final ProductivityGoal? goal;
  final int focusedSeconds;
  final ValueChanged<TaskStatus> onStatusChanged;
  final VoidCallback onEditTitle;
  final VoidCallback onEditPlanning;
  final VoidCallback onDelete;
  final VoidCallback onStartFocus;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final completed = task.status == TaskStatus.completed;
    final statusStyle = _taskStatusStyle(context, task.status);
    final durationMinutes = task.durationMinutes;

    return Container(
      key: ValueKey('planned-task-card-${task.id}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusStyle.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusStyle.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(statusStyle.icon, color: statusStyle.color, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: completed ? palette.textSecondary : null,
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: statusStyle.color,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TaskTag(
                      key: ValueKey('task-status-${task.id}'),
                      label: _taskStatusLabel(context, task.status),
                      color: statusStyle.color,
                      background: statusStyle.background,
                    ),
                    if (durationMinutes != null)
                      _TaskTag(
                        key: ValueKey('task-duration-${task.id}'),
                        label: '$durationMinutes min',
                      ),
                    _TaskTag(
                      key: ValueKey('task-goal-${task.id}'),
                      label:
                          goal?.title ?? context.tr('Sin objetivo', 'No goal'),
                    ),
                  ],
                ),
                if (durationMinutes != null) ...[
                  const SizedBox(height: 12),
                  _TaskFocusProgress(
                    key: ValueKey('task-focus-progress-${task.id}'),
                    focusedSeconds: focusedSeconds,
                    durationMinutes: durationMinutes,
                    color: statusStyle.color,
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<_PlannedTaskAction>(
            tooltip: context.tr('Opciones de tarea', 'Task options'),
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (action) {
              switch (action) {
                case _PlannedTaskAction.startFocus:
                  onStartFocus();
                case _PlannedTaskAction.editTitle:
                  onEditTitle();
                case _PlannedTaskAction.editPlanning:
                  onEditPlanning();
                case _PlannedTaskAction.deleteTask:
                  onDelete();
                case _PlannedTaskAction.markListed:
                  onStatusChanged(TaskStatus.listed);
                case _PlannedTaskAction.markInProgress:
                  onStatusChanged(TaskStatus.inProgress);
                case _PlannedTaskAction.markCompleted:
                  onStatusChanged(TaskStatus.completed);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _PlannedTaskAction.startFocus,
                child: ListTile(
                  leading: const Icon(Icons.play_arrow_rounded),
                  title: Text(context.tr('Empezar Pomodoro', 'Start Pomodoro')),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.editTitle,
                child: ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: Text(context.tr('Editar tarea', 'Edit task')),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.editPlanning,
                child: ListTile(
                  leading: const Icon(Icons.edit_calendar_rounded),
                  title: Text(
                    context.tr('Editar planificación', 'Edit planning'),
                  ),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.markListed,
                child: ListTile(
                  leading: const Icon(Icons.radio_button_unchecked_rounded),
                  title: Text(context.tr('Marcar pendiente', 'Mark pending')),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.markInProgress,
                child: ListTile(
                  leading: const Icon(Icons.timelapse_rounded),
                  title: Text(
                    context.tr('Marcar en progreso', 'Mark in progress'),
                  ),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.markCompleted,
                child: ListTile(
                  leading: const Icon(Icons.check_circle_rounded),
                  title: Text(
                    context.tr('Marcar completada', 'Mark completed'),
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: _PlannedTaskAction.deleteTask,
                child: ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: Text(context.tr('Eliminar tarea', 'Delete task')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _PlannedTaskAction {
  startFocus,
  editTitle,
  editPlanning,
  deleteTask,
  markListed,
  markInProgress,
  markCompleted,
}

class _TaskFocusProgress extends StatelessWidget {
  const _TaskFocusProgress({
    required this.focusedSeconds,
    required this.durationMinutes,
    required this.color,
    super.key,
  });

  final int focusedSeconds;
  final int durationMinutes;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final focusedMinutes = focusedSeconds ~/ 60;
    final shownMinutes = focusedMinutes.clamp(0, durationMinutes);
    final progress = durationMinutes <= 0
        ? 0.0
        : (focusedSeconds / (durationMinutes * 60)).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$shownMinutes/$durationMinutes min',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            color: color,
            backgroundColor: palette.neutralSoft.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _TaskTag extends StatelessWidget {
  const _TaskTag({
    required this.label,
    this.color,
    this.background,
    super.key,
  });

  final String label;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? palette.primaryMuted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color ?? palette.primary,
        ),
      ),
    );
  }
}

String _taskStatusLabel(BuildContext context, TaskStatus status) {
  return switch (status) {
    TaskStatus.listed => context.tr('Pendiente', 'Pending'),
    TaskStatus.inProgress => context.tr('En progreso', 'In progress'),
    TaskStatus.completed => context.tr('Completada', 'Completed'),
  };
}

_TaskStatusStyle _taskStatusStyle(BuildContext context, TaskStatus status) {
  final palette = context.palette;

  return switch (status) {
    TaskStatus.listed => _TaskStatusStyle(
      icon: Icons.assignment_outlined,
      color: palette.tertiary,
      background: palette.accentPeach.withValues(alpha: 0.52),
      surface: palette.surface,
      border: palette.accentPeach,
    ),
    TaskStatus.inProgress => _TaskStatusStyle(
      icon: Icons.pending_actions_rounded,
      color: palette.secondary,
      background: palette.secondarySoft.withValues(alpha: 0.72),
      surface: palette.secondarySoft.withValues(alpha: 0.24),
      border: palette.secondary.withValues(alpha: 0.42),
    ),
    TaskStatus.completed => _TaskStatusStyle(
      icon: Icons.task_alt_rounded,
      color: palette.primary,
      background: palette.primaryMuted.withValues(alpha: 0.72),
      surface: palette.primaryMuted.withValues(alpha: 0.30),
      border: palette.primary.withValues(alpha: 0.42),
    ),
  };
}

class _TaskStatusStyle {
  const _TaskStatusStyle({
    required this.icon,
    required this.color,
    required this.background,
    required this.surface,
    required this.border,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final Color surface;
  final Color border;
}
