import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_identity_color.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/models/routine_schedule_projection.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

enum _WeeklyScheduleLayout { compact, grid }

class WeeklyScheduleCard extends StatefulWidget {
  const WeeklyScheduleCard({
    required this.weekStart,
    required this.selectedDay,
    required this.goals,
    required this.tasks,
    required this.activities,
    required this.isLoading,
    required this.onPreviousWeek,
    required this.onCurrentWeek,
    required this.onNextWeek,
    required this.onDaySelected,
    required this.onOpenRoutine,
    required this.isExporting,
    required this.onExportPdf,
    super.key,
  });

  final DateTime weekStart;
  final DateTime selectedDay;
  final List<ProductivityGoal> goals;
  final List<Task> tasks;
  final List<RoutineScheduleActivity> activities;
  final bool isLoading;
  final VoidCallback onPreviousWeek;
  final VoidCallback onCurrentWeek;
  final VoidCallback onNextWeek;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<RoutineScheduleActivity> onOpenRoutine;
  final bool isExporting;
  final VoidCallback onExportPdf;

  @override
  State<WeeklyScheduleCard> createState() => _WeeklyScheduleCardState();
}

class _WeeklyScheduleCardState extends State<WeeklyScheduleCard> {
  _WeeklyScheduleLayout? _layoutOverride;
  bool _goalsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final weekEnd = widget.weekStart.add(const Duration(days: 6));
    final weekGoals =
        widget.goals
            .where(
              (goal) =>
                  goal.targetDate != null &&
                  !_dateOnly(goal.targetDate!).isBefore(widget.weekStart) &&
                  !_dateOnly(goal.targetDate!).isAfter(weekEnd),
            )
            .toList(growable: false)
          ..sort(
            (first, second) => first.targetDate!.compareTo(second.targetDate!),
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout =
            _layoutOverride ??
            (constraints.maxWidth < 680
                ? _WeeklyScheduleLayout.compact
                : _WeeklyScheduleLayout.grid);
        return GlassCard(
          key: const ValueKey('weekly-schedule-card'),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppCardPaddings.standard,
                child: _WeekHeader(
                  weekStart: widget.weekStart,
                  weekEnd: weekEnd,
                  onPreviousWeek: widget.onPreviousWeek,
                  onCurrentWeek: widget.onCurrentWeek,
                  onNextWeek: widget.onNextWeek,
                  isExporting: widget.isExporting,
                  onExportPdf: widget.onExportPdf,
                ),
              ),
              Divider(height: 1, color: context.palette.neutralSoft),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<_WeeklyScheduleLayout>(
                    key: const ValueKey('weekly-layout-selector'),
                    segments: [
                      ButtonSegment(
                        value: _WeeklyScheduleLayout.compact,
                        icon: const Icon(Icons.view_agenda_rounded),
                        label: Text(context.tr('Compacto', 'Compact')),
                      ),
                      ButtonSegment(
                        value: _WeeklyScheduleLayout.grid,
                        icon: const Icon(Icons.grid_view_rounded),
                        label: Text(context.tr('Cuadrícula', 'Grid')),
                      ),
                    ],
                    selected: {layout},
                    showSelectedIcon: false,
                    onSelectionChanged: (selection) {
                      setState(() => _layoutOverride = selection.single);
                    },
                  ),
                ),
              ),
              Divider(height: 1, color: context.palette.neutralSoft),
              Padding(
                padding: AppCardPaddings.standard,
                child: _AllDayGoals(
                  goals: weekGoals,
                  tasks: widget.tasks,
                  expanded: _goalsExpanded,
                  onToggle: () {
                    setState(() => _goalsExpanded = !_goalsExpanded);
                  },
                  onDaySelected: widget.onDaySelected,
                ),
              ),
              Divider(height: 1, color: context.palette.neutralSoft),
              if (widget.isLoading)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (layout == _WeeklyScheduleLayout.compact)
                _CompactWeeklySchedule(
                  weekStart: widget.weekStart,
                  selectedDay: widget.selectedDay,
                  activities: widget.activities,
                  onDaySelected: widget.onDaySelected,
                  onOpenRoutine: widget.onOpenRoutine,
                )
              else
                _WeeklyTimeTable(
                  weekStart: widget.weekStart,
                  selectedDay: widget.selectedDay,
                  activities: widget.activities,
                  onDaySelected: widget.onDaySelected,
                  onOpenRoutine: widget.onOpenRoutine,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.weekStart,
    required this.weekEnd,
    required this.onPreviousWeek,
    required this.onCurrentWeek,
    required this.onNextWeek,
    required this.isExporting,
    required this.onExportPdf,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final VoidCallback onPreviousWeek;
  final VoidCallback onCurrentWeek;
  final VoidCallback onNextWeek;
  final bool isExporting;
  final VoidCallback onExportPdf;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.view_week_rounded, color: context.palette.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.tr('Horario semanal', 'Weekly schedule'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton.filledTonal(
              key: const ValueKey('export-week-pdf'),
              tooltip: context.tr(
                'Exportar horario en PDF',
                'Export schedule as PDF',
              ),
              onPressed: isExporting ? null : onExportPdf,
              icon: isExporting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf_rounded),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${localizations.formatMediumDate(weekStart)} – '
              '${localizations.formatMediumDate(weekEnd)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.palette.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton.icon(
              key: const ValueKey('current-week'),
              onPressed: onCurrentWeek,
              icon: const Icon(Icons.today_rounded, size: 18),
              label: Text(context.tr('Esta semana', 'This week')),
            ),
            IconButton.outlined(
              key: const ValueKey('previous-week'),
              tooltip: context.tr('Semana anterior', 'Previous week'),
              onPressed: onPreviousWeek,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            IconButton.outlined(
              key: const ValueKey('next-week'),
              tooltip: context.tr('Semana siguiente', 'Next week'),
              onPressed: onNextWeek,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ],
    );
  }
}

class _AllDayGoals extends StatelessWidget {
  const _AllDayGoals({
    required this.goals,
    required this.tasks,
    required this.expanded,
    required this.onToggle,
    required this.onDaySelected,
  });

  final List<ProductivityGoal> goals;
  final List<Task> tasks;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final goalIds = goals.map((goal) => goal.id).toSet();
    final goalTasks = tasks
        .where((task) => goalIds.contains(task.goalId))
        .toList(growable: false);
    final completedTasks = goalTasks.where((task) => task.isCompleted).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            key: const ValueKey('weekly-goals-toggle'),
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.flag_circle_rounded,
                    size: 20,
                    color: context.palette.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(
                            'Objetivos de la semana',
                            'Goals this week',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.tr(
                            '${goals.length} objetivos · '
                                '$completedTasks/${goalTasks.length} tareas',
                            '${goals.length} goals · '
                                '$completedTasks/${goalTasks.length} tasks',
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: context.palette.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.palette.primaryMuted,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '${goals.length}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.palette.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: context.palette.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (expanded) ...[
          const SizedBox(height: 10),
          if (goals.isEmpty)
            Text(
              context.tr(
                'No hay objetivos fechados esta semana.',
                'There are no dated goals this week.',
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.palette.textSecondary,
              ),
            )
          else
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: goals.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  final relatedTasks = tasks
                      .where((task) => task.goalId == goal.id)
                      .toList(growable: false);
                  final completed = relatedTasks
                      .where((task) => task.status == TaskStatus.completed)
                      .length;
                  final progress = relatedTasks.isEmpty
                      ? 0.0
                      : completed / relatedTasks.length;
                  return _AllDayGoalTile(
                    goal: goal,
                    completedTasks: completed,
                    totalTasks: relatedTasks.length,
                    progress: progress,
                    onTap: () => onDaySelected(goal.targetDate!),
                  );
                },
              ),
            ),
        ],
      ],
    );
  }
}

class _AllDayGoalTile extends StatelessWidget {
  const _AllDayGoalTile({
    required this.goal,
    required this.completedTasks,
    required this.totalTasks,
    required this.progress,
    required this.onTap,
  });

  final ProductivityGoal goal;
  final int completedTasks;
  final int totalTasks;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      width: 224,
      child: Material(
        color: palette.primaryMuted.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('week-goal-${goal.id}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Text(
                      '${goal.targetDate!.day}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  context.tr(
                    '$completedTasks/$totalTasks tareas',
                    '$completedTasks/$totalTasks tasks',
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactWeeklySchedule extends StatelessWidget {
  const _CompactWeeklySchedule({
    required this.weekStart,
    required this.selectedDay,
    required this.activities,
    required this.onDaySelected,
    required this.onOpenRoutine,
  });

  final DateTime weekStart;
  final DateTime selectedDay;
  final List<RoutineScheduleActivity> activities;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<RoutineScheduleActivity> onOpenRoutine;

  @override
  Widget build(BuildContext context) => Padding(
    padding: AppCardPaddings.standard,
    child: Column(
      children: [
        for (var offset = 0; offset < 7; offset++) ...[
          _CompactDaySection(
            day: weekStart.add(Duration(days: offset)),
            selected: _sameDate(
              weekStart.add(Duration(days: offset)),
              selectedDay,
            ),
            activities:
                activities
                    .where(
                      (activity) => _sameDate(
                        activity.localDate,
                        weekStart.add(Duration(days: offset)),
                      ),
                    )
                    .toList(growable: false)
                  ..sort(
                    (first, second) =>
                        first.startMinute.compareTo(second.startMinute),
                  ),
            onDaySelected: onDaySelected,
            onOpenRoutine: onOpenRoutine,
          ),
          if (offset < 6) const SizedBox(height: 10),
        ],
      ],
    ),
  );
}

class _CompactDaySection extends StatelessWidget {
  const _CompactDaySection({
    required this.day,
    required this.selected,
    required this.activities,
    required this.onDaySelected,
    required this.onOpenRoutine,
  });

  final DateTime day;
  final bool selected;
  final List<RoutineScheduleActivity> activities;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<RoutineScheduleActivity> onOpenRoutine;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final today = _sameDate(day, DateTime.now());
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected
            ? palette.primaryMuted.withValues(alpha: 0.24)
            : palette.surface.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? palette.primary : palette.neutralSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: ValueKey('compact-week-day-${_dateKey(day)}'),
              onTap: () => onDaySelected(day),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? palette.primary : palette.neutralSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: selected
                              ? Theme.of(context).colorScheme.onPrimary
                              : palette.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _shortWeekday(context, day),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: today
                                      ? palette.primary
                                      : palette.textPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          Text(
                            MaterialLocalizations.of(
                              context,
                            ).formatMediumDate(day),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: palette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: palette.primaryMuted,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '${activities.length}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: palette.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                context.tr('Sin actividades', 'No activities'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                children: [
                  for (var index = 0; index < activities.length; index++) ...[
                    _CompactActivityTile(
                      activity: activities[index],
                      onTap: () => onOpenRoutine(activities[index]),
                    ),
                    if (index < activities.length - 1)
                      const SizedBox(height: 7),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CompactActivityTile extends StatelessWidget {
  const _CompactActivityTile({required this.activity, required this.onTap});

  final RoutineScheduleActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = _activityColor(activity);
    final status = _activityStatus(context, activity.status);
    return Material(
      color: accent.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: ValueKey(
          'compact-week-activity-${activity.sourceRoutineId}-'
          '${_dateKey(activity.localDate)}-${activity.startMinute}',
        ),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: accent, width: 4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 76,
                child: Text(
                  _activityTimeRange(context, activity),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity.routineName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _CompactActivityMeta(
                          icon: _activityStatusIcon(activity.status),
                          label: status,
                          color: palette.textSecondary,
                        ),
                        if (activity.hasOverlap)
                          _CompactActivityMeta(
                            icon: Icons.layers_rounded,
                            label: context.tr(
                              'Se superpone',
                              'Overlapping',
                            ),
                            color: palette.tertiary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: palette.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactActivityMeta extends StatelessWidget {
  const _CompactActivityMeta({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 3),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}

class _WeeklyTimeTable extends StatelessWidget {
  const _WeeklyTimeTable({
    required this.weekStart,
    required this.selectedDay,
    required this.activities,
    required this.onDaySelected,
    required this.onOpenRoutine,
  });

  static const _timeAxisWidth = 54.0;
  static const _phoneDayWidth = 148.0;
  static const _dayHeaderHeight = 72.0;
  static const _hourHeight = 76.0;

  final DateTime weekStart;
  final DateTime selectedDay;
  final List<RoutineScheduleActivity> activities;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<RoutineScheduleActivity> onOpenRoutine;

  @override
  Widget build(BuildContext context) {
    final days = [
      for (var offset = 0; offset < 7; offset++)
        weekStart.add(Duration(days: offset)),
    ];
    final earliestMinute = math.min(
      6 * 60,
      activities.isEmpty
          ? 6 * 60
          : activities.map((activity) => activity.startMinute).reduce(math.min),
    );
    final latestMinute = math.max(
      22 * 60,
      activities.isEmpty
          ? 22 * 60
          : activities.map((activity) => activity.endMinute).reduce(math.max),
    );
    final firstHour = (earliestMinute ~/ 60).clamp(0, 23);
    final lastHour = ((latestMinute + 59) ~/ 60).clamp(firstHour + 1, 24);
    final gridHeight = (lastHour - firstHour) * _hourHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableDaysWidth = constraints.maxWidth - _timeAxisWidth;
        final dayWidth = availableDaysWidth >= 7 * 112
            ? availableDaysWidth / 7
            : _phoneDayWidth;
        final tableWidth = dayWidth * 7;
        return SizedBox(
          height: _dayHeaderHeight + gridHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _timeAxisWidth,
                height: _dayHeaderHeight + gridHeight,
                child: Stack(
                  children: [
                    for (var hour = firstHour; hour <= lastHour; hour++)
                      Positioned(
                        top:
                            _dayHeaderHeight +
                            (hour - firstHour) * _hourHeight -
                            8,
                        left: 4,
                        right: 4,
                        child: Text(
                          _formatMinute(context, hour * 60),
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: context.palette.textSecondary,
                                fontSize: 10,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const ValueKey('weekly-horizontal-scroll'),
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    height: _dayHeaderHeight + gridHeight,
                    child: Stack(
                      children: [
                        for (var dayIndex = 0; dayIndex < 7; dayIndex++)
                          Positioned(
                            left: dayIndex * dayWidth,
                            width: dayWidth,
                            top: 0,
                            height: _dayHeaderHeight + gridHeight,
                            child: _DayColumnBackground(
                              day: days[dayIndex],
                              selected: _sameDate(
                                days[dayIndex],
                                selectedDay,
                              ),
                              today: _sameDate(
                                days[dayIndex],
                                DateTime.now(),
                              ),
                              onTap: () => onDaySelected(days[dayIndex]),
                            ),
                          ),
                        for (var hour = firstHour; hour <= lastHour; hour++)
                          Positioned(
                            left: 0,
                            right: 0,
                            top:
                                _dayHeaderHeight +
                                (hour - firstHour) * _hourHeight,
                            child: Divider(
                              height: 1,
                              color: context.palette.neutralSoft.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        for (var dayIndex = 0; dayIndex < 7; dayIndex++)
                          ..._activityBlocksForDay(
                            context: context,
                            day: days[dayIndex],
                            dayIndex: dayIndex,
                            dayWidth: dayWidth,
                            firstHour: firstHour,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _activityBlocksForDay({
    required BuildContext context,
    required DateTime day,
    required int dayIndex,
    required double dayWidth,
    required int firstHour,
  }) {
    final dayActivities = activities
        .where((activity) => _sameDate(activity.localDate, day))
        .toList(growable: false);
    final layouts = _layoutActivities(dayActivities);
    return [
      for (final layout in layouts)
        Positioned(
          left:
              dayIndex * dayWidth +
              (layout.lane * dayWidth / layout.laneCount) +
              4,
          width: dayWidth / layout.laneCount - 8,
          top:
              _dayHeaderHeight +
              ((layout.activity.startMinute - firstHour * 60) / 60) *
                  _hourHeight +
              2,
          height: math
              .max(
                34,
                layout.activity.durationMinutes / 60 * _hourHeight - 4,
              )
              .toDouble(),
          child: _ActivityBlock(
            activity: layout.activity,
            onTap: () => onOpenRoutine(layout.activity),
          ),
        ),
    ];
  }
}

class _DayColumnBackground extends StatelessWidget {
  const _DayColumnBackground({
    required this.day,
    required this.selected,
    required this.today,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected
            ? palette.primaryMuted.withValues(alpha: 0.28)
            : Colors.transparent,
        border: Border(
          left: BorderSide(color: palette.neutralSoft),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: _WeeklyTimeTable._dayHeaderHeight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: ValueKey('week-day-${_dateKey(day)}'),
                onTap: onTap,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _shortWeekday(context, day),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: today
                                  ? palette.primary
                                  : palette.textSecondary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? palette.primary
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: selected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : palette.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Expanded(child: IgnorePointer(child: SizedBox.expand())),
        ],
      ),
    );
  }
}

class _ActivityBlock extends StatelessWidget {
  const _ActivityBlock({required this.activity, required this.onTap});

  final RoutineScheduleActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = _activityColor(activity);
    final status = _activityStatus(context, activity.status);
    final statusIcon = _activityStatusIcon(activity.status);
    return Semantics(
      button: true,
      label:
          '${activity.routineName}, ${activity.title}, '
          '${_activityTimeRange(context, activity)}, $status',
      child: Material(
        color: accent.withValues(
          alpha: activity.status == RoutineRunStatus.completed ? 0.16 : 0.28,
        ),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey(
            'week-activity-${activity.sourceRoutineId}-'
            '${_dateKey(activity.localDate)}-${activity.startMinute}',
          ),
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: activity.hasOverlap
                    ? palette.tertiary
                    : accent.withValues(alpha: 0.78),
                width: activity.hasOverlap ? 2 : 1,
              ),
            ),
            child: ClipRect(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 42) {
                    return Center(
                      child: Icon(
                        activity.hasOverlap ? Icons.layers_rounded : statusIcon,
                        size: 12,
                        color: activity.hasOverlap
                            ? palette.tertiary
                            : palette.textSecondary,
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activity.routineName} · ${activity.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            size: 12,
                            color: palette.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${_activityTimeRange(context, activity)} · '
                              '$status',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: palette.textSecondary,
                                    fontSize: 9,
                                  ),
                            ),
                          ),
                          if (activity.hasOverlap)
                            Icon(
                              Icons.layers_rounded,
                              size: 12,
                              color: palette.tertiary,
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityLayout {
  const _ActivityLayout({
    required this.activity,
    required this.lane,
    required this.laneCount,
  });

  final RoutineScheduleActivity activity;
  final int lane;
  final int laneCount;
}

List<_ActivityLayout> _layoutActivities(
  List<RoutineScheduleActivity> source,
) {
  final sorted = [...source]
    ..sort((first, second) => first.startMinute.compareTo(second.startMinute));
  final result = <_ActivityLayout>[];
  var cursor = 0;
  while (cursor < sorted.length) {
    var groupEnd = sorted[cursor].endMinute;
    var groupLimit = cursor + 1;
    while (groupLimit < sorted.length &&
        sorted[groupLimit].startMinute < groupEnd) {
      groupEnd = math.max(groupEnd, sorted[groupLimit].endMinute);
      groupLimit += 1;
    }
    final laneEnds = <int>[];
    final assignments = <(RoutineScheduleActivity, int)>[];
    for (final activity in sorted.sublist(cursor, groupLimit)) {
      var lane = laneEnds.indexWhere((end) => end <= activity.startMinute);
      if (lane == -1) {
        lane = laneEnds.length;
        laneEnds.add(activity.endMinute);
      } else {
        laneEnds[lane] = activity.endMinute;
      }
      assignments.add((activity, lane));
    }
    for (final assignment in assignments) {
      result.add(
        _ActivityLayout(
          activity: assignment.$1,
          lane: assignment.$2,
          laneCount: laneEnds.length,
        ),
      );
    }
    cursor = groupLimit;
  }
  return result;
}

Color _activityColor(RoutineScheduleActivity activity) => Color(
  effectiveRoutineIdentityColorArgb(
    colorKey: activity.colorKey,
    customColorArgb: activity.customColorArgb,
  ),
);

IconData _activityStatusIcon(RoutineRunStatus status) => switch (status) {
  RoutineRunStatus.scheduled => Icons.schedule_rounded,
  RoutineRunStatus.inProgress => Icons.play_circle_rounded,
  RoutineRunStatus.completed => Icons.check_circle_rounded,
  RoutineRunStatus.skipped => Icons.skip_next_rounded,
  RoutineRunStatus.missed => Icons.error_outline_rounded,
};

String _activityStatus(BuildContext context, RoutineRunStatus status) =>
    switch (status) {
      RoutineRunStatus.scheduled => context.tr('Pendiente', 'Pending'),
      RoutineRunStatus.inProgress => context.tr('En curso', 'In progress'),
      RoutineRunStatus.completed => context.tr('Hecha', 'Completed'),
      RoutineRunStatus.skipped => context.tr('Omitida', 'Skipped'),
      RoutineRunStatus.missed => context.tr('Perdida', 'Missed'),
    };

String _formatMinute(BuildContext context, int minute) {
  if (minute >= 24 * 60) return '24:00';
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
  );
}

String _activityTimeRange(
  BuildContext context,
  RoutineScheduleActivity activity,
) =>
    '${_formatMinute(context, activity.startMinute)}–'
    '${_formatMinute(context, activity.endMinute)}';

String _shortWeekday(BuildContext context, DateTime day) {
  const spanish = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const english = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return Localizations.localeOf(context).languageCode == 'en'
      ? english[day.weekday - 1]
      : spanish[day.weekday - 1];
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
