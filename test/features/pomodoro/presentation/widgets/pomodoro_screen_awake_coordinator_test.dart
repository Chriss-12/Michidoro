import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/widgets/pomodoro_screen_awake_coordinator.dart';

void main() {
  testWidgets('keeps the screen awake only while the enabled timer runs', (
    tester,
  ) async {
    final controller = PomodoroController(
      repository: _MemoryPomodoroSessionsRepository(),
    );
    final platform = _RecordingScreenAwakePlatform();

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: PomodoroScreenAwakeCoordinator(
          controller: controller,
          platform: platform.setEnabled,
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pump();
    expect(platform.values, [false]);

    controller
      ..keepScreenAwake = true
      ..start();
    await tester.pump();
    expect(platform.values.last, isTrue);

    controller.pause();
    await tester.pump();
    expect(platform.values.last, isFalse);

    controller.start();
    await tester.pump();
    expect(platform.values.last, isTrue);

    controller.keepScreenAwake = false;
    await tester.pump();
    expect(platform.values.last, isFalse);
    controller.pause();
  });
}

class _RecordingScreenAwakePlatform {
  final List<bool> values = [];

  Future<void> setEnabled({required bool enabled}) async {
    values.add(enabled);
  }
}

class _MemoryPomodoroSessionsRepository implements PomodoroSessionsRepository {
  @override
  Future<List<PomodoroSession>> loadSessions() async => const [];

  @override
  Future<PomodoroSession> saveCompletedSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedSeconds,
    required int focusedSeconds,
    String? goalId,
    String? taskId,
    int? startMoodScore,
    PomodoroSessionStatus status = PomodoroSessionStatus.completed,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PomodoroSession> updateSessionReflection({
    required String sessionId,
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  }) {
    throw UnimplementedError();
  }
}
