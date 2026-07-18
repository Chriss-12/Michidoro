import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/calendar/data/datasources/calendar_events_database.dart';
import 'package:pomodoro_app_v1/features/calendar/data/repositories/drift_calendar_events_repository.dart';

void main() {
  group('DriftCalendarEventsRepository', () {
    test(
      'persists calendar events in the local SQLite database file',
      () async {
        final directory = Directory.systemTemp.createTempSync(
          'michifocus_calendar_events_test',
        );
        final file = File('${directory.path}/calendar_events.sqlite');
        var database = CalendarEventsDatabase(NativeDatabase(file));
        var repository = DriftCalendarEventsRepository(
          CalendarEventsDao(database),
        );

        addTearDown(() async {
          await database.close();
          if (directory.existsSync()) {
            directory.deleteSync(recursive: true);
          }
        });

        final createdEvent = await repository.createEvent(
          title: 'Persistir evento',
          scheduledAt: DateTime(2026, 7, 10, 9),
          durationMinutes: 45,
        );
        await database.close();

        database = CalendarEventsDatabase(NativeDatabase(file));
        repository = DriftCalendarEventsRepository(CalendarEventsDao(database));

        final events = await repository.loadEvents();

        expect(events, hasLength(1));
        expect(events.single.id, createdEvent.id);
        expect(events.single.title, 'Persistir evento');
        expect(events.single.scheduledAt, DateTime(2026, 7, 10, 9));
        expect(events.single.durationMinutes, 45);
      },
    );

    test('loads calendar events ordered by scheduled time', () async {
      final database = CalendarEventsDatabase(NativeDatabase.memory());
      final repository = DriftCalendarEventsRepository(
        CalendarEventsDao(database),
      );

      addTearDown(database.close);

      await repository.createEvent(
        title: 'Tarde',
        scheduledAt: DateTime(2026, 7, 10, 16),
        durationMinutes: 25,
      );
      await repository.createEvent(
        title: 'Manana',
        scheduledAt: DateTime(2026, 7, 10, 9),
        durationMinutes: 25,
      );

      final events = await repository.loadEvents();

      expect(events.map((event) => event.title), ['Manana', 'Tarde']);
    });
  });
}
