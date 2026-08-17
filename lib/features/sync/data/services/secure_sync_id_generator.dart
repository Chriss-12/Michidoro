import 'dart:math';

class SecureSyncIdGenerator {
  SecureSyncIdGenerator({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  String create(String scope) {
    final normalizedScope = scope.trim().toLowerCase();
    if (!RegExp(r'^[a-z][a-z0-9-]*$').hasMatch(normalizedScope)) {
      throw ArgumentError.value(
        scope,
        'scope',
        'Use lowercase letters, numbers, and hyphens.',
      );
    }
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    final encoded = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${normalizedScope}_$encoded';
  }
}
