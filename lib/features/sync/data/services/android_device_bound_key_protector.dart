import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_bound_key_protector.dart';

class AndroidDeviceBoundKeyProtector implements DeviceBoundKeyProtector {
  const AndroidDeviceBoundKeyProtector({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'michifocus/group_keystore';

  final MethodChannel _channel;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> hasKey(String groupId) async {
    try {
      return await _channel.invokeMethod<bool>(
            'hasKey',
            {'groupId': groupId},
          ) ??
          false;
    } on PlatformException catch (error) {
      throw _mapError(error);
    } on MissingPluginException {
      throw const DeviceKeyUnavailableException();
    }
  }

  @override
  Future<DeviceBoundKeyEnvelope> wrap({
    required String groupId,
    required List<int> clearKey,
  }) async {
    final transientKey = Uint8List.fromList(clearKey);
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'wrap',
        {'groupId': groupId, 'clearKey': transientKey},
      );
      if (result == null) throw const DeviceKeyUnavailableException();
      return DeviceBoundKeyEnvelope(
        nonce: _requiredBytes(result, 'nonce'),
        cipherText: _requiredBytes(result, 'cipherText'),
      );
    } on PlatformException catch (error) {
      throw _mapError(error);
    } on MissingPluginException {
      throw const DeviceKeyUnavailableException();
    } finally {
      transientKey.fillRange(0, transientKey.length, 0);
    }
  }

  @override
  Future<List<int>> unwrap({
    required String groupId,
    required DeviceBoundKeyEnvelope envelope,
  }) async {
    try {
      final result = await _channel.invokeMethod<Uint8List>(
        'unwrap',
        {
          'groupId': groupId,
          'nonce': Uint8List.fromList(envelope.nonce),
          'cipherText': Uint8List.fromList(envelope.cipherText),
        },
      );
      if (result == null || result.length != 32) {
        throw const DeviceKeyIntegrityException();
      }
      return result;
    } on PlatformException catch (error) {
      throw _mapError(error);
    } on MissingPluginException {
      throw const DeviceKeyUnavailableException();
    }
  }

  @override
  Future<void> delete(String groupId) async {
    try {
      await _channel.invokeMethod<void>('delete', {'groupId': groupId});
    } on PlatformException catch (error) {
      throw _mapError(error);
    } on MissingPluginException {
      throw const DeviceKeyUnavailableException();
    }
  }

  List<int> _requiredBytes(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is Uint8List && value.isNotEmpty) return value;
    if (value is List<int> && value.isNotEmpty) return value;
    throw const DeviceKeyIntegrityException();
  }

  DeviceBoundKeyException _mapError(PlatformException error) {
    return switch (error.code) {
      'authentication_required' =>
        const DeviceAuthenticationRequiredException(),
      'key_invalidated' => const DeviceKeyInvalidatedException(),
      'integrity_failed' => const DeviceKeyIntegrityException(),
      _ => const DeviceKeyUnavailableException(),
    };
  }
}
