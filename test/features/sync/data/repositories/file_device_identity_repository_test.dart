import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';

void main() {
  late Directory directory;
  late FileDeviceIdentityRepository repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('device-identity-test-');
    repository = FileDeviceIdentityRepository(directory: () async => directory);
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('starts without an identity when no file exists', () async {
    expect((await repository.load()).isInitialized, isFalse);
  });

  test('persists and reloads the stable identity', () async {
    const identity = DeviceIdentity(
      installationId: 'installation_1234',
      friendlyName: 'Pixel personal',
    );

    await repository.save(identity);
    final loaded = await repository.load();

    expect(loaded.installationId, identity.installationId);
    expect(loaded.friendlyName, identity.friendlyName);
  });

  test('treats malformed content as missing identity', () async {
    await File(
      '${directory.path}/michifocus-device-identity.json',
    ).writeAsString('{broken');

    expect((await repository.load()).isInitialized, isFalse);
  });
}
