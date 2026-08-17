import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_data_folder.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_storage_config_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_data_folder_validator.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';

void main() {
  test('starts in single-device mode without storage work', () {
    final controller = SyncStorageController();

    expect(controller.mode.value, SyncStorageMode.singleDevice);
    expect(controller.hasSelectedFolder, isFalse);
  });

  test('loads persisted mode and folder', () async {
    final repository = _MemoryConfigRepository(
      const SyncStorageConfig(
        mode: SyncStorageMode.multipleDevices,
        folderUri: 'content://shared',
        folderLabel: 'Compartida',
      ),
    );
    final controller = SyncStorageController(repository: repository);

    await controller.load();

    expect(controller.mode.value, SyncStorageMode.multipleDevices);
    expect(controller.folderLabel.value, 'Compartida');
  });

  test('changes mode without discarding the selected folder', () async {
    final repository = _MemoryConfigRepository(
      const SyncStorageConfig(
        folderUri: 'content://backup',
        folderLabel: 'Backup',
      ),
    );
    final controller = SyncStorageController(repository: repository);
    await controller.load();

    await controller.setMode(SyncStorageMode.multipleDevices);

    expect(repository.config.mode, SyncStorageMode.multipleDevices);
    expect(repository.config.folderUri, 'content://backup');
  });

  test('persists a folder selected in either mode', () async {
    final repository = _MemoryConfigRepository(const SyncStorageConfig());
    final controller = SyncStorageController(
      repository: repository,
      folderPicker: () async =>
          const SyncDataFolder(uri: 'content://chosen', label: 'Elegida'),
    );

    expect(await controller.selectFolder(), isTrue);
    expect(controller.folderUri.value, 'content://chosen');
    expect(repository.config.folderLabel, 'Elegida');
  });

  test('picker cancellation leaves the previous folder unchanged', () async {
    final repository = _MemoryConfigRepository(
      const SyncStorageConfig(
        folderUri: 'content://previous',
        folderLabel: 'Anterior',
      ),
    );
    final controller = SyncStorageController(
      repository: repository,
      folderPicker: () async => null,
    );
    await controller.load();

    expect(await controller.selectFolder(), isFalse);
    expect(controller.folderUri.value, 'content://previous');
    expect(repository.config.folderLabel, 'Anterior');
  });

  test('disconnects only the folder and preserves the mode', () async {
    final repository = _MemoryConfigRepository(
      const SyncStorageConfig(
        mode: SyncStorageMode.multipleDevices,
        folderUri: 'content://shared',
        folderLabel: 'Compartida',
      ),
    );
    final controller = SyncStorageController(repository: repository);
    await controller.load();

    await controller.disconnectFolder();

    expect(controller.mode.value, SyncStorageMode.multipleDevices);
    expect(controller.hasSelectedFolder, isFalse);
    expect(controller.folderAccessState.value, SyncFolderAccessState.none);
  });

  test(
    'validates a selected folder without blocking local configuration load',
    () async {
      final repository = _MemoryConfigRepository(
        const SyncStorageConfig(
          folderUri: 'content://revoked',
          folderLabel: 'Anterior',
        ),
      );
      final controller = SyncStorageController(
        repository: repository,
        folderValidator: (_) async => false,
      );

      await controller.load();
      expect(controller.folderAccessState.value, SyncFolderAccessState.unknown);

      expect(await controller.validateSelectedFolder(), isFalse);
      expect(
        controller.folderAccessState.value,
        SyncFolderAccessState.unavailable,
      );
      expect(controller.hasSelectedFolder, isTrue);
    },
  );

  test(
    'does not persist a newly selected folder that fails validation',
    () async {
      final repository = _MemoryConfigRepository(
        const SyncStorageConfig(
          folderUri: 'content://working',
          folderLabel: 'Actual',
        ),
      );
      final controller = SyncStorageController(
        repository: repository,
        folderPicker: () async =>
            const SyncDataFolder(uri: 'content://blocked', label: 'Bloqueada'),
        folderValidator: (_) async => false,
      );
      await controller.load();

      await expectLater(
        controller.selectFolder(),
        throwsA(isA<SyncDataFolderUnavailableException>()),
      );

      expect(controller.folderUri.value, 'content://working');
      expect(repository.config.folderLabel, 'Actual');
    },
  );
}

class _MemoryConfigRepository implements SyncStorageConfigRepository {
  _MemoryConfigRepository(this.config);

  SyncStorageConfig config;

  @override
  Future<SyncStorageConfig> load() async => config;

  @override
  Future<void> save(SyncStorageConfig config) async {
    this.config = config;
  }
}
