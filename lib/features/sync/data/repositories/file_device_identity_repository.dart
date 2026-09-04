import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';

typedef DeviceIdentityDirectoryProvider = Future<Directory> Function();

class FileDeviceIdentityRepository implements DeviceIdentityRepository {
  FileDeviceIdentityRepository({DeviceIdentityDirectoryProvider? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  static const _fileName = 'michifocus-device-identity.json';

  final DeviceIdentityDirectoryProvider _directory;
  DeviceIdentity? _cached;

  @override
  Future<DeviceIdentity> load() async {
    final cached = _cached;
    if (cached != null) return cached;
    try {
      final file = await _identityFile();
      if (!file.existsSync()) return _cache(const DeviceIdentity());

      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return _cache(const DeviceIdentity());
      }

      return _cache(
        DeviceIdentity(
          installationId: decoded['installationId'] is String
              ? decoded['installationId'] as String
              : '',
          friendlyName: decoded['friendlyName'] is String
              ? decoded['friendlyName'] as String
              : '',
        ).normalized(),
      );
    } on FormatException {
      return _cache(const DeviceIdentity());
    } on FileSystemException {
      return _cache(const DeviceIdentity());
    }
  }

  @override
  Future<void> save(DeviceIdentity identity) async {
    final normalized = identity.normalized();
    final file = await _identityFile();
    await file.writeAsString(
      jsonEncode({
        'installationId': normalized.installationId,
        'friendlyName': normalized.friendlyName,
      }),
      flush: true,
    );
    _cached = normalized;
  }

  DeviceIdentity _cache(DeviceIdentity value) => _cached = value;

  Future<File> _identityFile() async {
    final directory = await _directory();
    return File('${directory.path}/$_fileName');
  }
}
