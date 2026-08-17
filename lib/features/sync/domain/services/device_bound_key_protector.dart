import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';

abstract interface class DeviceBoundKeyProtector {
  Future<bool> isAvailable();

  Future<bool> hasKey(String groupId);

  Future<DeviceBoundKeyEnvelope> wrap({
    required String groupId,
    required List<int> clearKey,
  });

  Future<List<int>> unwrap({
    required String groupId,
    required DeviceBoundKeyEnvelope envelope,
  });

  Future<void> delete(String groupId);
}

sealed class DeviceBoundKeyException implements Exception {
  const DeviceBoundKeyException();
}

class DeviceAuthenticationRequiredException extends DeviceBoundKeyException {
  const DeviceAuthenticationRequiredException();
}

class DeviceKeyInvalidatedException extends DeviceBoundKeyException {
  const DeviceKeyInvalidatedException();
}

class DeviceKeyUnavailableException extends DeviceBoundKeyException {
  const DeviceKeyUnavailableException();
}

class DeviceKeyIntegrityException extends DeviceBoundKeyException {
  const DeviceKeyIntegrityException();
}
