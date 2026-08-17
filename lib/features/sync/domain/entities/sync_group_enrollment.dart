import 'package:pomodoro_app_v1/features/sync/domain/entities/device_bound_key_envelope.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_key_manifest.dart';

enum SyncGroupEnrollmentSource { createdHere, joinedExisting }

enum SyncGroupBootstrapPreference { restoreIntoEmpty, mergeLocal, replaceLocal }

class SyncGroupEnrollment {
  const SyncGroupEnrollment({
    required this.manifest,
    required this.deviceBoundDek,
    this.source = SyncGroupEnrollmentSource.createdHere,
    this.bootstrapPreference,
    this.recoverySnapshotPath = '',
  });

  factory SyncGroupEnrollment.fromJson(Map<String, dynamic> json) {
    final manifest = json['manifest'];
    final deviceBoundDek = json['deviceBoundDek'];
    if (manifest is! Map<String, dynamic> ||
        deviceBoundDek is! Map<String, dynamic>) {
      throw const FormatException('Invalid synchronization enrollment.');
    }
    return SyncGroupEnrollment(
      manifest: SyncGroupKeyManifest.fromJson(manifest),
      deviceBoundDek: DeviceBoundKeyEnvelope.fromJson(deviceBoundDek),
      source: _sourceFromJson(json['source']),
      bootstrapPreference: _bootstrapPreferenceFromJson(
        json['bootstrapPreference'],
      ),
      recoverySnapshotPath: _optionalString(
        json['recoverySnapshotPath'],
        'recovery snapshot path',
      ),
    );
  }

  final SyncGroupKeyManifest manifest;
  final DeviceBoundKeyEnvelope deviceBoundDek;
  final SyncGroupEnrollmentSource source;
  final SyncGroupBootstrapPreference? bootstrapPreference;
  final String recoverySnapshotPath;

  String get groupId => manifest.groupId;

  Map<String, Object> toJson() => {
    'version': 1,
    'manifest': manifest.toJson(),
    'deviceBoundDek': deviceBoundDek.toJson(),
    'source': source.name,
    if (bootstrapPreference != null)
      'bootstrapPreference': bootstrapPreference!.name,
    if (recoverySnapshotPath.isNotEmpty)
      'recoverySnapshotPath': recoverySnapshotPath,
  };
}

String _optionalString(Object? value, String label) {
  if (value == null) return '';
  if (value is! String) throw FormatException('Invalid $label.');
  return value.trim();
}

SyncGroupEnrollmentSource _sourceFromJson(Object? value) {
  if (value == null) return SyncGroupEnrollmentSource.createdHere;
  for (final source in SyncGroupEnrollmentSource.values) {
    if (source.name == value) return source;
  }
  throw const FormatException('Invalid synchronization enrollment source.');
}

SyncGroupBootstrapPreference? _bootstrapPreferenceFromJson(Object? value) {
  if (value == null) return null;
  for (final preference in SyncGroupBootstrapPreference.values) {
    if (preference.name == value) return preference;
  }
  throw const FormatException('Invalid synchronization bootstrap preference.');
}
