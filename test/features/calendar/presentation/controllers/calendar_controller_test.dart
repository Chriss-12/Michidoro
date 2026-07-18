import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';

void main() {
  group('CalendarController', () {
    test('rejects blank event titles', () async {
      final controller = CalendarController(
        repository: _MemoryCalendarEventsRepository(),
      );

      final saved = await controller.createEvent(
        rawTitle: '   ',
        scheduledAt: DateTime(2026, 7, 10, 9),
        durationMinutes: 25,
      );

      expect(saved, isFalse);
      expect(controller.events.value, isEmpty);
      expect(
        controller.validationMessage.value,
        'Escribe un titulo para guardar el evento.',
      );
    });

    test('creates events and exposes day and month planning state', () async {
      final controller = CalendarController(
        repository: _MemoryCalendarEventsRepository(),
      );

      final saved = await controller.createEvent(
        rawTitle: '  Planificar M5  ',
        scheduledAt: DateTime(2026, 7, 10, 9),
        durationMinutes: 45,
      );

      expect(saved, isTrue);
      expect(controller.validationMessage.value, isNull);
      expect(controller.events.value.single.title, 'Planificar M5');
      expect(controller.eventsForDay(DateTime(2026, 7, 10)), hasLength(1));
      expect(controller.eventsForDay(DateTime(2026, 7, 11)), isEmpty);
      expect(controller.plannedDaysForMonth(DateTime(2026, 7)), {10});
    });

    test('loads persisted events from repository', () async {
      final repository = _MemoryCalendarEventsRepository();
      await repository.createEvent(
        title: 'Cargar calendario',
        scheduledAt: DateTime(2026, 7, 10, 11),
        durationMinutes: 25,
      );
      final controller = CalendarController(repository: repository);

      await controller.loadEvents();

      expect(controller.events.value, hasLength(1));
      expect(controller.events.value.single.title, 'Cargar calendario');
    });
  });
}

class _MemoryCalendarEventsRepository implements CalendarEventsRepository {
  final List<CalendarEvent> _events = [];
  int _nextId = 0;

  @override
  Future<List<CalendarEvent>> loadEvents() async {
    return List.unmodifiable(_events);
  }

  @override
  Future<CalendarEvent> createEvent({
    required String title,
    required DateTime scheduledAt,
    required int durationMinutes,
  }) async {
    final event = CalendarEvent(
      id: (_nextId++).toString(),
      title: title,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      createdAt: DateTime(2026, 7, 10, 8),
    );
    _events
      ..add(event)
      ..sort(
        (first, second) => first.scheduledAt.compareTo(
          second.scheduledAt,
        ),
      );
    return event;
  }
}
