import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_local_unlock_policy_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/local_unlock_policy.dart';

void main() {
  late Directory directory;
  late FileLocalUnlockPolicyRepository repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'michifocus-local-unlock-',
    );
    repository = FileLocalUnlockPolicyRepository(
      directory: () async => directory,
    );
  });

  tearDown(() async {
    if (directory.existsSync()) await directory.delete(recursive: true);
  });

  test('defaults to disabled when no policy has been stored', () async {
    expect(await repository.load(), LocalUnlockPolicy.disabled);
  });

  test('round trips the selected local unlock policy', () async {
    await repository.save(LocalUnlockPolicy.afterFiveMinutes);

    expect(await repository.load(), LocalUnlockPolicy.afterFiveMinutes);
  });

  test('fails safely to disabled for malformed settings', () async {
    final file = File(
      '${directory.path}/michifocus-local-security.json',
    );
    await file.writeAsString('{not-json');

    expect(await repository.load(), LocalUnlockPolicy.disabled);
  });

  test('fails safely to disabled for an unknown policy', () async {
    final file = File(
      '${directory.path}/michifocus-local-security.json',
    );
    await file.writeAsString('{"localUnlockPolicy":"futurePolicy"}');

    expect(await repository.load(), LocalUnlockPolicy.disabled);
  });
}
