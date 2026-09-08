import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_app_content_protection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/content-protection');
  const protection = AndroidAppContentProtection(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('sends the selected protection state to Android', () async {
    final receivedStates = <bool>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'setEnabled');
          receivedStates.add(
            (call.arguments as Map<Object?, Object?>)['enabled']! as bool,
          );
          return null;
        });

    await protection.setEnabled(enabled: true);
    await protection.setEnabled(enabled: false);

    expect(receivedStates, [true, false]);
  });

  test(
    'keeps the Flutter privacy fallback when the bridge is absent',
    () async {
      await expectLater(protection.setEnabled(enabled: true), completes);
    },
  );

  test(
    'keeps the Flutter privacy fallback when Android rejects the call',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(code: 'content_protection_failed');
          });

      await expectLater(protection.setEnabled(enabled: true), completes);
    },
  );
}
