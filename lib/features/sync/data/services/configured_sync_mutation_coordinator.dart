import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_storage_config_repository.dart';

class ConfiguredSyncMutationCoordinator {
  ConfiguredSyncMutationCoordinator({
    required SyncStorageConfigRepository storageRepository,
    required SyncGroupEnrollmentRepository enrollmentRepository,
    required DeviceIdentityRepository identityRepository,
    required DriftSyncExchangeRepository exchangeRepository,
    required SecureSyncIdGenerator idGenerator,
    DateTime Function()? clock,
  }) : _storageRepository = storageRepository,
       _enrollmentRepository = enrollmentRepository,
       _identityRepository = identityRepository,
       _exchangeRepository = exchangeRepository,
       _idGenerator = idGenerator,
       _clock = clock ?? DateTime.now;

  final SyncStorageConfigRepository _storageRepository;
  final SyncGroupEnrollmentRepository _enrollmentRepository;
  final DeviceIdentityRepository _identityRepository;
  final DriftSyncExchangeRepository _exchangeRepository;
  final SecureSyncIdGenerator _idGenerator;
  final DateTime Function() _clock;

  Future<T> call<T>({
    required String entityType,
    required String entityId,
    required String operationKind,
    required Map<String, Object?> changedFields,
    required Future<T> Function() mutate,
  }) async {
    final storage = await _storageRepository.load();
    if (storage.mode != SyncStorageMode.multipleDevices) return mutate();
    final enrollment = await _enrollmentRepository.load();
    final identity = await _identityRepository.load();
    if (enrollment == null || !identity.isInitialized) return mutate();

    final now = _clock().toUtc();
    await _exchangeRepository.initializeLocalState(
      groupId: enrollment.groupId,
      installationId: identity.installationId,
      protocolVersion: enrollment.manifest.protocolVersion,
      now: now,
    );
    late T result;
    await _exchangeRepository.commitLocalMutation(
      groupId: enrollment.groupId,
      installationId: identity.installationId,
      entityType: entityType,
      entityId: entityId,
      now: now,
      buildOperation: (counter, parentVersion) async {
        final operation = SyncOperation(
          groupId: enrollment.groupId,
          operationId: _idGenerator.create('operation'),
          originDeviceId: identity.installationId,
          originCounter: counter,
          entityType: entityType,
          entityId: entityId,
          parentVersion: parentVersion,
          changedFields: changedFields,
          operationKind: operationKind,
          createdAtEpochMillis: now.millisecondsSinceEpoch,
        );
        final digest = await Sha256().hash(operation.canonicalBytes());
        return LocalSyncOperationDraft(
          operationId: operation.operationId,
          entityType: entityType,
          entityId: entityId,
          parentVersionJson: _canonicalJson(parentVersion),
          changedFieldsJson: _canonicalJson(changedFields),
          operationKind: operationKind,
          payloadSha256: digest.bytes
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join(),
        );
      },
      mutate: (_) async {
        result = await mutate();
      },
    );
    return result;
  }

  String _canonicalJson(Map<String, Object?> source) {
    final keys = source.keys.toList()..sort();
    return jsonEncode({for (final key in keys) key: source[key]});
  }
}
