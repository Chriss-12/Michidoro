import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/task_temporal_filter_repository.dart';

typedef TaskFilterDirectoryProvider = Future<Directory> Function();

class FileTaskTemporalFilterRepository implements TaskTemporalFilterRepository {
  FileTaskTemporalFilterRepository({
    TaskFilterDirectoryProvider? directory,
    DateTime Function()? now,
  }) : _directory = directory ?? getApplicationDocumentsDirectory,
       _now = now ?? DateTime.now;

  static const _fileName = 'michifocus-task-filter.json';

  final TaskFilterDirectoryProvider _directory;
  final DateTime Function() _now;

  @override
  Future<TaskTemporalFilter> load() async {
    try {
      final file = await _file();
      if (!file.existsSync()) return TaskTemporalFilter.day(_now());
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return TaskTemporalFilter.day(_now());
      }
      return _decode(decoded) ?? TaskTemporalFilter.day(_now());
    } on FormatException {
      return TaskTemporalFilter.day(_now());
    } on FileSystemException {
      return TaskTemporalFilter.day(_now());
    }
  }

  @override
  Future<void> save(TaskTemporalFilter filter) async {
    final file = await _file();
    await file.writeAsString(
      jsonEncode({
        'kind': filter.kind.name,
        if (filter.start != null) 'start': _dateKey(filter.start!),
        if (filter.end != null) 'end': _dateKey(filter.end!),
      }),
      flush: true,
    );
  }

  TaskTemporalFilter? _decode(Map<String, dynamic> source) {
    final kindName = source['kind'];
    if (kindName is! String) return null;
    TaskTemporalFilterKind? kind;
    for (final candidate in TaskTemporalFilterKind.values) {
      if (candidate.name == kindName) {
        kind = candidate;
        break;
      }
    }
    final start = source['start'] is String
        ? DateTime.tryParse(source['start'] as String)
        : null;
    final end = source['end'] is String
        ? DateTime.tryParse(source['end'] as String)
        : null;
    return switch (kind) {
      TaskTemporalFilterKind.allTime => const TaskTemporalFilter.allTime(),
      TaskTemporalFilterKind.day when start != null => TaskTemporalFilter.day(
        start,
      ),
      TaskTemporalFilterKind.month when start != null =>
        TaskTemporalFilter.month(start),
      TaskTemporalFilterKind.year when start != null => TaskTemporalFilter.year(
        start.year,
      ),
      TaskTemporalFilterKind.range when start != null && end != null =>
        TaskTemporalFilter.range(start, end),
      _ => null,
    };
  }

  Future<File> _file() async {
    final directory = await _directory();
    return File('${directory.path}/$_fileName');
  }
}

String _dateKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
