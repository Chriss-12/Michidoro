import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_publisher.dart';

class AndroidSyncOperationPublisher implements SyncOperationPublisher {
  const AndroidSyncOperationPublisher({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('michifocus/native_files');

  final MethodChannel _channel;

  @override
  String relativePathFor(SyncEncryptedOperation operation) {
    operation.validate();
    final counter = operation.originCounter.toString().padLeft(20, '0');
    final deviceId = operation.originDeviceId.substring(
      'installation_'.length,
    );
    final operationId = operation.operationId.substring('operation_'.length);
    return 'michifocus-op-$deviceId-$counter-$operationId.v1.json';
  }

  @override
  Future<SyncOperationPublication> publish({
    required String folderUri,
    required SyncEncryptedOperation operation,
  }) async {
    final normalizedFolderUri = folderUri.trim();
    if (normalizedFolderUri.isEmpty) {
      throw const SyncOperationFolderUnavailableException();
    }
    final expectedPath = relativePathFor(operation);
    final bytes = Uint8List.fromList(
      utf8.encode(jsonEncode(operation.toJson())),
    );
    if (bytes.length > 384 * 1024) {
      throw const SyncOperationFolderUnavailableException();
    }
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'publishSyncOperation',
        {
          'folderUri': normalizedFolderUri,
          'groupId': operation.groupId,
          'installationId': operation.originDeviceId,
          'originCounter': operation.originCounter,
          'operationId': operation.operationId,
          'bytes': bytes,
        },
      );
      final relativePath = result?['relativePath'];
      final atomicFinalization = result?['atomicFinalization'];
      if (relativePath != expectedPath || atomicFinalization is! bool) {
        throw const SyncOperationFolderUnavailableException();
      }
      return SyncOperationPublication(
        relativePath: relativePath! as String,
        atomicFinalization: atomicFinalization,
      );
    } on PlatformException catch (error) {
      if (error.code == 'sync_operation_conflict') {
        throw const SyncOperationConflictException();
      }
      throw const SyncOperationFolderUnavailableException();
    } on MissingPluginException {
      throw const SyncOperationFolderUnavailableException();
    }
  }
}
