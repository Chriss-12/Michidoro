import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/repositories/drift_pomodoro_runtime_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';

void main() {
  test('persists, replaces, and clears the singleton runtime', () async {
    final database = MichiFocusDatabase(NativeDatabase.memory());
    final repository = DriftPomodoroRuntimeRepository(
      PomodoroRuntimeDao(database),
    );
    final now = DateTime(2026, 7, 29, 9);

    addTearDown(database.close);

    await repository.save(
      PomodoroRuntimeState(
        phase: PomodoroRuntimePhase.focus,
        isRunning: true,
        remainingSeconds: 25 * 60,
        phaseTotalSeconds: 25 * 60,
        cadenceFocusMinutes: 25,
        cadenceBreakMinutes: 5,
        longBreakMinutes: 15,
        longBreakFrequency: 4,
        autoStartBreak: true,
        autoStartFocus: true,
        planMode: PomodoroPlanMode.continuous,
        blockIndex: 1,
        blockCount: 5,
        taskFocusedSecondsAtStart: 0,
        lastTickAt: now,
        focusStartedAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );

    var restored = await repository.load();
    expect(restored, isNotNull);
    expect(restored?.phase, PomodoroRuntimePhase.focus);
    expect(restored?.remainingSeconds, 1500);
    expect(restored?.blockIndex, 1);
    expect(restored?.blockCount, 5);

    await repository.save(
      PomodoroRuntimeState(
        phase: PomodoroRuntimePhase.shortBreak,
        isRunning: false,
        remainingSeconds: 240,
        phaseTotalSeconds: 300,
        cadenceFocusMinutes: 25,
        cadenceBreakMinutes: 5,
        longBreakMinutes: 15,
        longBreakFrequency: 4,
        autoStartBreak: true,
        autoStartFocus: true,
        planMode: PomodoroPlanMode.continuous,
        blockIndex: 1,
        blockCount: 5,
        taskFocusedSecondsAtStart: 0,
        createdAt: now,
        updatedAt: now.add(const Duration(minutes: 26)),
      ),
    );

    restored = await repository.load();
    expect(restored?.phase, PomodoroRuntimePhase.shortBreak);
    expect(restored?.isRunning, isFalse);
    expect(restored?.remainingSeconds, 240);

    await repository.clear();
    expect(await repository.load(), isNull);
  });
}
