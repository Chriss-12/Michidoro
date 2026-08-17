import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_recovery_snapshot_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_recovery_snapshot.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_recovery_snapshot_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('michifocus/native_files');
  const groupId = 'group_0123456789abcdef0123456789abcdef';
  final clearKey = List<int>.generate(32, (index) => index);
  late Directory directory;
  late MichiFocusDatabase database;
  late SyncGroupCrypto crypto;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('michi-recovery-test-');
    database = MichiFocusDatabase(NativeDatabase.memory());
    crypto = SyncGroupCrypto(
      parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
      random: Random(31),
    );
    await database.customSelect('SELECT 1').getSingle();
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await database.close();
    if (directory.existsSync()) await directory.delete(recursive: true);
  });

  test(
    'validates, encrypts, publishes, and removes plaintext temporaries',
    () async {
      await database.customStatement(
        '''
         INSERT INTO goals (id, title, target_sessions, completed_sessions, created_at, updated_at)
         VALUES ('goal-private', 'Private objective', 4, 1, 1, 1)''',
      );
      SyncEncryptedRecoverySnapshot? observedEnvelope;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'publishSyncRecoverySnapshot');
            final arguments = call.arguments! as Map<Object?, Object?>;
            final source = File(arguments['sourcePath']! as String);
            expect(source.existsSync(), isTrue);
            final encoded = await source.readAsString();
            expect(encoded, isNot(contains('Private objective')));
            observedEnvelope = SyncEncryptedRecoverySnapshot.fromJson(
              jsonDecode(encoded) as Map<String, dynamic>,
            );
            final snapshotId = arguments['snapshotId']! as String;
            return {
              'relativePath':
                  'michifocus-$groupId-recovery-$snapshotId.v1.json',
              'atomicFinalization': true,
            };
          });

      final publication =
          await DriftSyncRecoverySnapshotService(
            database: database,
            crypto: crypto,
            idGenerator: SecureSyncIdGenerator(random: Random(41)),
            temporaryDirectory: () async => directory,
            channel: channel,
            clock: () => DateTime.utc(2026, 8, 14, 12),
          ).call(
            folderUri: 'content://tree/michifocus',
            groupId: groupId,
            clearKey: clearKey,
          );

      expect(publication.relativePath, contains('-recovery-snapshot_'));
      expect(observedEnvelope, isNotNull);
      final decrypted = await crypto.decryptRecoverySnapshot(
        snapshot: observedEnvelope!,
        clearKey: clearKey,
      );
      expect(utf8.decode(decrypted, allowMalformed: true), contains('SQLite'));
      expect(
        directory.listSync().whereType<File>().where(
          (file) => file.path.contains('.michifocus-snapshot_'),
        ),
        isEmpty,
      );
    },
  );

  test(
    'fails closed and removes temporaries after an invalid native result',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (_) async => {'relativePath': 'wrong'},
          );
      final service = DriftSyncRecoverySnapshotService(
        database: database,
        crypto: crypto,
        idGenerator: SecureSyncIdGenerator(random: Random(51)),
        temporaryDirectory: () async => directory,
        channel: channel,
      );

      await expectLater(
        service.call(
          folderUri: 'content://tree/michifocus',
          groupId: groupId,
          clearKey: clearKey,
        ),
        throwsA(isA<SyncRecoverySnapshotException>()),
      );
      expect(
        directory.listSync().whereType<File>().where(
          (file) => file.path.contains('.michifocus-snapshot_'),
        ),
        isEmpty,
      );
    },
  );
}
