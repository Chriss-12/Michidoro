typedef SyncMutationCoordinator =
    Future<T> Function<T>({
      required String entityType,
      required String entityId,
      required String operationKind,
      required Map<String, Object?> changedFields,
      required Future<T> Function() mutate,
    });
