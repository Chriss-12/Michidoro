import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_operation_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_publisher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/sync-operation-publisher');
  const publisher = AndroidSyncOperationPublisher(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('publishes encrypted bytes only in the owner device path', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'publishSyncOperation');
          final arguments = call.arguments! as Map<Object?, Object?>;
          expect(arguments['installationId'], _installationId);
          expect(arguments['originCounter'], 7);
          final decoded =
              jsonDecode(
                    utf8.decode((arguments['bytes']! as Uint8List).toList()),
                  )
                  as Map<String, dynamic>;
          expect(decoded['cipherText'], isNotEmpty);
          expect(decoded.toString(), isNot(contains('Private objective')));
          return <String, dynamic>{
            'relativePath': _relativePath,
            'atomicFinalization': true,
          };
        });

    final result = await publisher.publish(
      folderUri: ' content://tree/michifocus ',
      operation: _operation,
    );

    expect(result.relativePath, _relativePath);
    expect(result.atomicFinalization, isTrue);
  });

  test('maps native conflicts and missing bridges safely', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(code: 'sync_operation_conflict');
        });
    await expectLater(
      publisher.publish(
        folderUri: 'content://tree/michifocus',
        operation: _operation,
      ),
      throwsA(isA<SyncOperationConflictException>()),
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await expectLater(
      publisher.publish(
        folderUri: 'content://tree/michifocus',
        operation: _operation,
      ),
      throwsA(isA<SyncOperationFolderUnavailableException>()),
    );
  });
}

const _installationId = 'installation_0123456789abcdef0123456789abcdef';
const _operationId = 'operation_0123456789abcdef0123456789abcdef';
const _relativePath =
    'michifocus-op-0123456789abcdef0123456789abcdef-'
    '00000000000000000007-0123456789abcdef0123456789abcdef.v1.json';

const _operation = SyncEncryptedOperation(
  groupId: 'group_0123456789abcdef0123456789abcdef',
  operationId: _operationId,
  originDeviceId: _installationId,
  originCounter: 7,
  payloadSha256:
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  nonce: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  cipherText: [13, 14, 15],
  mac: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
);
