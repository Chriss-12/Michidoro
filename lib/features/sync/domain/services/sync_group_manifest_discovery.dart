import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';

class DiscoveredSyncGroupManifest {
  const DiscoveredSyncGroupManifest({
    required this.relativePath,
    required this.manifest,
  });

  final String relativePath;
  final SyncGroupKeyManifest manifest;
}

class SyncGroupManifestDiscoveryResult {
  const SyncGroupManifestDiscoveryResult({
    required this.groups,
    required this.rejectedFiles,
  });

  final List<DiscoveredSyncGroupManifest> groups;
  final int rejectedFiles;
}

typedef SyncGroupManifestDiscovery =
    Future<SyncGroupManifestDiscoveryResult> Function({
      required String folderUri,
    });

class SyncGroupManifestDiscoveryException implements Exception {
  const SyncGroupManifestDiscoveryException();
}
