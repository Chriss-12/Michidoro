typedef SyncDataFolderValidator = Future<bool> Function(String folderUri);

class SyncDataFolderUnavailableException implements Exception {
  const SyncDataFolderUnavailableException();
}
