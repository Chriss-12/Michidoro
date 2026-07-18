import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'calendar_events_database.g.dart';

class CalendarEventRecords extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  DateTimeColumn get scheduledAt => dateTime()();

  IntColumn get durationMinutes => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String get tableName => 'calendar_events';
}

@DriftAccessor(tables: [CalendarEventRecords])
class CalendarEventsDao extends DatabaseAccessor<CalendarEventsDatabase>
    with _$CalendarEventsDaoMixin {
  CalendarEventsDao(super.db);

  Future<List<CalendarEventRecord>> getAllEvents() {
    return (select(calendarEventRecords)..orderBy([
          (record) => OrderingTerm.asc(record.scheduledAt),
          (record) => OrderingTerm.desc(record.createdAt),
        ]))
        .get();
  }

  Future<CalendarEventRecord?> findById(String id) {
    return (select(
      calendarEventRecords,
    )..where((record) => record.id.equals(id))).getSingleOrNull();
  }

  Future<CalendarEventRecord> insertEvent(
    CalendarEventRecordsCompanion companion,
  ) async {
    await into(calendarEventRecords).insert(companion);
    final event = await findById(companion.id.value);
    return event!;
  }
}

@DriftDatabase(tables: [CalendarEventRecords], daos: [CalendarEventsDao])
class CalendarEventsDatabase extends _$CalendarEventsDatabase {
  CalendarEventsDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'michifocus_calendar_events'));

  @override
  int get schemaVersion => 1;
}
