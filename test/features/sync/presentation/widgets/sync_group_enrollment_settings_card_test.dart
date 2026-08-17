import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_local_data_summary.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_bound_key_protector.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_recovery_snapshot_service.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_group_enrollment_settings_card.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('stays hidden in single-device mode', (tester) async {
    await _pumpCard(
      tester,
      enrollment: _buildEnrollmentController(_MemoryRepository()),
      storage: SyncStorageController(),
    );

    expect(
      find.byKey(const ValueKey('sync-group-enrollment-card')),
      findsNothing,
    );
  });

  testWidgets('requires a selected folder before group creation', (
    tester,
  ) async {
    final storage = SyncStorageController()
      ..mode.value = SyncStorageMode.multipleDevices;
    await _pumpCard(
      tester,
      enrollment: _buildEnrollmentController(_MemoryRepository()),
      storage: storage,
    );

    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('create-secure-sync-group')),
    );
    expect(button.onPressed, isNull);
    expect(
      find.text('Primero selecciona y valida la carpeta que compartirás.'),
      findsOneWidget,
    );
  });

  testWidgets('persists only after recovery confirmation', (tester) async {
    final repository = _MemoryRepository();
    final enrollment = _buildEnrollmentController(repository);
    final storage = SyncStorageController()
      ..mode.value = SyncStorageMode.multipleDevices
      ..folderUri.value = 'content://tree/michifocus'
      ..folderLabel.value = 'MichiFocus'
      ..folderAccessState.value = SyncFolderAccessState.available;
    await _pumpCard(tester, enrollment: enrollment, storage: storage);

    await tester.tap(find.byKey(const ValueKey('create-secure-sync-group')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('sync-group-password')),
      'correct horse battery staple',
    );
    await tester.enterText(
      find.byKey(const ValueKey('sync-group-password-confirmation')),
      'correct horse battery staple',
    );
    await tester.tap(find.byKey(const ValueKey('prepare-secure-sync-group')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('sync-recovery-key')),
      findsOneWidget,
    );
    expect(repository.created, isNull);
    expect(enrollment.recoveryKey.value, isNotEmpty);

    await tester.tap(
      find.byKey(const ValueKey('confirm-sync-recovery-saved')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('finish-sync-group-enrollment')),
    );
    await tester.pumpAndSettle();

    expect(repository.created, isNotNull);
    expect(enrollment.state.value, SyncGroupEnrollmentState.enrolled);
    expect(enrollment.recoveryKey.value, isEmpty);
    expect(find.textContaining('Grupo interno:'), findsOneWidget);
    expect(
      find.textContaining('Syncthing ya puede transportarlo'),
      findsOneWidget,
    );
  });

  testWidgets('shows discovered groups without linking automatically', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    final enrollment = _buildEnrollmentController(repository);
    final storage = SyncStorageController()
      ..mode.value = SyncStorageMode.multipleDevices
      ..folderUri.value = 'content://tree/michifocus'
      ..folderLabel.value = 'MichiFocus'
      ..folderAccessState.value = SyncFolderAccessState.available;
    await _pumpCard(tester, enrollment: enrollment, storage: storage);

    await tester.tap(find.byKey(const ValueKey('discover-secure-sync-groups')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('discovered-sync-groups-summary')),
      findsOneWidget,
    );
    expect(find.textContaining('Se encontró 1 grupo seguro'), findsOneWidget);
    expect(find.text('Vincular'), findsOneWidget);
    expect(repository.created, isNull);
  });

  testWidgets('links a discovered group after password and device security', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    final enrollment = _buildEnrollmentController(repository);
    final storage = SyncStorageController()
      ..mode.value = SyncStorageMode.multipleDevices
      ..folderUri.value = 'content://tree/michifocus'
      ..folderLabel.value = 'MichiFocus'
      ..folderAccessState.value = SyncFolderAccessState.available;
    await _pumpCard(tester, enrollment: enrollment, storage: storage);

    await tester.tap(find.byKey(const ValueKey('discover-secure-sync-groups')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vincular'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('join-sync-group-credential')),
      'correct horse battery staple',
    );
    await tester.tap(find.byKey(const ValueKey('confirm-join-sync-group')));
    await tester.pumpAndSettle();

    expect(repository.created, isNotNull);
    expect(enrollment.state.value, SyncGroupEnrollmentState.enrolled);
    expect(
      find.byKey(const ValueKey('publish-pending-sync-changes')),
      findsOneWidget,
    );
    expect(find.textContaining('envío cifrado'), findsOneWidget);
    expect(find.textContaining('todavía no está activa'), findsNothing);
  });

  testWidgets('requires a merge or replace choice for populated local data', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    final enrollment = _buildEnrollmentController(
      repository,
      localDataSummary: const SyncLocalDataSummary(
        goals: 1,
        tasks: 2,
        calendarEvents: 1,
        focusSessions: 1,
        taskCompletionEvents: 0,
        routines: 1,
        routineRuns: 0,
      ),
    );
    final storage = SyncStorageController()
      ..mode.value = SyncStorageMode.multipleDevices
      ..folderUri.value = 'content://tree/michifocus'
      ..folderLabel.value = 'MichiFocus'
      ..folderAccessState.value = SyncFolderAccessState.available;
    await _pumpCard(tester, enrollment: enrollment, storage: storage);

    await tester.tap(find.byKey(const ValueKey('discover-secure-sync-groups')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vincular'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Hay 6 registros locales'), findsOneWidget);
    var confirm = tester.widget<FilledButton>(
      find.byKey(const ValueKey('confirm-join-sync-group')),
    );
    expect(confirm.onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey('join-bootstrap-merge')));
    await tester.enterText(
      find.byKey(const ValueKey('join-sync-group-credential')),
      'correct horse battery staple',
    );
    confirm = tester.widget<FilledButton>(
      find.byKey(const ValueKey('confirm-join-sync-group')),
    );
    expect(confirm.onPressed, isNotNull);
    await tester.tap(find.byKey(const ValueKey('confirm-join-sync-group')));
    await tester.pumpAndSettle();

    expect(
      repository.created?.bootstrapPreference,
      SyncGroupBootstrapPreference.mergeLocal,
    );
    expect(
      find.byKey(const ValueKey('sync-bootstrap-preparation-status')),
      findsOneWidget,
    );
  });

  testWidgets(
    'an already linked phone can prepare its encrypted recovery copy',
    (
      tester,
    ) async {
      final repository = _MemoryRepository()
        ..created = await _existingEnrollment();
      final enrollment = _buildEnrollmentController(
        repository,
        localDataSummary: const SyncLocalDataSummary(
          goals: 0,
          tasks: 2,
          calendarEvents: 0,
          focusSessions: 0,
          taskCompletionEvents: 0,
          routines: 1,
          routineRuns: 0,
        ),
      );
      await enrollment.load();
      final storage = SyncStorageController()
        ..mode.value = SyncStorageMode.multipleDevices
        ..folderUri.value = 'content://tree/michifocus'
        ..folderLabel.value = 'MichiFocus'
        ..folderAccessState.value = SyncFolderAccessState.available;
      await _pumpCard(tester, enrollment: enrollment, storage: storage);

      expect(
        find.byKey(const ValueKey('create-encrypted-recovery-snapshot')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const ValueKey('create-encrypted-recovery-snapshot')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('encrypted-recovery-snapshot-ready')),
        findsOneWidget,
      );
      expect(repository.created?.recoverySnapshotPath, 'recovery.json');
    },
  );
}

SyncGroupEnrollmentController _buildEnrollmentController(
  _MemoryRepository repository, {
  SyncLocalDataSummary localDataSummary = const SyncLocalDataSummary.empty(),
}) {
  return SyncGroupEnrollmentController(
    repository: repository,
    crypto: SyncGroupCrypto(
      parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
      random: Random(3),
    ),
    keyProtector: _FakeProtector(),
    authenticator: _FakeAuthenticator(),
    idGenerator: SecureSyncIdGenerator(random: Random(4)),
    manifestPublisher: _FakePublisher(),
    manifestDiscovery: _FakeDiscovery().call,
    localDataInspector: () async => localDataSummary,
    recoverySnapshotService:
        ({required folderUri, required groupId, required clearKey}) async =>
            const SyncRecoverySnapshotPublication(
              snapshotId: 'snapshot_0123456789abcdef0123456789abcdef',
              relativePath: 'recovery.json',
              atomicFinalization: true,
            ),
  );
}

Future<void> _pumpCard(
  WidgetTester tester, {
  required SyncGroupEnrollmentController enrollment,
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
          child: SyncGroupEnrollmentSettingsCard(
            controller: enrollment,
            storageController: storage,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _MemoryRepository implements SyncGroupEnrollmentRepository {
  SyncGroupEnrollment? created;

  @override
  Future<void> create(SyncGroupEnrollment enrollment) async {
    created = enrollment;
  }

  @override
  Future<SyncGroupEnrollment?> load() async => created;

  @override
  Future<void> update(SyncGroupEnrollment enrollment) async {
    created = enrollment;
  }
}

Future<SyncGroupEnrollment> _existingEnrollment() async {
  final created =
      await SyncGroupCrypto(
        parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
        random: Random(18),
      ).createGroupKeys(
        groupId: 'group_0123456789abcdef0123456789abcdef',
        password: 'correct horse battery staple',
      );
  return SyncGroupEnrollment(
    manifest: created.manifest,
    deviceBoundDek: DeviceBoundKeyEnvelope(
      nonce: List<int>.filled(12, 2),
      cipherText: List<int>.filled(48, 3),
    ),
  );
}

class _FakeAuthenticator implements LocalDeviceAuthenticator {
  @override
  Future<bool> authenticate() async => true;

  @override
  Future<bool> isAvailable() async => true;
}

class _FakeProtector implements DeviceBoundKeyProtector {
  @override
  Future<void> delete(String groupId) async {}

  @override
  Future<bool> hasKey(String groupId) async => true;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<List<int>> unwrap({
    required String groupId,
    required DeviceBoundKeyEnvelope envelope,
  }) async => List<int>.filled(32, 1);

  @override
  Future<DeviceBoundKeyEnvelope> wrap({
    required String groupId,
    required List<int> clearKey,
  }) async {
    return DeviceBoundKeyEnvelope(
      nonce: List<int>.filled(12, 2),
      cipherText: List<int>.filled(48, 3),
    );
  }
}

class _FakePublisher implements SyncGroupManifestPublisher {
  @override
  String relativePathFor(String groupId) => 'michifocus-$groupId.v1.json';

  @override
  Future<SyncGroupManifestPublication> publish({
    required String folderUri,
    required SyncGroupKeyManifest manifest,
  }) async {
    return SyncGroupManifestPublication(
      relativePath: relativePathFor(manifest.groupId),
      atomicFinalization: true,
    );
  }
}

class _FakeDiscovery {
  Future<SyncGroupManifestDiscoveryResult> call({
    required String folderUri,
  }) async {
    final created =
        await SyncGroupCrypto(
          parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
          random: Random(8),
        ).createGroupKeys(
          groupId: 'group_0123456789abcdef0123456789abcdef',
          password: 'correct horse battery staple',
        );
    return SyncGroupManifestDiscoveryResult(
      groups: [
        DiscoveredSyncGroupManifest(
          relativePath: 'michifocus-${created.manifest.groupId}.v1.json',
          manifest: created.manifest,
        ),
      ],
      rejectedFiles: 0,
    );
  }
}
