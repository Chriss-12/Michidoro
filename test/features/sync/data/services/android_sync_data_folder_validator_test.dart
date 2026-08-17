import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_data_folder_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/sync-folder-validator');
  final validator = AndroidSyncDataFolderValidator(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('returns the native write-read-delete result', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'validateSyncFolder');
          expect(call.arguments, {'folderUri': 'content://shared'});
          return true;
        });

    expect(await validator.validate(' content://shared '), isTrue);
  });

  test('rejects an empty folder reference without invoking Android', () async {
    expect(await validator.validate('  '), isFalse);
  });

  test(
    'fails safely when permission or the native bridge is unavailable',
    () async {
      expect(await validator.validate('content://revoked'), isFalse);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(code: 'permission_denied');
          });
      expect(await validator.validate('content://revoked'), isFalse);
    },
  );
}
