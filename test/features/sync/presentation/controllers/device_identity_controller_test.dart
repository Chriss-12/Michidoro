import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/device_identity_controller.dart';

void main() {
  test('creates an automatic identity and model-based name once', () async {
    final repository = _MemoryIdentityRepository();
    final generator = _CountingIdGenerator();
    final controller = DeviceIdentityController(
      repository: repository,
      deviceNameProvider: () async => 'Samsung S23',
      idGenerator: generator,
    );

    await controller.initialize();

    expect(controller.installationId.value, 'installation_generated-once');
    expect(controller.friendlyName.value, 'Samsung S23');
    expect(repository.identity.isInitialized, isTrue);
    expect(generator.calls, 1);
  });

  test('reuses the stored identity on later startups', () async {
    final repository = _MemoryIdentityRepository(
      const DeviceIdentity(
        installationId: 'installation_stable',
        friendlyName: 'Mi teléfono',
      ),
    );
    final generator = _CountingIdGenerator();
    final controller = DeviceIdentityController(
      repository: repository,
      deviceNameProvider: () async => 'Otro modelo',
      idGenerator: generator,
    );

    await controller.initialize();

    expect(controller.installationId.value, 'installation_stable');
    expect(controller.friendlyName.value, 'Mi teléfono');
    expect(generator.calls, 0);
  });

  test('renaming never changes the installation identity', () async {
    final repository = _MemoryIdentityRepository(
      const DeviceIdentity(
        installationId: 'installation_stable',
        friendlyName: 'Nombre anterior',
      ),
    );
    final controller = DeviceIdentityController(repository: repository);
    await controller.initialize();

    await controller.rename('  Teléfono de trabajo  ');

    expect(controller.installationId.value, 'installation_stable');
    expect(controller.friendlyName.value, 'Teléfono de trabajo');
    expect(repository.identity.installationId, 'installation_stable');
  });

  test('rejects an empty rename without changing stored state', () async {
    final repository = _MemoryIdentityRepository(
      const DeviceIdentity(
        installationId: 'installation_stable',
        friendlyName: 'Nombre válido',
      ),
    );
    final controller = DeviceIdentityController(repository: repository);
    await controller.initialize();

    await expectLater(controller.rename('   '), throwsArgumentError);

    expect(controller.friendlyName.value, 'Nombre válido');
    expect(repository.identity.friendlyName, 'Nombre válido');
  });
}

class _MemoryIdentityRepository implements DeviceIdentityRepository {
  _MemoryIdentityRepository([this.identity = const DeviceIdentity()]);

  DeviceIdentity identity;

  @override
  Future<DeviceIdentity> load() async => identity;

  @override
  Future<void> save(DeviceIdentity identity) async {
    this.identity = identity;
  }
}

class _CountingIdGenerator extends SecureSyncIdGenerator {
  int calls = 0;

  @override
  String create(String scope) {
    calls++;
    return '${scope}_generated-once';
  }
}
