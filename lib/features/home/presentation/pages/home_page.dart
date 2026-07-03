import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

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
        const _PerformanceInsightsCard(),
        const SizedBox(height: 18),
        const _PerformanceHistoryCard(),
        const SizedBox(height: 18),
        const _StatisticsDownloadCard(),
        const SizedBox(height: 18),
        const _DailyGoalCard(),
        const SizedBox(height: 18),
        const _EnergyCard(),
        const SizedBox(height: 18),
        const _TodayTasksCard(),
        const SizedBox(height: 18),
        const _WeeklyProgressCard(),
      ],
    );
  }
}

enum _PerformanceRange { day, week, month }

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
            child: CustomPaint(
              painter: _PerformanceLinePainter(
                palette: palette,
                values: values,
                labels: _labels[_range]!,
              ),
              child: const SizedBox.expand(),
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

extension on _PerformanceRange {
  String get label {
    return switch (this) {
      _PerformanceRange.day => 'Día',
      _PerformanceRange.week => 'Semana',
      _PerformanceRange.month => 'Mes',
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
        oldDelegate.values != values ||
        oldDelegate.labels != labels;
  }
}

class _PerformanceInsightsCard extends StatelessWidget {
  const _PerformanceInsightsCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final taskProgress = settings.totalTasks == 0
        ? 0.0
        : (settings.completedTasks / settings.totalTasks).clamp(0.0, 1.0);
    final pomodoroProgress = (settings.completedPomodoros / 6).clamp(0.0, 1.0);
    final focusGoalSeconds = settings.focusMinutes * 6 * 60;
    final focusProgress = focusGoalSeconds == 0
        ? 0.0
        : (settings.totalFocusSeconds / focusGoalSeconds).clamp(0.0, 1.0);
    final overallProgress =
        (taskProgress + pomodoroProgress + focusProgress) / 3;
    final focusedMinutes = settings.totalFocusSeconds ~/ 60;

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
            'Avance por dia, semana y mes',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: AppDesignTokens.bodyFontSize,
            ),
          ),
          const SizedBox(height: 16),
          _HorizontalMetricBar(
            label: 'Tareas',
            description:
                '${settings.completedTasks}/${settings.totalTasks} completadas',
            value: taskProgress,
          ),
          const _MetricDivider(),
          _HorizontalMetricBar(
            label: 'Pomodoros',
            description: '${settings.completedPomodoros}/6 bloques',
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

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SoftIcon(
                icon: Icons.track_changes_rounded,
                color: palette.secondary,
              ),
              const Spacer(),
              Text(
                'Meta Diaria',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('4 / 6', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Bloques de enfoque completados',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 4 / 6,
            minHeight: 5,
            borderRadius: BorderRadius.circular(99),
            color: palette.secondarySoft,
            backgroundColor: palette.primaryMuted,
          ),
        ],
      ),
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

extension on AppPalette {
  Color get outlineColor => neutral.withValues(alpha: 0.55);
}
