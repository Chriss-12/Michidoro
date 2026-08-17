import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/app/data/datasources/unified_database_validator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_recovery_snapshot_service.dart';

class DriftSyncRecoverySnapshotService {
  DriftSyncRecoverySnapshotService({
    required MichiFocusDatabase database,
    required SyncGroupCrypto crypto,
    required SecureSyncIdGenerator idGenerator,
    UnifiedDatabaseValidator validator = const UnifiedDatabaseValidator(),
    Future<Directory> Function()? temporaryDirectory,
    MethodChannel? channel,
    DateTime Function()? clock,
  }) : _database = database,
       _crypto = crypto,
       _idGenerator = idGenerator,
       _validator = validator,
       _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory,
       _channel = channel ?? const MethodChannel('michifocus/native_files'),
       _clock = clock ?? DateTime.now;

  final MichiFocusDatabase _database;
  final SyncGroupCrypto _crypto;
  final SecureSyncIdGenerator _idGenerator;
  final UnifiedDatabaseValidator _validator;
  final Future<Directory> Function() _temporaryDirectory;
  final MethodChannel _channel;
  final DateTime Function() _clock;

  Future<SyncRecoverySnapshotPublication> call({
    required String folderUri,
    required String groupId,
    required List<int> clearKey,
  }) async {
    final normalizedFolderUri = folderUri.trim();
    if (normalizedFolderUri.isEmpty ||
        !RegExp(r'^group_[a-f0-9]{32}$').hasMatch(groupId) ||
        clearKey.length != 32) {
      throw const SyncRecoverySnapshotException();
    }

    final snapshotId = _idGenerator.create('snapshot');
    final expectedPath = _relativePath(groupId, snapshotId);
    final directory = await _temporaryDirectory();
    await directory.create(recursive: true);
    final sqliteSnapshot = File(
      '${directory.path}/.michifocus-$snapshotId.sqlite',
    );
    final encryptedArtifact = File(
      '${directory.path}/.michifocus-$snapshotId.json',
    );
    var databaseBytes = <int>[];
    var verificationBytes = <int>[];
    try {
      _deleteIfPresent(sqliteSnapshot);
      _deleteIfPresent(encryptedArtifact);
      await _database.createBackupSnapshot(sqliteSnapshot.path);
      await _validator.validateForImport(sqliteSnapshot);
      databaseBytes = await sqliteSnapshot.readAsBytes();
      final encrypted = await _crypto.encryptRecoverySnapshot(
        groupId: groupId,
        snapshotId: snapshotId,
        createdAtEpochMillis: _clock().toUtc().millisecondsSinceEpoch,
        clearKey: clearKey,
        databaseBytes: databaseBytes,
      );
      verificationBytes = await _crypto.decryptRecoverySnapshot(
        snapshot: encrypted,
        clearKey: clearKey,
      );
      if (!_sameBytes(databaseBytes, verificationBytes)) {
        throw const SyncRecoverySnapshotException();
      }
      await encryptedArtifact.writeAsString(
        jsonEncode(encrypted.toJson()),
        flush: true,
      );

      final result = await _channel.invokeMapMethod<String, dynamic>(
        'publishSyncRecoverySnapshot',
        {
          'folderUri': normalizedFolderUri,
          'groupId': groupId,
          'snapshotId': snapshotId,
          'sourcePath': encryptedArtifact.path,
        },
      );
      final relativePath = result?['relativePath'];
      final atomicFinalization = result?['atomicFinalization'];
      if (relativePath != expectedPath || atomicFinalization is! bool) {
        throw const SyncRecoverySnapshotException();
      }
      return SyncRecoverySnapshotPublication(
        snapshotId: snapshotId,
        relativePath: relativePath as String,
        atomicFinalization: atomicFinalization,
      );
    } on SyncRecoverySnapshotException {
      rethrow;
    } on Object {
      throw const SyncRecoverySnapshotException();
    } finally {
      _erase(databaseBytes);
      _erase(verificationBytes);
      _deleteIfPresent(sqliteSnapshot);
      _deleteIfPresent(encryptedArtifact);
    }
  }

  String _relativePath(String groupId, String snapshotId) {
    return 'michifocus-$groupId-recovery-$snapshotId.v1.json';
  }

  void _deleteIfPresent(File file) {
    if (file.existsSync()) file.deleteSync();
  }

  bool _sameBytes(List<int> first, List<int> second) {
    if (first.length != second.length) return false;
    var difference = 0;
    for (var index = 0; index < first.length; index++) {
      difference |= first[index] ^ second[index];
    }
    return difference == 0;
  }

  void _erase(List<int> bytes) {
    for (var index = 0; index < bytes.length; index++) {
      bytes[index] = 0;
    }
  }
}
