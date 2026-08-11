import 'dart:convert';
import 'dart:math' as math;

import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_document.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_document_renderer.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';

class RawStatisticsPdfRenderer implements StatisticsReportDocumentRenderer {
  const RawStatisticsPdfRenderer();

  @override
  List<int> render(StatisticsReportDocument document) {
    final isEnglish = document.language == AppLanguage.english;
    String t(String spanish, String english) => isEnglish ? english : spanish;
    final writer = _PdfPageWriter(isEnglish: isEnglish);
    final data = document.data;
    final owner = document.profileName.trim().isEmpty
        ? t('Usuario', 'User')
        : document.profileName.trim();
    final email = document.profileEmail.trim().isEmpty
        ? t('Sin correo configurado', 'No email configured')
        : document.profileEmail.trim();
    final mood = data.moodAverage == null
        ? t('Sin datos', 'No data')
        : '${data.moodAverage!.toStringAsFixed(1)}/5 '
              '(${data.moodSampleCount} ${t('sesiones', 'sessions')})';
    final taskStatusLine =
        '${t('Pendientes', 'Pending')}: ${data.tasks.listed} | '
        '${t('En progreso', 'In progress')}: ${data.tasks.inProgress} | '
        '${t('Completadas', 'Completed')}: ${data.tasks.completed}';
    final completionLine =
        '${t('Finalizaciones registradas', 'Recorded completions')}: '
        '${data.completionEvents} | '
        '${t('Historial legacy sin fecha', 'Undated legacy history')}: '
        '${data.legacyUnknownCompletions}';
    final pomodoroLine =
        'Pomodoros: ${data.completedPomodoros} | '
        '${t('Minutos enfocados', 'Focused minutes')}: ${data.focusedMinutes}';
    final moodLine =
        '${t('Ánimo promedio en tareas', 'Average mood during tasks')}: $mood | '
        '${t('Distracciones', 'Distractions')}: '
        '${data.distractionMinutes} min';

    writer
      ..addHeader(document.title, '$owner | $email')
      ..addText(
        '${t('Periodo', 'Period')}: ${document.periodLabel} | '
        '${t('Rango', 'Range')}: ${_rangeLabel(data.range, isEnglish)}',
        fontSize: 11,
        bold: true,
      )
      ..addText(
        '${t('Generado', 'Generated')}: ${_formatDateTime(data.generatedAt)}',
        fontSize: 9,
        color: _muted,
      )
      ..addGap(10)
      ..addPanel([
        '${t('Tareas planificadas del periodo', 'Tasks planned in period')}: ${data.tasks.total}',
        taskStatusLine,
        '${t('Tareas creadas en el periodo', 'Tasks created in period')}: ${data.createdTasks.total}',
        completionLine,
        pomodoroLine,
        moodLine,
      ])
      ..addText(
        '${t('Gráficos incluidos', 'Included charts')}: '
        '${document.enabledCharts.map((chart) => _chartLabel(chart, isEnglish)).join(', ')}',
        fontSize: 9,
        color: _muted,
      );

    if (document.enabledCharts.contains(StatisticsChartType.circular)) {
      writer
        ..addSection(t('Avance actual de tareas', 'Current task progress'))
        ..addBar(
          label: '${data.progressPercent}% ${t('completado', 'completed')}',
          value: data.tasks.completionRatio,
          color: _green,
        );
    }

    if (document.enabledCharts.intersection({
      StatisticsChartType.stackedBars,
      StatisticsChartType.horizontalBars,
      StatisticsChartType.standardBars,
    }).isNotEmpty) {
      final total = math.max(data.tasks.total, 1);
      writer
        ..addSection(t('Estado actual de tareas', 'Current task status'))
        ..addBar(
          label: '${t('Pendientes', 'Pending')}: ${data.tasks.listed}',
          value: data.tasks.listed / total,
          color: _red,
        )
        ..addBar(
          label: '${t('En progreso', 'In progress')}: ${data.tasks.inProgress}',
          value: data.tasks.inProgress / total,
          color: _yellow,
        )
        ..addBar(
          label: '${t('Completadas', 'Completed')}: ${data.tasks.completed}',
          value: data.tasks.completed / total,
          color: _green,
        );
    }

    if (document.enabledCharts.contains(StatisticsChartType.groupedBars)) {
      final maximum = math.max(
        math.max(data.focusedMinutes, data.completedPomodoros),
        1,
      );
      writer
        ..addSection(t('Foco y finalización', 'Focus and completion'))
        ..addBar(
          label:
              '${data.focusedMinutes} ${t('minutos de foco', 'focus minutes')}',
          value: data.focusedMinutes / maximum,
          color: _ink,
        )
        ..addBar(
          label: '${data.completedPomodoros} Pomodoros',
          value: data.completedPomodoros / maximum,
          color: _green,
        );
    }

    if (document.enabledCharts.contains(StatisticsChartType.xy)) {
      writer.addSection(
        t(
          'Estado actual por fecha planificada',
          'Current status by planned date',
        ),
      );
      for (final bucket in data.calendarDays) {
        writer.addTrend(
          label: _formatBucket(bucket.day, data.range.period),
          percent: (bucket.completionRatio * 100).round(),
          totalTasks: bucket.totalTasks,
          value: bucket.completionRatio,
        );
      }
    }

    final routines = data.routines;
    if (routines != null) {
      final consistency = routines.consistency;
      final delay = routines.averageStartDelayMinutes;
      final routineMood = routines.moodAverage;
      final abandonment = routines.typicalAbandonmentItem;

      writer.addSection(t('Constancia de rutinas', 'Routine consistency'));
      if (consistency == null) {
        writer.addText(
          t(
            'Sin datos: el período no contiene actividades obligatorias.',
            'No data: this period contains no required activities.',
          ),
          color: _muted,
        );
      } else {
        final consistencyPercent = (consistency * 100).round();
        writer.addBar(
          label: t(
            '$consistencyPercent% · ${routines.completedRequiredItems} de ${routines.requiredItems} actividades obligatorias',
            '$consistencyPercent% · ${routines.completedRequiredItems} of ${routines.requiredItems} required activities',
          ),
          value: consistency,
          color: _green,
        );
      }
      writer.addPanel([
        t(
          'Rutinas: ${routines.completedRuns} completadas | ${routines.inProgressRuns} en progreso | ${routines.skippedRuns} omitidas | ${routines.missedRuns} perdidas',
          'Routines: ${routines.completedRuns} completed | ${routines.inProgressRuns} in progress | ${routines.skippedRuns} skipped | ${routines.missedRuns} missed',
        ),
        t(
          'Actividades: ${routines.scheduledItems} programadas | ${routines.inProgressItems} en progreso | ${routines.completedItems} completadas',
          'Activities: ${routines.scheduledItems} scheduled | ${routines.inProgressItems} in progress | ${routines.completedItems} completed',
        ),
        t(
          'Actividades omitidas / perdidas: ${routines.skippedItems} / ${routines.missedItems}',
          'Skipped / missed activities: ${routines.skippedItems} / ${routines.missedItems}',
        ),
        t(
          'Foco planificado / real: ${routines.plannedFocusMinutes} / ${routines.focusedMinutes} min',
          'Planned / actual focus: ${routines.plannedFocusMinutes} / ${routines.focusedMinutes} min',
        ),
        t(
          'Retraso promedio: ${delay == null ? 'Sin datos' : '${delay.toStringAsFixed(1)} min'} (${routines.startDelaySampleCount} muestras)',
          'Average delay: ${delay == null ? 'No data' : '${delay.toStringAsFixed(1)} min'} (${routines.startDelaySampleCount} samples)',
        ),
        t(
          'Ánimo promedio: ${routineMood == null ? 'Sin datos' : '${routineMood.toStringAsFixed(1)}/5'} (${routines.moodSampleCount} muestras)',
          'Average mood: ${routineMood == null ? 'No data' : '${routineMood.toStringAsFixed(1)}/5'} (${routines.moodSampleCount} samples)',
        ),
        t(
          'Mejor racha por rutina: ${routines.longestCompletedStreak} días',
          'Best streak by routine: ${routines.longestCompletedStreak} days',
        ),
        if (abandonment != null)
          t(
            'Abandono más frecuente: $abandonment (${routines.typicalAbandonmentCount})',
            'Most frequent abandonment: $abandonment (${routines.typicalAbandonmentCount})',
          ),
      ]);

      if (routines.byRoutine.isNotEmpty) {
        writer.addSection(t('Detalle por rutina', 'Breakdown by routine'));
        for (final routine in routines.byRoutine) {
          final routineConsistency = routine.consistency;
          if (routineConsistency == null) {
            writer.addText(
              t(
                '${routine.name}: sin actividades obligatorias',
                '${routine.name}: no required activities',
              ),
              color: _muted,
            );
          } else {
            writer.addBar(
              label: t(
                '${routine.name}: ${routine.completedRequiredItems}/${routine.requiredItems} obligatorias',
                '${routine.name}: ${routine.completedRequiredItems}/${routine.requiredItems} required',
              ),
              value: routineConsistency,
              color: _ink,
            );
          }
        }
      }
    }

    writer
      ..addSection(t('Recomendación', 'Recommendation'))
      ..addText(_coachingPhrase(data.tasks.completionRatio, isEnglish));

    return _buildPdf(writer.finish());
  }

  String _formatBucket(DateTime date, StatisticsReportPeriod period) {
    if (period == StatisticsReportPeriod.day) {
      return '${date.hour.toString().padLeft(2, '0')}:00';
    }
    if (period == StatisticsReportPeriod.year) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}';
    }
    return _formatDate(date);
  }

  String _coachingPhrase(double ratio, bool isEnglish) {
    if (ratio <= 0.2) {
      return isEnglish
          ? 'Start small: choose one pending task and protect your next focus block.'
          : 'Empieza pequeño: elige una tarea pendiente y protege el siguiente bloque de foco.';
    }
    if (ratio <= 0.5) {
      return isEnglish
          ? 'Good progress: keep one task in progress and finish it before adding more work.'
          : 'Buen avance: mantén una tarea en progreso y ciérrala antes de sumar más trabajo.';
    }
    if (ratio <= 0.7) {
      return isEnglish
          ? 'Solid progress: your plan works; now finish the highest-value task.'
          : 'Progreso sólido: tu plan funciona; ahora cierra la tarea de mayor valor.';
    }
    return isEnglish
        ? 'Excellent pace: keep it up and schedule a recovery break.'
        : 'Excelente ritmo: conserva este paso y programa una pausa de recuperación.';
  }
}

class _PdfPageWriter {
  _PdfPageWriter({required this.isEnglish}) {
    _newPage();
  }

  final bool isEnglish;

  static const _pageWidth = 612.0;
  static const _pageHeight = 792.0;
  static const _margin = 44.0;
  static const _bottom = 62.0;

  final List<StringBuffer> _pages = [];
  late StringBuffer _page;
  var _y = 680.0;

  void addHeader(String title, String profile) {
    final titleLines = _wrap(title, 524, 19);
    final profileLines = _wrap(profile, 524, 10);
    final headerHeight =
        24 + titleLines.length * 23 + profileLines.length * 14 + 18;
    final headerBottom = _pageHeight - headerHeight;
    _page
      ..writeln(
        '${_rgb(_darkGreen)} 0 $headerBottom 612 $headerHeight re f',
      )
      ..writeln('${_rgb(_green)} 0 ${headerBottom - 8} 612 8 re f');
    _writeWrapped(
      title,
      x: 44,
      y: _pageHeight - 36,
      width: 524,
      fontSize: 19,
      color: _white,
      bold: true,
      advanceCursor: false,
    );
    _writeWrapped(
      profile,
      x: 44,
      y: _pageHeight - 36 - titleLines.length * 23,
      width: 524,
      fontSize: 10,
      color: _white,
      advanceCursor: false,
    );
    _y = headerBottom - 24;
  }

  void addText(
    String text, {
    double fontSize = 10,
    bool bold = false,
    _PdfColor color = _ink,
  }) {
    final lines = _wrap(text, 524, fontSize);
    _ensure(lines.length * (fontSize + 4) + 4);
    _writeWrapped(
      text,
      x: _margin,
      y: _y,
      width: 524,
      fontSize: fontSize,
      color: color,
      bold: bold,
    );
  }

  void addGap(double height) {
    _ensure(height);
    _y -= height;
  }

  void addSection(String title) {
    _ensure(36);
    _y -= 10;
    _writeLine(
      title,
      x: _margin,
      y: _y,
      fontSize: 14,
      color: _ink,
      bold: true,
    );
    _y -= 24;
  }

  void addPanel(List<String> lines) {
    final wrapped = [
      for (final line in lines) ..._wrap(line, 496, 10),
    ];
    final height = wrapped.length * 15 + 20;
    _ensure(height + 8);
    _page
      ..writeln('${_rgb(_white)} 38 ${_y - height + 8} 536 $height re f')
      ..writeln('${_stroke(_border)} 38 ${_y - height + 8} 536 $height re S');
    var lineY = _y - 10;
    for (final line in wrapped) {
      _writeLine(line, x: 52, y: lineY, fontSize: 10, color: _ink);
      lineY -= 15;
    }
    _y -= height;
  }

  void addBar({
    required String label,
    required double value,
    required _PdfColor color,
  }) {
    _ensure(34);
    final normalized = value.clamp(0.0, 1.0);
    _writeLine(label, x: _margin, y: _y, fontSize: 10, color: _ink);
    _page
      ..writeln('${_rgb(_track)} 260 ${_y - 4} 280 10 re f')
      ..writeln(
        '${_rgb(color)} 260 ${_y - 4} ${(normalized * 280).toStringAsFixed(1)} 10 re f',
      );
    _y -= 28;
  }

  void addTrend({
    required String label,
    required int percent,
    required int totalTasks,
    required double value,
  }) {
    _ensure(24);
    _writeLine(
      '$label: $percent% | $totalTasks ${isEnglish ? 'tasks' : 'tareas'}',
      x: _margin,
      y: _y,
      fontSize: 9,
      color: _ink,
    );
    _page
      ..writeln('${_rgb(_track)} 350 ${_y - 3} 190 8 re f')
      ..writeln(
        '${_rgb(_green)} 350 ${_y - 3} ${(value.clamp(0.0, 1.0) * 190).toStringAsFixed(1)} 8 re f',
      );
    _y -= 20;
  }

  List<String> finish() {
    for (var index = 0; index < _pages.length; index++) {
      final pageNumber = index + 1;
      _pages[index]
        ..writeln('${_stroke(_border)} 44 46 524 0 re S')
        ..writeln(
          'BT /F1 8 Tf ${_rgb(_muted)} 44 32 Td '
          '(MichiFocus | ${isEnglish ? 'Page' : 'Página'} $pageNumber '
          '${isEnglish ? 'of' : 'de'} ${_pages.length}) Tj ET',
        );
    }
    return _pages.map((page) => page.toString()).toList(growable: false);
  }

  void _ensure(double requiredHeight) {
    if (_y - requiredHeight >= _bottom) {
      return;
    }
    _newPage();
  }

  void _newPage() {
    _page = StringBuffer()
      ..writeln('${_rgb(_background)} 0 0 $_pageWidth $_pageHeight re f');
    _pages.add(_page);
    _y = 730;
  }

  void _writeWrapped(
    String text, {
    required double x,
    required double y,
    required double width,
    required double fontSize,
    required _PdfColor color,
    bool bold = false,
    bool advanceCursor = true,
  }) {
    final lines = _wrap(text, width, fontSize);
    var lineY = y;
    for (final line in lines) {
      _writeLine(
        line,
        x: x,
        y: lineY,
        fontSize: fontSize,
        color: color,
        bold: bold,
      );
      lineY -= fontSize + 4;
    }
    if (advanceCursor) {
      _y = lineY - 2;
    }
  }

  void _writeLine(
    String text, {
    required double x,
    required double y,
    required double fontSize,
    required _PdfColor color,
    bool bold = false,
  }) {
    final font = bold ? 'F2' : 'F1';
    _page.writeln(
      'BT /$font $fontSize Tf ${_rgb(color)} $x $y Td (${_pdfText(text)}) Tj ET',
    );
  }

  List<String> _wrap(String text, double width, double fontSize) {
    final maxCharacters = math.max(1, (width / (fontSize * 0.52)).floor());
    final words = text.trim().split(RegExp(r'\s+'));
    final lines = <String>[];
    var current = '';

    for (final word in words) {
      if (word.length > maxCharacters) {
        if (current.isNotEmpty) {
          lines.add(current);
          current = '';
        }
        for (var offset = 0; offset < word.length; offset += maxCharacters) {
          lines.add(
            word.substring(
              offset,
              math.min(offset + maxCharacters, word.length),
            ),
          );
        }
        continue;
      }
      final candidate = current.isEmpty ? word : '$current $word';
      if (candidate.length <= maxCharacters) {
        current = candidate;
      } else {
        lines.add(current);
        current = word;
      }
    }
    if (current.isNotEmpty) {
      lines.add(current);
    }
    return lines.isEmpty ? [''] : lines;
  }
}

List<int> _buildPdf(List<String> streams) {
  final pageReferences = [
    for (var index = 0; index < streams.length; index++) 5 + index * 2,
  ];
  final objects = <String>[
    '1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n',
    '2 0 obj << /Type /Pages /Kids [${pageReferences.map((id) => '$id 0 R').join(' ')}] /Count ${streams.length} >> endobj\n',
    '3 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >> endobj\n',
    '4 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >> endobj\n',
  ];

  for (var index = 0; index < streams.length; index++) {
    final pageId = 5 + index * 2;
    final contentId = pageId + 1;
    final stream = streams[index];
    objects
      ..add(
        '$pageId 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /Contents $contentId 0 R >> endobj\n',
      )
      ..add(
        '$contentId 0 obj << /Length ${latin1.encode(stream).length} >> stream\n$stream\nendstream endobj\n',
      );
  }

  final buffer = StringBuffer('%PDF-1.4\n');
  final offsets = <int>[0];
  var length = latin1.encode(buffer.toString()).length;
  for (final object in objects) {
    offsets.add(length);
    buffer.write(object);
    length += latin1.encode(object).length;
  }
  final xrefOffset = length;
  buffer
    ..writeln('xref')
    ..writeln('0 ${objects.length + 1}')
    ..writeln('0000000000 65535 f ');
  for (final offset in offsets.skip(1)) {
    buffer.writeln('${offset.toString().padLeft(10, '0')} 00000 n ');
  }
  buffer
    ..writeln('trailer << /Size ${objects.length + 1} /Root 1 0 R >>')
    ..writeln('startxref')
    ..writeln(xrefOffset)
    ..write('%%EOF');
  return latin1.encode(buffer.toString());
}

String _pdfText(String value) {
  final latin = String.fromCharCodes(
    value.codeUnits.map((unit) => unit <= 255 ? unit : 63),
  );
  return latin
      .replaceAll(r'\', r'\\')
      .replaceAll('(', r'\(')
      .replaceAll(')', r'\)');
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _formatDateTime(DateTime date) {
  final time =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  return '${_formatDate(date)} $time';
}

String _rangeLabel(ResolvedStatisticsReportRange range, bool isEnglish) {
  if (!isEnglish ||
      range.period == StatisticsReportPeriod.day ||
      range.period == StatisticsReportPeriod.month ||
      range.period == StatisticsReportPeriod.year) {
    return range.label;
  }

  final inclusiveEnd = range.end.subtract(const Duration(days: 1));
  return '${_formatDate(range.start)} to ${_formatDate(inclusiveEnd)}';
}

String _chartLabel(StatisticsChartType chart, bool isEnglish) {
  if (!isEnglish) {
    return chart.label;
  }

  return switch (chart) {
    StatisticsChartType.circular => 'Circular',
    StatisticsChartType.stackedBars => 'Stacked bars',
    StatisticsChartType.groupedBars => 'Grouped bars',
    StatisticsChartType.horizontalBars => 'Horizontal chart',
    StatisticsChartType.standardBars => 'Bar chart',
    StatisticsChartType.xy => 'X/Y',
  };
}

String _rgb(_PdfColor color) => '${color.r} ${color.g} ${color.b} rg';
String _stroke(_PdfColor color) => '${color.r} ${color.g} ${color.b} RG';

class _PdfColor {
  const _PdfColor(this.r, this.g, this.b);

  final double r;
  final double g;
  final double b;
}

const _background = _PdfColor(0.96, 0.97, 0.94);
const _white = _PdfColor(1, 1, 1);
const _ink = _PdfColor(0.18, 0.13, 0.09);
const _muted = _PdfColor(0.38, 0.40, 0.37);
const _border = _PdfColor(0.75, 0.78, 0.73);
const _track = _PdfColor(0.88, 0.88, 0.84);
const _darkGreen = _PdfColor(0.10, 0.18, 0.16);
const _green = _PdfColor(0.10, 0.56, 0.33);
const _yellow = _PdfColor(0.89, 0.70, 0.25);
const _red = _PdfColor(0.90, 0.32, 0.32);
