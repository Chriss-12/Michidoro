import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart'
    as domain;
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';

class DriftCalendarEventsRepository implements CalendarEventsRepository {
  DriftCalendarEventsRepository(this._dao);

  final CalendarEventsDao _dao;
  int _idSequence = 0;

  @override
  Future<List<domain.CalendarEvent>> loadEvents() async {
    final records = await _dao.getAllEvents();
    return records.map(_toDomain).toList(growable: false);
  }

  @override
  Future<domain.CalendarEvent> createEvent({
    required String title,
    required DateTime scheduledAt,
    required int durationMinutes,
  }) async {
    final now = DateTime.now();
    final record = await _dao.insertEvent(
      CalendarEventRecordsCompanion.insert(
        id: _createLocalId(now),
        title: title,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        createdAt: now,
      ),
    );

    return _toDomain(record);
  }

  String _createLocalId(DateTime now) {
    return '${now.microsecondsSinceEpoch}-${_idSequence++}';
  }

  domain.CalendarEvent _toDomain(CalendarEventRecord record) {
    return domain.CalendarEvent(
      id: record.id,
      title: record.title,
      scheduledAt: record.scheduledAt,
      durationMinutes: record.durationMinutes,
      createdAt: record.createdAt,
    );
  }
}
