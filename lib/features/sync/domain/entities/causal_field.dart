import 'package:pomodoro_app_v1/features/sync/domain/entities/causal_version.dart';

class CausalCandidate<T> {
  const CausalCandidate({
    required this.value,
    required this.version,
    required this.originDeviceId,
    required this.operationId,
  });

  final T value;
  final CausalVersion version;
  final String originDeviceId;
  final String operationId;
}

class CausalField<T> {
  CausalField(Iterable<CausalCandidate<T>> candidates)
    : candidates = List.unmodifiable(_normalize(candidates));

  final List<CausalCandidate<T>> candidates;

  bool get hasConflict => distinctValues.length > 1;

  Set<T> get distinctValues => {
    for (final candidate in candidates) candidate.value,
  };

  T? get resolvedValue {
    final values = distinctValues;
    return values.length == 1 ? values.single : null;
  }

  CausalVersion get joinedVersion {
    return candidates.fold(
      CausalVersion(),
      (current, candidate) => current.mergedWith(candidate.version),
    );
  }

  CausalField<T> mergedWith(CausalField<T> other) {
    return CausalField([...candidates, ...other.candidates]);
  }

  static List<CausalCandidate<T>> _normalize<T>(
    Iterable<CausalCandidate<T>> source,
  ) {
    final byOperationId = <String, CausalCandidate<T>>{};
    for (final candidate in source) {
      if (candidate.operationId.trim().isEmpty) {
        throw ArgumentError.value(
          candidate.operationId,
          'operationId',
          'Must not be empty.',
        );
      }
      if (candidate.originDeviceId.trim().isEmpty) {
        throw ArgumentError.value(
          candidate.originDeviceId,
          'originDeviceId',
          'Must not be empty.',
        );
      }
      final existing = byOperationId[candidate.operationId];
      if (existing != null && !_sameCandidate(existing, candidate)) {
        throw StateError(
          'Operation ${candidate.operationId} has inconsistent payloads.',
        );
      }
      byOperationId[candidate.operationId] = candidate;
    }

    final candidates = byOperationId.values.toList();
    final maximal = candidates.where((candidate) {
      return !candidates.any(
        (other) =>
            !identical(candidate, other) &&
            candidate.version.compareTo(other.version) == CausalRelation.before,
      );
    }).toList();
    return maximal..sort((first, second) {
      final operationOrder = first.operationId.compareTo(second.operationId);
      if (operationOrder != 0) return operationOrder;
      return first.originDeviceId.compareTo(second.originDeviceId);
    });
  }

  static bool _sameCandidate<T>(
    CausalCandidate<T> first,
    CausalCandidate<T> second,
  ) {
    return first.value == second.value &&
        first.version.compareTo(second.version) == CausalRelation.equal &&
        first.originDeviceId == second.originDeviceId;
  }
}
