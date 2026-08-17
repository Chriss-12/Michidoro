import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_sync_storage_config_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';

void main() {
  late Directory directory;
  late FileSyncStorageConfigRepository repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'michifocus-sync-config-',
    );
    repository = FileSyncStorageConfigRepository(
      directory: () async => directory,
    );
  });

  tearDown(() async {
    if (directory.existsSync()) await directory.delete(recursive: true);
  });

  test('defaults to single-device mode without a folder', () async {
    final config = await repository.load();

    expect(config.mode, SyncStorageMode.singleDevice);
    expect(config.hasSelectedFolder, isFalse);
  });

  test('round trips multiple-device mode and folder access', () async {
    await repository.save(
      const SyncStorageConfig(
        mode: SyncStorageMode.multipleDevices,
        folderUri: 'content://tree/michifocus',
        folderLabel: 'MichiFocus compartido',
      ),
    );

    final config = await repository.load();
    expect(config.mode, SyncStorageMode.multipleDevices);
    expect(config.folderUri, 'content://tree/michifocus');
    expect(config.folderLabel, 'MichiFocus compartido');
  });

  test('fails safely for malformed data', () async {
    await File(
      '${directory.path}/michifocus-sync-settings.json',
    ).writeAsString('{broken');

    final config = await repository.load();
    expect(config.mode, SyncStorageMode.singleDevice);
    expect(config.hasSelectedFolder, isFalse);
  });

  test('unknown future mode falls back to single device', () async {
    await File(
      '${directory.path}/michifocus-sync-settings.json',
    ).writeAsString('{"mode":"futureMode"}');

    expect((await repository.load()).mode, SyncStorageMode.singleDevice);
  });
}
