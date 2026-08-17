import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_data_folder.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_storage_config_repository.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_storage_settings_card.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('shows single-device mode as the default', (tester) async {
    final controller = SyncStorageController();
    await _pumpCard(tester, controller);

    expect(controller.mode.value, SyncStorageMode.singleDevice);
    expect(find.text('Sin carpeta seleccionada'), findsOneWidget);
    expect(find.textContaining('todavía no comparte datos'), findsNothing);
  });

  testWidgets('explains and confirms multiple-device preparation', (
    tester,
  ) async {
    final repository = _MemoryConfigRepository(const SyncStorageConfig());
    final controller = SyncStorageController(repository: repository);
    await _pumpCard(tester, controller);

    await tester.tap(find.text('Varios'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('enable-multiple-devices-dialog')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('confirm-multiple-devices')));
    await tester.pumpAndSettle();

    expect(controller.mode.value, SyncStorageMode.multipleDevices);
    expect(find.textContaining('todavía no comparte datos'), findsOneWidget);
  });

  testWidgets('selects and disconnects a folder without changing mode', (
    tester,
  ) async {
    final repository = _MemoryConfigRepository(const SyncStorageConfig());
    final controller = SyncStorageController(
      repository: repository,
      folderPicker: () async => const SyncDataFolder(
        uri: 'content://tree/michifocus',
        label: 'MichiFocus móvil',
      ),
    );
    await _pumpCard(tester, controller);

    await tester.tap(
      find.byKey(const ValueKey('sync-storage-select-folder')),
    );
    await tester.pumpAndSettle();
    expect(find.text('MichiFocus móvil'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('sync-storage-disconnect-folder')),
    );
    await tester.pumpAndSettle();

    expect(controller.mode.value, SyncStorageMode.singleDevice);
    expect(controller.hasSelectedFolder, isFalse);
  });

  testWidgets('warns when Android folder access has been revoked', (
    tester,
  ) async {
    final repository = _MemoryConfigRepository(
      const SyncStorageConfig(
        folderUri: 'content://revoked',
        folderLabel: 'Carpeta anterior',
      ),
    );
    final controller = SyncStorageController(
      repository: repository,
      folderValidator: (_) async => false,
    );
    await controller.load();
    await _pumpCard(tester, controller);
    await tester.pumpAndSettle();

    expect(find.textContaining('Acceso perdido'), findsOneWidget);
    expect(controller.hasSelectedFolder, isTrue);
  });

  testWidgets('rejects a selected folder that cannot pass the probe', (
    tester,
  ) async {
    final repository = _MemoryConfigRepository(const SyncStorageConfig());
    final controller = SyncStorageController(
      repository: repository,
      folderPicker: () async =>
          const SyncDataFolder(uri: 'content://blocked', label: 'Bloqueada'),
      folderValidator: (_) async => false,
    );
    await _pumpCard(tester, controller);

    await tester.tap(find.byKey(const ValueKey('sync-storage-select-folder')));
    await tester.pumpAndSettle();

    expect(find.textContaining('archivo de prueba'), findsOneWidget);
    expect(controller.hasSelectedFolder, isFalse);
    expect(repository.config.hasSelectedFolder, isFalse);
  });
}

Future<void> _pumpCard(
  WidgetTester tester,
  SyncStorageController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.fromPreset(AppThemePreset.natureFocus, isDark: false),
      home: Scaffold(
        body: SingleChildScrollView(
          child: SyncStorageSettingsCard(controller: controller),
        ),
      ),
    ),
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
