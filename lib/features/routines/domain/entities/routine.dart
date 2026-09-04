enum RoutineStatus { active, paused, archived }

enum RoutinePomodoroMode { none, recommended, custom }

class Routine {
  const Routine({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorKey,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.weekdays,
    required this.items,
    this.description,
    this.customColorArgb,
    this.validFromDate,
    this.validUntilDate,
    this.pausedUntilDate,
    this.archivedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String iconKey;
  final String colorKey;
  final int? customColorArgb;
  final DateTime? validFromDate;
  final DateTime? validUntilDate;
  final RoutineStatus status;
  final DateTime? pausedUntilDate;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<int> weekdays;
  final List<RoutineItem> items;
}

class RoutineItem {
  const RoutineItem({
    required this.id,
    required this.routineId,
    required this.position,
    required this.title,
    required this.scheduledMinute,
    required this.durationMinutes,
    required this.isOptional,
    required this.pomodoroMode,
    required this.createdAt,
    required this.updatedAt,
    this.goalId,
    this.reminderMinutesBefore,
    this.customFocusMinutes,
    this.customBreakMinutes,
  });

  final String id;
  final String routineId;
  final int position;
  final String title;
  final int scheduledMinute;
  final int durationMinutes;
  final String? goalId;
  final bool isOptional;
  final int? reminderMinutesBefore;
  final RoutinePomodoroMode pomodoroMode;
  final int? customFocusMinutes;
  final int? customBreakMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
