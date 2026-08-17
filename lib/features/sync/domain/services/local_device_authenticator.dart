abstract interface class LocalDeviceAuthenticator {
  Future<bool> isAvailable();

  Future<bool> authenticate();
}
