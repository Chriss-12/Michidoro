import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/file_task_temporal_filter_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';

void main() {
  late Directory directory;
  late FileTaskTemporalFilterRepository repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'michifocus-task-filter-',
    );
    repository = FileTaskTemporalFilterRepository(
      directory: () async => directory,
      now: () => DateTime(2026, 8, 24, 17, 30),
    );
  });

  tearDown(() async {
    if (directory.existsSync()) await directory.delete(recursive: true);
  });

  test('defaults to the current local day when no preference exists', () async {
    final filter = await repository.load();

    expect(filter.kind, TaskTemporalFilterKind.day);
    expect(filter.start, DateTime(2026, 8, 24));
    expect(filter.end, DateTime(2026, 8, 24));
  });

  test('round trips every explicit temporal selection', () async {
    final filters = <TaskTemporalFilter>[
      const TaskTemporalFilter.allTime(),
      TaskTemporalFilter.day(DateTime(2026, 2, 3)),
      TaskTemporalFilter.month(DateTime(2026, 4)),
      TaskTemporalFilter.year(2027),
      TaskTemporalFilter.range(DateTime(2026, 5, 2), DateTime(2026, 5, 9)),
    ];

    for (final expected in filters) {
      await repository.save(expected);
      final loaded = await repository.load();
      expect(loaded.kind, expected.kind);
      expect(loaded.start, expected.start);
      expect(loaded.end, expected.end);
    }
  });

  test('malformed or unknown preferences fall back safely to today', () async {
    final file = File('${directory.path}/michifocus-task-filter.json');
    await file.writeAsString('{broken');
    expect((await repository.load()).start, DateTime(2026, 8, 24));

    await file.writeAsString('{"kind":"future-filter"}');
    final unknown = await repository.load();
    expect(unknown.kind, TaskTemporalFilterKind.day);
    expect(unknown.start, DateTime(2026, 8, 24));
  });
}
