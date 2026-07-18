class ProductivityGoal {
  const ProductivityGoal({
    required this.id,
    required this.title,
    required this.targetSessions,
    required this.createdAt,
    this.completedSessions = 0,
    this.targetDate,
  });

  final String id;
  final String title;
  final int targetSessions;
  final int completedSessions;
  final DateTime createdAt;
  final DateTime? targetDate;

  double get progress {
    if (targetSessions <= 0) {
      return 0;
    }

    return (completedSessions / targetSessions).clamp(0, 1).toDouble();
  }

  bool get isCompleted => completedSessions >= targetSessions;

  ProductivityGoal copyWith({
    String? title,
    int? targetSessions,
    int? completedSessions,
    DateTime? createdAt,
    DateTime? targetDate,
    bool clearTargetDate = false,
  }) {
    return ProductivityGoal(
      id: id,
      title: title ?? this.title,
      targetSessions: targetSessions ?? this.targetSessions,
      completedSessions: completedSessions ?? this.completedSessions,
      createdAt: createdAt ?? this.createdAt,
      targetDate: clearTargetDate ? null : targetDate ?? this.targetDate,
    );
  }
}
