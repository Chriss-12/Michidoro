import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  setUp(() async {
    await serviceLocator.reset();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('applies one month filter to all status counts', (tester) async {
    final controller =
        TasksController(
            repository: _UnusedTasksRepository(),
            now: () => DateTime(2026, 8, 24),
          )
          ..tasks.value = [
            Task(
              id: 'july-active',
              title: 'Julio activa',
              createdAt: DateTime(2026),
              scheduledDate: DateTime(2026, 7, 5),
            ),
            Task(
              id: 'july-completed',
              title: 'Julio hecha',
              createdAt: DateTime(2026),
              scheduledDate: DateTime(2026, 7, 20),
              status: TaskStatus.completed,
            ),
            Task(
              id: 'august-active',
              title: 'Agosto activa',
              createdAt: DateTime(2026),
              scheduledDate: DateTime(2026, 8, 2),
            ),
          ];
    serviceLocator.registerSingleton<TasksController>(controller);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const Scaffold(body: TasksPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('24 agosto 2026'), findsOneWidget);
    expect(find.text('Todas (0)'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('task-temporal-filter-button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Un día'), findsOneWidget);
    expect(find.text('Un mes'), findsOneWidget);
    expect(find.text('Un año'), findsOneWidget);
    expect(find.text('Rango personalizado'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('task-filter-month')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('task-filter-month-7')));
    await tester.pumpAndSettle();

    expect(controller.temporalFilter.value.kind, TaskTemporalFilterKind.month);
    expect(find.text('julio 2026'), findsOneWidget);
    expect(find.text('Todas (2)'), findsOneWidget);
    expect(find.text('Activas (1)'), findsOneWidget);
    expect(find.text('Hechas (1)'), findsOneWidget);
    expect(find.text('Julio activa'), findsOneWidget);
    expect(find.text('Julio hecha'), findsOneWidget);
    expect(find.text('Agosto activa'), findsNothing);

    await tester.drag(
      find.byKey(const ValueKey('task-status-filter-scroll')),
      const Offset(-240, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hechas (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Julio hecha'), findsOneWidget);
    expect(find.text('Julio activa'), findsNothing);
    expect(controller.temporalFilter.value.kind, TaskTemporalFilterKind.month);
  });
}

class _UnusedTasksRepository implements TasksRepository {
  Never _unused() => throw UnimplementedError();

  @override
  Future<Task?> assignTaskToGoal(String id, String? goalId) => _unused();

  @override
  Future<Task> createPlannedTask({
    required String title,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) => _unused();

  @override
  Future<Task> createTask(String title) => _unused();

  @override
  Future<void> deleteTask(String id) => _unused();

  @override
  Future<List<Task>> loadTasks() => _unused();

  @override
  Future<Task?> scheduleTask(String id, DateTime? scheduledDate) => _unused();

  @override
  Future<Task?> toggleTaskCompletion(String id) => _unused();

  @override
  Future<Task?> updateTaskPlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
  }) => _unused();

  @override
  Future<Task?> updateTaskStatus(String id, TaskStatus status) => _unused();

  @override
  Future<Task?> updateTaskTitle(String id, String title) => _unused();
}
