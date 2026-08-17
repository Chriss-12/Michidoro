import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_storage_config_repository.dart';

typedef SyncConfigDirectoryProvider = Future<Directory> Function();

class FileSyncStorageConfigRepository implements SyncStorageConfigRepository {
  FileSyncStorageConfigRepository({SyncConfigDirectoryProvider? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  static const _fileName = 'michifocus-sync-settings.json';

  final SyncConfigDirectoryProvider _directory;

  @override
  Future<SyncStorageConfig> load() async {
    try {
      final file = await _configFile();
      if (!file.existsSync()) return const SyncStorageConfig();

      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return const SyncStorageConfig();

      final modeName = decoded['mode'];
      final mode = SyncStorageMode.values.firstWhere(
        (candidate) => candidate.name == modeName,
        orElse: () => SyncStorageMode.singleDevice,
      );
      return SyncStorageConfig(
        mode: mode,
        folderUri: decoded['folderUri'] is String
            ? decoded['folderUri'] as String
            : '',
        folderLabel: decoded['folderLabel'] is String
            ? decoded['folderLabel'] as String
            : '',
      ).normalized();
    } on FormatException {
      return const SyncStorageConfig();
    } on FileSystemException {
      return const SyncStorageConfig();
    }
  }

  @override
  Future<void> save(SyncStorageConfig config) async {
    final normalized = config.normalized();
    final file = await _configFile();
    await file.writeAsString(
      jsonEncode({
        'mode': normalized.mode.name,
        'folderUri': normalized.folderUri,
        'folderLabel': normalized.folderLabel,
      }),
      flush: true,
    );
  }

  Future<File> _configFile() async {
    final directory = await _directory();
    return File('${directory.path}/$_fileName');
  }
}
