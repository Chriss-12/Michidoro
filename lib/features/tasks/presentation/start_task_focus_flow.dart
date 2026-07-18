import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';

class TaskFocusPreset {
  const TaskFocusPreset({
    required this.focusSeconds,
    required this.breakSeconds,
    this.isTestPreset = false,
  });

  const TaskFocusPreset.minutes({
    required int focusMinutes,
    required int breakMinutes,
  }) : this(
         focusSeconds: focusMinutes * 60,
         breakSeconds: breakMinutes * 60,
       );

  final int focusSeconds;
  final int breakSeconds;
  final bool isTestPreset;

  int get focusMinutes => focusSeconds ~/ 60;
  int get breakMinutes => breakSeconds ~/ 60;

  String get label =>
      '${_durationLabel(focusSeconds)} enfoque / '
      '${_durationLabel(breakSeconds)} descanso';

  String get supportingLabel => isTestPreset
      ? 'Prueba rápida para validar sin esperar 25 minutos'
      : 'Preset normal de productividad';

  static String _durationLabel(int seconds) {
    if (seconds % 60 == 0) {
      return '${seconds ~/ 60} min';
    }

    return '$seconds s';
  }
}

const taskFocusPresets = [
  TaskFocusPreset(
    focusSeconds: 60,
    breakSeconds: 20,
    isTestPreset: true,
  ),
  TaskFocusPreset.minutes(focusMinutes: 5, breakMinutes: 1),
  TaskFocusPreset.minutes(focusMinutes: 25, breakMinutes: 5),
  TaskFocusPreset.minutes(focusMinutes: 30, breakMinutes: 5),
  TaskFocusPreset.minutes(focusMinutes: 45, breakMinutes: 10),
];

Future<void> startTaskFocusFlow({
  required BuildContext context,
  required Task task,
}) async {
  final preset = await showModalBottomSheet<TaskFocusPreset>(
    context: context,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final palette = sheetContext.palette;

      return SafeArea(
        child: ListView(
          padding: AppCardPaddings.standard,
          shrinkWrap: true,
          children: [
            Text(
              'Empezar Pomodoro',
              style: Theme.of(sheetContext).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              task.title,
              style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            for (final option in taskFocusPresets)
              ListTile(
                leading: Icon(
                  option.isTestPreset
                      ? Icons.science_outlined
                      : Icons.timer_rounded,
                ),
                title: Text(option.label),
                subtitle: Text(option.supportingLabel),
                onTap: () => Navigator.of(sheetContext).pop(option),
              ),
          ],
        ),
      );
    },
  );

  if (preset == null) {
    return;
  }

  serviceLocator<PomodoroController>()
    ..setFocusSeconds(preset.focusSeconds)
    ..setShortBreakSeconds(preset.breakSeconds)
    ..selectTask(
      taskId: task.id,
      taskTitle: task.title,
      goalId: task.goalId,
    );

  if (!preset.isTestPreset) {
    appSettingsController
      ..setFocusMinutes(preset.focusMinutes)
      ..setShortBreakMinutes(preset.breakMinutes);
    unawaited(appSettingsController.saveTimerPreferences());
  }

  if (context.mounted) {
    context.go(PomodoroPage.routePath);
  }
}
