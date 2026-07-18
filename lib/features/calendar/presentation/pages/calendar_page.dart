import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/start_task_focus_flow.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    this.controller,
    this.goalsController,
    this.tasksController,
    this.pomodoroController,
  });

  static const routePath = '/calendar';

  final CalendarController? controller;
  final GoalsController? goalsController;
  final TasksController? tasksController;
  final PomodoroController? pomodoroController;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final CalendarController _controller;
  late final GoalsController _goalsController;
  late final TasksController _tasksController;
  late final PomodoroController _pomodoroController;
  late DateTime _visibleMonth;
  late DateTime _selectedDay;
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
    final plannedDays = {
      ..._controller.plannedDaysForMonth(_visibleMonth),
      ..._goalsController.plannedDaysForMonth(_visibleMonth),
      ..._tasksController.plannedDaysForMonth(_visibleMonth),
    };
    final taskProgressByDay = _tasksController.progressByDayForMonth(
      _visibleMonth,
    );

    return ListView(
      padding: AppCardPaddings.pageWithTop,
      children: [
        Text(
          'Calendario',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppDesignTokens.mainTitleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Planifica tus bloques de enfoque sin salir del modo offline.',
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
          },
          onDaySelected: (day) {
            setState(() => _selectedDay = day);
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
              isLoading: _isLoading,
              onAddGoal: _showCreateGoalDialog,
              onAddTask: _showCreateTaskDialog,
              onScheduleTask: _showScheduleExistingTaskDialog,
              onTaskStatusChanged: _updateTaskStatus,
              onEditTaskPlanning: _showEditTaskPlanningDialog,
              onDeleteTask: _confirmDeleteTask,
              onStartTaskFocus: (task) => startTaskFocusFlow(
                context: context,
                task: task,
              ),
              onEditGoal: _showEditGoalDialog,
              onDeleteGoal: _confirmDeleteGoal,
            );
          },
        ),
      ],
    );
  }

  Future<void> _loadPlanningData() async {
    await Future.wait([
      _controller.loadEvents(),
      _goalsController.loadGoals(),
      _tasksController.loadTasks(),
    ]);

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);
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
          const SnackBar(
            content: Text('No hay tareas rapidas para programar.'),
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
        onSave: (goalId) => _updateTaskPlanningFromDialog(
          task: task,
          goalId: goalId,
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
        selectedDay: _selectedDay,
        onSave: (rawTitle) {
          return _updateGoalFromDialog(
            goal: goal,
            rawTitle: rawTitle,
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
  }) async {
    await _tasksController.assignTaskToGoal(task.id, goalId);

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
          title: const Text('Eliminar tarea'),
          content: Text('Se eliminara "${task.title}" de este dia.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Eliminar'),
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
  }) async {
    final saved = await _goalsController.updateGoalDetails(
      id: goal.id,
      rawTitle: rawTitle,
      targetSessions: goal.targetSessions,
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

  Future<void> _confirmDeleteGoal(ProductivityGoal goal) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar objetivo'),
          content: Text('Se eliminara "${goal.title}" de este dia.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Eliminar'),
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
              content: Text('Objetivo eliminado: ${goal.title}'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Deshacer',
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
        _validationMessage = validationMessage;
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
      title: Text('Objetivo para ${_formatShortDate(widget.selectedDay)}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Objetivo',
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
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Crear'),
        ),
      ],
    );
  }
}

class _EditCalendarGoalDialog extends StatefulWidget {
  const _EditCalendarGoalDialog({
    required this.goal,
    required this.selectedDay,
    required this.onSave,
  });

  final ProductivityGoal goal;
  final DateTime selectedDay;
  final Future<String?> Function(String rawTitle) onSave;

  @override
  State<_EditCalendarGoalDialog> createState() =>
      _EditCalendarGoalDialogState();
}

class _EditCalendarGoalDialogState extends State<_EditCalendarGoalDialog> {
  late final TextEditingController _titleController;
  String? _validationMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
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
      _titleController.text,
    );

    if (!mounted) {
      return;
    }

    if (validationMessage != null) {
      setState(() {
        _validationMessage = validationMessage;
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
        'Editar objetivo de ${_formatShortDate(widget.selectedDay)}',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Objetivo',
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
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Guardar'),
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
        _validationMessage = validationMessage;
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
      title: const Text('Crear nueva tarea'),
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
                labelText: 'Tarea',
                errorText: _validationMessage,
                prefixIcon: const Icon(Icons.task_alt_rounded),
              ),
              onSubmitted: (_) => unawaited(_submit()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _durationMinutes,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Duracion',
                prefixIcon: Icon(Icons.timer_outlined),
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
                decoration: const InputDecoration(
                  labelText: 'Objetivo',
                  prefixIcon: Icon(Icons.flag_rounded),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    child: Text('Sin objetivo'),
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
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Crear'),
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
      title: const Text('Asignar tarea rapida'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedTaskId,
            decoration: const InputDecoration(
              labelText: 'Tarea rapida',
              prefixIcon: Icon(Icons.checklist_rounded),
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
              decoration: const InputDecoration(
                labelText: 'Objetivo',
                prefixIcon: Icon(Icons.flag_rounded),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  child: Text('Sin objetivo'),
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
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.calendar_month_rounded),
          label: const Text('Asignar'),
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
  final Future<String?> Function(String? goalId) onSave;
  final Future<void> Function() onUnschedule;

  @override
  State<_EditTaskPlanningDialog> createState() =>
      _EditTaskPlanningDialogState();
}

class _EditTaskPlanningDialogState extends State<_EditTaskPlanningDialog> {
  late String? _selectedGoalId = widget.task.goalId;
  bool _isSaving = false;

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    await widget.onSave(_selectedGoalId);

    if (!mounted) {
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
      title: const Text('Planificacion de tarea'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.task_alt_rounded),
            title: Text(widget.task.title),
            subtitle: const Text('Tarea planificada'),
          ),
          DropdownButtonFormField<String?>(
            value: _selectedGoalId,
            decoration: const InputDecoration(
              labelText: 'Objetivo',
              prefixIcon: Icon(Icons.flag_rounded),
            ),
            items: [
              const DropdownMenuItem<String?>(
                child: Text('Sin objetivo'),
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
      ),
      actions: [
        TextButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_unschedule()),
          icon: const Icon(Icons.event_busy_rounded),
          label: const Text('Quitar del dia'),
        ),
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : () => unawaited(_submit()),
          icon: const Icon(Icons.save_rounded),
          label: const Text('Guardar'),
        ),
      ],
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
                  _formatMonth(visibleMonth),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppDesignTokens.sectionTitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _ArrowButton(
                icon: Icons.chevron_left_rounded,
                tooltip: 'Mes anterior',
                onPressed: onPreviousMonth,
              ),
              const SizedBox(width: 8),
              _ArrowButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Mes siguiente',
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
    const labels = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'];
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

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.selectedDay,
    required this.goals,
    required this.tasks,
    required this.focusedSecondsByTask,
    required this.events,
    required this.isLoading,
    required this.onAddGoal,
    required this.onAddTask,
    required this.onScheduleTask,
    required this.onTaskStatusChanged,
    required this.onEditTaskPlanning,
    required this.onDeleteTask,
    required this.onStartTaskFocus,
    required this.onEditGoal,
    required this.onDeleteGoal,
  });

  final DateTime selectedDay;
  final List<ProductivityGoal> goals;
  final List<Task> tasks;
  final Map<String, int> focusedSecondsByTask;
  final List<CalendarEvent> events;
  final bool isLoading;
  final VoidCallback onAddGoal;
  final VoidCallback onAddTask;
  final VoidCallback onScheduleTask;
  final void Function(Task task, TaskStatus status) onTaskStatusChanged;
  final ValueChanged<Task> onEditTaskPlanning;
  final ValueChanged<Task> onDeleteTask;
  final ValueChanged<Task> onStartTaskFocus;
  final ValueChanged<ProductivityGoal> onEditGoal;
  final ValueChanged<ProductivityGoal> onDeleteGoal;

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
                  _formatSelectedDay(selectedDay),
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
            'Agenda local de planificacion',
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
                label: const Text('Nueva tarea'),
              ),
              MenuAnchor(
                builder: (context, controller, child) {
                  return IconButton.outlined(
                    tooltip: 'Mas acciones',
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
                    child: const Text('Crear objetivo'),
                  ),
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.playlist_add_check_rounded),
                    onPressed: onScheduleTask,
                    child: const Text('Asignar tarea rapida'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (events.isEmpty && goals.isEmpty && tasks.isEmpty)
            _EmptyAgenda(day: selectedDay)
          else ...[
            for (final goal in goals) ...[
              _GoalDeadlineTile(
                goal: goal,
                onEdit: () => onEditGoal(goal),
                onDelete: () => onDeleteGoal(goal),
              ),
              const SizedBox(height: 12),
            ],
            if (tasks.isNotEmpty) ...[
              _AgendaSectionTitle(
                icon: Icons.task_alt_rounded,
                label: 'Tareas del dia',
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
          Text(_taskStatusLabel(status)),
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

class _GoalDeadlineTile extends StatelessWidget {
  const _GoalDeadlineTile({
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductivityGoal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
          Icon(Icons.flag_rounded, color: palette.secondary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                const _Tag(label: 'Objetivo'),
              ],
            ),
          ),
          PopupMenuButton<_GoalDeadlineAction>(
            tooltip: 'Opciones de objetivo',
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (action) {
              switch (action) {
                case _GoalDeadlineAction.edit:
                  onEdit();
                case _GoalDeadlineAction.delete:
                  onDelete();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _GoalDeadlineAction.edit,
                child: ListTile(
                  leading: Icon(Icons.edit_rounded),
                  title: Text('Editar objetivo'),
                ),
              ),
              PopupMenuItem(
                value: _GoalDeadlineAction.delete,
                child: ListTile(
                  leading: Icon(Icons.delete_outline_rounded),
                  title: Text('Eliminar objetivo'),
                ),
              ),
            ],
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
                      label: _taskStatusLabel(task.status),
                      color: statusStyle.color,
                      background: statusStyle.background,
                    ),
                    if (task.durationMinutes != null)
                      _Tag(label: '${task.durationMinutes} min'),
                    if (goal == null)
                      const _Tag(label: 'Sin objetivo')
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
            tooltip: 'Opciones de tarea',
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
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _PlannedTaskAction.startFocus,
                child: ListTile(
                  leading: Icon(Icons.play_arrow_rounded),
                  title: Text('Empezar Pomodoro'),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.editPlanning,
                child: ListTile(
                  leading: Icon(Icons.edit_calendar_rounded),
                  title: Text('Editar planificacion'),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.markListed,
                child: ListTile(
                  leading: Icon(Icons.radio_button_unchecked_rounded),
                  title: Text('Marcar pendiente'),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.markInProgress,
                child: ListTile(
                  leading: Icon(Icons.timelapse_rounded),
                  title: Text('Marcar en progreso'),
                ),
              ),
              PopupMenuItem(
                value: _PlannedTaskAction.markCompleted,
                child: ListTile(
                  leading: Icon(Icons.check_circle_rounded),
                  title: Text('Marcar completada'),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _PlannedTaskAction.deleteTask,
                child: ListTile(
                  leading: Icon(Icons.delete_outline_rounded),
                  title: Text('Eliminar tarea'),
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
        'Sin tareas planificadas para el ${day.day}.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
      ),
    );
  }
}

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

String _formatMonth(DateTime date) {
  return '${_monthNames[date.month - 1]} ${date.year}';
}

String _formatSelectedDay(DateTime date) {
  return '${_weekdayNames[date.weekday % 7]} ${date.day} de ${_monthNames[date.month - 1]}';
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

String _taskStatusLabel(TaskStatus status) {
  return switch (status) {
    TaskStatus.listed => 'Pendiente',
    TaskStatus.inProgress => 'En progreso',
    TaskStatus.completed => 'Completada',
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

const _monthNames = [
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

const _weekdayNames = [
  'Domingo',
  'Lunes',
  'Martes',
  'Miercoles',
  'Jueves',
  'Viernes',
  'Sabado',
];
