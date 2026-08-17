import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/device_identity.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_name_provider.dart';
import 'package:signals_flutter/signals_flutter.dart';

class DeviceIdentityController {
  DeviceIdentityController({
    DeviceIdentityRepository? repository,
    DeviceNameProvider? deviceNameProvider,
    SecureSyncIdGenerator? idGenerator,
  }) : _repository = repository,
       _deviceNameProvider = deviceNameProvider,
       _idGenerator = idGenerator ?? SecureSyncIdGenerator();

  final DeviceIdentityRepository? _repository;
  final DeviceNameProvider? _deviceNameProvider;
  final SecureSyncIdGenerator _idGenerator;

  final FlutterSignal<String> installationId = signal('');
  final FlutterSignal<String> friendlyName = signal('');

  String get shortInstallationId {
    final value = installationId.value;
    if (value.length <= 8) return value;
    return value.substring(value.length - 8);
  }

  Future<void> initialize() async {
    final stored = await _repository?.load() ?? const DeviceIdentity();
    final storedId = stored.installationId.trim();
    final generatedId = storedId.isEmpty
        ? _idGenerator.create('installation')
        : storedId;
    final storedName = stored.friendlyName.trim();
    final suggestedName = storedName.isEmpty
        ? await _deviceNameProvider?.call()
        : null;
    final next = DeviceIdentity(
      installationId: generatedId,
      friendlyName: storedName.isNotEmpty
          ? storedName
          : (suggestedName ?? 'Teléfono Android'),
    ).normalized();

    if (next.installationId != stored.installationId ||
        next.friendlyName != stored.friendlyName) {
      await _repository?.save(next);
    }
    _apply(next);
  }

  Future<void> rename(String nextName) async {
    final normalized = DeviceIdentity(
      installationId: installationId.value,
      friendlyName: nextName,
    ).normalized();
    if (normalized.friendlyName.isEmpty) {
      throw ArgumentError.value(nextName, 'nextName', 'Name cannot be empty.');
    }

    await _repository?.save(normalized);
    _apply(normalized);
  }

  void _apply(DeviceIdentity identity) {
    batch(() {
      installationId.value = identity.installationId;
      friendlyName.value = identity.friendlyName;
    });
  }
}
