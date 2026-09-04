import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/application_data_refresh_coordinator.dart';

void main() {
  test('shares one in-flight refresh and permits a later refresh', () async {
    final firstRefresh = Completer<void>();
    var calls = 0;
    final coordinator = ApplicationDataRefreshCoordinator(
      refreshers: [
        () {
          calls += 1;
          return calls == 1 ? firstRefresh.future : Future.value();
        },
      ],
    );

    final first = coordinator.refresh();
    final concurrent = coordinator.refresh();

    expect(identical(first, concurrent), isTrue);
    expect(calls, 1);

    firstRefresh.complete();
    await first;
    await coordinator.refresh();

    expect(calls, 2);
  });
}
