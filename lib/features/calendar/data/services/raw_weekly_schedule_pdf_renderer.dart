import 'dart:convert';
import 'dart:math' as math;

import 'package:pomodoro_app_v1/features/calendar/domain/entities/weekly_schedule_export_document.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_identity_color.dart';

class RawWeeklySchedulePdfRenderer {
  const RawWeeklySchedulePdfRenderer();

  static const _pageWidth = 792.0;
  static const _pageHeight = 612.0;
  static const _margin = 24.0;
  static const _ink = _PdfColor(36, 40, 46);
  static const _muted = _PdfColor(92, 101, 112);
  static const _line = _PdfColor(206, 211, 218);
  static const _paper = _PdfColor(255, 255, 255);
  static const _soft = _PdfColor(244, 246, 248);

  List<int> render(WeeklyScheduleExportDocument document) {
    final canvas = _PdfCanvas();
    final t = document.isEnglish
        ? const _PdfLabels.english()
        : const _PdfLabels.spanish();
    final activities = [...document.activities]
      ..sort((first, second) {
        final byDate = first.localDate.compareTo(second.localDate);
        return byDate != 0
            ? byDate
            : first.startMinute.compareTo(second.startMinute);
      });

    canvas
      ..rect(0, 0, _pageWidth, _pageHeight, fill: _paper)
      ..text(
        _margin,
        580,
        t.title,
        size: 20,
        bold: true,
        color: _ink,
      )
      ..text(
        _margin,
        560,
        '${_date(document.weekStart)} - ${_date(document.weekEnd)}',
        size: 10,
        bold: true,
        color: _muted,
      )
      ..text(
        _pageWidth - _margin - 190,
        560,
        '${t.generated}: ${_dateTime(document.generatedAt)}',
        size: 8,
        color: _muted,
      );

    _drawGoals(canvas, document, t);
    _drawSchedule(canvas, document, activities, t);

    canvas
      ..text(
        _margin,
        20,
        '${t.legend}: ${t.pending} / ${t.inProgress} / ${t.completed} / '
        '${t.skipped} / ${t.missed} | ! ${t.overlap}',
        size: 7,
        color: _muted,
      )
      ..text(
        _pageWidth - _margin - 116,
        20,
        'Michi Focus',
        size: 8,
        bold: true,
        color: _ink,
      );

    return canvas.buildLandscapeLetterPdf();
  }

  void _drawGoals(
    _PdfCanvas canvas,
    WeeklyScheduleExportDocument document,
    _PdfLabels labels,
  ) {
    const left = _margin;
    const bottom = 506.0;
    const height = 40.0;
    const width = _pageWidth - _margin * 2;
    canvas
      ..rect(left, bottom, width, height, fill: _soft, stroke: _line)
      ..text(
        left + 8,
        bottom + 26,
        labels.goals,
        size: 9,
        bold: true,
        color: _ink,
      );

    if (document.goals.isEmpty) {
      canvas.text(
        left + 96,
        bottom + 26,
        labels.noGoals,
        size: 8,
        color: _muted,
      );
      return;
    }

    final visibleGoals = document.goals.take(4).toList(growable: false);
    const goalsLeft = left + 96;
    final cardWidth = (width - 104) / visibleGoals.length;
    for (var index = 0; index < visibleGoals.length; index++) {
      final goal = visibleGoals[index];
      final x = goalsLeft + index * cardWidth;
      final remaining = document.goals.length - visibleGoals.length;
      final suffix = index == visibleGoals.length - 1 && remaining > 0
          ? '  +$remaining'
          : '';
      canvas
        ..text(
          x,
          bottom + 26,
          _fit('${goal.title}$suffix', cardWidth - 8, 8),
          size: 8,
          bold: true,
          color: _ink,
        )
        ..text(
          x,
          bottom + 12,
          '${_shortDate(goal.targetDate)} | '
          '${goal.completedTasks}/${goal.totalTasks} ${labels.tasks}',
          size: 7,
          color: _muted,
        );
    }
  }

  void _drawSchedule(
    _PdfCanvas canvas,
    WeeklyScheduleExportDocument document,
    List<WeeklyScheduleExportActivity> activities,
    _PdfLabels labels,
  ) {
    const left = _margin;
    const right = _pageWidth - _margin;
    const bottom = 38.0;
    const top = 496.0;
    const headerHeight = 28.0;
    const timeWidth = 40.0;
    const daysWidth = right - left - timeWidth;
    const dayWidth = daysWidth / 7;
    final earliest = activities.isEmpty
        ? 6 * 60
        : activities.map((item) => item.startMinute).reduce(math.min);
    final latest = activities.isEmpty
        ? 22 * 60
        : activities.map((item) => item.endMinute).reduce(math.max);
    final firstHour = math.min(6, earliest ~/ 60).clamp(0, 23);
    final lastHour = math.max(22, (latest + 59) ~/ 60).clamp(firstHour + 1, 24);
    const gridTop = top - headerHeight;
    const gridHeight = gridTop - bottom;
    final hourHeight = gridHeight / (lastHour - firstHour);

    canvas
      ..rect(left, bottom, right - left, top - bottom, stroke: _line)
      ..rect(left, gridTop, right - left, headerHeight, fill: _soft)
      ..text(
        left + 7,
        gridTop + 10,
        labels.time,
        size: 7,
        bold: true,
        color: _muted,
      );

    for (var dayIndex = 0; dayIndex < 7; dayIndex++) {
      final day = document.weekStart.add(Duration(days: dayIndex));
      final x = left + timeWidth + dayIndex * dayWidth;
      canvas
        ..line(x, bottom, x, top, color: _line)
        ..text(
          x + 5,
          gridTop + 16,
          '${labels.weekdays[dayIndex]} ${day.day}',
          size: 8,
          bold: true,
          color: _ink,
        );
    }

    for (var hour = firstHour; hour <= lastHour; hour++) {
      final y = gridTop - (hour - firstHour) * hourHeight;
      canvas
        ..line(left + timeWidth, y, right, y, color: _line, width: 0.45)
        ..text(
          left + 4,
          y - 3,
          '${hour.toString().padLeft(2, '0')}:00',
          size: 6.5,
          color: _muted,
        );
    }

    for (var dayIndex = 0; dayIndex < 7; dayIndex++) {
      final day = document.weekStart.add(Duration(days: dayIndex));
      final dayActivities = activities
          .where((activity) => _sameDate(activity.localDate, day))
          .toList(growable: false);
      final layouts = _layout(dayActivities);
      for (final layout in layouts) {
        final activity = layout.activity;
        final laneWidth = (dayWidth - 4) / layout.laneCount;
        final x =
            left +
            timeWidth +
            dayIndex * dayWidth +
            2 +
            layout.lane * laneWidth;
        final start = activity.startMinute.clamp(firstHour * 60, 24 * 60);
        final end = activity.endMinute.clamp(start + 1, 24 * 60);
        final activityTop =
            gridTop - (start - firstHour * 60) / 60 * hourHeight;
        final activityBottom =
            gridTop - (end - firstHour * 60) / 60 * hourHeight;
        final height = math
            .max(13, activityTop - activityBottom - 1.5)
            .toDouble();
        final base = _activityColor(activity);
        final fill = base.mix(_paper, 0.78);
        final border = activity.hasOverlap ? _ink : base;
        final blockWidth = laneWidth - 2;
        final labelWidth = math.max(10, blockWidth - 6).toDouble();
        canvas
          ..rect(
            x,
            activityTop - height,
            blockWidth,
            height,
            fill: fill,
            stroke: border,
            strokeWidth: activity.hasOverlap ? 1.2 : 0.75,
          )
          ..text(
            x + 3,
            activityTop - 8,
            _fit(activity.title, labelWidth, 6.4),
            size: 6.4,
            bold: true,
            color: _ink,
          );
        if (height >= 23) {
          canvas.text(
            x + 3,
            activityTop - 16,
            _fit(activity.routineName, labelWidth, 5.5),
            size: 5.5,
            color: _muted,
          );
        }
        if (height >= 32) {
          canvas.text(
            x + 3,
            activityTop - 24,
            _fit(
              '${_minute(activity.startMinute)}-${_minute(math.min(activity.endMinute, 24 * 60))} '
              '${activity.statusLabel}${activity.hasOverlap ? ' !' : ''}',
              labelWidth,
              5.2,
            ),
            size: 5.2,
            color: _ink,
          );
        }
      }
    }
  }
}

class _PdfLabels {
  const _PdfLabels.spanish()
    : title = 'Horario semanal de rutinas',
      generated = 'Generado',
      goals = 'OBJETIVOS',
      noGoals = 'Sin objetivos fechados esta semana',
      tasks = 'tareas',
      time = 'HORA',
      legend = 'Estados',
      pending = 'Pendiente',
      inProgress = 'En curso',
      completed = 'Hecha',
      skipped = 'Omitida',
      missed = 'Perdida',
      overlap = 'superposición',
      weekdays = const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  const _PdfLabels.english()
    : title = 'Weekly routine schedule',
      generated = 'Generated',
      goals = 'GOALS',
      noGoals = 'No dated goals this week',
      tasks = 'tasks',
      time = 'TIME',
      legend = 'Status',
      pending = 'Pending',
      inProgress = 'In progress',
      completed = 'Completed',
      skipped = 'Skipped',
      missed = 'Missed',
      overlap = 'overlap',
      weekdays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final String title;
  final String generated;
  final String goals;
  final String noGoals;
  final String tasks;
  final String time;
  final String legend;
  final String pending;
  final String inProgress;
  final String completed;
  final String skipped;
  final String missed;
  final String overlap;
  final List<String> weekdays;
}

class _ActivityLayout {
  const _ActivityLayout(this.activity, this.lane, this.laneCount);

  final WeeklyScheduleExportActivity activity;
  final int lane;
  final int laneCount;
}

List<_ActivityLayout> _layout(List<WeeklyScheduleExportActivity> source) {
  final sorted = [...source]
    ..sort((first, second) => first.startMinute.compareTo(second.startMinute));
  final result = <_ActivityLayout>[];
  var cursor = 0;
  while (cursor < sorted.length) {
    var groupEnd = sorted[cursor].endMinute;
    var limit = cursor + 1;
    while (limit < sorted.length && sorted[limit].startMinute < groupEnd) {
      groupEnd = math.max(groupEnd, sorted[limit].endMinute);
      limit++;
    }
    final laneEnds = <int>[];
    final assignments = <(WeeklyScheduleExportActivity, int)>[];
    for (final activity in sorted.sublist(cursor, limit)) {
      var lane = laneEnds.indexWhere((end) => end <= activity.startMinute);
      if (lane < 0) {
        lane = laneEnds.length;
        laneEnds.add(activity.endMinute);
      } else {
        laneEnds[lane] = activity.endMinute;
      }
      assignments.add((activity, lane));
    }
    for (final assignment in assignments) {
      result.add(
        _ActivityLayout(assignment.$1, assignment.$2, laneEnds.length),
      );
    }
    cursor = limit;
  }
  return result;
}

class _PdfCanvas {
  final StringBuffer _content = StringBuffer();

  void text(
    double x,
    double y,
    String value, {
    required double size,
    required _PdfColor color,
    bool bold = false,
  }) {
    _content.writeln(
      'BT /${bold ? 'F2' : 'F1'} ${_number(size)} Tf '
      '${color.command} ${_number(x)} ${_number(y)} Td '
      '(${_pdfText(value)}) Tj ET',
    );
  }

  void rect(
    double x,
    double y,
    double width,
    double height, {
    _PdfColor? fill,
    _PdfColor? stroke,
    double strokeWidth = 0.7,
  }) {
    _content.write('q ');
    if (fill != null) _content.write('${fill.command} ');
    if (stroke != null) _content.write('${stroke.strokeCommand} ');
    _content
      ..write('${_number(strokeWidth)} w ')
      ..write(
        '${_number(x)} ${_number(y)} ${_number(width)} ${_number(height)} re ',
      )
      ..writeln(
        fill != null && stroke != null
            ? 'B Q'
            : fill != null
            ? 'f Q'
            : 'S Q',
      );
  }

  void line(
    double x1,
    double y1,
    double x2,
    double y2, {
    required _PdfColor color,
    double width = 0.7,
  }) {
    _content.writeln(
      'q ${color.strokeCommand} ${_number(width)} w '
      '${_number(x1)} ${_number(y1)} m ${_number(x2)} ${_number(y2)} l S Q',
    );
  }

  List<int> buildLandscapeLetterPdf() {
    final stream = _content.toString();
    final streamBytes = latin1.encode(stream);
    final objects = <String>[
      '<< /Type /Catalog /Pages 2 0 R >>',
      '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
      '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 792 612] /Resources << /Font << /F1 4 0 R /F2 5 0 R >> >> /Contents 6 0 R >>',
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>',
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>',
      '<< /Length ${streamBytes.length} >>\nstream\n$stream\nendstream',
    ];
    final output = <int>[];
    void add(String value) {
      output.addAll(latin1.encode(value));
    }

    add('%PDF-1.4\n');
    final offsets = <int>[0];
    for (var index = 0; index < objects.length; index++) {
      offsets.add(output.length);
      add('${index + 1} 0 obj\n${objects[index]}\nendobj\n');
    }
    final xrefOffset = output.length;
    add('xref\n0 ${objects.length + 1}\n');
    add('0000000000 65535 f \n');
    for (final offset in offsets.skip(1)) {
      add('${offset.toString().padLeft(10, '0')} 00000 n \n');
    }
    add(
      'trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\n'
      'startxref\n$xrefOffset\n%%EOF',
    );
    return output;
  }
}

class _PdfColor {
  const _PdfColor(this.red, this.green, this.blue);

  final int red;
  final int green;
  final int blue;

  String get command =>
      '${_number(red / 255)} ${_number(green / 255)} ${_number(blue / 255)} rg';
  String get strokeCommand =>
      '${_number(red / 255)} ${_number(green / 255)} ${_number(blue / 255)} RG';

  _PdfColor mix(_PdfColor other, double amount) => _PdfColor(
    (red + (other.red - red) * amount).round(),
    (green + (other.green - green) * amount).round(),
    (blue + (other.blue - blue) * amount).round(),
  );
}

_PdfColor _activityColor(WeeklyScheduleExportActivity activity) {
  final value = effectiveRoutineIdentityColorArgb(
    colorKey: activity.colorKey,
    customColorArgb: activity.customColorArgb,
  );
  return _PdfColor((value >> 16) & 255, (value >> 8) & 255, value & 255);
}

String _fit(String value, double width, double fontSize) {
  final normalized = value.replaceAll(RegExp(r'\s+'), ' ').trim();
  final capacity = math.max(1, (width / (fontSize * 0.52)).floor());
  if (normalized.length <= capacity) return normalized;
  if (capacity <= 3) return normalized.substring(0, capacity);
  return '${normalized.substring(0, capacity - 3)}...';
}

String _pdfText(String value) {
  final escaped = value
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .replaceAll('’', "'")
      .replaceAll('“', '"')
      .replaceAll('”', '"')
      .replaceAll(r'\', r'\\')
      .replaceAll('(', r'\(')
      .replaceAll(')', r'\)');
  return String.fromCharCodes(
    escaped.runes.map((rune) => rune <= 255 ? rune : 63),
  );
}

String _number(num value) =>
    value.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');

String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/'
    '${value.month.toString().padLeft(2, '0')}/${value.year}';

String _shortDate(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/'
    '${value.month.toString().padLeft(2, '0')}';

String _dateTime(DateTime value) =>
    '${_date(value)} ${_minute(value.hour * 60 + value.minute)}';

String _minute(int value) {
  final bounded = value.clamp(0, 24 * 60);
  return '${(bounded ~/ 60).toString().padLeft(2, '0')}:'
      '${(bounded % 60).toString().padLeft(2, '0')}';
}

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
