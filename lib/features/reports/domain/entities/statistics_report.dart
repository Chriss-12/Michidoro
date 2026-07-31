enum StatisticsReportPeriod { day, week, month, year, range }

enum StatisticsChartType {
  circular('Circular'),
  stackedBars('Barras apiladas'),
  groupedBars('Barras agrupadas'),
  horizontalBars('Gráfico horizontal'),
  standardBars('Gráfico de barras'),
  xy('X/Y');

  const StatisticsChartType(this.label);

  final String label;
}

class StatisticsReportRequest {
  const StatisticsReportRequest({
    required this.period,
    this.from,
    this.to,
    this.anchor,
  });

  final StatisticsReportPeriod period;
  final DateTime? from;
  final DateTime? to;
  final DateTime? anchor;

  String get label {
    return switch (period) {
      StatisticsReportPeriod.day => 'Día',
      StatisticsReportPeriod.week => 'Semana',
      StatisticsReportPeriod.month => 'Mes',
      StatisticsReportPeriod.year => 'Año',
      StatisticsReportPeriod.range => 'Rango personalizado',
    };
  }

  ResolvedStatisticsReportRange resolve(DateTime generatedAt) {
    final today = _dateOnly(anchor ?? generatedAt);

    return switch (period) {
      StatisticsReportPeriod.day => ResolvedStatisticsReportRange(
        period: period,
        start: today,
        end: DateTime(today.year, today.month, today.day + 1),
        generatedAt: generatedAt,
      ),
      StatisticsReportPeriod.week => _resolveWeek(today, generatedAt),
      StatisticsReportPeriod.month => ResolvedStatisticsReportRange(
        period: period,
        start: DateTime(today.year, today.month),
        end: DateTime(today.year, today.month + 1),
        generatedAt: generatedAt,
      ),
      StatisticsReportPeriod.year => ResolvedStatisticsReportRange(
        period: period,
        start: DateTime(today.year),
        end: DateTime(today.year + 1),
        generatedAt: generatedAt,
      ),
      StatisticsReportPeriod.range => _resolveCustom(today, generatedAt),
    };
  }

  ResolvedStatisticsReportRange _resolveWeek(
    DateTime today,
    DateTime generatedAt,
  ) {
    final start = today.subtract(Duration(days: today.weekday - 1));
    return ResolvedStatisticsReportRange(
      period: period,
      start: start,
      end: DateTime(start.year, start.month, start.day + 7),
      generatedAt: generatedAt,
    );
  }

  ResolvedStatisticsReportRange _resolveCustom(
    DateTime fallback,
    DateTime generatedAt,
  ) {
    final first = _dateOnly(from ?? fallback);
    final second = _dateOnly(to ?? from ?? fallback);
    final start = first.isAfter(second) ? second : first;
    final inclusiveEnd = first.isAfter(second) ? first : second;
    final end = DateTime(
      inclusiveEnd.year,
      inclusiveEnd.month,
      inclusiveEnd.day + 1,
    );
    final maximumEnd = DateTime(start.year + 5, start.month, start.day);

    if (end.isAfter(maximumEnd)) {
      throw ArgumentError.value(
        end,
        'to',
        'El rango del reporte no puede superar cinco años.',
      );
    }

    return ResolvedStatisticsReportRange(
      period: period,
      start: start,
      end: end,
      generatedAt: generatedAt,
    );
  }
}

class ResolvedStatisticsReportRange {
  ResolvedStatisticsReportRange({
    required this.period,
    required this.start,
    required this.end,
    required this.generatedAt,
  }) : assert(start.isBefore(end), 'The report range must not be empty.');

  final StatisticsReportPeriod period;
  final DateTime start;
  final DateTime end;
  final DateTime generatedAt;

  bool contains(DateTime value) =>
      !value.isBefore(start) && value.isBefore(end);

  String get label {
    final inclusiveEnd = end.subtract(const Duration(days: 1));
    return switch (period) {
      StatisticsReportPeriod.day => _formatDate(start),
      StatisticsReportPeriod.week || StatisticsReportPeriod.range =>
        '${_formatDate(start)} a ${_formatDate(inclusiveEnd)}',
      StatisticsReportPeriod.month =>
        '${start.year}-${start.month.toString().padLeft(2, '0')}',
      StatisticsReportPeriod.year => '${start.year}',
    };
  }
}

class StatisticsTaskTotals {
  const StatisticsTaskTotals({
    required this.listed,
    required this.inProgress,
    required this.completed,
  });

  final int listed;
  final int inProgress;
  final int completed;

  int get total => listed + inProgress + completed;
  double get completionRatio => total == 0 ? 0 : completed / total;
}

class StatisticsCalendarDay {
  const StatisticsCalendarDay({
    required this.day,
    required this.completionRatio,
    required this.isEnded,
    required this.totalTasks,
    this.completedPomodoros = 0,
    this.focusedSeconds = 0,
  });

  final DateTime day;
  final double completionRatio;
  final bool isEnded;
  final int totalTasks;
  final int completedPomodoros;
  final int focusedSeconds;
}

class StatisticsReportData {
  const StatisticsReportData({
    required this.range,
    required this.tasks,
    required this.calendarDays,
    required this.completedPomodoros,
    required this.focusedSeconds,
    this.createdTasks = const StatisticsTaskTotals(
      listed: 0,
      inProgress: 0,
      completed: 0,
    ),
    this.completionEvents = 0,
    this.legacyUnknownCompletions = 0,
    this.moodAverage,
    this.moodSampleCount = 0,
    this.distractionMinutes = 0,
  });

  final ResolvedStatisticsReportRange range;

  /// Current status of tasks planned inside the selected range.
  final StatisticsTaskTotals tasks;

  /// Current status of tasks created inside the selected range.
  final StatisticsTaskTotals createdTasks;
  final List<StatisticsCalendarDay> calendarDays;
  final int completedPomodoros;
  final int focusedSeconds;
  final int completionEvents;
  final int legacyUnknownCompletions;
  final double? moodAverage;
  final int moodSampleCount;
  final int distractionMinutes;

  DateTime get generatedAt => range.generatedAt;
  int get focusedMinutes => focusedSeconds ~/ 60;
  int get progressPercent => (tasks.completionRatio * 100).round();
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
