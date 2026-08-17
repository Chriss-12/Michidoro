import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_recovery_snapshot.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';

void main() {
  const groupId = 'group_0123456789abcdef0123456789abcdef';
  const password = 'correct horse battery staple';
  late SyncGroupCrypto crypto;

  setUp(() {
    crypto = SyncGroupCrypto(
      parameters: const SyncGroupCryptoParameters(
        memoryKiB: 1024,
        iterations: 1,
      ),
      random: Random(42),
    );
  });

  test('creates two authenticated wrappers for the same random DEK', () async {
    final created = await crypto.createGroupKeys(
      groupId: groupId,
      password: password,
    );

    final passwordDek = await crypto.unlockWithPassword(
      created.manifest,
      password,
    );
    final recoveryDek = await crypto.unlockWithRecoveryKey(
      created.manifest,
      created.recoveryKey,
    );

    expect(await passwordDek.extractBytes(), await recoveryDek.extractBytes());
    expect(await passwordDek.extractBytes(), hasLength(32));
    expect(created.recoveryKey, hasLength(43));
  });

  test(
    'manifest round trips without storing password or plaintext keys',
    () async {
      final created = await crypto.createGroupKeys(
        groupId: groupId,
        password: password,
      );
      final encoded = jsonEncode(created.manifest.toJson());
      final decoded = SyncGroupKeyManifest.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );

      expect(encoded, isNot(contains(password)));
      expect(encoded, isNot(contains(created.recoveryKey)));
      expect(encoded, contains('argon2id-aes256gcm-v1'));
      expect(decoded.passwordKdf.memoryKiB, 1024);

      final unlocked = await crypto.unlockWithPassword(decoded, password);
      expect(await unlocked.extractBytes(), hasLength(32));
    },
  );

  test('wrong password and wrong recovery key fail authentication', () async {
    final created = await crypto.createGroupKeys(
      groupId: groupId,
      password: password,
    );
    final other = await crypto.createGroupKeys(
      groupId: 'group_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      password: 'another secure password',
    );

    await expectLater(
      crypto.unlockWithPassword(created.manifest, 'wrong password value'),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
    await expectLater(
      crypto.unlockWithRecoveryKey(created.manifest, other.recoveryKey),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('maps enrollment credentials to one non-revealing failure', () async {
    final created = await crypto.createGroupKeys(
      groupId: groupId,
      password: password,
    );

    await expectLater(
      crypto.unlockBytesForEnrollment(
        manifest: created.manifest,
        credential: 'incorrect password',
        useRecoveryKey: false,
      ),
      throwsA(isA<SyncGroupCredentialRejectedException>()),
    );
    await expectLater(
      crypto.unlockBytesForEnrollment(
        manifest: created.manifest,
        credential: 'not-a-recovery-key',
        useRecoveryKey: true,
      ),
      throwsA(isA<SyncGroupCredentialRejectedException>()),
    );
  });

  test('authenticated group context prevents moving a wrapper', () async {
    final created = await crypto.createGroupKeys(
      groupId: groupId,
      password: password,
    );
    final moved = SyncGroupKeyManifest(
      groupId: 'group_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
      passwordKdf: created.manifest.passwordKdf,
      passwordWrappedDek: created.manifest.passwordWrappedDek,
      recoveryWrappedDek: created.manifest.recoveryWrappedDek,
    );

    await expectLater(
      crypto.unlockWithPassword(moved, password),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('tampering is rejected before any DEK is returned', () async {
    final created = await crypto.createGroupKeys(
      groupId: groupId,
      password: password,
    );
    final original = created.manifest.passwordWrappedDek;
    final damagedCipherText = [...original.cipherText]
      ..[0] = original.cipherText.first ^ 1;
    final damaged = SyncGroupKeyManifest(
      groupId: groupId,
      passwordKdf: created.manifest.passwordKdf,
      passwordWrappedDek: EncryptedKeyEnvelope(
        nonce: original.nonce,
        cipherText: damagedCipherText,
        mac: original.mac,
      ),
      recoveryWrappedDek: created.manifest.recoveryWrappedDek,
    );

    await expectLater(
      crypto.unlockWithPassword(damaged, password),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('rejects short passwords and unsupported manifests', () async {
    await expectLater(
      crypto.createGroupKeys(groupId: groupId, password: 'too short'),
      throwsArgumentError,
    );

    expect(
      () => SyncGroupKeyManifest.fromJson({
        'protocolVersion': 99,
        'cryptoSuite': 'future',
      }),
      throwsFormatException,
    );

    final created = await crypto.createGroupKeys(
      groupId: groupId,
      password: password,
    );
    final hostileKdf = SyncGroupKeyManifest(
      groupId: groupId,
      passwordKdf: PasswordKdfParameters(
        salt: created.manifest.passwordKdf.salt,
        memoryKiB: 1024 * 1024,
        iterations: 1000,
        parallelism: 64,
        hashLength: 32,
      ),
      passwordWrappedDek: created.manifest.passwordWrappedDek,
      recoveryWrappedDek: created.manifest.recoveryWrappedDek,
    );
    await expectLater(
      crypto.unlockWithPassword(hostileKdf, password),
      throwsFormatException,
    );
  });

  test('encrypts and authenticates a recovery snapshot', () async {
    final clearKey = List<int>.generate(32, (index) => index);
    final databaseBytes = utf8.encode('SQLite format 3\u0000private task data');
    final encrypted = await crypto.encryptRecoverySnapshot(
      groupId: groupId,
      snapshotId: 'snapshot_0123456789abcdef0123456789abcdef',
      createdAtEpochMillis: 1_700_000_000_000,
      clearKey: clearKey,
      databaseBytes: databaseBytes,
    );
    final encoded = jsonEncode(encrypted.toJson());
    final decoded = SyncEncryptedRecoverySnapshot.fromJson(
      jsonDecode(encoded) as Map<String, dynamic>,
    );

    expect(encoded, isNot(contains('private task data')));
    expect(
      await crypto.decryptRecoverySnapshot(
        snapshot: decoded,
        clearKey: clearKey,
      ),
      databaseBytes,
    );
  });

  test('rejects changed recovery snapshot metadata and ciphertext', () async {
    final clearKey = List<int>.filled(32, 7);
    final encrypted = await crypto.encryptRecoverySnapshot(
      groupId: groupId,
      snapshotId: 'snapshot_0123456789abcdef0123456789abcdef',
      createdAtEpochMillis: 1_700_000_000_000,
      clearKey: clearKey,
      databaseBytes: [1, 2, 3, 4],
    );
    final moved = SyncEncryptedRecoverySnapshot(
      groupId: groupId,
      snapshotId: 'snapshot_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      createdAtEpochMillis: encrypted.createdAtEpochMillis,
      nonce: encrypted.nonce,
      cipherText: encrypted.cipherText,
      mac: encrypted.mac,
    );
    final changed = SyncEncryptedRecoverySnapshot(
      groupId: encrypted.groupId,
      snapshotId: encrypted.snapshotId,
      createdAtEpochMillis: encrypted.createdAtEpochMillis,
      nonce: encrypted.nonce,
      cipherText: [...encrypted.cipherText]..[0] ^= 1,
      mac: encrypted.mac,
    );

    await expectLater(
      crypto.decryptRecoverySnapshot(snapshot: moved, clearKey: clearKey),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
    await expectLater(
      crypto.decryptRecoverySnapshot(snapshot: changed, clearKey: clearKey),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('encrypts an operation without exposing user fields', () async {
    final clearKey = List<int>.generate(32, (index) => index);
    final operation = _operation();
    final encrypted = await crypto.encryptOperation(
      operation: operation,
      clearKey: clearKey,
    );
    final encoded = jsonEncode(encrypted.toJson());

    expect(encoded, isNot(contains('Private objective')));
    expect(encrypted.payloadSha256, hasLength(64));
    final decrypted = await crypto.decryptOperation(
      encrypted: encrypted,
      clearKey: clearKey,
    );
    expect(decrypted.toJson(), operation.toJson());
  });

  test('rejects moved, modified, and wrong-key operations', () async {
    final clearKey = List<int>.filled(32, 8);
    final encrypted = await crypto.encryptOperation(
      operation: _operation(),
      clearKey: clearKey,
    );

    await expectLater(
      crypto.decryptOperation(
        encrypted: SyncEncryptedOperation(
          groupId: encrypted.groupId,
          operationId: 'operation_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          originDeviceId: encrypted.originDeviceId,
          originCounter: encrypted.originCounter,
          payloadSha256: encrypted.payloadSha256,
          nonce: encrypted.nonce,
          cipherText: encrypted.cipherText,
          mac: encrypted.mac,
        ),
        clearKey: clearKey,
      ),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
    await expectLater(
      crypto.decryptOperation(
        encrypted: SyncEncryptedOperation(
          groupId: encrypted.groupId,
          operationId: encrypted.operationId,
          originDeviceId: encrypted.originDeviceId,
          originCounter: encrypted.originCounter,
          payloadSha256: encrypted.payloadSha256,
          nonce: encrypted.nonce,
          cipherText: [...encrypted.cipherText]..[0] ^= 1,
          mac: encrypted.mac,
        ),
        clearKey: clearKey,
      ),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
    await expectLater(
      crypto.decryptOperation(
        encrypted: encrypted,
        clearKey: List<int>.filled(32, 9),
      ),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });
}

SyncOperation _operation() => const SyncOperation(
  groupId: 'group_0123456789abcdef0123456789abcdef',
  operationId: 'operation_0123456789abcdef0123456789abcdef',
  originDeviceId: 'installation_0123456789abcdef0123456789abcdef',
  originCounter: 1,
  entityType: 'goal',
  entityId: 'goal_0123456789abcdef0123456789abcdef',
  parentVersion: {},
  changedFields: {'title': 'Private objective', 'targetSessions': 4},
  operationKind: 'create',
  createdAtEpochMillis: 1_700_000_000_000,
);
