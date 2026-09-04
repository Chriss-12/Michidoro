import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/services/screen_awake_platform.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PomodoroScreenAwakeCoordinator extends StatefulWidget {
  const PomodoroScreenAwakeCoordinator({
    required this.controller,
    required this.platform,
    required this.child,
    super.key,
  });

  final PomodoroController controller;
  final ScreenAwakePlatform platform;
  final Widget child;

  @override
  State<PomodoroScreenAwakeCoordinator> createState() =>
      _PomodoroScreenAwakeCoordinatorState();
}

class _PomodoroScreenAwakeCoordinatorState
    extends State<PomodoroScreenAwakeCoordinator> {
  bool? _lastRequestedValue;

  @override
  void dispose() {
    unawaited(_setEnabled(false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final enabled =
            widget.controller.isRunning.value &&
            widget.controller.keepScreenAwakeEnabled.value;
        _scheduleUpdate(enabled);
        return widget.child;
      },
    );
  }

  void _scheduleUpdate(bool enabled) {
    if (_lastRequestedValue == enabled) return;
    _lastRequestedValue = enabled;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _lastRequestedValue != enabled) return;
      unawaited(_setEnabled(enabled));
    });
  }

  Future<void> _setEnabled(bool enabled) async {
    try {
      await widget.platform(enabled: enabled);
    } on Object {
      // Optional platform support must never interrupt the running timer.
    }
  }
}
