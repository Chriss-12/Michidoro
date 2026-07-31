import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
// NativeDatabase exposes sqlite3's Database type in its setup callback.
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'migrates schema 1 without inventing legacy completion events',
    () async {
      final directory = Directory.systemTemp.createTempSync(
        'michifocus_schema_1_migration',
      );
      final file = File('${directory.path}/michifocus.sqlite');
      final executor = NativeDatabase(file, setup: _createSchemaOne);
      final database = MichiFocusDatabase(executor);

      addTearDown(() async {
        await database.close();
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      final legacyTask = await TasksDao(database).findById('legacy-completed');
      final events = await ReportsDao(database).getCompletionEventsInRange(
        start: DateTime(1970),
        end: DateTime(2100),
      );
      final metadata = await database
          .select(database.reportingMetadataRecords)
          .get();
      final runtime = await database
          .select(database.pomodoroRuntimeRecords)
          .get();
      final version = await database
          .customSelect('PRAGMA user_version')
          .getSingle();

      expect(legacyTask, isNotNull);
      expect(legacyTask?.legacyCompletionUnknown, isTrue);
      expect(events, isEmpty);
      expect(metadata, hasLength(1));
      expect(metadata.single.id, 'completion-history');
      expect(runtime, isEmpty);
      expect(version.read<int>('user_version'), 3);
    },
  );

  test('migrates schema 2 by adding the singleton runtime table', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus_schema_2_migration',
    );
    final file = File('${directory.path}/michifocus.sqlite');
    var database = MichiFocusDatabase(NativeDatabase(file));
    await database.customSelect('SELECT 1').getSingle();
    // Initialization must finish before the file is reopened with sqlite3.
    // ignore: cascade_invocations
    await database.close();

    sqlite3.open(file.path)
      ..execute('DROP TABLE pomodoro_runtime')
      ..execute('PRAGMA user_version = 2')
      ..dispose();

    database = MichiFocusDatabase(NativeDatabase(file));
    addTearDown(() async {
      await database.close();
      directory.deleteSync(recursive: true);
    });

    final runtime = await database
        .select(database.pomodoroRuntimeRecords)
        .get();
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();

    expect(runtime, isEmpty);
    expect(version.read<int>('user_version'), 3);
  });
}

void _createSchemaOne(Database database) {
  database
    ..execute('''
      CREATE TABLE goals (
        id TEXT NOT NULL PRIMARY KEY,
        title TEXT NOT NULL,
        target_sessions INTEGER NOT NULL,
        completed_sessions INTEGER NOT NULL DEFAULT 0,
        target_date INTEGER NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''')
    ..execute('''
      CREATE TABLE tasks (
        id TEXT NOT NULL PRIMARY KEY,
        title TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'listed',
        scheduled_date INTEGER NULL,
        goal_id TEXT NULL REFERENCES goals(id) ON DELETE SET NULL,
        duration_minutes INTEGER NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''')
    ..execute('''
      CREATE TABLE pomodoro_sessions (
        id TEXT NOT NULL PRIMARY KEY,
        started_at INTEGER NOT NULL,
        ended_at INTEGER NOT NULL,
        planned_seconds INTEGER NOT NULL,
        focused_seconds INTEGER NOT NULL,
        goal_id TEXT NULL REFERENCES goals(id) ON DELETE SET NULL,
        task_id TEXT NULL REFERENCES tasks(id) ON DELETE SET NULL,
        start_mood_score INTEGER NULL,
        end_mood_score INTEGER NULL,
        was_distracted INTEGER NULL,
        distraction_minutes INTEGER NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''')
    ..execute('''
      CREATE TABLE calendar_events (
        id TEXT NOT NULL PRIMARY KEY,
        title TEXT NOT NULL,
        scheduled_at INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''')
    ..execute('''
      INSERT INTO tasks (
        id, title, is_completed, status, created_at, updated_at
      ) VALUES (
        'legacy-completed', 'Legacy', 1, 'completed', 1, 1
      )
    ''')
    ..execute('PRAGMA user_version = 1');
}
