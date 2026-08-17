import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/causal_field.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/causal_record.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/causal_version.dart';

void main() {
  group('CausalVersion', () {
    test('classifies equal, before, after, and concurrent versions', () {
      final base = CausalVersion({'phone-a': 1});
      final fromA = base.increment('phone-a');
      final fromB = base.increment('phone-b');

      expect(
        base.compareTo(CausalVersion({'phone-a': 1})),
        CausalRelation.equal,
      );
      expect(base.compareTo(fromA), CausalRelation.before);
      expect(fromA.compareTo(base), CausalRelation.after);
      expect(fromA.compareTo(fromB), CausalRelation.concurrent);
    });

    test('merges counters without using wall-clock time', () {
      final merged = CausalVersion({
        'phone-a': 7,
        'phone-b': 2,
      }).mergedWith(CausalVersion({'phone-a': 3, 'phone-c': 9}));

      expect(merged.counters, {'phone-a': 7, 'phone-b': 2, 'phone-c': 9});
    });
  });

  group('causal record merge', () {
    test('combines concurrent edits to different fields automatically', () {
      final baseVersion = CausalVersion({'phone-a': 1});
      final base = _record(
        title: _candidate('Read', baseVersion, 'phone-a', 'base-title'),
        duration: _candidate(25, baseVersion, 'phone-a', 'base-duration'),
      );
      final phoneA = _replace(
        base,
        'title',
        _candidate(
          'Read 30 minutes',
          baseVersion.increment('phone-a'),
          'phone-a',
          'a-title',
        ),
      );
      final phoneB = _replace(
        base,
        'duration',
        _candidate(
          45,
          baseVersion.increment('phone-b'),
          'phone-b',
          'b-duration',
        ),
      );

      final merged = phoneA.mergedWith(phoneB);

      expect(merged.conflictingFields, isEmpty);
      expect(merged.resolvedValues, {
        'title': 'Read 30 minutes',
        'duration': 45,
      });
    });

    test('retains both concurrent values for the same field', () {
      final baseVersion = CausalVersion({'phone-a': 1});
      final phoneA = CausalRecord({
        'title': CausalField([
          _candidate(
            'Read 30 minutes',
            baseVersion.increment('phone-a'),
            'phone-a',
            'a-title',
          ),
        ]),
      });
      final phoneB = CausalRecord({
        'title': CausalField([
          _candidate(
            'Read one chapter',
            baseVersion.increment('phone-b'),
            'phone-b',
            'b-title',
          ),
        ]),
      });

      final merged = phoneA.mergedWith(phoneB);

      expect(merged.conflictingFields, {'title'});
      expect(merged.fields['title']!.distinctValues, {
        'Read 30 minutes',
        'Read one chapter',
      });
    });

    test('is idempotent when the same operation arrives repeatedly', () {
      final candidate = _candidate(
        'Read',
        CausalVersion({'phone-a': 1}),
        'phone-a',
        'operation-a',
      );
      final record = CausalRecord({
        'title': CausalField([candidate]),
      });

      final merged = record.mergedWith(record).mergedWith(record);

      expect(merged.fields['title']!.candidates, hasLength(1));
      expect(merged.resolvedValues['title'], 'Read');
    });

    test('converges for four-device delivery permutations', () {
      final baseVersion = CausalVersion({'phone-a': 1});
      final records = <CausalRecord>[
        CausalRecord({
          'title': CausalField([
            _candidate('Read', baseVersion, 'phone-a', 'base-title'),
          ]),
        }),
        CausalRecord({
          'duration': CausalField([
            _candidate(
              45,
              baseVersion.increment('phone-b'),
              'phone-b',
              'b-duration',
            ),
          ]),
        }),
        CausalRecord({
          'scheduledDay': CausalField([
            _candidate(
              '2026-08-14',
              baseVersion.increment('phone-c'),
              'phone-c',
              'c-day',
            ),
          ]),
        }),
        CausalRecord({
          'goalId': CausalField([
            _candidate(
              'goal-7',
              baseVersion.increment('phone-d'),
              'phone-d',
              'd-goal',
            ),
          ]),
        }),
      ];
      final expected = _mergeAll(records).resolvedValues;

      for (final order in _permutations(records)) {
        final withDuplicate = [...order, order.first];
        final result = _mergeAll(withDuplicate);
        expect(result.conflictingFields, isEmpty);
        expect(result.resolvedValues, expected);
      }
    });

    test('keeps conflict candidates stable for every delivery order', () {
      final base = CausalVersion({'phone-a': 1});
      final variants = <CausalRecord>[
        CausalRecord({
          'title': CausalField([
            _candidate(
              'Read 30 minutes',
              base.increment('phone-a'),
              'phone-a',
              'a-title',
            ),
          ]),
        }),
        CausalRecord({
          'title': CausalField([
            _candidate(
              'Read one chapter',
              base.increment('phone-b'),
              'phone-b',
              'b-title',
            ),
          ]),
        }),
        CausalRecord({
          'duration': CausalField([
            _candidate(
              50,
              base.increment('phone-c'),
              'phone-c',
              'c-duration',
            ),
          ]),
        }),
      ];

      for (final order in _permutations(variants)) {
        final result = _mergeAll(order);
        expect(result.conflictingFields, {'title'});
        expect(
          result.fields['title']!.candidates.map((item) => item.operationId),
          ['a-title', 'b-title'],
        );
        expect(result.resolvedValues['duration'], 50);
      }
    });
  });

  group('SecureSyncIdGenerator', () {
    test('creates scoped, clock-independent 128-bit identifiers', () {
      final generator = SecureSyncIdGenerator(random: Random(7));
      final ids = {
        for (var index = 0; index < 4000; index++) generator.create('task'),
      };

      expect(ids, hasLength(4000));
      expect(ids, everyElement(matches(RegExp(r'^task_[0-9a-f]{32}$'))));
    });

    test('rejects unsafe scopes', () {
      final generator = SecureSyncIdGenerator(random: Random(1));

      expect(() => generator.create('../task'), throwsArgumentError);
      expect(() => generator.create(''), throwsArgumentError);
    });
  });
}

CausalCandidate<Object?> _candidate(
  Object? value,
  CausalVersion version,
  String deviceId,
  String operationId,
) {
  return CausalCandidate(
    value: value,
    version: version,
    originDeviceId: deviceId,
    operationId: operationId,
  );
}

CausalRecord _record({
  required CausalCandidate<Object?> title,
  required CausalCandidate<Object?> duration,
}) {
  return CausalRecord({
    'title': CausalField([title]),
    'duration': CausalField([duration]),
  });
}

CausalRecord _replace(
  CausalRecord record,
  String field,
  CausalCandidate<Object?> candidate,
) {
  return CausalRecord({
    ...record.fields,
    field: CausalField([candidate]),
  });
}

CausalRecord _mergeAll(Iterable<CausalRecord> records) {
  return records.reduce((current, next) => current.mergedWith(next));
}

Iterable<List<T>> _permutations<T>(List<T> values) sync* {
  if (values.length <= 1) {
    yield values;
    return;
  }

  for (var index = 0; index < values.length; index++) {
    final remaining = [...values]..removeAt(index);
    for (final suffix in _permutations(remaining)) {
      yield [values[index], ...suffix];
    }
  }
}
