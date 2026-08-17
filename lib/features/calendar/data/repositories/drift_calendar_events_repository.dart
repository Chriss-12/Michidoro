import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/entities/calendar_event.dart'
    as domain;
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_coordinator.dart';

class DriftCalendarEventsRepository implements CalendarEventsRepository {
  DriftCalendarEventsRepository(
    this._dao, {
    SyncMutationCoordinator? sync,
    SecureSyncIdGenerator? idGenerator,
    DateTime Function()? clock,
  }) : _sync = sync,
       _idGenerator = idGenerator,
       _clock = clock ?? DateTime.now;

  final CalendarEventsDao _dao;
  final SyncMutationCoordinator? _sync;
  final SecureSyncIdGenerator? _idGenerator;
  final DateTime Function() _clock;
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
    final now = _clock();
    final id = _createLocalId(now);
    final record = await _run(
      entityId: id,
      changedFields: {
        'title': title,
        'scheduledAt': scheduledAt.millisecondsSinceEpoch,
        'durationMinutes': durationMinutes,
        'createdAt': now.millisecondsSinceEpoch,
      },
      mutate: () => _dao.insertEvent(
        CalendarEventRecordsCompanion.insert(
          id: id,
          title: title,
          scheduledAt: scheduledAt,
          durationMinutes: durationMinutes,
          createdAt: now,
        ),
      ),
    );

    return _toDomain(record);
  }

  String _createLocalId(DateTime now) {
    return _idGenerator?.create('calendar-event') ??
        '${now.microsecondsSinceEpoch}-${_idSequence++}';
  }

  Future<T> _run<T>({
    required String entityId,
    required Map<String, Object?> changedFields,
    required Future<T> Function() mutate,
  }) {
    final sync = _sync;
    if (sync == null) return mutate();
    return sync(
      entityType: 'calendarEvent',
      entityId: entityId,
      operationKind: 'create',
      changedFields: changedFields,
      mutate: mutate,
    );
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
