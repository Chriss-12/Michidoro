import 'dart:convert';

class SyncEncryptedRecoverySnapshot {
  const SyncEncryptedRecoverySnapshot({
    required this.groupId,
    required this.snapshotId,
    required this.createdAtEpochMillis,
    required this.nonce,
    required this.cipherText,
    required this.mac,
  });

  factory SyncEncryptedRecoverySnapshot.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1 ||
        json['cryptoSuite'] != 'aes256gcm-v1' ||
        json['groupId'] is! String ||
        json['snapshotId'] is! String ||
        json['createdAtEpochMillis'] is! int) {
      throw const FormatException('Invalid recovery snapshot envelope.');
    }
    return SyncEncryptedRecoverySnapshot(
      groupId: json['groupId']! as String,
      snapshotId: json['snapshotId']! as String,
      createdAtEpochMillis: json['createdAtEpochMillis']! as int,
      nonce: _decode(json['nonce']),
      cipherText: _decode(json['cipherText']),
      mac: _decode(json['mac']),
    )..validate();
  }

  final String groupId;
  final String snapshotId;
  final int createdAtEpochMillis;
  final List<int> nonce;
  final List<int> cipherText;
  final List<int> mac;

  void validate() {
    if (!RegExp(r'^group_[a-f0-9]{32}$').hasMatch(groupId) ||
        !RegExp(r'^snapshot_[a-f0-9]{32}$').hasMatch(snapshotId) ||
        createdAtEpochMillis <= 0 ||
        nonce.length != 12 ||
        cipherText.isEmpty ||
        mac.length != 16) {
      throw const FormatException('Invalid recovery snapshot envelope.');
    }
  }

  Map<String, Object> toJson() {
    validate();
    return {
      'version': 1,
      'cryptoSuite': 'aes256gcm-v1',
      'groupId': groupId,
      'snapshotId': snapshotId,
      'createdAtEpochMillis': createdAtEpochMillis,
      'nonce': base64UrlEncode(nonce),
      'cipherText': base64UrlEncode(cipherText),
      'mac': base64UrlEncode(mac),
    };
  }
}

List<int> _decode(Object? value) {
  if (value is! String) {
    throw const FormatException('Invalid recovery snapshot bytes.');
  }
  try {
    return base64Url.decode(base64Url.normalize(value));
  } on FormatException {
    throw const FormatException('Invalid recovery snapshot bytes.');
  }
}
