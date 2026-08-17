import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_device_name_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/device-identity');
  final provider = AndroidDeviceNameProvider(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('reads and normalizes the Android model suggestion', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'getSuggestedName');
          return '  Samsung   S23  ';
        });

    expect(await provider.suggestedName(), 'Samsung S23');
  });

  test('returns no suggestion when the native bridge is unavailable', () async {
    expect(await provider.suggestedName(), isNull);
  });

  test('returns no suggestion when Android rejects the request', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(code: 'device_name_failed');
        });

    expect(await provider.suggestedName(), isNull);
  });
}
