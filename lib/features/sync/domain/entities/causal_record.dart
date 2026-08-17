import 'package:pomodoro_app_v1/features/sync/domain/entities/causal_field.dart';

class CausalRecord {
  CausalRecord(Map<String, CausalField<Object?>> fields)
    : fields = Map.unmodifiable(fields);

  final Map<String, CausalField<Object?>> fields;

  Set<String> get conflictingFields => {
    for (final entry in fields.entries)
      if (entry.value.hasConflict) entry.key,
  };

  Map<String, Object?> get resolvedValues => {
    for (final entry in fields.entries)
      if (!entry.value.hasConflict) entry.key: entry.value.resolvedValue,
  };

  CausalRecord mergedWith(CausalRecord other) {
    final fieldNames = {...fields.keys, ...other.fields.keys};
    return CausalRecord({
      for (final fieldName in fieldNames)
        fieldName: _mergedField(fields[fieldName], other.fields[fieldName]),
    });
  }

  static CausalField<Object?> _mergedField(
    CausalField<Object?>? first,
    CausalField<Object?>? second,
  ) {
    if (first == null) return second!;
    if (second == null) return first;
    return first.mergedWith(second);
  }
}
