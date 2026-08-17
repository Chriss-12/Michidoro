import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_discovery.dart';

class AndroidSyncGroupManifestDiscovery {
  const AndroidSyncGroupManifestDiscovery({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('michifocus/native_files');

  static const int _maximumManifestBytes = 64 * 1024;
  static final RegExp _fileNamePattern = RegExp(
    r'^michifocus-(group_[a-f0-9]{32})\.v1\.json$',
  );

  final MethodChannel _channel;

  Future<SyncGroupManifestDiscoveryResult> call({
    required String folderUri,
  }) async {
    final normalizedFolderUri = folderUri.trim();
    if (normalizedFolderUri.isEmpty) {
      throw const SyncGroupManifestDiscoveryException();
    }

    try {
      final nativeFiles = await _channel.invokeMethod<List<dynamic>>(
        'discoverSyncGroupManifests',
        {'folderUri': normalizedFolderUri},
      );
      if (nativeFiles == null) {
        throw const SyncGroupManifestDiscoveryException();
      }

      var rejectedFiles = 0;
      final groupsById = <String, DiscoveredSyncGroupManifest>{};
      final conflictedGroupIds = <String>{};
      for (final nativeFile in nativeFiles) {
        try {
          final file = Map<String, dynamic>.from(nativeFile as Map);
          final relativePath = file['relativePath'];
          final bytes = file['bytes'];
          if (relativePath is! String || bytes is! Uint8List) {
            throw const FormatException('Invalid native manifest entry.');
          }
          final nameMatch = _fileNamePattern.firstMatch(relativePath);
          if (nameMatch == null ||
              bytes.isEmpty ||
              bytes.length > _maximumManifestBytes) {
            throw const FormatException('Invalid group manifest file.');
          }
          final decoded = jsonDecode(utf8.decode(bytes));
          if (decoded is! Map<String, dynamic>) {
            throw const FormatException('Invalid group manifest JSON.');
          }
          final manifest = SyncGroupKeyManifest.fromJson(decoded);
          if (manifest.groupId != nameMatch.group(1) ||
              !_hasSupportedCryptographicShape(manifest)) {
            throw const FormatException('Unsupported group manifest.');
          }
          if (conflictedGroupIds.contains(manifest.groupId)) {
            rejectedFiles++;
            continue;
          }

          final candidate = DiscoveredSyncGroupManifest(
            relativePath: relativePath,
            manifest: manifest,
          );
          final existing = groupsById[manifest.groupId];
          if (existing != null) {
            if (jsonEncode(existing.manifest.toJson()) !=
                jsonEncode(manifest.toJson())) {
              groupsById.remove(manifest.groupId);
              conflictedGroupIds.add(manifest.groupId);
            }
            rejectedFiles++;
            continue;
          }
          groupsById[manifest.groupId] = candidate;
        } on Object {
          rejectedFiles++;
        }
      }

      final groups = groupsById.values.toList()
        ..sort(
          (first, second) => first.manifest.groupId.compareTo(
            second.manifest.groupId,
          ),
        );
      return SyncGroupManifestDiscoveryResult(
        groups: List.unmodifiable(groups),
        rejectedFiles: rejectedFiles,
      );
    } on PlatformException {
      throw const SyncGroupManifestDiscoveryException();
    } on MissingPluginException {
      throw const SyncGroupManifestDiscoveryException();
    } on Object {
      throw const SyncGroupManifestDiscoveryException();
    }
  }

  bool _hasSupportedCryptographicShape(SyncGroupKeyManifest manifest) {
    final kdf = manifest.passwordKdf;
    return kdf.memoryKiB == 64 * 1024 &&
        kdf.iterations == 3 &&
        kdf.parallelism == 1 &&
        kdf.hashLength == 32 &&
        kdf.salt.length == 16 &&
        _hasSupportedEnvelopeShape(manifest.passwordWrappedDek) &&
        _hasSupportedEnvelopeShape(manifest.recoveryWrappedDek);
  }

  bool _hasSupportedEnvelopeShape(EncryptedKeyEnvelope envelope) {
    return envelope.nonce.length == 12 &&
        envelope.cipherText.length == 32 &&
        envelope.mac.length == 16;
  }
}
