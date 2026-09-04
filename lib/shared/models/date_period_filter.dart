enum DatePeriodFilterKind { today, day, week, month, year, all }

class DatePeriodFilter {
  const DatePeriodFilter._({required this.kind, this.referenceDate});

  factory DatePeriodFilter.today([DateTime? now]) => DatePeriodFilter._(
    kind: DatePeriodFilterKind.today,
    referenceDate: _dateOnly(now ?? DateTime.now()),
  );

  factory DatePeriodFilter.day(DateTime day) => DatePeriodFilter._(
    kind: DatePeriodFilterKind.day,
    referenceDate: _dateOnly(day),
  );

  factory DatePeriodFilter.week(DateTime day) => DatePeriodFilter._(
    kind: DatePeriodFilterKind.week,
    referenceDate: _dateOnly(day),
  );

  factory DatePeriodFilter.month(DateTime month) => DatePeriodFilter._(
    kind: DatePeriodFilterKind.month,
    referenceDate: DateTime(month.year, month.month),
  );

  factory DatePeriodFilter.year(int year) => DatePeriodFilter._(
    kind: DatePeriodFilterKind.year,
    referenceDate: DateTime(year),
  );

  const DatePeriodFilter.all() : this._(kind: DatePeriodFilterKind.all);

  final DatePeriodFilterKind kind;
  final DateTime? referenceDate;

  DateTime? get start {
    final reference = referenceDate;
    if (reference == null) return null;
    return switch (kind) {
      DatePeriodFilterKind.today || DatePeriodFilterKind.day => reference,
      DatePeriodFilterKind.week => reference.subtract(
        Duration(days: reference.weekday - DateTime.monday),
      ),
      DatePeriodFilterKind.month => DateTime(reference.year, reference.month),
      DatePeriodFilterKind.year => DateTime(reference.year),
      DatePeriodFilterKind.all => null,
    };
  }

  DateTime? get end {
    final reference = referenceDate;
    if (reference == null) return null;
    return switch (kind) {
      DatePeriodFilterKind.today || DatePeriodFilterKind.day => reference,
      DatePeriodFilterKind.week => start!.add(const Duration(days: 6)),
      DatePeriodFilterKind.month => DateTime(
        reference.year,
        reference.month + 1,
        0,
      ),
      DatePeriodFilterKind.year => DateTime(reference.year, 12, 31),
      DatePeriodFilterKind.all => null,
    };
  }

  bool includes(DateTime date) {
    if (kind == DatePeriodFilterKind.all) return true;
    final normalized = _dateOnly(date);
    return !normalized.isBefore(start!) && !normalized.isAfter(end!);
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
