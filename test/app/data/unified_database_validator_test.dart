import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/app/data/datasources/unified_database_validator.dart';
// NativeDatabase exposes sqlite3's Database type in its setup callback.
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';

void main() {
  const validator = UnifiedDatabaseValidator();

  test('accepts a complete current unified database', () async {
    final fixture = await _createCurrentFixture('valid');
    addTearDown(fixture.dispose);

    await validator.validateForImport(fixture.file);

    final database = MichiFocusDatabase(NativeDatabase(fixture.file));
    addTearDown(database.close);
    final tables = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    expect(
      tables.map((row) => row.read<String>('name')).toSet(),
      containsAll(UnifiedDatabaseValidator.requiredTables),
    );
  });

  test('rejects an empty SQLite file instead of initializing it', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus_validator_empty_sqlite',
    );
    final file = File('${directory.path}/michifocus.sqlite');
    sqlite3.open(file.path).dispose();
    final before = await file.readAsBytes();
    addTearDown(() => directory.deleteSync(recursive: true));

    await expectLater(
      validator.validateForImport(file),
      throwsA(isA<FormatException>()),
    );

    expect(await file.readAsBytes(), before);
  });

  test('migrates a staged schema 4 fixture before validating it', () async {
    final fixture = await _createCurrentFixture('schema-4');
    addTearDown(fixture.dispose);
    final raw = sqlite3.open(fixture.file.path);
    _dropRoutineTables(raw);
    _dropSyncTables(raw);
    raw
      ..execute('PRAGMA user_version = 4')
      ..dispose();

    await validator.validateForImport(fixture.file);

    final database = MichiFocusDatabase(NativeDatabase(fixture.file));
    addTearDown(database.close);
    expect(
      (await database.customSelect('PRAGMA user_version').getSingle())
          .read<int>('user_version'),
      MichiFocusDatabase.currentSchemaVersion,
    );
    expect(await database.select(database.routineRecords).get(), isEmpty);
  });

  test('rejects a future schema without modifying its bytes', () async {
    final fixture = await _createCurrentFixture('future');
    addTearDown(fixture.dispose);
    sqlite3.open(fixture.file.path)
      ..execute('PRAGMA user_version = 99')
      ..dispose();
    final before = await fixture.file.readAsBytes();

    await expectLater(
      validator.validateForImport(fixture.file),
      throwsA(isA<FormatException>()),
    );

    expect(await fixture.file.readAsBytes(), before);
  });

  test('rejects a current schema with a missing required index', () async {
    final fixture = await _createCurrentFixture('missing-index');
    addTearDown(fixture.dispose);
    sqlite3.open(fixture.file.path)
      ..execute('DROP INDEX routine_runs_occurrence_uq')
      ..dispose();

    await expectLater(
      validator.validateForImport(fixture.file),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a named unique index recreated as non-unique', () async {
    final fixture = await _createCurrentFixture('non-unique-index');
    addTearDown(fixture.dispose);
    sqlite3.open(fixture.file.path)
      ..execute('DROP INDEX routine_runs_occurrence_uq')
      ..execute(
        'CREATE INDEX routine_runs_occurrence_uq '
        'ON routine_runs (source_routine_id, local_date)',
      )
      ..dispose();

    await expectLater(
      validator.validateForImport(fixture.file),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a current schema with a missing required table', () async {
    final fixture = await _createCurrentFixture('missing-table');
    addTearDown(fixture.dispose);
    sqlite3.open(fixture.file.path)
      ..execute('DROP TABLE calendar_events')
      ..dispose();

    await expectLater(
      validator.validateForImport(fixture.file),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects an altered table column inventory', () async {
    final fixture = await _createCurrentFixture('altered-columns');
    addTearDown(fixture.dispose);
    sqlite3.open(fixture.file.path)
      ..execute('ALTER TABLE calendar_events ADD COLUMN intruder TEXT')
      ..dispose();

    await expectLater(
      validator.validateForImport(fixture.file),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects broken foreign-key references', () async {
    final fixture = await _createCurrentFixture('broken-foreign-key');
    addTearDown(fixture.dispose);
    sqlite3.open(fixture.file.path)
      ..execute('PRAGMA foreign_keys = OFF')
      ..execute('''
        INSERT INTO tasks (
          id, title, goal_id, created_at, updated_at
        ) VALUES ('orphan-task', 'Orphan', 'missing-goal', 1, 1)
      ''')
      ..dispose();

    await expectLater(
      validator.validateForImport(fixture.file),
      throwsA(isA<FormatException>()),
    );
  });

  test(
    'pauses imported runtime without changing its context or time',
    () async {
      final fixture = await _createCurrentFixture('active-runtime');
      addTearDown(fixture.dispose);
      final database = MichiFocusDatabase(NativeDatabase(fixture.file));
      final now = DateTime(2026, 8, 9, 12);
      await TasksDao(database).insertTask(
        TaskRecordsCompanion.insert(
          id: 'routine-task',
          title: 'Routine task',
          durationMinutes: const Value(45),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await PomodoroRuntimeDao(database).saveActive(
        PomodoroRuntimeRecordsCompanion.insert(
          id: 'active-runtime',
          taskId: const Value('routine-task'),
          taskTitle: const Value('Routine task'),
          taskEstimatedMinutes: const Value(45),
          phase: 'focus',
          isRunning: true,
          remainingSeconds: 777,
          phaseTotalSeconds: 1500,
          cadenceFocusMinutes: 25,
          cadenceBreakMinutes: 5,
          longBreakMinutes: 15,
          longBreakFrequency: 4,
          autoStartBreak: true,
          autoStartFocus: false,
          planMode: 'continuous',
          blockIndex: 2,
          blockCount: 2,
          taskFocusedSecondsAtStart: 723,
          focusStartedAt: Value(now.subtract(const Duration(minutes: 12))),
          lastTickAt: Value(now),
          createdAt: now.subtract(const Duration(minutes: 12)),
          updatedAt: now,
        ),
      );
      await database.close();

      await validator.validateForImport(fixture.file);

      final imported = MichiFocusDatabase(NativeDatabase(fixture.file));
      addTearDown(imported.close);
      final runtime = await PomodoroRuntimeDao(imported).loadActive();
      expect(runtime?.isRunning, isFalse);
      expect(runtime?.lastTickAt, isNull);
      expect(runtime?.taskId, 'routine-task');
      expect(runtime?.taskTitle, 'Routine task');
      expect(runtime?.remainingSeconds, 777);
      expect(runtime?.blockIndex, 2);
      expect(runtime?.taskFocusedSecondsAtStart, 723);
    },
  );

  test(
    'rejects non-canonical local dates that pass the SQL shape check',
    () async {
      final fixture = await _createCurrentFixture('invalid-date');
      addTearDown(fixture.dispose);
      sqlite3.open(fixture.file.path)
        ..execute('''
        INSERT INTO routines (
          id, name, icon_key, color_key, status, created_at, updated_at
        ) VALUES ('routine', 'Routine', 'sun', 'amber', 'active', 1, 1)
      ''')
        ..execute('''
        INSERT INTO routine_runs (
          id, routine_id, source_routine_id, local_date, status,
          name_snapshot, icon_key_snapshot, color_key_snapshot,
          scheduled_start_minute_snapshot, created_at, updated_at
        ) VALUES (
          'run', 'routine', 'routine', '2026-99-99', 'scheduled',
          'Routine', 'sun', 'amber', 420, 1, 1
        )
      ''')
        ..dispose();

      await expectLater(
        validator.validateForImport(fixture.file),
        throwsA(isA<FormatException>()),
      );
    },
  );
}

Future<_DatabaseFixture> _createCurrentFixture(String name) async {
  final directory = Directory.systemTemp.createTempSync(
    'michifocus_validator_$name',
  );
  final file = File('${directory.path}/michifocus.sqlite');
  final database = MichiFocusDatabase(NativeDatabase(file));
  await database.customSelect('SELECT 1').getSingle();
  await database.close();
  return _DatabaseFixture(directory, file);
}

void _dropRoutineTables(Database database) {
  database
    ..execute('DROP TABLE routine_item_runs')
    ..execute('DROP TABLE routine_runs')
    ..execute('DROP TABLE routine_items')
    ..execute('DROP TABLE routine_days')
    ..execute('DROP TABLE routines');
}

void _dropSyncTables(Database database) {
  database
    ..execute('DROP TABLE sync_acknowledgements')
    ..execute('DROP TABLE sync_conflicts')
    ..execute('DROP TABLE sync_tombstones')
    ..execute('DROP TABLE sync_entity_versions')
    ..execute('DROP TABLE sync_applied_operations')
    ..execute('DROP TABLE sync_outbox')
    ..execute('DROP TABLE sync_local_state');
}

class _DatabaseFixture {
  const _DatabaseFixture(this.directory, this.file);

  final Directory directory;
  final File file;

  void dispose() {
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  }
}
