import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';

abstract interface class SyncGroupEnrollmentRepository {
  Future<SyncGroupEnrollment?> load();

  Future<void> create(SyncGroupEnrollment enrollment);

  Future<void> update(SyncGroupEnrollment enrollment);
}

class SyncGroupAlreadyExistsException implements Exception {
  const SyncGroupAlreadyExistsException();
}
