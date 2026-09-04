import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/repositories/quick_notes_repository.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/controllers/quick_notes_controller.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/widgets/quick_notes_view.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('creates and completes a note on a narrow themed screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = QuickNotesController(
      repository: _WidgetNotesRepository(),
      now: () => DateTime(2026, 8, 27),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.fromPreset(
          AppThemePreset.graphiteNight,
          isDark: true,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: QuickNotesView(
              controller: controller,
              initialDate: DateTime(2026, 8, 27),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sin notas rápidas'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'initial quick-note view');
    await tester.tap(find.byKey(const ValueKey('create-quick-note-button')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'opened note editor');
    await tester.enterText(
      find.byKey(const ValueKey('quick-note-text-field')),
      'Idea para mañana',
    );
    final colorField = find.byKey(const ValueKey('quick-note-color-field'));
    await tester.ensureVisible(colorField);
    await tester.pumpAndSettle();
    final colorRect = tester.getRect(colorField);
    await tester.tapAt(
      Offset(
        colorRect.left + colorRect.width * 0.85,
        colorRect.top + colorRect.height * 0.2,
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull, reason: 'used Paint color field');
    await tester.ensureVisible(
      find.byKey(const ValueKey('save-quick-note-button')),
    );
    await tester.tap(find.byKey(const ValueKey('save-quick-note-button')));
    await tester.pumpAndSettle();

    expect(find.text('Idea para mañana'), findsOneWidget);
    expect(controller.notes.value.single.localDate, DateTime(2026, 8, 27));
    expect(controller.notes.value.single.colorArgb, isNot(0xFF6F8F68));
    expect(tester.takeException(), isNull, reason: 'saved dated note');
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(controller.notes.value.single.isCompleted, isTrue);
    final layoutException = tester.takeException();
    expect(
      layoutException,
      isNull,
      reason: layoutException is FlutterError
          ? layoutException.toStringDeep()
          : '$layoutException',
    );
  });

  testWidgets('unlocks saving and explains a persistence failure', (
    tester,
  ) async {
    final controller = QuickNotesController(
      repository: _FailingNotesRepository(),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: QuickNotesView(controller: controller)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('create-quick-note-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('quick-note-text-field')),
      'Nota con fallo',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('save-quick-note-button')),
    );
    await tester.tap(find.byKey(const ValueKey('save-quick-note-button')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No se pudo guardar la nota'),
      findsOneWidget,
    );
    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('save-quick-note-button')),
    );
    expect(button.onPressed, isNotNull);
  });
}

class _FailingNotesRepository extends _WidgetNotesRepository {
  @override
  Future<QuickNote> createNote({
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) => Future.error(StateError('persistence unavailable'));
}

class _WidgetNotesRepository implements QuickNotesRepository {
  final List<QuickNote> _notes = [];

  @override
  Future<List<QuickNote>> loadNotes() async => List.of(_notes);

  @override
  Future<QuickNote> createNote({
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async {
    final now = DateTime.utc(2026, 8, 27);
    final note = QuickNote(
      id: 'note-${_notes.length}',
      text: text,
      isCompleted: false,
      colorArgb: colorArgb,
      localDate: localDate,
      priority: priority,
      position: _notes.length * 100,
      createdAt: now,
      updatedAt: now,
    );
    _notes.add(note);
    return note;
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
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
  }

  @override
  Future<QuickNote?> moveNote(String id, int newIndex) async =>
      _notes.where((note) => note.id == id).firstOrNull;

  @override
  Future<QuickNote?> updateNote({
    required String id,
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async => _notes.where((note) => note.id == id).firstOrNull;
}
