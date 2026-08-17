class SyncRecoverySnapshotPublication {
  const SyncRecoverySnapshotPublication({
    required this.snapshotId,
    required this.relativePath,
    required this.atomicFinalization,
  });

  final String snapshotId;
  final String relativePath;
  final bool atomicFinalization;
}

typedef SyncRecoverySnapshotService =
    Future<SyncRecoverySnapshotPublication> Function({
      required String folderUri,
      required String groupId,
      required List<int> clearKey,
    });

class SyncRecoverySnapshotException implements Exception {
  const SyncRecoverySnapshotException();
}
