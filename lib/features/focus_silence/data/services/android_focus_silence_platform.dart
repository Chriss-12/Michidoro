import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/entities/focus_silence_preferences.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/services/focus_silence_platform.dart';

class AndroidFocusSilencePlatform implements FocusSilencePlatform {
  const AndroidFocusSilencePlatform();

  static const _channel = MethodChannel('michifocus/focus_silence');

  @override
  Future<FocusSilenceCapability> getCapability() async {
    if (!Platform.isAndroid) {
      return const FocusSilenceCapability.unsupported();
    }
    final result = await _channel.invokeMapMethod<String, Object?>(
      'getCapability',
    );
    return _decode(result);
  }

  @override
  Future<void> openPolicyAccessSettings() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>('openPolicyAccessSettings');
  }

  @override
  Future<FocusSilenceCapability> setActive({
    required bool active,
    required FocusSilenceProfile profile,
    DateTime? endsAt,
  }) async {
    if (!Platform.isAndroid) {
      return const FocusSilenceCapability.unsupported();
    }
    final result = await _channel.invokeMapMethod<String, Object?>(
      'setActive',
      {
        'active': active,
        'profile': profile.name,
        'endsAtEpochMillis': endsAt?.millisecondsSinceEpoch,
      },
    );
    return _decode(result);
  }

  FocusSilenceCapability _decode(Map<String, Object?>? source) {
    return FocusSilenceCapability(
      isSupported: source?['supported'] == true,
      isAuthorized: source?['authorized'] == true,
      isActive: source?['active'] == true,
      apiLevel: source?['apiLevel'] is int ? source!['apiLevel']! as int : 0,
    );
  }
}
