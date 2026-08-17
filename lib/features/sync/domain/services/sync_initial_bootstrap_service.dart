class SyncInitialBootstrapReport {
  const SyncInitialBootstrapReport({
    required this.queued,
    required this.skipped,
  });

  final int queued;
  final int skipped;
}

typedef SyncInitialBootstrapService =
    Future<SyncInitialBootstrapReport> Function({
      required String groupId,
      required String installationId,
      required int protocolVersion,
    });
