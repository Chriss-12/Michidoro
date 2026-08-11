import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/repositories/drift_pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_session.dart';

void main() {
  group('DriftPomodoroSessionsRepository', () {
    test('does not duplicate a retried focus boundary', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftPomodoroSessionsRepository(
        PomodoroSessionsDao(database),
      );
      final startedAt = DateTime(2026, 7, 29, 9);
      final endedAt = startedAt.add(const Duration(minutes: 25));
      addTearDown(database.close);

      await repository.saveCompletedSession(
        startedAt: startedAt,
        endedAt: endedAt,
        plannedSeconds: 1500,
        focusedSeconds: 1500,
      );
      await repository.saveCompletedSession(
        startedAt: startedAt,
        endedAt: endedAt,
        plannedSeconds: 1500,
        focusedSeconds: 1500,
      );

      expect(await repository.loadSessions(), hasLength(1));
    });

    test(
      'persists completed sessions in the local SQLite database file',
      () async {
        final directory = Directory.systemTemp.createTempSync(
          'michifocus_pomodoro_sessions_test',
        );
        final file = File('${directory.path}/pomodoro_sessions.sqlite');
        var database = MichiFocusDatabase(NativeDatabase(file));
        var repository = DriftPomodoroSessionsRepository(
          PomodoroSessionsDao(database),
        );

        addTearDown(() async {
          await database.close();
          if (directory.existsSync()) {
            directory.deleteSync(recursive: true);
          }
        });

        final now = DateTime(2026, 1, 1, 8);
        await database
            .into(database.goalRecords)
            .insert(
              GoalRecordsCompanion.insert(
                id: 'goal-1',
                title: 'Meta',
                targetSessions: 1,
                createdAt: now,
                updatedAt: now,
              ),
            );
        await database
            .into(database.taskRecords)
            .insert(
              TaskRecordsCompanion.insert(
                id: 'task-1',
                title: 'Tarea',
                goalId: const Value('goal-1'),
                createdAt: now,
                updatedAt: now,
              ),
            );

        final startedAt = DateTime(2026, 1, 1, 9);
        final endedAt = DateTime(2026, 1, 1, 9, 25);
        final createdSession = await repository.saveCompletedSession(
          startedAt: startedAt,
          endedAt: endedAt,
          plannedSeconds: 1500,
          focusedSeconds: 1500,
          goalId: 'goal-1',
          taskId: 'task-1',
          startMoodScore: 4,
        );
        expect(createdSession.moodPromptPending, isTrue);
        await repository.updateSessionReflection(
          sessionId: createdSession.id,
          endMoodScore: 2,
          wasDistracted: true,
          distractionMinutes: 8,
        );
        await database.close();

        database = MichiFocusDatabase(NativeDatabase(file));
        repository = DriftPomodoroSessionsRepository(
          PomodoroSessionsDao(database),
        );

        final sessions = await repository.loadSessions();

        expect(sessions, hasLength(1));
        expect(sessions.single.id, createdSession.id);
        expect(sessions.single.startedAt, startedAt);
        expect(sessions.single.endedAt, endedAt);
        expect(sessions.single.plannedSeconds, 1500);
        expect(sessions.single.focusedSeconds, 1500);
        expect(sessions.single.status, PomodoroSessionStatus.completed);
        expect(sessions.single.goalId, 'goal-1');
        expect(sessions.single.taskId, 'task-1');
        expect(sessions.single.startMoodScore, 4);
        expect(sessions.single.endMoodScore, 2);
        expect(sessions.single.moodPromptPending, isFalse);
        expect(sessions.single.wasDistracted, isTrue);
        expect(sessions.single.distractionMinutes, 8);
      },
    );

    test('loads sessions newest first', () async {
      final database = MichiFocusDatabase(NativeDatabase.memory());
      final repository = DriftPomodoroSessionsRepository(
        PomodoroSessionsDao(database),
      );

      addTearDown(database.close);

      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 1, 1, 9),
        endedAt: DateTime(2026, 1, 1, 9, 25),
        plannedSeconds: 1500,
        focusedSeconds: 1500,
      );
      await repository.saveCompletedSession(
        startedAt: DateTime(2026, 1, 2, 9),
        endedAt: DateTime(2026, 1, 2, 9, 25),
        plannedSeconds: 1500,
        focusedSeconds: 1500,
      );

      final sessions = await repository.loadSessions();

      expect(sessions, hasLength(2));
      expect(sessions.first.startedAt, DateTime(2026, 1, 2, 9));
    });
  });
}
