class Task {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final bool isCompleted;

  Task copyWith({
    String? title,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
