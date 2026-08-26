import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_conflict.dart';

abstract interface class SyncConflictResolutionService {
  Future<List<SyncConflict>> loadOpen({
    required String groupId,
    required String localInstallationId,
    required String localDeviceName,
  });

  Future<void> resolve({
    required String conflictId,
    required String groupId,
    required String localInstallationId,
    required String localDeviceName,
    required SyncConflictChoice choice,
  });
}
