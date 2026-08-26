import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/widgets/routines_view.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/start_task_focus_flow.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, this.showRoutines = false});

  static const routePath = '/tasks';
  final bool showRoutines;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _titleController = TextEditingController();
  final TasksController _tasksController = serviceLocator<TasksController>();
  RoutinesRepository? _routinesRepository;
  RoutinesController? _routinesController;
  late _PlanningView _selectedView;

  RoutinesController get _routineController =>
      _routinesController ??= serviceLocator<RoutinesController>();

  RoutinesRepository get _routineRepository =>
      _routinesRepository ??= serviceLocator<RoutinesRepository>();

  @override
  void initState() {
    super.initState();
    _selectedView = widget.showRoutines
        ? _PlanningView.routines
        : _PlanningView.tasks;
    if (widget.showRoutines) {
      _routineController.load();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    final created = await _tasksController.createTask(_titleController.text);
    if (created) {
      _titleController.clear();
      if (!mounted) {
        return;
      }

      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SignalBuilder(
      builder: (context) {
        final tasks = _tasksController.tasks.value;
        final visibleTasks = _tasksController.filteredTasks.value;
        final temporallyFilteredTasks =
            _tasksController.temporallyFilteredTasks.value;
        final filter = _tasksController.filter.value;
        final temporalFilter = _tasksController.temporalFilter.value;
        final validationMessage = _tasksController.validationMessage.value;

        return ListView(
          padding: AppCardPaddings.page,
          children: [
            const SizedBox(height: 24),
            Text(
              _selectedView == _PlanningView.tasks
                  ? context.tr('Mis tareas', 'My tasks')
                  : context.tr('Mis rutinas', 'My routines'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: AppDesignTokens.mainTitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(
                _selectedView == _PlanningView.tasks
                    ? 'Organiza lo importante de hoy'
                    : 'Programa actividades que repites con frecuencia',
                _selectedView == _PlanningView.tasks
                    ? 'Organize what matters today'
                    : 'Schedule activities you repeat frequently',
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<_PlanningView>(
                key: const ValueKey('tasks-routines-selector'),
                segments: [
                  ButtonSegment(
                    value: _PlanningView.tasks,
                    icon: const Icon(Icons.checklist_rounded),
                    label: Text(context.tr('Tareas', 'Tasks')),
                  ),
                  ButtonSegment(
                    value: _PlanningView.routines,
                    icon: const Icon(Icons.event_repeat_rounded),
                    label: Text(context.tr('Rutinas', 'Routines')),
                  ),
                ],
                selected: {_selectedView},
                showSelectedIcon: false,
                onSelectionChanged: (selection) {
                  final selected = selection.first;
                  setState(() => _selectedView = selected);
                  if (selected == _PlanningView.routines &&
                      _routineController.routines.value.isEmpty) {
                    _routineController.load();
                  } else if (selected == _PlanningView.tasks) {
                    _tasksController.loadTasks();
                  }
                },
              ),
            ),
            const SizedBox(height: 18),
            if (_selectedView == _PlanningView.tasks) ...[
              GlassCard(
                padding: AppCardPaddings.compact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: context.tr('Nueva tarea', 'New task'),
                        hintText: context.tr(
                          'Ej. Revisar avance del proyecto',
                          'E.g. Review project progress',
                        ),
                        errorText: _localizedValidationMessage(
                          context,
                          validationMessage,
                        ),
                        prefixIcon: const Icon(Icons.add_task_rounded),
                      ),
                      onChanged: (_) =>
                          _tasksController.clearValidationMessage(),
                      onSubmitted: (_) => _createTask(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _createTask,
                        icon: const Icon(Icons.add_rounded),
                        label: Text(context.tr('Agregar tarea', 'Add task')),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (tasks.isNotEmpty) ...[
                _TaskFilterBar(
                  selectedFilter: filter,
                  tasks: temporallyFilteredTasks,
                  onFilterChanged: (value) =>
                      _tasksController.selectedFilter = value,
                ),
                const SizedBox(height: 10),
                _TaskTemporalFilterButton(
                  filter: temporalFilter,
                  onPressed: _showTemporalFilterPicker,
                ),
                const SizedBox(height: 18),
              ],
              GlassCard(
                child: tasks.isEmpty
                    ? const _EmptyTasksState()
                    : _TaskList(
                        filter: filter,
                        temporalFilter: temporalFilter,
                        tasks: visibleTasks,
                        onToggleCompleted:
                            _tasksController.toggleTaskCompletion,
                        onStartFocus: (task) => startTaskFocusFlow(
                          context: context,
                          task: task,
                        ),
                        onEdit: _showEditTaskDialog,
                        onDelete: _confirmDeleteTask,
                      ),
              ),
            ] else
              RoutinesView(
                controller: _routineController,
                tasksController: _tasksController,
              ),
          ],
        );
      },
    );
  }
}

class _TaskTemporalFilterButton extends StatelessWidget {
  const _TaskTemporalFilterButton({
    required this.filter,
    required this.onPressed,
  });

  final TaskTemporalFilter filter;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        key: const ValueKey('task-temporal-filter-button'),
        onPressed: onPressed,
        icon: const Icon(Icons.date_range_rounded),
        label: Text(_temporalFilterLabel(context, filter)),
      ),
    );
  }
}

enum _PlanningView { tasks, routines }

class _TaskFilterBar extends StatelessWidget {
  const _TaskFilterBar({
    required this.selectedFilter,
    required this.tasks,
    required this.onFilterChanged,
  });

  final TaskFilter selectedFilter;
  final List<Task> tasks;
  final ValueChanged<TaskFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final activeCount = tasks.where((task) => !task.isCompleted).length;
    final completedCount = tasks.length - activeCount;

    return SingleChildScrollView(
      key: const ValueKey('task-status-filter-scroll'),
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<TaskFilter>(
        segments: [
          ButtonSegment(
            value: TaskFilter.all,
            label: Text('${context.tr('Todas', 'All')} (${tasks.length})'),
          ),
          ButtonSegment(
            value: TaskFilter.active,
            label: Text('${context.tr('Activas', 'Active')} ($activeCount)'),
          ),
          ButtonSegment(
            value: TaskFilter.completed,
            label: Text(
              '${context.tr('Hechas', 'Completed')} ($completedCount)',
            ),
          ),
        ],
        selected: {selectedFilter},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => onFilterChanged(selection.first),
      ),
    );
  }
}

class _EmptyTasksState extends StatelessWidget {
  const _EmptyTasksState();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: palette.primaryMuted,
          child: Icon(
            Icons.checklist_rounded,
            color: palette.primary,
            size: 46,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          context.tr('Sin tareas todavía', 'No tasks yet'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppDesignTokens.sectionTitleFontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          context.tr(
            'Agrega tu primera tarea para empezar a planificar el día.',
            'Add your first task to start planning your day.',
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

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.filter,
    required this.temporalFilter,
    required this.tasks,
    required this.onToggleCompleted,
    required this.onStartFocus,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskFilter filter;
  final TaskTemporalFilter temporalFilter;
  final List<Task> tasks;
  final Future<void> Function(String id) onToggleCompleted;
  final ValueChanged<Task> onStartFocus;
  final ValueChanged<Task> onEdit;
  final Future<void> Function(Task task) onDelete;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _FilteredEmptyState(
        filter: filter,
        hasTemporalFilter:
            temporalFilter.kind != TaskTemporalFilterKind.allTime,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                temporalFilter.kind == TaskTemporalFilterKind.allTime
                    ? context.tr('Tareas', 'Tasks')
                    : context.tr('Tareas filtradas', 'Filtered tasks'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${tasks.length}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.palette.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final task in tasks) ...[
          _TaskTile(
            task: task,
            onToggleCompleted: () => onToggleCompleted(task.id),
            onStartFocus: () => onStartFocus(task),
            onEdit: () => onEdit(task),
            onDelete: () => onDelete(task),
          ),
          if (task != tasks.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({
    required this.filter,
    required this.hasTemporalFilter,
  });

  final TaskFilter filter;
  final bool hasTemporalFilter;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final label = hasTemporalFilter
        ? context.tr(
            'No hay tareas en el período seleccionado.',
            'There are no tasks in the selected period.',
          )
        : switch (filter) {
            TaskFilter.all => context.tr(
              'No hay tareas para mostrar.',
              'There are no tasks to show.',
            ),
            TaskFilter.active => context.tr(
              'No quedan tareas activas.',
              'There are no active tasks left.',
            ),
            TaskFilter.completed => context.tr(
              'Todavía no completaste tareas.',
              "You haven't completed any tasks yet.",
            ),
          };

    return Column(
      children: [
        Icon(Icons.inbox_outlined, color: palette.textSecondary, size: 42),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MonthPickerDialog extends StatefulWidget {
  const _MonthPickerDialog({required this.initialMonth});

  final DateTime initialMonth;

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = widget.initialMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('Seleccionar mes', 'Select month')),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: context.tr('Año anterior', 'Previous year'),
                  onPressed: _year > 1900
                      ? () => setState(() => _year -= 1)
                      : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Text(
                    '$_year',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: context.tr('Año siguiente', 'Next year'),
                  onPressed: _year < 2100
                      ? () => setState(() => _year += 1)
                      : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.15,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final selected =
                    widget.initialMonth.year == _year &&
                    widget.initialMonth.month == month;
                return OutlinedButton(
                  key: ValueKey('task-filter-month-$month'),
                  onPressed: () => Navigator.pop(
                    context,
                    DateTime(_year, month),
                  ),
                  style: selected
                      ? OutlinedButton.styleFrom(
                          backgroundColor: context.palette.primaryMuted,
                        )
                      : null,
                  child: Text(_monthName(context, month, short: true)),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
      ],
    );
  }
}

class _YearPickerDialog extends StatelessWidget {
  const _YearPickerDialog({required this.initialYear});

  final int initialYear;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('Seleccionar año', 'Select year')),
      content: SizedBox(
        width: 320,
        height: 360,
        child: YearPicker(
          firstDate: DateTime(1900),
          lastDate: DateTime(2100, 12, 31),
          selectedDate: DateTime(initialYear),
          onChanged: (date) => Navigator.pop(context, date.year),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggleCompleted,
    required this.onStartFocus,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggleCompleted;
  final VoidCallback onStartFocus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 42,
            child: IconButton(
              tooltip: task.isCompleted
                  ? context.tr('Marcar como activa', 'Mark as active')
                  : context.tr('Marcar como completada', 'Mark as completed'),
              onPressed: onToggleCompleted,
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: task.isCompleted ? palette.secondary : palette.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: task.isCompleted ? palette.textSecondary : null,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            tooltip: context.tr('Empezar Pomodoro', 'Start Pomodoro'),
            onPressed: onStartFocus,
            icon: const Icon(Icons.play_arrow_rounded),
          ),
          IconButton(
            tooltip: context.tr('Editar tarea', 'Edit task'),
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            tooltip: context.tr('Eliminar tarea', 'Delete task'),
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}

extension on _TasksPageState {
  Future<void> _showTemporalFilterPicker() async {
    final current = _tasksController.temporalFilter.value;
    final kind = await showModalBottomSheet<TaskTemporalFilterKind>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('task-filter-all-time'),
              leading: const Icon(Icons.all_inclusive_rounded),
              title: Text(sheetContext.tr('Todo el tiempo', 'All time')),
              trailing: current.kind == TaskTemporalFilterKind.allTime
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.pop(
                sheetContext,
                TaskTemporalFilterKind.allTime,
              ),
            ),
            ListTile(
              key: const ValueKey('task-filter-day'),
              leading: const Icon(Icons.today_rounded),
              title: Text(sheetContext.tr('Un día', 'One day')),
              onTap: () => Navigator.pop(
                sheetContext,
                TaskTemporalFilterKind.day,
              ),
            ),
            ListTile(
              key: const ValueKey('task-filter-month'),
              leading: const Icon(Icons.calendar_view_month_rounded),
              title: Text(sheetContext.tr('Un mes', 'One month')),
              onTap: () => Navigator.pop(
                sheetContext,
                TaskTemporalFilterKind.month,
              ),
            ),
            ListTile(
              key: const ValueKey('task-filter-year'),
              leading: const Icon(Icons.calendar_today_rounded),
              title: Text(sheetContext.tr('Un año', 'One year')),
              onTap: () => Navigator.pop(
                sheetContext,
                TaskTemporalFilterKind.year,
              ),
            ),
            ListTile(
              key: const ValueKey('task-filter-range'),
              leading: const Icon(Icons.date_range_rounded),
              title: Text(
                sheetContext.tr('Rango personalizado', 'Custom range'),
              ),
              onTap: () => Navigator.pop(
                sheetContext,
                TaskTemporalFilterKind.range,
              ),
            ),
          ],
        ),
      ),
    );
    if (!mounted || kind == null) return;

    switch (kind) {
      case TaskTemporalFilterKind.allTime:
        await _tasksController.selectTemporalFilter(
          const TaskTemporalFilter.allTime(),
        );
      case TaskTemporalFilterKind.day:
        final selected = await showDatePicker(
          context: context,
          initialDate: current.start ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100, 12, 31),
          helpText: context.tr('Filtrar por día', 'Filter by day'),
        );
        if (selected != null) {
          await _tasksController.selectTemporalFilter(
            TaskTemporalFilter.day(selected),
          );
        }
      case TaskTemporalFilterKind.month:
        final selected = await showDialog<DateTime>(
          context: context,
          builder: (context) => _MonthPickerDialog(
            initialMonth: current.start ?? DateTime.now(),
          ),
        );
        if (selected != null) {
          await _tasksController.selectTemporalFilter(
            TaskTemporalFilter.month(selected),
          );
        }
      case TaskTemporalFilterKind.year:
        final selected = await showDialog<int>(
          context: context,
          builder: (context) => _YearPickerDialog(
            initialYear: current.start?.year ?? DateTime.now().year,
          ),
        );
        if (selected != null) {
          await _tasksController.selectTemporalFilter(
            TaskTemporalFilter.year(selected),
          );
        }
      case TaskTemporalFilterKind.range:
        final selected = await showDateRangePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100, 12, 31),
          initialDateRange: current.kind == TaskTemporalFilterKind.range
              ? DateTimeRange(start: current.start!, end: current.end!)
              : null,
          helpText: context.tr(
            'Filtrar por rango de fechas',
            'Filter by date range',
          ),
        );
        if (selected != null) {
          await _tasksController.selectTemporalFilter(
            TaskTemporalFilter.range(selected.start, selected.end),
          );
        }
    }
  }

  Future<void> _showEditTaskDialog(Task task) async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) => _EditTaskDialog(initialTitle: task.title),
    );

    if (title == null) {
      return;
    }

    final isRoutineTask = await _routineRepository.isGeneratedTask(task.id);
    if (!mounted) return;
    var updateFutureTemplate = false;
    if (isRoutineTask) {
      final scope = await showDialog<_RoutineTaskEditScope>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            dialogContext.tr('Actualizar rutina', 'Update routine'),
          ),
          content: Text(
            dialogContext.tr(
              '¿Este cambio aplica solo a la tarea de hoy o también a las futuras?',
              "Apply this change only to today's task or to future ones too?",
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
              ).pop(_RoutineTaskEditScope.currentOnly),
              child: Text(dialogContext.tr('Solo hoy', 'Today only')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(_RoutineTaskEditScope.currentAndFuture),
              child: Text(
                dialogContext.tr('Hoy y futuras', 'Today and future'),
              ),
            ),
          ],
        ),
      );
      if (scope == null) return;
      updateFutureTemplate = scope == _RoutineTaskEditScope.currentAndFuture;
    }

    final updated = await _tasksController.updateTaskTitle(task.id, title);
    if (updated && updateFutureTemplate) {
      await _routineRepository.updateFutureTemplateTitleForTask(
        taskId: task.id,
        title: title,
      );
    }
  }

  Future<void> _confirmDeleteTask(Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr('Eliminar tarea', 'Delete task')),
          content: Text(
            context.tr(
              '¿Eliminar "${task.title}" de la lista?',
              'Delete "${task.title}" from the list?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.tr('Cancelar', 'Cancel')),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(context.tr('Eliminar', 'Delete')),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      await _tasksController.deleteTask(task.id);
    }
  }
}

enum _RoutineTaskEditScope { currentOnly, currentAndFuture }

class _EditTaskDialog extends StatefulWidget {
  const _EditTaskDialog({required this.initialTitle});

  final String initialTitle;

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final title = _controller.text.trim();

    if (title.isEmpty) {
      setState(() {
        _errorText = context.tr(
          'Escribe un título para guardar la tarea.',
          'Enter a title to save the task.',
        );
      });
      return;
    }

    Navigator.of(context).pop(title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('Editar tarea', 'Edit task')),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.tr('Título', 'Title'),
          errorText: _errorText,
        ),
        textInputAction: TextInputAction.done,
        onChanged: (_) {
          if (_errorText == null) {
            return;
          }

          setState(() {
            _errorText = null;
          });
        },
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_rounded),
          label: Text(context.tr('Guardar', 'Save')),
        ),
      ],
    );
  }
}

String? _localizedValidationMessage(BuildContext context, String? message) {
  if (message == null) {
    return null;
  }

  return switch (message) {
    'Escribe un titulo para guardar la tarea.' => context.tr(
      'Escribe un título para guardar la tarea.',
      'Enter a title to save the task.',
    ),
    'La duracion debe estar entre 1 y 1440 minutos.' => context.tr(
      'La duración debe estar entre 1 y 1440 minutos.',
      'Duration must be between 1 and 1440 minutes.',
    ),
    'No se pudo actualizar la tarea.' => context.tr(
      'No se pudo actualizar la tarea.',
      'The task could not be updated.',
    ),
    _ => message,
  };
}

String _temporalFilterLabel(
  BuildContext context,
  TaskTemporalFilter filter,
) {
  return switch (filter.kind) {
    TaskTemporalFilterKind.allTime => context.tr(
      'Todo el tiempo',
      'All time',
    ),
    TaskTemporalFilterKind.day => _fullDate(context, filter.start!),
    TaskTemporalFilterKind.month =>
      '${_monthName(context, filter.start!.month)} ${filter.start!.year}',
    TaskTemporalFilterKind.year => '${filter.start!.year}',
    TaskTemporalFilterKind.range =>
      '${_shortDate(context, filter.start!)} – '
          '${_shortDate(context, filter.end!)}',
  };
}

String _fullDate(BuildContext context, DateTime date) {
  return '${date.day} ${_monthName(context, date.month)} ${date.year}';
}

String _shortDate(BuildContext context, DateTime date) {
  final separator = Localizations.localeOf(context).languageCode == 'es'
      ? '/'
      : '/';
  return Localizations.localeOf(context).languageCode == 'es'
      ? '${date.day.toString().padLeft(2, '0')}$separator'
            '${date.month.toString().padLeft(2, '0')}$separator${date.year}'
      : '${date.month.toString().padLeft(2, '0')}$separator'
            '${date.day.toString().padLeft(2, '0')}$separator${date.year}';
}

String _monthName(BuildContext context, int month, {bool short = false}) {
  const spanish = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  const english = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final isSpanish = Localizations.localeOf(context).languageCode == 'es';
  final name = (isSpanish ? spanish : english)[month - 1];
  if (!short) return name;
  return name.substring(0, name.length < 3 ? name.length : 3);
}
