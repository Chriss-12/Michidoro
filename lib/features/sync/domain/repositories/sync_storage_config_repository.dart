import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';

abstract interface class SyncStorageConfigRepository {
  Future<SyncStorageConfig> load();

  Future<void> save(SyncStorageConfig config);
}
