import 'package:flutter/widgets.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/device_identity_controller.dart';

class DeviceIdentityScope extends InheritedWidget {
  const DeviceIdentityScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final DeviceIdentityController controller;

  static DeviceIdentityController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DeviceIdentityScope>();
    assert(scope != null, 'DeviceIdentityScope was not found in the tree.');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(DeviceIdentityScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
