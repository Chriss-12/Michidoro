import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_recovery_snapshot.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';

class SyncGroupCryptoParameters {
  const SyncGroupCryptoParameters({
    this.memoryKiB = 64 * 1024,
    this.iterations = 3,
    this.parallelism = 1,
    this.hashLength = 32,
  });

  final int memoryKiB;
  final int iterations;
  final int parallelism;
  final int hashLength;
}

class SyncGroupCredentialRejectedException implements Exception {
  const SyncGroupCredentialRejectedException();
}

class SyncGroupCrypto {
  SyncGroupCrypto({
    SyncGroupCryptoParameters parameters = const SyncGroupCryptoParameters(),
    Random? random,
  }) : _parameters = parameters,
       _random = random ?? Random.secure();

  static const minimumPasswordLength = 12;
  static const _keyLength = 32;
  static const _saltLength = 16;

  final SyncGroupCryptoParameters _parameters;
  final Random _random;
  final Cipher _cipher = AesGcm.with256bits();

  Future<CreatedSyncGroupKeys> createGroupKeys({
    required String groupId,
    required String password,
  }) async {
    final normalizedGroupId = groupId.trim();
    _validateGroupId(normalizedGroupId);
    _validatePassword(password);

    final dekBytes = _randomBytes(_keyLength);
    final recoveryBytes = _randomBytes(_keyLength);
    final salt = _randomBytes(_saltLength);
    try {
      final passwordKdf = PasswordKdfParameters(
        salt: salt,
        memoryKiB: _parameters.memoryKiB,
        iterations: _parameters.iterations,
        parallelism: _parameters.parallelism,
        hashLength: _parameters.hashLength,
      );
      final passwordKek = await _derivePasswordKek(password, passwordKdf);
      final passwordWrappedDek = await _wrapDek(
        dekBytes,
        wrappingKey: passwordKek,
        aad: _aad(normalizedGroupId, 'password'),
      );
      final recoveryWrappedDek = await _wrapDek(
        dekBytes,
        wrappingKey: SecretKey(recoveryBytes),
        aad: _aad(normalizedGroupId, 'recovery'),
      );

      return CreatedSyncGroupKeys(
        manifest: SyncGroupKeyManifest(
          groupId: normalizedGroupId,
          passwordKdf: passwordKdf,
          passwordWrappedDek: passwordWrappedDek,
          recoveryWrappedDek: recoveryWrappedDek,
        ),
        recoveryKey: base64UrlEncode(recoveryBytes).replaceAll('=', ''),
      );
    } finally {
      _eraseBytes(dekBytes);
      _eraseBytes(recoveryBytes);
    }
  }

  Future<SecretKey> unlockWithPassword(
    SyncGroupKeyManifest manifest,
    String password,
  ) async {
    _validateManifest(manifest);
    final kek = await _derivePasswordKek(password, manifest.passwordKdf);
    return _unwrapDek(
      manifest.passwordWrappedDek,
      wrappingKey: kek,
      aad: _aad(manifest.groupId, 'password'),
    );
  }

  Future<SecretKey> unlockWithRecoveryKey(
    SyncGroupKeyManifest manifest,
    String recoveryKey,
  ) async {
    _validateManifest(manifest);
    final recoveryBytes = _decodeRecoveryKey(recoveryKey);
    try {
      return await _unwrapDek(
        manifest.recoveryWrappedDek,
        wrappingKey: SecretKey(recoveryBytes),
        aad: _aad(manifest.groupId, 'recovery'),
      );
    } finally {
      _eraseBytes(recoveryBytes);
    }
  }

  Future<List<int>> unlockBytesForEnrollment({
    required SyncGroupKeyManifest manifest,
    required String credential,
    required bool useRecoveryKey,
  }) async {
    try {
      final key = useRecoveryKey
          ? await unlockWithRecoveryKey(manifest, credential)
          : await unlockWithPassword(manifest, credential);
      return List<int>.from(await key.extractBytes());
    } on SecretBoxAuthenticationError {
      throw const SyncGroupCredentialRejectedException();
    } on FormatException {
      throw const SyncGroupCredentialRejectedException();
    }
  }

  Future<SyncEncryptedRecoverySnapshot> encryptRecoverySnapshot({
    required String groupId,
    required String snapshotId,
    required int createdAtEpochMillis,
    required List<int> clearKey,
    required List<int> databaseBytes,
  }) async {
    _validateGroupId(groupId);
    if (!RegExp(r'^snapshot_[a-f0-9]{32}$').hasMatch(snapshotId) ||
        createdAtEpochMillis <= 0 ||
        clearKey.length != _keyLength ||
        databaseBytes.isEmpty) {
      throw const FormatException('Invalid recovery snapshot input.');
    }
    final box = await _cipher.encrypt(
      databaseBytes,
      secretKey: SecretKey(clearKey),
      nonce: _randomBytes(_cipher.nonceLength),
      aad: _snapshotAad(groupId, snapshotId, createdAtEpochMillis),
    );
    return SyncEncryptedRecoverySnapshot(
      groupId: groupId,
      snapshotId: snapshotId,
      createdAtEpochMillis: createdAtEpochMillis,
      nonce: box.nonce,
      cipherText: box.cipherText,
      mac: box.mac.bytes,
    );
  }

  Future<List<int>> decryptRecoverySnapshot({
    required SyncEncryptedRecoverySnapshot snapshot,
    required List<int> clearKey,
  }) {
    snapshot.validate();
    if (clearKey.length != _keyLength) {
      throw const FormatException('Invalid group data key length.');
    }
    return _cipher.decrypt(
      SecretBox(
        snapshot.cipherText,
        nonce: snapshot.nonce,
        mac: Mac(snapshot.mac),
      ),
      secretKey: SecretKey(clearKey),
      aad: _snapshotAad(
        snapshot.groupId,
        snapshot.snapshotId,
        snapshot.createdAtEpochMillis,
      ),
    );
  }

  Future<SyncEncryptedOperation> encryptOperation({
    required SyncOperation operation,
    required List<int> clearKey,
  }) async {
    operation.validate();
    if (clearKey.length != _keyLength) {
      throw const FormatException('Invalid group data key length.');
    }
    final clearBytes = operation.canonicalBytes();
    final digest = await Sha256().hash(clearBytes);
    final payloadSha256 = digest.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    final box = await _cipher.encrypt(
      clearBytes,
      secretKey: SecretKey(clearKey),
      nonce: _randomBytes(_cipher.nonceLength),
      aad: _operationAad(
        operation.groupId,
        operation.operationId,
        operation.originDeviceId,
        operation.originCounter,
        payloadSha256,
      ),
    );
    return SyncEncryptedOperation(
      groupId: operation.groupId,
      operationId: operation.operationId,
      originDeviceId: operation.originDeviceId,
      originCounter: operation.originCounter,
      payloadSha256: payloadSha256,
      nonce: box.nonce,
      cipherText: box.cipherText,
      mac: box.mac.bytes,
    );
  }

  Future<SyncOperation> decryptOperation({
    required SyncEncryptedOperation encrypted,
    required List<int> clearKey,
  }) async {
    encrypted.validate();
    if (clearKey.length != _keyLength) {
      throw const FormatException('Invalid group data key length.');
    }
    final clearBytes = await _cipher.decrypt(
      SecretBox(
        encrypted.cipherText,
        nonce: encrypted.nonce,
        mac: Mac(encrypted.mac),
      ),
      secretKey: SecretKey(clearKey),
      aad: _operationAad(
        encrypted.groupId,
        encrypted.operationId,
        encrypted.originDeviceId,
        encrypted.originCounter,
        encrypted.payloadSha256,
      ),
    );
    final digest = await Sha256().hash(clearBytes);
    final payloadSha256 = digest.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    if (payloadSha256 != encrypted.payloadSha256) {
      throw const FormatException('Operation digest does not match.');
    }
    final decoded = jsonDecode(utf8.decode(clearBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid operation payload.');
    }
    final operation = SyncOperation.fromJson(decoded);
    if (operation.groupId != encrypted.groupId ||
        operation.operationId != encrypted.operationId ||
        operation.originDeviceId != encrypted.originDeviceId ||
        operation.originCounter != encrypted.originCounter) {
      throw const FormatException(
        'Operation identity does not match envelope.',
      );
    }
    return operation;
  }

  Future<SecretKey> _derivePasswordKek(
    String password,
    PasswordKdfParameters parameters,
  ) {
    return Argon2id(
      memory: parameters.memoryKiB,
      iterations: parameters.iterations,
      parallelism: parameters.parallelism,
      hashLength: parameters.hashLength,
    ).deriveKeyFromPassword(password: password, nonce: parameters.salt);
  }

  Future<EncryptedKeyEnvelope> _wrapDek(
    List<int> dekBytes, {
    required SecretKey wrappingKey,
    required List<int> aad,
  }) async {
    final box = await _cipher.encrypt(
      dekBytes,
      secretKey: wrappingKey,
      nonce: _randomBytes(_cipher.nonceLength),
      aad: aad,
    );
    return EncryptedKeyEnvelope(
      nonce: box.nonce,
      cipherText: box.cipherText,
      mac: box.mac.bytes,
    );
  }

  Future<SecretKey> _unwrapDek(
    EncryptedKeyEnvelope envelope, {
    required SecretKey wrappingKey,
    required List<int> aad,
  }) async {
    final clearBytes = await _cipher.decrypt(
      SecretBox(
        envelope.cipherText,
        nonce: envelope.nonce,
        mac: Mac(envelope.mac),
      ),
      secretKey: wrappingKey,
      aad: aad,
    );
    if (clearBytes.length != _keyLength) {
      _eraseBytes(clearBytes);
      throw const FormatException('Invalid group data key length.');
    }
    return SecretKey(clearBytes);
  }

  Uint8List _randomBytes(int length) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _random.nextInt(256)),
    );
  }

  Uint8List _decodeRecoveryKey(String recoveryKey) {
    try {
      final normalized = base64Url.normalize(recoveryKey.trim());
      final bytes = base64Url.decode(normalized);
      if (bytes.length != _keyLength) throw const FormatException();
      return bytes;
    } on FormatException {
      throw const FormatException('Invalid recovery key.');
    }
  }

  void _eraseBytes(List<int> bytes) {
    for (var index = 0; index < bytes.length; index++) {
      bytes[index] = 0;
    }
  }

  List<int> _aad(String groupId, String wrapper) {
    return utf8.encode(
      'michifocus|1|argon2id-aes256gcm-v1|$groupId|dek|$wrapper',
    );
  }

  List<int> _snapshotAad(
    String groupId,
    String snapshotId,
    int createdAtEpochMillis,
  ) {
    return utf8.encode(
      'michifocus|1|aes256gcm-v1|$groupId|$snapshotId|$createdAtEpochMillis|recovery-snapshot',
    );
  }

  List<int> _operationAad(
    String groupId,
    String operationId,
    String originDeviceId,
    int originCounter,
    String payloadSha256,
  ) {
    return utf8.encode(
      'michifocus|1|aes256gcm-v1|$groupId|$originDeviceId|$originCounter|$operationId|$payloadSha256|operation',
    );
  }

  void _validateManifest(SyncGroupKeyManifest manifest) {
    _validateGroupId(manifest.groupId);
    if (manifest.protocolVersion != 1 ||
        manifest.cryptoSuite != 'argon2id-aes256gcm-v1' ||
        manifest.passwordKdf.memoryKiB != _parameters.memoryKiB ||
        manifest.passwordKdf.iterations != _parameters.iterations ||
        manifest.passwordKdf.parallelism != _parameters.parallelism ||
        manifest.passwordKdf.hashLength != _parameters.hashLength ||
        manifest.passwordKdf.salt.length != _saltLength ||
        !_isValidEnvelope(manifest.passwordWrappedDek) ||
        !_isValidEnvelope(manifest.recoveryWrappedDek)) {
      throw const FormatException('Unsupported group cryptography.');
    }
  }

  bool _isValidEnvelope(EncryptedKeyEnvelope envelope) {
    return envelope.nonce.length == _cipher.nonceLength &&
        envelope.cipherText.length == _keyLength &&
        envelope.mac.length == _cipher.macAlgorithm.macLength;
  }

  void _validateGroupId(String groupId) {
    if (!RegExp(r'^group_[a-f0-9]{32}$').hasMatch(groupId)) {
      throw const FormatException('Invalid synchronization group ID.');
    }
  }

  void _validatePassword(String password) {
    if (password.length < minimumPasswordLength) {
      throw ArgumentError.value(
        password.length,
        'password',
        'Use at least $minimumPasswordLength characters.',
      );
    }
  }
}
