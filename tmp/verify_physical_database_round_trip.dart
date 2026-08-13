import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sqlite3/sqlite3.dart';

const expectedTables = <String>{
  'calendar_events',
  'goals',
  'pomodoro_runtime',
  'pomodoro_sessions',
  'reporting_metadata',
  'routine_days',
  'routine_item_runs',
  'routine_items',
  'routine_runs',
  'routines',
  'task_completion_events',
  'tasks',
};

void main(List<String> arguments) {
  if (arguments.length != 2) {
    stderr.writeln('Expected the exported and re-exported database paths.');
    exitCode = 64;
    return;
  }

  final first = _inspect(arguments[0]);
  final second = _inspect(arguments[1]);
  final contentMatches =
      jsonEncode(first['tables']) == jsonEncode(second['tables']);

  final result = <String, Object?>{
    'first': first,
    'second': second,
    'logicalContentMatches': contentMatches,
  };
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(result));

  final valid =
      first['schemaVersion'] == 5 &&
      second['schemaVersion'] == 5 &&
      first['integrity'] == 'ok' &&
      second['integrity'] == 'ok' &&
      first['foreignKeyViolations'] == 0 &&
      second['foreignKeyViolations'] == 0 &&
      contentMatches;
  if (!valid) {
    exitCode = 1;
  }
}

Map<String, Object?> _inspect(String path) {
  final database = sqlite3.open(path, mode: OpenMode.readOnly);
  try {
    final tableNames = database
        .select(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name NOT LIKE 'sqlite_%' ORDER BY name",
        )
        .map((row) => row['name']! as String)
        .toList(growable: false);
    if (tableNames.toSet().difference(expectedTables).isNotEmpty ||
        expectedTables.difference(tableNames.toSet()).isNotEmpty) {
      throw StateError('Unexpected table inventory: $tableNames');
    }

    final tables = <String, Object?>{};
    for (final table in tableNames) {
      final columns = database
          .select('PRAGMA table_info(${_quote(table)})')
          .toList(growable: false);
      final primaryKeys =
          columns
              .where((column) => (column['pk']! as int) > 0)
              .toList(growable: false)
            ..sort(
              (left, right) =>
                  (left['pk']! as int).compareTo(right['pk']! as int),
            );
      final orderColumns = primaryKeys.isNotEmpty ? primaryKeys : columns;
      final orderBy = orderColumns
          .map((column) => _quote(column['name']! as String))
          .join(', ');
      final resultSet = database.select(
        'SELECT * FROM ${_quote(table)} ORDER BY $orderBy',
      );
      final rows = resultSet
          .map(
            (row) => <String, Object?>{
              for (final column in resultSet.columnNames)
                column: _normalize(row[column]),
            },
          )
          .toList(growable: false);
      tables[table] = <String, Object?>{
        'count': rows.length,
        'rows': rows,
      };
    }

    return <String, Object?>{
      'path': path,
      'bytes': File(path).lengthSync(),
      'schemaVersion': database.userVersion,
      'integrity': database.select('PRAGMA integrity_check').first.values.first,
      'foreignKeyViolations': database
          .select('PRAGMA foreign_key_check')
          .length,
      'tableCount': tableNames.length,
      'tables': tables,
    };
  } finally {
    database.dispose();
  }
}

Object? _normalize(Object? value) {
  if (value is Uint8List) {
    return base64Encode(value);
  }
  return value;
}

String _quote(String identifier) => '"${identifier.replaceAll('"', '""')}"';
