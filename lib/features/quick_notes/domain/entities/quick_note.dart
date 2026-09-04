enum QuickNotePriority { high, medium, low }

enum QuickNoteSort { manual, priority, date, recent, color }

class QuickNote {
  const QuickNote({
    required this.id,
    required this.text,
    required this.isCompleted,
    required this.colorArgb,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    this.localDate,
    this.priority,
  });

  final String id;
  final String text;
  final bool isCompleted;
  final int colorArgb;
  final DateTime? localDate;
  final QuickNotePriority? priority;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuickNote copyWith({
    String? text,
    bool? isCompleted,
    int? colorArgb,
    DateTime? localDate,
    QuickNotePriority? priority,
    int? position,
    DateTime? updatedAt,
    bool clearLocalDate = false,
    bool clearPriority = false,
  }) => QuickNote(
    id: id,
    text: text ?? this.text,
    isCompleted: isCompleted ?? this.isCompleted,
    colorArgb: colorArgb ?? this.colorArgb,
    localDate: clearLocalDate ? null : localDate ?? this.localDate,
    priority: clearPriority ? null : priority ?? this.priority,
    position: position ?? this.position,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
