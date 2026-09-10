import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/security/encrypted_database_backup_codec.dart';

void main() {
  const parameters = EncryptedDatabaseBackupParameters(
    memoryKiB: 32,
    iterations: 1,
  );
  const password = 'correct horse battery staple';

  test('round trips without exposing the clear database bytes', () async {
    final codec = EncryptedDatabaseBackupCodec(
      parameters: parameters,
      random: Random(7),
    );
    final clearBytes = utf8.encode('SQLite format 3\u0000private routine');

    final encrypted = await codec.encrypt(
      databaseBytes: clearBytes,
      password: password,
    );

    expect(utf8.decode(encrypted), isNot(contains('private routine')));
    expect(
      await codec.decrypt(encryptedBytes: encrypted, password: password),
      clearBytes,
    );
  });

  test('rejects a wrong password and an altered envelope', () async {
    final codec = EncryptedDatabaseBackupCodec(
      parameters: parameters,
      random: Random(8),
    );
    final encrypted = await codec.encrypt(
      databaseBytes: utf8.encode('SQLite format 3\u0000secret'),
      password: password,
    );

    await expectLater(
      codec.decrypt(
        encryptedBytes: encrypted,
        password: 'another secure password',
      ),
      throwsA(isA<EncryptedDatabaseBackupException>()),
    );

    final altered = List<int>.from(encrypted)..[encrypted.length - 2] ^= 1;
    await expectLater(
      codec.decrypt(encryptedBytes: altered, password: password),
      throwsA(isA<EncryptedDatabaseBackupException>()),
    );
  });

  test('requires a password with at least twelve characters', () async {
    final codec = EncryptedDatabaseBackupCodec(parameters: parameters);

    await expectLater(
      codec.encrypt(databaseBytes: const [1], password: 'short'),
      throwsArgumentError,
    );
  });

  test('master password recovers the same AES-256 backup key', () async {
    final codec = EncryptedDatabaseBackupCodec(
      parameters: parameters,
      random: Random(9),
    );
    final material = await codec.createMasterKey(password);
    final encrypted = await codec.encryptWithMasterKey(
      databaseBytes: utf8.encode('SQLite format 3\u0000master protected'),
      clearKey: material.clearKey,
      recoveryEnvelope: material.recoveryEnvelope,
    );

    expect(utf8.decode(encrypted), isNot(contains('master protected')));
    final decrypted = await codec.decryptWithMasterPassword(
      encryptedBytes: encrypted,
      password: password,
    );
    expect(decrypted.clearKey, material.clearKey);
    expect(
      utf8.decode(decrypted.databaseBytes),
      contains('master protected'),
    );
  });

  test('master backup rejects the wrong recovery password', () async {
    final codec = EncryptedDatabaseBackupCodec(
      parameters: parameters,
      random: Random(10),
    );
    final material = await codec.createMasterKey(password);
    final encrypted = await codec.encryptWithMasterKey(
      databaseBytes: utf8.encode('SQLite format 3\u0000private'),
      clearKey: material.clearKey,
      recoveryEnvelope: material.recoveryEnvelope,
    );

    await expectLater(
      codec.decryptWithMasterPassword(
        encryptedBytes: encrypted,
        password: 'another secure password',
      ),
      throwsA(isA<EncryptedDatabaseBackupException>()),
    );
  });
}
