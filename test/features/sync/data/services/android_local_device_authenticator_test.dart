import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_local_device_authenticator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/local-auth');
  const authenticator = AndroidLocalDeviceAuthenticator(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('reports the native system-authentication capability', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'isAvailable');
          return true;
        });

    expect(await authenticator.isAvailable(), isTrue);
  });

  test('returns only the native authentication result', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'authenticate');
          expect(call.arguments, isNull);
          return true;
        });

    expect(await authenticator.authenticate(), isTrue);
  });

  test('fails closed when the native bridge is unavailable', () async {
    expect(await authenticator.isAvailable(), isFalse);
    expect(await authenticator.authenticate(), isFalse);
  });

  test('fails closed when Android rejects the request', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(code: 'authentication_failed');
        });

    expect(await authenticator.authenticate(), isFalse);
  });
}
