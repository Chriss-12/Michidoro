import 'package:pomodoro_app_v1/features/sync/domain/entities/local_unlock_policy.dart';

abstract interface class LocalUnlockPolicyRepository {
  Future<LocalUnlockPolicy> load();

  Future<void> save(LocalUnlockPolicy policy);
}
