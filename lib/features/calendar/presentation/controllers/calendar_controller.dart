import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CalendarController {
  CalendarController({required CalendarEventsRepository repository})
    : _repository = repository;

  final CalendarEventsRepository _repository;
  final FlutterSignal<List<CalendarEvent>> events = signal(const []);
  final FlutterSignal<String?> validationMessage = signal(null);
  final FlutterSignal<bool> isLoading = signal(false);

  Future<void> loadEvents() async {
    isLoading.value = true;
    events.value = await _repository.loadEvents();
    isLoading.value = false;
  }

  Future<bool> createEvent({
    required String rawTitle,
    required DateTime scheduledAt,
    required int durationMinutes,
  }) async {
    final title = rawTitle.trim();

    if (title.isEmpty) {
      validationMessage.value = 'Escribe un titulo para guardar el evento.';
      return false;
    }

    if (durationMinutes < 1) {
      validationMessage.value = 'La duracion debe ser mayor a 0 minutos.';
      return false;
    }

    final event = await _repository.createEvent(
      title: title,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
    );

    events.value = [...events.value, event]..sort(_sortByScheduledAt);
    validationMessage.value = null;
    return true;
  }

  List<CalendarEvent> eventsForDay(DateTime day) {
    return events.value
        .where((event) => _sameDate(event.scheduledAt, day))
        .toList(growable: false);
  }

  Set<int> plannedDaysForMonth(DateTime month) {
    return events.value
        .where(
          (event) =>
              event.scheduledAt.year == month.year &&
              event.scheduledAt.month == month.month,
        )
        .map((event) => event.scheduledAt.day)
        .toSet();
  }

  void clearValidationMessage() {
    if (validationMessage.value == null) {
      return;
    }

    validationMessage.value = null;
  }

  static int _sortByScheduledAt(CalendarEvent first, CalendarEvent second) {
    final scheduledComparison = first.scheduledAt.compareTo(
      second.scheduledAt,
    );
    if (scheduledComparison != 0) {
      return scheduledComparison;
    }

    return second.createdAt.compareTo(first.createdAt);
  }
}

bool _sameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
