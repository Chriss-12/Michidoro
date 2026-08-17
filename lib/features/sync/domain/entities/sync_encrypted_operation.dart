import 'dart:convert';

class SyncEncryptedOperation {
  const SyncEncryptedOperation({
    required this.groupId,
    required this.operationId,
    required this.originDeviceId,
    required this.originCounter,
    required this.payloadSha256,
    required this.nonce,
    required this.cipherText,
    required this.mac,
  });

  factory SyncEncryptedOperation.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1 || json['cryptoSuite'] != 'aes256gcm-v1') {
      throw const FormatException('Unsupported encrypted operation.');
    }
    return SyncEncryptedOperation(
      groupId: _requiredString(json, 'groupId'),
      operationId: _requiredString(json, 'operationId'),
      originDeviceId: _requiredString(json, 'originDeviceId'),
      originCounter: _requiredPositiveInt(json, 'originCounter'),
      payloadSha256: _requiredString(json, 'payloadSha256'),
      nonce: _decode(json['nonce']),
      cipherText: _decode(json['cipherText']),
      mac: _decode(json['mac']),
    )..validate();
  }

  final String groupId;
  final String operationId;
  final String originDeviceId;
  final int originCounter;
  final String payloadSha256;
  final List<int> nonce;
  final List<int> cipherText;
  final List<int> mac;

  void validate() {
    if (!RegExp(r'^group_[a-f0-9]{32}$').hasMatch(groupId) ||
        !RegExp(r'^operation_[a-f0-9]{32}$').hasMatch(operationId) ||
        !RegExp(r'^installation_[a-f0-9]{32}$').hasMatch(originDeviceId) ||
        originCounter < 1 ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(payloadSha256) ||
        nonce.length != 12 ||
        cipherText.isEmpty ||
        cipherText.length > 256 * 1024 ||
        mac.length != 16) {
      throw const FormatException('Invalid encrypted operation.');
    }
  }

  Map<String, Object> toJson() {
    validate();
    return {
      'version': 1,
      'cryptoSuite': 'aes256gcm-v1',
      'groupId': groupId,
      'operationId': operationId,
      'originDeviceId': originDeviceId,
      'originCounter': originCounter,
      'payloadSha256': payloadSha256,
      'nonce': base64UrlEncode(nonce),
      'cipherText': base64UrlEncode(cipherText),
      'mac': base64UrlEncode(mac),
    };
  }
}

List<int> _decode(Object? value) {
  if (value is! String) throw const FormatException('Invalid bytes.');
  try {
    return base64Url.decode(base64Url.normalize(value));
  } on FormatException {
    throw const FormatException('Invalid bytes.');
  }
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
  if (value is! int || value < 1) throw FormatException('Invalid $key.');
  return value;
}
