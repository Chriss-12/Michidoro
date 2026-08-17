import 'package:flutter/widgets.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/local_app_lock_controller.dart';

class LocalAppLockScope extends InheritedWidget {
  const LocalAppLockScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final LocalAppLockController controller;

  static LocalAppLockController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LocalAppLockScope>();
    assert(scope != null, 'LocalAppLockScope was not found in the tree.');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(LocalAppLockScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
