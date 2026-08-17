import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/local_unlock_policy.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/local_unlock_policy_repository.dart';

typedef LocalUnlockDirectoryProvider = Future<Directory> Function();

class FileLocalUnlockPolicyRepository implements LocalUnlockPolicyRepository {
  FileLocalUnlockPolicyRepository({LocalUnlockDirectoryProvider? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  static const _fileName = 'michifocus-local-security.json';

  final LocalUnlockDirectoryProvider _directory;

  @override
  Future<LocalUnlockPolicy> load() async {
    try {
      final file = await _policyFile();
      if (!file.existsSync()) return LocalUnlockPolicy.disabled;

      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return LocalUnlockPolicy.disabled;
      }

      final storedPolicy = decoded['localUnlockPolicy'];
      if (storedPolicy is! String) return LocalUnlockPolicy.disabled;

      return LocalUnlockPolicy.values.firstWhere(
        (policy) => policy.name == storedPolicy,
        orElse: () => LocalUnlockPolicy.disabled,
      );
    } on FormatException {
      return LocalUnlockPolicy.disabled;
    } on FileSystemException {
      return LocalUnlockPolicy.disabled;
    }
  }

  @override
  Future<void> save(LocalUnlockPolicy policy) async {
    final file = await _policyFile();
    await file.writeAsString(
      jsonEncode({'localUnlockPolicy': policy.name}),
      flush: true,
    );
  }

  Future<File> _policyFile() async {
    final directory = await _directory();
    return File('${directory.path}/$_fileName');
  }
}
