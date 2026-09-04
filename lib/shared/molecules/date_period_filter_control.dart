import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/models/date_period_filter.dart';

class DatePeriodFilterControl extends StatelessWidget {
  const DatePeriodFilterControl({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final DatePeriodFilter value;
  final ValueChanged<DatePeriodFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PeriodSegment(
          key: const ValueKey('date-period-filter-primary'),
          value: value.kind,
          values: const [
            DatePeriodFilterKind.today,
            DatePeriodFilterKind.day,
            DatePeriodFilterKind.week,
          ],
          onSelected: (kind) => unawaited(_select(context, kind)),
        ),
        const SizedBox(height: 8),
        _PeriodSegment(
          key: const ValueKey('date-period-filter-secondary'),
          value: value.kind,
          values: const [
            DatePeriodFilterKind.month,
            DatePeriodFilterKind.year,
            DatePeriodFilterKind.all,
          ],
          onSelected: (kind) => unawaited(_select(context, kind)),
        ),
        const SizedBox(height: 10),
        Container(
          key: const ValueKey('date-period-filter-label'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.palette.primaryMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _kindIcon(value.kind),
                size: 19,
                color: context.palette.primary,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  _periodLabel(context, value),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.palette.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _select(
    BuildContext context,
    DatePeriodFilterKind kind,
  ) async {
    final initial = value.referenceDate ?? DateTime.now();
    switch (kind) {
      case DatePeriodFilterKind.today:
        onChanged(DatePeriodFilter.today());
        return;
      case DatePeriodFilterKind.day:
        final selected = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100, 12, 31),
          helpText: context.tr('Seleccionar día', 'Select day'),
        );
        if (selected != null) onChanged(DatePeriodFilter.day(selected));
        return;
      case DatePeriodFilterKind.week:
        final selected = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100, 12, 31),
          helpText: context.tr(
            'Seleccionar una semana',
            'Select a week',
          ),
        );
        if (selected != null) onChanged(DatePeriodFilter.week(selected));
        return;
      case DatePeriodFilterKind.month:
        final selected = await showDialog<DateTime>(
          context: context,
          builder: (context) => _MonthPickerDialog(initialMonth: initial),
        );
        if (selected != null) onChanged(DatePeriodFilter.month(selected));
        return;
      case DatePeriodFilterKind.year:
        final selected = await showDialog<int>(
          context: context,
          builder: (context) => _YearPickerDialog(initialYear: initial.year),
        );
        if (selected != null) onChanged(DatePeriodFilter.year(selected));
        return;
      case DatePeriodFilterKind.all:
        onChanged(const DatePeriodFilter.all());
        return;
    }
  }
}

class _PeriodSegment extends StatelessWidget {
  const _PeriodSegment({
    required this.value,
    required this.values,
    required this.onSelected,
    super.key,
  });

  final DatePeriodFilterKind value;
  final List<DatePeriodFilterKind> values;
  final ValueChanged<DatePeriodFilterKind> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<DatePeriodFilterKind>(
        showSelectedIcon: false,
        emptySelectionAllowed: true,
        segments: [
          for (final kind in values)
            ButtonSegment(value: kind, label: Text(_kindLabel(context, kind))),
        ],
        selected: values.contains(value) ? {value} : const {},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) onSelected(selection.first);
        },
      ),
    );
  }
}

class _MonthPickerDialog extends StatefulWidget {
  const _MonthPickerDialog({required this.initialMonth});

  final DateTime initialMonth;

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late int _year = widget.initialMonth.year;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          IconButton(
            onPressed: () => setState(() => _year--),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Text('$_year', textAlign: TextAlign.center),
          ),
          IconButton(
            onPressed: () => setState(() => _year++),
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 1.8,
          children: [
            for (var month = 1; month <= 12; month++)
              TextButton(
                onPressed: () => Navigator.pop(
                  context,
                  DateTime(_year, month),
                ),
                child: Text(_monthName(context, month)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
      ],
    );
  }
}

class _YearPickerDialog extends StatelessWidget {
  const _YearPickerDialog({required this.initialYear});

  final int initialYear;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('Seleccionar año', 'Select year')),
      content: SizedBox(
        width: 320,
        height: 360,
        child: YearPicker(
          firstDate: DateTime(1900),
          lastDate: DateTime(2100, 12, 31),
          selectedDate: DateTime(initialYear),
          onChanged: (date) => Navigator.pop(context, date.year),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
      ],
    );
  }
}

String _kindLabel(BuildContext context, DatePeriodFilterKind kind) =>
    switch (kind) {
      DatePeriodFilterKind.today => context.tr('Hoy', 'Today'),
      DatePeriodFilterKind.day => context.tr('Día', 'Day'),
      DatePeriodFilterKind.week => context.tr('Semana', 'Week'),
      DatePeriodFilterKind.month => context.tr('Mes', 'Month'),
      DatePeriodFilterKind.year => context.tr('Año', 'Year'),
      DatePeriodFilterKind.all => context.tr('Todas', 'All'),
    };

IconData _kindIcon(DatePeriodFilterKind kind) => switch (kind) {
  DatePeriodFilterKind.today => Icons.today_rounded,
  DatePeriodFilterKind.day => Icons.event_rounded,
  DatePeriodFilterKind.week => Icons.view_week_rounded,
  DatePeriodFilterKind.month => Icons.calendar_view_month_rounded,
  DatePeriodFilterKind.year => Icons.calendar_today_rounded,
  DatePeriodFilterKind.all => Icons.all_inclusive_rounded,
};

String _periodLabel(BuildContext context, DatePeriodFilter filter) {
  final start = filter.start;
  final end = filter.end;
  return switch (filter.kind) {
    DatePeriodFilterKind.today => context.tr(
      'Hoy · ${_shortDate(start!)}',
      'Today · ${_shortDate(start)}',
    ),
    DatePeriodFilterKind.day => _shortDate(start!),
    DatePeriodFilterKind.week => '${_shortDate(start!)} – ${_shortDate(end!)}',
    DatePeriodFilterKind.month =>
      '${_monthName(context, start!.month)} ${start.year}',
    DatePeriodFilterKind.year => '${start!.year}',
    DatePeriodFilterKind.all => context.tr(
      'Todas, incluidas las que no tienen fecha',
      'All, including undated items',
    ),
  };
}

String _shortDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';

String _monthName(BuildContext context, int month) {
  const spanish = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  const english = [
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
  return Localizations.localeOf(context).languageCode == 'es'
      ? spanish[month - 1]
      : english[month - 1];
}
