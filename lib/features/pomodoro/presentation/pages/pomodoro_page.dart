import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/pomodoro_runtime_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/focus_silence/presentation/controllers/focus_silence_controller.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/entities/pomodoro_runtime_state.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  static const routePath = '/pomodoro';
  static const fullscreenRoutePath = '/pomodoro/fullscreen';

  @override
  Widget build(BuildContext context) {
    final goalsController = serviceLocator<GoalsController>();
    final tasksController = serviceLocator<TasksController>();
    final pomodoroController = serviceLocator<PomodoroController>();

    return ListView(
      padding: AppCardPaddings.page,
      children: [
        const SizedBox(height: 48),
        const _TimerRingSection(),
        const SizedBox(height: 32),
        const _TimerControlsSection(),
        const SizedBox(height: 86),
        const _FocusLifecycleActionsSection(),
        const SizedBox(height: 24),
        SignalBuilder(
          builder: (context) {
            final pendingSessionId =
                pomodoroController.pendingReflectionSessionId.value;
            if (pendingSessionId == null) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                _FocusReflectionCard(
                  key: ValueKey(pendingSessionId),
                  onSubmit: pomodoroController.submitCompletionReflection,
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
        SignalBuilder(
          builder: (context) {
            final scheduledGoals = goalsController.scheduledGoals();
            final selectedGoal = goalsController.goalById(
              pomodoroController.activeGoalId.value,
            );
            final selectedTaskTitle = pomodoroController.activeTaskTitle.value;

            return _ActiveFocusContextCard(
              taskTitle: selectedTaskTitle,
              selectedGoal: selectedGoal?.targetDate == null
                  ? null
                  : selectedGoal,
              scheduledGoals: scheduledGoals,
              onSelectGoal: (goalId) =>
                  pomodoroController.selectedGoalId = goalId,
              onCompleteTask: selectedTaskTitle == null
                  ? null
                  : () {
                      final taskId = pomodoroController.selectedTaskId;
                      if (taskId == null) {
                        return;
                      }

                      unawaited(
                        tasksController.updateTaskStatus(
                          taskId,
                          TaskStatus.completed,
                        ),
                      );
                    },
            );
          },
        ),
        const SizedBox(height: 24),
        const _TimerStatsSection(),
      ],
    );
  }
}

class _FocusReflectionCard extends StatefulWidget {
  const _FocusReflectionCard({required this.onSubmit, super.key});

  final Future<void> Function({
    required int endMoodScore,
    required bool wasDistracted,
    required int distractionMinutes,
  })
  onSubmit;

  @override
  State<_FocusReflectionCard> createState() => _FocusReflectionCardState();
}

class _FocusReflectionCardState extends State<_FocusReflectionCard> {
  int? _endMoodScore;
  bool _wasDistracted = false;
  int _distractionMinutes = 5;
  bool _isSaving = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GlassCard(
        key: const ValueKey('focus-reflection-card'),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: Semantics(
                button: true,
                expanded: _isExpanded,
                child: InkWell(
                  key: const ValueKey('focus-reflection-toggle'),
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding: AppCardPaddings.compact,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: palette.primaryMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.self_improvement_rounded,
                            color: palette.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            context.tr('Cierre de enfoque', 'Focus wrap-up'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            Icons.expand_more_rounded,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: _isExpanded
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: palette.neutralSoft, height: 1),
                            const SizedBox(height: 16),
                            Text(
                              context.tr(
                                '¿Cómo te sientes después de este bloque?',
                                'How do you feel after this block?',
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                            _MoodScoreSelector(
                              selectedScore: _endMoodScore,
                              onChanged: (value) =>
                                  setState(() => _endMoodScore = value),
                            ),
                            const SizedBox(height: 14),
                            SegmentedButton<bool>(
                              segments: [
                                ButtonSegment(
                                  value: false,
                                  icon: const Icon(
                                    Icons.check_circle_outline_rounded,
                                  ),
                                  label: Text(
                                    context.tr('Todo bien', 'All good'),
                                  ),
                                ),
                                ButtonSegment(
                                  value: true,
                                  icon: const Icon(
                                    Icons.visibility_off_outlined,
                                  ),
                                  label: Text(
                                    context.tr(
                                      'Me distraje',
                                      'I got distracted',
                                    ),
                                  ),
                                ),
                              ],
                              selected: {_wasDistracted},
                              onSelectionChanged: (values) => setState(
                                () => _wasDistracted = values.single,
                              ),
                            ),
                            if (_wasDistracted) ...[
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      context.tr(
                                        'Minutos aproximados',
                                        'Approximate minutes',
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                  ),
                                  Text(
                                    '$_distractionMinutes min',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: palette.primary),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _distractionMinutes.toDouble(),
                                min: 1,
                                max: 60,
                                divisions: 59,
                                label: '$_distractionMinutes min',
                                onChanged: (value) => setState(
                                  () => _distractionMinutes = value.round(),
                                ),
                              ),
                            ],
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: _isSaving || _endMoodScore == null
                                    ? null
                                    : () async {
                                        setState(() => _isSaving = true);
                                        await widget.onSubmit(
                                          endMoodScore: _endMoodScore!,
                                          wasDistracted: _wasDistracted,
                                          distractionMinutes:
                                              _distractionMinutes,
                                        );
                                        if (mounted) {
                                          setState(() => _isSaving = false);
                                        }
                                      },
                                icon: const Icon(Icons.save_alt_rounded),
                                label: Text(
                                  context.tr(
                                    'Guardar reflexión',
                                    'Save reflection',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodScoreSelector extends StatelessWidget {
  const _MoodScoreSelector({
    required this.selectedScore,
    required this.onChanged,
  });

  final int? selectedScore;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        for (var score = 1; score <= 5; score += 1) ...[
          Expanded(
            child: Tooltip(
              message: context.tr('$score de 5', '$score out of 5'),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onChanged(score),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 42,
                  decoration: BoxDecoration(
                    color: selectedScore == score
                        ? palette.primary
                        : palette.primaryMuted.withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: palette.neutralSoft),
                  ),
                  child: Center(
                    child: Icon(
                      _moodIconForScore(score),
                      semanticLabel: context.tr(
                        'Ánimo $score de 5',
                        'Mood $score out of 5',
                      ),
                      color: selectedScore == score
                          ? Theme.of(context).colorScheme.onPrimary
                          : palette.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (score < 5) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

IconData _moodIconForScore(int score) {
  return switch (score) {
    1 => Icons.sentiment_very_dissatisfied_rounded,
    2 => Icons.sentiment_dissatisfied_rounded,
    3 => Icons.sentiment_neutral_rounded,
    4 => Icons.sentiment_satisfied_rounded,
    _ => Icons.sentiment_very_satisfied_rounded,
  };
}

class _TimerRingSection extends StatelessWidget {
  const _TimerRingSection();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final runtime = PomodoroRuntimeScope.of(context);
    final minutes = runtime.remainingSeconds ~/ 60;
    final seconds = runtime.remainingSeconds % 60;
    final progress = runtime.timerProgress;
    final timeLabel =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _TimerRingPainter(
                  palette: palette,
                  progress: progress,
                ),
                child: _TimerFace(
                  timeLabel: timeLabel,
                  phaseLabel: _phaseTitle(context, runtime.phase),
                ),
              ),
            ),
          ),
          if (runtime.hasActiveRuntime) ...[
            const SizedBox(height: 12),
            _PomodoroCompletionIndicator(runtime: runtime),
          ],
          if (runtime.taskEstimatedSeconds != null) ...[
            const SizedBox(height: 12),
            _TaskPlanInfoButton(runtime: runtime),
          ],
        ],
      ),
    );
  }
}

class _TimerControlsSection extends StatefulWidget {
  const _TimerControlsSection();

  @override
  State<_TimerControlsSection> createState() => _TimerControlsSectionState();
}

class _TimerControlsSectionState extends State<_TimerControlsSection> {
  bool _isOpeningMaximumConcentration = false;

  @override
  Widget build(BuildContext context) {
    final runtime = PomodoroRuntimeScope.of(context);
    final controller = serviceLocator<PomodoroController>();

    return SignalBuilder(
      builder: (context) {
        final maximumConcentrationEnabled =
            controller.maximumConcentrationEnabled.value;
        final maximumConcentrationStyle =
            controller.maximumConcentrationStyle.value;
        final amoledProtectionEnabled =
            controller.amoledProtectionEnabled.value;
        final keepScreenAwakeEnabled = controller.keepScreenAwakeEnabled.value;
        final maximumConcentrationOpacity =
            appSettingsController.maximumConcentrationOpacity.value;
        final focusSilenceController =
            serviceLocator.isRegistered<FocusSilenceController>()
            ? serviceLocator<FocusSilenceController>()
            : null;
        final focusSilenceEnabled =
            (focusSilenceController?.effectivePlanEnabled ?? false) &&
            (focusSilenceController?.capability.value.isAuthorized ?? false);
        if (maximumConcentrationEnabled &&
            runtime.hasStartedRuntime &&
            !_isOpeningMaximumConcentration &&
            GoRouterState.of(context).uri.path == PomodoroPage.routePath) {
          _isOpeningMaximumConcentration = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) {
              return;
            }
            await context.push<void>(PomodoroFullscreenPage.routePath);
            if (mounted) {
              _isOpeningMaximumConcentration = false;
            }
          });
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CircleAction(
              icon: Icons.replay_rounded,
              onPressed: runtime.onReset,
              outline: true,
            ),
            _CircleAction(
              icon: runtime.isRunning
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              onPressed: () => _handleStartPressed(context, runtime),
              large: true,
            ),
            _FocusDisplayMenuButton(
              isFullscreen: false,
              maximumConcentrationEnabled: maximumConcentrationEnabled,
              maximumConcentrationActive: false,
              maximumConcentrationStyle: maximumConcentrationStyle,
              amoledProtectionEnabled: amoledProtectionEnabled,
              keepScreenAwakeEnabled: keepScreenAwakeEnabled,
              maximumConcentrationOpacity: maximumConcentrationOpacity,
              showFocusSilenceControl:
                  runtime.hasActiveRuntime && focusSilenceController != null,
              focusSilenceEnabled: focusSilenceEnabled,
              onMaximumConcentrationChanged: (enabled) =>
                  controller.maximumConcentrationMode = enabled,
              onMaximumConcentrationStyleChanged: (style) =>
                  controller.maximumConcentrationDisplayStyle = style,
              onAmoledProtectionChanged: (enabled) =>
                  controller.amoledProtection = enabled,
              onKeepScreenAwakeChanged: (enabled) =>
                  controller.keepScreenAwake = enabled,
              onMaximumConcentrationOpacityChanged:
                  appSettingsController.setMaximumConcentrationOpacity,
              onMaximumConcentrationOpacityChangeEnd: (_) =>
                  unawaited(appSettingsController.saveTimerPreferences()),
              onFocusSilenceChanged: (enabled) => unawaited(
                _changeCurrentPlanSilence(context, enabled),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FocusLifecycleActionsSection extends StatelessWidget {
  const _FocusLifecycleActionsSection();

  @override
  Widget build(BuildContext context) {
    final runtime = PomodoroRuntimeScope.of(context);

    return _FocusLifecycleActions(
      phase: runtime.phase,
      hasElapsedPhase: runtime.remainingSeconds < runtime.currentPhaseSeconds,
      onDiscard: runtime.onDiscard,
      onRestart: runtime.onRestart,
      onFinishEarly: () => unawaited(
        runtime.phase == PomodoroPhase.focus
            ? runtime.onStopForNow()
            : runtime.onFinishEarly(),
      ),
    );
  }
}

class _TimerStatsSection extends StatelessWidget {
  const _TimerStatsSection();

  @override
  Widget build(BuildContext context) {
    final runtime = PomodoroRuntimeScope.of(context);
    final focusedMinutes = runtime.totalFocusSeconds ~/ 60;
    final focusedLabel = focusedMinutes >= 60
        ? '${(focusedMinutes / 60).toStringAsFixed(1)}h'
        : '${focusedMinutes}m';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: _TimerStat(
              label: context.tr('Hoy', 'Today'),
              value: focusedLabel,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: _TimerStat(
              label: context.tr('Sesiones', 'Sessions'),
              value: '${runtime.completedPomodoros}',
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveFocusContextCard extends StatelessWidget {
  const _ActiveFocusContextCard({
    required this.taskTitle,
    required this.selectedGoal,
    required this.scheduledGoals,
    required this.onSelectGoal,
    required this.onCompleteTask,
  });

  final String? taskTitle;
  final ProductivityGoal? selectedGoal;
  final List<ProductivityGoal> scheduledGoals;
  final ValueChanged<String?> onSelectGoal;
  final VoidCallback? onCompleteTask;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final goal = selectedGoal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GlassCard(
        padding: AppCardPaddings.compact,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showGoalPicker(
            context: context,
            goals: scheduledGoals,
            onSelectGoal: onSelectGoal,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.flag_rounded, color: palette.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (taskTitle != null) ...[
                        Text(
                          context.tr('Enfoque actual', 'Current focus'),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 3),
                      ],
                      Text(
                        _focusContextLabel(
                          context: context,
                          taskTitle: taskTitle,
                          goal: goal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: taskTitle == null
                            ? Theme.of(context).textTheme.titleSmall
                            : Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: palette.textSecondary,
                              ),
                      ),
                    ],
                  ),
                ),
                if (onCompleteTask != null)
                  IconButton(
                    tooltip: context.tr(
                      'Marcar tarea completada',
                      'Mark task as completed',
                    ),
                    onPressed: onCompleteTask,
                    icon: const Icon(Icons.done_all_rounded),
                  ),
                const Icon(Icons.expand_more_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _focusContextLabel({
  required BuildContext context,
  required String? taskTitle,
  required ProductivityGoal? goal,
}) {
  final goalLabel = goal == null
      ? context.tr('Sin objetivo', 'No goal')
      : goal.title;
  if (taskTitle == null) {
    return goal == null
        ? context.tr('Sin objetivo', 'No goal')
        : _goalLabel(context, goal);
  }

  return '$taskTitle - $goalLabel';
}

String _phaseTitle(BuildContext context, PomodoroPhase phase) {
  return switch (phase) {
    PomodoroPhase.focus => context.tr('MODO ENFOQUE', 'FOCUS MODE'),
    PomodoroPhase.shortBreak => context.tr('DESCANSO CORTO', 'SHORT BREAK'),
    PomodoroPhase.longBreak => context.tr('DESCANSO LARGO', 'LONG BREAK'),
  };
}

class _FocusLifecycleActions extends StatelessWidget {
  const _FocusLifecycleActions({
    required this.phase,
    required this.hasElapsedPhase,
    required this.onDiscard,
    required this.onRestart,
    required this.onFinishEarly,
  });

  final PomodoroPhase phase;
  final bool hasElapsedPhase;
  final VoidCallback onDiscard;
  final VoidCallback onRestart;
  final VoidCallback onFinishEarly;

  @override
  Widget build(BuildContext context) {
    final isBreak = phase != PomodoroPhase.focus;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: _CompactLifecycleButton(
              label: context.tr('Descartar', 'Discard'),
              icon: Icons.close_rounded,
              onPressed: hasElapsedPhase ? onDiscard : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactLifecycleButton(
              label: context.tr('Reiniciar', 'Restart'),
              icon: Icons.replay_rounded,
              onPressed: onRestart,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactLifecycleButton(
              label: isBreak
                  ? context.tr('Saltar', 'Skip')
                  : context.tr('Terminar', 'Finish'),
              icon: Icons.flag_rounded,
              onPressed: hasElapsedPhase ? onFinishEarly : null,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactLifecycleButton extends StatelessWidget {
  const _CompactLifecycleButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(38)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      textStyle: WidgetStatePropertyAll(
        Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    final iconWidget = Icon(icon, size: 17);
    final labelWidget = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(label, maxLines: 1),
    );

    if (filled) {
      return FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: iconWidget,
        label: labelWidget,
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: iconWidget,
      label: labelWidget,
    );
  }
}

Future<void> _showGoalPicker({
  required BuildContext context,
  required List<ProductivityGoal> goals,
  required ValueChanged<String?> onSelectGoal,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final palette = sheetContext.palette;

      return SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 520),
          child: ListView(
            padding: AppCardPaddings.standard,
            shrinkWrap: true,
            children: [
              Text(
                sheetContext.tr(
                  'Objetivo del Pomodoro',
                  'Pomodoro goal',
                ),
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                sheetContext.tr(
                  'Elige un objetivo fechado en el calendario o deja este '
                      'Pomodoro sin objetivo.',
                  'Choose a goal scheduled in the calendar or leave this '
                      'Pomodoro without a goal.',
                ),
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.not_interested_rounded),
                title: Text(sheetContext.tr('Sin objetivo', 'No goal')),
                onTap: () {
                  onSelectGoal(null);
                  Navigator.of(sheetContext).pop();
                },
              ),
              for (final goal in goals)
                ListTile(
                  leading: Icon(Icons.flag_rounded, color: palette.primary),
                  title: Text(goal.title),
                  subtitle: Text(_goalLabel(sheetContext, goal)),
                  onTap: () {
                    onSelectGoal(goal.id);
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

String _goalLabel(BuildContext context, ProductivityGoal goal) {
  final date = goal.targetDate;
  final dateLabel = date == null
      ? context.tr('Sin fecha', 'No date')
      : context.tr(
          '${date.day.toString().padLeft(2, '0')}/'
              '${date.month.toString().padLeft(2, '0')}',
          '${date.month.toString().padLeft(2, '0')}/'
              '${date.day.toString().padLeft(2, '0')}',
        );

  return '${goal.title} - ${goal.completedSessions}/${goal.targetSessions} - '
      '$dateLabel';
}

Future<void> _handleStartPressed(
  BuildContext context,
  PomodoroRuntimeScope runtime,
) async {
  if (runtime.isRunning) {
    runtime.onPlayPause();
    return;
  }

  final pomodoroController = serviceLocator<PomodoroController>();
  var selectedMoodScore = pomodoroController.selectedFocusStartMoodScore ?? 3;
  final startFullscreen = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final palette = context.palette;

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: AppCardPaddings.standard,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Empezar enfoque', 'Start focus'),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr(
                      'Antes de iniciar, registra cómo te sientes del 1 al 5.',
                      'Before starting, rate how you feel from 1 to 5.',
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MoodScoreSelector(
                    selectedScore: selectedMoodScore,
                    onChanged: (value) =>
                        setSheetState(() => selectedMoodScore = value),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.fullscreen_rounded),
                      label: Text(
                        context.tr('Pantalla completa', 'Full screen'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        context.tr('Iniciar normal', 'Start normally'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  if (startFullscreen == null) {
    return;
  }

  pomodoroController.setFocusStartMoodScore(selectedMoodScore);
  runtime.onPlayPause();

  if (startFullscreen &&
      !pomodoroController.maximumConcentrationEnabled.value &&
      context.mounted) {
    await context.push<void>(PomodoroFullscreenPage.routePath);
  }
}

Future<void> _changeCurrentPlanSilence(
  BuildContext context,
  bool enabled,
) async {
  if (!serviceLocator.isRegistered<FocusSilenceController>()) return;
  final controller = serviceLocator<FocusSilenceController>();
  if (!enabled) {
    await controller.setCurrentPlanEnabled(enabled: false);
    return;
  }

  await controller.refreshCapability();
  if (controller.capability.value.isAuthorized) {
    await controller.setCurrentPlanEnabled(enabled: true);
    return;
  }
  if (!context.mounted) return;

  final authorize = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        context.tr('Autorizar No molestar', 'Authorize Do Not Disturb'),
      ),
      content: Text(
        context.tr(
          'El Pomodoro seguirá funcionando. Android debe autorizar primero la regla propia de Michi Focus.',
          'The Pomodoro will keep running. Android must first authorize the Michi Focus rule.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.tr('Autorizar en Android', 'Authorize in Android'),
          ),
        ),
      ],
    ),
  );
  if (authorize ?? false) {
    await controller.requestAuthorization(forCurrentPlan: true);
  }
}

class PomodoroFullscreenPage extends StatefulWidget {
  const PomodoroFullscreenPage({super.key});

  static const String routePath = PomodoroPage.fullscreenRoutePath;

  @override
  State<PomodoroFullscreenPage> createState() => _PomodoroFullscreenPageState();
}

class _PomodoroFullscreenPageState extends State<PomodoroFullscreenPage> {
  static const List<Offset> _amoledProtectionOffsets = [
    Offset.zero,
    Offset(0, -0.012),
    Offset.zero,
    Offset(0, 0.012),
  ];

  bool _hasShownMaximumConcentration = false;
  bool _isClosingMaximumConcentration = false;
  Timer? _amoledProtectionTimer;
  int _amoledProtectionOffsetIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _amoledProtectionTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _advanceAmoledProtection(),
    );
  }

  void _advanceAmoledProtection() {
    if (!mounted) return;
    final controller = serviceLocator<PomodoroController>();
    final shouldMove =
        controller.maximumConcentrationEnabled.value &&
        controller.hasStartedRuntime.value &&
        controller.maximumConcentrationStyle.value ==
            MaximumConcentrationStyle.oled &&
        controller.amoledProtectionEnabled.value;
    if (!shouldMove) return;

    setState(() {
      _amoledProtectionOffsetIndex =
          (_amoledProtectionOffsetIndex + 1) % _amoledProtectionOffsets.length;
    });
  }

  @override
  void dispose() {
    _amoledProtectionTimer?.cancel();
    final controller = serviceLocator<PomodoroController>();
    if (controller.maximumConcentrationEnabled.value) {
      controller.maximumConcentrationMode = false;
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final runtime = PomodoroRuntimeScope.of(context);
    final controller = serviceLocator<PomodoroController>();

    return SignalBuilder(
      builder: (context) {
        final maximumConcentrationEnabled =
            controller.maximumConcentrationEnabled.value;
        final maximumConcentrationStyle =
            controller.maximumConcentrationStyle.value;
        final amoledProtectionEnabled =
            controller.amoledProtectionEnabled.value;
        final keepScreenAwakeEnabled = controller.keepScreenAwakeEnabled.value;
        final maximumConcentrationOpacity =
            appSettingsController.maximumConcentrationOpacity.value;
        final maximumConcentrationActive =
            maximumConcentrationEnabled && runtime.hasStartedRuntime;
        if (maximumConcentrationActive) {
          _hasShownMaximumConcentration = true;
        } else if (_hasShownMaximumConcentration &&
            !_isClosingMaximumConcentration) {
          _isClosingMaximumConcentration = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && context.canPop()) {
              context.pop();
            }
          });
        }
        final showMaximumConcentrationSurface =
            maximumConcentrationActive || _isClosingMaximumConcentration;
        final maximumColors = showMaximumConcentrationSurface
            ? _maximumConcentrationColors(
                maximumConcentrationStyle,
                maximumConcentrationOpacity,
              )
            : null;

        final minutes = runtime.remainingSeconds ~/ 60;
        final seconds = runtime.remainingSeconds % 60;
        final progress = runtime.timerProgress;
        final timeLabel =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        final content = SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: AnimatedSlide(
              key: const Key('amoledProtectedContent'),
              offset:
                  maximumConcentrationActive &&
                      maximumConcentrationStyle ==
                          MaximumConcentrationStyle.oled &&
                      amoledProtectionEnabled
                  ? _amoledProtectionOffsets[_amoledProtectionOffsetIndex]
                  : Offset.zero,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  Expanded(
                    child: GestureDetector(
                      key: const Key('maximumConcentrationExitArea'),
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: maximumConcentrationActive
                          ? () => controller.maximumConcentrationMode = false
                          : null,
                      child: Column(
                        children: [
                          const Spacer(),
                          AspectRatio(
                            aspectRatio: 1,
                            child: RepaintBoundary(
                              child: CustomPaint(
                                painter: _TimerRingPainter(
                                  palette: palette,
                                  progress: progress,
                                  maximumColors: maximumColors,
                                ),
                                child: _TimerFace(
                                  timeLabel: timeLabel,
                                  phaseLabel: _phaseTitle(
                                    context,
                                    runtime.phase,
                                  ),
                                  maximumColors: maximumColors,
                                ),
                              ),
                            ),
                          ),
                          if (!showMaximumConcentrationSurface &&
                              runtime.taskEstimatedSeconds != null) ...[
                            const SizedBox(height: 12),
                            _TaskPlanInfoButton(runtime: runtime),
                          ],
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  if (runtime.hasActiveRuntime) ...[
                    _PomodoroCompletionIndicator(
                      runtime: runtime,
                      maximumColors: maximumColors,
                    ),
                    const SizedBox(height: 14),
                  ],
                  Row(
                    key: const Key('amoledProtectedControls'),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CircleAction(
                        icon: Icons.replay_rounded,
                        onPressed: runtime.onReset,
                        outline: true,
                        maximumColors: maximumColors,
                      ),
                      _CircleAction(
                        icon: runtime.isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        onPressed: runtime.onPlayPause,
                        large: true,
                        maximumColors: maximumColors,
                      ),
                      _FocusDisplayMenuButton(
                        isFullscreen: true,
                        maximumConcentrationEnabled:
                            maximumConcentrationEnabled,
                        maximumConcentrationActive:
                            showMaximumConcentrationSurface,
                        maximumConcentrationStyle: maximumConcentrationStyle,
                        amoledProtectionEnabled: amoledProtectionEnabled,
                        keepScreenAwakeEnabled: keepScreenAwakeEnabled,
                        maximumConcentrationOpacity:
                            maximumConcentrationOpacity,
                        showFocusSilenceControl:
                            runtime.hasActiveRuntime &&
                            serviceLocator
                                .isRegistered<FocusSilenceController>(),
                        focusSilenceEnabled:
                            serviceLocator
                                .isRegistered<FocusSilenceController>() &&
                            serviceLocator<FocusSilenceController>()
                                .effectivePlanEnabled &&
                            serviceLocator<FocusSilenceController>()
                                .capability
                                .value
                                .isAuthorized,
                        maximumColors: maximumColors,
                        onMaximumConcentrationChanged: (enabled) =>
                            controller.maximumConcentrationMode = enabled,
                        onMaximumConcentrationStyleChanged: (style) =>
                            controller.maximumConcentrationDisplayStyle = style,
                        onAmoledProtectionChanged: (enabled) =>
                            controller.amoledProtection = enabled,
                        onKeepScreenAwakeChanged: (enabled) =>
                            controller.keepScreenAwake = enabled,
                        onMaximumConcentrationOpacityChanged:
                            appSettingsController
                                .setMaximumConcentrationOpacity,
                        onMaximumConcentrationOpacityChangeEnd: (_) =>
                            unawaited(
                              appSettingsController.saveTimerPreferences(),
                            ),
                        onFocusSilenceChanged: (enabled) => unawaited(
                          _changeCurrentPlanSilence(context, enabled),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        return Scaffold(
          backgroundColor: showMaximumConcentrationSurface
              ? maximumColors!.background
              : palette.background,
          body: showMaximumConcentrationSurface
              ? ColoredBox(
                  key: const Key('maximumConcentrationSurface'),
                  color: maximumColors!.background,
                  child: content,
                )
              : DecoratedBox(
                  decoration: palette.appBackgroundDecoration,
                  child: content,
                ),
        );
      },
    );
  }
}

class _MaximumConcentrationColors {
  const _MaximumConcentrationColors({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.track,
    required this.surface,
    required this.border,
  });

  final Color background;
  final Color primary;
  final Color secondary;
  final Color track;
  final Color surface;
  final Color border;
}

_MaximumConcentrationColors _maximumConcentrationColors(
  MaximumConcentrationStyle style,
  double opacity,
) {
  return switch (style) {
    MaximumConcentrationStyle.clear => const _MaximumConcentrationColors(
      background: Color(0xFFFFFFFF),
      primary: Color(0xFF000000),
      secondary: Color(0x99000000),
      track: Color(0x1F000000),
      surface: Color(0xFFF5F5F5),
      border: Color(0x33000000),
    ),
    MaximumConcentrationStyle.oled => _MaximumConcentrationColors(
      background: const Color(0xFF000000),
      primary: _dimAmoledColor(const Color(0xFFC8C8C8), opacity),
      secondary: _dimAmoledColor(const Color(0xFF7C7C7C), opacity),
      track: _dimAmoledColor(const Color(0xFF242424), opacity),
      surface: _dimAmoledColor(const Color(0xFF101010), opacity),
      border: _dimAmoledColor(const Color(0xFF383838), opacity),
    ),
  };
}

Color _dimAmoledColor(Color color, double opacity) {
  return Color.lerp(
    const Color(0xFF000000),
    color,
    opacity.clamp(0.2, 1),
  )!;
}

class _TimerFace extends StatelessWidget {
  const _TimerFace({
    required this.timeLabel,
    required this.phaseLabel,
    this.maximumColors,
  });

  final String timeLabel;
  final String phaseLabel;
  final _MaximumConcentrationColors? maximumColors;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final maximumConcentration = maximumColors != null;

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                timeLabel,
                key: const Key('pomodoroTimeLabel'),
                maxLines: 1,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: maximumConcentration
                      ? maximumColors!.primary
                      : palette.primary,
                  fontSize: AppDesignTokens.timerFontSize - 2,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                phaseLabel,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: maximumConcentration
                      ? maximumColors!.secondary
                      : palette.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PomodoroCompletionIndicator extends StatelessWidget {
  const _PomodoroCompletionIndicator({
    required this.runtime,
    this.maximumColors,
  });

  final PomodoroRuntimeScope runtime;
  final _MaximumConcentrationColors? maximumColors;

  @override
  Widget build(BuildContext context) {
    final color = maximumColors?.secondary ?? context.palette.textSecondary;
    return Semantics(
      label: context.tr(
        '${runtime.completedPlanPomodoros} de ${runtime.totalBlocks} Pomodoros completados',
        '${runtime.completedPlanPomodoros} of ${runtime.totalBlocks} completed Pomodoros',
      ),
      child: Row(
        key: const Key('pomodoroPlanProgressLabel'),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 19, color: color),
          const SizedBox(width: 6),
          Text(
            '${runtime.completedPlanPomodoros}/${runtime.totalBlocks}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskPlanInfoButton extends StatelessWidget {
  const _TaskPlanInfoButton({required this.runtime});

  final PomodoroRuntimeScope runtime;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: context.tr('Ver detalles del plan', 'View plan details'),
      onPressed: () => _showTaskPlanDetails(context, runtime),
      icon: const Icon(Icons.info_outline_rounded),
    );
  }
}

Future<void> _showTaskPlanDetails(
  BuildContext context,
  PomodoroRuntimeScope runtime,
) {
  final planLabel = _taskPlanLabel(context, runtime);
  final progressLabel = _taskProgressLabel(runtime);
  final nextStepLabel = _nextStepLabel(context, runtime);
  final projectedElapsedLabel = _projectedElapsedLabel(context, runtime);

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.palette.surface,
    builder: (sheetContext) => SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: AppCardPaddings.standard,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheetContext.tr('Detalles del plan', 'Plan details'),
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              if (planLabel != null)
                _TaskPlanDetailRow(
                  icon: Icons.view_agenda_outlined,
                  label: planLabel,
                ),
              if (progressLabel != null)
                _TaskPlanDetailRow(
                  icon: Icons.donut_large_rounded,
                  label: progressLabel,
                ),
              if (nextStepLabel != null)
                _TaskPlanDetailRow(
                  icon: Icons.skip_next_rounded,
                  label: nextStepLabel,
                ),
              if (projectedElapsedLabel != null)
                _TaskPlanDetailRow(
                  icon: Icons.schedule_rounded,
                  label: projectedElapsedLabel,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _TaskPlanDetailRow extends StatelessWidget {
  const _TaskPlanDetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: palette.primary),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String? _taskPlanLabel(
  BuildContext context,
  PomodoroRuntimeScope runtime,
) {
  if (runtime.taskEstimatedSeconds == null) {
    return null;
  }
  return context.tr(
    'BLOQUE ${runtime.currentBlockIndex} DE ${runtime.totalBlocks}',
    'BLOCK ${runtime.currentBlockIndex} OF ${runtime.totalBlocks}',
  );
}

String? _taskProgressLabel(PomodoroRuntimeScope runtime) {
  final estimatedSeconds = runtime.taskEstimatedSeconds;
  if (estimatedSeconds == null || estimatedSeconds <= 0) {
    return null;
  }
  final focusedMinutes = runtime.taskFocusedSeconds ~/ 60;
  final estimatedMinutes = estimatedSeconds ~/ 60;
  final percentage = ((runtime.taskFocusedSeconds / estimatedSeconds) * 100)
      .clamp(0, 100)
      .round();
  return '$focusedMinutes/$estimatedMinutes min · $percentage%';
}

String? _nextStepLabel(
  BuildContext context,
  PomodoroRuntimeScope runtime,
) {
  if (runtime.taskEstimatedSeconds == null) {
    return null;
  }
  if (runtime.phase != PomodoroPhase.focus) {
    if (runtime.planMode == PomodoroPlanMode.continuous &&
        runtime.currentBlockIndex < runtime.totalBlocks) {
      return context.tr(
        'Después: bloque ${runtime.currentBlockIndex + 1}',
        'Next: block ${runtime.currentBlockIndex + 1}',
      );
    }
    return context.tr('Después: finalizar por ahora', 'Next: finish for now');
  }
  final hasBreak =
      runtime.planMode == PomodoroPlanMode.singleBlock ||
      runtime.currentBlockIndex < runtime.totalBlocks;
  if (!hasBreak) {
    return context.tr('Último bloque del plan', 'Last block in the plan');
  }
  return context.tr(
    'Después: descanso de ${runtime.cadenceBreakMinutes} min',
    'Next: ${runtime.cadenceBreakMinutes} min break',
  );
}

String? _projectedElapsedLabel(
  BuildContext context,
  PomodoroRuntimeScope runtime,
) {
  final estimatedSeconds = runtime.taskEstimatedSeconds;
  if (estimatedSeconds == null || estimatedSeconds <= 0) {
    return null;
  }

  final taskFocusRemaining = math.max(
    0,
    estimatedSeconds - runtime.taskFocusedSeconds,
  );
  var projectedSeconds = runtime.remainingSeconds;

  if (runtime.phase == PomodoroPhase.focus) {
    if (runtime.planMode == PomodoroPlanMode.continuous) {
      final remainingBreaks = math.max(
        0,
        runtime.totalBlocks - runtime.currentBlockIndex,
      );
      projectedSeconds =
          taskFocusRemaining +
          remainingBreaks * runtime.cadenceBreakMinutes * 60;
    } else if (taskFocusRemaining > runtime.remainingSeconds) {
      projectedSeconds += runtime.cadenceBreakMinutes * 60;
    }
  } else if (runtime.planMode == PomodoroPlanMode.continuous) {
    final futureBreaks = math.max(
      0,
      runtime.totalBlocks - runtime.currentBlockIndex - 1,
    );
    projectedSeconds +=
        taskFocusRemaining + futureBreaks * runtime.cadenceBreakMinutes * 60;
  }

  final projectedMinutes = math.max(1, (projectedSeconds / 60).ceil());
  final label = runtime.planMode == PomodoroPlanMode.singleBlock
      ? context.tr('Sesión restante', 'Session remaining')
      : context.tr('Plan restante', 'Plan remaining');
  return context.tr(
    '$label: ~$projectedMinutes min de reloj',
    '$label: ~$projectedMinutes min elapsed time',
  );
}

class _TimerRingPainter extends CustomPainter {
  const _TimerRingPainter({
    required this.palette,
    required this.progress,
    this.maximumColors,
  });

  final AppPalette palette;
  final double progress;
  final _MaximumConcentrationColors? maximumColors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final ring = rect.deflate(12);
    final strokeWidth = size.width * 0.055;
    final track = Paint()
      ..color = maximumColors != null
          ? maximumColors!.track
          : palette.primaryMuted.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: maximumColors != null
            ? [
                maximumColors!.secondary,
                maximumColors!.primary,
                maximumColors!.secondary,
              ]
            : [palette.secondarySoft, palette.primary, palette.secondarySoft],
        stops: const [0, 0.7, 1],
      ).createShader(ring)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawArc(ring, -math.pi / 2, math.pi * 2, false, track)
      ..drawArc(
        ring,
        -math.pi / 2,
        math.pi * 2 * progress,
        false,
        progressPaint,
      );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.palette != palette ||
        oldDelegate.maximumColors != maximumColors;
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onPressed,
    this.large = false,
    this.outline = false,
    this.maximumColors,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool large;
  final bool outline;
  final _MaximumConcentrationColors? maximumColors;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colorScheme = Theme.of(context).colorScheme;
    final size = large ? 112.0 : 82.0;

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: maximumColors != null
              ? maximumColors!.surface
              : large
              ? palette.primary
              : palette.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: maximumColors != null
                ? maximumColors!.border
                : outline
                ? palette.primary
                : palette.neutralSoft,
            width: outline ? 1.4 : 1,
          ),
          boxShadow: large && maximumColors == null
              ? [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: large ? 44 : 34),
          color: maximumColors != null
              ? maximumColors!.primary
              : large
              ? colorScheme.onPrimary
              : palette.primary,
        ),
      ),
    );
  }
}

enum _FocusDisplayAction {
  toggleFullscreen,
  toggleMaximumConcentration,
  toggleKeepScreenAwake,
  selectClear,
  selectOled,
  toggleAmoledProtection,
  toggleFocusSilence,
}

class _FocusDisplayMenuButton extends StatelessWidget {
  const _FocusDisplayMenuButton({
    required this.isFullscreen,
    required this.maximumConcentrationEnabled,
    required this.maximumConcentrationActive,
    required this.maximumConcentrationStyle,
    required this.amoledProtectionEnabled,
    required this.keepScreenAwakeEnabled,
    required this.maximumConcentrationOpacity,
    required this.showFocusSilenceControl,
    required this.focusSilenceEnabled,
    required this.onMaximumConcentrationChanged,
    required this.onMaximumConcentrationStyleChanged,
    required this.onAmoledProtectionChanged,
    required this.onKeepScreenAwakeChanged,
    required this.onMaximumConcentrationOpacityChanged,
    required this.onMaximumConcentrationOpacityChangeEnd,
    required this.onFocusSilenceChanged,
    this.maximumColors,
  });

  final bool isFullscreen;
  final bool maximumConcentrationEnabled;
  final bool maximumConcentrationActive;
  final MaximumConcentrationStyle maximumConcentrationStyle;
  final bool amoledProtectionEnabled;
  final bool keepScreenAwakeEnabled;
  final double maximumConcentrationOpacity;
  final bool showFocusSilenceControl;
  final bool focusSilenceEnabled;
  final _MaximumConcentrationColors? maximumColors;
  final ValueChanged<bool> onMaximumConcentrationChanged;
  final ValueChanged<MaximumConcentrationStyle>
  onMaximumConcentrationStyleChanged;
  final ValueChanged<bool> onAmoledProtectionChanged;
  final ValueChanged<bool> onKeepScreenAwakeChanged;
  final ValueChanged<double> onMaximumConcentrationOpacityChanged;
  final ValueChanged<double> onMaximumConcentrationOpacityChangeEnd;
  final ValueChanged<bool> onFocusSilenceChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox.square(
      dimension: 82,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: maximumConcentrationActive
              ? maximumColors!.surface
              : palette.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: maximumConcentrationActive
                ? maximumColors!.border
                : palette.neutralSoft,
          ),
        ),
        child: IconButton(
          tooltip: context.tr(
            'Opciones de visualización',
            'Display options',
          ),
          icon: Icon(
            Icons.more_vert_rounded,
            size: 34,
            color: maximumConcentrationActive
                ? maximumColors!.primary
                : palette.primary.withValues(alpha: 0.75),
          ),
          onPressed: () => unawaited(_showDisplayMenu(context)),
        ),
      ),
    );
  }

  Future<void> _showDisplayMenu(BuildContext context) async {
    final button = context.findRenderObject();
    final overlay = Overlay.of(context).context.findRenderObject();
    if (button is! RenderBox || overlay is! RenderBox) {
      return;
    }

    final router = GoRouter.of(context);
    final palette = context.palette;
    final fullscreenLabel = isFullscreen
        ? context.tr('Salir de pantalla completa', 'Exit full screen')
        : context.tr('Ver en pantalla completa', 'View full screen');
    final buttonRect = Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    );

    final action = await showMenu<_FocusDisplayAction>(
      context: context,
      position: RelativeRect.fromRect(
        buttonRect,
        Offset.zero & overlay.size,
      ),
      constraints: const BoxConstraints(minWidth: 260, maxWidth: 320),
      color: maximumConcentrationActive
          ? maximumColors!.surface
          : palette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        if (!maximumConcentrationActive)
          PopupMenuItem<_FocusDisplayAction>(
            value: _FocusDisplayAction.toggleFullscreen,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFullscreen
                      ? Icons.close_fullscreen_rounded
                      : Icons.fullscreen_rounded,
                ),
                const SizedBox(width: 12),
                Flexible(child: Text(fullscreenLabel)),
              ],
            ),
          ),
        PopupMenuItem<_FocusDisplayAction>(
          value: _FocusDisplayAction.toggleMaximumConcentration,
          child: SignalBuilder(
            builder: (context) {
              final liveColors = maximumConcentrationActive
                  ? _maximumConcentrationColors(
                      maximumConcentrationStyle,
                      appSettingsController.maximumConcentrationOpacity.value,
                    )
                  : null;
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr(
                        'Máxima concentración',
                        'Maximum concentration',
                      ),
                      style: liveColors == null
                          ? null
                          : TextStyle(color: liveColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    key: const Key('maximumConcentrationSwitch'),
                    value: maximumConcentrationEnabled,
                    onChanged: (_) => Navigator.of(context).pop(
                      _FocusDisplayAction.toggleMaximumConcentration,
                    ),
                    activeColor: liveColors?.primary,
                    activeTrackColor: liveColors?.secondary,
                    inactiveThumbColor: liveColors?.secondary,
                    inactiveTrackColor: liveColors?.track,
                  ),
                ],
              );
            },
          ),
        ),
        PopupMenuItem<_FocusDisplayAction>(
          value: _FocusDisplayAction.toggleKeepScreenAwake,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.tr(
                    'Mantener pantalla encendida',
                    'Keep screen awake',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                key: const Key('keepScreenAwakeSwitch'),
                value: keepScreenAwakeEnabled,
                onChanged: (_) => Navigator.of(context).pop(
                  _FocusDisplayAction.toggleKeepScreenAwake,
                ),
                activeColor: maximumConcentrationActive
                    ? maximumColors!.primary
                    : null,
                activeTrackColor: maximumConcentrationActive
                    ? maximumColors!.secondary
                    : null,
              ),
            ],
          ),
        ),
        if (showFocusSilenceControl)
          PopupMenuItem<_FocusDisplayAction>(
            value: _FocusDisplayAction.toggleFocusSilence,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr(
                      'Bloquear notificaciones en este Pomodoro',
                      'Block notifications in this Pomodoro',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: focusSilenceEnabled,
                  onChanged: (_) => Navigator.of(context).pop(
                    _FocusDisplayAction.toggleFocusSilence,
                  ),
                ),
              ],
            ),
          ),
        if (maximumConcentrationEnabled) ...[
          const PopupMenuDivider(),
          _maximumStyleMenuItem(
            context: context,
            action: _FocusDisplayAction.selectClear,
            style: MaximumConcentrationStyle.clear,
            icon: Icons.light_mode_outlined,
            label: context.tr('Claro', 'Clear'),
          ),
          _maximumStyleMenuItem(
            context: context,
            action: _FocusDisplayAction.selectOled,
            style: MaximumConcentrationStyle.oled,
            icon: Icons.brightness_2_outlined,
            label: 'OLED',
          ),
          if (maximumConcentrationStyle == MaximumConcentrationStyle.oled) ...[
            const PopupMenuDivider(),
            _AmoledOpacityMenuEntry(
              value: maximumConcentrationOpacity,
              color: maximumConcentrationActive
                  ? const Color(0xFFC8C8C8)
                  : palette.primary,
              dimColor: maximumConcentrationActive,
              onChanged: onMaximumConcentrationOpacityChanged,
              onChangeEnd: onMaximumConcentrationOpacityChangeEnd,
            ),
            PopupMenuItem<_FocusDisplayAction>(
              value: _FocusDisplayAction.toggleAmoledProtection,
              child: SignalBuilder(
                builder: (context) {
                  final liveColors = maximumConcentrationActive
                      ? _maximumConcentrationColors(
                          maximumConcentrationStyle,
                          appSettingsController
                              .maximumConcentrationOpacity
                              .value,
                        )
                      : null;
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr(
                            'Protección AMOLED',
                            'AMOLED protection',
                          ),
                          style: liveColors == null
                              ? null
                              : TextStyle(color: liveColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: amoledProtectionEnabled,
                        onChanged: (_) => Navigator.of(context).pop(
                          _FocusDisplayAction.toggleAmoledProtection,
                        ),
                        activeColor: liveColors?.primary,
                        activeTrackColor: liveColors?.secondary,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ],
    );
    if (action == null) {
      return;
    }

    if (action == _FocusDisplayAction.toggleMaximumConcentration) {
      onMaximumConcentrationChanged(!maximumConcentrationEnabled);
      return;
    }

    if (action == _FocusDisplayAction.toggleKeepScreenAwake) {
      onKeepScreenAwakeChanged(!keepScreenAwakeEnabled);
      return;
    }

    if (action == _FocusDisplayAction.selectClear) {
      onMaximumConcentrationStyleChanged(MaximumConcentrationStyle.clear);
      return;
    }

    if (action == _FocusDisplayAction.selectOled) {
      onMaximumConcentrationStyleChanged(MaximumConcentrationStyle.oled);
      return;
    }

    if (action == _FocusDisplayAction.toggleAmoledProtection) {
      onAmoledProtectionChanged(!amoledProtectionEnabled);
      return;
    }

    if (action == _FocusDisplayAction.toggleFocusSilence) {
      onFocusSilenceChanged(!focusSilenceEnabled);
      return;
    }

    if (isFullscreen) {
      router.pop();
      return;
    }

    await router.push<void>(PomodoroFullscreenPage.routePath);
  }

  PopupMenuItem<_FocusDisplayAction> _maximumStyleMenuItem({
    required BuildContext context,
    required _FocusDisplayAction action,
    required MaximumConcentrationStyle style,
    required IconData icon,
    required String label,
  }) {
    final selected = maximumConcentrationStyle == style;
    return PopupMenuItem<_FocusDisplayAction>(
      value: action,
      child: SignalBuilder(
        builder: (context) {
          final foreground = maximumConcentrationActive
              ? _maximumConcentrationColors(
                  maximumConcentrationStyle,
                  appSettingsController.maximumConcentrationOpacity.value,
                ).primary
              : context.palette.textPrimary;
          return Row(
            children: [
              Icon(icon, color: foreground),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: TextStyle(color: foreground)),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: foreground,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AmoledOpacityMenuEntry extends PopupMenuEntry<_FocusDisplayAction> {
  const _AmoledOpacityMenuEntry({
    required this.value,
    required this.color,
    required this.dimColor,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final double value;
  final Color color;
  final bool dimColor;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  double get height => 92;

  @override
  bool represents(_FocusDisplayAction? value) => false;

  @override
  State<_AmoledOpacityMenuEntry> createState() =>
      _AmoledOpacityMenuEntryState();
}

class _AmoledOpacityMenuEntryState extends State<_AmoledOpacityMenuEntry> {
  late double _value = widget.value;

  @override
  Widget build(BuildContext context) {
    final color = widget.dimColor
        ? _dimAmoledColor(widget.color, _value)
        : widget.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(
            'Opacidad AMOLED ${(_value * 100).round()}%',
            'AMOLED opacity ${(_value * 100).round()}%',
          ),
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
        Slider(
          key: const Key('maximumConcentrationOpacitySlider'),
          value: _value,
          min: 0.2,
          divisions: 16,
          activeColor: color,
          inactiveColor: color.withValues(alpha: 0.28),
          onChanged: (value) {
            setState(() => _value = value);
            widget.onChanged(value);
          },
          onChangeEnd: widget.onChangeEnd,
        ),
      ],
    );
  }
}

class _TimerStat extends StatelessWidget {
  const _TimerStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
