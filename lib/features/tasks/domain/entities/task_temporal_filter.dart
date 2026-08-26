import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

enum TaskTemporalFilterKind { allTime, day, month, year, range }

class TaskTemporalFilter {
  const TaskTemporalFilter._({required this.kind, this.start, this.end});

  const TaskTemporalFilter.allTime()
    : this._(kind: TaskTemporalFilterKind.allTime);

  factory TaskTemporalFilter.day(DateTime day) {
    final normalized = _normalizeDate(day);
    return TaskTemporalFilter._(
      kind: TaskTemporalFilterKind.day,
      start: normalized,
      end: normalized,
    );
  }

  factory TaskTemporalFilter.month(DateTime month) {
    return TaskTemporalFilter._(
      kind: TaskTemporalFilterKind.month,
      start: DateTime(month.year, month.month),
      end: DateTime(month.year, month.month + 1, 0),
    );
  }

  factory TaskTemporalFilter.year(int year) {
    return TaskTemporalFilter._(
      kind: TaskTemporalFilterKind.year,
      start: DateTime(year),
      end: DateTime(year, 12, 31),
    );
  }

  factory TaskTemporalFilter.range(DateTime first, DateTime last) {
    final normalizedFirst = _normalizeDate(first);
    final normalizedLast = _normalizeDate(last);
    final start = normalizedFirst.isBefore(normalizedLast)
        ? normalizedFirst
        : normalizedLast;
    final end = normalizedFirst.isAfter(normalizedLast)
        ? normalizedFirst
        : normalizedLast;
    return TaskTemporalFilter._(
      kind: TaskTemporalFilterKind.range,
      start: start,
      end: end,
    );
  }

  final TaskTemporalFilterKind kind;
  final DateTime? start;
  final DateTime? end;

  bool includes(Task task) {
    if (kind == TaskTemporalFilterKind.allTime) return true;
    final taskDate = _normalizeDate(task.scheduledDate ?? task.createdAt);
    return !taskDate.isBefore(start!) && !taskDate.isAfter(end!);
  }
}

DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
