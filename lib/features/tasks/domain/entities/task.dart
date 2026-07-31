enum TaskStatus {
  listed,
  inProgress,
  completed;

  bool get isCompleted => this == TaskStatus.completed;
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.status = TaskStatus.listed,
    this.scheduledDate,
    this.goalId,
    this.durationMinutes,
    this.legacyCompletionUnknown = false,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final TaskStatus status;
  final DateTime? scheduledDate;
  final String? goalId;
  final int? durationMinutes;
  final bool legacyCompletionUnknown;

  bool get isCompleted => status.isCompleted;
  bool get isPlanned => scheduledDate != null;
  bool get hasGoal => goalId != null;

  Task copyWith({
    String? title,
    DateTime? createdAt,
    TaskStatus? status,
    DateTime? scheduledDate,
    String? goalId,
    int? durationMinutes,
    bool? legacyCompletionUnknown,
    bool clearScheduledDate = false,
    bool clearGoalId = false,
    bool clearDuration = false,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      scheduledDate: clearScheduledDate
          ? null
          : scheduledDate ?? this.scheduledDate,
      goalId: clearGoalId ? null : goalId ?? this.goalId,
      durationMinutes: clearDuration
          ? null
          : durationMinutes ?? this.durationMinutes,
      legacyCompletionUnknown:
          legacyCompletionUnknown ?? this.legacyCompletionUnknown,
    );
  }
}
