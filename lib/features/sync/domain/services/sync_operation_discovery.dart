import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';

class DiscoveredSyncOperation {
  const DiscoveredSyncOperation({
    required this.relativePath,
    required this.operation,
  });

  final String relativePath;
  final SyncEncryptedOperation operation;
}

class SyncOperationDiscoveryReport {
  const SyncOperationDiscoveryReport({
    required this.operations,
    required this.rejectedFiles,
  });

  final List<DiscoveredSyncOperation> operations;
  final int rejectedFiles;
}

typedef SyncOperationDiscovery =
    Future<SyncOperationDiscoveryReport> Function({
      required String folderUri,
      required String localInstallationId,
    });
