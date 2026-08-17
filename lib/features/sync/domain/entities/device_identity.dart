class DeviceIdentity {
  const DeviceIdentity({
    this.installationId = '',
    this.friendlyName = '',
  });

  final String installationId;
  final String friendlyName;

  bool get isInitialized =>
      installationId.trim().isNotEmpty && friendlyName.trim().isNotEmpty;

  DeviceIdentity normalized() {
    final normalizedName = friendlyName.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    return DeviceIdentity(
      installationId: installationId.trim(),
      friendlyName: normalizedName.length <= 60
          ? normalizedName
          : normalizedName.substring(0, 60).trimRight(),
    );
  }
}
