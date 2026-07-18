import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart';

abstract class CalendarEventsRepository {
  Future<List<CalendarEvent>> loadEvents();

  Future<CalendarEvent> createEvent({
    required String title,
    required DateTime scheduledAt,
    required int durationMinutes,
  });
}
