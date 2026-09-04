enum SyncConflictChoice { local, remote, preserveBoth }

class SyncConflictCandidate {
  const SyncConflictCandidate({
    required this.originDeviceId,
    required this.deviceLabel,
    required this.recordedAt,
    required this.value,
    required this.isDeletion,
    required this.canApply,
    this.snapshot = const {},
  });

  final String originDeviceId;
  final String deviceLabel;
  final DateTime recordedAt;
  final Object? value;
  final bool isDeletion;
  final bool canApply;
  final Map<String, Object?> snapshot;
}

class SyncConflict {
  const SyncConflict({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.fieldName,
    required this.createdAt,
    required this.local,
    required this.remote,
  });

  final String id;
  final String entityType;
  final String entityId;
  final String? fieldName;
  final DateTime createdAt;
  final SyncConflictCandidate local;
  final SyncConflictCandidate remote;

  bool get isDeletionConflict =>
      local.isDeletion || remote.isDeletion || fieldName == null;

  bool get canPreserveBoth {
    if (!const {
      'goal',
      'calendarEvent',
      'quickNote',
    }.contains(entityType)) {
      return false;
    }
    if (isDeletionConflict) {
      final surviving = local.isDeletion ? remote : local;
      return !surviving.isDeletion && surviving.snapshot.isNotEmpty;
    }
    return local.snapshot.isNotEmpty && remote.snapshot.isNotEmpty;
  }
}
