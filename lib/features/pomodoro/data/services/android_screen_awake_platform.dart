import 'dart:io';

import 'package:flutter/services.dart';

class AndroidScreenAwakePlatform {
  const AndroidScreenAwakePlatform();

  static const _channel = MethodChannel('michifocus/screen_awake');

  Future<void> setEnabled({required bool enabled}) async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>('setEnabled', {'enabled': enabled});
  }
}
