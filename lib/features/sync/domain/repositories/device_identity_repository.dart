import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';

abstract interface class DeviceIdentityRepository {
  Future<DeviceIdentity> load();

  Future<void> save(DeviceIdentity identity);
}
