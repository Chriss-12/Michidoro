import 'dart:convert';

class SyncOperation {
  const SyncOperation({
    required this.groupId,
    required this.operationId,
    required this.originDeviceId,
    required this.originCounter,
    required this.entityType,
    required this.entityId,
    required this.parentVersion,
    required this.changedFields,
    required this.operationKind,
    required this.createdAtEpochMillis,
    this.originDeviceName = '',
    this.entitySnapshot = const {},
    this.protocolVersion = 1,
  });

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    final parentVersion = json['parentVersion'];
    final changedFields = json['changedFields'];
    final originDeviceName = json['originDeviceName'];
    final entitySnapshot = json['entitySnapshot'];
    if (json['protocolVersion'] != 1 ||
        parentVersion is! Map<String, dynamic> ||
        changedFields is! Map<String, dynamic> ||
        (originDeviceName != null && originDeviceName is! String) ||
        (entitySnapshot != null && entitySnapshot is! Map<String, dynamic>)) {
      throw const FormatException('Invalid synchronization operation.');
    }
    return SyncOperation(
      groupId: _requiredString(json, 'groupId'),
      operationId: _requiredString(json, 'operationId'),
      originDeviceId: _requiredString(json, 'originDeviceId'),
      originCounter: _requiredPositiveInt(json, 'originCounter'),
      entityType: _requiredString(json, 'entityType'),
      entityId: _requiredString(json, 'entityId'),
      parentVersion: Map<String, Object?>.from(parentVersion),
      changedFields: Map<String, Object?>.from(changedFields),
      operationKind: _requiredString(json, 'operationKind'),
      createdAtEpochMillis: _requiredPositiveInt(
        json,
        'createdAtEpochMillis',
      ),
      originDeviceName: originDeviceName is String ? originDeviceName : '',
      entitySnapshot: entitySnapshot is Map<String, dynamic>
          ? Map<String, Object?>.from(entitySnapshot)
          : const {},
    )..validate();
  }

  final int protocolVersion;
  final String groupId;
  final String operationId;
  final String originDeviceId;
  final int originCounter;
  final String entityType;
  final String entityId;
  final Map<String, Object?> parentVersion;
  final Map<String, Object?> changedFields;
  final String operationKind;
  final int createdAtEpochMillis;
  final String originDeviceName;
  final Map<String, Object?> entitySnapshot;

  void validate() {
    if (!RegExp(r'^group_[a-f0-9]{32}$').hasMatch(groupId) ||
        !RegExp(r'^operation_[a-f0-9]{32}$').hasMatch(operationId) ||
        !RegExp(r'^installation_[a-f0-9]{32}$').hasMatch(originDeviceId) ||
        originCounter < 1 ||
        !const {
          'goal',
          'task',
          'calendarEvent',
          'routine',
          'quickNote',
        }.contains(entityType) ||
        entityId.trim().isEmpty ||
        entityId.length > 256 ||
        !const {'create', 'update', 'delete'}.contains(operationKind) ||
        createdAtEpochMillis < 1 ||
        (operationKind == 'delete' && changedFields.isNotEmpty) ||
        (operationKind != 'delete' && changedFields.isEmpty)) {
      throw const FormatException('Invalid synchronization operation.');
    }
    final normalizedDeviceName = originDeviceName.trim();
    if (normalizedDeviceName.length > 60 ||
        (originDeviceName.isNotEmpty && normalizedDeviceName.isEmpty)) {
      throw const FormatException('Invalid origin device name.');
    }
    for (final entry in parentVersion.entries) {
      if (!RegExp(r'^installation_[a-f0-9]{32}$').hasMatch(entry.key) ||
          entry.value is! int ||
          (entry.value! as int) < 1) {
        throw const FormatException('Invalid causal parent version.');
      }
    }
    try {
      jsonEncode(toJson());
    } on Object {
      throw const FormatException('Operation contains unsupported values.');
    }
  }

  Map<String, Object> toJson() {
    return {
      'protocolVersion': protocolVersion,
      'groupId': groupId,
      'operationId': operationId,
      'originDeviceId': originDeviceId,
      'originCounter': originCounter,
      'entityType': entityType,
      'entityId': entityId,
      'parentVersion': _sortedMap(parentVersion),
      'changedFields': _sortedMap(changedFields),
      'operationKind': operationKind,
      'createdAtEpochMillis': createdAtEpochMillis,
      if (originDeviceName.isNotEmpty)
        'originDeviceName': originDeviceName.trim(),
      if (entitySnapshot.isNotEmpty)
        'entitySnapshot': _sortedMap(entitySnapshot),
    };
  }

  List<int> canonicalBytes() {
    validate();
    return utf8.encode(jsonEncode(toJson()));
  }
}

Map<String, Object?> _sortedMap(Map<String, Object?> source) {
  final keys = source.keys.toList()..sort();
  return {for (final key in keys) key: source[key]};
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Missing $key.');
  }
  return value;
}

int _requiredPositiveInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int || value < 1) throw FormatException('Invalid $key.');
  return value;
}
