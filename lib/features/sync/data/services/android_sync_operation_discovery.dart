import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_discovery.dart';

class AndroidSyncOperationDiscovery {
  const AndroidSyncOperationDiscovery({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('michifocus/native_files');

  final MethodChannel _channel;

  Future<SyncOperationDiscoveryReport> call({
    required String folderUri,
    required String localInstallationId,
  }) async {
    if (folderUri.trim().isEmpty ||
        !RegExp(
          r'^installation_[a-f0-9]{32}$',
        ).hasMatch(localInstallationId)) {
      throw const FormatException('Invalid operation discovery request.');
    }
    try {
      final raw = await _channel.invokeListMethod<dynamic>(
        'discoverSyncOperations',
        {
          'folderUri': folderUri.trim(),
          'localInstallationId': localInstallationId,
        },
      );
      final operations = <DiscoveredSyncOperation>[];
      var rejected = 0;
      for (final item in raw ?? const <dynamic>[]) {
        if (item is! Map) {
          rejected++;
          continue;
        }
        final path = item['relativePath'];
        final bytes = item['bytes'];
        if (path is! String || bytes is! Uint8List || bytes.isEmpty) {
          rejected++;
          continue;
        }
        try {
          final decoded = jsonDecode(utf8.decode(bytes));
          if (decoded is! Map<String, dynamic>) throw const FormatException();
          final operation = SyncEncryptedOperation.fromJson(decoded);
          if (!_pathMatches(path, operation)) throw const FormatException();
          operations.add(
            DiscoveredSyncOperation(
              relativePath: path,
              operation: operation,
            ),
          );
        } on Object {
          rejected++;
        }
      }
      operations.sort(
        (left, right) => left.relativePath.compareTo(right.relativePath),
      );
      return SyncOperationDiscoveryReport(
        operations: List.unmodifiable(operations),
        rejectedFiles: rejected,
      );
    } on PlatformException {
      throw const SyncOperationDiscoveryException();
    } on MissingPluginException {
      throw const SyncOperationDiscoveryException();
    }
  }

  bool _pathMatches(String path, SyncEncryptedOperation operation) {
    final counter = operation.originCounter.toString().padLeft(20, '0');
    final deviceId = operation.originDeviceId.substring(
      'installation_'.length,
    );
    final operationId = operation.operationId.substring('operation_'.length);
    return path == 'michifocus-op-$deviceId-$counter-$operationId.v1.json';
  }
}

class SyncOperationDiscoveryException implements Exception {
  const SyncOperationDiscoveryException();
}
