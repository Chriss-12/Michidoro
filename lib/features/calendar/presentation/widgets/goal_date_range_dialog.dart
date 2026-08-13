import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

Future<DateTimeRange?> showGoalDateRangeDialog({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    builder: (context) => _GoalDateRangeDialog(
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialDateRange,
    ),
  );
}

class _GoalDateRangeDialog extends StatefulWidget {
  const _GoalDateRangeDialog({
    required this.firstDate,
    required this.lastDate,
    required this.initialDateRange,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialDateRange;

  @override
  State<_GoalDateRangeDialog> createState() => _GoalDateRangeDialogState();
}

class _GoalDateRangeDialogState extends State<_GoalDateRangeDialog> {
  DateTime? _start;
  DateTime? _end;
  late DateTime _visibleMonth;
  late bool _selectingStart;

  @override
  void initState() {
    super.initState();
    _start = widget.initialDateRange?.start;
    _end = widget.initialDateRange?.end;
    final initialMonth = _start ?? DateTime.now();
    _visibleMonth = DateTime(initialMonth.year, initialMonth.month);
    _selectingStart = _start == null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final rangeComplete = _start != null && _end != null;

    return Dialog(
      key: const ValueKey('goal-date-range-dialog'),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: palette.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('Seleccionar periodo', 'Select period'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.tr('Cerrar', 'Close'),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _RangeDateField(
                      key: const ValueKey('goal-range-start-field'),
                      label: context.tr('Inicio', 'Start'),
                      value: _start,
                      selected: _selectingStart,
                      onTap: () => setState(() => _selectingStart = true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: palette.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: _RangeDateField(
                      key: const ValueKey('goal-range-end-field'),
                      label: context.tr('Fin', 'End'),
                      value: _end,
                      selected: !_selectingStart,
                      onTap: () => setState(() => _selectingStart = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _RangeCalendar(
                visibleMonth: _visibleMonth,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                start: _start,
                end: _end,
                onPreviousMonth: _canShowPreviousMonth
                    ? () => _showMonth(-1)
                    : null,
                onNextMonth: _canShowNextMonth ? () => _showMonth(1) : null,
                onSelected: _selectDate,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.tr('Cancelar', 'Cancel')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      key: const ValueKey('apply-goal-date-range'),
                      onPressed: rangeComplete
                          ? () => Navigator.of(context).pop(
                              DateTimeRange(start: _start!, end: _end!),
                            )
                          : null,
                      child: Text(context.tr('Aplicar', 'Apply')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canShowPreviousMonth {
    final previous = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    return !previous.isBefore(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    );
  }

  bool get _canShowNextMonth {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    return !next.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  void _showMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + delta,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (_selectingStart) {
        _start = date;
        if (_end != null && _end!.isBefore(date)) _end = null;
        _selectingStart = false;
        return;
      }

      if (_start == null || date.isBefore(_start!)) {
        _start = date;
        _end = null;
      } else {
        _end = date;
      }
    });
  }
}

class _RangeDateField extends StatelessWidget {
  const _RangeDateField({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final DateTime? value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: selected
          ? palette.primaryMuted.withValues(alpha: 0.55)
          : palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected ? palette.primary : palette.neutralSoft,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected ? palette.primary : palette.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value == null ? '--/--/----' : _formatDate(value!),
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RangeCalendar extends StatelessWidget {
  const _RangeCalendar({
    required this.visibleMonth,
    required this.firstDate,
    required this.lastDate,
    required this.start,
    required this.end,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onSelected,
  });

  final DateTime visibleMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? start;
  final DateTime? end;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final weekdays = isEnglish
        ? const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
        : const ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final months = isEnglish ? _monthsEnglish : _monthsSpanish;
    final days = _monthDays(visibleMonth);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              key: const ValueKey('previous-range-month'),
              tooltip: context.tr('Mes anterior', 'Previous month'),
              onPressed: onPreviousMonth,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                '${months[visibleMonth.month - 1]} ${visibleMonth.year}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              key: const ValueKey('next-range-month'),
              tooltip: context.tr('Mes siguiente', 'Next month'),
              onPressed: onNextMonth,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.35,
          children: [
            for (final weekday in weekdays)
              Center(
                child: Text(
                  weekday,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        GridView.builder(
          itemCount: days.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            final date = days[index];
            return _RangeDay(
              date: date,
              muted: date.month != visibleMonth.month,
              enabled:
                  !_dateOnly(date).isBefore(_dateOnly(firstDate)) &&
                  !_dateOnly(date).isAfter(_dateOnly(lastDate)),
              isStart: start != null && _sameDate(date, start!),
              isEnd: end != null && _sameDate(date, end!),
              inRange:
                  start != null &&
                  end != null &&
                  date.isAfter(_dateOnly(start!)) &&
                  date.isBefore(_dateOnly(end!)),
              onTap: () => onSelected(_dateOnly(date)),
            );
          },
        ),
      ],
    );
  }
}

class _RangeDay extends StatelessWidget {
  const _RangeDay({
    required this.date,
    required this.muted,
    required this.enabled,
    required this.isStart,
    required this.isEnd,
    required this.inRange,
    required this.onTap,
  });

  final DateTime date;
  final bool muted;
  final bool enabled;
  final bool isStart;
  final bool isEnd;
  final bool inRange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final endpoint = isStart || isEnd;
    return Semantics(
      label: _formatDate(date),
      selected: endpoint || inRange,
      button: true,
      child: InkWell(
        key: ValueKey('goal-range-day-${_dateKey(date)}'),
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (inRange)
              Positioned.fill(
                top: 6,
                bottom: 6,
                child: ColoredBox(
                  color: palette.primaryMuted.withValues(alpha: 0.8),
                ),
              ),
            if (endpoint)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: palette.primary,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              '${date.day}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: !enabled
                    ? palette.textSecondary.withValues(alpha: 0.35)
                    : endpoint
                    ? Theme.of(context).colorScheme.onPrimary
                    : muted
                    ? palette.textSecondary.withValues(alpha: 0.55)
                    : palette.textPrimary,
                fontWeight: endpoint ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<DateTime> _monthDays(DateTime month) {
  final first = DateTime(month.year, month.month);
  final start = first.subtract(Duration(days: first.weekday - 1));
  return List.generate(42, (index) => start.add(Duration(days: index)));
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

const _monthsSpanish = [
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

const _monthsEnglish = [
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
