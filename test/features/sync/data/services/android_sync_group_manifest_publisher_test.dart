import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_group_manifest_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_publisher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/group-manifest-publisher');
  const publisher = AndroidSyncGroupManifestPublisher(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('publishes only the canonical encrypted manifest', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'publishSyncGroupManifest');
          final arguments = call.arguments! as Map<Object?, Object?>;
          expect(arguments['folderUri'], 'content://tree/michifocus');
          expect(arguments['groupId'], _groupId);
          final decoded =
              jsonDecode(
                    utf8.decode((arguments['bytes']! as Uint8List).toList()),
                  )
                  as Map<String, dynamic>;
          expect(decoded['groupId'], _groupId);
          expect(decoded['cryptoSuite'], 'argon2id-aes256gcm-v1');
          expect(decoded.toString(), isNot(contains('deviceBoundDek')));
          return <String, dynamic>{
            'relativePath': 'michifocus-$_groupId.v1.json',
            'atomicFinalization': true,
          };
        });

    final result = await publisher.publish(
      folderUri: ' content://tree/michifocus ',
      manifest: _manifest(),
    );

    expect(result.relativePath, 'michifocus-$_groupId.v1.json');
    expect(result.atomicFinalization, isTrue);
  });

  test('reports a different existing group manifest as a conflict', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(code: 'group_manifest_conflict');
        });

    await expectLater(
      publisher.publish(
        folderUri: 'content://tree/michifocus',
        manifest: _manifest(),
      ),
      throwsA(isA<SyncGroupManifestConflictException>()),
    );
  });

  test(
    'fails closed for unavailable folder or malformed native result',
    () async {
      await expectLater(
        publisher.publish(folderUri: '', manifest: _manifest()),
        throwsA(isA<SyncGroupManifestFolderUnavailableException>()),
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (call) async => <String, dynamic>{},
          );
      await expectLater(
        publisher.publish(
          folderUri: 'content://tree/michifocus',
          manifest: _manifest(),
        ),
        throwsA(isA<SyncGroupManifestFolderUnavailableException>()),
      );
    },
  );

  test('fails closed when the Android bridge is missing', () async {
    await expectLater(
      publisher.publish(
        folderUri: 'content://tree/michifocus',
        manifest: _manifest(),
      ),
      throwsA(isA<SyncGroupManifestFolderUnavailableException>()),
    );
  });
}

const _groupId = 'group_0123456789abcdef0123456789abcdef';

SyncGroupKeyManifest _manifest() {
  return SyncGroupKeyManifest(
    groupId: _groupId,
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
  );
}
