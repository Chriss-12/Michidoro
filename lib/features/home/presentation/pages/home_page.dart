import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
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
          'Hola, ${settings.profileName}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppDesignTokens.mainTitleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Listo para enfocarte hoy',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 36),
        const _CalendarPlanningCard(),
        const SizedBox(height: 18),
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
        const _TodayTasksCard(),
        const SizedBox(height: 18),
        const _WeeklyProgressCardV2(),
      ],
    );
  }
}

class _CalendarPlanningCard extends StatelessWidget {
  const _CalendarPlanningCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Row(
        children: [
          _SoftIcon(icon: Icons.calendar_month_rounded, color: palette.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Planificacion',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  'Revisa tu calendario local de enfoque.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Abrir calendario',
            onPressed: () => context.push(CalendarPage.routePath),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}

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

  static const _labels = <_PerformanceRange, List<String>>{
    _PerformanceRange.day: ['08', '10', '12', '14', '16', '18', '20'],
    _PerformanceRange.week: ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
    _PerformanceRange.month: ['S1', 'S2', 'S3', 'S4'],
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
            'Historial de rendimiento',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: AppDesignTokens.sectionTitleFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Evolución del rendimiento por período',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<_PerformanceRange>(
              segments: const [
                ButtonSegment(value: _PerformanceRange.day, label: Text('Día')),
                ButtonSegment(
                  value: _PerformanceRange.week,
                  label: Text('Semana'),
                ),
                ButtonSegment(
                  value: _PerformanceRange.month,
                  label: Text('Mes'),
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
                  values: values,
                  labels: _labels[_range]!,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HistorySummaryRow(label: 'Promedio', value: '$average%'),
              const SizedBox(height: 8),
              _HistorySummaryRow(
                label: 'Período',
                value: _range.label,
              ),
              const SizedBox(height: 8),
              Text(
                'Datos de demostración',
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
          for (final progress in weekProgress) _weekdayShortLabel(progress.day),
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
                'Historial de rendimiento',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tareas por dia de la semana actual',
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
                  _HistorySummaryRow(label: 'Tareas', value: '$total'),
                  const SizedBox(height: 8),
                  _HistorySummaryRow(
                    label: 'Completadas',
                    value: '$completion%',
                  ),
                  const SizedBox(height: 8),
                  const _HistorySummaryRow(label: 'Periodo', value: 'Semana'),
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
  String get label {
    return switch (this) {
      _PerformanceRange.day => 'Día',
      _PerformanceRange.week => 'Semana',
      _PerformanceRange.month => 'Mes',
      _PerformanceRange.year => 'Año',
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
    required this.values,
    required this.labels,
  });

  final AppPalette palette;
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
    for (var index = 0; index < points.length; index++) {
      canvas.drawCircle(points[index], 4, pointPaint);
      textPainter
        ..text = TextSpan(
          text: labels[index],
          style: TextStyle(color: palette.textSecondary, fontSize: 10),
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

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final tasksController = serviceLocator<TasksController>();
    final pomodoroController = serviceLocator<PomodoroController>();

    return SignalBuilder(
      builder: (context) {
        final snapshot = _PerformanceSnapshot.fromControllers(
          range: _range,
          focusMinutes: settings.focusMinutes,
          tasksController: tasksController,
          pomodoroController: pomodoroController,
        );
        final visibleCharts = settings.enabledStatisticsCharts;

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rendimiento ${_range.titleSuffix}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                snapshot.summaryLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              _PerformanceRangeSelector(
                selectedRange: _range,
                onChanged: (range) => setState(() => _range = range),
              ),
              const SizedBox(height: 14),
              _ChartVisibilitySelector(
                visibleCharts: visibleCharts,
                onToggle: settings.onStatisticsChartVisibilityChanged,
              ),
              const SizedBox(height: 18),
              if (visibleCharts.contains(StatisticsChartType.circular)) ...[
                _DashboardSection(
                  title: 'Circular',
                  child: _OverallProgressChart(
                    progress: snapshot.overallProgress,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (visibleCharts.contains(StatisticsChartType.stackedBars)) ...[
                _DashboardSection(
                  title: 'Barras apiladas',
                  child: _StackedTaskStatusChart(snapshot: snapshot),
                ),
                const SizedBox(height: 16),
              ],
              if (visibleCharts.contains(StatisticsChartType.groupedBars)) ...[
                _DashboardSection(
                  title: 'Barras agrupadas',
                  child: _GroupedFocusChart(snapshot: snapshot),
                ),
                const SizedBox(height: 16),
              ],
              if (visibleCharts.contains(
                StatisticsChartType.horizontalBars,
              )) ...[
                _DashboardSection(
                  title: 'Grafico horizontal',
                  child: _HorizontalStatusChart(snapshot: snapshot),
                ),
                const SizedBox(height: 16),
              ],
              if (visibleCharts.contains(StatisticsChartType.standardBars)) ...[
                _DashboardSection(
                  title: 'Grafico de barras',
                  child: _BasicBarsChart(snapshot: snapshot),
                ),
                const SizedBox(height: 16),
              ],
              if (visibleCharts.contains(StatisticsChartType.xy))
                _DashboardSection(
                  title: 'Grafico basico x/y',
                  child: _BasicTrendChart(snapshot: snapshot),
                ),
            ],
          ),
        );
      },
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<_PerformanceRange>(
        segments: const [
          ButtonSegment(value: _PerformanceRange.day, label: Text('Día')),
          ButtonSegment(value: _PerformanceRange.week, label: Text('Semana')),
          ButtonSegment(value: _PerformanceRange.month, label: Text('Mes')),
          ButtonSegment(value: _PerformanceRange.year, label: Text('Año')),
        ],
        selected: {selectedRange},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => onChanged(selection.single),
      ),
    );
  }
}

class _ChartVisibilitySelector extends StatelessWidget {
  const _ChartVisibilitySelector({
    required this.visibleCharts,
    required this.onToggle,
  });

  final Set<StatisticsChartType> visibleCharts;
  final void Function(StatisticsChartType chart, {required bool enabled})
  onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final chart in StatisticsChartType.values)
          FilterChip(
            label: Text(chart.label),
            selected: visibleCharts.contains(chart),
            onSelected: (selected) => onToggle(chart, enabled: selected),
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
            _LegendValue('Pendientes', snapshot.taskSummary.listed),
            _LegendValue('En progreso', snapshot.taskSummary.inProgress),
            _LegendValue('Completadas', snapshot.taskSummary.completed),
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
    final values = snapshot.bucketValues.take(6).toList(growable: false);
    final labels = snapshot.bucketLabels
        .take(values.length)
        .toList(
          growable: false,
        );

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var index = 0; index < values.length; index += 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _GroupedBarPair(
                  label: labels[index],
                  taskValue: values[index],
                  focusValue: snapshot.focusBucketValues[index],
                ),
              ),
            ),
        ],
      ),
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
          label: 'Tareas',
          description:
              '${snapshot.taskSummary.total} tareas, ${snapshot.taskSummary.completed} completadas',
          value: snapshot.taskProgress,
        ),
        const _MetricDivider(),
        _HorizontalMetricBar(
          label: 'Pomodoros',
          description: '${snapshot.completedPomodoros} completados',
          value: snapshot.pomodoroProgress,
        ),
        const _MetricDivider(),
        _HorizontalMetricBar(
          label: 'Enfoque',
          description: '${snapshot.focusedMinutes} min enfocados',
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
    final labels = ['Tareas', 'Pom', 'Foco'];

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
          painter: _PerformanceLinePainter(
            palette: context.palette,
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
  });

  factory _PerformanceSnapshot.fromControllers({
    required _PerformanceRange range,
    required int focusMinutes,
    required TasksController tasksController,
    required PomodoroController pomodoroController,
  }) {
    final now = DateTime.now();
    final bounds = _rangeBounds(range, now);
    final tasks = tasksController.tasks.value
        .where((task) {
          final date = task.scheduledDate ?? task.createdAt;
          return !_dateOnly(date).isBefore(bounds.start) &&
              !_dateOnly(date).isAfter(bounds.end);
        })
        .toList(growable: false);
    final sessions = pomodoroController.sessions.value
        .where((session) {
          final date = _dateOnly(session.endedAt);
          return !date.isBefore(bounds.start) && !date.isAfter(bounds.end);
        })
        .toList(growable: false);
    final buckets = _bucketStarts(range, bounds.start, bounds.end);
    final taskCounts = [
      for (final bucket in buckets)
        tasks
            .where(
              (task) => _sameBucket(
                range,
                task.scheduledDate ?? task.createdAt,
                bucket,
              ),
            )
            .length,
    ];
    final focusMinutesByBucket = [
      for (final bucket in buckets)
        sessions
                .where((session) => _sameBucket(range, session.endedAt, bucket))
                .fold<int>(
                  0,
                  (total, session) => total + session.focusedSeconds,
                ) ~/
            60,
    ];
    final maxTaskCount = taskCounts.fold<int>(
      1,
      (max, count) => count > max ? count : max,
    );
    final maxFocusMinutes = focusMinutesByBucket.fold<int>(
      1,
      (max, minutes) => minutes > max ? minutes : max,
    );

    return _PerformanceSnapshot(
      range: range,
      focusMinutes: focusMinutes,
      taskSummary: TaskStatusSummary.fromTasks(tasks),
      completedPomodoros: sessions.length,
      focusedSeconds: sessions.fold<int>(
        0,
        (total, session) => total + session.focusedSeconds,
      ),
      bucketValues: [
        for (final count in taskCounts) count / maxTaskCount,
      ],
      focusBucketValues: [
        for (final minutes in focusMinutesByBucket) minutes / maxFocusMinutes,
      ],
      bucketLabels: [
        for (final bucket in buckets) _bucketLabel(range, bucket),
      ],
    );
  }

  final _PerformanceRange range;
  final int focusMinutes;
  final TaskStatusSummary taskSummary;
  final int completedPomodoros;
  final int focusedSeconds;
  final List<double> bucketValues;
  final List<double> focusBucketValues;
  final List<String> bucketLabels;

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
    return switch (range) {
      _PerformanceRange.day => 4,
      _PerformanceRange.week => 12,
      _PerformanceRange.month => 24,
      _PerformanceRange.year => 180,
    };
  }

  int get expectedFocusSeconds => focusMinutes * expectedPomodoros * 60;

  String get summaryLabel {
    return '${taskSummary.total} tareas, $completedPomodoros pomodoros, '
        '$focusedMinutes min de enfoque';
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
                'Rendimiento',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Rendimiento del mes actual',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AppDesignTokens.bodyFontSize,
                ),
              ),
              const SizedBox(height: 16),
              _HorizontalMetricBar(
                label: 'Tareas',
                description:
                    '${taskSummary.total} tareas, ${taskSummary.completed} completadas',
                value: taskProgress,
              ),
              const _MetricDivider(),
              _HorizontalMetricBar(
                label: 'Pomodoros',
                description: '${monthlySessions.length} completados este mes',
                value: pomodoroProgress,
              ),
              const _MetricDivider(),
              _HorizontalMetricBar(
                label: 'Enfoque',
                description: '$focusedMinutes min enfocados',
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

class _TaskStatusOverviewCard extends StatelessWidget {
  const _TaskStatusOverviewCard();

  @override
  Widget build(BuildContext context) {
    final tasksController = serviceLocator<TasksController>();

    return SignalBuilder(
      builder: (context) {
        final summary = tasksController.allTaskSummary.value;

        return GlassCard(
          padding: AppCardPaddings.compact,
          child: Column(
            children: [
              _TaskStatusMetric(
                label: 'Pendientes',
                value: summary.listed,
                icon: Icons.playlist_add_check_rounded,
              ),
              const SizedBox(height: 10),
              _TaskStatusMetric(
                label: 'En progreso',
                value: summary.inProgress,
                icon: Icons.pending_actions_rounded,
              ),
              const SizedBox(height: 10),
              _TaskStatusMetric(
                label: 'Completadas',
                value: summary.completed,
                icon: Icons.task_alt_rounded,
              ),
            ],
          ),
        );
      },
    );
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
                'Rendimiento general',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Promedio de tareas, pomodoros y objetivo diario de enfoque.',
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
            'Descargar estadisticas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: AppDesignTokens.sectionTitleFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<StatisticsReportPeriod>(
            value: _period,
            decoration: const InputDecoration(labelText: 'Periodo'),
            items: const [
              DropdownMenuItem(
                value: StatisticsReportPeriod.day,
                child: Text('Dia'),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.week,
                child: Text('Semana'),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.month,
                child: Text('Mes'),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.year,
                child: Text('Año'),
              ),
              DropdownMenuItem(
                value: StatisticsReportPeriod.range,
                child: Text('Fecha a fecha'),
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
                    child: Text(_from == null ? 'Desde' : _formatDate(_from!)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(isFrom: false),
                    child: Text(_to == null ? 'Hasta' : _formatDate(_to!)),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'El PDF incluye gráficas de rendimiento, estudio vs descanso y porcentaje de avance.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await settings.onDownloadStatisticsPdf(
                  StatisticsReportRequest(
                    period: _period,
                    from: _from,
                    to: _to,
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'PDF guardado en ${settings.lastReportPath}',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
              label: const Text('Descargar PDF'),
            ),
          ),
        ],
      ),
    );
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
                    today.isEnded ? 'Dia finalizado' : 'Meta Diaria',
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
                '$progressLabel% de tareas completadas hoy',
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
                                'Dia terminado con $progressLabel% de avance.',
                              ),
                            ),
                          );
                        },
                  icon: Icon(
                    today.isEnded
                        ? Icons.check_circle_rounded
                        : Icons.outlined_flag_rounded,
                  ),
                  label: Text(today.isEnded ? 'Dia terminado' : 'Terminar dia'),
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
                'Nivel de Energía',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Óptimo', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Basado en tus descansos recientes',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _TodayTasksCard extends StatelessWidget {
  const _TodayTasksCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tareas para Hoy',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(
                        fontSize: AppDesignTokens.sectionTitleFontSize,
                      ),
                ),
              ),
              TextButton(
                onPressed: () => context.go(TasksPage.routePath),
                child: const Text('Ver todas ›'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _TaskTile(
            title: 'Revisión de\ndiseño\nMichiFocus',
            meta: 'Alta prioridad · 2:00\nPM',
            tag: 'Trabajo',
          ),
          const SizedBox(height: 12),
          const _TaskTile(
            title: 'Estirar y\nMeditación',
            meta: 'Salud · 4:30 PM',
            tag: 'Personal',
          ),
          const SizedBox(height: 12),
          const _DoneTile(),
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
            'Progreso Semanal',
            style:
                Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                ),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WeeklyDayProgress(day: 'L', progress: 0.65),
              _WeeklyDayProgress(day: 'M', progress: 0.45),
              _WeeklyDayProgress(day: 'M', progress: 0),
              _WeeklyDayProgress(day: 'J', progress: 0),
              _WeeklyDayProgress(day: 'V', progress: 0),
              _WeeklyDayProgress(day: 'S', progress: 0),
              _WeeklyDayProgress(day: 'D', progress: 0),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Completá bloques de enfoque para llenar tu semana.',
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
                'Progreso Semanal',
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
                      day: _weekdayShortLabel(progress.day),
                      progress: progress.completionRatio,
                      band: progress.band,
                      isEnded: progress.isEnded,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Rojo hasta 20%, amarillo hasta 50%, verde hasta 70%, verde fuerte hasta 100%.',
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

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.title, required this.meta, required this.tag});

  final String title;
  final String meta;
  final String tag;

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
            dimension: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: palette.outlineColor),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(meta, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          _Pill(
            label: tag,
            background: palette.secondarySoft.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}

class _DoneTile extends StatelessWidget {
  const _DoneTile();

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
          Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: palette.secondary,
          ),
          const SizedBox(width: 14),
          Text(
            'Planificar semana\nCompletada',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.background});

  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: context.palette.primary),
      ),
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

String _weekdayShortLabel(DateTime day) {
  return switch (day.weekday) {
    DateTime.monday => 'L',
    DateTime.tuesday => 'M',
    DateTime.wednesday => 'X',
    DateTime.thursday => 'J',
    DateTime.friday => 'V',
    DateTime.saturday => 'S',
    DateTime.sunday => 'D',
    _ => '',
  };
}

bool _isInMonth(DateTime date, DateTime month) {
  return date.year == month.year && date.month == month.month;
}

extension on AppPalette {
  Color get outlineColor => neutral.withValues(alpha: 0.55);
}

extension on _PerformanceRange {
  String get titleSuffix {
    return switch (this) {
      _PerformanceRange.day => 'del día',
      _PerformanceRange.week => 'de la semana',
      _PerformanceRange.month => 'del mes',
      _PerformanceRange.year => 'del año',
    };
  }
}

DateTimeRange _rangeBounds(_PerformanceRange range, DateTime now) {
  final today = _dateOnly(now);

  return switch (range) {
    _PerformanceRange.day => DateTimeRange(start: today, end: today),
    _PerformanceRange.week => DateTimeRange(
      start: today.subtract(Duration(days: today.weekday - 1)),
      end: today.add(Duration(days: DateTime.sunday - today.weekday)),
    ),
    _PerformanceRange.month => DateTimeRange(
      start: DateTime(today.year, today.month),
      end: DateTime(today.year, today.month + 1, 0),
    ),
    _PerformanceRange.year => DateTimeRange(
      start: DateTime(today.year),
      end: DateTime(today.year, 12, 31),
    ),
  };
}

List<DateTime> _bucketStarts(
  _PerformanceRange range,
  DateTime start,
  DateTime end,
) {
  return switch (range) {
    _PerformanceRange.day => [
      for (var hour = 6; hour <= 22; hour += 4)
        DateTime(start.year, start.month, start.day, hour),
    ],
    _PerformanceRange.week => [
      for (
        var day = start;
        !day.isAfter(end);
        day = day.add(const Duration(days: 1))
      )
        day,
    ],
    _PerformanceRange.month => [
      DateTime(start.year, start.month),
      DateTime(start.year, start.month, 8),
      DateTime(start.year, start.month, 15),
      DateTime(start.year, start.month, 22),
      DateTime(start.year, start.month, 29),
    ],
    _PerformanceRange.year => [
      for (var month = 1; month <= 12; month += 1) DateTime(start.year, month),
    ],
  };
}

bool _sameBucket(_PerformanceRange range, DateTime date, DateTime bucket) {
  return switch (range) {
    _PerformanceRange.day =>
      _dateOnly(date) == _dateOnly(bucket) &&
          date.hour >= bucket.hour &&
          date.hour < bucket.hour + 4,
    _PerformanceRange.week => _dateOnly(date) == _dateOnly(bucket),
    _PerformanceRange.month =>
      date.year == bucket.year &&
          date.month == bucket.month &&
          ((date.day - 1) ~/ 7) == ((bucket.day - 1) ~/ 7),
    _PerformanceRange.year =>
      date.year == bucket.year && date.month == bucket.month,
  };
}

String _bucketLabel(_PerformanceRange range, DateTime bucket) {
  return switch (range) {
    _PerformanceRange.day => '${bucket.hour}h',
    _PerformanceRange.week => _weekdayShortLabel(bucket),
    _PerformanceRange.month => 'S${((bucket.day - 1) ~/ 7) + 1}',
    _PerformanceRange.year => '${bucket.month}',
  };
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
