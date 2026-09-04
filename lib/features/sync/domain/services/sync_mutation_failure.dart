enum SyncMutationFailureStage {
  storageConfiguration,
  enrollment,
  deviceIdentity,
  localState,
  currentSnapshot,
  localCommit,
}

class SyncMutationFailure implements Exception {
  const SyncMutationFailure({required this.stage, required this.cause});

  final SyncMutationFailureStage stage;
  final Object cause;

  @override
  String toString() => 'SyncMutationFailure(${stage.name})';
}
