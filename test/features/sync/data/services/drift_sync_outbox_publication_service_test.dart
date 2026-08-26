import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_outbox_publication_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_encrypted_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_operation.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_publisher.dart';

void main() {
  late MichiFocusDatabase database;
  late DriftSyncExchangeRepository repository;
  late SyncGroupCrypto crypto;
  final now = DateTime.utc(2026, 8, 14, 14, 0, 0, 731);
  final clearKey = List<int>.generate(32, (index) => index);

  setUp(() async {
    database = MichiFocusDatabase(NativeDatabase.memory());
    repository = DriftSyncExchangeRepository(database);
    crypto = SyncGroupCrypto(random: Random(12));
    await repository.initializeLocalState(
      groupId: _groupId,
      installationId: _installationId,
      protocolVersion: 1,
      now: now,
    );
    await repository.commitLocalMutation(
      groupId: _groupId,
      installationId: _installationId,
      entityType: 'goal',
      entityId: _goalId,
      now: now,
      buildOperation: (counter, parentVersion) async {
        final operation = SyncOperation(
          groupId: _groupId,
          operationId: _operationId,
          originDeviceId: _installationId,
          originCounter: counter,
          entityType: 'goal',
          entityId: _goalId,
          parentVersion: parentVersion,
          changedFields: const {'title': 'Private goal'},
          operationKind: 'create',
          createdAtEpochMillis: now.millisecondsSinceEpoch,
        );
        final encrypted = await crypto.encryptOperation(
          operation: operation,
          clearKey: clearKey,
        );
        return LocalSyncOperationDraft(
          operationId: operation.operationId,
          entityType: operation.entityType,
          entityId: operation.entityId,
          parentVersionJson: jsonEncode(parentVersion),
          changedFieldsJson: jsonEncode(operation.changedFields),
          operationKind: operation.operationKind,
          payloadSha256: encrypted.payloadSha256,
        );
      },
      mutate: (_) async {},
    );
  });

  tearDown(() => database.close());

  test(
    'encrypts, publishes, and marks one outbox operation complete',
    () async {
      final publisher = _Publisher();
      final service = DriftSyncOutboxPublicationService(
        repository: repository,
        crypto: crypto,
        publisher: publisher,
        clock: () => now.add(const Duration(minutes: 1)),
      );

      final report = await service(
        folderUri: 'content://tree/michifocus',
        groupId: _groupId,
        installationId: _installationId,
        clearKey: clearKey,
      );

      expect(report.published, 1);
      expect(report.failed, 0);
      expect(report.remaining, 0);
      final encrypted = publisher.published.single;
      expect(
        (await crypto.decryptOperation(
          encrypted: encrypted,
          clearKey: clearKey,
        )).changedFields,
        {'title': 'Private goal'},
      );
      expect(
        (await crypto.decryptOperation(
          encrypted: encrypted,
          clearKey: clearKey,
        )).createdAtEpochMillis,
        now.millisecondsSinceEpoch,
      );
      final stored = await database
          .select(database.syncOutboxRecords)
          .getSingle();
      expect(stored.publicationState, 'published');
      expect(stored.publicationAttempts, 1);
      expect(
        stored.publishedAt?.toUtc(),
        DateTime.utc(2026, 8, 14, 14, 1),
      );
    },
  );

  test('keeps a failed publication visible and retryable', () async {
    final service = DriftSyncOutboxPublicationService(
      repository: repository,
      crypto: crypto,
      publisher: _Publisher(fail: true),
    );

    final report = await service(
      folderUri: 'content://tree/michifocus',
      groupId: _groupId,
      installationId: _installationId,
      clearKey: clearKey,
    );

    expect(report.failed, 1);
    expect(report.remaining, 1);
    final stored = await database
        .select(database.syncOutboxRecords)
        .getSingle();
    expect(stored.publicationState, 'failed');
    expect(stored.publicationAttempts, 1);
  });

  test('rejects a digest that matches no legacy millisecond', () async {
    await database
        .update(database.syncOutboxRecords)
        .write(
          const SyncOutboxRecordsCompanion(
            payloadSha256: Value(
              'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff',
            ),
          ),
        );
    final publisher = _Publisher();
    final service = DriftSyncOutboxPublicationService(
      repository: repository,
      crypto: crypto,
      publisher: publisher,
    );

    final report = await service(
      folderUri: 'content://tree/michifocus',
      groupId: _groupId,
      installationId: _installationId,
      clearKey: clearKey,
    );

    expect(report.failed, 1);
    expect(report.remaining, 1);
    expect(publisher.published, isEmpty);
  });
}

const _groupId = 'group_0123456789abcdef0123456789abcdef';
const _installationId = 'installation_0123456789abcdef0123456789abcdef';
const _operationId = 'operation_0123456789abcdef0123456789abcdef';
const _goalId = 'goal_0123456789abcdef0123456789abcdef';

class _Publisher implements SyncOperationPublisher {
  _Publisher({this.fail = false});

  final bool fail;
  final List<SyncEncryptedOperation> published = [];

  @override
  Future<SyncOperationPublication> publish({
    required String folderUri,
    required SyncEncryptedOperation operation,
  }) async {
    if (fail) throw const SyncOperationFolderUnavailableException();
    published.add(operation);
    return const SyncOperationPublication(
      relativePath: 'operation.json',
      atomicFinalization: true,
    );
  }

  @override
  String relativePathFor(SyncEncryptedOperation operation) => 'operation.json';
}
