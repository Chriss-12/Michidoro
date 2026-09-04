import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/repositories/quick_notes_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_coordinator.dart';

class DriftQuickNotesRepository implements QuickNotesRepository {
  DriftQuickNotesRepository(
    this._dao, {
    SyncMutationCoordinator? sync,
    SecureSyncIdGenerator? idGenerator,
    DateTime Function()? clock,
  }) : _sync = sync,
       _idGenerator = idGenerator,
       _clock = clock ?? DateTime.now;

  static const _positionStep = 4294967296;

  final QuickNotesDao _dao;
  final SyncMutationCoordinator? _sync;
  final SecureSyncIdGenerator? _idGenerator;
  final DateTime Function() _clock;
  var _idSequence = 0;

  @override
  Future<List<QuickNote>> loadNotes() async =>
      (await _dao.getAllNotes()).map(_toDomain).toList(growable: false);

  @override
  Future<QuickNote> createNote({
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async {
    _validate(text: text, colorArgb: colorArgb, localDate: localDate);
    final now = _clock();
    final id =
        _idGenerator?.create('quick-note') ??
        'quick_note_${now.microsecondsSinceEpoch}_${_idSequence++}';
    final position = await _dao.nextPosition();
    final fields = _fields(
      text: text,
      isCompleted: false,
      colorArgb: colorArgb,
      localDate: localDate,
      priority: priority,
      position: position,
      createdAt: now,
      updatedAt: now,
    );
    final record = await _run(
      entityId: id,
      operationKind: 'create',
      changedFields: fields,
      mutate: () => _dao.insertNote(
        QuickNoteRecordsCompanion.insert(
          id: id,
          textContent: text,
          colorArgb: colorArgb,
          localDate: Value(_dateKeyOrNull(localDate)),
          priority: Value(priority?._storageValue),
          position: position,
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );
    return _toDomain(record);
  }

  @override
  Future<QuickNote?> updateNote({
    required String id,
    required String text,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async {
    _validate(text: text, colorArgb: colorArgb, localDate: localDate);
    if (await _dao.findById(id) == null) return null;
    final now = _clock();
    final record = await _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'text': text,
        'colorArgb': colorArgb,
        'localDate': _dateKeyOrNull(localDate),
        'priority': priority?._storageValue,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateDetails(
        id: id,
        textContent: text,
        colorArgb: colorArgb,
        localDate: _dateKeyOrNull(localDate),
        priority: priority?._storageValue,
        updatedAt: now,
      ),
    );
    return record == null ? null : _toDomain(record);
  }

  @override
  Future<QuickNote?> toggleCompletion(String id) async {
    final current = await _dao.findById(id);
    if (current == null) return null;
    final now = _clock();
    final completed = !current.isCompleted;
    final record = await _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'isCompleted': completed,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updateCompletion(
        id: id,
        isCompleted: completed,
        updatedAt: now,
      ),
    );
    return record == null ? null : _toDomain(record);
  }

  @override
  Future<QuickNote?> moveNote(String id, int newIndex) async {
    var records = await _dao.getAllNotes();
    final oldIndex = records.indexWhere((note) => note.id == id);
    if (oldIndex < 0) return null;
    final boundedIndex = newIndex.clamp(0, records.length - 1);
    if (boundedIndex == oldIndex) return _toDomain(records[oldIndex]);

    final moved = records.removeAt(oldIndex);
    records.insert(boundedIndex, moved);
    var position = _positionFor(records, boundedIndex);
    if (position == null) {
      final now = _clock();
      await _dao.normalizePositions(now);
      records = await _dao.getAllNotes();
      final normalizedIndex = records.indexWhere((note) => note.id == id);
      final normalized = records.removeAt(normalizedIndex);
      records.insert(boundedIndex, normalized);
      position = _positionFor(records, boundedIndex);
    }
    if (position == null) {
      throw StateError('Could not allocate a stable note position.');
    }

    final now = _clock();
    final record = await _run(
      entityId: id,
      operationKind: 'update',
      changedFields: {
        'position': position,
        'updatedAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.updatePosition(
        id: id,
        position: position!,
        updatedAt: now,
      ),
    );
    return record == null ? null : _toDomain(record);
  }

  @override
  Future<void> deleteNote(String id) async {
    if (await _dao.findById(id) == null) return;
    await _run<void>(
      entityId: id,
      operationKind: 'delete',
      changedFields: const {},
      mutate: () => _dao.deleteById(id),
    );
  }

  int? _positionFor(List<QuickNoteRecord> records, int index) {
    final previous = index == 0 ? null : records[index - 1].position;
    final next = index == records.length - 1
        ? null
        : records[index + 1].position;
    if (previous == null) return (next ?? 0) - _positionStep;
    if (next == null) return previous + _positionStep;
    if (next - previous <= 1) return null;
    return previous + ((next - previous) ~/ 2);
  }

  Future<T> _run<T>({
    required String entityId,
    required String operationKind,
    required Map<String, Object?> changedFields,
    required Future<T> Function() mutate,
  }) {
    final sync = _sync;
    if (sync == null) return mutate();
    return sync(
      entityType: 'quickNote',
      entityId: entityId,
      operationKind: operationKind,
      changedFields: changedFields,
      mutate: mutate,
    );
  }

  Map<String, Object?> _fields({
    required String text,
    required bool isCompleted,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) => {
    'text': text,
    'isCompleted': isCompleted,
    'colorArgb': colorArgb,
    'localDate': _dateKeyOrNull(localDate),
    'priority': priority?._storageValue,
    'position': position,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
  };

  QuickNote _toDomain(QuickNoteRecord record) => QuickNote(
    id: record.id,
    text: record.textContent,
    isCompleted: record.isCompleted,
    colorArgb: record.colorArgb,
    localDate: _parseDate(record.localDate),
    priority: _priorityFromStorage(record.priority),
    position: record.position,
    createdAt: record.createdAt,
    updatedAt: record.updatedAt,
  );

  void _validate({
    required String text,
    required int colorArgb,
    required DateTime? localDate,
  }) {
    if (text.trim() != text || text.isEmpty || text.length > 500) {
      throw const FormatException('Invalid quick-note text.');
    }
    if (colorArgb < 0xFF000000 || colorArgb > 0xFFFFFFFF) {
      throw const FormatException('Invalid quick-note color.');
    }
    if (localDate != null &&
        (localDate.hour != 0 ||
            localDate.minute != 0 ||
            localDate.second != 0 ||
            localDate.millisecond != 0 ||
            localDate.microsecond != 0)) {
      throw const FormatException('Quick-note date must be date-only.');
    }
  }
}

extension on QuickNotePriority {
  String get _storageValue => switch (this) {
    QuickNotePriority.high => 'high',
    QuickNotePriority.medium => 'medium',
    QuickNotePriority.low => 'low',
  };
}

QuickNotePriority? _priorityFromStorage(String? value) => switch (value) {
  null => null,
  'high' => QuickNotePriority.high,
  'medium' => QuickNotePriority.medium,
  'low' => QuickNotePriority.low,
  _ => throw const FormatException('Invalid quick-note priority.'),
};

String? _dateKeyOrNull(DateTime? value) => value == null
    ? null
    : '${value.year.toString().padLeft(4, '0')}-'
          '${value.month.toString().padLeft(2, '0')}-'
          '${value.day.toString().padLeft(2, '0')}';

DateTime? _parseDate(String? value) {
  if (value == null) return null;
  final parts = value.split('-');
  if (parts.length != 3) {
    throw const FormatException('Invalid quick-note date.');
  }
  final date = DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
  if (_dateKeyOrNull(date) != value) {
    throw const FormatException('Invalid quick-note date.');
  }
  return date;
}
