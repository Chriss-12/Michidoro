import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_run.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

class RoutineScheduleOccurrence {
  const RoutineScheduleOccurrence({
    required this.sourceRoutineId,
    required this.name,
    required this.iconKey,
    required this.colorKey,
    required this.localDate,
    required this.startMinute,
    required this.status,
    required this.totalRequiredItems,
    required this.completedRequiredItems,
    required this.skippedOptionalItems,
    required this.missedRequiredItems,
    required this.isVirtual,
    required this.hasOverlap,
  });

  final String sourceRoutineId;
  final String name;
  final String iconKey;
  final String colorKey;
  final DateTime localDate;
  final int startMinute;
  final RoutineRunStatus status;
  final int totalRequiredItems;
  final int completedRequiredItems;
  final int skippedOptionalItems;
  final int missedRequiredItems;
  final bool isVirtual;
  final bool hasOverlap;

  RoutineScheduleOccurrence copyWith({bool? hasOverlap}) =>
      RoutineScheduleOccurrence(
        sourceRoutineId: sourceRoutineId,
        name: name,
        iconKey: iconKey,
        colorKey: colorKey,
        localDate: localDate,
        startMinute: startMinute,
        status: status,
        totalRequiredItems: totalRequiredItems,
        completedRequiredItems: completedRequiredItems,
        skippedOptionalItems: skippedOptionalItems,
        missedRequiredItems: missedRequiredItems,
        isVirtual: isVirtual,
        hasOverlap: hasOverlap ?? this.hasOverlap,
      );
}

class RoutineTodayFocus {
  const RoutineTodayFocus({
    required this.routine,
    required this.run,
    required this.items,
    required this.completedRequiredItems,
    required this.totalRequiredItems,
    this.nextItem,
    this.followingItem,
    this.task,
  });

  final Routine routine;
  final RoutineRun run;
  final List<RoutineItemRun> items;
  final int completedRequiredItems;
  final int totalRequiredItems;
  final RoutineItemRun? nextItem;
  final RoutineItemRun? followingItem;
  final Task? task;

  bool get canStart => nextItem != null && task != null;
}

List<RoutineScheduleOccurrence> projectRoutineSchedule({
  required List<Routine> routines,
  required List<RoutineRun> runs,
  required Map<String, List<RoutineItemRun>> itemRuns,
  required DateTime startDate,
  required DateTime endDate,
  required DateTime today,
}) {
  final start = _dateOnly(startDate);
  final end = _dateOnly(endDate);
  final currentDay = _dateOnly(today);
  final runsByOccurrence = {
    for (final run in runs)
      '${run.sourceRoutineId}:${_dateKey(run.localDate)}': run,
  };
  final result = <RoutineScheduleOccurrence>[];

  for (final run in runs) {
    final items = itemRuns[run.id] ?? const <RoutineItemRun>[];
    final requiredItems = items.where((item) => !item.isOptionalSnapshot);
    result.add(
      RoutineScheduleOccurrence(
        sourceRoutineId: run.sourceRoutineId,
        name: run.nameSnapshot,
        iconKey: run.iconKeySnapshot,
        colorKey: run.colorKeySnapshot,
        localDate: _dateOnly(run.localDate),
        startMinute: run.scheduledStartMinuteSnapshot,
        status: run.status,
        totalRequiredItems: requiredItems.length,
        completedRequiredItems: requiredItems
            .where((item) => item.status == RoutineRunStatus.completed)
            .length,
        skippedOptionalItems: items
            .where(
              (item) =>
                  item.isOptionalSnapshot &&
                  item.status == RoutineRunStatus.skipped,
            )
            .length,
        missedRequiredItems: items
            .where(
              (item) =>
                  !item.isOptionalSnapshot &&
                  item.status == RoutineRunStatus.missed,
            )
            .length,
        isVirtual: false,
        hasOverlap: false,
      ),
    );
  }

  for (final routine in routines) {
    if (routine.status != RoutineStatus.active || routine.items.isEmpty) {
      continue;
    }
    final createdDay = _dateOnly(routine.createdAt);
    for (
      var day = start;
      !day.isAfter(end);
      day = day.add(const Duration(days: 1))
    ) {
      if (day.isBefore(currentDay) ||
          day.isBefore(createdDay) ||
          !routine.weekdays.contains(day.weekday) ||
          runsByOccurrence.containsKey('${routine.id}:${_dateKey(day)}')) {
        continue;
      }
      result.add(
        RoutineScheduleOccurrence(
          sourceRoutineId: routine.id,
          name: routine.name,
          iconKey: routine.iconKey,
          colorKey: routine.colorKey,
          localDate: day,
          startMinute: routine.items
              .map((item) => item.scheduledMinute)
              .reduce((first, second) => first < second ? first : second),
          status: RoutineRunStatus.scheduled,
          totalRequiredItems: routine.items
              .where((item) => !item.isOptional)
              .length,
          completedRequiredItems: 0,
          skippedOptionalItems: 0,
          missedRequiredItems: 0,
          isVirtual: true,
          hasOverlap: false,
        ),
      );
    }
  }

  result.sort((first, second) {
    final byDate = first.localDate.compareTo(second.localDate);
    return byDate != 0
        ? byDate
        : first.startMinute.compareTo(second.startMinute);
  });
  return _markOverlaps(result, routines);
}

RoutineTodayFocus? projectRoutineTodayFocus({
  required List<Routine> routines,
  required List<RoutineRun> runs,
  required Map<String, List<RoutineItemRun>> itemRuns,
  required List<Task> tasks,
}) {
  final routinesById = {for (final routine in routines) routine.id: routine};
  final tasksById = {for (final task in tasks) task.id: task};
  final candidates = <RoutineTodayFocus>[];
  for (final run in runs) {
    if (run.status == RoutineRunStatus.skipped ||
        run.status == RoutineRunStatus.missed) {
      continue;
    }
    final routine = routinesById[run.sourceRoutineId];
    if (routine == null) continue;
    final items = itemRuns[run.id] ?? const <RoutineItemRun>[];
    final required = items.where((item) => !item.isOptionalSnapshot);
    final actionable =
        items
            .where(
              (item) =>
                  item.status == RoutineRunStatus.inProgress ||
                  item.status == RoutineRunStatus.scheduled,
            )
            .toList()
          ..sort((first, second) {
            final firstPriority = first.status == RoutineRunStatus.inProgress
                ? 0
                : 1;
            final secondPriority = second.status == RoutineRunStatus.inProgress
                ? 0
                : 1;
            final byStatus = firstPriority.compareTo(secondPriority);
            return byStatus != 0
                ? byStatus
                : first.positionSnapshot.compareTo(second.positionSnapshot);
          });
    RoutineItemRun? nextItem;
    Task? task;
    for (final item in actionable) {
      final candidate = item.taskId == null ? null : tasksById[item.taskId];
      if (candidate == null || candidate.status == TaskStatus.completed) {
        continue;
      }
      nextItem = item;
      task = candidate;
      break;
    }
    final followingItem = nextItem == null
        ? null
        : items
              .where(
                (item) =>
                    item.positionSnapshot > nextItem!.positionSnapshot &&
                    item.status == RoutineRunStatus.scheduled,
              )
              .fold<RoutineItemRun?>(
                null,
                (current, item) =>
                    current == null ||
                        item.positionSnapshot < current.positionSnapshot
                    ? item
                    : current,
              );
    candidates.add(
      RoutineTodayFocus(
        routine: routine,
        run: run,
        items: items,
        completedRequiredItems: required
            .where((item) => item.status == RoutineRunStatus.completed)
            .length,
        totalRequiredItems: required.length,
        nextItem: nextItem,
        followingItem: followingItem,
        task: task,
      ),
    );
  }
  candidates.sort((first, second) {
    final firstActive = first.nextItem?.status == RoutineRunStatus.inProgress;
    final secondActive = second.nextItem?.status == RoutineRunStatus.inProgress;
    if (firstActive != secondActive) return firstActive ? -1 : 1;
    return first.run.scheduledStartMinuteSnapshot.compareTo(
      second.run.scheduledStartMinuteSnapshot,
    );
  });
  return candidates.isEmpty ? null : candidates.first;
}

List<RoutineScheduleOccurrence> _markOverlaps(
  List<RoutineScheduleOccurrence> occurrences,
  List<Routine> routines,
) {
  final routinesById = {for (final routine in routines) routine.id: routine};
  final overlapping = <int>{};
  for (var first = 0; first < occurrences.length; first++) {
    for (var second = first + 1; second < occurrences.length; second++) {
      if (!_sameDate(
        occurrences[first].localDate,
        occurrences[second].localDate,
      )) {
        if (occurrences[second].localDate.isAfter(
          occurrences[first].localDate,
        )) {
          break;
        }
        continue;
      }
      final firstRoutine = routinesById[occurrences[first].sourceRoutineId];
      final secondRoutine = routinesById[occurrences[second].sourceRoutineId];
      if (firstRoutine == null || secondRoutine == null) continue;
      if (_routinesOverlap(firstRoutine, secondRoutine)) {
        overlapping
          ..add(first)
          ..add(second);
      }
    }
  }
  return [
    for (var index = 0; index < occurrences.length; index++)
      occurrences[index].copyWith(hasOverlap: overlapping.contains(index)),
  ];
}

bool _routinesOverlap(Routine first, Routine second) {
  for (final firstItem in first.items) {
    final firstEnd = firstItem.scheduledMinute + firstItem.durationMinutes;
    for (final secondItem in second.items) {
      final secondEnd = secondItem.scheduledMinute + secondItem.durationMinutes;
      if (firstItem.scheduledMinute < secondEnd &&
          secondItem.scheduledMinute < firstEnd) {
        return true;
      }
    }
  }
  return false;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
