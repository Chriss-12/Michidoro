class SyncIncomingApplicationReport {
  const SyncIncomingApplicationReport({
    required this.applied,
    required this.duplicates,
    required this.conflicts,
    required this.deferred,
    required this.rejected,
  });

  final int applied;
  final int duplicates;
  final int conflicts;
  final int deferred;
  final int rejected;
}

typedef SyncIncomingApplicationService =
    Future<SyncIncomingApplicationReport> Function({
      required String folderUri,
      required String groupId,
      required String localInstallationId,
      required List<int> clearKey,
    });
