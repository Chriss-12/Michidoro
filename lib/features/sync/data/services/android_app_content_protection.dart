import 'package:flutter/services.dart';

class AndroidAppContentProtection {
  const AndroidAppContentProtection({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'michifocus/content_protection';

  final MethodChannel _channel;

  Future<void> setEnabled({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('setEnabled', {'enabled': enabled});
    } on PlatformException {
      // The Flutter privacy shield remains active if Android rejects the call.
    } on MissingPluginException {
      // Widget tests and unsupported platforms rely on the Flutter shield.
    }
  }
}
