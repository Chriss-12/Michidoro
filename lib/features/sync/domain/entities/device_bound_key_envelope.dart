class DeviceBoundKeyEnvelope {
  const DeviceBoundKeyEnvelope({
    required this.nonce,
    required this.cipherText,
    this.version = 1,
  });

  factory DeviceBoundKeyEnvelope.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1) {
      throw const FormatException('Unsupported device key envelope.');
    }
    final nonce = json['nonce'];
    final cipherText = json['cipherText'];
    if (nonce is! List ||
        cipherText is! List ||
        nonce.any((value) => value is! int) ||
        cipherText.any((value) => value is! int)) {
      throw const FormatException('Invalid device key envelope.');
    }
    return DeviceBoundKeyEnvelope(
      nonce: nonce.cast<int>(),
      cipherText: cipherText.cast<int>(),
    );
  }

  final int version;
  final List<int> nonce;
  final List<int> cipherText;

  Map<String, Object> toJson() => {
    'version': version,
    'nonce': nonce,
    'cipherText': cipherText,
  };
}
