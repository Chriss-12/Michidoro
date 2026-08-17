enum CausalRelation { equal, before, after, concurrent }

class CausalVersion {
  CausalVersion([Map<String, int> counters = const {}])
    : counters = Map.unmodifiable(_validatedCounters(counters));

  final Map<String, int> counters;

  int counterFor(String deviceId) => counters[deviceId] ?? 0;

  CausalVersion increment(String deviceId) {
    final normalizedDeviceId = deviceId.trim();
    if (normalizedDeviceId.isEmpty) {
      throw ArgumentError.value(deviceId, 'deviceId', 'Must not be empty.');
    }
    return CausalVersion({
      ...counters,
      normalizedDeviceId: counterFor(normalizedDeviceId) + 1,
    });
  }

  CausalVersion mergedWith(CausalVersion other) {
    final deviceIds = {...counters.keys, ...other.counters.keys};
    return CausalVersion({
      for (final deviceId in deviceIds)
        deviceId: _max(counterFor(deviceId), other.counterFor(deviceId)),
    });
  }

  CausalRelation compareTo(CausalVersion other) {
    var hasLowerCounter = false;
    var hasHigherCounter = false;
    for (final deviceId in {...counters.keys, ...other.counters.keys}) {
      final localCounter = counterFor(deviceId);
      final otherCounter = other.counterFor(deviceId);
      hasLowerCounter = hasLowerCounter || localCounter < otherCounter;
      hasHigherCounter = hasHigherCounter || localCounter > otherCounter;
    }
    if (!hasLowerCounter && !hasHigherCounter) return CausalRelation.equal;
    if (hasLowerCounter && !hasHigherCounter) return CausalRelation.before;
    if (!hasLowerCounter && hasHigherCounter) return CausalRelation.after;
    return CausalRelation.concurrent;
  }

  static Map<String, int> _validatedCounters(Map<String, int> counters) {
    final result = <String, int>{};
    for (final entry in counters.entries) {
      final deviceId = entry.key.trim();
      if (deviceId.isEmpty) {
        throw ArgumentError.value(entry.key, 'counters', 'Device ID is empty.');
      }
      if (entry.value < 0) {
        throw ArgumentError.value(
          entry.value,
          'counters',
          'Counters must not be negative.',
        );
      }
      if (entry.value > 0) result[deviceId] = entry.value;
    }
    return result;
  }

  static int _max(int first, int second) => first > second ? first : second;

  @override
  String toString() => 'CausalVersion($counters)';
}
