import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/legacy_database_migrator.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/tasks/data/datasources/tasks_database.dart'
    as legacy;

void main() {
  test('legacy completed tasks migrate as unknown history', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus-legacy-migration-',
    );
    final legacyFile = File(
      '${directory.path}/michifocus_tasks.sqlite',
    );
    final legacyDatabase = legacy.TasksDatabase(NativeDatabase(legacyFile));
    final now = DateTime(2026, 7, 28);

    addTearDown(() async {
      await legacyDatabase.close();
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    await legacy.TasksDao(legacyDatabase).insertTask(
      legacy.TaskRecordsCompanion.insert(
        id: 'legacy-completed',
        title: 'Terminada antes de unificar',
        isCompleted: const Value(true),
        status: const Value('completed'),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await legacyDatabase.close();

    await LegacyDatabaseMigrator.migrateIfNeeded(
      directoryOverride: directory,
    );

    final database = MichiFocusDatabase(
      NativeDatabase(File('${directory.path}/michifocus.sqlite')),
    );
    addTearDown(database.close);
    final task = await TasksDao(database).findById('legacy-completed');
    final events = await ReportsDao(database).getCompletionEventsInRange(
      start: DateTime(1970),
      end: DateTime(2100),
    );
    final metadata = await database
        .select(database.reportingMetadataRecords)
        .get();

    expect(task?.legacyCompletionUnknown, isTrue);
    expect(events, isEmpty);
    expect(metadata, hasLength(1));
  });
}
