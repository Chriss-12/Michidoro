import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_operation_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/sync-operation-discovery');
  const discovery = AndroidSyncOperationDiscovery(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('accepts only canonical final operation paths', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'discoverSyncOperations');
          return [
            {
              'relativePath': _relativePath,
              'bytes': Uint8List.fromList(
                utf8.encode(jsonEncode(_operation.toJson())),
              ),
            },
            {
              'relativePath': 'michifocus-operation-changed-wrong.json',
              'bytes': Uint8List.fromList(
                utf8.encode(jsonEncode(_operation.toJson())),
              ),
            },
          ];
        });

    final report = await discovery.call(
      folderUri: 'content://tree/michifocus',
      localInstallationId: _localInstallationId,
    );

    expect(report.operations, hasLength(1));
    expect(report.operations.single.relativePath, _relativePath);
    expect(report.rejectedFiles, 1);
  });
}

const _localInstallationId = 'installation_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const _remoteInstallationId = 'installation_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
const _operationId = 'operation_0123456789abcdef0123456789abcdef';
const _relativePath =
    'michifocus-op-bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb-'
    '00000000000000000007-0123456789abcdef0123456789abcdef.v1.json';
const _operation = SyncEncryptedOperation(
  groupId: 'group_0123456789abcdef0123456789abcdef',
  operationId: _operationId,
  originDeviceId: _remoteInstallationId,
  originCounter: 7,
  payloadSha256:
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  nonce: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  cipherText: [13, 14, 15],
  mac: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
);
