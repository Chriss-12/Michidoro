import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';

typedef SyncGroupDirectoryProvider = Future<Directory> Function();

class FileSyncGroupEnrollmentRepository
    implements SyncGroupEnrollmentRepository {
  FileSyncGroupEnrollmentRepository({SyncGroupDirectoryProvider? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  static const _fileName = 'michifocus-sync-group.json';

  final SyncGroupDirectoryProvider _directory;
  SyncGroupEnrollment? _cached;
  bool _hasCachedValue = false;

  @override
  Future<SyncGroupEnrollment?> load() async {
    if (_hasCachedValue) return _cached;
    try {
      final file = await _file();
      if (!file.existsSync()) return _cache(null);
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic> || decoded['version'] != 1) {
        return _cache(null);
      }
      return _cache(SyncGroupEnrollment.fromJson(decoded));
    } on FormatException {
      return _cache(null);
    } on FileSystemException {
      return _cache(null);
    }
  }

  @override
  Future<void> create(SyncGroupEnrollment enrollment) async {
    final destination = await _file();
    if (destination.existsSync()) {
      throw const SyncGroupAlreadyExistsException();
    }

    final temporary = File('${destination.path}.pending');
    await temporary.writeAsString(jsonEncode(enrollment.toJson()), flush: true);
    try {
      await temporary.rename(destination.path);
      _cache(enrollment);
    } on Object {
      if (temporary.existsSync()) temporary.deleteSync();
      rethrow;
    }
  }

  @override
  Future<void> update(SyncGroupEnrollment enrollment) async {
    final destination = await _file();
    if (!destination.existsSync()) {
      throw StateError('Synchronization group does not exist.');
    }
    final current = await load();
    if (current == null || current.groupId != enrollment.groupId) {
      throw StateError('Synchronization group identity changed.');
    }

    final temporary = File('${destination.path}.pending');
    final previous = File('${destination.path}.previous');
    if (temporary.existsSync()) temporary.deleteSync();
    if (previous.existsSync()) previous.deleteSync();
    await temporary.writeAsString(jsonEncode(enrollment.toJson()), flush: true);
    try {
      await destination.rename(previous.path);
      await temporary.rename(destination.path);
      await previous.delete();
      _cache(enrollment);
    } on Object {
      if (!destination.existsSync() && previous.existsSync()) {
        await previous.rename(destination.path);
      }
      if (temporary.existsSync()) await temporary.delete();
      rethrow;
    }
  }

  SyncGroupEnrollment? _cache(SyncGroupEnrollment? value) {
    _cached = value;
    _hasCachedValue = true;
    return value;
  }

  Future<File> _file() async {
    final directory = await _directory();
    directory.createSync(recursive: true);
    return File('${directory.path}/$_fileName');
  }
}
