import 'package:flutter/widgets.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';

class SyncStorageScope extends InheritedWidget {
  const SyncStorageScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final SyncStorageController controller;

  static SyncStorageController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<SyncStorageScope>();
    assert(scope != null, 'SyncStorageScope was not found in the tree.');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(SyncStorageScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
