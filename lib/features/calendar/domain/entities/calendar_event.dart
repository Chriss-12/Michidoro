class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.createdAt,
  });

  final String id;
  final String title;
  final DateTime scheduledAt;
  final int durationMinutes;
  final DateTime createdAt;

  DateTime get endsAt => scheduledAt.add(Duration(minutes: durationMinutes));

  CalendarEvent copyWith({
    String? title,
    DateTime? scheduledAt,
    int? durationMinutes,
    DateTime? createdAt,
  }) {
    return CalendarEvent(
      id: id,
      title: title ?? this.title,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
