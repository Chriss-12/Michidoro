import 'package:flutter/services.dart';

class AndroidExternalSyncAppLauncher {
  const AndroidExternalSyncAppLauncher({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('michifocus/native_files');

  final MethodChannel _channel;

  Future<bool> call() async {
    try {
      return await _channel.invokeMethod<bool>('openSyncthing') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
