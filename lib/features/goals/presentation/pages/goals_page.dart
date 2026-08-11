import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  static const routePath = '/goals';

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final TextEditingController _titleController = TextEditingController();
  final GoalsController _goalsController = serviceLocator<GoalsController>();
  final TasksController _tasksController = serviceLocator<TasksController>();
  int _targetSessions = 4;
  DateTime? _targetDate;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _createGoal() async {
    final created = await _goalsController.createGoal(
      _titleController.text,
      _targetSessions,
      targetDate: _targetDate,
    );

    if (!created) {
      return;
    }

    _titleController.clear();
    setState(() => _targetDate = null);
    if (!mounted) {
      return;
    }

    FocusScope.of(context).unfocus();
  }

  void _changeTargetSessions(int delta) {
    setState(() {
      _targetSessions = (_targetSessions + delta).clamp(1, 24);
    });
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _targetDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
    });
  }

  void _clearTargetDate() {
    setState(() => _targetDate = null);
  }

  Future<void> _editGoal(ProductivityGoal goal) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _EditGoalDialog(
        goal: goal,
        onSave: _updateGoalFromDialog,
      ),
    );
  }

  Future<String?> _updateGoalFromDialog({
    required ProductivityGoal goal,
    required String rawTitle,
    required int targetSessions,
    DateTime? targetDate,
  }) async {
    final saved = await _goalsController.updateGoalDetails(
      id: goal.id,
      rawTitle: rawTitle,
      targetSessions: targetSessions,
      targetDate: targetDate,
    );

    if (!saved) {
      if (!mounted) {
        return null;
      }
      return _localizedGoalValidation(
        context,
        _goalsController.validationMessage.value,
      );
    }

    return null;
  }

  Future<void> _confirmDeleteGoal(ProductivityGoal goal) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            dialogContext.tr('Eliminar objetivo', 'Delete goal'),
          ),
          content: Text(
            dialogContext.tr(
              'Se eliminará "${goal.title}" de tu plan local.',
              '"${goal.title}" will be removed from your local plan.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.tr('Cancelar', 'Cancel')),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(dialogContext.tr('Eliminar', 'Delete')),
            ),
          ],
        );
      },
    );

    if (delete ?? false) {
      await _goalsController.deleteGoal(goal.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SignalBuilder(
      builder: (context) {
        final goals = _goalsController.goals.value;
        final taskSummary = _tasksController.allTaskSummary.value;
        final unassignedSummary = _tasksController.unassignedSummary();
        final validationMessage = _localizedGoalValidation(
          context,
          _goalsController.validationMessage.value,
        );
        final totalGoals = goals.length;
        final completedGoals = goals.where((goal) {
          final summary = _tasksController.summaryForGoal(goal.id);
          return summary.total > 0 && summary.completed == summary.total;
        }).length;
        final averageProgress = goals.isEmpty
            ? 0.0
            : goals
                      .map(
                        (goal) => _tasksController
                            .summaryForGoal(goal.id)
                            .completionRatio,
                      )
                      .fold<double>(
                        0,
                        (total, progress) => total + progress,
                      ) /
                  goals.length;

        return ListView(
          padding: AppCardPaddings.page,
          children: [
            const SizedBox(height: 24),
            Text(
              context.tr('Mis metas', 'My goals'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: AppDesignTokens.mainTitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(
                'Convierte tu enfoque en avances medibles',
                'Turn your focus into measurable progress',
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            _GoalComposerCard(
              titleController: _titleController,
              targetSessions: _targetSessions,
              validationMessage: validationMessage,
              targetDate: _targetDate,
              onTitleChanged: (_) => _goalsController.clearValidationMessage(),
              onTargetChanged: _changeTargetSessions,
              onPickTargetDate: _pickTargetDate,
              onClearTargetDate: _clearTargetDate,
              onSubmitted: _createGoal,
            ),
            const SizedBox(height: 18),
            _GoalsSummaryCard(
              totalGoals: totalGoals,
              completedGoals: completedGoals,
              averageProgress: averageProgress,
              taskSummary: taskSummary,
            ),
            const SizedBox(height: 18),
            _UnassignedTasksSummaryCard(summary: unassignedSummary),
            const SizedBox(height: 18),
            GlassCard(
              child: goals.isEmpty
                  ? const _EmptyGoalsState()
                  : _GoalsList(
                      goals: goals,
                      tasksController: _tasksController,
                      onIncrement: _goalsController.incrementProgress,
                      onDecrement: _goalsController.decrementProgress,
                      onEdit: _editGoal,
                      onDelete: _confirmDeleteGoal,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _EditGoalDialog extends StatefulWidget {
  const _EditGoalDialog({
    required this.goal,
    required this.onSave,
  });

  final ProductivityGoal goal;
  final Future<String?> Function({
    required ProductivityGoal goal,
    required String rawTitle,
    required int targetSessions,
    DateTime? targetDate,
  })
  onSave;

  @override
  State<_EditGoalDialog> createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends State<_EditGoalDialog> {
  late final TextEditingController _titleController;
  late int _targetSessions;
  DateTime? _targetDate;
  String? _validationMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    _targetSessions = widget.goal.targetSessions;
    _targetDate = widget.goal.targetDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _targetDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
    });
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    final validationMessage = await widget.onSave(
      goal: widget.goal,
      rawTitle: _titleController.text,
      targetSessions: _targetSessions,
      targetDate: _targetDate,
    );

    if (!mounted) {
      return;
    }

    if (validationMessage != null) {
      setState(() {
        _validationMessage = context.localizeMessage(validationMessage);
        _isSaving = false;
      });
      return;
    }

    Navigator.of(context).pop();
  }

  void _changeTargetSessions(int delta) {
    setState(() {
      _targetSessions = (_targetSessions + delta).clamp(1, 24);
    });
  }

  void _clearTargetDate() {
    setState(() => _targetDate = null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(context.tr('Editar objetivo', 'Edit goal')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: context.tr('Objetivo', 'Goal'),
              errorText: _validationMessage,
              prefixIcon: const Icon(Icons.flag_rounded),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 14),
          _TargetSessionsStepper(
            value: _targetSessions,
            onChanged: _changeTargetSessions,
          ),
          const SizedBox(height: 14),
          _TargetDateSelector(
            targetDate: _targetDate,
            onPickDate: _pickTargetDate,
            onClearDate: _targetDate == null ? null : _clearTargetDate,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : _submit,
          icon: const Icon(Icons.check_rounded),
          label: Text(context.tr('Guardar', 'Save')),
        ),
      ],
    );
  }
}

class _GoalComposerCard extends StatelessWidget {
  const _GoalComposerCard({
    required this.titleController,
    required this.targetSessions,
    required this.validationMessage,
    required this.targetDate,
    required this.onTitleChanged,
    required this.onTargetChanged,
    required this.onPickTargetDate,
    required this.onClearTargetDate,
    required this.onSubmitted,
  });

  final TextEditingController titleController;
  final int targetSessions;
  final String? validationMessage;
  final DateTime? targetDate;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<int> onTargetChanged;
  final VoidCallback onPickTargetDate;
  final VoidCallback onClearTargetDate;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: context.tr('Nueva meta', 'New goal'),
              hintText: context.tr(
                'Ej. Completar el módulo de reportes',
                'E.g. Complete the reports module',
              ),
              errorText: validationMessage,
              prefixIcon: const Icon(Icons.flag_rounded),
            ),
            onChanged: onTitleChanged,
            onSubmitted: (_) => onSubmitted(),
          ),
          const SizedBox(height: 14),
          _TargetSessionsStepper(
            value: targetSessions,
            onChanged: onTargetChanged,
          ),
          const SizedBox(height: 14),
          _TargetDateSelector(
            targetDate: targetDate,
            onPickDate: onPickTargetDate,
            onClearDate: targetDate == null ? null : onClearTargetDate,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSubmitted,
              icon: const Icon(Icons.add_rounded),
              label: Text(context.tr('Agregar meta', 'Add goal')),
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetDateSelector extends StatelessWidget {
  const _TargetDateSelector({
    required this.targetDate,
    required this.onPickDate,
    required this.onClearDate,
  });

  final DateTime? targetDate;
  final VoidCallback onPickDate;
  final VoidCallback? onClearDate;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Icon(Icons.event_rounded, color: palette.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Fecha objetivo', 'Target date'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  targetDate == null
                      ? context.tr('Sin fecha definida', 'No date set')
                      : _formatGoalDate(context, targetDate!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.tr('Elegir fecha', 'Choose date'),
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_month_rounded),
          ),
          IconButton(
            tooltip: context.tr('Quitar fecha', 'Remove date'),
            onPressed: onClearDate,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _TargetSessionsStepper extends StatelessWidget {
  const _TargetSessionsStepper({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_rounded, color: palette.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Meta de pomodoros', 'Pomodoro target'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr(
                    '$value ${value == 1 ? 'sesión' : 'sesiones'} para completar',
                    '$value ${value == 1 ? 'session' : 'sessions'} to complete',
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.tr('Reducir objetivo', 'Decrease target'),
            onPressed: value == 1 ? null : () => onChanged(-1),
            icon: const Icon(Icons.remove_rounded),
          ),
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          IconButton(
            tooltip: context.tr('Aumentar objetivo', 'Increase target'),
            onPressed: value == 24 ? null : () => onChanged(1),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _GoalsSummaryCard extends StatelessWidget {
  const _GoalsSummaryCard({
    required this.totalGoals,
    required this.completedGoals,
    required this.averageProgress,
    required this.taskSummary,
  });

  final int totalGoals;
  final int completedGoals;
  final double averageProgress;
  final TaskStatusSummary taskSummary;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progressLabel = (averageProgress * 100).round();

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('Progreso general', 'Overall progress'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppDesignTokens.sectionTitleFontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$progressLabel%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: averageProgress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(99),
            backgroundColor: palette.primaryMuted,
          ),
          const SizedBox(height: 14),
          _SummaryMetric(
            label: context.tr('Objetivos', 'Goals'),
            value: '$totalGoals',
          ),
          const SizedBox(height: 8),
          _SummaryMetric(
            label: context.tr('Objetivos listos', 'Completed goals'),
            value: '$completedGoals',
          ),
          const SizedBox(height: 8),
          _SummaryMetric(
            label: context.tr('Pendientes', 'Pending'),
            value: '${taskSummary.listed}',
          ),
          const SizedBox(height: 8),
          _SummaryMetric(
            label: context.tr('En progreso', 'In progress'),
            value: '${taskSummary.inProgress}',
          ),
          const SizedBox(height: 8),
          _SummaryMetric(
            label: context.tr('Completadas', 'Completed'),
            value: '${taskSummary.completed}',
          ),
        ],
      ),
    );
  }
}

class _UnassignedTasksSummaryCard extends StatelessWidget {
  const _UnassignedTasksSummaryCard({required this.summary});

  final TaskStatusSummary summary;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final percent = (summary.completionRatio * 100).round();

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inbox_rounded, color: palette.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.tr('Tareas sin objetivo', 'Tasks without a goal'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _GoalTaskRows(
            summary: summary,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

enum _GoalAction {
  edit,
  delete;

  String label(BuildContext context) {
    return switch (this) {
      _GoalAction.edit => context.tr('Editar', 'Edit'),
      _GoalAction.delete => context.tr('Eliminar', 'Delete'),
    };
  }

  IconData get icon {
    return switch (this) {
      _GoalAction.edit => Icons.edit_rounded,
      _GoalAction.delete => Icons.delete_outline_rounded,
    };
  }
}

class _GoalActionsMenu extends StatelessWidget {
  const _GoalActionsMenu({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_GoalAction>(
      tooltip: context.tr('Opciones de objetivo', 'Goal options'),
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) {
        switch (action) {
          case _GoalAction.edit:
            onEdit();
          case _GoalAction.delete:
            onDelete();
        }
      },
      itemBuilder: (context) {
        return [
          for (final action in _GoalAction.values)
            PopupMenuItem(
              value: action,
              child: Row(
                children: [
                  Icon(action.icon),
                  const SizedBox(width: 12),
                  Text(action.label(context)),
                ],
              ),
            ),
        ];
      },
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.background.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyGoalsState extends StatelessWidget {
  const _EmptyGoalsState();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: palette.primaryMuted,
          child: Icon(
            Icons.flag_rounded,
            color: palette.primary,
            size: 46,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          context.tr('Sin metas todavía', 'No goals yet'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppDesignTokens.sectionTitleFontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          context.tr(
            'Crea una meta y suma pomodoros hasta completarla.',
            'Create a goal and add Pomodoros until you complete it.',
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: palette.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _GoalsList extends StatelessWidget {
  const _GoalsList({
    required this.goals,
    required this.tasksController,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ProductivityGoal> goals;
  final TasksController tasksController;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final ValueChanged<ProductivityGoal> onEdit;
  final ValueChanged<ProductivityGoal> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.tr('Metas activas', 'Active goals'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${goals.length}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.palette.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final goal in goals) ...[
          _GoalTile(
            goal: goal,
            taskSummary: tasksController.summaryForGoal(goal.id),
            onIncrement: () => onIncrement(goal.id),
            onDecrement: () => onDecrement(goal.id),
            onEdit: () => onEdit(goal),
            onDelete: () => onDelete(goal),
          ),
          if (goal != goals.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.goal,
    required this.taskSummary,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductivityGoal goal;
  final TaskStatusSummary taskSummary;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progress = taskSummary.completionRatio;
    final progressLabel = (progress * 100).round();
    final tasksCompleted =
        taskSummary.total > 0 && taskSummary.completed == taskSummary.total;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                tasksCompleted
                    ? Icons.check_circle_rounded
                    : Icons.outlined_flag_rounded,
                color: tasksCompleted ? palette.secondary : palette.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr(
                        '${taskSummary.completed}/${taskSummary.total} '
                            '${taskSummary.total == 1 ? 'tarea completada' : 'tareas completadas'}',
                        '${taskSummary.completed}/${taskSummary.total} '
                            '${taskSummary.total == 1 ? 'task completed' : 'tasks completed'}',
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _GoalTaskRows(summary: taskSummary),
                    if (goal.targetDate != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: palette.textPrimary.withValues(alpha: 0.1),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        child: Text(
                          context.tr(
                            'Fecha objetivo: '
                                '${_formatGoalDate(context, goal.targetDate!)}',
                            'Target date: '
                                '${_formatGoalDate(context, goal.targetDate!)}',
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: palette.textSecondary,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _GoalActionsMenu(
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(99),
            backgroundColor: palette.primaryMuted,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$progressLabel%',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                context.tr(
                  '${goal.completedSessions}/${goal.targetSessions} '
                      '${goal.targetSessions == 1 ? 'pomodoro' : 'pomodoros'}',
                  '${goal.completedSessions}/${goal.targetSessions} '
                      '${goal.targetSessions == 1 ? 'Pomodoro' : 'Pomodoros'}',
                ),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: context.tr('Restar pomodoro', 'Remove Pomodoro'),
                onPressed: goal.completedSessions == 0 ? null : onDecrement,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
              IconButton(
                tooltip: context.tr('Sumar pomodoro', 'Add Pomodoro'),
                onPressed: goal.isCompleted ? null : onIncrement,
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalTaskRows extends StatelessWidget {
  const _GoalTaskRows({
    required this.summary,
    this.fullWidth = false,
  });

  final TaskStatusSummary summary;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GoalTaskRow(
          label: context.tr('Pendientes', 'Pending'),
          value: summary.listed,
          fullWidth: fullWidth,
        ),
        const SizedBox(height: 6),
        _GoalTaskRow(
          label: context.tr('En progreso', 'In progress'),
          value: summary.inProgress,
          fullWidth: fullWidth,
        ),
        const SizedBox(height: 6),
        _GoalTaskRow(
          label: context.tr('Completadas', 'Completed'),
          value: summary.completed,
          fullWidth: fullWidth,
        ),
      ],
    );
  }
}

class _GoalTaskRow extends StatelessWidget {
  const _GoalTaskRow({
    required this.label,
    required this.value,
    required this.fullWidth,
  });

  final String label;
  final int value;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final row = Container(
      width: double.infinity,
      constraints: fullWidth ? null : const BoxConstraints(maxWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: palette.background.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: fullWidth ? FlexFit.tight : FlexFit.loose,
            child: Text(
              label,
              softWrap: true,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$value',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    if (fullWidth) {
      return row;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: row,
    );
  }
}

String? _localizedGoalValidation(BuildContext context, String? message) {
  return switch (message) {
    'Escribe un titulo para guardar la meta.' => context.tr(
      'Escribe un título para guardar la meta.',
      'Enter a title to save the goal.',
    ),
    'El objetivo debe tener al menos 1 pomodoro.' => context.tr(
      'El objetivo debe tener al menos 1 pomodoro.',
      'The goal must include at least 1 Pomodoro.',
    ),
    _ => message,
  };
}

String _formatGoalDate(BuildContext context, DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return context.tr(
    '$day/$month/${date.year}',
    '$month/$day/${date.year}',
  );
}
