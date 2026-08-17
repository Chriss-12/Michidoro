import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_group_manifest_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_discovery.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('test/group_manifest_discovery');
  const discovery = AndroidSyncGroupManifestDiscovery(channel: channel);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('returns only structurally valid final group manifests', () async {
    final validManifest = _manifest();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'discoverSyncGroupManifests');
          return <Map<String, Object>>[
            {
              'relativePath': 'michifocus-$_groupId.v1.json',
              'bytes': Uint8List.fromList(
                utf8.encode(jsonEncode(validManifest.toJson())),
              ),
            },
            {
              'relativePath': '.michifocus-$_groupId.tmp',
              'bytes': Uint8List.fromList([1, 2, 3]),
            },
          ];
        });

    final result = await discovery(
      folderUri: ' content://tree/michifocus ',
    );

    expect(result.groups, hasLength(1));
    expect(result.groups.single.manifest.groupId, _groupId);
    expect(result.rejectedFiles, 1);
  });

  test('rejects filename and manifest group mismatch', () async {
    final manifest = _manifest(
      groupId: 'group_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (call) async => <Map<String, Object>>[
            {
              'relativePath': 'michifocus-$_groupId.v1.json',
              'bytes': Uint8List.fromList(
                utf8.encode(jsonEncode(manifest.toJson())),
              ),
            },
          ],
        );

    final result = await discovery(folderUri: 'content://tree/group');

    expect(result.groups, isEmpty);
    expect(result.rejectedFiles, 1);
  });

  test(
    'rejects unsupported KDF parameters before password processing',
    () async {
      final json = _manifest().toJson();
      (json['passwordKdf']! as Map<String, Object>)['memoryKiB'] = 1024 * 1024;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (call) async => <Map<String, Object>>[
              {
                'relativePath': 'michifocus-$_groupId.v1.json',
                'bytes': Uint8List.fromList(utf8.encode(jsonEncode(json))),
              },
            ],
          );

      final result = await discovery(
        folderUri: 'content://tree/group',
      );

      expect(result.groups, isEmpty);
      expect(result.rejectedFiles, 1);
    },
  );

  test(
    'removes a group when duplicate final entries disagree',
    () async {
      final first = _manifest();
      final second = _manifest().toJson();
      (second['passwordWrappedDek']! as Map<String, Object>)['cipherText'] =
          base64UrlEncode(List<int>.filled(32, 9));
      final firstBytes = Uint8List.fromList(
        utf8.encode(jsonEncode(first.toJson())),
      );
      final secondBytes = Uint8List.fromList(utf8.encode(jsonEncode(second)));
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (call) async => <Map<String, Object>>[
              {
                'relativePath': 'michifocus-$_groupId.v1.json',
                'bytes': firstBytes,
              },
              {
                'relativePath': 'michifocus-$_groupId.v1.json',
                'bytes': secondBytes,
              },
              {
                'relativePath': 'michifocus-$_groupId.v1.json',
                'bytes': firstBytes,
              },
            ],
          );

      final result = await discovery(folderUri: 'content://tree/group');

      expect(result.groups, isEmpty);
      expect(result.rejectedFiles, 2);
    },
  );

  test(
    'fails closed when folder access or native bridge is unavailable',
    () async {
      await expectLater(
        discovery(folderUri: ''),
        throwsA(isA<SyncGroupManifestDiscoveryException>()),
      );
      await expectLater(
        discovery(folderUri: 'content://tree/group'),
        throwsA(isA<SyncGroupManifestDiscoveryException>()),
      );
    },
  );
}

const _groupId = 'group_0123456789abcdef0123456789abcdef';

SyncGroupKeyManifest _manifest({String groupId = _groupId}) {
  return SyncGroupKeyManifest(
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
  );
}
