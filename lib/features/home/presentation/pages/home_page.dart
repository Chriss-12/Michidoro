import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/models/routine_schedule_projection.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/pages/routine_editor_page.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/start_routine_focus_flow.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routePath = '/home';

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return ListView(
      padding: AppCardPaddings.page,
      children: [
        Text(
          context.tr(
            'Hola, ${settings.profileName}',
            'Hello, ${settings.profileName}',
          ),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppDesignTokens.mainTitleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.tr('Listo para enfocarte hoy', 'Ready to focus today'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 36),
        const _RoutineTodayCard(),
        const _TaskStatusOverviewCard(),
        const SizedBox(height: 18),
        const _PerformanceDashboardCard(),
        const SizedBox(height: 18),
        const _StatisticsDownloadCard(),
        const SizedBox(height: 18),
        const _DailyGoalCard(),
        const SizedBox(height: 18),
        const _EnergyCard(),
        const SizedBox(height: 18),
        const _WeeklyProgressCardV2(),
      ],
    );
  }
}

class _RoutineTodayCard extends StatelessWidget {
  const _RoutineTodayCard();

  @override
  Widget build(BuildContext context) {
    if (!serviceLocator.isRegistered<RoutinesController>()) {
      return const SizedBox.shrink();
    }
    final routinesController = serviceLocator<RoutinesController>();
    final tasksController = serviceLocator<TasksController>();
    return SignalBuilder(
      builder: (context) {
        final summary = projectRoutineTodayFocus(
          routines: routinesController.routines.value,
          runs: routinesController.todayRuns.value,
          itemRuns: routinesController.todayItemRuns.value,
          tasks: tasksController.tasks.value,
        );
        if (summary == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: _RoutineTodayContent(summary: summary),
        );
      },
    );
  }
}

class _RoutineTodayContent extends StatelessWidget {
  const _RoutineTodayContent({required this.summary});

  final RoutineTodayFocus summary;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final nextItem = summary.nextItem;
    final completed =
        summary.run.status == RoutineRunStatus.completed ||
        summary.completedRequiredItems >= summary.totalRequiredItems;
    final inProgress = nextItem?.status == RoutineRunStatus.inProgress;
    final progress = summary.totalRequiredItems == 0
        ? 0.0
        : (summary.completedRequiredItems / summary.totalRequiredItems).clamp(
            0.0,
            1.0,
          );
    return GlassCard(
      key: const ValueKey('home-routine-today'),
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SoftIcon(
                icon: Icons.event_repeat_rounded,
                color: palette.secondary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Rutina de hoy', "Today's routine"),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      summary.routine.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: context.tr('Ver rutina', 'View routine'),
                onPressed: () => context.push(
                  '${RoutineEditorPage.routePath}?id=${summary.routine.id}',
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  completed
                      ? context.tr('Completada', 'Completed')
                      : inProgress
                      ? context.tr('En progreso', 'In progress')
                      : context.tr('Pendiente', 'Pending'),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: completed ? palette.primary : palette.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${summary.completedRequiredItems}/${summary.totalRequiredItems}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              color: palette.primary,
              backgroundColor: palette.neutralSoft.withValues(alpha: 0.5),
            ),
          ),
          if (nextItem != null) ...[
            const SizedBox(height: 12),
            Text(
              nextItem.titleSnapshot,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 3),
            Text(
              '${_homeClock(context, nextItem.scheduledAtSnapshot)} · '
              '${nextItem.durationMinutesSnapshot} min',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
          if (inProgress && summary.followingItem != null) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: palette.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr(
                      'Después: ${summary.followingItem!.titleSnapshot} · '
                          '${_homeClock(context, summary.followingItem!.scheduledAtSnapshot)}',
                      'Next: ${summary.followingItem!.titleSnapshot} · '
                          '${_homeClock(context, summary.followingItem!.scheduledAtSnapshot)}',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (summary.canStart) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const ValueKey('home-routine-start'),
                onPressed: () => startRoutineTaskFocusFlow(
                  context: context,
                  task: summary.task!,
                  run: summary.run,
                  item: summary.nextItem!,
                  controller: serviceLocator<RoutinesController>(),
                ),
                icon: Icon(
                  inProgress ? Icons.play_arrow_rounded : Icons.timer_outlined,
                ),
                label: Text(
                  inProgress
                      ? context.tr('Continuar actividad', 'Continue activity')
                      : context.tr('Iniciar actividad', 'Start activity'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _homeClock(BuildContext context, DateTime value) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: value.hour, minute: value.minute),
    );

enum _PerformanceRange { day, week, month, year }

class _PerformanceHistoryCard extends StatefulWidget {
  const _PerformanceHistoryCard();

  @override
  State<_PerformanceHistoryCard> createState() =>
      _PerformanceHistoryCardState();
}

class _PerformanceHistoryCardState extends State<_PerformanceHistoryCard> {
  _PerformanceRange _range = _PerformanceRange.day;

  static const _data = <_PerformanceRange, List<double>>{
    _PerformanceRange.day: [0.32, 0.48, 0.44, 0.68, 0.57, 0.82, 0.74],
    _PerformanceRange.week: [0.42, 0.58, 0.51, 0.76, 0.69, 0.86, 0.79],
    _PerformanceRange.month: [0.46, 0.61, 0.73, 0.81],
  };

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final values = _data[_range]!;
    final average =
        (values.reduce((first, second) => first + second) / values.length * 100)
            .round();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Historial de rendimiento', 'Performance history'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: AppDesignTokens.sectionTitleFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.tr(
              'Evolución del rendimiento por período',
              'Performance over time',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<_PerformanceRange>(
              expandedInsets: EdgeInsets.zero,
              style: _compactSegmentStyle,
              segments: [
                ButtonSegment(
                  value: _PerformanceRange.day,
                  label: Text(context.tr('Día', 'Day')),
                ),
                ButtonSegment(
                  value: _PerformanceRange.week,
                  label: Text(context.tr('Semana', 'Week')),
                ),
                ButtonSegment(
                  value: _PerformanceRange.month,
                  label: Text(context.tr('Mes', 'Month')),
                ),
              ],
              selected: {_range},
              showSelectedIcon: false,
              onSelectionChanged: (selection) {
                setState(() => _range = selection.first);
              },
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 190,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _PerformanceLinePainter(
                  palette: palette,
                  fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                  values: values,
                  labels: _performanceDemoLabels(context, _range),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HistorySummaryRow(
                label: context.tr('Promedio', 'Average'),
                value: '$average%',
              ),
              const SizedBox(height: 8),
              _HistorySummaryRow(
                label: context.tr('Período', 'Period'),
                value: _range.label(context),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('Datos de demostración', 'Demo data'),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Kept as the previous V2 chart while V3 uses the unified dashboard.
// ignore: unused_element
class _PerformanceHistoryCardV2 extends StatelessWidget {
  const _PerformanceHistoryCardV2();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tasksController = serviceLocator<TasksController>();

    return SignalBuilder(
      builder: (context) {
        final weekProgress = tasksController.progressForWeek(DateTime.now());
        final taskCounts = weekProgress
            .map((progress) => progress.summary.total)
            .toList(growable: false);
        final maxTasks = taskCounts.fold<int>(
          1,
          (max, count) => count > max ? count : max,
        );
        final values = [
          for (final count in taskCounts) count / maxTasks,
        ];
        final labels = [
          for (final progress in weekProgress)
            _weekdayShortLabel(context, progress.day),
        ];
        final total = weekProgress.fold<int>(
          0,
          (sum, progress) => sum + progress.summary.total,
        );
        final completed = weekProgress.fold<int>(
          0,
          (sum, progress) => sum + progress.summary.completed,
        );
        final completion = total == 0 ? 0 : (completed / total * 100).round();

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('Historial de rendimiento', 'Performance history'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr(
                  'Tareas por día de la semana actual',
                  'Tasks by day of the current week',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 190,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _PerformanceLinePainter(
                      palette: palette,
                      fontFamily: Theme.of(
                        context,
                      ).textTheme.bodySmall?.fontFamily,
                      values: values,
                      labels: labels,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HistorySummaryRow(
                    label: context.tr('Tareas', 'Tasks'),
                    value: '$total',
                  ),
                  const SizedBox(height: 8),
                  _HistorySummaryRow(
                    label: context.tr('Completadas', 'Completed'),
                    value: '$completion%',
                  ),
                  const SizedBox(height: 8),
                  _HistorySummaryRow(
                    label: context.tr('Período', 'Period'),
                    value: context.tr('Semana', 'Week'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

extension on _PerformanceRange {
  String label(BuildContext context) {
    return switch (this) {
      _PerformanceRange.day => context.tr('Día', 'Day'),
      _PerformanceRange.week => context.tr('Semana', 'Week'),
      _PerformanceRange.month => context.tr('Mes', 'Month'),
      _PerformanceRange.year => context.tr('Año', 'Year'),
    };
  }
}

class _HistorySummaryRow extends StatelessWidget {
  const _HistorySummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: palette.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PerformanceLinePainter extends CustomPainter {
  const _PerformanceLinePainter({
    required this.palette,
    required this.fontFamily,
    required this.values,
    required this.labels,
  });

  final AppPalette palette;
  final String? fontFamily;
  final List<double> values;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 8.0;
    const top = 12.0;
    const bottom = 28.0;
    final chartHeight = size.height - top - bottom;
    final chartWidth = size.width - left * 2;
    final gridPaint = Paint()
      ..color = palette.neutralSoft
      ..strokeWidth = 1;

    for (var line = 0; line <= 4; line++) {
      final y = top + chartHeight * line / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width - left, y), gridPaint);
    }

    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x = values.length == 1
          ? left + chartWidth / 2
          : left + chartWidth * index / (values.length - 1);
      final y = top + chartHeight * (1 - values[index]);
      points.add(Offset(x, y));
    }

    final areaPath = Path()
      ..moveTo(points.first.dx, top + chartHeight)
      ..lineTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      areaPath.lineTo(point.dx, point.dy);
    }
    areaPath
      ..lineTo(points.last.dx, top + chartHeight)
      ..close();
    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.primary.withValues(alpha: 0.28),
            palette.primary.withValues(alpha: 0.02),
          ],
        ).createShader(Rect.fromLTWH(left, top, chartWidth, chartHeight)),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = palette.primary
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    final pointPaint = Paint()..color = palette.secondary;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final maximumLabels = values.length < 2
        ? 1
        : (chartWidth / 36).floor().clamp(2, values.length);
    final labelStride = values.length <= maximumLabels
        ? 1
        : (values.length / maximumLabels).ceil();
    for (var index = 0; index < points.length; index++) {
      canvas.drawCircle(points[index], 4, pointPaint);
      if (index % labelStride != 0 && index != points.length - 1) {
        continue;
      }
      textPainter
        ..text = TextSpan(
          text: labels[index],
          style: TextStyle(
            color: palette.textSecondary,
            fontFamily: fontFamily,
            fontSize: 10,
          ),
        )
        ..layout()
        ..paint(
          canvas,
          Offset(points[index].dx - textPainter.width / 2, size.height - 17),
        );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformanceLinePainter oldDelegate) {
    return oldDelegate.palette != palette ||
        oldDelegate.fontFamily != fontFamily ||
        !listEquals(oldDelegate.values, values) ||
        !listEquals(oldDelegate.labels, labels);
  }
}

class _CartesianCurvePainter extends CustomPainter {
  const _CartesianCurvePainter({
    required this.palette,
    required this.fontFamily,
    required this.values,
    required this.labels,
  });

  final AppPalette palette;
  final String? fontFamily;
  final List<double> values;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 34.0;
    const right = 14.0;
    const top = 12.0;
    const bottom = 34.0;
    final chartHeight = size.height - top - bottom;
    final chartWidth = size.width - left - right;
    final origin = Offset(left, top + chartHeight);
    final xEnd = Offset(left + chartWidth, origin.dy);
    const yEnd = Offset(left, top);
    final gridPaint = Paint()
      ..color = palette.neutralSoft
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = palette.textSecondary
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (var line = 0; line <= 4; line++) {
      final y = top + chartHeight * line / 4;
      canvas.drawLine(Offset(left, y), Offset(xEnd.dx, y), gridPaint);
    }
    for (var line = 1; line <= 4; line++) {
      final x = left + chartWidth * line / 4;
      canvas.drawLine(Offset(x, top), Offset(x, origin.dy), gridPaint);
    }

    canvas
      ..drawLine(origin, xEnd, axisPaint)
      ..drawLine(origin, yEnd, axisPaint)
      ..drawLine(xEnd, Offset(xEnd.dx - 7, xEnd.dy - 4), axisPaint)
      ..drawLine(xEnd, Offset(xEnd.dx - 7, xEnd.dy + 4), axisPaint)
      ..drawLine(yEnd, Offset(yEnd.dx - 4, yEnd.dy + 7), axisPaint)
      ..drawLine(yEnd, Offset(yEnd.dx + 4, yEnd.dy + 7), axisPaint);

    final points = <Offset>[];
    for (var index = 0; index < values.length; index += 1) {
      final x = values.length == 1
          ? left + chartWidth / 2
          : left + chartWidth * index / (values.length - 1);
      final value = values[index].clamp(0, 1).toDouble();
      final y = top + chartHeight * (1 - value);
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      final curve = Path()..moveTo(points.first.dx, points.first.dy);
      for (var index = 0; index < points.length - 1; index += 1) {
        final current = points[index];
        final next = points[index + 1];
        final midX = (current.dx + next.dx) / 2;
        curve.cubicTo(midX, current.dy, midX, next.dy, next.dx, next.dy);
      }
      canvas.drawPath(
        curve,
        Paint()
          ..color = palette.primary
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      );

      final pointPaint = Paint()..color = palette.secondary;
      for (final point in points) {
        canvas
          ..drawCircle(point, 4.5, Paint()..color = palette.surface)
          ..drawCircle(point, 3.2, pointPaint);
      }
    }

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    void paintLabel(String text, Offset offset, {double fontSize = 10}) {
      textPainter
        ..text = TextSpan(
          text: text,
          style: TextStyle(
            color: palette.textSecondary,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        )
        ..layout()
        ..paint(canvas, offset);
    }

    paintLabel('Y', Offset(8, yEnd.dy - 3), fontSize: 11);
    paintLabel('X', Offset(xEnd.dx - 2, origin.dy + 12), fontSize: 11);

    final maximumLabels = values.length < 2
        ? 1
        : (chartWidth / 44).floor().clamp(2, values.length);
    final labelStride = values.length <= maximumLabels
        ? 1
        : (values.length / maximumLabels).ceil();
    for (
      var index = 0;
      index < labels.length && index < points.length;
      index += 1
    ) {
      if (index % labelStride != 0 && index != labels.length - 1) {
        continue;
      }
      paintLabel(
        labels[index],
        Offset(points[index].dx - 14, size.height - 18),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CartesianCurvePainter oldDelegate) {
    return oldDelegate.palette != palette ||
        oldDelegate.fontFamily != fontFamily ||
        !listEquals(oldDelegate.values, values) ||
        !listEquals(oldDelegate.labels, labels);
  }
}

class _PerformanceDashboardCard extends StatefulWidget {
  const _PerformanceDashboardCard();

  @override
  State<_PerformanceDashboardCard> createState() =>
      _PerformanceDashboardCardState();
}

class _PerformanceDashboardCardState extends State<_PerformanceDashboardCard> {
  _PerformanceRange _range = _PerformanceRange.month;
  StatisticsChartType _selectedChart = StatisticsChartType.circular;
  Object? _tasksRevision;
  Object? _sessionsRevision;
  Object? _routineTemplatesRevision;
  Object? _routineRunsRevision;
  Object? _routineItemsRevision;
  _PerformanceRange? _loadedRange;
  Future<StatisticsReportData>? _reportFuture;
  Timer? _rangeRefreshTimer;

  @override
  void initState() {
    super.initState();
    _scheduleRangeRefresh();
  }

  @override
  void dispose() {
    _rangeRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final tasksController = serviceLocator<TasksController>();
    final pomodoroController = serviceLocator<PomodoroController>();
    final routinesController = serviceLocator.isRegistered<RoutinesController>()
        ? serviceLocator<RoutinesController>()
        : null;

    return SignalBuilder(
      builder: (context) {
        final reportFuture = _reportFor(
          tasksRevision: tasksController.tasks.value,
          sessionsRevision: pomodoroController.sessions.value,
          routineTemplatesRevision: routinesController?.routines.value,
          routineRunsRevision: routinesController?.todayRuns.value,
          routineItemsRevision: routinesController?.todayItemRuns.value,
        );

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('Rendimiento', 'Performance') +
                    _range.titleSuffix(context),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              FutureBuilder<StatisticsReportData>(
                future: reportFuture,
                builder: (context, reportSnapshot) {
                  final report = reportSnapshot.data;
                  final label =
                      reportSnapshot.connectionState == ConnectionState.done &&
                          report != null
                      ? _PerformanceSnapshot.fromReportData(
                          context: context,
                          range: _range,
                          focusMinutes: settings.focusMinutes,
                          report: report,
                        ).summaryLabel(context)
                      : context.tr(
                          'Resumen de actividad del período',
                          'Activity summary for this period',
                        );
                  return Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.palette.textSecondary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              _PerformanceRangeSelector(
                selectedRange: _range,
                onChanged: (range) => setState(() => _range = range),
              ),
              const SizedBox(height: 14),
              _ChartTypeSelector(
                selectedChart: _selectedChart,
                onChanged: (chart) => setState(() => _selectedChart = chart),
              ),
              const SizedBox(height: 18),
              FutureBuilder<StatisticsReportData>(
                future: reportFuture,
                builder: (context, reportSnapshot) {
                  if (reportSnapshot.connectionState != ConnectionState.done) {
                    return const _PerformanceLoadingState();
                  }
                  if (reportSnapshot.hasError) {
                    return _PerformanceErrorState(onRetry: _retry);
                  }

                  final report = reportSnapshot.data;
                  if (report == null || _isEmptyReport(report)) {
                    return const _PerformanceEmptyState();
                  }

                  return _PerformanceDashboardContent(
                    snapshot: _PerformanceSnapshot.fromReportData(
                      context: context,
                      range: _range,
                      focusMinutes: settings.focusMinutes,
                      report: report,
                    ),
                    selectedChart: _selectedChart,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<StatisticsReportData> _reportFor({
    required Object tasksRevision,
    required Object sessionsRevision,
    required Object? routineTemplatesRevision,
    required Object? routineRunsRevision,
    required Object? routineItemsRevision,
  }) {
    if (_reportFuture == null ||
        _loadedRange != _range ||
        !identical(_tasksRevision, tasksRevision) ||
        !identical(_sessionsRevision, sessionsRevision) ||
        !identical(_routineTemplatesRevision, routineTemplatesRevision) ||
        !identical(_routineRunsRevision, routineRunsRevision) ||
        !identical(_routineItemsRevision, routineItemsRevision)) {
      _tasksRevision = tasksRevision;
      _sessionsRevision = sessionsRevision;
      _routineTemplatesRevision = routineTemplatesRevision;
      _routineRunsRevision = routineRunsRevision;
      _routineItemsRevision = routineItemsRevision;
      _loadedRange = _range;
      _reportFuture = serviceLocator<GenerateStatisticsReport>()(
        StatisticsReportRequest(period: _range.reportPeriod),
      );
    }

    return _reportFuture!;
  }

  void _retry() {
    setState(() {
      _reportFuture = null;
    });
  }

  void _scheduleRangeRefresh() {
    _rangeRefreshTimer?.cancel();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    _rangeRefreshTimer = Timer(nextDay.difference(now), () {
      if (!mounted) {
        return;
      }
      setState(() => _reportFuture = null);
      _scheduleRangeRefresh();
    });
  }
}

class _PerformanceDashboardContent extends StatelessWidget {
  const _PerformanceDashboardContent({
    required this.snapshot,
    required this.selectedChart,
  });

  final _PerformanceSnapshot snapshot;
  final StatisticsChartType selectedChart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MoodAverageSummary(snapshot: snapshot),
        if (snapshot.routines case final routines?) ...[
          const SizedBox(height: 18),
          _RoutineAnalyticsSummary(metrics: routines),
        ],
        const SizedBox(height: 18),
        if (selectedChart == StatisticsChartType.circular) ...[
          _DashboardSection(
            title: context.tr('Circular', 'Circular'),
            child: _OverallProgressChart(progress: snapshot.overallProgress),
          ),
          const SizedBox(height: 16),
        ],
        if (selectedChart == StatisticsChartType.stackedBars) ...[
          _DashboardSection(
            title: context.tr('Barras apiladas', 'Stacked bars'),
            child: _StackedTaskStatusChart(snapshot: snapshot),
          ),
          const SizedBox(height: 16),
        ],
        if (selectedChart == StatisticsChartType.groupedBars) ...[
          _DashboardSection(
            title: context.tr('Barras agrupadas', 'Grouped bars'),
            child: _GroupedFocusChart(snapshot: snapshot),
          ),
          const SizedBox(height: 16),
        ],
        if (selectedChart == StatisticsChartType.horizontalBars) ...[
          _DashboardSection(
            title: context.tr('Gráfico horizontal', 'Horizontal chart'),
            child: _HorizontalStatusChart(snapshot: snapshot),
          ),
          const SizedBox(height: 16),
        ],
        if (selectedChart == StatisticsChartType.standardBars) ...[
          _DashboardSection(
            title: context.tr('Gráfico de barras', 'Bar chart'),
            child: _BasicBarsChart(snapshot: snapshot),
          ),
          const SizedBox(height: 16),
        ],
        if (selectedChart == StatisticsChartType.xy)
          _DashboardSection(
            title: context.tr('Gráfico básico x/y', 'Basic x/y chart'),
            child: _BasicTrendChart(snapshot: snapshot),
          ),
      ],
    );
  }
}

class _RoutineAnalyticsSummary extends StatelessWidget {
  const _RoutineAnalyticsSummary({required this.metrics});

  final StatisticsRoutineMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final consistency = metrics.consistency;
    final percent = consistency == null ? null : (consistency * 100).round();
    final delay = metrics.averageStartDelayMinutes;
    final mood = metrics.moodAverage;
    final abandonment = metrics.typicalAbandonmentItem;

    return Semantics(
      label: context.tr(
        percent == null
            ? 'Constancia de rutinas sin datos'
            : 'Constancia de rutinas $percent por ciento',
        percent == null
            ? 'Routine consistency unavailable'
            : 'Routine consistency $percent percent',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('Constancia de rutinas', 'Routine consistency'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                percent == null
                    ? context.tr('Sin datos', 'No data')
                    : '$percent%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.palette.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (consistency != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: consistency.clamp(0, 1),
                minHeight: 8,
                backgroundColor: context.palette.neutralSoft,
                color: context.palette.primary,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            context.tr(
              '${metrics.completedRequiredItems} de ${metrics.requiredItems} actividades obligatorias',
              '${metrics.completedRequiredItems} of ${metrics.requiredItems} required activities',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              _RoutineMetric(
                label: context.tr('Rutinas completadas', 'Completed routines'),
                value: '${metrics.completedRuns}/${metrics.scheduledRuns}',
              ),
              _RoutineMetric(
                label: context.tr('Omitidas / perdidas', 'Skipped / missed'),
                value: '${metrics.skippedRuns} / ${metrics.missedRuns}',
              ),
              _RoutineMetric(
                label: context.tr(
                  'Actividades programadas',
                  'Scheduled activities',
                ),
                value: '${metrics.scheduledItems}',
              ),
              _RoutineMetric(
                label: context.tr(
                  'Actividades en progreso',
                  'Activities in progress',
                ),
                value: '${metrics.inProgressItems}',
              ),
              _RoutineMetric(
                label: context.tr(
                  'Actividades completadas',
                  'Completed activities',
                ),
                value: '${metrics.completedItems}',
              ),
              _RoutineMetric(
                label: context.tr(
                  'Actividades omitidas / perdidas',
                  'Skipped / missed activities',
                ),
                value: '${metrics.skippedItems} / ${metrics.missedItems}',
              ),
              _RoutineMetric(
                label: context.tr('Foco plan / real', 'Planned / actual focus'),
                value:
                    '${metrics.plannedFocusMinutes} / ${metrics.focusedMinutes} min',
              ),
              _RoutineMetric(
                label: context.tr('Retraso promedio', 'Average delay'),
                value: delay == null
                    ? context.tr('Sin datos', 'No data')
                    : '${delay.round()} min',
              ),
              _RoutineMetric(
                label: context.tr('Ánimo en rutinas', 'Mood in routines'),
                value: mood == null
                    ? context.tr('Sin datos', 'No data')
                    : '${mood.toStringAsFixed(1)}/5',
              ),
              _RoutineMetric(
                label: context.tr(
                  'Mejor racha por rutina',
                  'Best streak by routine',
                ),
                value: context.tr(
                  '${metrics.longestCompletedStreak} días',
                  '${metrics.longestCompletedStreak} days',
                ),
              ),
            ],
          ),
          if (abandonment != null) ...[
            const SizedBox(height: 12),
            Text(
              context.tr(
                'Abandono más frecuente: $abandonment (${metrics.typicalAbandonmentCount})',
                'Most frequent abandonment: $abandonment (${metrics.typicalAbandonmentCount})',
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RoutineMetric extends StatelessWidget {
  const _RoutineMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodAverageSummary extends StatelessWidget {
  const _MoodAverageSummary({required this.snapshot});

  final _PerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final average = snapshot.moodAverage;
    final isDay = snapshot.range == _PerformanceRange.day;
    final title = isDay
        ? context.tr('Ánimo promedio del día', 'Average mood today')
        : context.tr('Ánimo promedio del período', 'Average mood this period');
    final sampleLabel = context.tr(
      '${snapshot.moodSampleCount} bloques valorados',
      '${snapshot.moodSampleCount} rated blocks',
    );

    return Semantics(
      label: average == null
          ? '$title. ${context.tr('Sin respuestas', 'No responses')}'
          : '$title. ${average.toStringAsFixed(1)} de 5. $sampleLabel',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.palette.primaryMuted.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.palette.neutralSoft),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                _homeMoodIcon(average),
                color: context.palette.primary,
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      average == null
                          ? context.tr(
                              'Sin respuestas de ánimo',
                              'No mood responses',
                            )
                          : '${average.toStringAsFixed(1)}/5 · $sampleLabel',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
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

IconData _homeMoodIcon(double? average) {
  if (average == null) {
    return Icons.sentiment_neutral_rounded;
  }
  return switch (average.round().clamp(1, 5)) {
    1 => Icons.sentiment_very_dissatisfied_rounded,
    2 => Icons.sentiment_dissatisfied_rounded,
    3 => Icons.sentiment_neutral_rounded,
    4 => Icons.sentiment_satisfied_rounded,
    _ => Icons.sentiment_very_satisfied_rounded,
  };
}

class _PerformanceLoadingState extends StatelessWidget {
  const _PerformanceLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: ValueKey('performance-loading'),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _PerformanceErrorState extends StatelessWidget {
  const _PerformanceErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('performance-error'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(
              context.tr(
                'No se pudieron cargar las estadísticas.',
                'Statistics could not be loaded.',
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr('Reintentar', 'Retry')),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceEmptyState extends StatelessWidget {
  const _PerformanceEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('performance-empty'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Text(
          context.tr(
            'Aún no hay actividad en este período.',
            'There is no activity in this period yet.',
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.palette.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _PerformanceRangeSelector extends StatelessWidget {
  const _PerformanceRangeSelector({
    required this.selectedRange,
    required this.onChanged,
  });

  final _PerformanceRange selectedRange;
  final ValueChanged<_PerformanceRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<_PerformanceRange>(
        expandedInsets: EdgeInsets.zero,
        style: _compactSegmentStyle,
        segments: [
          ButtonSegment(
            value: _PerformanceRange.day,
            tooltip: 'performance-range-day',
            label: Text(context.tr('Día', 'Day')),
          ),
          ButtonSegment(
            value: _PerformanceRange.week,
            label: Text(context.tr('Semana', 'Week')),
          ),
          ButtonSegment(
            value: _PerformanceRange.month,
            label: Text(context.tr('Mes', 'Month')),
          ),
          ButtonSegment(
            value: _PerformanceRange.year,
            label: Text(context.tr('Año', 'Year')),
          ),
        ],
        selected: {selectedRange},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => onChanged(selection.single),
      ),
    );
  }
}

const _compactSegmentStyle = ButtonStyle(
  padding: WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 6),
  ),
);

class _ChartTypeSelector extends StatelessWidget {
  const _ChartTypeSelector({
    required this.selectedChart,
    required this.onChanged,
  });

  final StatisticsChartType selectedChart;
  final ValueChanged<StatisticsChartType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final chart in StatisticsChartType.values)
          ChoiceChip(
            label: Text(_chartTypeLabel(context, chart)),
            selected: selectedChart == chart,
            onSelected: (_) => onChanged(chart),
          ),
      ],
    );
  }
}

class _DashboardSection extends StatelessWidget {
  const _DashboardSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _StackedTaskStatusChart extends StatelessWidget {
  const _StackedTaskStatusChart({required this.snapshot});

  final _PerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final total = snapshot.taskSummary.total;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 26,
            child: Row(
              children: [
                _StackSegment(
                  value: snapshot.taskSummary.listed,
                  total: total,
                  color: context.palette.secondarySoft,
                ),
                _StackSegment(
                  value: snapshot.taskSummary.inProgress,
                  total: total,
                  color: const Color(0xFFE3B341),
                ),
                _StackSegment(
                  value: snapshot.taskSummary.completed,
                  total: total,
                  color: context.palette.primary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _MiniLegend(
          values: [
            _LegendValue(
              context.tr('Pendientes', 'Pending'),
              snapshot.taskSummary.listed,
            ),
            _LegendValue(
              context.tr('En progreso', 'In progress'),
              snapshot.taskSummary.inProgress,
            ),
            _LegendValue(
              context.tr('Completadas', 'Completed'),
              snapshot.taskSummary.completed,
            ),
          ],
        ),
      ],
    );
  }
}

class _StackSegment extends StatelessWidget {
  const _StackSegment({
    required this.value,
    required this.total,
    required this.color,
  });

  final int value;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) {
      return const Expanded(child: SizedBox.shrink());
    }

    return Expanded(
      flex: value <= 0 ? 1 : value,
      child: ColoredBox(
        color: value <= 0 ? context.palette.primaryMuted : color,
      ),
    );
  }
}

class _GroupedFocusChart extends StatelessWidget {
  const _GroupedFocusChart({required this.snapshot});

  final _PerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final values = snapshot.bucketValues;

    return LayoutBuilder(
      builder: (context, constraints) {
        final requiredWidth = values.length * 42.0;
        final chartWidth = requiredWidth > constraints.maxWidth
            ? requiredWidth
            : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < values.length; index += 1)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _GroupedBarPair(
                        label: snapshot.bucketLabels[index],
                        taskValue: values[index],
                        focusValue: snapshot.focusBucketValues[index],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GroupedBarPair extends StatelessWidget {
  const _GroupedBarPair({
    required this.label,
    required this.taskValue,
    required this.focusValue,
  });

  final String label;
  final double taskValue;
  final double focusValue;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: taskValue.clamp(0.04, 1),
                  alignment: Alignment.bottomCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: focusValue.clamp(0.04, 1),
                  alignment: Alignment.bottomCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _HorizontalStatusChart extends StatelessWidget {
  const _HorizontalStatusChart({required this.snapshot});

  final _PerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HorizontalMetricBar(
          label: context.tr('Tareas', 'Tasks'),
          description: context.tr(
            '${snapshot.taskSummary.total} tareas, '
                '${snapshot.taskSummary.completed} completadas',
            '${snapshot.taskSummary.total} tasks, '
                '${snapshot.taskSummary.completed} completed',
          ),
          value: snapshot.taskProgress,
        ),
        const _MetricDivider(),
        _HorizontalMetricBar(
          label: context.tr('Pomodoros', 'Pomodoros'),
          description: context.tr(
            '${snapshot.completedPomodoros} completados',
            '${snapshot.completedPomodoros} completed',
          ),
          value: snapshot.pomodoroProgress,
        ),
        const _MetricDivider(),
        _HorizontalMetricBar(
          label: context.tr('Enfoque', 'Focus'),
          description: context.tr(
            '${snapshot.focusedMinutes} min enfocados',
            '${snapshot.focusedMinutes} focused min',
          ),
          value: snapshot.focusProgress,
        ),
      ],
    );
  }
}

class _BasicBarsChart extends StatelessWidget {
  const _BasicBarsChart({required this.snapshot});

  final _PerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final values = [
      snapshot.taskProgress,
      snapshot.pomodoroProgress,
      snapshot.focusProgress,
    ];
    final labels = [
      context.tr('Tareas', 'Tasks'),
      'Pom',
      context.tr('Foco', 'Focus'),
    ];

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var index = 0; index < values.length; index += 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _BasicBar(
                  label: labels[index],
                  value: values[index],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BasicBar extends StatelessWidget {
  const _BasicBar({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: value.clamp(0.04, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _BasicTrendChart extends StatelessWidget {
  const _BasicTrendChart({required this.snapshot});

  final _PerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CartesianCurvePainter(
            palette: context.palette,
            fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
            values: snapshot.bucketValues,
            labels: snapshot.bucketLabels,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _MiniLegend extends StatelessWidget {
  const _MiniLegend({required this.values});

  final List<_LegendValue> values;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: [
        for (final value in values)
          Text(
            '${value.label}: ${value.value}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
      ],
    );
  }
}

class _LegendValue {
  const _LegendValue(this.label, this.value);

  final String label;
  final int value;
}

class _PerformanceSnapshot {
  const _PerformanceSnapshot({
    required this.range,
    required this.focusMinutes,
    required this.taskSummary,
    required this.completedPomodoros,
    required this.focusedSeconds,
    required this.bucketValues,
    required this.focusBucketValues,
    required this.bucketLabels,
    required this.moodAverage,
    required this.moodSampleCount,
    required this.routines,
  });

  factory _PerformanceSnapshot.fromReportData({
    required BuildContext context,
    required _PerformanceRange range,
    required int focusMinutes,
    required StatisticsReportData report,
  }) {
    final buckets = report.calendarDays.isEmpty
        ? [
            StatisticsCalendarDay(
              day: report.range.start,
              completionRatio: 0,
              isEnded: false,
              totalTasks: 0,
            ),
          ]
        : report.calendarDays;
    final taskCounts = [
      for (final bucket in buckets) bucket.totalTasks,
    ];
    final maxTaskCount = taskCounts.fold<int>(
      1,
      (max, count) => count > max ? count : max,
    );
    final maxFocusedSeconds = buckets.fold<int>(
      1,
      (max, bucket) =>
          bucket.focusedSeconds > max ? bucket.focusedSeconds : max,
    );

    return _PerformanceSnapshot(
      range: range,
      focusMinutes: focusMinutes,
      taskSummary: report.tasks,
      completedPomodoros: report.completedPomodoros,
      focusedSeconds: report.focusedSeconds,
      bucketValues: [
        for (final count in taskCounts) count / maxTaskCount,
      ],
      focusBucketValues: [
        for (final bucket in buckets) bucket.focusedSeconds / maxFocusedSeconds,
      ],
      bucketLabels: [
        for (final bucket in buckets)
          _reportBucketLabel(context, range, bucket.day),
      ],
      moodAverage: report.moodAverage,
      moodSampleCount: report.moodSampleCount,
      routines: report.routines,
    );
  }

  final _PerformanceRange range;
  final int focusMinutes;
  final StatisticsTaskTotals taskSummary;
  final int completedPomodoros;
  final int focusedSeconds;
  final List<double> bucketValues;
  final List<double> focusBucketValues;
  final List<String> bucketLabels;
  final double? moodAverage;
  final int moodSampleCount;
  final StatisticsRoutineMetrics? routines;

  int get focusedMinutes => focusedSeconds ~/ 60;
  double get taskProgress => taskSummary.completionRatio;
  double get pomodoroProgress =>
      (completedPomodoros / expectedPomodoros).clamp(0.0, 1.0);
  double get focusProgress => (focusedSeconds / expectedFocusSeconds).clamp(
    0.0,
    1.0,
  );
  double get overallProgress =>
      (taskProgress + pomodoroProgress + focusProgress) / 3;
  int get expectedPomodoros {
    return _expectedPomodorosFor(range);
  }

  int get expectedFocusSeconds => focusMinutes * expectedPomodoros * 60;

  String summaryLabel(BuildContext context) {
    return context.tr(
      '${taskSummary.total} tareas, $completedPomodoros pomodoros, '
          '$focusedMinutes min de enfoque',
      '${taskSummary.total} tasks, $completedPomodoros pomodoros, '
          '$focusedMinutes focus min',
    );
  }
}

// Kept as the previous V2 summary while V3 uses the unified dashboard.
// ignore: unused_element
class _PerformanceInsightsCard extends StatelessWidget {
  const _PerformanceInsightsCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final tasksController = serviceLocator<TasksController>();
    final pomodoroController = serviceLocator<PomodoroController>();

    return SignalBuilder(
      builder: (context) {
        final now = DateTime.now();
        final monthlyTasks = tasksController.tasks.value
            .where(
              (task) => _isInMonth(task.scheduledDate ?? task.createdAt, now),
            )
            .toList(growable: false);
        final taskSummary = TaskStatusSummary.fromTasks(monthlyTasks);
        final taskProgress = taskSummary.completionRatio;
        final monthlySessions = pomodoroController.sessions.value
            .where((session) => _isInMonth(session.endedAt, now))
            .toList(growable: false);
        final focusedSeconds = monthlySessions.fold<int>(
          0,
          (total, session) => total + session.focusedSeconds,
        );
        final monthlyFocusGoalSeconds = settings.focusMinutes * 24 * 60;
        final focusProgress = monthlyFocusGoalSeconds == 0
            ? 0.0
            : (focusedSeconds / monthlyFocusGoalSeconds).clamp(0.0, 1.0);
        final pomodoroProgress = (monthlySessions.length / 24).clamp(0.0, 1.0);
        final overallProgress = (taskProgress + focusProgress) / 2;
        final focusedMinutes = focusedSeconds ~/ 60;

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('Rendimiento', 'Performance'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr(
                  'Rendimiento del mes actual',
                  'Performance for the current month',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AppDesignTokens.bodyFontSize,
                ),
              ),
              const SizedBox(height: 16),
              _HorizontalMetricBar(
                label: context.tr('Tareas', 'Tasks'),
                description: context.tr(
                  '${taskSummary.total} tareas, '
                      '${taskSummary.completed} completadas',
                  '${taskSummary.total} tasks, '
                      '${taskSummary.completed} completed',
                ),
                value: taskProgress,
              ),
              const _MetricDivider(),
              _HorizontalMetricBar(
                label: context.tr('Pomodoros', 'Pomodoros'),
                description: context.tr(
                  '${monthlySessions.length} completados este mes',
                  '${monthlySessions.length} completed this month',
                ),
                value: pomodoroProgress,
              ),
              const _MetricDivider(),
              _HorizontalMetricBar(
                label: context.tr('Enfoque', 'Focus'),
                description: context.tr(
                  '$focusedMinutes min enfocados',
                  '$focusedMinutes focused min',
                ),
                value: focusProgress,
              ),
              const SizedBox(height: 20),
              _OverallProgressChart(progress: overallProgress),
            ],
          ),
        );
      },
    );
  }
}

class _TaskStatusOverviewCard extends StatefulWidget {
  const _TaskStatusOverviewCard();

  @override
  State<_TaskStatusOverviewCard> createState() =>
      _TaskStatusOverviewCardState();
}

class _TaskStatusOverviewCardState extends State<_TaskStatusOverviewCard> {
  Object? _tasksRevision;
  Future<TaskStatusSummary>? _summaryFuture;

  @override
  Widget build(BuildContext context) {
    final tasksController = serviceLocator<TasksController>();

    return SignalBuilder(
      builder: (context) {
        final summaryFuture = _summaryFor(tasksController.tasks.value);

        return GlassCard(
          padding: AppCardPaddings.compact,
          child: FutureBuilder<TaskStatusSummary>(
            future: summaryFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  key: const ValueKey('task-status-error'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: TextButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(context.tr('Reintentar', 'Retry')),
                    ),
                  ),
                );
              }

              final summary =
                  snapshot.data ??
                  const TaskStatusSummary(
                    listed: 0,
                    inProgress: 0,
                    completed: 0,
                  );

              return Column(
                children: [
                  _TaskStatusMetric(
                    label: context.tr('Pendientes', 'Pending'),
                    value: summary.listed,
                    icon: Icons.playlist_add_check_rounded,
                  ),
                  const SizedBox(height: 10),
                  _TaskStatusMetric(
                    label: context.tr('En progreso', 'In progress'),
                    value: summary.inProgress,
                    icon: Icons.pending_actions_rounded,
                  ),
                  const SizedBox(height: 10),
                  _TaskStatusMetric(
                    label: context.tr('Completadas', 'Completed'),
                    value: summary.completed,
                    icon: Icons.task_alt_rounded,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<TaskStatusSummary> _summaryFor(Object tasksRevision) {
    if (_summaryFuture == null || !identical(_tasksRevision, tasksRevision)) {
      _tasksRevision = tasksRevision;
      _summaryFuture = serviceLocator<TasksRepository>().loadTasks().then(
        TaskStatusSummary.fromTasks,
      );
    }

    return _summaryFuture!;
  }

  void _retry() {
    setState(() {
      _summaryFuture = null;
    });
  }
}

class _TaskStatusMetric extends StatelessWidget {
  const _TaskStatusMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.64),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.primaryMuted.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: palette.primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$value',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(height: 1, color: context.palette.neutralSoft),
    );
  }
}

class _OverallProgressChart extends StatelessWidget {
  const _OverallProgressChart({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final percentage = (progress * 100).round();

    return Row(
      children: [
        SizedBox.square(
          dimension: 82,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 9,
                  strokeCap: StrokeCap.round,
                  color: palette.primary,
                  backgroundColor: palette.primaryMuted,
                ),
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('Rendimiento general', 'Overall performance'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(
                  'Promedio de tareas, pomodoros y objetivo diario de enfoque.',
                  'Average of tasks, pomodoros, and daily focus goal.',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatisticsDownloadCard extends StatefulWidget {
  const _StatisticsDownloadCard();

  @override
  State<_StatisticsDownloadCard> createState() =>
      _StatisticsDownloadCardState();
}

class _StatisticsDownloadCardState extends State<_StatisticsDownloadCard> {
  StatisticsReportPeriod _period = StatisticsReportPeriod.day;
  DateTime? _from;
  DateTime? _to;
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final palette = context.palette;
    final isRange = _period == StatisticsReportPeriod.range;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Descargar estadísticas', 'Download statistics'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: AppDesignTokens.sectionTitleFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<StatisticsReportPeriod>(
            value: _period,
            decoration: InputDecoration(
              labelText: context.tr('Período', 'Period'),
            ),
            items: [
              DropdownMenuItem(
                value: StatisticsReportPeriod.day,
                child: Text(context.tr('Día', 'Day')),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.week,
                child: Text(context.tr('Semana', 'Week')),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.month,
                child: Text(context.tr('Mes', 'Month')),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.year,
                child: Text(context.tr('Año', 'Year')),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.range,
                child: Text(context.tr('Fecha a fecha', 'Date range')),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _period = value);
            },
          ),
          if (isRange) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(isFrom: true),
                    child: Text(
                      _from == null
                          ? context.tr('Desde', 'From')
                          : _formatDate(_from!),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(isFrom: false),
                    child: Text(
                      _to == null
                          ? context.tr('Hasta', 'To')
                          : _formatDate(_to!),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Text(
            context.tr(
              'El PDF incluye gráficas de rendimiento, estudio vs descanso '
                  'y porcentaje de avance.',
              'The PDF includes performance charts, focus versus break time, '
                  'and progress percentage.',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isExporting ? null : () => _export(settings),
              icon: _isExporting
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf_rounded, size: 16),
              label: Text(
                _isExporting
                    ? context.tr('Guardando...', 'Saving...')
                    : context.tr('Descargar PDF', 'Download PDF'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _export(AppSettingsScope settings) async {
    setState(() => _isExporting = true);
    try {
      final reportFile = await settings.onDownloadStatisticsPdf(
        StatisticsReportRequest(
          period: _period,
          from: _from,
          to: _to,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.tr(
                'PDF guardado en ${reportFile.displayPath}',
                'PDF saved to ${reportFile.displayPath}',
              ),
            ),
            action: SnackBarAction(
              label: context.tr('Abrir', 'Open'),
              onPressed: () => _openReport(settings, reportFile.openReference),
            ),
          ),
        );
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.tr(
                'No se pudo guardar el PDF. Revisa la carpeta seleccionada.',
                'The PDF could not be saved. Check the selected folder.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _openReport(AppSettingsScope settings, String path) async {
    try {
      await settings.onOpenReport(path);
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.tr(
                'No se pudo abrir el PDF. Verifica que tengas un visor '
                    'instalado.',
                'The PDF could not be opened. Make sure a PDF viewer is '
                    'installed.',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDate: isFrom ? _from ?? now : _to ?? now,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isFrom) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _HorizontalMetricBar extends StatelessWidget {
  const _HorizontalMetricBar({
    required this.label,
    required this.description,
    required this.value,
  });

  final String label;
  final String description;
  final double value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final percent = (value * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 2),
        Text(
          description,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: palette.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  color: palette.primary,
                  backgroundColor: palette.primaryMuted,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 42,
              child: Text(
                '$percent%',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tasksController = serviceLocator<TasksController>();

    return SignalBuilder(
      builder: (context) {
        final today = tasksController.progressForDay(DateTime.now());
        final progress = today.completionRatio;
        final progressLabel = (progress * 100).round();

        return GlassCard(
          padding: AppCardPaddings.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SoftIcon(
                    icon: Icons.track_changes_rounded,
                    color: _progressColor(today.band),
                  ),
                  const Spacer(),
                  Text(
                    today.isEnded
                        ? context.tr('Día finalizado', 'Day completed')
                        : context.tr('Meta diaria', 'Daily goal'),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                '${today.summary.completed} / ${today.summary.total}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(
                  '$progressLabel% de tareas completadas hoy',
                  "$progressLabel% of today's tasks completed",
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                borderRadius: BorderRadius.circular(99),
                color: _progressColor(today.band),
                backgroundColor: palette.primaryMuted,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: today.isEnded
                      ? null
                      : () {
                          tasksController.endDay(DateTime.now());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.tr(
                                  'Día terminado con $progressLabel% de avance.',
                                  'Day completed with $progressLabel% progress.',
                                ),
                              ),
                            ),
                          );
                        },
                  icon: Icon(
                    today.isEnded
                        ? Icons.check_circle_rounded
                        : Icons.outlined_flag_rounded,
                  ),
                  label: Text(
                    today.isEnded
                        ? context.tr('Día terminado', 'Day completed')
                        : context.tr('Terminar día', 'End day'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EnergyCard extends StatelessWidget {
  const _EnergyCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SoftIcon(icon: Icons.bolt_outlined, color: palette.primary),
              const Spacer(),
              Text(
                context.tr('Nivel de energía', 'Energy level'),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('Óptimo', 'Optimal'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            context.tr(
              'Basado en tus descansos recientes',
              'Based on your recent breaks',
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// Legacy demo card kept temporarily while V2 uses live task progress.
// ignore: unused_element
class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Progreso semanal', 'Weekly progress'),
            style:
                Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WeeklyDayProgress(
                day: context.tr('L', 'M'),
                progress: 0.65,
              ),
              _WeeklyDayProgress(
                day: context.tr('M', 'T'),
                progress: 0.45,
              ),
              _WeeklyDayProgress(day: context.tr('X', 'W'), progress: 0),
              _WeeklyDayProgress(day: context.tr('J', 'T'), progress: 0),
              _WeeklyDayProgress(day: context.tr('V', 'F'), progress: 0),
              _WeeklyDayProgress(day: context.tr('S', 'S'), progress: 0),
              _WeeklyDayProgress(day: context.tr('D', 'S'), progress: 0),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.tr(
              'Completa bloques de enfoque para llenar tu semana.',
              'Complete focus blocks to fill your week.',
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _WeeklyProgressCardV2 extends StatelessWidget {
  const _WeeklyProgressCardV2();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tasksController = serviceLocator<TasksController>();

    return SignalBuilder(
      builder: (context) {
        final weekProgress = tasksController.progressForWeek(DateTime.now());

        return GlassCard(
          padding: AppCardPaddings.spacious,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('Progreso semanal', 'Weekly progress'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final progress in weekProgress)
                    _WeeklyDayProgressV2(
                      day: _weekdayShortLabel(context, progress.day),
                      progress: progress.completionRatio,
                      band: progress.band,
                      isEnded: progress.isEnded,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                context.tr(
                  'Rojo hasta 20%, amarillo hasta 50%, verde hasta 70%, '
                      'verde fuerte hasta 100%.',
                  'Red up to 20%, yellow up to 50%, green up to 70%, '
                      'strong green up to 100%.',
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeeklyDayProgressV2 extends StatelessWidget {
  const _WeeklyDayProgressV2({
    required this.day,
    required this.progress,
    required this.band,
    required this.isEnded,
  });

  final String day;
  final double progress;
  final TaskProgressBand band;
  final bool isEnded;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = _progressColor(band);

    return Column(
      children: [
        SizedBox(
          width: 18,
          height: 64,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.primaryMuted.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: progress.clamp(0.0, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEnded ? '$day*' : day,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

// Legacy demo day marker kept with the temporary demo weekly card.
// ignore: unused_element
class _WeeklyDayProgress extends StatelessWidget {
  const _WeeklyDayProgress({required this.day, required this.progress});

  final String day;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        SizedBox(
          width: 18,
          height: 64,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.primaryMuted.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: progress.clamp(0.0, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: progress == 0 ? Colors.transparent : palette.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

Color _progressColor(TaskProgressBand band) {
  return switch (band) {
    TaskProgressBand.red => const Color(0xFFE05252),
    TaskProgressBand.yellow => const Color(0xFFE3B341),
    TaskProgressBand.green => const Color(0xFF5EAD68),
    TaskProgressBand.strongGreen => const Color(0xFF188E53),
  };
}

String _weekdayShortLabel(BuildContext context, DateTime day) {
  return switch (day.weekday) {
    DateTime.monday => context.tr('L', 'M'),
    DateTime.tuesday => context.tr('M', 'T'),
    DateTime.wednesday => context.tr('X', 'W'),
    DateTime.thursday => context.tr('J', 'T'),
    DateTime.friday => context.tr('V', 'F'),
    DateTime.saturday => 'S',
    DateTime.sunday => context.tr('D', 'S'),
    _ => '',
  };
}

List<String> _performanceDemoLabels(
  BuildContext context,
  _PerformanceRange range,
) {
  return switch (range) {
    _PerformanceRange.day => ['08', '10', '12', '14', '16', '18', '20'],
    _PerformanceRange.week => [
      context.tr('L', 'M'),
      context.tr('M', 'T'),
      context.tr('X', 'W'),
      context.tr('J', 'T'),
      context.tr('V', 'F'),
      'S',
      context.tr('D', 'S'),
    ],
    _PerformanceRange.month => [
      context.tr('S1', 'W1'),
      context.tr('S2', 'W2'),
      context.tr('S3', 'W3'),
      context.tr('S4', 'W4'),
    ],
    _PerformanceRange.year => const [],
  };
}

String _chartTypeLabel(BuildContext context, StatisticsChartType chart) {
  return switch (chart) {
    StatisticsChartType.circular => context.tr('Circular', 'Circular'),
    StatisticsChartType.stackedBars => context.tr(
      'Barras apiladas',
      'Stacked bars',
    ),
    StatisticsChartType.groupedBars => context.tr(
      'Barras agrupadas',
      'Grouped bars',
    ),
    StatisticsChartType.horizontalBars => context.tr(
      'Gráfico horizontal',
      'Horizontal chart',
    ),
    StatisticsChartType.standardBars => context.tr(
      'Gráfico de barras',
      'Bar chart',
    ),
    StatisticsChartType.xy => 'X/Y',
  };
}

bool _isInMonth(DateTime date, DateTime month) {
  return date.year == month.year && date.month == month.month;
}

extension on _PerformanceRange {
  String titleSuffix(BuildContext context) {
    return switch (this) {
      _PerformanceRange.day => context.tr(' del día', ' for the day'),
      _PerformanceRange.week => context.tr(' de la semana', ' for the week'),
      _PerformanceRange.month => context.tr(' del mes', ' for the month'),
      _PerformanceRange.year => context.tr(' del año', ' for the year'),
    };
  }

  StatisticsReportPeriod get reportPeriod {
    return switch (this) {
      _PerformanceRange.day => StatisticsReportPeriod.day,
      _PerformanceRange.week => StatisticsReportPeriod.week,
      _PerformanceRange.month => StatisticsReportPeriod.month,
      _PerformanceRange.year => StatisticsReportPeriod.year,
    };
  }
}

String _reportBucketLabel(
  BuildContext context,
  _PerformanceRange range,
  DateTime bucket,
) {
  return switch (range) {
    _PerformanceRange.day => '${bucket.hour}h',
    _PerformanceRange.week => _weekdayShortLabel(context, bucket),
    _PerformanceRange.month => '${bucket.day}',
    _PerformanceRange.year => '${bucket.month}',
  };
}

int _expectedPomodorosFor(_PerformanceRange range) {
  return switch (range) {
    _PerformanceRange.day => 4,
    _PerformanceRange.week => 12,
    _PerformanceRange.month => 24,
    _PerformanceRange.year => 180,
  };
}

bool _isEmptyReport(StatisticsReportData report) {
  return report.tasks.total == 0 &&
      report.createdTasks.total == 0 &&
      report.completedPomodoros == 0 &&
      report.focusedSeconds == 0 &&
      report.completionEvents == 0 &&
      report.legacyUnknownCompletions == 0 &&
      report.moodSampleCount == 0 &&
      report.distractionMinutes == 0 &&
      report.routines == null;
}
