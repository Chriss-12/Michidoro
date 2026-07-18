import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/goals/data/datasources/goals_database.dart';
import 'package:pomodoro_app_v1/features/goals/data/repositories/drift_goals_repository.dart';

void main() {
  group('DriftGoalsRepository', () {
    test('persists goals in the local SQLite database file', () async {
      final directory = Directory.systemTemp.createTempSync(
        'michifocus_goals_test',
      );
      final file = File('${directory.path}/goals.sqlite');
      var database = GoalsDatabase(NativeDatabase(file));
      var repository = DriftGoalsRepository(GoalsDao(database));

      addTearDown(() async {
        await database.close();
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      final createdGoal = await repository.createGoal(
        title: 'Persistir M3',
        targetSessions: 4,
        targetDate: DateTime(2026, 7, 31),
      );
      await repository.updateProgress(
        id: createdGoal.id,
        completedSessions: 2,
      );
      await database.close();

      database = GoalsDatabase(NativeDatabase(file));
      repository = DriftGoalsRepository(GoalsDao(database));

      final goals = await repository.loadGoals();

      expect(goals, hasLength(1));
      expect(goals.single.id, createdGoal.id);
      expect(goals.single.title, 'Persistir M3');
      expect(goals.single.targetSessions, 4);
      expect(goals.single.completedSessions, 2);
      expect(goals.single.targetDate, DateTime(2026, 7, 31));
    });

    test(
      'updates progress and deletes goals through the repository boundary',
      () async {
        final database = GoalsDatabase(NativeDatabase.memory());
        final repository = DriftGoalsRepository(GoalsDao(database));

        addTearDown(database.close);

        final createdGoal = await repository.createGoal(
          title: 'Inicial',
          targetSessions: 3,
        );
        final updatedGoal = await repository.updateProgress(
          id: createdGoal.id,
          completedSessions: 1,
        );
        final editedGoal = await repository.updateGoalDetails(
          id: createdGoal.id,
          title: 'Editada',
          targetSessions: 5,
          targetDate: DateTime(2026, 8, 3),
        );

        expect(updatedGoal?.completedSessions, 1);
        expect(editedGoal?.title, 'Editada');
        expect(editedGoal?.targetSessions, 5);
        expect(editedGoal?.targetDate, DateTime(2026, 8, 3));

        await repository.deleteGoal(createdGoal.id);

        expect(await repository.loadGoals(), isEmpty);

        await repository.restoreGoal(editedGoal!);

        final restoredGoals = await repository.loadGoals();
        expect(restoredGoals, hasLength(1));
        expect(restoredGoals.single.id, createdGoal.id);
        expect(restoredGoals.single.title, 'Editada');
        expect(restoredGoals.single.targetDate, DateTime(2026, 8, 3));
      },
    );
  });
}
