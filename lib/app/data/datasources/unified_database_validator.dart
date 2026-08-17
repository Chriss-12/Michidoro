import 'dart:io';

import 'package:drift/native.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';

class UnifiedDatabaseValidator {
  const UnifiedDatabaseValidator();

  static const requiredTables = {
    'goals',
    'tasks',
    'pomodoro_sessions',
    'pomodoro_runtime',
    'calendar_events',
    'task_completion_events',
    'reporting_metadata',
    'routines',
    'routine_days',
    'routine_items',
    'routine_runs',
    'routine_item_runs',
    'sync_local_state',
    'sync_outbox',
    'sync_applied_operations',
    'sync_entity_versions',
    'sync_tombstones',
    'sync_conflicts',
    'sync_acknowledgements',
  };

  static const requiredIndexes = {
    'tasks_goal_id_idx',
    'tasks_scheduled_date_idx',
    'tasks_created_at_idx',
    'task_completion_events_completed_at_idx',
    'task_completion_events_task_completed_idx',
    'pomodoro_sessions_goal_id_idx',
    'pomodoro_sessions_task_id_idx',
    'pomodoro_sessions_started_at_idx',
    'pomodoro_sessions_ended_at_idx',
    'calendar_events_scheduled_at_idx',
    'routines_status_idx',
    'routines_updated_at_idx',
    'routine_days_weekday_routine_idx',
    'routine_items_routine_position_uq',
    'routine_items_routine_time_idx',
    'routine_items_goal_id_idx',
    'routine_runs_occurrence_uq',
    'routine_runs_date_status_idx',
    'routine_runs_routine_date_idx',
    'routine_item_runs_materialization_uq',
    'routine_item_runs_task_id_uq',
    'routine_item_runs_routine_item_id_idx',
    'routine_item_runs_schedule_status_idx',
    'routine_item_runs_run_position_idx',
    'sync_outbox_origin_counter_uq',
    'sync_outbox_state_created_idx',
    'sync_applied_origin_counter_uq',
    'sync_conflicts_entity_status_idx',
  };

  static const _indexContracts = <String, _IndexContract>{
    'tasks_goal_id_idx': _IndexContract('tasks', ['goal_id']),
    'tasks_scheduled_date_idx': _IndexContract('tasks', ['scheduled_date']),
    'tasks_created_at_idx': _IndexContract('tasks', ['created_at']),
    'task_completion_events_completed_at_idx': _IndexContract(
      'task_completion_events',
      ['completed_at'],
    ),
    'task_completion_events_task_completed_idx': _IndexContract(
      'task_completion_events',
      ['task_id', 'completed_at'],
    ),
    'pomodoro_sessions_goal_id_idx': _IndexContract(
      'pomodoro_sessions',
      ['goal_id'],
    ),
    'pomodoro_sessions_task_id_idx': _IndexContract(
      'pomodoro_sessions',
      ['task_id'],
    ),
    'pomodoro_sessions_started_at_idx': _IndexContract(
      'pomodoro_sessions',
      ['started_at'],
    ),
    'pomodoro_sessions_ended_at_idx': _IndexContract(
      'pomodoro_sessions',
      ['ended_at'],
    ),
    'calendar_events_scheduled_at_idx': _IndexContract(
      'calendar_events',
      ['scheduled_at'],
    ),
    'routines_status_idx': _IndexContract('routines', ['status']),
    'routines_updated_at_idx': _IndexContract('routines', ['updated_at']),
    'routine_days_weekday_routine_idx': _IndexContract(
      'routine_days',
      ['weekday', 'routine_id'],
    ),
    'routine_items_routine_position_uq': _IndexContract(
      'routine_items',
      ['routine_id', 'position'],
      unique: true,
    ),
    'routine_items_routine_time_idx': _IndexContract(
      'routine_items',
      ['routine_id', 'scheduled_minute'],
    ),
    'routine_items_goal_id_idx': _IndexContract(
      'routine_items',
      ['goal_id'],
    ),
    'routine_runs_occurrence_uq': _IndexContract(
      'routine_runs',
      ['source_routine_id', 'local_date'],
      unique: true,
    ),
    'routine_runs_date_status_idx': _IndexContract(
      'routine_runs',
      ['local_date', 'status'],
    ),
    'routine_runs_routine_date_idx': _IndexContract(
      'routine_runs',
      ['routine_id', 'local_date'],
    ),
    'routine_item_runs_materialization_uq': _IndexContract(
      'routine_item_runs',
      ['routine_run_id', 'source_item_id'],
      unique: true,
    ),
    'routine_item_runs_task_id_uq': _IndexContract(
      'routine_item_runs',
      ['task_id'],
      unique: true,
    ),
    'routine_item_runs_routine_item_id_idx': _IndexContract(
      'routine_item_runs',
      ['routine_item_id'],
    ),
    'routine_item_runs_schedule_status_idx': _IndexContract(
      'routine_item_runs',
      ['scheduled_at_snapshot', 'status'],
    ),
    'routine_item_runs_run_position_idx': _IndexContract(
      'routine_item_runs',
      ['routine_run_id', 'position_snapshot'],
    ),
    'sync_outbox_origin_counter_uq': _IndexContract(
      'sync_outbox',
      ['group_id', 'origin_device_id', 'origin_counter'],
      unique: true,
    ),
    'sync_outbox_state_created_idx': _IndexContract(
      'sync_outbox',
      ['publication_state', 'created_at'],
    ),
    'sync_applied_origin_counter_uq': _IndexContract(
      'sync_applied_operations',
      ['group_id', 'origin_device_id', 'origin_counter'],
      unique: true,
    ),
    'sync_conflicts_entity_status_idx': _IndexContract(
      'sync_conflicts',
      ['group_id', 'entity_type', 'entity_id', 'status'],
    ),
  };

  static const _foreignKeyContracts = <String, List<_ForeignKeyContract>>{
    'tasks': [_ForeignKeyContract('goal_id', 'goals', 'id', 'SET NULL')],
    'task_completion_events': [
      _ForeignKeyContract('task_id', 'tasks', 'id', 'SET NULL'),
    ],
    'pomodoro_sessions': [
      _ForeignKeyContract('goal_id', 'goals', 'id', 'SET NULL'),
      _ForeignKeyContract('task_id', 'tasks', 'id', 'SET NULL'),
    ],
    'pomodoro_runtime': [
      _ForeignKeyContract('goal_id', 'goals', 'id', 'SET NULL'),
      _ForeignKeyContract('task_id', 'tasks', 'id', 'RESTRICT'),
    ],
    'routine_days': [
      _ForeignKeyContract('routine_id', 'routines', 'id', 'CASCADE'),
    ],
    'routine_items': [
      _ForeignKeyContract('routine_id', 'routines', 'id', 'CASCADE'),
      _ForeignKeyContract('goal_id', 'goals', 'id', 'SET NULL'),
    ],
    'routine_runs': [
      _ForeignKeyContract('routine_id', 'routines', 'id', 'SET NULL'),
    ],
    'routine_item_runs': [
      _ForeignKeyContract('routine_run_id', 'routine_runs', 'id', 'CASCADE'),
      _ForeignKeyContract(
        'routine_item_id',
        'routine_items',
        'id',
        'SET NULL',
      ),
      _ForeignKeyContract('task_id', 'tasks', 'id', 'SET NULL'),
    ],
  };

  Future<void> validateForImport(File file) async {
    final executor = NativeDatabase(
      file,
      setup: (database) {
        final result = database.select('PRAGMA user_version');
        final versionValue = result.single.values.single;
        if (versionValue is! int) {
          throw const FormatException('Version de esquema invalida.');
        }
        final version = versionValue;
        if (version < 1) {
          throw const FormatException(
            'El archivo no contiene un esquema MichiFocus compatible.',
          );
        }
        if (version > MichiFocusDatabase.currentSchemaVersion) {
          throw const FormatException(
            'Version de esquema futura no compatible.',
          );
        }
      },
    );
    final database = MichiFocusDatabase(executor);
    try {
      await database.customSelect('SELECT 1').getSingle();
      await _validateIntegrity(database);
      await _validateSchemaInventory(database);
      await _validateTableContracts(database);
      await _validateIndexContracts(database);
      await _validateForeignKeyContracts(database);
      await _validateRoutineSchema(database);
      await _validateRoutineValues(database);
      await database.customStatement(
        'UPDATE pomodoro_runtime '
        'SET is_running = 0, last_tick_at = NULL',
      );
    } finally {
      await database.close();
    }
  }

  Future<void> _validateTableContracts(MichiFocusDatabase database) async {
    for (final table in database.allTables) {
      final rows = await database
          .customSelect('PRAGMA table_info(${table.actualTableName})')
          .get();
      final actualColumns = rows.map((row) => row.read<String>('name')).toSet();
      final expectedColumns = table.$columns
          .map((column) => column.$name)
          .toSet();
      if (actualColumns.length != expectedColumns.length ||
          !actualColumns.containsAll(expectedColumns)) {
        throw FormatException(
          'Contrato de columnas invalido: ${table.actualTableName}.',
        );
      }

      final actualPrimaryKey = rows
          .where((row) => row.read<int>('pk') > 0)
          .map((row) => row.read<String>('name'))
          .toSet();
      final expectedPrimaryKey = table.$primaryKey
          .map((column) => column.$name)
          .toSet();
      if (actualPrimaryKey.length != expectedPrimaryKey.length ||
          !actualPrimaryKey.containsAll(expectedPrimaryKey)) {
        throw FormatException(
          'Clave primaria invalida: ${table.actualTableName}.',
        );
      }
    }
  }

  Future<void> _validateIndexContracts(MichiFocusDatabase database) async {
    for (final entry in _indexContracts.entries) {
      final contract = entry.value;
      final indexes = await database
          .customSelect('PRAGMA index_list(${contract.table})')
          .get();
      final index = indexes
          .where(
            (row) => row.read<String>('name') == entry.key,
          )
          .firstOrNull;
      if (index == null ||
          (index.read<int>('unique') == 1) != contract.unique) {
        throw FormatException('Contrato de indice invalido: ${entry.key}.');
      }
      final columns = await database
          .customSelect('PRAGMA index_info(${entry.key})')
          .get();
      final columnNames = columns
          .map((row) => row.read<String>('name'))
          .toList(growable: false);
      if (!_sameValues(columnNames, contract.columns)) {
        throw FormatException('Columnas de indice invalidas: ${entry.key}.');
      }
    }
  }

  Future<void> _validateForeignKeyContracts(
    MichiFocusDatabase database,
  ) async {
    for (final entry in _foreignKeyContracts.entries) {
      final rows = await database
          .customSelect('PRAGMA foreign_key_list(${entry.key})')
          .get();
      if (rows.length != entry.value.length) {
        throw FormatException(
          'Cantidad de claves foraneas invalida: ${entry.key}.',
        );
      }
      for (final contract in entry.value) {
        final matches = rows.any(
          (row) =>
              row.read<String>('from') == contract.from &&
              row.read<String>('table') == contract.parentTable &&
              row.read<String>('to') == contract.parentColumn &&
              row.read<String>('on_delete').toUpperCase() == contract.onDelete,
        );
        if (!matches) {
          throw FormatException(
            'Contrato de clave foranea invalido: ${entry.key}.${contract.from}.',
          );
        }
      }
    }
  }

  Future<void> _validateIntegrity(MichiFocusDatabase database) async {
    final integrityRows = await database
        .customSelect('PRAGMA integrity_check')
        .get();
    if (integrityRows.isEmpty ||
        integrityRows.any((row) => row.data.values.single != 'ok')) {
      throw const FormatException('PRAGMA integrity_check fallo.');
    }

    final foreignKeyIssues = await database
        .customSelect('PRAGMA foreign_key_check')
        .get();
    if (foreignKeyIssues.isNotEmpty) {
      throw const FormatException('Existen claves foraneas invalidas.');
    }
  }

  Future<void> _validateSchemaInventory(MichiFocusDatabase database) async {
    final schemaRows = await database.customSelect(
      '''SELECT type, name, sql FROM sqlite_master WHERE type IN ('table', 'index')''',
    ).get();
    final tableNames = schemaRows
        .where((row) => row.read<String>('type') == 'table')
        .map((row) => row.read<String>('name'))
        .toSet();
    if (!tableNames.containsAll(requiredTables)) {
      throw const FormatException('Faltan tablas requeridas.');
    }

    final indexNames = schemaRows
        .where((row) => row.read<String>('type') == 'index')
        .map((row) => row.read<String>('name'))
        .toSet();
    if (!indexNames.containsAll(requiredIndexes)) {
      throw const FormatException('Faltan indices requeridos.');
    }

    final versionRow = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    if (versionRow.read<int>('user_version') != database.schemaVersion) {
      throw const FormatException('Version de esquema no compatible.');
    }

    for (final table in requiredTables) {
      await database.customSelect('SELECT COUNT(*) FROM $table').getSingle();
    }
  }

  Future<void> _validateRoutineSchema(MichiFocusDatabase database) async {
    final rows = await database
        .customSelect(
          "SELECT name, sql FROM sqlite_master WHERE type = 'table' "
          "AND name IN ('routines', 'routine_days', 'routine_items', "
          "'routine_runs', 'routine_item_runs')",
        )
        .get();
    final sqlByTable = <String, String>{
      for (final row in rows)
        row.read<String>('name'): _normalizeSql(row.read<String>('sql')),
    };
    const requiredFragments = <String, List<String>>{
      'routines': [
        "check (status in ('active', 'paused', 'archived'))",
        'paused_until_local_date',
        'archived_at is not null',
      ],
      'routine_days': ['check (weekday between 1 and 7)'],
      'routine_items': [
        'check (scheduled_minute between 0 and 1439)',
        'check (duration_minutes between 1 and 1440)',
        "check (pomodoro_mode in ('none', 'recommended', 'custom'))",
      ],
      'routine_runs': [
        "check (local_date glob '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')",
        "check (status in ('scheduled', 'inprogress', 'completed', 'skipped', 'missed'))",
        'completed_at is not null',
      ],
      'routine_item_runs': [
        'check (task_id is null or task_id_snapshot is not null)',
        "check (pomodoro_mode_snapshot in ('none', 'recommended', 'custom'))",
        "check (status in ('scheduled', 'inprogress', 'completed', 'skipped', 'missed'))",
      ],
    };

    for (final entry in requiredFragments.entries) {
      final sql = sqlByTable[entry.key];
      if (sql == null ||
          entry.value.any((fragment) => !sql.contains(fragment))) {
        throw FormatException('Contrato de tabla invalido: ${entry.key}.');
      }
    }
  }

  Future<void> _validateRoutineValues(MichiFocusDatabase database) async {
    final invalidEnums = await database.customSelect(
      '''SELECT 1 FROM routines WHERE status NOT IN ('active', 'paused', 'archived') UNION ALL SELECT 1 FROM routine_items WHERE pomodoro_mode NOT IN ('none', 'recommended', 'custom') UNION ALL SELECT 1 FROM routine_runs WHERE status NOT IN ('scheduled', 'inProgress', 'completed', 'skipped', 'missed') UNION ALL SELECT 1 FROM routine_item_runs WHERE status NOT IN ('scheduled', 'inProgress', 'completed', 'skipped', 'missed') LIMIT 1''',
    ).get();
    if (invalidEnums.isNotEmpty) {
      throw const FormatException('Existen estados de rutina invalidos.');
    }

    final dateRows = await database
        .customSelect(
          'SELECT paused_until_local_date AS local_date FROM routines '
          'WHERE paused_until_local_date IS NOT NULL UNION ALL '
          'SELECT local_date FROM routine_runs',
        )
        .get();
    for (final row in dateRows) {
      if (!_isCanonicalLocalDate(row.read<String>('local_date'))) {
        throw const FormatException('Existen fechas locales invalidas.');
      }
    }
  }

  String _normalizeSql(String sql) =>
      sql.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  bool _isCanonicalLocalDate(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
    if (match == null) {
      return false;
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    if (month < 1 || month > 12 || day < 1 || day > 31) {
      return false;
    }
    final parsed = DateTime.utc(year, month, day);
    return parsed.year == year && parsed.month == month && parsed.day == day;
  }

  bool _sameValues(List<String> actual, List<String> expected) {
    if (actual.length != expected.length) {
      return false;
    }
    for (var index = 0; index < actual.length; index += 1) {
      if (actual[index] != expected[index]) {
        return false;
      }
    }
    return true;
  }
}

class _IndexContract {
  const _IndexContract(this.table, this.columns, {this.unique = false});

  final String table;
  final List<String> columns;
  final bool unique;
}

class _ForeignKeyContract {
  const _ForeignKeyContract(
    this.from,
    this.parentTable,
    this.parentColumn,
    this.onDelete,
  );

  final String from;
  final String parentTable;
  final String parentColumn;
  final String onDelete;
}
