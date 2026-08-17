import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_incoming_application_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_discovery.dart';

void main() {
  late MichiFocusDatabase database;
  late DriftSyncExchangeRepository exchange;
  late SyncGroupCrypto crypto;
  late List<DiscoveredSyncOperation> discovered;
  late DriftSyncIncomingApplicationService service;
  final now = DateTime.utc(2026, 8, 15, 12);

  setUp(() async {
    database = MichiFocusDatabase(NativeDatabase.memory());
    exchange = DriftSyncExchangeRepository(database);
    crypto = SyncGroupCrypto();
    discovered = [];
    await exchange.initializeLocalState(
      groupId: _groupId,
      installationId: _localId,
      protocolVersion: 1,
      now: now,
    );
    service = DriftSyncIncomingApplicationService(
      exchangeRepository: exchange,
      discovery: ({required folderUri, required localInstallationId}) async =>
          SyncOperationDiscoveryReport(
            operations: discovered,
            rejectedFiles: 0,
          ),
      crypto: crypto,
      clock: () => now,
    );
  });

  tearDown(() => database.close());

  test('applies encrypted task and routine operations exactly once', () async {
    discovered = [
      await _encrypt(
        crypto,
        SyncOperation(
          groupId: _groupId,
          operationId: _operationId('1'),
          originDeviceId: _remoteId,
          originCounter: 1,
          entityType: 'task',
          entityId: 'task-remote',
          parentVersion: const {},
          changedFields: {
            'title': 'Preparar informe',
            'status': 'listed',
            'isCompleted': false,
            'scheduledDate': null,
            'goalId': null,
            'durationMinutes': 25,
            'createdAt': now.millisecondsSinceEpoch,
            'updatedAt': now.millisecondsSinceEpoch,
          },
          operationKind: 'create',
          createdAtEpochMillis: now.millisecondsSinceEpoch,
        ),
      ),
      await _encrypt(
        crypto,
        SyncOperation(
          groupId: _groupId,
          operationId: _operationId('2'),
          originDeviceId: _remoteId,
          originCounter: 2,
          entityType: 'routine',
          entityId: 'routine-remote',
          parentVersion: const {},
          changedFields: {
            'aggregate': {
              'name': 'Mañana tranquila',
              'description': null,
              'iconKey': 'sun',
              'colorKey': 'mint',
              'status': 'active',
              'pausedUntilLocalDate': null,
              'archivedAt': null,
              'createdAt': now.millisecondsSinceEpoch,
              'updatedAt': now.millisecondsSinceEpoch,
              'weekdays': [1, 2, 3, 4, 5],
              'items': [
                {
                  'id': 'routine-item-remote',
                  'position': 0,
                  'title': 'Ordenar escritorio',
                  'scheduledMinute': 480,
                  'durationMinutes': 10,
                  'goalId': null,
                  'isOptional': false,
                  'reminderMinutesBefore': null,
                  'pomodoroMode': 'none',
                  'customFocusMinutes': null,
                  'customBreakMinutes': null,
                  'createdAt': now.millisecondsSinceEpoch,
                  'updatedAt': now.millisecondsSinceEpoch,
                },
              ],
            },
          },
          operationKind: 'create',
          createdAtEpochMillis: now.millisecondsSinceEpoch,
        ),
      ),
    ];

    final first = await service.call(
      folderUri: 'content://sync',
      groupId: _groupId,
      localInstallationId: _localId,
      clearKey: _clearKey,
    );
    final second = await service.call(
      folderUri: 'content://sync',
      groupId: _groupId,
      localInstallationId: _localId,
      clearKey: _clearKey,
    );

    expect(first.applied, 2);
    expect(first.rejected, 0);
    expect(second.duplicates, 2);
    expect(
      (await TasksDao(database).findById('task-remote'))?.title,
      'Preparar informe',
    );
    expect(
      (await RoutinesDao(database).findRoutineById('routine-remote'))?.name,
      'Mañana tranquila',
    );
    expect(
      await RoutinesDao(database).getItemsForRoutine('routine-remote'),
      hasLength(1),
    );
  });
}

Future<DiscoveredSyncOperation> _encrypt(
  SyncGroupCrypto crypto,
  SyncOperation operation,
) async {
  final encrypted = await crypto.encryptOperation(
    operation: operation,
    clearKey: _clearKey,
  );
  final counter = operation.originCounter.toString().padLeft(20, '0');
  return DiscoveredSyncOperation(
    relativePath:
        'michifocus-op-${_remoteId.substring('installation_'.length)}-$counter-'
        '${operation.operationId.substring('operation_'.length)}.v1.json',
    operation: encrypted,
  );
}

String _operationId(String suffix) => 'operation_${suffix.padLeft(32, '0')}';

const _groupId = 'group_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const _localId = 'installation_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
const _remoteId = 'installation_cccccccccccccccccccccccccccccccc';
final _clearKey = List<int>.generate(32, (index) => index + 1);
