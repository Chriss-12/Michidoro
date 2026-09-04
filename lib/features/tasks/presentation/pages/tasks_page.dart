import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/controllers/quick_notes_controller.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/widgets/quick_notes_view.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/widgets/routines_view.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/start_task_focus_flow.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/widgets/planned_task_card.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/widgets/task_planning_dialog.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:pomodoro_app_v1/shared/molecules/speech_dictation_button.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, this.showRoutines = false});

  static const routePath = '/tasks';
  final bool showRoutines;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  static const _creationDurationOptions = [25, 30, 45, 60, 90, 120];

  final TextEditingController _titleController = TextEditingController();
  final TasksController _tasksController = serviceLocator<TasksController>();
  RoutinesRepository? _routinesRepository;
  RoutinesController? _routinesController;
  QuickNotesController? _quickNotesController;
  GoalsController? _goalsController;
  PomodoroController? _pomodoroController;
  String? _selectedCreationGoalId;
  int _selectedCreationDurationMinutes = _creationDurationOptions.first;
  late _PlanningView _selectedView;

  RoutinesController get _routineController =>
      _routinesController ??= serviceLocator<RoutinesController>();

  RoutinesRepository get _routineRepository =>
      _routinesRepository ??= serviceLocator<RoutinesRepository>();

  QuickNotesController get _quickNoteController =>
      _quickNotesController ??= serviceLocator<QuickNotesController>();

  @override
  void initState() {
    super.initState();
    _selectedView = widget.showRoutines
        ? _PlanningView.routines
        : _PlanningView.tasks;
    _goalsController = serviceLocator.isRegistered<GoalsController>()
        ? serviceLocator<GoalsController>()
        : null;
    _pomodoroController = serviceLocator.isRegistered<PomodoroController>()
        ? serviceLocator<PomodoroController>()
        : null;
    if (widget.showRoutines) {
      _routineController.load();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _createTask(List<ProductivityGoal> selectableGoals) async {
    final selectedGoal = _goalById(
      _selectedCreationGoalId,
      selectableGoals,
    );
    final created = selectedGoal == null
        ? await _tasksController.createTask(
            _titleController.text,
            durationMinutes: _selectedCreationDurationMinutes,
          )
        : await _tasksController.createPlannedTask(
            rawTitle: _titleController.text,
            scheduledDate: selectedGoal.targetDate!,
            goalId: selectedGoal.id,
            durationMinutes: _selectedCreationDurationMinutes,
          );
    if (created) {
      _titleController.clear();
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedCreationGoalId = null;
        _selectedCreationDurationMinutes = _creationDurationOptions.first;
      });
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _selectCreationGoal(
    List<ProductivityGoal> selectableGoals,
  ) async {
    final selection = await showModalBottomSheet<_TaskGoalSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _TaskCreationGoalPicker(
        goals: selectableGoals,
        selectedGoalId: _selectedCreationGoalId,
      ),
    );
    if (selection == null || !mounted) {
      return;
    }
    setState(() => _selectedCreationGoalId = selection.goalId);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SignalBuilder(
      builder: (context) {
        final tasks = _tasksController.tasks.value;
        final visibleTasks = _tasksController.filteredTasks.value;
        final goalFilteredTasks = _tasksController.goalFilteredTasks.value;
        final filter = _tasksController.filter.value;
        final selectedGoalId = _tasksController.goalFilter.value;
        final temporalFilter = _tasksController.temporalFilter.value;
        final validationMessage = _tasksController.validationMessage.value;
        final goals =
            _goalsController?.goals.value ?? const <ProductivityGoal>[];
        final selectableCreationGoals =
            _goalsController?.goalsOnOrAfter(DateTime.now()) ??
            const <ProductivityGoal>[];
        final selectedCreationGoal = _goalById(
          _selectedCreationGoalId,
          selectableCreationGoals,
        );
        final focusedSecondsByTask = _focusedSecondsByTask(
          _pomodoroController?.sessions.value ?? const <PomodoroSession>[],
        );

        return RefreshIndicator(
          onRefresh: refreshApplicationData,
          child: ListView(
            key: const PageStorageKey('tasks-scroll'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppCardPaddings.page,
            children: [
              const SizedBox(height: 24),
              Text(
                switch (_selectedView) {
                  _PlanningView.tasks => context.tr('Mis tareas', 'My tasks'),
                  _PlanningView.routines => context.tr(
                    'Mis rutinas',
                    'My routines',
                  ),
                  _PlanningView.quickNotes => context.tr(
                    'Mis notas rápidas',
                    'My quick notes',
                  ),
                },
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: AppDesignTokens.mainTitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(
                  switch (_selectedView) {
                    _PlanningView.tasks => 'Organiza lo importante de hoy',
                    _PlanningView.routines =>
                      'Programa actividades que repites con frecuencia',
                    _PlanningView.quickNotes =>
                      'Captura ideas y recordatorios sin convertirlos en tareas',
                  },
                  switch (_selectedView) {
                    _PlanningView.tasks => 'Organize what matters today',
                    _PlanningView.routines =>
                      'Schedule activities you repeat frequently',
                    _PlanningView.quickNotes =>
                      'Capture ideas and reminders without turning them into tasks',
                  },
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
                    ButtonSegment(
                      value: _PlanningView.quickNotes,
                      icon: const Icon(Icons.sticky_note_2_rounded),
                      label: Text(context.tr('Notas', 'Notes')),
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
                    } else if (selected == _PlanningView.quickNotes &&
                        _quickNoteController.notes.value.isEmpty) {
                      _quickNoteController.load();
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
                        key: const ValueKey('task-create-title'),
                        controller: _titleController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 2,
                        scrollPadding: const EdgeInsets.only(bottom: 120),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
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
                          suffixIcon: SpeechDictationFieldActions(
                            fieldId: 'task-create-title',
                            textController: _titleController,
                            onChanged: (_) =>
                                _tasksController.clearValidationMessage(),
                          ),
                        ),
                        onChanged: (_) =>
                            _tasksController.clearValidationMessage(),
                      ),
                      const SizedBox(height: 12),
                      _TaskCreationGoalSelector(
                        selectedGoal: selectedCreationGoal,
                        onPressed: () =>
                            _selectCreationGoal(selectableCreationGoals),
                      ),
                      const SizedBox(height: 12),
                      _TaskCreationDurationSelector(
                        options: _creationDurationOptions,
                        selectedMinutes: _selectedCreationDurationMinutes,
                        onChanged: (minutes) => setState(
                          () => _selectedCreationDurationMinutes = minutes,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _createTask(selectableCreationGoals),
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
                    tasks: goalFilteredTasks,
                    onFilterChanged: (value) =>
                        _tasksController.selectedFilter = value,
                  ),
                  const SizedBox(height: 10),
                  if (goals.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: _TaskGoalFilter(
                        goals: goals,
                        selectedGoalId: selectedGoalId,
                        onChanged: (value) =>
                            _tasksController.selectedGoalId = value,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
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
                          goals: goals,
                          focusedSecondsByTask: focusedSecondsByTask,
                          onStatusChanged: (task, status) => _tasksController
                              .updateTaskStatus(task.id, status),
                          onStartFocus: (task) => startTaskFocusFlow(
                            context: context,
                            task: task,
                          ),
                          onEditTitle: _showEditTaskDialog,
                          onEditPlanning: _showTaskPlanningDialog,
                          onDelete: _confirmDeleteTask,
                        ),
                ),
              ] else if (_selectedView == _PlanningView.routines)
                RoutinesView(
                  controller: _routineController,
                  tasksController: _tasksController,
                )
              else
                QuickNotesView(controller: _quickNoteController),
            ],
          ),
        );
      },
    );
  }
}

class _TaskCreationDurationSelector extends StatelessWidget {
  const _TaskCreationDurationSelector({
    required this.options,
    required this.selectedMinutes,
    required this.onChanged,
  });

  final List<int> options;
  final int selectedMinutes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.tr('Duración de la tarea', 'Task duration'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final minutes in options)
              ChoiceChip(
                key: ValueKey('task-create-duration-$minutes'),
                label: Text('$minutes min'),
                selected: selectedMinutes == minutes,
                onSelected: (selected) {
                  if (selected) onChanged(minutes);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _TaskCreationGoalSelector extends StatelessWidget {
  const _TaskCreationGoalSelector({
    required this.selectedGoal,
    required this.onPressed,
  });

  final ProductivityGoal? selectedGoal;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final selectedDate = selectedGoal?.targetDate;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        key: const ValueKey('task-create-goal-selector'),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          children: [
            const Icon(Icons.flag_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Objetivo', 'Goal'),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedGoal?.title ??
                        context.tr('Sin objetivo', 'No goal'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (selectedDate != null)
                    Text(
                      MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(selectedDate),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }
}

class _TaskCreationGoalPicker extends StatefulWidget {
  const _TaskCreationGoalPicker({
    required this.goals,
    required this.selectedGoalId,
  });

  final List<ProductivityGoal> goals;
  final String? selectedGoalId;

  @override
  State<_TaskCreationGoalPicker> createState() =>
      _TaskCreationGoalPickerState();
}

class _TaskCreationGoalPickerState extends State<_TaskCreationGoalPicker> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _normalizeGoalSearch(_query);
    final visibleGoals = widget.goals
        .where(
          (goal) =>
              normalizedQuery.isEmpty ||
              _normalizeGoalSearch(goal.title).contains(normalizedQuery),
        )
        .toList(growable: false);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.palette.neutral,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.tr('Elegir objetivo', 'Choose goal'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(
                  'Solo objetivos de hoy en adelante',
                  'Only goals from today onward',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              TextField(
                key: const ValueKey('task-create-goal-search'),
                controller: _searchController,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: context.tr(
                    'Buscar objetivo',
                    'Search goals',
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: SpeechDictationFieldActions(
                    fieldId: 'task-create-goal-search',
                    textController: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _TaskGoalPickerTile(
                      key: const ValueKey('task-create-goal-none'),
                      title: context.tr('Sin objetivo', 'No goal'),
                      subtitle: context.tr(
                        'Crear como tarea rápida',
                        'Create as a quick task',
                      ),
                      selected: widget.selectedGoalId == null,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(const _TaskGoalSelection(null)),
                    ),
                    if (visibleGoals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 24,
                        ),
                        child: Text(
                          normalizedQuery.isEmpty
                              ? context.tr(
                                  'No hay objetivos disponibles desde hoy.',
                                  'There are no goals available from today.',
                                )
                              : context.tr(
                                  'No encontramos objetivos con esa búsqueda.',
                                  'No goals match that search.',
                                ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      for (final goal in visibleGoals)
                        _TaskGoalPickerTile(
                          key: ValueKey(
                            'task-create-goal-option-${goal.id}',
                          ),
                          title: goal.title,
                          subtitle: MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(goal.targetDate!),
                          selected: widget.selectedGoalId == goal.id,
                          onTap: () => Navigator.of(
                            context,
                          ).pop(_TaskGoalSelection(goal.id)),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskGoalPickerTile extends StatelessWidget {
  const _TaskGoalPickerTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        selected ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: selected
            ? context.palette.primary
            : context.palette.textSecondary,
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      selected: selected,
      selectedTileColor: context.palette.primaryMuted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _TaskGoalSelection {
  const _TaskGoalSelection(this.goalId);

  final String? goalId;
}

String _normalizeGoalSearch(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp('[áàäâ]'), 'a')
      .replaceAll(RegExp('[éèëê]'), 'e')
      .replaceAll(RegExp('[íìïî]'), 'i')
      .replaceAll(RegExp('[óòöô]'), 'o')
      .replaceAll(RegExp('[úùüû]'), 'u')
      .replaceAll('ñ', 'n');
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

class _TaskGoalFilter extends StatelessWidget {
  const _TaskGoalFilter({
    required this.goals,
    required this.selectedGoalId,
    required this.onChanged,
  });

  static const _allGoalsValue = '';

  final List<ProductivityGoal> goals;
  final String? selectedGoalId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveValue = goals.any((goal) => goal.id == selectedGoalId)
        ? selectedGoalId!
        : _allGoalsValue;

    return DropdownButtonFormField<String>(
      key: const ValueKey('task-goal-filter'),
      value: effectiveValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.tr('Objetivo', 'Goal'),
        prefixIcon: const Icon(Icons.flag_outlined),
      ),
      items: [
        DropdownMenuItem(
          value: _allGoalsValue,
          child: Text(context.tr('Todos los objetivos', 'All goals')),
        ),
        for (final goal in goals)
          DropdownMenuItem(
            key: ValueKey('task-goal-filter-${goal.id}'),
            value: goal.id,
            child: Text(
              goal.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (value) =>
          onChanged(value == null || value.isEmpty ? null : value),
    );
  }
}

enum _PlanningView { tasks, routines, quickNotes }

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
    required this.goals,
    required this.focusedSecondsByTask,
    required this.onStatusChanged,
    required this.onStartFocus,
    required this.onEditTitle,
    required this.onEditPlanning,
    required this.onDelete,
  });

  final TaskFilter filter;
  final TaskTemporalFilter temporalFilter;
  final List<Task> tasks;
  final List<ProductivityGoal> goals;
  final Map<String, int> focusedSecondsByTask;
  final void Function(Task task, TaskStatus status) onStatusChanged;
  final ValueChanged<Task> onStartFocus;
  final ValueChanged<Task> onEditTitle;
  final ValueChanged<Task> onEditPlanning;
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
          PlannedTaskCard(
            task: task,
            goal: _goalForTask(task, goals),
            focusedSeconds: focusedSecondsByTask[task.id] ?? 0,
            onStatusChanged: (status) => onStatusChanged(task, status),
            onStartFocus: () => onStartFocus(task),
            onEditTitle: () => onEditTitle(task),
            onEditPlanning: () => onEditPlanning(task),
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

  Future<void> _showTaskPlanningDialog(Task task) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => TaskPlanningDialog(
        task: task,
        goals: _goalsController?.goals.value ?? const <ProductivityGoal>[],
        onSave: ({required goalId, required durationMinutes}) async {
          final saved = await _tasksController.updateTaskPlanning(
            id: task.id,
            goalId: goalId,
            durationMinutes: durationMinutes,
          );
          return saved ? null : _tasksController.validationMessage.value;
        },
        onUnschedule: () async {
          await _tasksController.scheduleTask(task.id, null);
          await _tasksController.assignTaskToGoal(task.id, null);
        },
      ),
    );
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
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        minLines: 1,
        maxLines: 2,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: context.tr('Título', 'Title'),
          errorText: _errorText,
          suffixIcon: SpeechDictationFieldActions(
            fieldId: 'task-edit-title',
            textController: _controller,
            onChanged: (_) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
          ),
        ),
        onChanged: (_) {
          if (_errorText == null) {
            return;
          }

          setState(() {
            _errorText = null;
          });
        },
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

ProductivityGoal? _goalForTask(Task task, List<ProductivityGoal> goals) {
  for (final goal in goals) {
    if (goal.id == task.goalId) return goal;
  }
  return null;
}

ProductivityGoal? _goalById(
  String? goalId,
  List<ProductivityGoal> goals,
) {
  if (goalId == null) return null;
  for (final goal in goals) {
    if (goal.id == goalId) return goal;
  }
  return null;
}

Map<String, int> _focusedSecondsByTask(List<PomodoroSession> sessions) {
  final focusedSecondsByTask = <String, int>{};
  for (final session in sessions) {
    final taskId = session.taskId;
    if (taskId == null) continue;
    focusedSecondsByTask.update(
      taskId,
      (value) => value + session.focusedSeconds,
      ifAbsent: () => session.focusedSeconds,
    );
  }
  return focusedSecondsByTask;
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
