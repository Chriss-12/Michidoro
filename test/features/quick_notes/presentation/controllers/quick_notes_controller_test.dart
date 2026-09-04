import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/repositories/quick_notes_repository.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/controllers/quick_notes_controller.dart';
import 'package:pomodoro_app_v1/shared/models/date_period_filter.dart';

void main() {
  group('QuickNotesController', () {
    test('validates, trims and exposes dated notes', () async {
      final controller = QuickNotesController(repository: _MemoryRepository());

      expect(
        await controller.create(
          rawText: '   ',
          colorArgb: 0xFF336699,
          localDate: null,
          priority: null,
        ),
        isFalse,
      );
      expect(controller.validationCode.value, 'empty');

      expect(
        await controller.create(
          rawText: '  Recordar esto  ',
          colorArgb: 0xFF336699,
          localDate: DateTime(2026, 8, 27, 22),
          priority: QuickNotePriority.high,
        ),
        isTrue,
      );
      expect(controller.notes.value.single.text, 'Recordar esto');
      expect(
        controller.notesForDay(DateTime(2026, 8, 27)).single.localDate,
        DateTime(2026, 8, 27),
      );
    });

    test('shares one repository load between simultaneous callers', () async {
      final repository = _DelayedRepository();
      final controller = QuickNotesController(repository: repository);

      final first = controller.load();
      final second = controller.load();

      expect(repository.loadCalls, 1);
      expect(controller.isLoading.value, isTrue);

      repository.completeLoad();
      await Future.wait([first, second]);

      expect(repository.loadCalls, 1);
      expect(controller.isLoading.value, isFalse);
    });

    test('sorts by priority and keeps completed notes last', () async {
      final repository = _MemoryRepository();
      final controller = QuickNotesController(repository: repository);
      await controller.create(
        rawText: 'Baja',
        colorArgb: 0xFF112233,
        localDate: null,
        priority: QuickNotePriority.low,
      );
      await controller.create(
        rawText: 'Alta',
        colorArgb: 0xFF445566,
        localDate: null,
        priority: QuickNotePriority.high,
      );
      controller.sort.value = QuickNoteSort.priority;

      expect(controller.sortedNotes.value.map((note) => note.text), [
        'Alta',
        'Baja',
      ]);

      await controller.toggle(controller.notes.value.last.id);
      expect(controller.sortedNotes.value.last.text, 'Alta');
    });

    test('updates, moves and deletes through the repository', () async {
      final controller = QuickNotesController(repository: _MemoryRepository());
      for (final text in ['Uno', 'Dos']) {
        await controller.create(
          rawText: text,
          colorArgb: 0xFF778899,
          localDate: null,
          priority: null,
        );
      }
      final second = controller.notes.value.last;
      await controller.move(second.id, 0);
      expect(controller.sortedNotes.value.first.id, second.id);

      final updated = await controller.update(
        id: second.id,
        rawText: 'Dos editada',
        colorArgb: 0xFFABCDEF,
        localDate: null,
        priority: QuickNotePriority.medium,
      );
      expect(updated, isTrue);
      expect(controller.notes.value.last.text, 'Dos editada');

      await controller.delete(second.id);
      expect(controller.notes.value, hasLength(1));
    });

    test('recent sorting uses creation time', () async {
      final controller = QuickNotesController(repository: _MemoryRepository());
      for (final text in ['Primera', 'Segunda']) {
        await controller.create(
          rawText: text,
          colorArgb: 0xFF778899,
          localDate: null,
          priority: null,
        );
      }

      controller.sort.value = QuickNoteSort.recent;

      expect(controller.sortedNotes.value.map((note) => note.text), [
        'Segunda',
        'Primera',
      ]);
    });

    test('filters notes by day, week, month, year and all', () async {
      final controller = QuickNotesController(
        repository: _MemoryRepository(),
        now: () => DateTime(2026, 8, 27),
      );
      for (final entry in <(String, DateTime?)>[
        ('Hoy', DateTime(2026, 8, 27)),
        ('Semana', DateTime(2026, 8, 24)),
        ('Mes', DateTime(2026, 8, 2)),
        ('Año', DateTime(2026, 1, 10)),
        ('Sin fecha', null),
      ]) {
        await controller.create(
          rawText: entry.$1,
          colorArgb: 0xFF778899,
          localDate: entry.$2,
          priority: null,
        );
      }

      expect(controller.filteredNotes.value.map((note) => note.text), ['Hoy']);
      controller.selectedDateFilter = DatePeriodFilter.week(
        DateTime(2026, 8, 27),
      );
      expect(controller.filteredNotes.value, hasLength(2));
      controller.selectedDateFilter = DatePeriodFilter.month(
        DateTime(2026, 8),
      );
      expect(controller.filteredNotes.value, hasLength(3));
      controller.selectedDateFilter = DatePeriodFilter.year(2026);
      expect(controller.filteredNotes.value, hasLength(4));
      controller.selectedDateFilter = const DatePeriodFilter.all();
      expect(controller.filteredNotes.value, hasLength(5));
    });
  });
}

class _MemoryRepository implements QuickNotesRepository {
  final List<QuickNote> _notes = [];
  var _sequence = 0;

  @override
  Future<List<QuickNote>> loadNotes() async => List.of(_notes);

  @override
  Future<QuickNote> createNote({
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async {
    final now = DateTime.utc(2026, 8, 27, 12, _sequence);
    final note = QuickNote(
      id: 'note-${_sequence++}',
      text: text,
      isCompleted: false,
      colorArgb: colorArgb,
      localDate: localDate,
      priority: priority,
      position: _sequence * 100,
      createdAt: now,
      updatedAt: now,
    );
    _notes.add(note);
    return note;
  }

  @override
  Future<QuickNote?> updateNote({
    required String id,
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index < 0) return null;
    final updated = _notes[index].copyWith(
      text: text,
      colorArgb: colorArgb,
      localDate: localDate,
      priority: priority,
      clearLocalDate: localDate == null,
      clearPriority: priority == null,
    );
    _notes[index] = updated;
    return updated;
  }

  @override
  Future<QuickNote?> toggleCompletion(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index < 0) return null;
    final updated = _notes[index].copyWith(
      isCompleted: !_notes[index].isCompleted,
    );
    _notes[index] = updated;
    return updated;
  }

  @override
  Future<QuickNote?> moveNote(String id, int newIndex) async {
    final oldIndex = _notes.indexWhere((note) => note.id == id);
    if (oldIndex < 0) return null;
    final note = _notes.removeAt(oldIndex);
    _notes.insert(newIndex.clamp(0, _notes.length), note);
    for (var index = 0; index < _notes.length; index++) {
      _notes[index] = _notes[index].copyWith(position: index * 100);
    }
    return _notes.firstWhere((note) => note.id == id);
  }

  @override
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
  }
}

class _DelayedRepository extends _MemoryRepository {
  final Completer<List<QuickNote>> _loadCompleter =
      Completer<List<QuickNote>>();
  int loadCalls = 0;

  @override
  Future<List<QuickNote>> loadNotes() {
    loadCalls += 1;
    return _loadCompleter.future;
  }

  void completeLoad() => _loadCompleter.complete(const []);
}
