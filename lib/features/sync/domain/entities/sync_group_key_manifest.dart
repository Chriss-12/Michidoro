import 'dart:convert';

class EncryptedKeyEnvelope {
  const EncryptedKeyEnvelope({
    required this.nonce,
    required this.cipherText,
    required this.mac,
  });

  factory EncryptedKeyEnvelope.fromJson(Map<String, dynamic> json) {
    return EncryptedKeyEnvelope(
      nonce: base64Url.decode(_requiredString(json, 'nonce')),
      cipherText: base64Url.decode(_requiredString(json, 'cipherText')),
      mac: base64Url.decode(_requiredString(json, 'mac')),
    );
  }

  final List<int> nonce;
  final List<int> cipherText;
  final List<int> mac;

  Map<String, Object> toJson() => {
    'nonce': base64UrlEncode(nonce),
    'cipherText': base64UrlEncode(cipherText),
    'mac': base64UrlEncode(mac),
  };
}

class PasswordKdfParameters {
  const PasswordKdfParameters({
    required this.salt,
    required this.memoryKiB,
    required this.iterations,
    required this.parallelism,
    required this.hashLength,
  });

  factory PasswordKdfParameters.fromJson(Map<String, dynamic> json) {
    if (json['algorithm'] != 'argon2id' || json['version'] != 19) {
      throw const FormatException('Unsupported password KDF.');
    }
    return PasswordKdfParameters(
      salt: base64Url.decode(_requiredString(json, 'salt')),
      memoryKiB: _requiredPositiveInt(json, 'memoryKiB'),
      iterations: _requiredPositiveInt(json, 'iterations'),
      parallelism: _requiredPositiveInt(json, 'parallelism'),
      hashLength: _requiredPositiveInt(json, 'hashLength'),
    );
  }

  final List<int> salt;
  final int memoryKiB;
  final int iterations;
  final int parallelism;
  final int hashLength;

  Map<String, Object> toJson() => {
    'algorithm': 'argon2id',
    'version': 19,
    'salt': base64UrlEncode(salt),
    'memoryKiB': memoryKiB,
    'iterations': iterations,
    'parallelism': parallelism,
    'hashLength': hashLength,
  };
}

class SyncGroupKeyManifest {
  const SyncGroupKeyManifest({
    required this.groupId,
    required this.passwordKdf,
    required this.passwordWrappedDek,
    required this.recoveryWrappedDek,
    this.protocolVersion = 1,
    this.cryptoSuite = 'argon2id-aes256gcm-v1',
  });

  factory SyncGroupKeyManifest.fromJson(Map<String, dynamic> json) {
    if (json['protocolVersion'] != 1 ||
        json['cryptoSuite'] != 'argon2id-aes256gcm-v1') {
      throw const FormatException('Unsupported synchronization crypto suite.');
    }
    return SyncGroupKeyManifest(
      groupId: _requiredString(json, 'groupId'),
      passwordKdf: PasswordKdfParameters.fromJson(
        _requiredMap(json, 'passwordKdf'),
      ),
      passwordWrappedDek: EncryptedKeyEnvelope.fromJson(
        _requiredMap(json, 'passwordWrappedDek'),
      ),
      recoveryWrappedDek: EncryptedKeyEnvelope.fromJson(
        _requiredMap(json, 'recoveryWrappedDek'),
      ),
    );
  }

  final int protocolVersion;
  final String cryptoSuite;
  final String groupId;
  final PasswordKdfParameters passwordKdf;
  final EncryptedKeyEnvelope passwordWrappedDek;
  final EncryptedKeyEnvelope recoveryWrappedDek;

  Map<String, Object> toJson() => {
    'protocolVersion': protocolVersion,
    'cryptoSuite': cryptoSuite,
    'groupId': groupId,
    'passwordKdf': passwordKdf.toJson(),
    'passwordWrappedDek': passwordWrappedDek.toJson(),
    'recoveryWrappedDek': recoveryWrappedDek.toJson(),
  };
}

class CreatedSyncGroupKeys {
  const CreatedSyncGroupKeys({
    required this.manifest,
    required this.recoveryKey,
  });

  final SyncGroupKeyManifest manifest;
  final String recoveryKey;
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Missing $key.');
  }
  return value;
}

int _requiredPositiveInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int || value <= 0) throw FormatException('Invalid $key.');
  return value;
}

Map<String, dynamic> _requiredMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map<String, dynamic>) throw FormatException('Invalid $key.');
  return value;
}
