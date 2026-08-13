import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';

enum GoalPeriod { all, day, week, month, year, range }

List<ProductivityGoal> filterGoalsForPeriod(
  Iterable<ProductivityGoal> source, {
  required GoalPeriod period,
  required DateTime referenceDay,
  required DateTimeRange? customRange,
}) {
  final normalizedReference = DateTime(
    referenceDay.year,
    referenceDay.month,
    referenceDay.day,
  );
  final weekStart = normalizedReference.subtract(
    Duration(days: normalizedReference.weekday - 1),
  );
  final weekEnd = weekStart.add(const Duration(days: 6));
  final filtered =
      source
          .where((goal) {
            final date = goal.targetDate;
            return switch (period) {
              GoalPeriod.all => true,
              GoalPeriod.day =>
                date != null && sameCalendarDate(date, normalizedReference),
              GoalPeriod.week =>
                date != null && dateWithinInclusive(date, weekStart, weekEnd),
              GoalPeriod.month =>
                date != null &&
                    date.year == normalizedReference.year &&
                    date.month == normalizedReference.month,
              GoalPeriod.year =>
                date != null && date.year == normalizedReference.year,
              GoalPeriod.range =>
                date != null &&
                    customRange != null &&
                    dateWithinInclusive(
                      date,
                      customRange.start,
                      customRange.end,
                    ),
            };
          })
          .toList(growable: false)
        ..sort((first, second) {
          final firstDate = first.targetDate;
          final secondDate = second.targetDate;
          if (firstDate == null && secondDate != null) return 1;
          if (firstDate != null && secondDate == null) return -1;
          final dateOrder = firstDate == null || secondDate == null
              ? 0
              : firstDate.compareTo(secondDate);
          return dateOrder != 0
              ? dateOrder
              : first.title.toLowerCase().compareTo(second.title.toLowerCase());
        });
  return filtered;
}

bool sameCalendarDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

bool dateWithinInclusive(DateTime value, DateTime start, DateTime end) {
  final date = DateTime(value.year, value.month, value.day);
  final normalizedStart = DateTime(start.year, start.month, start.day);
  final normalizedEnd = DateTime(end.year, end.month, end.day);
  return !date.isBefore(normalizedStart) && !date.isAfter(normalizedEnd);
}
