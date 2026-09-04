import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';

void main() {
  late Directory directory;
  late FileSyncGroupEnrollmentRepository repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('michi-group-test-');
    repository = FileSyncGroupEnrollmentRepository(
      directory: () async => directory,
    );
  });

  tearDown(() async {
    if (directory.existsSync()) await directory.delete(recursive: true);
  });

  test('starts without a group and round trips encrypted enrollment', () async {
    expect(await repository.load(), isNull);

    await repository.create(_enrollment());
    final loaded = await repository.load();

    expect(loaded?.groupId, _groupId);
    expect(loaded?.deviceBoundDek.nonce, List<int>.filled(12, 7));
    expect(loaded?.manifest.passwordKdf.memoryKiB, 64 * 1024);
  });

  test('reuses an absent group result without reopening its file', () async {
    var directoryReads = 0;
    final cachedRepository = FileSyncGroupEnrollmentRepository(
      directory: () async {
        directoryReads++;
        return directory;
      },
    );

    await cachedRepository.load();
    await cachedRepository.load();

    expect(directoryReads, 1);
  });

  test('refuses to overwrite an existing group', () async {
    await repository.create(_enrollment());

    await expectLater(
      repository.create(_enrollment()),
      throwsA(isA<SyncGroupAlreadyExistsException>()),
    );
  });

  test('round trips a joining phone bootstrap decision', () async {
    final joined = SyncGroupEnrollment(
      manifest: _enrollment().manifest,
      deviceBoundDek: _enrollment().deviceBoundDek,
      source: SyncGroupEnrollmentSource.joinedExisting,
      bootstrapPreference: SyncGroupBootstrapPreference.mergeLocal,
    );

    await repository.create(joined);
    final loaded = await repository.load();

    expect(loaded?.source, SyncGroupEnrollmentSource.joinedExisting);
    expect(
      loaded?.bootstrapPreference,
      SyncGroupBootstrapPreference.mergeLocal,
    );
  });

  test(
    'atomically records a verified recovery snapshot for the same group',
    () async {
      await repository.create(_enrollment());
      final current = (await repository.load())!;

      await repository.update(
        SyncGroupEnrollment(
          manifest: current.manifest,
          deviceBoundDek: current.deviceBoundDek,
          source: current.source,
          bootstrapPreference: current.bootstrapPreference,
          recoverySnapshotPath:
              'michifocus-$_groupId-recovery-snapshot_0123456789abcdef0123456789abcdef.v1.json',
        ),
      );

      expect(
        (await repository.load())?.recoverySnapshotPath,
        contains('recovery-snapshot_'),
      );
      expect(
        File(
          '${directory.path}/michifocus-sync-group.json.previous',
        ).existsSync(),
        isFalse,
      );
    },
  );

  test('refuses to update a different group identity', () async {
    await repository.create(_enrollment());
    final other = _enrollment(
      groupId: 'group_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    );

    await expectLater(repository.update(other), throwsStateError);
    expect((await repository.load())?.groupId, _groupId);
  });

  test('malformed enrollment fails closed as absent', () async {
    await File(
      '${directory.path}/michifocus-sync-group.json',
    ).writeAsString('{"version":1,"manifest":"plaintext"}');

    expect(await repository.load(), isNull);
  });
}

const _groupId = 'group_0123456789abcdef0123456789abcdef';

SyncGroupEnrollment _enrollment({String groupId = _groupId}) {
  return SyncGroupEnrollment(
    manifest: SyncGroupKeyManifest(
      groupId: groupId,
      passwordKdf: PasswordKdfParameters(
        salt: List<int>.filled(16, 1),
        memoryKiB: 64 * 1024,
        iterations: 3,
        parallelism: 1,
        hashLength: 32,
      ),
      passwordWrappedDek: EncryptedKeyEnvelope(
        nonce: List<int>.filled(12, 2),
        cipherText: List<int>.filled(32, 3),
        mac: List<int>.filled(16, 4),
      ),
      recoveryWrappedDek: EncryptedKeyEnvelope(
        nonce: List<int>.filled(12, 5),
        cipherText: List<int>.filled(32, 6),
        mac: List<int>.filled(16, 7),
      ),
    ),
    deviceBoundDek: DeviceBoundKeyEnvelope(
      nonce: List<int>.filled(12, 7),
      cipherText: List<int>.filled(48, 8),
    ),
  );
}
