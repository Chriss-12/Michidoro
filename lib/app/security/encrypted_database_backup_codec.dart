import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class EncryptedDatabaseBackupException implements Exception {
  const EncryptedDatabaseBackupException();
}

class BackupMasterKeyMaterial {
  const BackupMasterKeyMaterial({
    required this.clearKey,
    required this.recoveryEnvelope,
  });

  final List<int> clearKey;
  final Map<String, Object> recoveryEnvelope;
}

class DecryptedMasterDatabaseBackup extends BackupMasterKeyMaterial {
  const DecryptedMasterDatabaseBackup({
    required super.clearKey,
    required super.recoveryEnvelope,
    required this.databaseBytes,
  });

  final List<int> databaseBytes;
}

class EncryptedDatabaseBackupParameters {
  const EncryptedDatabaseBackupParameters({
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

class EncryptedDatabaseBackupCodec {
  EncryptedDatabaseBackupCodec({
    EncryptedDatabaseBackupParameters parameters =
        const EncryptedDatabaseBackupParameters(),
    Random? random,
  }) : _parameters = parameters,
       _random = random ?? Random.secure();

  static const minimumPasswordLength = 12;
  static const _format = 'michifocus-encrypted-backup';
  static const _version = 1;
  static const _masterVersion = 2;
  static const _saltLength = 16;

  final EncryptedDatabaseBackupParameters _parameters;
  final Random _random;
  final Cipher _cipher = AesGcm.with256bits();

  Future<List<int>> encrypt({
    required List<int> databaseBytes,
    required String password,
  }) async {
    _validatePassword(password);
    if (databaseBytes.isEmpty) {
      throw const EncryptedDatabaseBackupException();
    }
    final salt = _randomBytes(_saltLength);
    final box = await _cipher.encrypt(
      databaseBytes,
      secretKey: await _deriveKey(password, salt),
      nonce: _randomBytes(_cipher.nonceLength),
      aad: _aad,
    );
    return utf8.encode(
      jsonEncode(<String, Object>{
        'format': _format,
        'version': _version,
        'kdf': <String, Object>{
          'name': 'argon2id',
          'memoryKiB': _parameters.memoryKiB,
          'iterations': _parameters.iterations,
          'parallelism': _parameters.parallelism,
          'hashLength': _parameters.hashLength,
          'salt': base64UrlEncode(salt),
        },
        'cipher': <String, Object>{
          'name': 'aes-256-gcm',
          'nonce': base64UrlEncode(box.nonce),
          'cipherText': base64Encode(box.cipherText),
          'mac': base64UrlEncode(box.mac.bytes),
        },
      }),
    );
  }

  Future<List<int>> decrypt({
    required List<int> encryptedBytes,
    required String password,
  }) async {
    _validatePassword(password);
    try {
      final decoded = jsonDecode(utf8.decode(encryptedBytes));
      if (decoded is! Map<String, dynamic> ||
          decoded['format'] != _format ||
          decoded['version'] != _version) {
        throw const EncryptedDatabaseBackupException();
      }
      final kdf = decoded['kdf'];
      final cipher = decoded['cipher'];
      if (kdf is! Map<String, dynamic> ||
          cipher is! Map<String, dynamic> ||
          kdf['name'] != 'argon2id' ||
          cipher['name'] != 'aes-256-gcm' ||
          kdf['memoryKiB'] != _parameters.memoryKiB ||
          kdf['iterations'] != _parameters.iterations ||
          kdf['parallelism'] != _parameters.parallelism ||
          kdf['hashLength'] != _parameters.hashLength) {
        throw const EncryptedDatabaseBackupException();
      }
      final salt = base64Url.decode(base64Url.normalize(kdf['salt'] as String));
      final nonce = base64Url.decode(
        base64Url.normalize(cipher['nonce'] as String),
      );
      final cipherText = base64Decode(cipher['cipherText'] as String);
      final mac = base64Url.decode(
        base64Url.normalize(cipher['mac'] as String),
      );
      if (salt.length != _saltLength ||
          nonce.length != _cipher.nonceLength ||
          mac.length != _cipher.macAlgorithm.macLength ||
          cipherText.isEmpty) {
        throw const EncryptedDatabaseBackupException();
      }
      return await _cipher.decrypt(
        SecretBox(cipherText, nonce: nonce, mac: Mac(mac)),
        secretKey: await _deriveKey(password, salt),
        aad: _aad,
      );
    } on EncryptedDatabaseBackupException {
      rethrow;
    } on Object {
      throw const EncryptedDatabaseBackupException();
    }
  }

  Future<BackupMasterKeyMaterial> createMasterKey(String password) async {
    _validatePassword(password);
    final clearKey = _randomBytes(32);
    final salt = _randomBytes(_saltLength);
    final box = await _cipher.encrypt(
      clearKey,
      secretKey: await _deriveKey(password, salt),
      nonce: _randomBytes(_cipher.nonceLength),
      aad: _masterKeyAad,
    );
    return BackupMasterKeyMaterial(
      clearKey: clearKey,
      recoveryEnvelope: <String, Object>{
        'version': 1,
        'kdf': <String, Object>{
          'name': 'argon2id',
          'memoryKiB': _parameters.memoryKiB,
          'iterations': _parameters.iterations,
          'parallelism': _parameters.parallelism,
          'hashLength': _parameters.hashLength,
          'salt': base64UrlEncode(salt),
        },
        'cipher': <String, Object>{
          'name': 'aes-256-gcm',
          'nonce': base64UrlEncode(box.nonce),
          'cipherText': base64Encode(box.cipherText),
          'mac': base64UrlEncode(box.mac.bytes),
        },
      },
    );
  }

  Future<List<int>> unlockMasterKey({
    required Map<String, dynamic> recoveryEnvelope,
    required String password,
  }) async {
    _validatePassword(password);
    try {
      final kdf = recoveryEnvelope['kdf'];
      final cipher = recoveryEnvelope['cipher'];
      if (recoveryEnvelope['version'] != 1 ||
          kdf is! Map<String, dynamic> ||
          cipher is! Map<String, dynamic> ||
          kdf['name'] != 'argon2id' ||
          cipher['name'] != 'aes-256-gcm' ||
          kdf['memoryKiB'] != _parameters.memoryKiB ||
          kdf['iterations'] != _parameters.iterations ||
          kdf['parallelism'] != _parameters.parallelism ||
          kdf['hashLength'] != _parameters.hashLength) {
        throw const EncryptedDatabaseBackupException();
      }
      final salt = base64Url.decode(base64Url.normalize(kdf['salt'] as String));
      final nonce = base64Url.decode(
        base64Url.normalize(cipher['nonce'] as String),
      );
      final cipherText = base64Decode(cipher['cipherText'] as String);
      final mac = base64Url.decode(
        base64Url.normalize(cipher['mac'] as String),
      );
      if (salt.length != _saltLength ||
          nonce.length != _cipher.nonceLength ||
          mac.length != _cipher.macAlgorithm.macLength ||
          cipherText.isEmpty) {
        throw const EncryptedDatabaseBackupException();
      }
      final clearKey = await _cipher.decrypt(
        SecretBox(cipherText, nonce: nonce, mac: Mac(mac)),
        secretKey: await _deriveKey(password, salt),
        aad: _masterKeyAad,
      );
      if (clearKey.length != 32) {
        throw const EncryptedDatabaseBackupException();
      }
      return clearKey;
    } on EncryptedDatabaseBackupException {
      rethrow;
    } on Object {
      throw const EncryptedDatabaseBackupException();
    }
  }

  Future<List<int>> encryptWithMasterKey({
    required List<int> databaseBytes,
    required List<int> clearKey,
    required Map<String, Object> recoveryEnvelope,
  }) async {
    if (databaseBytes.isEmpty || clearKey.length != 32) {
      throw const EncryptedDatabaseBackupException();
    }
    final box = await _cipher.encrypt(
      databaseBytes,
      secretKey: SecretKey(clearKey),
      nonce: _randomBytes(_cipher.nonceLength),
      aad: _masterBackupAad(recoveryEnvelope),
    );
    return utf8.encode(
      jsonEncode(<String, Object>{
        'format': _format,
        'version': _masterVersion,
        'recovery': recoveryEnvelope,
        'cipher': <String, Object>{
          'name': 'aes-256-gcm',
          'nonce': base64UrlEncode(box.nonce),
          'cipherText': base64Encode(box.cipherText),
          'mac': base64UrlEncode(box.mac.bytes),
        },
      }),
    );
  }

  Future<DecryptedMasterDatabaseBackup> decryptWithMasterPassword({
    required List<int> encryptedBytes,
    required String password,
  }) async {
    try {
      final decoded = jsonDecode(utf8.decode(encryptedBytes));
      if (decoded is! Map<String, dynamic> ||
          decoded['format'] != _format ||
          decoded['version'] != _masterVersion ||
          decoded['recovery'] is! Map<String, dynamic> ||
          decoded['cipher'] is! Map<String, dynamic>) {
        throw const EncryptedDatabaseBackupException();
      }
      final recovery = decoded['recovery'] as Map<String, dynamic>;
      final cipher = decoded['cipher'] as Map<String, dynamic>;
      if (cipher['name'] != 'aes-256-gcm') {
        throw const EncryptedDatabaseBackupException();
      }
      final clearKey = await unlockMasterKey(
        recoveryEnvelope: recovery,
        password: password,
      );
      final databaseBytes = await _cipher.decrypt(
        SecretBox(
          base64Decode(cipher['cipherText'] as String),
          nonce: base64Url.decode(
            base64Url.normalize(cipher['nonce'] as String),
          ),
          mac: Mac(
            base64Url.decode(base64Url.normalize(cipher['mac'] as String)),
          ),
        ),
        secretKey: SecretKey(clearKey),
        aad: _masterBackupAad(recovery),
      );
      return DecryptedMasterDatabaseBackup(
        clearKey: clearKey,
        recoveryEnvelope: Map<String, Object>.from(recovery),
        databaseBytes: databaseBytes,
      );
    } on EncryptedDatabaseBackupException {
      rethrow;
    } on Object {
      throw const EncryptedDatabaseBackupException();
    }
  }

  Future<SecretKey> _deriveKey(String password, List<int> salt) {
    return Argon2id(
      memory: _parameters.memoryKiB,
      iterations: _parameters.iterations,
      parallelism: _parameters.parallelism,
      hashLength: _parameters.hashLength,
    ).deriveKeyFromPassword(password: password, nonce: salt);
  }

  Uint8List _randomBytes(int length) => Uint8List.fromList(
    List<int>.generate(length, (_) => _random.nextInt(256)),
  );

  List<int> get _aad =>
      utf8.encode('michifocus|backup|v1|argon2id|aes-256-gcm');

  List<int> get _masterKeyAad =>
      utf8.encode('michifocus|backup-master-key|v1|argon2id|aes-256-gcm');

  List<int> _masterBackupAad(Map<String, Object?> recoveryEnvelope) =>
      utf8.encode(
        'michifocus|backup|v2|aes-256-gcm|${jsonEncode(recoveryEnvelope)}',
      );

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
