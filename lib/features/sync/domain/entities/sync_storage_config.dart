enum SyncStorageMode { singleDevice, multipleDevices }

class SyncStorageConfig {
  const SyncStorageConfig({
    this.mode = SyncStorageMode.singleDevice,
    this.folderUri = '',
    this.folderLabel = '',
  });

  final SyncStorageMode mode;
  final String folderUri;
  final String folderLabel;

  bool get hasSelectedFolder => folderUri.trim().isNotEmpty;

  SyncStorageConfig normalized() {
    final uri = folderUri.trim();
    return SyncStorageConfig(
      mode: mode,
      folderUri: uri,
      folderLabel: uri.isEmpty ? '' : folderLabel.trim(),
    );
  }
}
