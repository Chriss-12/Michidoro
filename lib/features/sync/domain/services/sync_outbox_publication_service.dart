class SyncOutboxPublicationReport {
  const SyncOutboxPublicationReport({
    required this.published,
    required this.failed,
    required this.remaining,
  });

  final int published;
  final int failed;
  final int remaining;
}

typedef SyncOutboxPublicationService =
    Future<SyncOutboxPublicationReport> Function({
      required String folderUri,
      required String groupId,
      required String installationId,
      required List<int> clearKey,
    });
