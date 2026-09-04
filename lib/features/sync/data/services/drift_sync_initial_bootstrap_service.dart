import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_initial_bootstrap_service.dart';

class DriftSyncInitialBootstrapService {
  DriftSyncInitialBootstrapService({
    required MichiFocusDatabase database,
    required DriftSyncExchangeRepository exchangeRepository,
    required SecureSyncIdGenerator idGenerator,
    DeviceIdentityRepository? identityRepository,
    DateTime Function()? clock,
  }) : _database = database,
       _exchangeRepository = exchangeRepository,
       _idGenerator = idGenerator,
       _identityRepository = identityRepository,
       _clock = clock ?? DateTime.now;

  final MichiFocusDatabase _database;
  final DriftSyncExchangeRepository _exchangeRepository;
  final SecureSyncIdGenerator _idGenerator;
  final DeviceIdentityRepository? _identityRepository;
  final DateTime Function() _clock;

  Future<SyncInitialBootstrapReport> call({
    required String groupId,
    required String installationId,
    required int protocolVersion,
  }) async {
    final identity = await _identityRepository?.load();
    final deviceName = identity?.installationId == installationId
        ? identity!.friendlyName
        : '';
    final now = _sqliteDateTime(_clock().toUtc());
    await _exchangeRepository.initializeLocalState(
      groupId: groupId,
      installationId: installationId,
      protocolVersion: protocolVersion,
      now: now,
    );

    final targets = <_BootstrapTarget>[
      for (final id in await _goalIds()) _BootstrapTarget('goal', id),
      for (final id in await _routineIds()) _BootstrapTarget('routine', id),
      for (final id in await _taskIds()) _BootstrapTarget('task', id),
      for (final id in await _calendarIds())
        _BootstrapTarget('calendarEvent', id),
      for (final id in await _quickNoteIds()) _BootstrapTarget('quickNote', id),
    ];
    var queued = 0;
    var skipped = 0;
    for (final target in targets) {
      final didQueue = await _exchangeRepository.enqueueBootstrapCreate(
        groupId: groupId,
        installationId: installationId,
        entityType: target.entityType,
        entityId: target.entityId,
        now: now,
        buildOperation: (database, counter) => _buildOperation(
          database,
          groupId: groupId,
          installationId: installationId,
          target: target,
          counter: counter,
          now: now,
          deviceName: deviceName,
        ),
      );
      didQueue ? queued++ : skipped++;
    }
    return SyncInitialBootstrapReport(queued: queued, skipped: skipped);
  }

  Future<LocalSyncOperationDraft?> _buildOperation(
    MichiFocusDatabase database, {
    required String groupId,
    required String installationId,
    required _BootstrapTarget target,
    required int counter,
    required DateTime now,
    required String deviceName,
  }) async {
    final changedFields = await _changedFields(database, target);
    if (changedFields == null) return null;
    final operation = SyncOperation(
      groupId: groupId,
      operationId: _idGenerator.create('operation'),
      originDeviceId: installationId,
      originCounter: counter,
      entityType: target.entityType,
      entityId: target.entityId,
      parentVersion: const {},
      changedFields: changedFields,
      operationKind: 'create',
      createdAtEpochMillis: now.millisecondsSinceEpoch,
      originDeviceName: deviceName,
      entitySnapshot: changedFields,
    );
    final digest = await Sha256().hash(operation.canonicalBytes());
    return LocalSyncOperationDraft(
      operationId: operation.operationId,
      entityType: target.entityType,
      entityId: target.entityId,
      parentVersionJson: '{}',
      changedFieldsJson: _canonicalJson(changedFields),
      operationKind: 'create',
      payloadSha256: digest.bytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join(),
      originDeviceName: deviceName,
      entitySnapshotJson: _canonicalJson(changedFields),
    );
  }

  Future<Map<String, Object?>?> _changedFields(
    MichiFocusDatabase database,
    _BootstrapTarget target,
  ) async {
    return switch (target.entityType) {
      'goal' => _goalFields(database, target.entityId),
      'routine' => _routineFields(database, target.entityId),
      'task' => _taskFields(database, target.entityId),
      'calendarEvent' => _calendarFields(database, target.entityId),
      'quickNote' => _quickNoteFields(database, target.entityId),
      _ => throw StateError('Unsupported bootstrap entity type.'),
    };
  }

  Future<Map<String, Object?>?> _goalFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final record = await (database.select(
      database.goalRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (record == null) return null;
    return {
      'title': record.title,
      'targetSessions': record.targetSessions,
      'completedSessions': record.completedSessions,
      'targetDate': record.targetDate?.millisecondsSinceEpoch,
      'createdAt': record.createdAt.millisecondsSinceEpoch,
      'updatedAt': record.updatedAt.millisecondsSinceEpoch,
    };
  }

  Future<Map<String, Object?>?> _taskFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final record = await (database.select(
      database.taskRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (record == null) return null;
    return {
      'title': record.title,
      'status': record.status,
      'isCompleted': record.isCompleted,
      'scheduledDate': record.scheduledDate?.millisecondsSinceEpoch,
      'goalId': record.goalId,
      'durationMinutes': record.durationMinutes,
      'createdAt': record.createdAt.millisecondsSinceEpoch,
      'updatedAt': record.updatedAt.millisecondsSinceEpoch,
    };
  }

  Future<Map<String, Object?>?> _calendarFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final record = await (database.select(
      database.calendarEventRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (record == null) return null;
    return {
      'title': record.title,
      'scheduledAt': record.scheduledAt.millisecondsSinceEpoch,
      'durationMinutes': record.durationMinutes,
      'createdAt': record.createdAt.millisecondsSinceEpoch,
    };
  }

  Future<Map<String, Object?>?> _quickNoteFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final record = await (database.select(
      database.quickNoteRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (record == null) return null;
    return {
      'text': record.textContent,
      'isCompleted': record.isCompleted,
      'colorArgb': record.colorArgb,
      'localDate': record.localDate,
      'priority': record.priority,
      'position': record.position,
      'createdAt': record.createdAt.millisecondsSinceEpoch,
      'updatedAt': record.updatedAt.millisecondsSinceEpoch,
    };
  }

  Future<Map<String, Object?>?> _routineFields(
    MichiFocusDatabase database,
    String id,
  ) async {
    final routine = await (database.select(
      database.routineRecords,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (routine == null) return null;
    final days =
        await (database.select(database.routineDayRecords)
              ..where((row) => row.routineId.equals(id))
              ..orderBy([(row) => OrderingTerm.asc(row.weekday)]))
            .get();
    final items =
        await (database.select(database.routineItemRecords)
              ..where((row) => row.routineId.equals(id))
              ..orderBy([(row) => OrderingTerm.asc(row.position)]))
            .get();
    return {
      'aggregate': {
        'name': routine.name,
        'description': routine.description,
        'iconKey': routine.iconKey,
        'colorKey': routine.colorKey,
        'customColorArgb': routine.customColorArgb,
        'validFromLocalDate': routine.validFromLocalDate,
        'validUntilLocalDate': routine.validUntilLocalDate,
        'status': routine.status,
        'pausedUntilLocalDate': routine.pausedUntilLocalDate,
        'archivedAt': routine.archivedAt?.millisecondsSinceEpoch,
        'createdAt': routine.createdAt.millisecondsSinceEpoch,
        'updatedAt': routine.updatedAt.millisecondsSinceEpoch,
        'weekdays': days.map((day) => day.weekday).toList(growable: false),
        'items': items
            .map(
              (item) => {
                'id': item.id,
                'position': item.position,
                'title': item.title,
                'scheduledMinute': item.scheduledMinute,
                'durationMinutes': item.durationMinutes,
                'goalId': item.goalId,
                'isOptional': item.isOptional,
                'reminderMinutesBefore': item.reminderMinutesBefore,
                'pomodoroMode': item.pomodoroMode,
                'customFocusMinutes': item.customFocusMinutes,
                'customBreakMinutes': item.customBreakMinutes,
                'createdAt': item.createdAt.millisecondsSinceEpoch,
                'updatedAt': item.updatedAt.millisecondsSinceEpoch,
              },
            )
            .toList(growable: false),
      },
    };
  }

  Future<List<String>> _goalIds() async =>
      (await (_database.select(
            _database.goalRecords,
          )..orderBy([(row) => OrderingTerm.asc(row.id)])).get())
          .map((row) => row.id)
          .toList(growable: false);

  Future<List<String>> _taskIds() async =>
      (await (_database.select(
            _database.taskRecords,
          )..orderBy([(row) => OrderingTerm.asc(row.id)])).get())
          .map((row) => row.id)
          .toList(growable: false);

  Future<List<String>> _calendarIds() async =>
      (await (_database.select(
            _database.calendarEventRecords,
          )..orderBy([(row) => OrderingTerm.asc(row.id)])).get())
          .map((row) => row.id)
          .toList(growable: false);

  Future<List<String>> _routineIds() async =>
      (await (_database.select(
            _database.routineRecords,
          )..orderBy([(row) => OrderingTerm.asc(row.id)])).get())
          .map((row) => row.id)
          .toList(growable: false);

  Future<List<String>> _quickNoteIds() async =>
      (await (_database.select(
            _database.quickNoteRecords,
          )..orderBy([(row) => OrderingTerm.asc(row.id)])).get())
          .map((row) => row.id)
          .toList(growable: false);

  String _canonicalJson(Map<String, Object?> source) {
    final keys = source.keys.toList()..sort();
    return jsonEncode({for (final key in keys) key: source[key]});
  }

  DateTime _sqliteDateTime(DateTime value) =>
      DateTime.fromMillisecondsSinceEpoch(
        (value.millisecondsSinceEpoch ~/ 1000) * 1000,
        isUtc: true,
      );
}

class _BootstrapTarget {
  const _BootstrapTarget(this.entityType, this.entityId);

  final String entityType;
  final String entityId;
}
