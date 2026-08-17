import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/device_identity_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/device_identity_settings_card.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('stays hidden in single-device mode', (tester) async {
    final identity = await _identityController();
    await _pumpSection(
      tester,
      identity: identity,
      storage: SyncStorageController(),
    );

    expect(
      find.byKey(const ValueKey('device-identity-settings-card')),
      findsNothing,
    );
  });

  testWidgets('shows the automatic name and short internal ID in multi mode', (
    tester,
  ) async {
    final identity = await _identityController();
    final storage = SyncStorageController();
    await storage.setMode(SyncStorageMode.multipleDevices);
    await _pumpSection(tester, identity: identity, storage: storage);

    expect(find.text('Este dispositivo'), findsOneWidget);
    expect(find.text('Samsung S23'), findsOneWidget);
    expect(find.textContaining('12345678'), findsOneWidget);
  });

  testWidgets('renames the phone without replacing its identity', (
    tester,
  ) async {
    final repository = _MemoryIdentityRepository(
      const DeviceIdentity(
        installationId: 'installation_abcdef12345678',
        friendlyName: 'Samsung S23',
      ),
    );
    final identity = DeviceIdentityController(repository: repository);
    await identity.initialize();
    final storage = SyncStorageController();
    await storage.setMode(SyncStorageMode.multipleDevices);
    await _pumpSection(tester, identity: identity, storage: storage);

    await tester.enterText(
      find.byKey(const ValueKey('device-friendly-name-field')),
      'Teléfono personal',
    );
    await tester.tap(find.byKey(const ValueKey('save-device-friendly-name')));
    await tester.pumpAndSettle();

    expect(identity.friendlyName.value, 'Teléfono personal');
    expect(identity.installationId.value, 'installation_abcdef12345678');
  });
}

Future<DeviceIdentityController> _identityController() async {
  final controller = DeviceIdentityController(
    repository: _MemoryIdentityRepository(
      const DeviceIdentity(
        installationId: 'installation_abcdef12345678',
        friendlyName: 'Samsung S23',
      ),
    ),
  );
  await controller.initialize();
  return controller;
}

Future<void> _pumpSection(
  WidgetTester tester, {
  required DeviceIdentityController identity,
  required SyncStorageController storage,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.fromPreset(AppThemePreset.natureFocus, isDark: false),
      home: Scaffold(
        body: SingleChildScrollView(
          child: DeviceIdentitySettingsSection(
            identityController: identity,
            storageController: storage,
          ),
        ),
      ),
    ),
  );
}

class _MemoryIdentityRepository implements DeviceIdentityRepository {
  _MemoryIdentityRepository(this.identity);

  DeviceIdentity identity;

  @override
  Future<DeviceIdentity> load() async => identity;

  @override
  Future<void> save(DeviceIdentity identity) async {
    this.identity = identity;
  }
}
