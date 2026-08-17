import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_storage_config_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_data_folder_picker.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_data_folder_validator.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum SyncFolderAccessState { none, unknown, checking, available, unavailable }

class SyncStorageController {
  SyncStorageController({
    SyncStorageConfigRepository? repository,
    SyncDataFolderPicker? folderPicker,
    SyncDataFolderValidator? folderValidator,
  }) : _repository = repository,
       _folderPicker = folderPicker,
       _folderValidator = folderValidator;

  final SyncStorageConfigRepository? _repository;
  final SyncDataFolderPicker? _folderPicker;
  final SyncDataFolderValidator? _folderValidator;

  final FlutterSignal<SyncStorageMode> mode = signal(
    SyncStorageMode.singleDevice,
  );
  final FlutterSignal<String> folderUri = signal('');
  final FlutterSignal<String> folderLabel = signal('');
  final FlutterSignal<SyncFolderAccessState> folderAccessState = signal(
    SyncFolderAccessState.none,
  );

  bool get hasSelectedFolder => folderUri.value.trim().isNotEmpty;

  SyncStorageConfig get config => SyncStorageConfig(
    mode: mode.value,
    folderUri: folderUri.value,
    folderLabel: folderLabel.value,
  ).normalized();

  Future<void> load() async {
    final repository = _repository;
    if (repository == null) return;
    _apply(await repository.load());
  }

  Future<void> setMode(SyncStorageMode nextMode) async {
    final previousAccessState = folderAccessState.value;
    final next = SyncStorageConfig(
      mode: nextMode,
      folderUri: folderUri.value,
      folderLabel: folderLabel.value,
    );
    await _repository?.save(next);
    _apply(next);
    if (next.hasSelectedFolder) {
      folderAccessState.value = previousAccessState;
    }
  }

  Future<bool> selectFolder() async {
    final selection = await _folderPicker?.call();
    if (selection == null || selection.uri.trim().isEmpty) return false;

    final validator = _folderValidator;
    if (validator != null && !await validator(selection.uri)) {
      throw const SyncDataFolderUnavailableException();
    }

    final next = SyncStorageConfig(
      mode: mode.value,
      folderUri: selection.uri,
      folderLabel: selection.label,
    ).normalized();
    await _repository?.save(next);
    _apply(next);
    folderAccessState.value = SyncFolderAccessState.available;
    return true;
  }

  Future<bool> validateSelectedFolder() async {
    final uri = folderUri.value.trim();
    if (uri.isEmpty) {
      folderAccessState.value = SyncFolderAccessState.none;
      return false;
    }
    final validator = _folderValidator;
    if (validator == null) {
      folderAccessState.value = SyncFolderAccessState.available;
      return true;
    }

    folderAccessState.value = SyncFolderAccessState.checking;
    final isAvailable = await validator(uri);
    folderAccessState.value = isAvailable
        ? SyncFolderAccessState.available
        : SyncFolderAccessState.unavailable;
    return isAvailable;
  }

  Future<void> disconnectFolder() async {
    final next = SyncStorageConfig(mode: mode.value);
    await _repository?.save(next);
    _apply(next);
    folderAccessState.value = SyncFolderAccessState.none;
  }

  void _apply(SyncStorageConfig next) {
    final normalized = next.normalized();
    batch(() {
      mode.value = normalized.mode;
      folderUri.value = normalized.folderUri;
      folderLabel.value = normalized.folderLabel;
      folderAccessState.value = normalized.hasSelectedFolder
          ? SyncFolderAccessState.unknown
          : SyncFolderAccessState.none;
    });
  }
}
