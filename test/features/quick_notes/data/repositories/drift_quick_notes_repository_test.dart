import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/quick_notes/data/repositories/drift_quick_notes_repository.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';

void main() {
  group('DriftQuickNotesRepository', () {
    test('persists every note field across a database restart', () async {
      final directory = Directory.systemTemp.createTempSync(
        'michifocus_quick_notes_test',
      );
      final file = File('${directory.path}/notes.sqlite');
      var database = MichiFocusDatabase(NativeDatabase(file));
      var repository = DriftQuickNotesRepository(
        QuickNotesDao(database),
        clock: () => DateTime.utc(2026, 8, 27, 12),
      );
      addTearDown(() async {
        await database.close();
        if (directory.existsSync()) directory.deleteSync(recursive: true);
      });

      final created = await repository.createNote(
        text: 'Idea persistente',
        colorArgb: 0xFF2D8C78,
        localDate: DateTime(2026, 8, 28),
        priority: QuickNotePriority.high,
      );
      await database.close();

      database = MichiFocusDatabase(NativeDatabase(file));
      repository = DriftQuickNotesRepository(QuickNotesDao(database));
      final notes = await repository.loadNotes();

      expect(notes, hasLength(1));
      expect(notes.single.id, created.id);
      expect(notes.single.text, 'Idea persistente');
      expect(notes.single.colorArgb, 0xFF2D8C78);
      expect(notes.single.localDate, DateTime(2026, 8, 28));
      expect(notes.single.priority, QuickNotePriority.high);
      expect(notes.single.isCompleted, isFalse);
    });

    test('updates, checks, reorders and deletes notes', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftQuickNotesRepository(QuickNotesDao(database));
      addTearDown(database.close);

      final first = await repository.createNote(
        text: 'Primera',
        colorArgb: 0xFF336699,
        localDate: null,
        priority: null,
      );
      final second = await repository.createNote(
        text: 'Segunda',
        colorArgb: 0xFF993366,
        localDate: null,
        priority: QuickNotePriority.low,
      );

      final edited = await repository.updateNote(
        id: first.id,
        text: 'Primera editada',
        colorArgb: 0xFF112233,
        localDate: DateTime(2026, 9),
        priority: QuickNotePriority.medium,
      );
      final completed = await repository.toggleCompletion(first.id);
      await repository.moveNote(second.id, 0);

      var notes = await repository.loadNotes();
      expect(edited?.text, 'Primera editada');
      expect(completed?.isCompleted, isTrue);
      expect(notes.map((note) => note.id), [second.id, first.id]);

      await repository.deleteNote(first.id);
      notes = await repository.loadNotes();
      expect(notes.single.id, second.id);
    });

    test('emits quickNote synchronization mutations', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final calls = <String>[];
      Future<T> synchronize<T>({
        required String entityType,
        required String entityId,
        required String operationKind,
        required Map<String, Object?> changedFields,
        required Future<T> Function() mutate,
      }) async {
        calls.add('$entityType:$operationKind');
        return mutate();
      }

      final repository = DriftQuickNotesRepository(
        QuickNotesDao(database),
        sync: synchronize,
        idGenerator: SecureSyncIdGenerator(random: Random(7)),
      );
      addTearDown(database.close);

      final note = await repository.createNote(
        text: 'Sincronizar',
        colorArgb: 0xFF445566,
        localDate: null,
        priority: null,
      );
      await repository.toggleCompletion(note.id);
      await repository.deleteNote(note.id);

      expect(note.id, startsWith('quick-note_'));
      expect(calls, [
        'quickNote:create',
        'quickNote:update',
        'quickNote:delete',
      ]);
    });
  });
}
