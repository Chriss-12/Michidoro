import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_publisher.dart';

class AndroidSyncGroupManifestPublisher implements SyncGroupManifestPublisher {
  const AndroidSyncGroupManifestPublisher({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('michifocus/native_files');

  final MethodChannel _channel;

  @override
  String relativePathFor(String groupId) {
    final normalizedGroupId = groupId.trim();
    if (!RegExp(r'^group_[a-f0-9]{32}$').hasMatch(normalizedGroupId)) {
      throw const FormatException('Invalid synchronization group ID.');
    }
    return 'michifocus-$normalizedGroupId.v1.json';
  }

  @override
  Future<SyncGroupManifestPublication> publish({
    required String folderUri,
    required SyncGroupKeyManifest manifest,
  }) async {
    final normalizedFolderUri = folderUri.trim();
    if (normalizedFolderUri.isEmpty) {
      throw const SyncGroupManifestFolderUnavailableException();
    }
    final expectedPath = relativePathFor(manifest.groupId);
    final bytes = Uint8List.fromList(
      utf8.encode(jsonEncode(manifest.toJson())),
    );
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'publishSyncGroupManifest',
        {
          'folderUri': normalizedFolderUri,
          'groupId': manifest.groupId,
          'bytes': bytes,
        },
      );
      final relativePath = result?['relativePath'];
      final atomicFinalization = result?['atomicFinalization'];
      if (relativePath is! String ||
          relativePath != expectedPath ||
          atomicFinalization is! bool) {
        throw const SyncGroupManifestFolderUnavailableException();
      }
      return SyncGroupManifestPublication(
        relativePath: relativePath,
        atomicFinalization: atomicFinalization,
      );
    } on PlatformException catch (error) {
      if (error.code == 'group_manifest_conflict') {
        throw const SyncGroupManifestConflictException();
      }
      throw const SyncGroupManifestFolderUnavailableException();
    } on MissingPluginException {
      throw const SyncGroupManifestFolderUnavailableException();
    }
  }
}
