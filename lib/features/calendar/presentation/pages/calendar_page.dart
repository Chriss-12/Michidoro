import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/widgets/goal_date_range_dialog.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/models/goal_period_filter.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/models/routine_schedule_projection.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/pages/routine_editor_page.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/start_routine_focus_flow.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/start_task_focus_flow.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    this.controller,
    this.goalsController,
    this.tasksController,
    this.pomodoroController,
    this.routinesController,
  });

  static const routePath = '/calendar';

  final CalendarController? controller;
  final GoalsController? goalsController;
  final TasksController? tasksController;
  final PomodoroController? pomodoroController;
  final RoutinesController? routinesController;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final CalendarController _controller;
  late final GoalsController _goalsController;
  late final TasksController _tasksController;
  late final PomodoroController _pomodoroController;
  RoutinesController? _routinesController;
  late DateTime _visibleMonth;
  late DateTime _selectedDay;
  GoalPeriod _goalPeriod = GoalPeriod.all;
  DateTimeRange? _goalDateRange;
  List<RoutineScheduleOccurrence> _routineSchedule = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? serviceLocator<CalendarController>();
    _goalsController =
        widget.goalsController ?? serviceLocator<GoalsController>();
    _tasksController =
        widget.tasksController ?? serviceLocator<TasksController>();
    _pomodoroController =
        widget.pomodoroController ?? serviceLocator<PomodoroController>();
    _routinesController =
        widget.routinesController ??
        (serviceLocator.isRegistered<RoutinesController>()
            ? serviceLocator<RoutinesController>()
            : null);
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadPlanningData());
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _controller.eventsForDay(_selectedDay);
    final selectedGoals = _goalsController.goalsForDay(_selectedDay);
    final selectedTasks = _tasksController.tasksForDay(_selectedDay);
    final selectedRoutines = _routineSchedule
        .where((occurrence) => _sameDate(occurrence.localDate, _selectedDay))
        .toList(growable: false);
    final plannedDays = {
      ..._controller.plannedDaysForMonth(_visibleMonth),
      ..._goalsController.plannedDaysForMonth(_visibleMonth),
      ..._tasksController.plannedDaysForMonth(_visibleMonth),
      ..._routineSchedule
          .where(
            (occurrence) =>
                occurrence.localDate.year == _visibleMonth.year &&
                occurrence.localDate.month == _visibleMonth.month,
          )
          .map((occurrence) => occurrence.localDate.day),
    };
    final taskProgressByDay = _tasksController.progressByDayForMonth(
      _visibleMonth,
    );

    return ListView(
      padding: AppCardPaddings.pageWithTop,
      children: [
        Text(
          context.tr('Planificación', 'Planning'),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppDesignTokens.mainTitleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.tr(
            'Organiza objetivos, tareas y rutinas en un solo lugar.',
            'Organize goals, tasks, and routines in one place.',
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        _MonthCard(
          visibleMonth: _visibleMonth,
          selectedDay: _selectedDay,
          plannedDays: plannedDays,
          taskProgressByDay: taskProgressByDay,
          onPreviousMonth: () {
            setState(() {
              _visibleMonth = DateTime(
                _visibleMonth.year,
                _visibleMonth.month - 1,
              );
              _selectedDay = DateTime(
                _visibleMonth.year,
                _visibleMonth.month,
              );
            });
            unawaited(_loadRoutineSchedule());
          },
          onNextMonth: () {
            setState(() {
              _visibleMonth = DateTime(
                _visibleMonth.year,
                _visibleMonth.month + 1,
              );
              _selectedDay = DateTime(
                _visibleMonth.year,
                _visibleMonth.month,
              );
            });
            unawaited(_loadRoutineSchedule());
          },
          onDaySelected: (day) {
            setState(() => _selectedDay = day);
          },
        ),
        const SizedBox(height: 18),
        SignalBuilder(
          builder: (context) {
            final goals = filterGoalsForPeriod(
              _goalsController.goals.value,
              period: _goalPeriod,
              referenceDay: _selectedDay,
              customRange: _goalDateRange,
            );
            return _GoalPeriodCard(
              period: _goalPeriod,
              periodLabel: _goalPeriodLabel(
                context,
                period: _goalPeriod,
                referenceDay: _selectedDay,
                customRange: _goalDateRange,
              ),
              hasSelectedRange: _goalDateRange != null,
              goals: goals,
              tasks: _tasksController.tasks.value,
              onPeriodChanged: _changeGoalPeriod,
              onPrevious: () => _shiftGoalPeriod(-1),
              onNext: () => _shiftGoalPeriod(1),
              onPickPeriod: _pickGoalPeriod,
              onEditGoal: _showEditGoalDialog,
              onDeleteGoal: _confirmDeleteGoal,
            );
          },
        ),
        const SizedBox(height: 18),
        SignalBuilder(
          builder: (context) {
            final focusedSecondsByTask = _focusedSecondsByTask(
              _pomodoroController.sessions.value,
            );

            return _AgendaCard(
              selectedDay: _selectedDay,
              goals: selectedGoals,
              tasks: selectedTasks,
              focusedSecondsByTask: focusedSecondsByTask,
              events: selectedEvents,
              routines: selectedRoutines,
              isLoading: _isLoading,
              onAddGoal: _showCreateGoalDialog,
              onAddTask: _showCreateTaskDialog,
              onScheduleTask: _showScheduleExistingTaskDialog,
              onTaskStatusChanged: _updateTaskStatus,
              onEditTaskPlanning: _showEditTaskPlanningDialog,
              onDeleteTask: _confirmDeleteTask,
              onStartTaskFocus: (task) {
                final routinesController = _routinesController;
                final execution = routinesController == null
                    ? null
                    : findRoutineTaskExecution(
                        controller: routinesController,
                        taskId: task.id,
                      );
                if (routinesController != null && execution != null) {
                  unawaited(
                    startRoutineTaskFocusFlow(
                      context: context,
                      task: task,
                      run: execution.run,
                      item: execution.item,
                      controller: routinesController,
                    ),
                  );
                  return;
                }
                unawaited(startTaskFocusFlow(context: context, task: task));
              },
              onOpenRoutine: (occurrence) => context.push(
                '${RoutineEditorPage.routePath}?id=${occurrence.sourceRoutineId}',
              ),
            );
          },
        ),
      ],
    );
  }

  void _changeGoalPeriod(GoalPeriod period) {
    setState(() => _goalPeriod = period);
    if (period == GoalPeriod.range && _goalDateRange == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            _goalPeriod == GoalPeriod.range &&
            _goalDateRange == null) {
          unawaited(_pickGoalPeriod());
        }
      });
    }
  }

  void _shiftGoalPeriod(int direction) {
    final shifted = switch (_goalPeriod) {
      GoalPeriod.day => _selectedDay.add(Duration(days: direction)),
      GoalPeriod.week => _selectedDay.add(Duration(days: 7 * direction)),
      GoalPeriod.month => _shiftMonth(_selectedDay, direction),
      GoalPeriod.year => _shiftYear(_selectedDay, direction),
      GoalPeriod.all || GoalPeriod.range => _selectedDay,
    };
    if (_sameDate(shifted, _selectedDay)) return;
    setState(() {
      _selectedDay = shifted;
      _visibleMonth = DateTime(shifted.year, shifted.month);
    });
    unawaited(_loadRoutineSchedule());
  }

  Future<void> _pickGoalPeriod() async {
    final now = DateTime.now();
    if (_goalPeriod == GoalPeriod.range) {
      final picked = await showGoalDateRangeDialog(
        context: context,
        firstDate: DateTime(now.year - 10),
        lastDate: DateTime(now.year + 10, 12, 31),
        initialDateRange: _goalDateRange,
      );
      if (!mounted) return;
      if (picked == null) {
        if (_goalDateRange == null) {
          setState(() => _goalPeriod = GoalPeriod.all);
        }
        return;
      }
      setState(() => _goalDateRange = picked);
      return;
    }

    if (_goalPeriod == GoalPeriod.all) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10, 12, 31),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDay = picked;
      _visibleMonth = DateTime(picked.year, picked.month);
    });
    unawaited(_loadRoutineSchedule());
  }

  Future<void> _loadPlanningData() async {
    await Future.wait([
      _controller.loadEvents(),
      _goalsController.loadGoals(),
      _tasksController.loadTasks(),
      if (_routinesController != null) _routinesController!.load(),
    ]);
    await _loadRoutineSchedule(notify: false);

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadRoutineSchedule({bool notify = true}) async {
    final controller = _routinesController;
    if (controller == null) return;
    final requestedMonth = _visibleMonth;
    final days = _monthGridDays(requestedMonth);
    final schedule = await controller.scheduleBetween(
      startDate: days.first,
      endDate: days.last,
    );
    if (!mounted ||
        requestedMonth.year != _visibleMonth.year ||
        requestedMonth.month != _visibleMonth.month) {
      return;
    }
    if (notify) {
      setState(() => _routineSchedule = schedule);
    } else {
      _routineSchedule = schedule;
    }
  }

  Future<void> _showCreateGoalDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _CreateGoalDialog(
        selectedDay: _selectedDay,
        onSave: _saveGoalFromDialog,
      ),
    );
  }

  Future<void> _showCreateTaskDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _CreateTaskDialog(
        selectedDay: _selectedDay,
        goals: _goalsController.goalsForDay(_selectedDay),
        onSave: _saveTaskFromDialog,
      ),
    );
  }

  Future<void> _showScheduleExistingTaskDialog() async {
    final quickTasks = _tasksController.quickTasks();
    if (quickTasks.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              context.tr(
                'No hay tareas rápidas para programar.',
                'There are no quick tasks to schedule.',
              ),
            ),
          ),
        );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _ScheduleTaskDialog(
        selectedDay: _selectedDay,
        tasks: quickTasks,
        goals: _goalsController.goalsForDay(_selectedDay),
        onSave: _scheduleExistingTaskFromDialog,
      ),
    );
  }

  Future<void> _showEditTaskPlanningDialog(Task task) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _EditTaskPlanningDialog(
        task: task,
        goals: _goalsController.goalsForDay(_selectedDay),
        onSave: ({required goalId, required durationMinutes}) =>
            _updateTaskPlanningFromDialog(
              task: task,
              goalId: goalId,
              durationMinutes: durationMinutes,
            ),
        onUnschedule: () => _unscheduleTaskFromDialog(task),
      ),
    );
  }

  Future<void> _showEditGoalDialog(ProductivityGoal goal) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _EditCalendarGoalDialog(
        goal: goal,
        onSave:
            ({
              required rawTitle,
              required targetSessions,
              required targetDate,
            }) {
              return _updateGoalFromDialog(
                goal: goal,
                rawTitle: rawTitle,
                targetSessions: targetSessions,
                targetDate: targetDate,
              );
            },
      ),
    );
  }

  Future<String?> _saveGoalFromDialog(
    String rawTitle,
  ) async {
    final saved = await _goalsController.createGoal(
      rawTitle,
      1,
      targetDate: _selectedDay,
    );

    if (!saved) {
      return _goalsController.validationMessage.value;
    }

    if (mounted) {
      setState(() {});
    }

    return null;
  }

  Future<String?> _saveTaskFromDialog({
    required String rawTitle,
    required String? goalId,
    required int durationMinutes,
  }) async {
    final saved = await _tasksController.createPlannedTask(
      rawTitle: rawTitle,
      scheduledDate: _selectedDay,
      goalId: goalId,
      durationMinutes: durationMinutes,
    );

    if (!saved) {
      return _tasksController.validationMessage.value;
    }

    if (mounted) {
      setState(() {});
    }

    return null;
  }

  Future<String?> _scheduleExistingTaskFromDialog({
    required String taskId,
    required String? goalId,
  }) async {
    await _tasksController.moveTaskToDay(
      id: taskId,
      scheduledDate: _selectedDay,
      goalId: goalId,
    );

    if (mounted) {
      setState(() {});
    }

    return null;
  }

  Future<String?> _updateTaskPlanningFromDialog({
    required Task task,
    required String? goalId,
    required int durationMinutes,
  }) async {
    final saved = await _tasksController.updateTaskPlanning(
      id: task.id,
      goalId: goalId,
      durationMinutes: durationMinutes,
    );
    if (!saved) {
      return _tasksController.validationMessage.value;
    }

    if (mounted) {
      setState(() {});
    }

    return null;
  }

  Future<void> _unscheduleTaskFromDialog(Task task) async {
    await _tasksController.scheduleTask(task.id, null);
    await _tasksController.assignTaskToGoal(task.id, null);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updateTaskStatus(Task task, TaskStatus status) async {
    await _tasksController.updateTaskStatus(task.id, status);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _confirmDeleteTask(Task task) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.tr('Eliminar tarea', 'Delete task')),
          content: Text(
            context.tr(
              'Se eliminará "${task.title}" de este día.',
              '"${task.title}" will be removed from this day.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.tr('Cancelar', 'Cancel')),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(context.tr('Eliminar', 'Delete')),
            ),
          ],
        );
      },
    );

    if (delete ?? false) {
      await _tasksController.deleteTask(task.id);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<String?> _updateGoalFromDialog({
    required ProductivityGoal goal,
    required String rawTitle,
    required int targetSessions,
    required DateTime? targetDate,
  }) async {
    final saved = await _goalsController.updateGoalDetails(
      id: goal.id,
      rawTitle: rawTitle,
      targetSessions: targetSessions,
      targetDate: targetDate,
    );

    if (!saved) {
      return _goalsController.validationMessage.value;
    }

    if (mounted) {
      setState(() {});
    }

    return null;
  }

  Future<void> _confirmDeleteGoal(ProductivityGoal goal) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.tr('Eliminar objetivo', 'Delete goal')),
          content: Text(
            context.tr(
              'Se eliminará "${goal.title}" de este día.',
              '"${goal.title}" will be removed from this day.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.tr('Cancelar', 'Cancel')),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(context.tr('Eliminar', 'Delete')),
            ),
          ],
        );
      },
    );

    if (delete ?? false) {
      final affectedTasks = _tasksController.tasksForGoal(goal.id);
      await _tasksController.detachTasksFromGoal(goal.id);
      await _goalsController.deleteGoal(goal.id);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                context.tr(
                  'Objetivo eliminado: ${goal.title}',
                  'Goal deleted: ${goal.title}',
                ),
              ),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: context.tr('Deshacer', 'Undo'),
                onPressed: () {
                  unawaited(_restoreDeletedGoal(goal, affectedTasks));
                },
              ),
            ),
          );
      }
    }
  }

  Future<void> _restoreDeletedGoal(
    ProductivityGoal goal,
    List<Task> affectedTasks,
  ) async {
    await _goalsController.restoreDeletedGoal(goal);
    for (final task in affectedTasks) {
      await _tasksController.assignTaskToGoal(task.id, goal.id);
    }
    if (mounted) {
      setState(() {});
    }
  }
}

class _CreateGoalDialog extends StatefulWidget {
  const _CreateGoalDialog({
    required this.selectedDay,
    required this.onSave,
  });

  final DateTime selectedDay;
  final Future<String?> Function(String rawTitle) onSave;

  @override
  State<_CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<_CreateGoalDialog> {
  final TextEditingController _titleController = TextEditingController();
  String? _validationMessage;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    final validationMessage = await widget.onSave(
      _titleController.text,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        context.tr(
          'Objetivo para ${_formatShortDate(widget.selectedDay)}',
          'Goal for ${_formatShortDate(widget.selectedDay)}',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: context.tr('Objetivo', 'Goal'),
              errorText: _validationMessage,
              prefixIcon: const Icon(Icons.flag_rounded),
            ),
            onSubmitted: (_) => unawaited(_submit()),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.add_rounded),
          label: Text(context.tr('Crear', 'Create')),
        ),
      ],
    );
  }
}

class _EditCalendarGoalDialog extends StatefulWidget {
  const _EditCalendarGoalDialog({
    required this.goal,
    required this.onSave,
  });

  final ProductivityGoal goal;
  final Future<String?> Function({
    required String rawTitle,
    required int targetSessions,
    required DateTime? targetDate,
  })
  onSave;

  @override
  State<_EditCalendarGoalDialog> createState() =>
      _EditCalendarGoalDialogState();
}

class _EditCalendarGoalDialogState extends State<_EditCalendarGoalDialog> {
  late final TextEditingController _titleController;
  late int _targetSessions;
  late DateTime? _targetDate;
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

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    final validationMessage = await widget.onSave(
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

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10, 12, 31),
    );
    if (picked == null || !mounted) return;
    setState(() => _targetDate = picked);
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
            onSubmitted: (_) => unawaited(_submit()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSaving ? null : _pickTargetDate,
                  icon: const Icon(Icons.event_rounded),
                  label: Text(
                    _targetDate == null
                        ? context.tr('Elegir fecha', 'Choose date')
                        : _formatSelectedDay(context, _targetDate!),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (_targetDate != null) ...[
                const SizedBox(width: 8),
                IconButton.outlined(
                  tooltip: context.tr('Quitar fecha', 'Remove date'),
                  onPressed: _isSaving
                      ? null
                      : () => setState(() => _targetDate = null),
                  icon: const Icon(Icons.event_busy_rounded),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Meta Pomodoro', 'Pomodoro target'),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      context.tr(
                        'Sesiones necesarias para completarlo',
                        'Sessions needed to complete it',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton.outlined(
                tooltip: context.tr('Reducir meta', 'Decrease target'),
                onPressed: _isSaving || _targetSessions <= 1
                    ? null
                    : () => setState(() => _targetSessions -= 1),
                icon: const Icon(Icons.remove_rounded),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  '$_targetSessions',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton.outlined(
                tooltip: context.tr('Aumentar meta', 'Increase target'),
                onPressed: _isSaving || _targetSessions >= 24
                    ? null
                    : () => setState(() => _targetSessions += 1),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.check_rounded),
          label: Text(context.tr('Guardar', 'Save')),
        ),
      ],
    );
  }
}

class _CreateTaskDialog extends StatefulWidget {
  const _CreateTaskDialog({
    required this.selectedDay,
    required this.goals,
    required this.onSave,
  });

  final DateTime selectedDay;
  final List<ProductivityGoal> goals;
  final Future<String?> Function({
    required String rawTitle,
    required String? goalId,
    required int durationMinutes,
  })
  onSave;

  @override
  State<_CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<_CreateTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  int _durationMinutes = 25;
  String? _selectedGoalId;
  String? _validationMessage;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    final validationMessage = await widget.onSave(
      rawTitle: _titleController.text,
      goalId: _selectedGoalId,
      durationMinutes: _durationMinutes,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      scrollable: true,
      title: Text(context.tr('Crear nueva tarea', 'Create new task')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: context.tr('Tarea', 'Task'),
                errorText: _validationMessage,
                prefixIcon: const Icon(Icons.task_alt_rounded),
              ),
              onSubmitted: (_) => unawaited(_submit()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _durationMinutes,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.tr('Duración', 'Duration'),
                prefixIcon: const Icon(Icons.timer_outlined),
              ),
              items: const [25, 30, 45, 60, 90, 120]
                  .map(
                    (minutes) => DropdownMenuItem<int>(
                      value: minutes,
                      child: Text('$minutes min'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() => _durationMinutes = value);
              },
            ),
            if (widget.goals.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                value: _selectedGoalId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: context.tr('Objetivo', 'Goal'),
                  prefixIcon: const Icon(Icons.flag_rounded),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    child: Text(context.tr('Sin objetivo', 'No goal')),
                  ),
                  ...widget.goals.map(
                    (goal) => DropdownMenuItem<String?>(
                      value: goal.id,
                      child: Text(
                        goal.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedGoalId = value);
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.add_rounded),
          label: Text(context.tr('Crear', 'Create')),
        ),
      ],
    );
  }
}

class _ScheduleTaskDialog extends StatefulWidget {
  const _ScheduleTaskDialog({
    required this.selectedDay,
    required this.tasks,
    required this.goals,
    required this.onSave,
  });

  final DateTime selectedDay;
  final List<Task> tasks;
  final List<ProductivityGoal> goals;
  final Future<String?> Function({
    required String taskId,
    required String? goalId,
  })
  onSave;

  @override
  State<_ScheduleTaskDialog> createState() => _ScheduleTaskDialogState();
}

class _ScheduleTaskDialogState extends State<_ScheduleTaskDialog> {
  late String _selectedTaskId;
  String? _selectedGoalId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedTaskId = widget.tasks.first.id;
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    await widget.onSave(
      taskId: _selectedTaskId,
      goalId: _selectedGoalId,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(context.tr('Asignar tarea rápida', 'Assign quick task')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedTaskId,
            decoration: InputDecoration(
              labelText: context.tr('Tarea rápida', 'Quick task'),
              prefixIcon: const Icon(Icons.checklist_rounded),
            ),
            items: widget.tasks
                .map(
                  (task) => DropdownMenuItem<String>(
                    value: task.id,
                    child: Text(task.title),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() => _selectedTaskId = value);
            },
          ),
          if (widget.goals.isNotEmpty) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              value: _selectedGoalId,
              decoration: InputDecoration(
                labelText: context.tr('Objetivo', 'Goal'),
                prefixIcon: const Icon(Icons.flag_rounded),
              ),
              items: [
                DropdownMenuItem<String?>(
                  child: Text(context.tr('Sin objetivo', 'No goal')),
                ),
                ...widget.goals.map(
                  (goal) => DropdownMenuItem<String?>(
                    value: goal.id,
                    child: Text(goal.title),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedGoalId = value);
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.calendar_month_rounded),
          label: Text(context.tr('Asignar', 'Assign')),
        ),
      ],
    );
  }
}

class _EditTaskPlanningDialog extends StatefulWidget {
  const _EditTaskPlanningDialog({
    required this.task,
    required this.goals,
    required this.onSave,
    required this.onUnschedule,
  });

  final Task task;
  final List<ProductivityGoal> goals;
  final Future<String?> Function({
    required String? goalId,
    required int durationMinutes,
  })
  onSave;
  final Future<void> Function() onUnschedule;

  @override
  State<_EditTaskPlanningDialog> createState() =>
      _EditTaskPlanningDialogState();
}

class _EditTaskPlanningDialogState extends State<_EditTaskPlanningDialog> {
  late String? _selectedGoalId = widget.task.goalId;
  late final TextEditingController _durationController;
  String? _validationMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(
      text: '${widget.task.durationMinutes ?? 25}',
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    final durationMinutes = int.tryParse(_durationController.text.trim());
    if (durationMinutes == null ||
        durationMinutes <= 0 ||
        durationMinutes > 24 * 60) {
      setState(() {
        _validationMessage = context.tr(
          'Escribe una duración entre 1 y 1440 minutos.',
          'Enter a duration between 1 and 1440 minutes.',
        );
      });
      return;
    }

    setState(() => _isSaving = true);
    final validationMessage = await widget.onSave(
      goalId: _selectedGoalId,
      durationMinutes: durationMinutes,
    );

    if (!mounted) {
      return;
    }

    if (validationMessage != null) {
      setState(() {
        _isSaving = false;
        _validationMessage = context.localizeMessage(validationMessage);
      });
      return;
    }

    Navigator.of(context).pop();
  }

  Future<void> _unschedule() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    await widget.onUnschedule();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: Text(context.tr('Planificación de tarea', 'Task planning')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.task_alt_rounded),
              title: Text(widget.task.title),
              subtitle: Text(context.tr('Tarea planificada', 'Planned task')),
            ),
            DropdownButtonFormField<String?>(
              value: _selectedGoalId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.tr('Objetivo', 'Goal'),
                prefixIcon: const Icon(Icons.flag_rounded),
              ),
              items: [
                DropdownMenuItem<String?>(
                  child: Text(context.tr('Sin objetivo', 'No goal')),
                ),
                ...widget.goals.map(
                  (goal) => DropdownMenuItem<String?>(
                    value: goal.id,
                    child: Text(
                      goal.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: _isSaving
                  ? null
                  : (value) => setState(() => _selectedGoalId = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              enabled: !_isSaving,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: context.tr(
                  'Duración en minutos',
                  'Duration in minutes',
                ),
                prefixIcon: const Icon(Icons.timer_outlined),
                errorText: _validationMessage,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final minutes in const [25, 30, 45, 60, 90, 120])
                  ChoiceChip(
                    label: Text('$minutes min'),
                    selected: int.tryParse(_durationController.text) == minutes,
                    onSelected: _isSaving
                        ? null
                        : (_) {
                            setState(() {
                              _durationController.text = '$minutes';
                              _validationMessage = null;
                            });
                          },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : () => unawaited(_submit()),
                icon: const Icon(Icons.save_rounded),
                label: Text(context.tr('Guardar', 'Save')),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                child: Text(context.tr('Cancelar', 'Cancel')),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _isSaving ? null : () => unawaited(_unschedule()),
                icon: const Icon(Icons.event_busy_rounded),
                label: Text(context.tr('Quitar del día', 'Remove from day')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({
    required this.visibleMonth,
    required this.selectedDay,
    required this.plannedDays,
    required this.taskProgressByDay,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDaySelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDay;
  final Set<int> plannedDays;
  final Map<int, DailyTaskProgress> taskProgressByDay;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatMonth(context, visibleMonth),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppDesignTokens.sectionTitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _ArrowButton(
                icon: Icons.chevron_left_rounded,
                tooltip: context.tr('Mes anterior', 'Previous month'),
                onPressed: onPreviousMonth,
              ),
              const SizedBox(width: 8),
              _ArrowButton(
                icon: Icons.chevron_right_rounded,
                tooltip: context.tr('Mes siguiente', 'Next month'),
                onPressed: onNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _CalendarGrid(
            visibleMonth: visibleMonth,
            selectedDay: selectedDay,
            plannedDays: plannedDays,
            taskProgressByDay: taskProgressByDay,
            onDaySelected: onDaySelected,
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: IconButton.outlined(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.visibleMonth,
    required this.selectedDay,
    required this.plannedDays,
    required this.taskProgressByDay,
    required this.onDaySelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDay;
  final Set<int> plannedDays;
  final Map<int, DailyTaskProgress> taskProgressByDay;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final labels = context.l10n.localeName == 'en'
        ? const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        : const ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    final days = _monthGridDays(visibleMonth);

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.45,
          children: labels
              .map(
                (label) => Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 6,
            childAspectRatio: 0.86,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final day = days[index];
            final taskProgress = day.month == visibleMonth.month
                ? taskProgressByDay[day.day]
                : null;
            return _DayCell(
              day: day,
              muted: day.month != visibleMonth.month,
              selected: _sameDate(day, selectedDay),
              highlighted:
                  day.month == visibleMonth.month &&
                  plannedDays.contains(day.day),
              taskProgress: taskProgress,
              onTap: () => onDaySelected(day),
            );
          },
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.muted,
    required this.selected,
    required this.highlighted,
    required this.taskProgress,
    required this.onTap,
  });

  final DateTime day;
  final bool muted;
  final bool selected;
  final bool highlighted;
  final DailyTaskProgress? taskProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progress = taskProgress;
    final markerColor = progress == null
        ? palette.secondary
        : _calendarProgressColor(progress.band);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? palette.primaryMuted.withValues(alpha: 0.55)
              : palette.background.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? palette.primary : palette.neutralSoft,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 10,
              child: Text(
                '${day.day}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: muted
                      ? palette.neutral.withValues(alpha: 0.45)
                      : palette.textPrimary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (highlighted)
              Positioned(
                bottom: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: markerColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    if (progress?.isEnded ?? false) ...[
                      const SizedBox(height: 3),
                      Icon(
                        Icons.check_circle_rounded,
                        color: markerColor,
                        size: 10,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GoalPeriodCard extends StatelessWidget {
  const _GoalPeriodCard({
    required this.period,
    required this.periodLabel,
    required this.hasSelectedRange,
    required this.goals,
    required this.tasks,
    required this.onPeriodChanged,
    required this.onPrevious,
    required this.onNext,
    required this.onPickPeriod,
    required this.onEditGoal,
    required this.onDeleteGoal,
  });

  final GoalPeriod period;
  final String periodLabel;
  final bool hasSelectedRange;
  final List<ProductivityGoal> goals;
  final List<Task> tasks;
  final ValueChanged<GoalPeriod> onPeriodChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPickPeriod;
  final ValueChanged<ProductivityGoal> onEditGoal;
  final ValueChanged<ProductivityGoal> onDeleteGoal;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final canStep = period != GoalPeriod.all && period != GoalPeriod.range;

    return GlassCard(
      key: const ValueKey('goal-period-card'),
      padding: AppCardPaddings.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('Objetivos', 'Goals'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppDesignTokens.sectionTitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 34),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: palette.primaryMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${goals.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: palette.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            key: const ValueKey('goal-period-selector'),
            children: [
              SizedBox(
                width: double.infinity,
                child: _GoalPeriodSegment(
                  period: period,
                  values: const [
                    GoalPeriod.all,
                    GoalPeriod.day,
                    GoalPeriod.week,
                  ],
                  onChanged: onPeriodChanged,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: _GoalPeriodSegment(
                  period: period,
                  values: const [
                    GoalPeriod.month,
                    GoalPeriod.year,
                    GoalPeriod.range,
                  ],
                  onChanged: onPeriodChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (canStep)
                IconButton.outlined(
                  key: const ValueKey('previous-goal-period'),
                  tooltip: context.tr('Periodo anterior', 'Previous period'),
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
              if (canStep) const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('pick-goal-period'),
                  onPressed: period == GoalPeriod.all ? null : onPickPeriod,
                  icon: Icon(
                    period == GoalPeriod.range
                        ? Icons.date_range_rounded
                        : Icons.calendar_today_rounded,
                  ),
                  label: Text(
                    periodLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (canStep) const SizedBox(width: 8),
              if (canStep)
                IconButton.outlined(
                  key: const ValueKey('next-goal-period'),
                  tooltip: context.tr('Periodo siguiente', 'Next period'),
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (goals.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, color: palette.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      period == GoalPeriod.range && !hasSelectedRange
                          ? context.tr(
                              'Selecciona un rango de fechas.',
                              'Select a date range.',
                            )
                          : context.tr(
                              'No hay objetivos en este periodo.',
                              'There are no goals in this period.',
                            ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            for (var index = 0; index < goals.length; index++) ...[
              _PeriodGoalTile(
                goal: goals[index],
                summary: TaskStatusSummary.fromTasks(
                  tasks.where((task) => task.goalId == goals[index].id),
                ),
                onEdit: () => onEditGoal(goals[index]),
                onDelete: () => onDeleteGoal(goals[index]),
              ),
              if (index != goals.length - 1) const Divider(height: 20),
            ],
        ],
      ),
    );
  }
}

class _GoalPeriodSegment extends StatelessWidget {
  const _GoalPeriodSegment({
    required this.period,
    required this.values,
    required this.onChanged,
  });

  final GoalPeriod period;
  final List<GoalPeriod> values;
  final ValueChanged<GoalPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<GoalPeriod>(
      showSelectedIcon: false,
      emptySelectionAllowed: true,
      segments: [
        for (final value in values)
          ButtonSegment(
            value: value,
            label: Text(_goalPeriodName(context, value)),
          ),
      ],
      selected: values.contains(period) ? {period} : const {},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) onChanged(selection.first);
      },
    );
  }
}

class _PeriodGoalTile extends StatelessWidget {
  const _PeriodGoalTile({
    required this.goal,
    required this.summary,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductivityGoal goal;
  final TaskStatusSummary summary;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dateLabel = goal.targetDate == null
        ? context.tr('Sin fecha', 'No date')
        : _formatSelectedDay(context, goal.targetDate!);

    return Semantics(
      container: true,
      child: Row(
        key: ValueKey('period-goal-${goal.id}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.flag_rounded, color: palette.secondary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: summary.completionRatio,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(8),
                  color: palette.primary,
                  backgroundColor: palette.neutralSoft,
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr(
                    '${summary.completed}/${summary.total} tareas completadas',
                    '${summary.completed}/${summary.total} tasks completed',
                  ),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<_GoalDeadlineAction>(
            tooltip: context.tr('Opciones de objetivo', 'Goal options'),
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (action) {
              switch (action) {
                case _GoalDeadlineAction.edit:
                  onEdit();
                case _GoalDeadlineAction.delete:
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _GoalDeadlineAction.edit,
                child: ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: Text(context.tr('Editar objetivo', 'Edit goal')),
                ),
              ),
              PopupMenuItem(
                value: _GoalDeadlineAction.delete,
                child: ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: Text(context.tr('Eliminar objetivo', 'Delete goal')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.selectedDay,
    required this.goals,
    required this.tasks,
    required this.focusedSecondsByTask,
    required this.events,
    required this.routines,
    required this.isLoading,
    required this.onAddGoal,
    required this.onAddTask,
    required this.onScheduleTask,
    required this.onTaskStatusChanged,
    required this.onEditTaskPlanning,
    required this.onDeleteTask,
    required this.onStartTaskFocus,
    required this.onOpenRoutine,
  });

  final DateTime selectedDay;
  final List<ProductivityGoal> goals;
  final List<Task> tasks;
  final Map<String, int> focusedSecondsByTask;
  final List<CalendarEvent> events;
  final List<RoutineScheduleOccurrence> routines;
  final bool isLoading;
  final VoidCallback onAddGoal;
  final VoidCallback onAddTask;
  final VoidCallback onScheduleTask;
  final void Function(Task task, TaskStatus status) onTaskStatusChanged;
  final ValueChanged<Task> onEditTaskPlanning;
  final ValueChanged<Task> onDeleteTask;
  final ValueChanged<Task> onStartTaskFocus;
  final ValueChanged<RoutineScheduleOccurrence> onOpenRoutine;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _formatSelectedDay(context, selectedDay),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppDesignTokens.sectionTitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (tasks.isNotEmpty) ...[
                const SizedBox(width: 12),
                _TaskStatusSummaryMenu(tasks: tasks),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            context.tr(
              'Agenda local de planificación',
              'Local planning agenda',
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: onAddTask,
                icon: const Icon(Icons.add_task_rounded),
                label: Text(context.tr('Nueva tarea', 'New task')),
              ),
              MenuAnchor(
                builder: (context, controller, child) {
                  return IconButton.outlined(
                    tooltip: context.tr('Más acciones', 'More actions'),
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.more_horiz_rounded),
                  );
                },
                menuChildren: [
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.flag_rounded),
                    onPressed: onAddGoal,
                    child: Text(context.tr('Crear objetivo', 'Create goal')),
                  ),
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.playlist_add_check_rounded),
                    onPressed: onScheduleTask,
                    child: Text(
                      context.tr('Asignar tarea rápida', 'Assign quick task'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (events.isEmpty &&
              goals.isEmpty &&
              tasks.isEmpty &&
              routines.isEmpty)
            _EmptyAgenda(day: selectedDay)
          else ...[
            if (routines.isNotEmpty) ...[
              _AgendaSectionTitle(
                icon: Icons.event_repeat_rounded,
                label: context.tr('Rutinas', 'Routines'),
                count: routines.length,
              ),
              const SizedBox(height: 10),
              for (final routine in routines) ...[
                _RoutineOccurrenceTile(
                  occurrence: routine,
                  onOpen: () => onOpenRoutine(routine),
                ),
                const SizedBox(height: 12),
              ],
            ],
            if (tasks.isNotEmpty) ...[
              _AgendaSectionTitle(
                icon: Icons.task_alt_rounded,
                label: context.tr('Tareas del día', 'Tasks for the day'),
                count: tasks.length,
              ),
              const SizedBox(height: 10),
              for (final task in tasks) ...[
                _PlannedTaskTile(
                  task: task,
                  goal: _goalForTask(task, goals),
                  focusedSeconds: focusedSecondsByTask[task.id] ?? 0,
                  onStatusChanged: (status) =>
                      onTaskStatusChanged(task, status),
                  onEditPlanning: () => onEditTaskPlanning(task),
                  onDelete: () => onDeleteTask(task),
                  onStartFocus: () => onStartTaskFocus(task),
                ),
                const SizedBox(height: 12),
              ],
            ],
            for (final event in events) ...[
              _EventTile(event: event),
              if (event != events.last) const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

class _AgendaSectionTitle extends StatelessWidget {
  const _AgendaSectionTitle({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Icon(icon, color: palette.primary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          '$count',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: palette.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TaskStatusSummaryMenu extends StatelessWidget {
  const _TaskStatusSummaryMenu({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final summary = TaskStatusSummary.fromTasks(tasks);
    final palette = context.palette;

    return MenuAnchor(
      builder: (context, controller, child) {
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: palette.primaryMuted.withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: palette.primary.withValues(alpha: 0.24),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task_alt_rounded, color: palette.primary, size: 17),
                const SizedBox(width: 6),
                Text(
                  '${summary.completed}/${summary.total}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: palette.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: [
        _TaskStatusSummaryMenuItem(
          status: TaskStatus.listed,
          value: summary.listed,
        ),
        _TaskStatusSummaryMenuItem(
          status: TaskStatus.inProgress,
          value: summary.inProgress,
        ),
        _TaskStatusSummaryMenuItem(
          status: TaskStatus.completed,
          value: summary.completed,
        ),
      ],
    );
  }
}

class _TaskStatusSummaryMenuItem extends StatelessWidget {
  const _TaskStatusSummaryMenuItem({
    required this.status,
    required this.value,
  });

  final TaskStatus status;
  final int value;

  @override
  Widget build(BuildContext context) {
    final style = _taskStatusStyle(context, status);

    return MenuItemButton(
      onPressed: () {},
      leadingIcon: Icon(style.icon, color: style.color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_taskStatusLabel(context, status)),
          const SizedBox(width: 18),
          Container(
            width: 30,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$value',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: style.color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _GoalDeadlineAction { edit, delete }

class _PlannedTaskTile extends StatelessWidget {
  const _PlannedTaskTile({
    required this.task,
    required this.goal,
    required this.focusedSeconds,
    required this.onStatusChanged,
    required this.onEditPlanning,
    required this.onDelete,
    required this.onStartFocus,
  });

  final Task task;
  final ProductivityGoal? goal;
  final int focusedSeconds;
  final ValueChanged<TaskStatus> onStatusChanged;
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusStyle.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusStyle.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            statusStyle.icon,
            color: statusStyle.color,
            size: 22,
          ),
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
                    _Tag(
                      label: _taskStatusLabel(context, task.status),
                      color: statusStyle.color,
                      background: statusStyle.background,
                    ),
                    if (task.durationMinutes != null)
                      _Tag(label: '${task.durationMinutes} min'),
                    if (goal == null)
                      _Tag(label: context.tr('Sin objetivo', 'No goal'))
                    else
                      _Tag(label: goal!.title),
                  ],
                ),
                if (durationMinutes != null) ...[
                  const SizedBox(height: 12),
                  _TaskFocusProgress(
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
                  title: Text(
                    context.tr('Empezar Pomodoro', 'Start Pomodoro'),
                  ),
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

class _EmptyAgenda extends StatelessWidget {
  const _EmptyAgenda({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Text(
        context.tr(
          'Sin tareas planificadas para el ${day.day}.',
          'No tasks planned for day ${day.day}.',
        ),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
      ),
    );
  }
}

class _RoutineOccurrenceTile extends StatelessWidget {
  const _RoutineOccurrenceTile({
    required this.occurrence,
    required this.onOpen,
  });

  final RoutineScheduleOccurrence occurrence;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = switch (occurrence.status) {
      RoutineRunStatus.completed => palette.primary,
      RoutineRunStatus.inProgress => palette.secondary,
      RoutineRunStatus.skipped => palette.textSecondary,
      RoutineRunStatus.missed => palette.tertiary,
      RoutineRunStatus.scheduled => palette.primary,
    };
    return Container(
      key: ValueKey(
        'routine-occurrence-${occurrence.sourceRoutineId}-'
        '${occurrence.localDate.toIso8601String()}',
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: occurrence.isVirtual
            ? palette.primaryMuted.withValues(alpha: 0.18)
            : palette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: occurrence.hasOverlap
              ? palette.tertiary
              : color.withValues(alpha: 0.42),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.event_repeat_rounded, color: color, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  occurrence.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatMinute(context, occurrence.startMinute),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(
                      label: _routineOccurrenceStatus(context, occurrence),
                      color: color,
                      background: color.withValues(alpha: 0.12),
                    ),
                    _Tag(
                      label:
                          '${occurrence.completedRequiredItems}/'
                          '${occurrence.totalRequiredItems}',
                    ),
                    if (occurrence.isVirtual)
                      _Tag(
                        label: context.tr('Proyección', 'Projection'),
                        color: palette.textSecondary,
                        background: palette.neutralSoft.withValues(alpha: 0.5),
                      ),
                    if (occurrence.skippedOptionalItems > 0)
                      _Tag(
                        label: context.tr(
                          '${occurrence.skippedOptionalItems} opcional omitida',
                          '${occurrence.skippedOptionalItems} optional skipped',
                        ),
                        color: palette.textSecondary,
                        background: palette.neutralSoft.withValues(alpha: 0.5),
                      ),
                    if (occurrence.missedRequiredItems > 0)
                      _Tag(
                        label: context.tr(
                          '${occurrence.missedRequiredItems} pendiente perdida',
                          '${occurrence.missedRequiredItems} required missed',
                        ),
                        color: palette.tertiary,
                        background: palette.accentPeach.withValues(alpha: 0.5),
                      ),
                    if (occurrence.hasOverlap)
                      _Tag(
                        label: context.tr(
                          'Horario superpuesto',
                          'Time overlap',
                        ),
                        color: palette.tertiary,
                        background: palette.accentPeach.withValues(alpha: 0.5),
                      ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.tr('Ver rutina', 'View routine'),
            onPressed: onOpen,
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}

String _routineOccurrenceStatus(
  BuildContext context,
  RoutineScheduleOccurrence occurrence,
) => switch (occurrence.status) {
  RoutineRunStatus.scheduled => context.tr('Pendiente', 'Pending'),
  RoutineRunStatus.inProgress => context.tr('En progreso', 'In progress'),
  RoutineRunStatus.completed => context.tr('Completada', 'Completed'),
  RoutineRunStatus.skipped => context.tr('Omitida', 'Skipped'),
  RoutineRunStatus.missed => context.tr('Perdida', 'Missed'),
};

String _formatMinute(BuildContext context, int minute) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
    );

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.event_available_rounded, color: palette.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeRange(event),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                _Tag(label: '${event.durationMinutes} min'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    this.color,
    this.background,
  });

  final String label;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = color ?? palette.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? palette.primaryMuted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }
}

List<DateTime> _monthGridDays(DateTime month) {
  final firstDay = DateTime(month.year, month.month);
  final start = firstDay.subtract(Duration(days: firstDay.weekday % 7));

  return List.generate(42, (index) => start.add(Duration(days: index)));
}

bool _sameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _goalPeriodLabel(
  BuildContext context, {
  required GoalPeriod period,
  required DateTime referenceDay,
  required DateTimeRange? customRange,
}) {
  final weekStart = referenceDay.subtract(
    Duration(days: referenceDay.weekday - 1),
  );
  final weekEnd = weekStart.add(const Duration(days: 6));
  return switch (period) {
    GoalPeriod.all => context.tr('Todos los objetivos', 'All goals'),
    GoalPeriod.day => _formatSelectedDay(context, referenceDay),
    GoalPeriod.week =>
      '${_formatShortDate(weekStart)} - '
          '${_formatShortDate(weekEnd)}',
    GoalPeriod.month => _formatMonth(context, referenceDay),
    GoalPeriod.year => '${referenceDay.year}',
    GoalPeriod.range =>
      customRange == null
          ? context.tr('Seleccionar rango', 'Select range')
          : '${_formatShortDate(customRange.start)} - '
                '${_formatShortDate(customRange.end)}',
  };
}

String _goalPeriodName(BuildContext context, GoalPeriod period) {
  return switch (period) {
    GoalPeriod.all => context.tr('Todos', 'All'),
    GoalPeriod.day => context.tr('Día', 'Day'),
    GoalPeriod.week => context.tr('Semana', 'Week'),
    GoalPeriod.month => context.tr('Mes', 'Month'),
    GoalPeriod.year => context.tr('Año', 'Year'),
    GoalPeriod.range => context.tr('Rango', 'Range'),
  };
}

DateTime _shiftMonth(DateTime date, int delta) {
  final targetMonth = DateTime(date.year, date.month + delta);
  final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
  return DateTime(
    targetMonth.year,
    targetMonth.month,
    date.day.clamp(1, lastDay),
  );
}

DateTime _shiftYear(DateTime date, int delta) {
  final year = date.year + delta;
  final lastDay = DateTime(year, date.month + 1, 0).day;
  return DateTime(year, date.month, date.day.clamp(1, lastDay));
}

String _formatMonth(BuildContext context, DateTime date) {
  final months = context.l10n.localeName == 'en'
      ? _monthNamesEnglish
      : _monthNamesSpanish;
  return '${months[date.month - 1]} ${date.year}';
}

String _formatSelectedDay(BuildContext context, DateTime date) {
  final isEnglish = context.l10n.localeName == 'en';
  final weekdays = isEnglish ? _weekdayNamesEnglish : _weekdayNamesSpanish;
  final months = isEnglish ? _monthNamesEnglish : _monthNamesSpanish;
  return isEnglish
      ? '${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}'
      : '${weekdays[date.weekday % 7]} ${date.day} de ${months[date.month - 1]}';
}

String _formatTimeRange(CalendarEvent event) {
  return '${_formatClock(event.scheduledAt)} - ${_formatClock(event.endsAt)}';
}

String _formatClock(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String _formatShortDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
}

ProductivityGoal? _goalForTask(Task task, List<ProductivityGoal> goals) {
  for (final goal in goals) {
    if (goal.id == task.goalId) {
      return goal;
    }
  }

  return null;
}

Map<String, int> _focusedSecondsByTask(List<PomodoroSession> sessions) {
  final focusedSecondsByTask = <String, int>{};
  for (final session in sessions) {
    final taskId = session.taskId;
    if (taskId == null) {
      continue;
    }

    focusedSecondsByTask.update(
      taskId,
      (value) => value + session.focusedSeconds,
      ifAbsent: () => session.focusedSeconds,
    );
  }

  return focusedSecondsByTask;
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

Color _calendarProgressColor(TaskProgressBand band) {
  return switch (band) {
    TaskProgressBand.red => const Color(0xFFE05252),
    TaskProgressBand.yellow => const Color(0xFFE3B341),
    TaskProgressBand.green => const Color(0xFF5EAD68),
    TaskProgressBand.strongGreen => const Color(0xFF188E53),
  };
}

const _monthNamesSpanish = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

const _monthNamesEnglish = [
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

const _weekdayNamesSpanish = [
  'Domingo',
  'Lunes',
  'Martes',
  'Miercoles',
  'Jueves',
  'Viernes',
  'Sabado',
];

const _weekdayNamesEnglish = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];
