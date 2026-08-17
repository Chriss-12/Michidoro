import 'package:flutter/widgets.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';

class SyncGroupEnrollmentScope extends InheritedWidget {
  const SyncGroupEnrollmentScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final SyncGroupEnrollmentController controller;

  static SyncGroupEnrollmentController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<SyncGroupEnrollmentScope>();
    assert(scope != null, 'SyncGroupEnrollmentScope was not found.');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(SyncGroupEnrollmentScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
