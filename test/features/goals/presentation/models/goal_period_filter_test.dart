import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/models/goal_period_filter.dart';

void main() {
  final reference = DateTime(2026, 8, 12);
  final goals = [
    _goal('undated'),
    _goal('day', date: DateTime(2026, 8, 12, 23, 59)),
    _goal('week-start', date: DateTime(2026, 8, 10)),
    _goal('week-end', date: DateTime(2026, 8, 16)),
    _goal('month-start', date: DateTime(2026, 8)),
    _goal('month-end', date: DateTime(2026, 8, 31)),
    _goal('year-start', date: DateTime(2026)),
    _goal('year-end', date: DateTime(2026, 12, 31)),
    _goal('outside', date: DateTime(2025, 12, 31)),
  ];

  test('all includes dated and undated goals with undated entries last', () {
    final result = filterGoalsForPeriod(
      goals,
      period: GoalPeriod.all,
      referenceDay: reference,
      customRange: null,
    );

    expect(result, hasLength(goals.length));
    expect(result.last.id, 'undated');
  });

  test('day uses calendar date and ignores the time component', () {
    expect(_ids(goals, GoalPeriod.day, reference), ['day']);
  });

  test('week includes Monday and Sunday boundaries', () {
    expect(
      _ids(goals, GoalPeriod.week, reference),
      ['week-start', 'day', 'week-end'],
    );
  });

  test('month includes its first and last calendar dates', () {
    expect(
      _ids(goals, GoalPeriod.month, reference),
      ['month-start', 'week-start', 'day', 'week-end', 'month-end'],
    );
  });

  test('year includes January 1 and December 31', () {
    expect(
      _ids(goals, GoalPeriod.year, reference),
      [
        'year-start',
        'month-start',
        'week-start',
        'day',
        'week-end',
        'month-end',
        'year-end',
      ],
    );
  });

  test('custom range is inclusive and returns nothing before selection', () {
    expect(_ids(goals, GoalPeriod.range, reference), isEmpty);

    final result = filterGoalsForPeriod(
      goals,
      period: GoalPeriod.range,
      referenceDay: reference,
      customRange: DateTimeRange(
        start: DateTime(2026, 8, 10),
        end: DateTime(2026, 8, 12),
      ),
    );

    expect(result.map((goal) => goal.id), ['week-start', 'day']);
  });
}

List<String> _ids(
  List<ProductivityGoal> goals,
  GoalPeriod period,
  DateTime reference,
) {
  return filterGoalsForPeriod(
    goals,
    period: period,
    referenceDay: reference,
    customRange: null,
  ).map((goal) => goal.id).toList(growable: false);
}

ProductivityGoal _goal(String id, {DateTime? date}) {
  return ProductivityGoal(
    id: id,
    title: id,
    targetSessions: 1,
    targetDate: date,
    createdAt: DateTime(2026),
  );
}
