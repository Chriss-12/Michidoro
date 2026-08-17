import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';

class SyncGroupManifestPublication {
  const SyncGroupManifestPublication({
    required this.relativePath,
    required this.atomicFinalization,
  });

  final String relativePath;
  final bool atomicFinalization;
}

abstract interface class SyncGroupManifestPublisher {
  String relativePathFor(String groupId);

  Future<SyncGroupManifestPublication> publish({
    required String folderUri,
    required SyncGroupKeyManifest manifest,
  });
}

sealed class SyncGroupManifestPublicationException implements Exception {
  const SyncGroupManifestPublicationException();
}

class SyncGroupManifestConflictException
    extends SyncGroupManifestPublicationException {
  const SyncGroupManifestConflictException();
}

class SyncGroupManifestFolderUnavailableException
    extends SyncGroupManifestPublicationException {
  const SyncGroupManifestFolderUnavailableException();
}
