import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_incoming_application_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_discovery.dart';

class DriftSyncIncomingApplicationService {
  DriftSyncIncomingApplicationService({
    required DriftSyncExchangeRepository exchangeRepository,
    required SyncOperationDiscovery discovery,
    required SyncGroupCrypto crypto,
    DateTime Function()? clock,
  }) : _exchangeRepository = exchangeRepository,
       _discovery = discovery,
       _crypto = crypto,
       _clock = clock ?? DateTime.now;

  final DriftSyncExchangeRepository _exchangeRepository;
  final SyncOperationDiscovery _discovery;
  final SyncGroupCrypto _crypto;
  final DateTime Function() _clock;

  Future<SyncIncomingApplicationReport> call({
    required String folderUri,
    required String groupId,
    required String localInstallationId,
    required List<int> clearKey,
  }) async {
    if (clearKey.length != 32) {
      throw const FormatException('Invalid group data key.');
    }
    final discovery = await _discovery(
      folderUri: folderUri,
      localInstallationId: localInstallationId,
    );
    final pending = <_IncomingOperation>[];
    var rejected = discovery.rejectedFiles;
    for (final artifact in discovery.operations) {
      try {
        final operation = await _crypto.decryptOperation(
          encrypted: artifact.operation,
          clearKey: clearKey,
        );
        if (operation.groupId != groupId ||
            operation.originDeviceId == localInstallationId) {
          throw const FormatException('Operation does not belong here.');
        }
        pending.add(
          _IncomingOperation(
            operation: operation,
            payloadSha256: artifact.operation.payloadSha256,
          ),
        );
      } on Object {
        rejected++;
      }
    }
    pending.sort(_compareIncoming);

    var applied = 0;
    var duplicates = 0;
    var conflicts = 0;
    var previousPending = -1;
    while (pending.isNotEmpty && pending.length != previousPending) {
      previousPending = pending.length;
      final pass = List<_IncomingOperation>.from(pending);
      pending.clear();
      for (final incoming in pass) {
        try {
          final result = await _apply(incoming);
          switch (result) {
            case RemoteCausalApplyResult.applied:
              applied++;
            case RemoteCausalApplyResult.duplicate:
            case RemoteCausalApplyResult.obsolete:
              duplicates++;
            case RemoteCausalApplyResult.conflicted:
              conflicts++;
            case RemoteCausalApplyResult.deferred:
              pending.add(incoming);
          }
        } on _MissingDependencyException {
          pending.add(incoming);
        } on Object {
          rejected++;
        }
      }
    }
    return SyncIncomingApplicationReport(
      applied: applied,
      duplicates: duplicates,
      conflicts: conflicts,
      deferred: pending.length,
      rejected: rejected,
    );
  }

  Future<RemoteCausalApplyResult> _apply(_IncomingOperation incoming) {
    final operation = incoming.operation;
    return _exchangeRepository.applyRemoteCausalOperation(
      identity: RemoteSyncOperationIdentity(
        operationId: operation.operationId,
        groupId: operation.groupId,
        originDeviceId: operation.originDeviceId,
        originCounter: operation.originCounter,
        payloadSha256: incoming.payloadSha256,
      ),
      entityType: operation.entityType,
      entityId: operation.entityId,
      parentVersion: operation.parentVersion.cast<String, int>(),
      changedFields: operation.entityType == 'routine'
          ? const {'aggregate'}
          : operation.changedFields.keys.toSet(),
      isDelete: operation.operationKind == 'delete',
      isCreate: operation.operationKind == 'create',
      appliedAt: _clock().toUtc(),
      apply: (database, fields, {required applyDelete}) =>
          _applyApplicationData(
            database,
            operation: operation,
            fields: fields,
            applyDelete: applyDelete,
          ),
    );
  }

  Future<void> _applyApplicationData(
    MichiFocusDatabase database, {
    required SyncOperation operation,
    required Set<String> fields,
    required bool applyDelete,
  }) {
    return switch (operation.entityType) {
      'goal' => _applyGoal(database, operation, fields, applyDelete),
      'task' => _applyTask(database, operation, fields, applyDelete),
      'calendarEvent' => _applyCalendar(
        database,
        operation,
        fields,
        applyDelete,
      ),
      'routine' => _applyRoutine(database, operation, fields, applyDelete),
      _ => throw const FormatException('Unsupported entity type.'),
    };
  }

  Future<void> _applyGoal(
    MichiFocusDatabase database,
    SyncOperation operation,
    Set<String> fields,
    bool applyDelete,
  ) async {
    final table = database.goalRecords;
    if (applyDelete) {
      await (database.delete(
        table,
      )..where((row) => row.id.equals(operation.entityId))).go();
      return;
    }
    final values = operation.changedFields;
    final existing = await (database.select(
      table,
    )..where((row) => row.id.equals(operation.entityId))).getSingleOrNull();
    if (existing == null) {
      if (operation.operationKind != 'create') {
        throw const _MissingDependencyException();
      }
      await database
          .into(table)
          .insert(
            GoalRecordsCompanion.insert(
              id: operation.entityId,
              title: _string(values, 'title'),
              targetSessions: _int(values, 'targetSessions'),
              completedSessions: Value(_int(values, 'completedSessions')),
              targetDate: Value(_dateTimeOrNull(values['targetDate'])),
              createdAt: _dateTime(values, 'createdAt'),
              updatedAt: _dateTime(values, 'updatedAt'),
            ),
          );
      return;
    }
    await (database.update(
      table,
    )..where((row) => row.id.equals(operation.entityId))).write(
      GoalRecordsCompanion(
        title: _valueIf(fields, 'title', () => _string(values, 'title')),
        targetSessions: _valueIf(
          fields,
          'targetSessions',
          () => _int(values, 'targetSessions'),
        ),
        completedSessions: _valueIf(
          fields,
          'completedSessions',
          () => _int(values, 'completedSessions'),
        ),
        targetDate: _nullableValueIf(
          fields,
          'targetDate',
          () => _dateTimeOrNull(values['targetDate']),
        ),
        updatedAt: _valueIf(
          fields,
          'updatedAt',
          () => _dateTime(values, 'updatedAt'),
        ),
      ),
    );
  }

  Future<void> _applyTask(
    MichiFocusDatabase database,
    SyncOperation operation,
    Set<String> fields,
    bool applyDelete,
  ) async {
    final table = database.taskRecords;
    if (applyDelete) {
      await (database.delete(
        table,
      )..where((row) => row.id.equals(operation.entityId))).go();
      return;
    }
    final values = operation.changedFields;
    final existing = await (database.select(
      table,
    )..where((row) => row.id.equals(operation.entityId))).getSingleOrNull();
    if (existing == null) {
      if (operation.operationKind != 'create') {
        throw const _MissingDependencyException();
      }
      await database
          .into(table)
          .insert(
            TaskRecordsCompanion.insert(
              id: operation.entityId,
              title: _string(values, 'title'),
              isCompleted: Value(_bool(values, 'isCompleted')),
              status: Value(_taskStatus(values['status'])),
              scheduledDate: Value(_dateTimeOrNull(values['scheduledDate'])),
              goalId: Value(_nullableString(values['goalId'])),
              durationMinutes: Value(_nullableInt(values['durationMinutes'])),
              createdAt: _dateTime(values, 'createdAt'),
              updatedAt: _dateTime(values, 'updatedAt'),
            ),
          );
      return;
    }
    await (database.update(
      table,
    )..where((row) => row.id.equals(operation.entityId))).write(
      TaskRecordsCompanion(
        title: _valueIf(fields, 'title', () => _string(values, 'title')),
        isCompleted: _valueIf(
          fields,
          'isCompleted',
          () => _bool(values, 'isCompleted'),
        ),
        status: _valueIf(
          fields,
          'status',
          () => _taskStatus(values['status']),
        ),
        scheduledDate: _nullableValueIf(
          fields,
          'scheduledDate',
          () => _dateTimeOrNull(values['scheduledDate']),
        ),
        goalId: _nullableValueIf(
          fields,
          'goalId',
          () => _nullableString(values['goalId']),
        ),
        durationMinutes: _nullableValueIf(
          fields,
          'durationMinutes',
          () => _nullableInt(values['durationMinutes']),
        ),
        updatedAt: _valueIf(
          fields,
          'updatedAt',
          () => _dateTime(values, 'updatedAt'),
        ),
      ),
    );
  }

  Future<void> _applyCalendar(
    MichiFocusDatabase database,
    SyncOperation operation,
    Set<String> fields,
    bool applyDelete,
  ) async {
    final table = database.calendarEventRecords;
    if (applyDelete) {
      await (database.delete(
        table,
      )..where((row) => row.id.equals(operation.entityId))).go();
      return;
    }
    final values = operation.changedFields;
    final existing = await (database.select(
      table,
    )..where((row) => row.id.equals(operation.entityId))).getSingleOrNull();
    if (existing == null) {
      if (operation.operationKind != 'create') {
        throw const _MissingDependencyException();
      }
      await database
          .into(table)
          .insert(
            CalendarEventRecordsCompanion.insert(
              id: operation.entityId,
              title: _string(values, 'title'),
              scheduledAt: _dateTime(values, 'scheduledAt'),
              durationMinutes: _int(values, 'durationMinutes'),
              createdAt: _dateTime(values, 'createdAt'),
            ),
          );
      return;
    }
    await (database.update(
      table,
    )..where((row) => row.id.equals(operation.entityId))).write(
      CalendarEventRecordsCompanion(
        title: _valueIf(fields, 'title', () => _string(values, 'title')),
        scheduledAt: _valueIf(
          fields,
          'scheduledAt',
          () => _dateTime(values, 'scheduledAt'),
        ),
        durationMinutes: _valueIf(
          fields,
          'durationMinutes',
          () => _int(values, 'durationMinutes'),
        ),
      ),
    );
  }

  Future<void> _applyRoutine(
    MichiFocusDatabase database,
    SyncOperation operation,
    Set<String> fields,
    bool applyDelete,
  ) async {
    final dao = RoutinesDao(database);
    if (applyDelete) {
      await (database.delete(
        database.routineRecords,
      )..where((row) => row.id.equals(operation.entityId))).go();
      return;
    }
    final values = operation.changedFields;
    if (fields.contains('aggregate') && values['aggregate'] != null) {
      final aggregate = values['aggregate'];
      if (aggregate is! Map<String, dynamic>) {
        throw const FormatException('Invalid routine aggregate.');
      }
      await dao.saveRoutineAggregate(
        routine: RoutineRecordsCompanion.insert(
          id: operation.entityId,
          name: _string(aggregate, 'name'),
          description: Value(_nullableString(aggregate['description'])),
          iconKey: Value(_string(aggregate, 'iconKey')),
          colorKey: Value(_string(aggregate, 'colorKey')),
          status: Value(_routineStatus(aggregate['status'])),
          pausedUntilLocalDate: Value(
            _nullableString(aggregate['pausedUntilLocalDate']),
          ),
          archivedAt: Value(_dateTimeOrNull(aggregate['archivedAt'])),
          createdAt: _dateTime(aggregate, 'createdAt'),
          updatedAt: _dateTime(aggregate, 'updatedAt'),
        ),
        days: _intList(aggregate['weekdays'])
            .map(
              (weekday) => RoutineDayRecordsCompanion.insert(
                routineId: operation.entityId,
                weekday: weekday,
              ),
            )
            .toList(growable: false),
        items: _mapList(aggregate['items'])
            .map(
              (item) => RoutineItemRecordsCompanion.insert(
                id: _string(item, 'id'),
                routineId: operation.entityId,
                position: _int(item, 'position'),
                title: _string(item, 'title'),
                scheduledMinute: _int(item, 'scheduledMinute'),
                durationMinutes: _int(item, 'durationMinutes'),
                goalId: Value(_nullableString(item['goalId'])),
                isOptional: Value(_bool(item, 'isOptional')),
                reminderMinutesBefore: Value(
                  _nullableInt(item['reminderMinutesBefore']),
                ),
                pomodoroMode: Value(_pomodoroMode(item['pomodoroMode'])),
                customFocusMinutes: Value(
                  _nullableInt(item['customFocusMinutes']),
                ),
                customBreakMinutes: Value(
                  _nullableInt(item['customBreakMinutes']),
                ),
                createdAt: _dateTime(item, 'createdAt'),
                updatedAt: _dateTime(item, 'updatedAt'),
              ),
            )
            .toList(growable: false),
      );
      return;
    }
    if (await dao.findRoutineById(operation.entityId) == null) {
      throw const _MissingDependencyException();
    }
    final lifecycleFields = values.keys.toSet();
    await (database.update(
      database.routineRecords,
    )..where((row) => row.id.equals(operation.entityId))).write(
      RoutineRecordsCompanion(
        status: _valueIf(
          lifecycleFields,
          'status',
          () => _routineStatus(values['status']),
        ),
        pausedUntilLocalDate: _nullableValueIf(
          lifecycleFields,
          'pausedUntilLocalDate',
          () => _nullableString(values['pausedUntilLocalDate']),
        ),
        archivedAt: _nullableValueIf(
          lifecycleFields,
          'archivedAt',
          () => _dateTimeOrNull(values['archivedAt']),
        ),
        updatedAt: _valueIf(
          lifecycleFields,
          'updatedAt',
          () => _dateTime(values, 'updatedAt'),
        ),
      ),
    );
  }
}

class _IncomingOperation {
  const _IncomingOperation({
    required this.operation,
    required this.payloadSha256,
  });

  final SyncOperation operation;
  final String payloadSha256;
}

class _MissingDependencyException implements Exception {
  const _MissingDependencyException();
}

int _compareIncoming(_IncomingOperation left, _IncomingOperation right) {
  final priority = _priority(left.operation.entityType).compareTo(
    _priority(right.operation.entityType),
  );
  if (priority != 0) return priority;
  final origin = left.operation.originDeviceId.compareTo(
    right.operation.originDeviceId,
  );
  if (origin != 0) return origin;
  return left.operation.originCounter.compareTo(right.operation.originCounter);
}

int _priority(String entityType) => switch (entityType) {
  'goal' => 0,
  'routine' => 1,
  'task' => 2,
  'calendarEvent' => 3,
  _ => 4,
};

Value<T> _valueIf<T>(Set<String> fields, String field, T Function() value) =>
    fields.contains(field) ? Value(value()) : const Value.absent();

Value<T?> _nullableValueIf<T>(
  Set<String> fields,
  String field,
  T? Function() value,
) => fields.contains(field) ? Value(value()) : const Value.absent();

String _string(Map<String, Object?> values, String key) {
  final value = values[key];
  if (value is! String || value.trim().isEmpty) {
    throw const FormatException();
  }
  return value;
}

String? _nullableString(Object? value) {
  if (value == null) return null;
  if (value is! String) throw const FormatException();
  return value;
}

int _int(Map<String, Object?> values, String key) {
  final value = values[key];
  if (value is! int) throw const FormatException();
  return value;
}

int? _nullableInt(Object? value) {
  if (value == null) return null;
  if (value is! int) throw const FormatException();
  return value;
}

bool _bool(Map<String, Object?> values, String key) {
  final value = values[key];
  if (value is! bool) throw const FormatException();
  return value;
}

DateTime _dateTime(Map<String, Object?> values, String key) =>
    DateTime.fromMillisecondsSinceEpoch(_int(values, key));

DateTime? _dateTimeOrNull(Object? value) {
  if (value == null) return null;
  if (value is! int || value < 1) throw const FormatException();
  return DateTime.fromMillisecondsSinceEpoch(value);
}

String _taskStatus(Object? value) {
  if (value is! String ||
      !const {'listed', 'in_progress', 'completed'}.contains(value)) {
    throw const FormatException();
  }
  return value;
}

String _routineStatus(Object? value) {
  if (value is! String ||
      !const {'active', 'paused', 'archived'}.contains(value)) {
    throw const FormatException();
  }
  return value;
}

String _pomodoroMode(Object? value) {
  if (value is! String ||
      !const {'none', 'recommended', 'custom'}.contains(value)) {
    throw const FormatException();
  }
  return value;
}

List<int> _intList(Object? value) {
  if (value is! List || value.any((item) => item is! int)) {
    throw const FormatException();
  }
  return value.cast<int>();
}

List<Map<String, Object?>> _mapList(Object? value) {
  if (value is! List) throw const FormatException();
  return value
      .map((item) {
        if (item is! Map<String, dynamic>) throw const FormatException();
        return Map<String, Object?>.from(item);
      })
      .toList(growable: false);
}
