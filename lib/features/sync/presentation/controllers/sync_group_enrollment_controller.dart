import 'dart:developer' as developer;

import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
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
import 'package:signals_flutter/signals_flutter.dart';

enum SyncGroupEnrollmentState {
  none,
  preparing,
  joining,
  recoveryReady,
  saving,
  enrolled,
  rebindRequired,
  failed,
}

enum SyncGroupEnrollmentFailure {
  passwordTooShort,
  passwordsDoNotMatch,
  deviceSecurityUnavailable,
  authenticationCancelled,
  keyInvalidated,
  integrityFailure,
  invalidCredential,
  localDataCheckFailed,
  bootstrapChoiceRequired,
  recoverySnapshotFailed,
  alreadyEnrolled,
  unexpected,
}

enum SyncGroupPublicationState {
  notApplicable,
  pending,
  publishing,
  published,
  failed,
  conflict,
}

enum SyncGroupDiscoveryState { idle, searching, complete, failed }

enum SyncLocalDataInspectionState {
  notChecked,
  checking,
  empty,
  populated,
  failed,
}

enum SyncRecoverySnapshotState { notRequired, pending, creating, ready, failed }

enum SyncOutboxPublicationState { idle, publishing, complete, failed }

enum SyncIncomingApplicationState { idle, processing, complete, failed }

class SyncGroupEnrollmentController {
  SyncGroupEnrollmentController({
    SyncGroupEnrollmentRepository? repository,
    SyncGroupCrypto? crypto,
    DeviceBoundKeyProtector? keyProtector,
    LocalDeviceAuthenticator? authenticator,
    SecureSyncIdGenerator? idGenerator,
    SyncGroupManifestDiscovery? manifestDiscovery,
    SyncGroupManifestPublisher? manifestPublisher,
    SyncLocalDataInspector? localDataInspector,
    SyncRecoverySnapshotService? recoverySnapshotService,
    SyncOutboxPublicationService? outboxPublicationService,
    SyncIncomingApplicationService? incomingApplicationService,
    SyncInitialBootstrapService? initialBootstrapService,
    DeviceIdentityRepository? identityRepository,
    Future<void> Function()? refreshApplicationData,
  }) : _repository = repository,
       _crypto = crypto ?? SyncGroupCrypto(),
       _keyProtector = keyProtector,
       _authenticator = authenticator,
       _idGenerator = idGenerator ?? SecureSyncIdGenerator(),
       _manifestDiscovery = manifestDiscovery,
       _manifestPublisher = manifestPublisher,
       _localDataInspector = localDataInspector,
       _recoverySnapshotService = recoverySnapshotService,
       _outboxPublicationService = outboxPublicationService,
       _incomingApplicationService = incomingApplicationService,
       _initialBootstrapService = initialBootstrapService,
       _identityRepository = identityRepository,
       _refreshApplicationData = refreshApplicationData;

  final SyncGroupEnrollmentRepository? _repository;
  final SyncGroupCrypto _crypto;
  final DeviceBoundKeyProtector? _keyProtector;
  final LocalDeviceAuthenticator? _authenticator;
  final SecureSyncIdGenerator _idGenerator;
  final SyncGroupManifestDiscovery? _manifestDiscovery;
  final SyncGroupManifestPublisher? _manifestPublisher;
  final SyncLocalDataInspector? _localDataInspector;
  final SyncRecoverySnapshotService? _recoverySnapshotService;
  final SyncOutboxPublicationService? _outboxPublicationService;
  final SyncIncomingApplicationService? _incomingApplicationService;
  final SyncInitialBootstrapService? _initialBootstrapService;
  final DeviceIdentityRepository? _identityRepository;
  final Future<void> Function()? _refreshApplicationData;

  SyncGroupEnrollment? _pendingEnrollment;
  SyncGroupEnrollment? _enrollment;

  final FlutterSignal<SyncGroupEnrollmentState> state = signal(
    SyncGroupEnrollmentState.none,
  );
  final FlutterSignal<SyncGroupEnrollmentFailure?> failure = signal(null);
  final FlutterSignal<String> recoveryKey = signal('');
  final FlutterSignal<String> groupId = signal('');
  final FlutterSignal<SyncGroupPublicationState> publicationState = signal(
    SyncGroupPublicationState.notApplicable,
  );
  final FlutterSignal<String> publishedManifestPath = signal('');
  final FlutterSignal<SyncGroupDiscoveryState> discoveryState = signal(
    SyncGroupDiscoveryState.idle,
  );
  final FlutterSignal<List<DiscoveredSyncGroupManifest>> discoveredGroups =
      signal(const []);
  final FlutterSignal<int> rejectedManifestFiles = signal(0);
  final FlutterSignal<SyncLocalDataInspectionState> localDataState = signal(
    SyncLocalDataInspectionState.notChecked,
  );
  final FlutterSignal<SyncLocalDataSummary> localDataSummary = signal(
    const SyncLocalDataSummary.empty(),
  );
  final FlutterSignal<SyncGroupEnrollmentSource?> enrollmentSource = signal(
    null,
  );
  final FlutterSignal<SyncGroupBootstrapPreference?> bootstrapPreference =
      signal(null);
  final FlutterSignal<String> recoverySnapshotPath = signal('');
  final FlutterSignal<SyncRecoverySnapshotState> recoverySnapshotState = signal(
    SyncRecoverySnapshotState.notRequired,
  );
  final FlutterSignal<SyncOutboxPublicationState> outboxPublicationState =
      signal(SyncOutboxPublicationState.idle);
  final FlutterSignal<int> publishedOperationCount = signal(0);
  final FlutterSignal<int> remainingOperationCount = signal(0);
  final FlutterSignal<SyncIncomingApplicationState> incomingApplicationState =
      signal(SyncIncomingApplicationState.idle);
  final FlutterSignal<int> receivedOperationCount = signal(0);
  final FlutterSignal<int> incomingConflictCount = signal(0);
  final FlutterSignal<int> deferredOperationCount = signal(0);
  final FlutterSignal<int> rejectedOperationCount = signal(0);

  bool get isBusy =>
      state.value == SyncGroupEnrollmentState.preparing ||
      state.value == SyncGroupEnrollmentState.joining ||
      state.value == SyncGroupEnrollmentState.saving ||
      discoveryState.value == SyncGroupDiscoveryState.searching ||
      localDataState.value == SyncLocalDataInspectionState.checking ||
      recoverySnapshotState.value == SyncRecoverySnapshotState.creating ||
      outboxPublicationState.value == SyncOutboxPublicationState.publishing ||
      incomingApplicationState.value == SyncIncomingApplicationState.processing;

  Future<void> load() async {
    final stored = await _repository?.load();
    if (stored == null) return;
    _enrollment = stored;
    groupId.value = stored.groupId;
    enrollmentSource.value = stored.source;
    bootstrapPreference.value = stored.bootstrapPreference;
    recoverySnapshotPath.value = stored.recoverySnapshotPath;
    publicationState.value = SyncGroupPublicationState.pending;
    try {
      state.value = (await _keyProtector?.hasKey(stored.groupId) ?? false)
          ? SyncGroupEnrollmentState.enrolled
          : SyncGroupEnrollmentState.rebindRequired;
    } on DeviceBoundKeyException {
      state.value = SyncGroupEnrollmentState.rebindRequired;
    }
    await assessLocalData();
    recoverySnapshotState.value = stored.recoverySnapshotPath.isNotEmpty
        ? SyncRecoverySnapshotState.ready
        : localDataSummary.value.hasUserData
        ? SyncRecoverySnapshotState.pending
        : SyncRecoverySnapshotState.notRequired;
  }

  Future<bool> prepareNewGroup({
    required String password,
    required String passwordConfirmation,
  }) async {
    if (isBusy || _enrollment != null || _pendingEnrollment != null) {
      failure.value = SyncGroupEnrollmentFailure.alreadyEnrolled;
      return false;
    }
    if (password.length < SyncGroupCrypto.minimumPasswordLength) {
      failure.value = SyncGroupEnrollmentFailure.passwordTooShort;
      return false;
    }
    if (password != passwordConfirmation) {
      failure.value = SyncGroupEnrollmentFailure.passwordsDoNotMatch;
      return false;
    }

    state.value = SyncGroupEnrollmentState.preparing;
    failure.value = null;
    final nextGroupId = _idGenerator.create('group');
    var keyMayExist = false;
    try {
      final authenticator = _authenticator;
      final keyProtector = _keyProtector;
      if (authenticator == null ||
          keyProtector == null ||
          !await authenticator.isAvailable() ||
          !await keyProtector.isAvailable()) {
        throw const DeviceKeyUnavailableException();
      }

      final created = await _crypto.createGroupKeys(
        groupId: nextGroupId,
        password: password,
      );
      if (!await authenticator.authenticate()) {
        failure.value = SyncGroupEnrollmentFailure.authenticationCancelled;
        state.value = SyncGroupEnrollmentState.none;
        return false;
      }

      final clearKey = List<int>.from(
        await (await _crypto.unlockWithPassword(
          created.manifest,
          password,
        )).extractBytes(),
      );
      try {
        keyMayExist = true;
        final deviceEnvelope = await keyProtector.wrap(
          groupId: nextGroupId,
          clearKey: clearKey,
        );
        _pendingEnrollment = SyncGroupEnrollment(
          manifest: created.manifest,
          deviceBoundDek: deviceEnvelope,
        );
      } finally {
        _erase(clearKey);
      }

      batch(() {
        groupId.value = nextGroupId;
        recoveryKey.value = created.recoveryKey;
        state.value = SyncGroupEnrollmentState.recoveryReady;
      });
      return true;
    } on DeviceAuthenticationRequiredException {
      failure.value = SyncGroupEnrollmentFailure.authenticationCancelled;
    } on DeviceKeyInvalidatedException {
      failure.value = SyncGroupEnrollmentFailure.keyInvalidated;
    } on DeviceKeyIntegrityException {
      failure.value = SyncGroupEnrollmentFailure.integrityFailure;
    } on DeviceKeyUnavailableException {
      failure.value = SyncGroupEnrollmentFailure.deviceSecurityUnavailable;
    } on Object {
      failure.value = SyncGroupEnrollmentFailure.unexpected;
    }

    if (keyMayExist) await _deleteProvisionalKey(nextGroupId);
    state.value = SyncGroupEnrollmentState.failed;
    return false;
  }

  Future<bool> confirmRecoverySaved({String folderUri = ''}) async {
    final pending = _pendingEnrollment;
    if (pending == null ||
        state.value != SyncGroupEnrollmentState.recoveryReady) {
      return false;
    }

    state.value = SyncGroupEnrollmentState.saving;
    try {
      final repository = _repository;
      if (repository == null) {
        throw StateError('Synchronization group storage is unavailable.');
      }
      await repository.create(pending);
      _pendingEnrollment = null;
      _enrollment = pending;
      recoveryKey.value = '';
      enrollmentSource.value = pending.source;
      bootstrapPreference.value = pending.bootstrapPreference;
      state.value = SyncGroupEnrollmentState.enrolled;
      publicationState.value = SyncGroupPublicationState.pending;
      if (folderUri.trim().isNotEmpty) {
        await ensureManifestPublished(folderUri);
      }
      return true;
    } on SyncGroupAlreadyExistsException {
      failure.value = SyncGroupEnrollmentFailure.alreadyEnrolled;
    } on Object {
      failure.value = SyncGroupEnrollmentFailure.unexpected;
    }
    state.value = SyncGroupEnrollmentState.recoveryReady;
    return false;
  }

  Future<bool> ensureManifestPublished(String folderUri) async {
    final enrollment = _enrollment;
    final publisher = _manifestPublisher;
    if (enrollment == null || folderUri.trim().isEmpty || publisher == null) {
      publicationState.value = SyncGroupPublicationState.failed;
      return false;
    }
    if (publicationState.value == SyncGroupPublicationState.publishing) {
      return false;
    }

    publicationState.value = SyncGroupPublicationState.publishing;
    try {
      final publication = await publisher.publish(
        folderUri: folderUri,
        manifest: enrollment.manifest,
      );
      publishedManifestPath.value = publication.relativePath;
      publicationState.value = SyncGroupPublicationState.published;
      return true;
    } on SyncGroupManifestConflictException {
      publicationState.value = SyncGroupPublicationState.conflict;
    } on SyncGroupManifestPublicationException {
      publicationState.value = SyncGroupPublicationState.failed;
    } on Object {
      publicationState.value = SyncGroupPublicationState.failed;
    }
    return false;
  }

  Future<bool> ensureRecoverySnapshot(String folderUri) async {
    final enrollment = _enrollment;
    final repository = _repository;
    final service = _recoverySnapshotService;
    final authenticator = _authenticator;
    final keyProtector = _keyProtector;
    if (enrollment == null ||
        repository == null ||
        service == null ||
        authenticator == null ||
        keyProtector == null ||
        folderUri.trim().isEmpty ||
        isBusy) {
      failure.value = SyncGroupEnrollmentFailure.recoverySnapshotFailed;
      return false;
    }
    if (enrollment.recoverySnapshotPath.isNotEmpty) return true;
    if (localDataState.value != SyncLocalDataInspectionState.empty &&
        localDataState.value != SyncLocalDataInspectionState.populated) {
      if (!await assessLocalData()) {
        failure.value = SyncGroupEnrollmentFailure.localDataCheckFailed;
        return false;
      }
    }
    if (!localDataSummary.value.hasUserData) return true;

    recoverySnapshotState.value = SyncRecoverySnapshotState.creating;
    failure.value = null;
    var clearKey = <int>[];
    try {
      if (!await authenticator.isAvailable() ||
          !await keyProtector.isAvailable()) {
        throw const DeviceKeyUnavailableException();
      }
      if (!await authenticator.authenticate()) {
        throw const DeviceAuthenticationRequiredException();
      }
      clearKey = List<int>.from(
        await keyProtector.unwrap(
          groupId: enrollment.groupId,
          envelope: enrollment.deviceBoundDek,
        ),
      );
      final publication = await service(
        folderUri: folderUri,
        groupId: enrollment.groupId,
        clearKey: clearKey,
      );
      final updated = SyncGroupEnrollment(
        manifest: enrollment.manifest,
        deviceBoundDek: enrollment.deviceBoundDek,
        source: enrollment.source,
        bootstrapPreference: enrollment.bootstrapPreference,
        recoverySnapshotPath: publication.relativePath,
      );
      await repository.update(updated);
      _enrollment = updated;
      recoverySnapshotPath.value = updated.recoverySnapshotPath;
      recoverySnapshotState.value = SyncRecoverySnapshotState.ready;
      return true;
    } on DeviceAuthenticationRequiredException {
      failure.value = SyncGroupEnrollmentFailure.authenticationCancelled;
    } on DeviceKeyInvalidatedException {
      failure.value = SyncGroupEnrollmentFailure.keyInvalidated;
    } on DeviceKeyIntegrityException {
      failure.value = SyncGroupEnrollmentFailure.integrityFailure;
    } on DeviceKeyUnavailableException {
      failure.value = SyncGroupEnrollmentFailure.deviceSecurityUnavailable;
    } on SyncRecoverySnapshotException {
      failure.value = SyncGroupEnrollmentFailure.recoverySnapshotFailed;
    } on Object {
      failure.value = SyncGroupEnrollmentFailure.recoverySnapshotFailed;
    } finally {
      _erase(clearKey);
    }
    recoverySnapshotState.value = SyncRecoverySnapshotState.failed;
    return false;
  }

  Future<bool> publishPendingChanges(String folderUri) async {
    final enrollment = _enrollment;
    final service = _outboxPublicationService;
    final identityRepository = _identityRepository;
    final authenticator = _authenticator;
    final keyProtector = _keyProtector;
    if (enrollment == null ||
        service == null ||
        identityRepository == null ||
        authenticator == null ||
        keyProtector == null ||
        folderUri.trim().isEmpty ||
        isBusy) {
      outboxPublicationState.value = SyncOutboxPublicationState.failed;
      return false;
    }

    outboxPublicationState.value = SyncOutboxPublicationState.publishing;
    failure.value = null;
    var clearKey = <int>[];
    try {
      final identity = await identityRepository.load();
      if (!identity.isInitialized ||
          !await authenticator.isAvailable() ||
          !await keyProtector.isAvailable()) {
        throw const DeviceKeyUnavailableException();
      }
      if (!await authenticator.authenticate()) {
        throw const DeviceAuthenticationRequiredException();
      }
      clearKey = List<int>.from(
        await keyProtector.unwrap(
          groupId: enrollment.groupId,
          envelope: enrollment.deviceBoundDek,
        ),
      );
      final bootstrap = _initialBootstrapService;
      if (bootstrap != null &&
          enrollment.bootstrapPreference !=
              SyncGroupBootstrapPreference.replaceLocal) {
        await bootstrap(
          groupId: enrollment.groupId,
          installationId: identity.installationId,
          protocolVersion: enrollment.manifest.protocolVersion,
        );
      }
      final report = await service(
        folderUri: folderUri,
        groupId: enrollment.groupId,
        installationId: identity.installationId,
        clearKey: clearKey,
      );
      publishedOperationCount.value = report.published;
      remainingOperationCount.value = report.remaining;
      outboxPublicationState.value = report.failed == 0
          ? SyncOutboxPublicationState.complete
          : SyncOutboxPublicationState.failed;
      return report.failed == 0;
    } on DeviceAuthenticationRequiredException {
      failure.value = SyncGroupEnrollmentFailure.authenticationCancelled;
    } on DeviceKeyInvalidatedException {
      failure.value = SyncGroupEnrollmentFailure.keyInvalidated;
    } on DeviceKeyIntegrityException {
      failure.value = SyncGroupEnrollmentFailure.integrityFailure;
    } on DeviceKeyUnavailableException {
      failure.value = SyncGroupEnrollmentFailure.deviceSecurityUnavailable;
    } on Object catch (error, stackTrace) {
      developer.log(
        'No se pudieron preparar los cambios pendientes: $error',
        name: 'MichiFocusSync',
        error: error,
        stackTrace: stackTrace,
      );
      failure.value = SyncGroupEnrollmentFailure.unexpected;
    } finally {
      _erase(clearKey);
    }
    outboxPublicationState.value = SyncOutboxPublicationState.failed;
    return false;
  }

  Future<bool> processIncomingChanges(String folderUri) async {
    final enrollment = _enrollment;
    final service = _incomingApplicationService;
    final identityRepository = _identityRepository;
    final authenticator = _authenticator;
    final keyProtector = _keyProtector;
    if (enrollment == null ||
        service == null ||
        identityRepository == null ||
        authenticator == null ||
        keyProtector == null ||
        folderUri.trim().isEmpty ||
        isBusy) {
      incomingApplicationState.value = SyncIncomingApplicationState.failed;
      return false;
    }

    if (localDataSummary.value.hasUserData &&
        enrollment.recoverySnapshotPath.isEmpty) {
      final protected = await ensureRecoverySnapshot(folderUri);
      if (!protected) {
        incomingApplicationState.value = SyncIncomingApplicationState.failed;
        return false;
      }
    }

    incomingApplicationState.value = SyncIncomingApplicationState.processing;
    failure.value = null;
    var clearKey = <int>[];
    try {
      final identity = await identityRepository.load();
      if (!identity.isInitialized ||
          !await authenticator.isAvailable() ||
          !await keyProtector.isAvailable()) {
        throw const DeviceKeyUnavailableException();
      }
      if (!await authenticator.authenticate()) {
        throw const DeviceAuthenticationRequiredException();
      }
      clearKey = List<int>.from(
        await keyProtector.unwrap(
          groupId: enrollment.groupId,
          envelope: enrollment.deviceBoundDek,
        ),
      );
      final report = await service(
        folderUri: folderUri,
        groupId: enrollment.groupId,
        localInstallationId: identity.installationId,
        clearKey: clearKey,
      );
      receivedOperationCount.value = report.applied;
      incomingConflictCount.value = report.conflicts;
      deferredOperationCount.value = report.deferred;
      rejectedOperationCount.value = report.rejected;
      if (report.applied > 0) await _refreshApplicationData?.call();
      incomingApplicationState.value = SyncIncomingApplicationState.complete;
      return true;
    } on DeviceAuthenticationRequiredException {
      failure.value = SyncGroupEnrollmentFailure.authenticationCancelled;
    } on DeviceKeyInvalidatedException {
      failure.value = SyncGroupEnrollmentFailure.keyInvalidated;
    } on DeviceKeyIntegrityException {
      failure.value = SyncGroupEnrollmentFailure.integrityFailure;
    } on DeviceKeyUnavailableException {
      failure.value = SyncGroupEnrollmentFailure.deviceSecurityUnavailable;
    } on Object {
      failure.value = SyncGroupEnrollmentFailure.unexpected;
    } finally {
      _erase(clearKey);
    }
    incomingApplicationState.value = SyncIncomingApplicationState.failed;
    return false;
  }

  Future<bool> discoverGroups(String folderUri) async {
    if (_enrollment != null ||
        _pendingEnrollment != null ||
        discoveryState.value == SyncGroupDiscoveryState.searching) {
      return false;
    }
    final discovery = _manifestDiscovery;
    if (discovery == null || folderUri.trim().isEmpty) {
      discoveryState.value = SyncGroupDiscoveryState.failed;
      return false;
    }

    discoveryState.value = SyncGroupDiscoveryState.searching;
    try {
      final result = await discovery(folderUri: folderUri);
      batch(() {
        discoveredGroups.value = result.groups;
        rejectedManifestFiles.value = result.rejectedFiles;
        discoveryState.value = SyncGroupDiscoveryState.complete;
      });
      return true;
    } on Object {
      batch(() {
        discoveredGroups.value = const [];
        rejectedManifestFiles.value = 0;
        discoveryState.value = SyncGroupDiscoveryState.failed;
      });
      return false;
    }
  }

  Future<bool> assessLocalData() async {
    final inspector = _localDataInspector;
    if (inspector == null ||
        localDataState.value == SyncLocalDataInspectionState.checking) {
      localDataState.value = SyncLocalDataInspectionState.failed;
      return false;
    }

    localDataState.value = SyncLocalDataInspectionState.checking;
    try {
      final summary = await inspector();
      batch(() {
        localDataSummary.value = summary;
        localDataState.value = summary.hasUserData
            ? SyncLocalDataInspectionState.populated
            : SyncLocalDataInspectionState.empty;
      });
      return true;
    } on Object {
      batch(() {
        localDataSummary.value = const SyncLocalDataSummary.empty();
        localDataState.value = SyncLocalDataInspectionState.failed;
      });
      return false;
    }
  }

  Future<bool> joinExistingGroup({
    required DiscoveredSyncGroupManifest group,
    required String credential,
    required bool useRecoveryKey,
    String folderUri = '',
    SyncGroupBootstrapPreference? selectedBootstrapPreference,
  }) async {
    if (isBusy || _enrollment != null || _pendingEnrollment != null) {
      failure.value = SyncGroupEnrollmentFailure.alreadyEnrolled;
      return false;
    }
    if (credential.trim().isEmpty) {
      failure.value = SyncGroupEnrollmentFailure.invalidCredential;
      return false;
    }
    if (localDataState.value != SyncLocalDataInspectionState.empty &&
        localDataState.value != SyncLocalDataInspectionState.populated) {
      if (!await assessLocalData()) {
        failure.value = SyncGroupEnrollmentFailure.localDataCheckFailed;
        return false;
      }
    }
    final hasLocalData = localDataSummary.value.hasUserData;
    if (hasLocalData &&
        selectedBootstrapPreference !=
            SyncGroupBootstrapPreference.mergeLocal &&
        selectedBootstrapPreference !=
            SyncGroupBootstrapPreference.replaceLocal) {
      failure.value = SyncGroupEnrollmentFailure.bootstrapChoiceRequired;
      return false;
    }
    final effectiveBootstrapPreference = hasLocalData
        ? selectedBootstrapPreference
        : SyncGroupBootstrapPreference.restoreIntoEmpty;

    state.value = SyncGroupEnrollmentState.joining;
    failure.value = null;
    var deleteProvisionalKey = false;
    List<int>? clearKey;
    try {
      final authenticator = _authenticator;
      final keyProtector = _keyProtector;
      final repository = _repository;
      if (authenticator == null ||
          keyProtector == null ||
          repository == null ||
          !await authenticator.isAvailable() ||
          !await keyProtector.isAvailable()) {
        throw const DeviceKeyUnavailableException();
      }

      clearKey = List<int>.from(
        await _crypto.unlockBytesForEnrollment(
          manifest: group.manifest,
          credential: credential,
          useRecoveryKey: useRecoveryKey,
        ),
      );
      if (!await authenticator.authenticate()) {
        failure.value = SyncGroupEnrollmentFailure.authenticationCancelled;
        state.value = SyncGroupEnrollmentState.none;
        return false;
      }

      var snapshotPath = '';
      if (hasLocalData) {
        final snapshotService = _recoverySnapshotService;
        if (snapshotService == null || folderUri.trim().isEmpty) {
          throw const SyncRecoverySnapshotException();
        }
        final snapshot = await snapshotService(
          folderUri: folderUri,
          groupId: group.manifest.groupId,
          clearKey: clearKey,
        );
        snapshotPath = snapshot.relativePath;
      }

      deleteProvisionalKey = true;
      final deviceEnvelope = await keyProtector.wrap(
        groupId: group.manifest.groupId,
        clearKey: clearKey,
      );
      final enrollment = SyncGroupEnrollment(
        manifest: group.manifest,
        deviceBoundDek: deviceEnvelope,
        source: SyncGroupEnrollmentSource.joinedExisting,
        bootstrapPreference: effectiveBootstrapPreference,
        recoverySnapshotPath: snapshotPath,
      );
      await repository.create(enrollment);
      deleteProvisionalKey = false;
      _enrollment = enrollment;
      batch(() {
        groupId.value = enrollment.groupId;
        publishedManifestPath.value = group.relativePath;
        publicationState.value = SyncGroupPublicationState.published;
        discoveredGroups.value = const [];
        rejectedManifestFiles.value = 0;
        discoveryState.value = SyncGroupDiscoveryState.idle;
        enrollmentSource.value = enrollment.source;
        bootstrapPreference.value = enrollment.bootstrapPreference;
        recoverySnapshotPath.value = enrollment.recoverySnapshotPath;
        recoverySnapshotState.value = snapshotPath.isEmpty
            ? SyncRecoverySnapshotState.notRequired
            : SyncRecoverySnapshotState.ready;
        state.value = SyncGroupEnrollmentState.enrolled;
      });
      return true;
    } on SyncGroupCredentialRejectedException {
      failure.value = SyncGroupEnrollmentFailure.invalidCredential;
    } on SyncRecoverySnapshotException {
      failure.value = SyncGroupEnrollmentFailure.recoverySnapshotFailed;
    } on SyncGroupAlreadyExistsException {
      deleteProvisionalKey = false;
      failure.value = SyncGroupEnrollmentFailure.alreadyEnrolled;
    } on DeviceAuthenticationRequiredException {
      failure.value = SyncGroupEnrollmentFailure.authenticationCancelled;
    } on DeviceKeyInvalidatedException {
      failure.value = SyncGroupEnrollmentFailure.keyInvalidated;
    } on DeviceKeyIntegrityException {
      failure.value = SyncGroupEnrollmentFailure.integrityFailure;
    } on DeviceKeyUnavailableException {
      failure.value = SyncGroupEnrollmentFailure.deviceSecurityUnavailable;
    } on Object {
      failure.value = SyncGroupEnrollmentFailure.unexpected;
    } finally {
      if (clearKey != null) _erase(clearKey);
      if (deleteProvisionalKey) {
        await _deleteProvisionalKey(group.manifest.groupId);
      }
    }
    state.value = SyncGroupEnrollmentState.none;
    return false;
  }

  Future<void> cancelPendingEnrollment() async {
    final pending = _pendingEnrollment;
    _pendingEnrollment = null;
    recoveryKey.value = '';
    groupId.value = '';
    publicationState.value = SyncGroupPublicationState.notApplicable;
    publishedManifestPath.value = '';
    failure.value = null;
    state.value = SyncGroupEnrollmentState.none;
    if (pending != null) await _deleteProvisionalKey(pending.groupId);
  }

  Future<void> _deleteProvisionalKey(String targetGroupId) async {
    try {
      await _keyProtector?.delete(targetGroupId);
    } on DeviceBoundKeyException {
      // The group was never persisted, so an unreachable alias has no authority.
    }
  }

  void _erase(List<int> bytes) {
    for (var index = 0; index < bytes.length; index++) {
      bytes[index] = 0;
    }
  }
}
