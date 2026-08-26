import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_conflict.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_bound_key_protector.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_conflict_resolution_service.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_conflict_center_sheet.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('shows both versions and resolves the selected candidate', (
    tester,
  ) async {
    final service = _MemoryConflictService()..conflicts = [_conflict];
    final controller = SyncGroupEnrollmentController(
      repository: _MemoryEnrollmentRepository(await _enrollment()),
      identityRepository: _MemoryIdentityRepository(),
      keyProtector: _AvailableKeyProtector(),
      conflictResolutionService: service,
    );
    await controller.load();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.fromPreset(
          AppThemePreset.natureFocus,
          isDark: false,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () => showSyncConflictCenter(context, controller),
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(find.text('Resolver conflictos'), findsOneWidget);
    expect(find.text('Realme personal'), findsOneWidget);
    expect(find.text('Poco personal'), findsOneWidget);
    expect(find.text('Leer local'), findsOneWidget);
    expect(find.text('Leer remoto'), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, 'Conservar esta versión'),
      findsNWidgets(2),
    );
    expect(find.text('Conservar ambas versiones'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Conservar esta versión').at(1),
    );
    await tester.pumpAndSettle();
    expect(find.text('Confirmar elección'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('confirm-sync-conflict-resolution')),
    );
    await tester.pumpAndSettle();

    expect(service.resolvedChoice, SyncConflictChoice.remote);
    expect(find.text('No hay conflictos pendientes.'), findsOneWidget);
  });
}

final _conflict = SyncConflict(
  id: 'conflict-a',
  entityType: 'goal',
  entityId: 'goal-a',
  fieldName: 'title',
  createdAt: DateTime.utc(2026, 8, 24, 15),
  local: SyncConflictCandidate(
    originDeviceId: _localId,
    deviceLabel: 'Realme personal',
    recordedAt: DateTime.utc(2026, 8, 24, 14, 58),
    value: 'Leer local',
    isDeletion: false,
    canApply: true,
    snapshot: const {
      'title': 'Leer local',
      'targetSessions': 2,
      'completedSessions': 0,
      'createdAt': 1787580000000,
      'updatedAt': 1787580000000,
    },
  ),
  remote: SyncConflictCandidate(
    originDeviceId: _remoteId,
    deviceLabel: 'Poco personal',
    recordedAt: DateTime.utc(2026, 8, 24, 14, 59),
    value: 'Leer remoto',
    isDeletion: false,
    canApply: true,
    snapshot: const {
      'title': 'Leer remoto',
      'targetSessions': 2,
      'completedSessions': 0,
      'createdAt': 1787580000000,
      'updatedAt': 1787580000000,
    },
  ),
);

class _MemoryConflictService implements SyncConflictResolutionService {
  List<SyncConflict> conflicts = const [];
  SyncConflictChoice? resolvedChoice;

  @override
  Future<List<SyncConflict>> loadOpen({
    required String groupId,
    required String localInstallationId,
    required String localDeviceName,
  }) async => List<SyncConflict>.from(conflicts);

  @override
  Future<void> resolve({
    required String conflictId,
    required String groupId,
    required String localInstallationId,
    required String localDeviceName,
    required SyncConflictChoice choice,
  }) async {
    resolvedChoice = choice;
    conflicts = conflicts
        .where((conflict) => conflict.id != conflictId)
        .toList(growable: false);
  }
}

class _MemoryEnrollmentRepository implements SyncGroupEnrollmentRepository {
  _MemoryEnrollmentRepository(this.enrollment);

  SyncGroupEnrollment enrollment;

  @override
  Future<void> create(SyncGroupEnrollment enrollment) async {
    this.enrollment = enrollment;
  }

  @override
  Future<SyncGroupEnrollment?> load() async => enrollment;

  @override
  Future<void> update(SyncGroupEnrollment enrollment) async {
    this.enrollment = enrollment;
  }
}

class _MemoryIdentityRepository implements DeviceIdentityRepository {
  @override
  Future<DeviceIdentity> load() async => const DeviceIdentity(
    installationId: _localId,
    friendlyName: 'Realme personal',
  );

  @override
  Future<void> save(DeviceIdentity identity) async {}
}

class _AvailableKeyProtector implements DeviceBoundKeyProtector {
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
  }) async => DeviceBoundKeyEnvelope(
    nonce: List<int>.filled(12, 1),
    cipherText: List<int>.filled(48, 2),
  );
}

Future<SyncGroupEnrollment> _enrollment() async {
  final keys =
      await SyncGroupCrypto(
        parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
        random: Random(22),
      ).createGroupKeys(
        groupId: _groupId,
        password: 'correct horse battery staple',
      );
  return SyncGroupEnrollment(
    manifest: keys.manifest,
    deviceBoundDek: DeviceBoundKeyEnvelope(
      nonce: List<int>.filled(12, 1),
      cipherText: List<int>.filled(48, 2),
    ),
  );
}

const _groupId = 'group_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const _localId = 'installation_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
const _remoteId = 'installation_cccccccccccccccccccccccccccccccc';
