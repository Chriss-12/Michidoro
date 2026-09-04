import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/shared/models/date_period_filter.dart';

void main() {
  group('DatePeriodFilter', () {
    test('uses inclusive calendar boundaries', () {
      final week = DatePeriodFilter.week(DateTime(2026, 8, 12));
      final month = DatePeriodFilter.month(DateTime(2026, 8, 30));
      final year = DatePeriodFilter.year(2026);

      expect(week.start, DateTime(2026, 8, 10));
      expect(week.end, DateTime(2026, 8, 16));
      expect(week.includes(DateTime(2026, 8, 16, 23, 59)), isTrue);
      expect(week.includes(DateTime(2026, 8, 17)), isFalse);
      expect(month.start, DateTime(2026, 8));
      expect(month.end, DateTime(2026, 8, 31));
      expect(year.start, DateTime(2026));
      expect(year.end, DateTime(2026, 12, 31));
    });

    test('all includes any date', () {
      expect(
        const DatePeriodFilter.all().includes(DateTime(1900)),
        isTrue,
      );
    });
  });
}
