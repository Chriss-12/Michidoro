import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/configured_sync_mutation_coordinator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_storage_config_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_coordinator.dart';

void main() {
  late MichiFocusDatabase database;
  final now = DateTime.utc(2026, 8, 14, 12);

  setUp(() {
    database = MichiFocusDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test(
    'records sequential causal operations and a durable tombstone',
    () async {
      final coordinator = _coordinator(database, now: now);
      const goalId = 'goal_0123456789abcdef0123456789abcdef';

      await coordinator<void>(
        entityType: 'goal',
        entityId: goalId,
        operationKind: 'create',
        changedFields: const {'title': 'Read', 'targetSessions': 2},
        mutate: () => database
            .into(database.goalRecords)
            .insert(
              GoalRecordsCompanion.insert(
                id: goalId,
                title: 'Read',
                targetSessions: 2,
                createdAt: now,
                updatedAt: now,
              ),
            ),
      );
      await coordinator<void>(
        entityType: 'goal',
        entityId: goalId,
        operationKind: 'update',
        changedFields: const {'title': 'Read more'},
        mutate: () =>
            (database.update(
              database.goalRecords,
            )..where((row) => row.id.equals(goalId))).write(
              const GoalRecordsCompanion(title: Value('Read more')),
            ),
      );

      final outbox = await database.select(database.syncOutboxRecords).get();
      expect(outbox.map((row) => row.originCounter), [1, 2]);
      expect(outbox.first.parentVersionJson, '{}');
      expect(outbox.last.parentVersionJson, contains('"$_installationId":1'));
      expect(outbox.every((row) => row.payloadSha256.length == 64), isTrue);

      await coordinator<void>(
        entityType: 'goal',
        entityId: goalId,
        operationKind: 'delete',
        changedFields: const {},
        mutate: () => (database.delete(
          database.goalRecords,
        )..where((row) => row.id.equals(goalId))).go(),
      );

      expect(await database.select(database.goalRecords).get(), isEmpty);
      final tombstone = await database
          .select(database.syncTombstoneRecords)
          .getSingle();
      expect(tombstone.entityId, goalId);
      expect(tombstone.causalVersionJson, contains('"$_installationId":3'));
    },
  );

  test(
    'single-device mode mutates without creating exchange metadata',
    () async {
      final coordinator = _coordinator(
        database,
        now: now,
        mode: SyncStorageMode.singleDevice,
      );
      var changed = false;

      await coordinator<void>(
        entityType: 'goal',
        entityId: 'local-only',
        operationKind: 'create',
        changedFields: const {'title': 'Local'},
        mutate: () async => changed = true,
      );

      expect(changed, isTrue);
      expect(await database.select(database.syncOutboxRecords).get(), isEmpty);
      expect(
        await database.select(database.syncLocalStateRecords).get(),
        isEmpty,
      );
    },
  );
}

SyncMutationCoordinator _coordinator(
  MichiFocusDatabase database, {
  required DateTime now,
  SyncStorageMode mode = SyncStorageMode.multipleDevices,
}) {
  return ConfiguredSyncMutationCoordinator(
    storageRepository: _StorageRepository(mode),
    enrollmentRepository: _EnrollmentRepository(_enrollment()),
    identityRepository: const _IdentityRepository(
      DeviceIdentity(
        installationId: _installationId,
        friendlyName: 'Phone A',
      ),
    ),
    exchangeRepository: DriftSyncExchangeRepository(database),
    idGenerator: SecureSyncIdGenerator(random: Random(7)),
    clock: () => now,
  ).call;
}

const _installationId = 'installation_0123456789abcdef0123456789abcdef';

SyncGroupEnrollment _enrollment() => SyncGroupEnrollment(
  manifest: SyncGroupKeyManifest(
    groupId: 'group_0123456789abcdef0123456789abcdef',
    passwordKdf: PasswordKdfParameters(
      salt: List<int>.filled(16, 1),
      memoryKiB: 64 * 1024,
      iterations: 3,
      parallelism: 1,
      hashLength: 32,
    ),
    passwordWrappedDek: EncryptedKeyEnvelope(
      nonce: List<int>.filled(12, 2),
      cipherText: List<int>.filled(32, 3),
      mac: List<int>.filled(16, 4),
    ),
    recoveryWrappedDek: EncryptedKeyEnvelope(
      nonce: List<int>.filled(12, 5),
      cipherText: List<int>.filled(32, 6),
      mac: List<int>.filled(16, 7),
    ),
  ),
  deviceBoundDek: DeviceBoundKeyEnvelope(
    nonce: List<int>.filled(12, 8),
    cipherText: List<int>.filled(48, 9),
  ),
);

class _StorageRepository implements SyncStorageConfigRepository {
  const _StorageRepository(this.mode);

  final SyncStorageMode mode;

  @override
  Future<SyncStorageConfig> load() async => SyncStorageConfig(mode: mode);

  @override
  Future<void> save(SyncStorageConfig config) async {}
}

class _EnrollmentRepository implements SyncGroupEnrollmentRepository {
  const _EnrollmentRepository(this.enrollment);

  final SyncGroupEnrollment enrollment;

  @override
  Future<void> create(SyncGroupEnrollment enrollment) async {}

  @override
  Future<SyncGroupEnrollment?> load() async => enrollment;

  @override
  Future<void> update(SyncGroupEnrollment enrollment) async {}
}

class _IdentityRepository implements DeviceIdentityRepository {
  const _IdentityRepository(this.identity);

  final DeviceIdentity identity;

  @override
  Future<DeviceIdentity> load() async => identity;

  @override
  Future<void> save(DeviceIdentity identity) async {}
}
