import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/repositories/quick_notes_repository.dart';
import 'package:pomodoro_app_v1/shared/models/date_period_filter.dart';
import 'package:signals_flutter/signals_flutter.dart';

class QuickNotesController {
  QuickNotesController({
    required QuickNotesRepository repository,
    DateTime Function()? now,
  }) : _repository = repository,
       dateFilter = signal(DatePeriodFilter.today((now ?? DateTime.now)()));

  final QuickNotesRepository _repository;
  Future<void>? _loadInFlight;
  final FlutterSignal<List<QuickNote>> notes = signal(const []);
  final FlutterSignal<QuickNoteSort> sort = signal(QuickNoteSort.manual);
  final FlutterSignal<DatePeriodFilter> dateFilter;
  final FlutterSignal<String?> validationCode = signal(null);
  final FlutterSignal<bool> isLoading = signal(false);

  late final Computed<List<QuickNote>> sortedNotes = computed(() {
    final result = [...notes.value]..sort(_comparator(sort.value));
    return result;
  });

  late final Computed<List<QuickNote>> filteredNotes = computed(() {
    final selectedPeriod = dateFilter.value;
    final result = notes.value.where((note) {
      if (selectedPeriod.kind == DatePeriodFilterKind.all) return true;
      final localDate = note.localDate;
      return localDate != null && selectedPeriod.includes(localDate);
    }).toList()..sort(_comparator(sort.value));
    return result;
  });

  DatePeriodFilter get selectedDateFilter => dateFilter.value;

  set selectedDateFilter(DatePeriodFilter value) => dateFilter.value = value;

  Future<void> load() => _loadInFlight ??= _loadOnce();

  Future<void> _loadOnce() async {
    isLoading.value = true;
    try {
      notes.value = await _repository.loadNotes();
    } finally {
      isLoading.value = false;
      _loadInFlight = null;
    }
  }

  List<QuickNote> notesForDay(DateTime day) =>
      notes.value
          .where(
            (note) => note.localDate != null && _sameDate(note.localDate!, day),
          )
          .toList(growable: false)
        ..sort(_comparator(QuickNoteSort.manual));

  Future<bool> create({
    required String rawText,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async {
    final text = _validateText(rawText);
    if (text == null) return false;
    final note = await _repository.createNote(
      text: text,
      colorArgb: colorArgb,
      localDate: _normalizeDate(localDate),
      priority: priority,
    );
    notes.value = [...notes.value, note];
    validationCode.value = null;
    return true;
  }

  Future<bool> update({
    required String id,
    required String rawText,
    required int colorArgb,
    required DateTime? localDate,
    required QuickNotePriority? priority,
  }) async {
    final text = _validateText(rawText);
    if (text == null) return false;
    final updated = await _repository.updateNote(
      id: id,
      text: text,
      colorArgb: colorArgb,
      localDate: _normalizeDate(localDate),
      priority: priority,
    );
    if (updated == null) return false;
    _replace(updated);
    validationCode.value = null;
    return true;
  }

  Future<void> toggle(String id) async {
    final updated = await _repository.toggleCompletion(id);
    if (updated != null) _replace(updated);
  }

  Future<void> move(String id, int newIndex) async {
    final updated = await _repository.moveNote(id, newIndex);
    if (updated == null) return;
    _replace(updated);
  }

  Future<void> delete(String id) async {
    await _repository.deleteNote(id);
    notes.value = notes.value
        .where((note) => note.id != id)
        .toList(growable: false);
  }

  void clearValidation() => validationCode.value = null;

  String? _validateText(String rawText) {
    final text = rawText.trim();
    if (text.isEmpty) {
      validationCode.value = 'empty';
      return null;
    }
    if (text.length > 500) {
      validationCode.value = 'tooLong';
      return null;
    }
    return text;
  }

  void _replace(QuickNote updated) {
    notes.value = [
      for (final note in notes.value)
        if (note.id == updated.id) updated else note,
    ];
  }
}

Comparator<QuickNote> _comparator(QuickNoteSort sort) => (left, right) {
  final completed = left.isCompleted == right.isCompleted
      ? 0
      : left.isCompleted
      ? 1
      : -1;
  if (completed != 0) return completed;
  final result = switch (sort) {
    QuickNoteSort.manual => left.position.compareTo(right.position),
    QuickNoteSort.priority => _priorityWeight(
      left.priority,
    ).compareTo(_priorityWeight(right.priority)),
    QuickNoteSort.date => _nullableDateCompare(left.localDate, right.localDate),
    QuickNoteSort.recent => right.createdAt.compareTo(left.createdAt),
    QuickNoteSort.color => left.colorArgb.compareTo(right.colorArgb),
  };
  if (result != 0) return result;
  final position = left.position.compareTo(right.position);
  return position != 0 ? position : left.id.compareTo(right.id);
};

int _priorityWeight(QuickNotePriority? priority) => switch (priority) {
  QuickNotePriority.high => 0,
  QuickNotePriority.medium => 1,
  QuickNotePriority.low => 2,
  null => 3,
};

int _nullableDateCompare(DateTime? left, DateTime? right) {
  if (left == null && right == null) return 0;
  if (left == null) return 1;
  if (right == null) return -1;
  return left.compareTo(right);
}

DateTime? _normalizeDate(DateTime? value) =>
    value == null ? null : DateTime(value.year, value.month, value.day);

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
