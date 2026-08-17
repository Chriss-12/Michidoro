import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_local_data_summary.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_bound_key_protector.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_incoming_application_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_initial_bootstrap_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_local_data_inspector.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_outbox_publication_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_recovery_snapshot_service.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';

void main() {
  const password = 'correct horse battery staple';

  SyncGroupEnrollmentController buildController({
    _MemoryEnrollmentRepository? repository,
    _FakeAuthenticator? authenticator,
    _FakeKeyProtector? protector,
    _FakeManifestPublisher? publisher,
    SyncGroupManifestDiscovery? discovery,
    SyncLocalDataInspector? localDataInspector,
    SyncRecoverySnapshotService? recoverySnapshotService,
    SyncOutboxPublicationService? outboxPublicationService,
    SyncIncomingApplicationService? incomingApplicationService,
    SyncInitialBootstrapService? initialBootstrapService,
    DeviceIdentityRepository? identityRepository,
    Future<void> Function()? refreshApplicationData,
  }) {
    return SyncGroupEnrollmentController(
      repository: repository ?? _MemoryEnrollmentRepository(),
      crypto: SyncGroupCrypto(
        parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
        random: Random(11),
      ),
      keyProtector: protector ?? _FakeKeyProtector(),
      authenticator: authenticator ?? _FakeAuthenticator(),
      idGenerator: SecureSyncIdGenerator(random: Random(22)),
      manifestPublisher: publisher ?? _FakeManifestPublisher(),
      manifestDiscovery: discovery ?? _FakeManifestDiscovery().call,
      localDataInspector:
          localDataInspector ?? () async => const SyncLocalDataSummary.empty(),
      recoverySnapshotService:
          recoverySnapshotService ??
          ({required folderUri, required groupId, required clearKey}) async =>
              const SyncRecoverySnapshotPublication(
                snapshotId: 'snapshot_0123456789abcdef0123456789abcdef',
                relativePath: 'recovery.json',
                atomicFinalization: true,
              ),
      outboxPublicationService:
          outboxPublicationService ??
          ({
            required folderUri,
            required groupId,
            required installationId,
            required clearKey,
          }) async => const SyncOutboxPublicationReport(
            published: 0,
            failed: 0,
            remaining: 0,
          ),
      incomingApplicationService:
          incomingApplicationService ??
          ({
            required folderUri,
            required groupId,
            required localInstallationId,
            required clearKey,
          }) async => const SyncIncomingApplicationReport(
            applied: 0,
            duplicates: 0,
            conflicts: 0,
            deferred: 0,
            rejected: 0,
          ),
      initialBootstrapService: initialBootstrapService,
      identityRepository: identityRepository ?? _FakeIdentityRepository(),
      refreshApplicationData: refreshApplicationData,
    );
  }

  test('validates password before touching device security', () async {
    final authenticator = _FakeAuthenticator();
    final controller = buildController(authenticator: authenticator);

    expect(
      await controller.prepareNewGroup(
        password: 'short',
        passwordConfirmation: 'short',
      ),
      isFalse,
    );
    expect(
      controller.failure.value,
      SyncGroupEnrollmentFailure.passwordTooShort,
    );
    expect(authenticator.authenticationCalls, 0);

    expect(
      await controller.prepareNewGroup(
        password: password,
        passwordConfirmation: '$password!',
      ),
      isFalse,
    );
    expect(
      controller.failure.value,
      SyncGroupEnrollmentFailure.passwordsDoNotMatch,
    );
    expect(authenticator.authenticationCalls, 0);
  });

  test('does not persist until recovery is explicitly confirmed', () async {
    final repository = _MemoryEnrollmentRepository();
    final protector = _FakeKeyProtector();
    final publisher = _FakeManifestPublisher();
    final controller = buildController(
      repository: repository,
      protector: protector,
      publisher: publisher,
    );

    expect(
      await controller.prepareNewGroup(
        password: password,
        passwordConfirmation: password,
      ),
      isTrue,
    );
    expect(controller.state.value, SyncGroupEnrollmentState.recoveryReady);
    expect(controller.groupId.value, startsWith('group_'));
    expect(controller.recoveryKey.value, isNotEmpty);
    expect(repository.created, isNull);
    expect(protector.wrappedKey, hasLength(32));

    expect(
      await controller.confirmRecoverySaved(
        folderUri: 'content://tree/michifocus',
      ),
      isTrue,
    );
    expect(controller.state.value, SyncGroupEnrollmentState.enrolled);
    expect(controller.recoveryKey.value, isEmpty);
    expect(repository.created?.groupId, controller.groupId.value);
    expect(
      repository.created?.manifest.toJson().toString(),
      isNot(contains(password)),
    );
    expect(publisher.calls, 1);
    expect(
      controller.publicationState.value,
      SyncGroupPublicationState.published,
    );
    expect(controller.publishedManifestPath.value, contains('group'));
  });

  test(
    'cancellation deletes the provisional Android key and saves nothing',
    () async {
      final repository = _MemoryEnrollmentRepository();
      final protector = _FakeKeyProtector();
      final controller = buildController(
        repository: repository,
        protector: protector,
      );
      await controller.prepareNewGroup(
        password: password,
        passwordConfirmation: password,
      );
      final pendingGroupId = controller.groupId.value;

      await controller.cancelPendingEnrollment();

      expect(protector.deletedGroupIds, [pendingGroupId]);
      expect(repository.created, isNull);
      expect(controller.recoveryKey.value, isEmpty);
      expect(controller.state.value, SyncGroupEnrollmentState.none);
    },
  );

  test('authentication cancellation cannot produce a pending group', () async {
    final repository = _MemoryEnrollmentRepository();
    final controller = buildController(
      repository: repository,
      authenticator: _FakeAuthenticator(authenticationResult: false),
    );

    expect(
      await controller.prepareNewGroup(
        password: password,
        passwordConfirmation: password,
      ),
      isFalse,
    );
    expect(
      controller.failure.value,
      SyncGroupEnrollmentFailure.authenticationCancelled,
    );
    expect(controller.recoveryKey.value, isEmpty);
    expect(repository.created, isNull);
  });

  test('loads enrolled or rebind-required state from local evidence', () async {
    final enrollment = await _createdEnrollment();
    final enrolled = buildController(
      repository: _MemoryEnrollmentRepository(existing: enrollment),
    );
    await enrolled.load();
    expect(enrolled.state.value, SyncGroupEnrollmentState.enrolled);

    final missingKey = buildController(
      repository: _MemoryEnrollmentRepository(existing: enrollment),
      protector: _FakeKeyProtector(hasKeyResult: false),
    );
    await missingKey.load();
    expect(
      missingKey.state.value,
      SyncGroupEnrollmentState.rebindRequired,
    );
    expect(
      await missingKey.prepareNewGroup(
        password: password,
        passwordConfirmation: password,
      ),
      isFalse,
    );
    expect(
      missingKey.failure.value,
      SyncGroupEnrollmentFailure.alreadyEnrolled,
    );
  });

  test('keeps an enrolled group retryable when publication fails', () async {
    final publisher = _FakeManifestPublisher(shouldFail: true);
    final controller = buildController(publisher: publisher);
    await controller.prepareNewGroup(
      password: password,
      passwordConfirmation: password,
    );

    expect(
      await controller.confirmRecoverySaved(folderUri: 'content://tree/group'),
      isTrue,
    );
    expect(controller.state.value, SyncGroupEnrollmentState.enrolled);
    expect(
      controller.publicationState.value,
      SyncGroupPublicationState.failed,
    );

    publisher.shouldFail = false;
    expect(
      await controller.ensureManifestPublished('content://tree/group'),
      isTrue,
    );
    expect(publisher.calls, 2);
    expect(
      controller.publicationState.value,
      SyncGroupPublicationState.published,
    );
  });

  test(
    'discovers valid remote groups without changing local enrollment',
    () async {
      final discovery = _FakeManifestDiscovery();
      final repository = _MemoryEnrollmentRepository();
      final controller = buildController(
        repository: repository,
        discovery: discovery.call,
      );

      expect(
        await controller.discoverGroups('content://tree/michifocus'),
        isTrue,
      );
      expect(controller.discoveryState.value, SyncGroupDiscoveryState.complete);
      expect(controller.discoveredGroups.value, hasLength(1));
      expect(controller.rejectedManifestFiles.value, 2);
      expect(repository.created, isNull);
    },
  );

  test('joins an existing group with its password and keeps its ID', () async {
    final repository = _MemoryEnrollmentRepository();
    final protector = _FakeKeyProtector();
    final authenticator = _FakeAuthenticator();
    final controller = buildController(
      repository: repository,
      protector: protector,
      authenticator: authenticator,
    );
    final group = await _discoveredGroup();

    expect(
      await controller.joinExistingGroup(
        group: group,
        credential: password,
        useRecoveryKey: false,
      ),
      isTrue,
    );

    expect(repository.created?.groupId, group.manifest.groupId);
    expect(controller.groupId.value, group.manifest.groupId);
    expect(controller.state.value, SyncGroupEnrollmentState.enrolled);
    expect(
      controller.publicationState.value,
      SyncGroupPublicationState.published,
    );
    expect(controller.publishedManifestPath.value, group.relativePath);
    expect(
      repository.created?.bootstrapPreference,
      SyncGroupBootstrapPreference.restoreIntoEmpty,
    );
    expect(protector.wrappedKey, hasLength(32));
    expect(authenticator.authenticationCalls, 1);
  });

  test('joins an existing group with its independent recovery key', () async {
    final crypto = SyncGroupCrypto(
      parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
      random: Random(44),
    );
    final created = await crypto.createGroupKeys(
      groupId: 'group_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
      password: password,
    );
    final repository = _MemoryEnrollmentRepository();
    final controller = SyncGroupEnrollmentController(
      repository: repository,
      crypto: crypto,
      keyProtector: _FakeKeyProtector(),
      authenticator: _FakeAuthenticator(),
      localDataInspector: () async => const SyncLocalDataSummary.empty(),
    );

    expect(
      await controller.joinExistingGroup(
        group: DiscoveredSyncGroupManifest(
          relativePath: 'michifocus-${created.manifest.groupId}.v1.json',
          manifest: created.manifest,
        ),
        credential: created.recoveryKey,
        useRecoveryKey: true,
      ),
      isTrue,
    );
    expect(repository.created?.groupId, created.manifest.groupId);
  });

  test('wrong group credential never authenticates or persists', () async {
    final repository = _MemoryEnrollmentRepository();
    final authenticator = _FakeAuthenticator();
    final protector = _FakeKeyProtector();
    final controller = buildController(
      repository: repository,
      authenticator: authenticator,
      protector: protector,
    );

    expect(
      await controller.joinExistingGroup(
        group: await _discoveredGroup(),
        credential: 'this password is incorrect',
        useRecoveryKey: false,
      ),
      isFalse,
    );
    expect(
      controller.failure.value,
      SyncGroupEnrollmentFailure.invalidCredential,
    );
    expect(controller.state.value, SyncGroupEnrollmentState.none);
    expect(repository.created, isNull);
    expect(protector.wrappedKey, isNull);
    expect(authenticator.authenticationCalls, 0);
  });

  test('cancelled device authentication never completes a join', () async {
    final repository = _MemoryEnrollmentRepository();
    final protector = _FakeKeyProtector();
    final controller = buildController(
      repository: repository,
      protector: protector,
      authenticator: _FakeAuthenticator(authenticationResult: false),
    );

    expect(
      await controller.joinExistingGroup(
        group: await _discoveredGroup(),
        credential: password,
        useRecoveryKey: false,
      ),
      isFalse,
    );
    expect(
      controller.failure.value,
      SyncGroupEnrollmentFailure.authenticationCancelled,
    );
    expect(repository.created, isNull);
    expect(protector.wrappedKey, isNull);
    expect(controller.state.value, SyncGroupEnrollmentState.none);
  });

  test(
    'populated local data requires and persists an explicit choice',
    () async {
      final repository = _MemoryEnrollmentRepository();
      final authenticator = _FakeAuthenticator();
      final controller = buildController(
        repository: repository,
        authenticator: authenticator,
        localDataInspector: () async => const SyncLocalDataSummary(
          goals: 1,
          tasks: 2,
          calendarEvents: 0,
          focusSessions: 1,
          taskCompletionEvents: 0,
          routines: 1,
          routineRuns: 0,
        ),
      );
      final group = await _discoveredGroup();

      expect(
        await controller.joinExistingGroup(
          group: group,
          credential: password,
          useRecoveryKey: false,
        ),
        isFalse,
      );
      expect(
        controller.failure.value,
        SyncGroupEnrollmentFailure.bootstrapChoiceRequired,
      );
      expect(authenticator.authenticationCalls, 0);

      expect(
        await controller.joinExistingGroup(
          group: group,
          credential: password,
          useRecoveryKey: false,
          folderUri: 'content://tree/michifocus',
          selectedBootstrapPreference: SyncGroupBootstrapPreference.mergeLocal,
        ),
        isTrue,
      );
      expect(
        repository.created?.bootstrapPreference,
        SyncGroupBootstrapPreference.mergeLocal,
      );
      expect(repository.created?.recoverySnapshotPath, 'recovery.json');
    },
  );

  test(
    'an enrolled phone can add and persist its verified recovery copy',
    () async {
      final existing = await _createdEnrollment();
      final repository = _MemoryEnrollmentRepository(existing: existing);
      var snapshotCalls = 0;
      final controller = buildController(
        repository: repository,
        localDataInspector: () async => const SyncLocalDataSummary(
          goals: 0,
          tasks: 1,
          calendarEvents: 0,
          focusSessions: 0,
          taskCompletionEvents: 0,
          routines: 1,
          routineRuns: 0,
        ),
        recoverySnapshotService:
            ({required folderUri, required groupId, required clearKey}) async {
              snapshotCalls++;
              expect(folderUri, 'content://tree/michifocus');
              expect(groupId, existing.groupId);
              expect(clearKey, hasLength(32));
              return const SyncRecoverySnapshotPublication(
                snapshotId: 'snapshot_0123456789abcdef0123456789abcdef',
                relativePath: 'verified-recovery.json',
                atomicFinalization: true,
              );
            },
      );
      await controller.load();

      expect(
        await controller.ensureRecoverySnapshot('content://tree/michifocus'),
        isTrue,
      );
      expect(snapshotCalls, 1);
      expect(
        repository.created?.recoverySnapshotPath,
        'verified-recovery.json',
      );
      expect(controller.recoverySnapshotPath.value, 'verified-recovery.json');
      expect(controller.state.value, SyncGroupEnrollmentState.enrolled);
    },
  );

  test(
    'snapshot publication failure preserves enrollment and local data',
    () async {
      final existing = await _createdEnrollment();
      final repository = _MemoryEnrollmentRepository(existing: existing);
      final controller = buildController(
        repository: repository,
        localDataInspector: () async => const SyncLocalDataSummary(
          goals: 0,
          tasks: 1,
          calendarEvents: 0,
          focusSessions: 0,
          taskCompletionEvents: 0,
          routines: 0,
          routineRuns: 0,
        ),
        recoverySnapshotService:
            ({required folderUri, required groupId, required clearKey}) async =>
                throw const SyncRecoverySnapshotException(),
      );
      await controller.load();

      expect(
        await controller.ensureRecoverySnapshot('content://tree/michifocus'),
        isFalse,
      );
      expect(
        controller.failure.value,
        SyncGroupEnrollmentFailure.recoverySnapshotFailed,
      );
      expect(repository.created, isNull);
      expect(controller.groupId.value, existing.groupId);
      expect(controller.state.value, SyncGroupEnrollmentState.enrolled);
    },
  );

  test('authenticates and publishes pending encrypted changes', () async {
    final existing = await _createdEnrollment();
    final repository = _MemoryEnrollmentRepository(existing: existing);
    var calls = 0;
    List<int>? receivedKey;
    final controller = buildController(
      repository: repository,
      outboxPublicationService:
          ({
            required folderUri,
            required groupId,
            required installationId,
            required clearKey,
          }) async {
            calls++;
            receivedKey = clearKey;
            expect(folderUri, 'content://tree/michifocus');
            expect(groupId, existing.groupId);
            expect(installationId, _installationId);
            return const SyncOutboxPublicationReport(
              published: 3,
              failed: 0,
              remaining: 0,
            );
          },
    );
    await controller.load();

    expect(
      await controller.publishPendingChanges('content://tree/michifocus'),
      isTrue,
    );
    expect(calls, 1);
    expect(receivedKey, everyElement(0));
    expect(controller.publishedOperationCount.value, 3);
    expect(
      controller.outboxPublicationState.value,
      SyncOutboxPublicationState.complete,
    );
  });

  test(
    'queues existing data before publishing the first encrypted batch',
    () async {
      final existing = await _createdEnrollment();
      final repository = _MemoryEnrollmentRepository(existing: existing);
      var bootstrapFinished = false;
      final controller = buildController(
        repository: repository,
        initialBootstrapService:
            ({
              required groupId,
              required installationId,
              required protocolVersion,
            }) async {
              expect(groupId, existing.groupId);
              expect(installationId, _installationId);
              expect(protocolVersion, 1);
              bootstrapFinished = true;
              return const SyncInitialBootstrapReport(queued: 2, skipped: 1);
            },
        outboxPublicationService:
            ({
              required folderUri,
              required groupId,
              required installationId,
              required clearKey,
            }) async {
              expect(bootstrapFinished, isTrue);
              return const SyncOutboxPublicationReport(
                published: 2,
                failed: 0,
                remaining: 0,
              );
            },
      );
      await controller.load();

      expect(
        await controller.publishPendingChanges('content://tree/michifocus'),
        isTrue,
      );
      expect(controller.publishedOperationCount.value, 2);
    },
  );

  test('repairs local data on a phone previously marked as empty', () async {
    final base = await _createdEnrollment();
    final existing = SyncGroupEnrollment(
      manifest: base.manifest,
      deviceBoundDek: base.deviceBoundDek,
      source: SyncGroupEnrollmentSource.joinedExisting,
      bootstrapPreference: SyncGroupBootstrapPreference.restoreIntoEmpty,
    );
    var bootstrapCalls = 0;
    final controller = buildController(
      repository: _MemoryEnrollmentRepository(existing: existing),
      initialBootstrapService:
          ({
            required groupId,
            required installationId,
            required protocolVersion,
          }) async {
            bootstrapCalls++;
            return const SyncInitialBootstrapReport(queued: 3, skipped: 0);
          },
    );
    await controller.load();

    expect(
      await controller.publishPendingChanges('content://tree/michifocus'),
      isTrue,
    );
    expect(bootstrapCalls, 1);
  });

  test(
    'authenticates, applies received changes, and refreshes app data',
    () async {
      final existing = await _createdEnrollment();
      final repository = _MemoryEnrollmentRepository(existing: existing);
      List<int>? receivedKey;
      var refreshCalls = 0;
      final controller = buildController(
        repository: repository,
        incomingApplicationService:
            ({
              required folderUri,
              required groupId,
              required localInstallationId,
              required clearKey,
            }) async {
              expect(folderUri, 'content://tree/michifocus');
              expect(groupId, existing.groupId);
              expect(localInstallationId, _installationId);
              receivedKey = clearKey;
              return const SyncIncomingApplicationReport(
                applied: 4,
                duplicates: 2,
                conflicts: 1,
                deferred: 3,
                rejected: 1,
              );
            },
        refreshApplicationData: () async => refreshCalls++,
      );
      await controller.load();

      expect(
        await controller.processIncomingChanges('content://tree/michifocus'),
        isTrue,
      );
      expect(receivedKey, everyElement(0));
      expect(refreshCalls, 1);
      expect(controller.receivedOperationCount.value, 4);
      expect(controller.incomingConflictCount.value, 1);
      expect(controller.deferredOperationCount.value, 3);
      expect(controller.rejectedOperationCount.value, 1);
      expect(
        controller.incomingApplicationState.value,
        SyncIncomingApplicationState.complete,
      );
    },
  );

  test('failed persistence deletes the provisional device key', () async {
    final repository = _MemoryEnrollmentRepository(shouldFail: true);
    final protector = _FakeKeyProtector();
    final controller = buildController(
      repository: repository,
      protector: protector,
    );
    final group = await _discoveredGroup();

    expect(
      await controller.joinExistingGroup(
        group: group,
        credential: password,
        useRecoveryKey: false,
      ),
      isFalse,
    );
    expect(protector.deletedGroupIds, [group.manifest.groupId]);
    expect(controller.state.value, SyncGroupEnrollmentState.none);
  });
}

Future<DiscoveredSyncGroupManifest> _discoveredGroup() async {
  final enrollment = await _createdEnrollment();
  return DiscoveredSyncGroupManifest(
    relativePath: 'michifocus-${enrollment.groupId}.v1.json',
    manifest: enrollment.manifest,
  );
}

Future<SyncGroupEnrollment> _createdEnrollment() async {
  final crypto = SyncGroupCrypto(
    parameters: const SyncGroupCryptoParameters(memoryKiB: 8),
    random: Random(1),
  );
  final created = await crypto.createGroupKeys(
    groupId: 'group_0123456789abcdef0123456789abcdef',
    password: 'correct horse battery staple',
  );
  return SyncGroupEnrollment(
    manifest: created.manifest,
    deviceBoundDek: DeviceBoundKeyEnvelope(
      nonce: List<int>.filled(12, 1),
      cipherText: List<int>.filled(48, 2),
    ),
  );
}

class _MemoryEnrollmentRepository implements SyncGroupEnrollmentRepository {
  _MemoryEnrollmentRepository({this.existing, this.shouldFail = false});

  final SyncGroupEnrollment? existing;
  final bool shouldFail;
  SyncGroupEnrollment? created;

  @override
  Future<void> create(SyncGroupEnrollment enrollment) async {
    if (shouldFail) throw StateError('test persistence failure');
    created = enrollment;
  }

  @override
  Future<SyncGroupEnrollment?> load() async => existing;

  @override
  Future<void> update(SyncGroupEnrollment enrollment) async {
    created = enrollment;
  }
}

const _installationId = 'installation_0123456789abcdef0123456789abcdef';

class _FakeIdentityRepository implements DeviceIdentityRepository {
  @override
  Future<DeviceIdentity> load() async => const DeviceIdentity(
    installationId: _installationId,
    friendlyName: 'Test phone',
  );

  @override
  Future<void> save(DeviceIdentity identity) async {}
}

class _FakeAuthenticator implements LocalDeviceAuthenticator {
  _FakeAuthenticator({this.authenticationResult = true});

  final bool authenticationResult;
  int authenticationCalls = 0;

  @override
  Future<bool> authenticate() async {
    authenticationCalls++;
    return authenticationResult;
  }

  @override
  Future<bool> isAvailable() async => true;
}

class _FakeKeyProtector implements DeviceBoundKeyProtector {
  _FakeKeyProtector({this.hasKeyResult = true});

  final bool hasKeyResult;
  List<int>? wrappedKey;
  final List<String> deletedGroupIds = [];

  @override
  Future<void> delete(String groupId) async => deletedGroupIds.add(groupId);

  @override
  Future<bool> hasKey(String groupId) async => hasKeyResult;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<List<int>> unwrap({
    required String groupId,
    required DeviceBoundKeyEnvelope envelope,
  }) async => List<int>.unmodifiable(List<int>.filled(32, 4));

  @override
  Future<DeviceBoundKeyEnvelope> wrap({
    required String groupId,
    required List<int> clearKey,
  }) async {
    wrappedKey = List<int>.from(clearKey);
    return DeviceBoundKeyEnvelope(
      nonce: List<int>.filled(12, 5),
      cipherText: List<int>.filled(48, 6),
    );
  }
}

class _FakeManifestPublisher implements SyncGroupManifestPublisher {
  _FakeManifestPublisher({this.shouldFail = false});

  bool shouldFail;
  int calls = 0;

  @override
  String relativePathFor(String groupId) => 'michifocus-$groupId.v1.json';

  @override
  Future<SyncGroupManifestPublication> publish({
    required String folderUri,
    required SyncGroupKeyManifest manifest,
  }) async {
    calls++;
    if (shouldFail) {
      throw const SyncGroupManifestFolderUnavailableException();
    }
    return SyncGroupManifestPublication(
      relativePath: relativePathFor(manifest.groupId),
      atomicFinalization: true,
    );
  }
}

class _FakeManifestDiscovery {
  Future<SyncGroupManifestDiscoveryResult> call({
    required String folderUri,
  }) async {
    final enrollment = await _createdEnrollment();
    return SyncGroupManifestDiscoveryResult(
      groups: [
        DiscoveredSyncGroupManifest(
          relativePath: 'michifocus-${enrollment.groupId}.v1.json',
          manifest: enrollment.manifest,
        ),
      ],
      rejectedFiles: 2,
    );
  }
}
