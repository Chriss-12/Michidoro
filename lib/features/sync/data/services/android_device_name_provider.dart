import 'package:flutter/services.dart';

class AndroidDeviceNameProvider {
  AndroidDeviceNameProvider({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('michifocus/device_identity');

  final MethodChannel _channel;

  Future<String?> suggestedName() async {
    try {
      final name = await _channel.invokeMethod<String>('getSuggestedName');
      final normalized = name?.trim().replaceAll(RegExp(r'\s+'), ' ');
      return normalized == null || normalized.isEmpty ? null : normalized;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
