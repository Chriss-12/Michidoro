import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';

class AndroidLocalDeviceAuthenticator implements LocalDeviceAuthenticator {
  const AndroidLocalDeviceAuthenticator({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'michifocus/local_auth';

  final MethodChannel _channel;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _channel.invokeMethod<bool>('authenticate') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
