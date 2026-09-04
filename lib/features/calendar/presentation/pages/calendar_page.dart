import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_document.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_file.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/weekly_schedule_exporter.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/widgets/goal_date_range_dialog.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/widgets/weekly_schedule_card.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/models/goal_period_filter.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/controllers/quick_notes_controller.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/widgets/planning_quick_notes_card.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/models/routine_schedule_projection.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/pages/routine_editor_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:pomodoro_app_v1/shared/molecules/speech_dictation_button.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum _PlanningCalendarView { month, week }

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    this.controller,
    this.goalsController,
    this.tasksController,
    this.pomodoroController,
    this.quickNotesController,
    this.routinesController,
    this.weeklyScheduleExporter,
    this.initialGoalId,
    this.initialTaskId,
  });

  static const routePath = '/calendar';

  final CalendarController? controller;
  final GoalsController? goalsController;
  final TasksController? tasksController;
  final PomodoroController? pomodoroController;
  final QuickNotesController? quickNotesController;
  final RoutinesController? routinesController;
  final WeeklyScheduleExporter? weeklyScheduleExporter;
  final String? initialGoalId;
  final String? initialTaskId;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final CalendarController _controller;
  late final GoalsController _goalsController;
  late final TasksController _tasksController;
  QuickNotesController? _quickNotesController;
  WeeklyScheduleExporter? _weeklyScheduleExporter;
  RoutinesController? _routinesController;
  late DateTime _visibleMonth;
  late DateTime _selectedDay;
  GoalPeriod _goalPeriod = GoalPeriod.all;
  DateTimeRange? _goalDateRange;
  _PlanningCalendarView _planningView = _PlanningCalendarView.month;
  List<RoutineScheduleOccurrence> _routineSchedule = const [];
  List<RoutineScheduleActivity> _routineActivities = const [];
  int _scheduleRequestId = 0;
  bool _isLoading = true;
  bool _isExportingWeek = false;
  String? _expandedGoalId;
  String? _highlightedTaskId;
  final Map<String, GlobalKey> _goalKeys = {};

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? serviceLocator<CalendarController>();
    _goalsController =
        widget.goalsController ?? serviceLocator<GoalsController>();
    _tasksController =
        widget.tasksController ?? serviceLocator<TasksController>();
    _quickNotesController =
        widget.quickNotesController ??
        (serviceLocator.isRegistered<QuickNotesController>()
            ? serviceLocator<QuickNotesController>()
            : null);
    _weeklyScheduleExporter =
        widget.weeklyScheduleExporter ??
        (serviceLocator.isRegistered<WeeklyScheduleExporter>()
            ? serviceLocator<WeeklyScheduleExporter>()
            : null);
    _routinesController =
        widget.routinesController ??
        (serviceLocator.isRegistered<RoutinesController>()
            ? serviceLocator<RoutinesController>()
            : null);
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
    _expandedGoalId = widget.initialGoalId;
    _highlightedTaskId = widget.initialTaskId;
    if (widget.initialGoalId != null) {
      _goalPeriod = GoalPeriod.all;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadPlanningData());
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return RefreshIndicator(
      onRefresh: _refreshPlanningData,
      child: ListView(
        key: const PageStorageKey('goals-scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
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
              'Organiza objetivos, fechas y actividades en un solo lugar.',
              'Organize goals, dates, and activities in one place.',
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<_PlanningCalendarView>(
              key: const ValueKey('planning-view-selector'),
              segments: [
                ButtonSegment(
                  value: _PlanningCalendarView.month,
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(context.tr('Mes', 'Month')),
                ),
                ButtonSegment(
                  value: _PlanningCalendarView.week,
                  icon: const Icon(Icons.view_week_rounded),
                  label: Text(context.tr('Semana', 'Week')),
                ),
              ],
              selected: {_planningView},
              showSelectedIcon: false,
              onSelectionChanged: (selection) {
                _changePlanningView(selection.single);
              },
            ),
          ),
          const SizedBox(height: 18),
          if (_planningView == _PlanningCalendarView.month)
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
            )
          else
            SignalBuilder(
              builder: (context) => WeeklyScheduleCard(
                weekStart: _mondayOf(_selectedDay),
                selectedDay: _selectedDay,
                goals: _goalsController.goals.value,
                tasks: _tasksController.tasks.value,
                activities: _routineActivities,
                isLoading: _isLoading,
                isExporting: _isExportingWeek,
                onPreviousWeek: () => _shiftWeek(-1),
                onCurrentWeek: _goToCurrentWeek,
                onNextWeek: () => _shiftWeek(1),
                onDaySelected: (day) {
                  setState(() {
                    _selectedDay = day;
                    _visibleMonth = DateTime(day.year, day.month);
                  });
                },
                onOpenRoutine: (activity) {
                  unawaited(_openRoutine(activity.sourceRoutineId));
                },
                onExportPdf: () => unawaited(_exportWeeklySchedule()),
              ),
            ),
          const SizedBox(height: 18),
          SignalBuilder(
            builder: (context) {
              final controller = _quickNotesController;
              if (controller == null) return const SizedBox.shrink();
              final notes = controller.notesForDay(_selectedDay);
              if (notes.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: PlanningQuickNotesCard(
                  notes: notes,
                  onToggle: controller.toggle,
                ),
              );
            },
          ),
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
                expandedGoalId: _expandedGoalId,
                highlightedTaskId: _highlightedTaskId,
                goalKeyFor: (goalId) =>
                    _goalKeys.putIfAbsent(goalId, GlobalKey.new),
                onAddTask: _showCreateTaskDialog,
                onAddGoal: _showCreateGoalDialog,
                onGoalToggle: (goalId) {
                  setState(() {
                    _expandedGoalId = _expandedGoalId == goalId ? null : goalId;
                    if (_expandedGoalId != goalId) {
                      _highlightedTaskId = null;
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _changePlanningView(_PlanningCalendarView view) {
    if (view == _planningView) return;
    setState(() => _planningView = view);
    unawaited(_loadRoutineSchedule());
  }

  void _shiftWeek(int direction) {
    final shifted = _selectedDay.add(Duration(days: 7 * direction));
    setState(() {
      _selectedDay = shifted;
      _visibleMonth = DateTime(shifted.year, shifted.month);
    });
    unawaited(_loadRoutineSchedule());
  }

  void _goToCurrentWeek() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _selectedDay = today;
      _visibleMonth = DateTime(today.year, today.month);
    });
    unawaited(_loadRoutineSchedule());
  }

  Future<void> _openRoutine(String routineId) async {
    await context.push('${RoutineEditorPage.routePath}?id=$routineId');
    if (!mounted) return;
    await _routinesController?.load(day: _selectedDay);
    await _loadRoutineSchedule();
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
      if (_quickNotesController != null) _quickNotesController!.load(),
      if (_routinesController != null) _routinesController!.load(),
    ]);
    await _loadRoutineSchedule(notify: false);

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);
    if (widget.initialGoalId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealGoal());
    }
  }

  Future<void> _refreshPlanningData() async {
    await refreshApplicationData();
    await _loadRoutineSchedule();
  }

  void _revealGoal() {
    if (!mounted) return;
    final goalId = widget.initialGoalId;
    if (goalId == null || _goalsController.goalById(goalId) == null) return;

    final targetContext = _goalKeys[goalId]?.currentContext;
    if (targetContext == null) return;
    unawaited(
      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.18,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Future<void> _loadRoutineSchedule({bool notify = true}) async {
    final controller = _routinesController;
    if (controller == null) return;
    final requestId = ++_scheduleRequestId;
    final requestedView = _planningView;
    final requestedMonth = _visibleMonth;
    final requestedWeek = _mondayOf(_selectedDay);
    final monthDays = _monthGridDays(requestedMonth);
    final startDate = requestedView == _PlanningCalendarView.month
        ? monthDays.first
        : requestedWeek;
    final endDate = requestedView == _PlanningCalendarView.month
        ? monthDays.last
        : requestedWeek.add(const Duration(days: 6));
    final projection = await controller.scheduleProjectionBetween(
      startDate: startDate,
      endDate: endDate,
    );
    if (!mounted ||
        requestId != _scheduleRequestId ||
        requestedView != _planningView ||
        (requestedView == _PlanningCalendarView.month &&
            (requestedMonth.year != _visibleMonth.year ||
                requestedMonth.month != _visibleMonth.month)) ||
        (requestedView == _PlanningCalendarView.week &&
            !_sameDate(requestedWeek, _mondayOf(_selectedDay)))) {
      return;
    }
    if (notify) {
      setState(() {
        _routineSchedule = projection.occurrences;
        _routineActivities = projection.activities;
      });
    } else {
      _routineSchedule = projection.occurrences;
      _routineActivities = projection.activities;
    }
  }

  Future<void> _exportWeeklySchedule() async {
    final exporter = _weeklyScheduleExporter;
    if (exporter == null) return;
    if (_isExportingWeek || _isLoading) return;
    final weekStart = _mondayOf(_selectedDay);
    final weekEnd = weekStart.add(const Duration(days: 6));
    final tasks = _tasksController.tasks.value;
    final goals = _goalsController.goals.value
        .where(
          (goal) =>
              goal.targetDate != null &&
              !_dateOnly(goal.targetDate!).isBefore(weekStart) &&
              !_dateOnly(goal.targetDate!).isAfter(weekEnd),
        )
        .map((goal) {
          final relatedTasks = tasks
              .where((task) => task.goalId == goal.id)
              .toList(growable: false);
          return WeeklyScheduleExportGoal(
            targetDate: goal.targetDate!,
            title: goal.title,
            completedTasks: relatedTasks
                .where((task) => task.isCompleted)
                .length,
            totalTasks: relatedTasks.length,
          );
        })
        .toList(growable: false);
    final document = WeeklyScheduleExportDocument(
      weekStart: weekStart,
      generatedAt: DateTime.now(),
      isEnglish: Localizations.localeOf(context).languageCode == 'en',
      activities: _routineActivities
          .map(
            (activity) => WeeklyScheduleExportActivity(
              localDate: activity.localDate,
              routineName: activity.routineName,
              title: activity.title,
              startMinute: activity.startMinute,
              durationMinutes: activity.durationMinutes,
              statusLabel: _routineRunStatusLabel(context, activity.status),
              colorKey: activity.colorKey,
              customColorArgb: activity.customColorArgb,
              hasOverlap: activity.hasOverlap,
            ),
          )
          .toList(growable: false),
      goals: goals,
    );

    setState(() => _isExportingWeek = true);
    try {
      final file = await exporter.export(document);
      if (!mounted) return;
      if (file == null) {
        _showWeeklyExportMessage(
          context.tr('Exportación cancelada.', 'Export canceled.'),
        );
        return;
      }
      _showWeeklyExportMessage(
        context.tr(
          'PDF guardado en: ${file.displayPath}',
          'PDF saved to: ${file.displayPath}',
        ),
        file: file,
      );
    } on Object {
      if (!mounted) return;
      _showWeeklyExportMessage(
        context.tr(
          'No se pudo guardar el PDF. Inténtalo nuevamente.',
          'The PDF could not be saved. Please try again.',
        ),
      );
    } finally {
      if (mounted) setState(() => _isExportingWeek = false);
    }
  }

  void _showWeeklyExportMessage(
    String message, {
    WeeklyScheduleExportFile? file,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: file == null
              ? null
              : SnackBarAction(
                  label: context.tr('Abrir', 'Open'),
                  onPressed: () {
                    unawaited(_openWeeklySchedulePdf(file));
                  },
                ),
        ),
      );
  }

  Future<void> _openWeeklySchedulePdf(
    WeeklyScheduleExportFile file,
  ) async {
    final exporter = _weeklyScheduleExporter;
    if (exporter == null) return;
    try {
      await exporter.open(file);
    } on Object {
      if (!mounted) return;
      _showWeeklyExportMessage(
        context.tr(
          'No se encontró una aplicación para abrir el PDF.',
          'No application was found to open the PDF.',
        ),
      );
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
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: context.tr('Objetivo', 'Goal'),
              errorText: _validationMessage,
              prefixIcon: const Icon(Icons.flag_rounded),
              suffixIcon: SpeechDictationFieldActions(
                fieldId: 'calendar-goal-create-title',
                textController: _titleController,
                onChanged: (_) {
                  if (_validationMessage != null) {
                    setState(() => _validationMessage = null);
                  }
                },
              ),
            ),
            onChanged: (_) {
              if (_validationMessage != null) {
                setState(() => _validationMessage = null);
              }
            },
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
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: context.tr('Objetivo', 'Goal'),
              errorText: _validationMessage,
              prefixIcon: const Icon(Icons.flag_rounded),
              suffixIcon: SpeechDictationFieldActions(
                fieldId: 'calendar-goal-edit-title',
                textController: _titleController,
                onChanged: (_) {
                  if (_validationMessage != null) {
                    setState(() => _validationMessage = null);
                  }
                },
              ),
            ),
            onChanged: (_) {
              if (_validationMessage != null) {
                setState(() => _validationMessage = null);
              }
            },
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
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: context.tr('Tarea', 'Task'),
                errorText: _validationMessage,
                prefixIcon: const Icon(Icons.task_alt_rounded),
                suffixIcon: SpeechDictationFieldActions(
                  fieldId: 'calendar-task-create-title',
                  textController: _titleController,
                  onChanged: (_) {
                    if (_validationMessage != null) {
                      setState(() => _validationMessage = null);
                    }
                  },
                ),
              ),
              onChanged: (_) {
                if (_validationMessage != null) {
                  setState(() => _validationMessage = null);
                }
              },
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
        : _calendarProgressColor(progress.band, palette);

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

class _PlanningCreateMenu extends StatelessWidget {
  const _PlanningCreateMenu({
    required this.onAddTask,
    required this.onAddGoal,
  });

  final VoidCallback onAddTask;
  final VoidCallback onAddGoal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MenuAnchor(
        menuChildren: [
          MenuItemButton(
            leadingIcon: const Icon(Icons.add_task_rounded),
            onPressed: onAddTask,
            child: Text(context.tr('Nueva tarea', 'New task')),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.flag_rounded),
            onPressed: onAddGoal,
            child: Text(context.tr('Nuevo objetivo', 'New goal')),
          ),
        ],
        builder: (context, controller, child) => SizedBox(
          width: double.infinity,
          child: FilledButton.tonalIcon(
            key: const ValueKey('planning-create-button'),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(context.tr('Crear', 'Create')),
          ),
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
    required this.expandedGoalId,
    required this.highlightedTaskId,
    required this.goalKeyFor,
    required this.onAddTask,
    required this.onAddGoal,
    required this.onGoalToggle,
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
  final String? expandedGoalId;
  final String? highlightedTaskId;
  final GlobalKey Function(String goalId) goalKeyFor;
  final VoidCallback onAddTask;
  final VoidCallback onAddGoal;
  final ValueChanged<String> onGoalToggle;

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
          _PlanningCreateMenu(onAddTask: onAddTask, onAddGoal: onAddGoal),
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
                key: goalKeyFor(goals[index].id),
                goal: goals[index],
                tasks: tasks
                    .where((task) => task.goalId == goals[index].id)
                    .toList(growable: false),
                summary: TaskStatusSummary.fromTasks(
                  tasks.where((task) => task.goalId == goals[index].id),
                ),
                isExpanded: expandedGoalId == goals[index].id,
                highlightedTaskId: highlightedTaskId,
                onToggle: () => onGoalToggle(goals[index].id),
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
    required this.tasks,
    required this.summary,
    required this.isExpanded,
    required this.highlightedTaskId,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final ProductivityGoal goal;
  final List<Task> tasks;
  final TaskStatusSummary summary;
  final bool isExpanded;
  final String? highlightedTaskId;
  final VoidCallback onToggle;
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
      child: Column(
        key: ValueKey('period-goal-${goal.id}'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  key: ValueKey('period-goal-toggle-${goal.id}'),
                  borderRadius: BorderRadius.circular(10),
                  onTap: onToggle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.flag_rounded,
                            color: palette.secondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.title,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateLabel,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: palette.textSecondary),
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
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: palette.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: palette.textSecondary,
                        ),
                      ],
                    ),
                  ),
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
                      title: Text(
                        context.tr('Eliminar objetivo', 'Delete goal'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: isExpanded
                ? _GoalTaskDetails(
                    goalId: goal.id,
                    tasks: tasks,
                    highlightedTaskId: highlightedTaskId,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _GoalTaskDetails extends StatelessWidget {
  const _GoalTaskDetails({
    required this.goalId,
    required this.tasks,
    required this.highlightedTaskId,
  });

  final String goalId;
  final List<Task> tasks;
  final String? highlightedTaskId;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      key: ValueKey('period-goal-tasks-$goalId'),
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.neutral),
      ),
      child: tasks.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                context.tr(
                  'Este objetivo todavía no tiene tareas.',
                  'This goal does not have tasks yet.',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final status in TaskStatus.values)
                  _GoalTaskStatusGroup(
                    status: status,
                    tasks: tasks
                        .where((task) => task.status == status)
                        .toList(growable: false),
                    highlightedTaskId: highlightedTaskId,
                  ),
              ],
            ),
    );
  }
}

class _GoalTaskStatusGroup extends StatelessWidget {
  const _GoalTaskStatusGroup({
    required this.status,
    required this.tasks,
    required this.highlightedTaskId,
  });

  final TaskStatus status;
  final List<Task> tasks;
  final String? highlightedTaskId;

  @override
  Widget build(BuildContext context) {
    final style = _taskStatusStyle(context, status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(style.icon, size: 17, color: style.color),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _taskStatusLabel(context, status),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: style.color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${tasks.length}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: style.color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (tasks.isNotEmpty) const SizedBox(height: 7),
          for (final task in tasks) ...[
            _GoalTaskRow(
              task: task,
              style: style,
              highlighted: task.id == highlightedTaskId,
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _GoalTaskRow extends StatelessWidget {
  const _GoalTaskRow({
    required this.task,
    required this.style,
    required this.highlighted,
  });

  final Task task;
  final _TaskStatusStyle style;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AnimatedContainer(
      key: highlighted
          ? ValueKey('period-goal-task-highlight-${task.id}')
          : ValueKey('period-goal-task-${task.id}'),
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? palette.primaryMuted : style.surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: highlighted ? palette.primary : style.border,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Text(
        task.title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: palette.textPrimary,
          fontWeight: highlighted ? FontWeight.w800 : FontWeight.w600,
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}

enum _GoalDeadlineAction { edit, delete }

String _routineRunStatusLabel(
  BuildContext context,
  RoutineRunStatus status,
) => switch (status) {
  RoutineRunStatus.scheduled => context.tr('Pendiente', 'Pending'),
  RoutineRunStatus.inProgress => context.tr('En progreso', 'In progress'),
  RoutineRunStatus.completed => context.tr('Completada', 'Completed'),
  RoutineRunStatus.skipped => context.tr('Omitida', 'Skipped'),
  RoutineRunStatus.missed => context.tr('Perdida', 'Missed'),
};

List<DateTime> _monthGridDays(DateTime month) {
  final firstDay = DateTime(month.year, month.month);
  final start = firstDay.subtract(Duration(days: firstDay.weekday % 7));

  return List.generate(42, (index) => start.add(Duration(days: index)));
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _mondayOf(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  return normalized.subtract(Duration(days: normalized.weekday - 1));
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

String _formatShortDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
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

Color _calendarProgressColor(TaskProgressBand band, AppPalette palette) {
  return switch (band) {
    TaskProgressBand.red => palette.statusDanger,
    TaskProgressBand.yellow => palette.statusWarning,
    TaskProgressBand.green => palette.statusSuccess,
    TaskProgressBand.strongGreen => palette.statusSuccessStrong,
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
