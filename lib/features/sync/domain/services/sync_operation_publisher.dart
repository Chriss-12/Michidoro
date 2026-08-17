import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';

class SyncOperationPublication {
  const SyncOperationPublication({
    required this.relativePath,
    required this.atomicFinalization,
  });

  final String relativePath;
  final bool atomicFinalization;
}

abstract interface class SyncOperationPublisher {
  String relativePathFor(SyncEncryptedOperation operation);

  Future<SyncOperationPublication> publish({
    required String folderUri,
    required SyncEncryptedOperation operation,
  });
}

sealed class SyncOperationPublicationException implements Exception {
  const SyncOperationPublicationException();
}

class SyncOperationConflictException extends SyncOperationPublicationException {
  const SyncOperationConflictException();
}

class SyncOperationFolderUnavailableException
    extends SyncOperationPublicationException {
  const SyncOperationFolderUnavailableException();
}
