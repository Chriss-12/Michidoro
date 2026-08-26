import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/app/data/datasources/unified_database_validator.dart';
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
      final indexes = await database
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
          .get();

      expect(legacyTask, isNotNull);
      expect(legacyTask?.legacyCompletionUnknown, isTrue);
      expect(events, isEmpty);
      expect(metadata, hasLength(1));
      expect(metadata.single.id, 'completion-history');
      expect(runtime, isEmpty);
      expect(version.read<int>('user_version'), 7);
      expect(await database.select(database.routineRecords).get(), isEmpty);
      expect(
        indexes.map((row) => row.read<String>('name')).toSet(),
        containsAll(UnifiedDatabaseValidator.requiredIndexes),
      );
    },
  );

  test('migrates schema 2 with runtime and pending mood prompts', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus_schema_2_migration',
    );
    final file = File('${directory.path}/michifocus.sqlite');
    var database = MichiFocusDatabase(NativeDatabase(file));
    await database.customSelect('SELECT 1').getSingle();
    // Initialization must finish before the file is reopened with sqlite3.
    // ignore: cascade_invocations
    await database.close();

    final rawDatabase = sqlite3.open(file.path);
    _dropRoutineTables(rawDatabase);
    _dropSyncTables(rawDatabase);
    rawDatabase
      ..execute('DROP TABLE pomodoro_runtime')
      ..execute(
        'ALTER TABLE pomodoro_sessions DROP COLUMN mood_prompt_pending',
      )
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
    final columns = await database
        .customSelect('PRAGMA table_info(pomodoro_sessions)')
        .get();

    expect(runtime, isEmpty);
    expect(
      columns.map((column) => column.read<String>('name')),
      contains('mood_prompt_pending'),
    );
    expect(version.read<int>('user_version'), 7);
  });

  test('migrates populated schema 3 and preserves active runtime', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus_schema_3_migration',
    );
    final file = File('${directory.path}/michifocus.sqlite');
    var database = MichiFocusDatabase(NativeDatabase(file));
    final now = DateTime(2026, 8, 7, 9);
    await TasksDao(database).insertTask(
      TaskRecordsCompanion.insert(
        id: 'task-v3',
        title: 'Runtime task',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await PomodoroRuntimeDao(database).saveActive(
      PomodoroRuntimeRecordsCompanion.insert(
        id: 'active-runtime',
        taskId: const Value('task-v3'),
        taskTitle: const Value('Runtime task'),
        phase: 'focus',
        isRunning: true,
        remainingSeconds: 900,
        phaseTotalSeconds: 1500,
        cadenceFocusMinutes: 25,
        cadenceBreakMinutes: 5,
        longBreakMinutes: 15,
        longBreakFrequency: 4,
        autoStartBreak: true,
        autoStartFocus: false,
        planMode: 'continuous',
        blockIndex: 1,
        blockCount: 2,
        taskFocusedSecondsAtStart: 0,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.close();

    final rawDatabase = sqlite3.open(file.path);
    _dropRoutineTables(rawDatabase);
    _dropSyncTables(rawDatabase);
    rawDatabase
      ..execute(
        'ALTER TABLE pomodoro_sessions DROP COLUMN mood_prompt_pending',
      )
      ..execute('PRAGMA user_version = 3')
      ..dispose();

    database = MichiFocusDatabase(NativeDatabase(file));
    addTearDown(() async {
      await database.close();
      directory.deleteSync(recursive: true);
    });

    final runtime = await PomodoroRuntimeDao(database).loadActive();
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();

    expect(runtime?.id, 'active-runtime');
    expect(runtime?.taskId, 'task-v3');
    expect(runtime?.isRunning, isTrue);
    expect(version.read<int>('user_version'), 7);
    expect(await database.select(database.routineRecords).get(), isEmpty);
  });

  test('migrates populated schema 4 without changing existing rows', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus_schema_4_migration',
    );
    final file = File('${directory.path}/michifocus.sqlite');
    var database = MichiFocusDatabase(NativeDatabase(file));
    final now = DateTime(2026, 8, 7, 10);
    await GoalsDao(database).insertGoal(
      GoalRecordsCompanion.insert(
        id: 'goal-v4',
        title: 'Existing goal',
        targetSessions: 3,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await TasksDao(database).insertTask(
      TaskRecordsCompanion.insert(
        id: 'task-v4',
        title: 'Existing task',
        goalId: const Value('goal-v4'),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await PomodoroSessionsDao(database).insertSession(
      PomodoroSessionRecordsCompanion.insert(
        id: 'session-v4',
        startedAt: now,
        endedAt: now.add(const Duration(minutes: 25)),
        plannedSeconds: 1500,
        focusedSeconds: 1500,
        goalId: const Value('goal-v4'),
        taskId: const Value('task-v4'),
        moodPromptPending: const Value(true),
        status: 'completed',
        createdAt: now,
      ),
    );
    await database.close();

    final rawDatabase = sqlite3.open(file.path);
    _dropRoutineTables(rawDatabase);
    _dropSyncTables(rawDatabase);
    rawDatabase
      ..execute('PRAGMA user_version = 4')
      ..dispose();

    database = MichiFocusDatabase(NativeDatabase(file));
    addTearDown(() async {
      await database.close();
      directory.deleteSync(recursive: true);
    });

    final goal = await GoalsDao(database).findById('goal-v4');
    final task = await TasksDao(database).findById('task-v4');
    final session = await PomodoroSessionsDao(
      database,
    ).findById('session-v4');
    final indexes = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name LIKE 'routine_%'",
        )
        .get();

    expect(goal?.title, 'Existing goal');
    expect(task?.goalId, 'goal-v4');
    expect(session?.taskId, 'task-v4');
    expect(session?.moodPromptPending, isTrue);
    expect(await database.select(database.routineRecords).get(), isEmpty);
    expect(indexes, hasLength(14));
    expect(
      (await database.customSelect('PRAGMA user_version').getSingle())
          .read<int>('user_version'),
      7,
    );

    await database.close();
    database = MichiFocusDatabase(NativeDatabase(file));

    expect(
      (await GoalsDao(database).findById('goal-v4'))?.title,
      'Existing goal',
    );
    expect((await TasksDao(database).findById('task-v4'))?.goalId, 'goal-v4');
    expect(
      (await database.customSelect('PRAGMA user_version').getSingle())
          .read<int>('user_version'),
      7,
    );
    expect(
      await database
          .customSelect(
            'SELECT COUNT(*) AS count FROM sqlite_master '
            "WHERE type = 'table' AND name LIKE 'routine%'",
          )
          .map((row) => row.read<int>('count'))
          .getSingle(),
      5,
    );
  });

  test('migrates populated schema 5 and preserves application rows', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus_schema_5_migration',
    );
    final file = File('${directory.path}/michifocus.sqlite');
    var database = MichiFocusDatabase(NativeDatabase(file));
    final now = DateTime(2026, 8, 14, 9);
    await GoalsDao(database).insertGoal(
      GoalRecordsCompanion.insert(
        id: 'goal-v5',
        title: 'Preserved goal',
        targetSessions: 4,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.close();

    final rawDatabase = sqlite3.open(file.path);
    _dropSyncTables(rawDatabase);
    rawDatabase
      ..execute('PRAGMA user_version = 5')
      ..dispose();

    database = MichiFocusDatabase(NativeDatabase(file));
    addTearDown(() async {
      await database.close();
      directory.deleteSync(recursive: true);
    });

    expect(
      (await GoalsDao(database).findById('goal-v5'))?.title,
      'Preserved goal',
    );
    expect(await database.select(database.syncOutboxRecords).get(), isEmpty);
    expect(
      (await database.customSelect('PRAGMA user_version').getSingle())
          .read<int>('user_version'),
      7,
    );
  });

  test('migrates schema 6 and adds encrypted operation context', () async {
    final directory = Directory.systemTemp.createTempSync(
      'michifocus_schema_6_migration',
    );
    final file = File('${directory.path}/michifocus.sqlite');
    var database = MichiFocusDatabase(NativeDatabase(file));
    await database.customSelect('SELECT 1').getSingle();
    // Initialization must finish before the file is reopened with sqlite3.
    // ignore: cascade_invocations
    await database.close();

    sqlite3.open(file.path)
      ..execute('ALTER TABLE sync_outbox DROP COLUMN origin_device_name')
      ..execute('ALTER TABLE sync_outbox DROP COLUMN entity_snapshot_json')
      ..execute('ALTER TABLE sync_tombstones DROP COLUMN entity_snapshot_json')
      ..execute(
        'ALTER TABLE sync_entity_versions DROP COLUMN origin_device_name',
      )
      ..execute('ALTER TABLE sync_tombstones DROP COLUMN origin_device_name')
      ..execute('PRAGMA user_version = 6')
      ..dispose();

    database = MichiFocusDatabase(NativeDatabase(file));
    addTearDown(() async {
      await database.close();
      directory.deleteSync(recursive: true);
    });
    final outboxColumns = await database
        .customSelect('PRAGMA table_info(sync_outbox)')
        .get();
    final tombstoneColumns = await database
        .customSelect('PRAGMA table_info(sync_tombstones)')
        .get();
    final versionColumns = await database
        .customSelect('PRAGMA table_info(sync_entity_versions)')
        .get();

    expect(
      outboxColumns.map((row) => row.read<String>('name')),
      containsAll(['origin_device_name', 'entity_snapshot_json']),
    );
    expect(
      tombstoneColumns.map((row) => row.read<String>('name')),
      contains('entity_snapshot_json'),
    );
    expect(
      versionColumns.map((row) => row.read<String>('name')),
      contains('origin_device_name'),
    );
    expect(
      tombstoneColumns.map((row) => row.read<String>('name')),
      contains('origin_device_name'),
    );
    expect(
      (await database.customSelect('PRAGMA user_version').getSingle())
          .read<int>('user_version'),
      7,
    );
  });
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
