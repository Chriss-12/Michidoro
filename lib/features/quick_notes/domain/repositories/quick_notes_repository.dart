import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';

abstract interface class QuickNotesRepository {
  Future<List<QuickNote>> loadNotes();

  Future<QuickNote> createNote({
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  });

  Future<QuickNote?> updateNote({
    required String id,
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  });

  Future<QuickNote?> toggleCompletion(String id);

  Future<QuickNote?> moveNote(String id, int newIndex);

  Future<void> deleteNote(String id);
}
