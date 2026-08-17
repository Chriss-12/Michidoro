import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_device_bound_key_protector.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_bound_key_protector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const groupId = 'group_0123456789abcdef0123456789abcdef';
  const channel = MethodChannel('test/group-keystore');
  const protector = AndroidDeviceBoundKeyProtector(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('reports native availability and key presence', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'isAvailable') return true;
          expect(call.method, 'hasKey');
          expect(call.arguments, {'groupId': groupId});
          return true;
        });

    expect(await protector.isAvailable(), isTrue);
    expect(await protector.hasKey(groupId), isTrue);
  });

  test('wraps a copied DEK without changing the caller buffer', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'wrap');
          final arguments = call.arguments! as Map<Object?, Object?>;
          expect(arguments['clearKey'], List<int>.filled(32, 7));
          return <String, dynamic>{
            'nonce': Uint8List.fromList(
              List<int>.generate(12, (index) => index),
            ),
            'cipherText': Uint8List.fromList(List<int>.filled(48, 9)),
          };
        });

    final original = List<int>.filled(32, 7);
    final envelope = await protector.wrap(
      groupId: groupId,
      clearKey: original,
    );

    expect(envelope.nonce, hasLength(12));
    expect(envelope.cipherText, hasLength(48));
    expect(original, everyElement(7));
  });

  test('unwraps only a 256-bit group key', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'unwrap');
          return Uint8List.fromList(List<int>.filled(32, 5));
        });

    final clearKey = await protector.unwrap(
      groupId: groupId,
      envelope: DeviceBoundKeyEnvelope(
        nonce: List<int>.filled(12, 1),
        cipherText: List<int>.filled(48, 2),
      ),
    );

    expect(clearKey, everyElement(5));
  });

  test('maps native failures without exposing platform details', () async {
    Future<void> expectCode(
      String code,
      Matcher matcher,
      Future<Object?> Function() action,
    ) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(
              code: code,
              message: 'sensitive native text',
            );
          });
      await expectLater(action(), throwsA(matcher));
    }

    await expectCode(
      'authentication_required',
      isA<DeviceAuthenticationRequiredException>(),
      () => protector.hasKey(groupId),
    );
    await expectCode(
      'key_invalidated',
      isA<DeviceKeyInvalidatedException>(),
      () => protector.hasKey(groupId),
    );
    await expectCode(
      'integrity_failed',
      isA<DeviceKeyIntegrityException>(),
      () => protector.hasKey(groupId),
    );
    await expectCode(
      'unexpected',
      isA<DeviceKeyUnavailableException>(),
      () => protector.hasKey(groupId),
    );
  });

  test('deletes only the requested group key alias', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'delete');
          expect(call.arguments, {'groupId': groupId});
          return null;
        });

    await protector.delete(groupId);
  });

  test('fails closed when the native bridge is unavailable', () async {
    expect(await protector.isAvailable(), isFalse);
    await expectLater(
      protector.hasKey(groupId),
      throwsA(isA<DeviceKeyUnavailableException>()),
    );
  });
}
