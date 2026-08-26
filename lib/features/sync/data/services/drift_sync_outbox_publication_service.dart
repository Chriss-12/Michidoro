import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cryptography/cryptography.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_outbox_publication_service.dart';

class DriftSyncOutboxPublicationService {
  DriftSyncOutboxPublicationService({
    required DriftSyncExchangeRepository repository,
    required SyncGroupCrypto crypto,
    required SyncOperationPublisher publisher,
    DateTime Function()? clock,
  }) : _repository = repository,
       _crypto = crypto,
       _publisher = publisher,
       _clock = clock ?? DateTime.now;

  final DriftSyncExchangeRepository _repository;
  final SyncGroupCrypto _crypto;
  final SyncOperationPublisher _publisher;
  final DateTime Function() _clock;

  Future<SyncOutboxPublicationReport> call({
    required String folderUri,
    required String groupId,
    required String installationId,
    required List<int> clearKey,
  }) async {
    if (clearKey.length != 32) {
      throw const FormatException('Invalid group data key.');
    }
    final pending = await _repository.pendingOutbox(
      groupId: groupId,
      originDeviceId: installationId,
    );
    var published = 0;
    var failed = 0;
    for (final record in pending) {
      try {
        await _repository.markPublicationAttempt(record.operationId);
        if (record.protocolVersion != 1 ||
            record.groupId != groupId ||
            record.originDeviceId != installationId) {
          throw const FormatException('Outbox identity is invalid.');
        }
        final storedOperation = SyncOperation(
          groupId: record.groupId,
          operationId: record.operationId,
          originDeviceId: record.originDeviceId,
          originCounter: record.originCounter,
          entityType: record.entityType,
          entityId: record.entityId,
          parentVersion: _jsonObject(record.parentVersionJson),
          changedFields: _jsonObject(record.changedFieldsJson),
          operationKind: record.operationKind,
          createdAtEpochMillis: record.createdAt.toUtc().millisecondsSinceEpoch,
          originDeviceName: record.originDeviceName,
          entitySnapshot: record.entitySnapshotJson == null
              ? const {}
              : _jsonObject(record.entitySnapshotJson!),
        );
        final operation = await _operationMatchingDigest(
          storedOperation,
          record.payloadSha256,
        );
        final encrypted = await _crypto.encryptOperation(
          operation: operation,
          clearKey: clearKey,
        );
        if (encrypted.payloadSha256 != record.payloadSha256) {
          throw const FormatException('Outbox digest is invalid.');
        }
        await _publisher.publish(
          folderUri: folderUri,
          operation: encrypted,
        );
        await _repository.markPublished(
          operationId: record.operationId,
          publishedAt: _clock().toUtc(),
        );
        published++;
      } on Object catch (error, stackTrace) {
        developer.log(
          'No se pudo publicar ${record.operationId}: $error',
          name: 'MichiFocusSync',
          error: error,
          stackTrace: stackTrace,
        );
        await _repository.markPublicationFailed(record.operationId);
        failed++;
      }
    }
    final remaining = (await _repository.pendingOutbox(
      groupId: groupId,
      originDeviceId: installationId,
    )).length;
    return SyncOutboxPublicationReport(
      published: published,
      failed: failed,
      remaining: remaining,
    );
  }

  Map<String, Object?> _jsonObject(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Outbox JSON is invalid.');
    }
    return Map<String, Object?>.from(decoded);
  }

  Future<SyncOperation> _operationMatchingDigest(
    SyncOperation storedOperation,
    String expectedDigest,
  ) async {
    if (await _hasDigest(storedOperation, expectedDigest)) {
      return storedOperation;
    }

    // Drift stores DateTime values as Unix seconds. Operations created by an
    // earlier build hashed the milliseconds before that value was persisted.
    // Recover only the timestamp whose canonical payload matches the durable
    // digest; unrelated or altered rows remain rejected.
    final storedSecond = storedOperation.createdAtEpochMillis;
    for (var millisecond = 1; millisecond < 1000; millisecond++) {
      final candidate = SyncOperation(
        groupId: storedOperation.groupId,
        operationId: storedOperation.operationId,
        originDeviceId: storedOperation.originDeviceId,
        originCounter: storedOperation.originCounter,
        entityType: storedOperation.entityType,
        entityId: storedOperation.entityId,
        parentVersion: storedOperation.parentVersion,
        changedFields: storedOperation.changedFields,
        operationKind: storedOperation.operationKind,
        createdAtEpochMillis: storedSecond + millisecond,
        originDeviceName: storedOperation.originDeviceName,
        entitySnapshot: storedOperation.entitySnapshot,
      );
      if (await _hasDigest(candidate, expectedDigest)) return candidate;
    }
    throw const FormatException('Outbox digest is invalid.');
  }

  Future<bool> _hasDigest(
    SyncOperation operation,
    String expectedDigest,
  ) async {
    final digest = await Sha256().hash(operation.canonicalBytes());
    final actual = digest.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return actual == expectedDigest;
  }
}
