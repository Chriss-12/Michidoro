import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/pomodoro_runtime_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/pomodoro_time_settings_page.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
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
        const SizedBox(height: 92),
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

            return _FocusReflectionCard(
              onSubmit: pomodoroController.submitCompletionReflection,
            );
          },
        ),
        const SizedBox(height: 24),
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
  const _FocusReflectionCard({required this.onSubmit});

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
  int _endMoodScore = 3;
  bool _wasDistracted = false;
  int _distractionMinutes = 5;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GlassCard(
        padding: AppCardPaddings.compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.self_improvement_rounded, color: palette.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cierre de enfoque',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Como te sientes despues de esta sesion?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            _MoodScoreSelector(
              selectedScore: _endMoodScore,
              onChanged: (value) => setState(() => _endMoodScore = value),
            ),
            const SizedBox(height: 14),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.check_circle_outline_rounded),
                  label: Text('Todo bien'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.visibility_off_outlined),
                  label: Text('Me distraje'),
                ),
              ],
              selected: {_wasDistracted},
              onSelectionChanged: (values) =>
                  setState(() => _wasDistracted = values.single),
            ),
            if (_wasDistracted) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Minutos aproximados',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    '$_distractionMinutes min',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: palette.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _distractionMinutes.toDouble(),
                min: 1,
                max: 60,
                divisions: 59,
                label: '$_distractionMinutes min',
                onChanged: (value) =>
                    setState(() => _distractionMinutes = value.round()),
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving
                    ? null
                    : () async {
                        setState(() => _isSaving = true);
                        await widget.onSubmit(
                          endMoodScore: _endMoodScore,
                          wasDistracted: _wasDistracted,
                          distractionMinutes: _distractionMinutes,
                        );
                        if (mounted) {
                          setState(() => _isSaving = false);
                        }
                      },
                icon: const Icon(Icons.save_alt_rounded),
                label: const Text('Guardar reflexion'),
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

  final int selectedScore;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        for (var score = 1; score <= 5; score += 1) ...[
          Expanded(
            child: Tooltip(
              message: '$score de 5',
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
                    child: Text(
                      '$score',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: selectedScore == score
                            ? Theme.of(context).colorScheme.onPrimary
                            : palette.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
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

class _TimerRingSection extends StatelessWidget {
  const _TimerRingSection();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final runtime = PomodoroRuntimeScope.of(context);
    final minutes = runtime.remainingSeconds ~/ 60;
    final seconds = runtime.remainingSeconds % 60;
    final totalSeconds = runtime.currentPhaseSeconds;
    final progress = totalSeconds <= 0
        ? 0.0
        : 1 - (runtime.remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    final timeLabel =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: AspectRatio(
        aspectRatio: 1,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _TimerRingPainter(
              palette: palette,
              progress: progress,
            ),
            child: _TimerFace(
              timeLabel: timeLabel,
              phaseLabel: _phaseTitle(runtime.phase),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerControlsSection extends StatelessWidget {
  const _TimerControlsSection();

  @override
  Widget build(BuildContext context) {
    final runtime = PomodoroRuntimeScope.of(context);

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
        _CircleAction(
          icon: Icons.more_vert_rounded,
          onPressed: () => context.push(PomodoroTimeSettingsPage.routePath),
          muted: true,
        ),
      ],
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
      onFinishEarly: () => unawaited(runtime.onFinishEarly()),
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
            child: _TimerStat(label: 'Hoy', value: focusedLabel),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: _TimerStat(
              label: 'Sesiones',
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
                      Text(
                        taskTitle == null
                            ? 'Este Pomodoro suma a'
                            : 'Enfoque actual',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _focusContextLabel(
                          taskTitle: taskTitle,
                          goal: goal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onCompleteTask != null)
                  IconButton(
                    tooltip: 'Marcar tarea completada',
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
  required String? taskTitle,
  required ProductivityGoal? goal,
}) {
  final goalLabel = goal == null ? 'Sin objetivo' : goal.title;
  if (taskTitle == null) {
    return goal == null ? 'Sin objetivo' : _goalLabel(goal);
  }

  return '$taskTitle - $goalLabel';
}

String _phaseTitle(PomodoroPhase phase) {
  return switch (phase) {
    PomodoroPhase.focus => 'MODO ENFOQUE',
    PomodoroPhase.shortBreak => 'DESCANSO CORTO',
    PomodoroPhase.longBreak => 'DESCANSO LARGO',
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
              label: 'Descartar',
              icon: Icons.close_rounded,
              onPressed: hasElapsedPhase ? onDiscard : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactLifecycleButton(
              label: 'Reiniciar',
              icon: Icons.replay_rounded,
              onPressed: onRestart,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactLifecycleButton(
              label: isBreak ? 'Saltar' : 'Terminar',
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
                'Objetivo del Pomodoro',
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Elige un objetivo fechado en calendario o deja este Pomodoro sin objetivo.',
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.not_interested_rounded),
                title: const Text('Sin objetivo'),
                onTap: () {
                  onSelectGoal(null);
                  Navigator.of(sheetContext).pop();
                },
              ),
              for (final goal in goals)
                ListTile(
                  leading: Icon(Icons.flag_rounded, color: palette.primary),
                  title: Text(goal.title),
                  subtitle: Text(_goalLabel(goal)),
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

String _goalLabel(ProductivityGoal goal) {
  final date = goal.targetDate;
  final dateLabel = date == null
      ? 'Sin fecha'
      : '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}';

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
                    'Empezar enfoque',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Antes de iniciar, registra como te sientes del 1 al 5.',
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
                      label: const Text('Pantalla completa'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Iniciar normal'),
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

  if (startFullscreen && context.mounted) {
    await context.push<void>(PomodoroFullscreenPage.routePath);
  }
}

class PomodoroFullscreenPage extends StatefulWidget {
  const PomodoroFullscreenPage({super.key});

  static const String routePath = PomodoroPage.fullscreenRoutePath;

  @override
  State<PomodoroFullscreenPage> createState() => _PomodoroFullscreenPageState();
}

class _PomodoroFullscreenPageState extends State<PomodoroFullscreenPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final runtime = PomodoroRuntimeScope.of(context);
    final minutes = runtime.remainingSeconds ~/ 60;
    final seconds = runtime.remainingSeconds % 60;
    final totalSeconds = runtime.currentPhaseSeconds;
    final progress = totalSeconds <= 0
        ? 0.0
        : 1 - (runtime.remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    final timeLabel =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: palette.background,
      body: DecoratedBox(
        decoration: palette.appBackgroundDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton.filledTonal(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close_fullscreen_rounded),
                  ),
                ),
                const Spacer(),
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
                        phaseLabel: _phaseTitle(runtime.phase),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
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
                      onPressed: runtime.onPlayPause,
                      large: true,
                    ),
                    _CircleAction(
                      icon: Icons.close_rounded,
                      onPressed: () => context.pop(),
                      muted: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerFace extends StatelessWidget {
  const _TimerFace({required this.timeLabel, required this.phaseLabel});

  final String timeLabel;
  final String phaseLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

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
                maxLines: 1,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: palette.primary,
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
                  color: palette.textSecondary,
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

class _TimerRingPainter extends CustomPainter {
  const _TimerRingPainter({required this.palette, required this.progress});

  final AppPalette palette;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final ring = rect.deflate(12);
    final strokeWidth = size.width * 0.055;
    final track = Paint()
      ..color = palette.primaryMuted.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [palette.secondarySoft, palette.primary, palette.secondarySoft],
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
    return oldDelegate.progress != progress || oldDelegate.palette != palette;
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onPressed,
    this.large = false,
    this.outline = false,
    this.muted = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool large;
  final bool outline;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colorScheme = Theme.of(context).colorScheme;
    final size = large ? 112.0 : 82.0;

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: large ? palette.primary : palette.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: outline ? palette.primary : palette.neutralSoft,
            width: outline ? 1.4 : 1,
          ),
          boxShadow: large
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
          color: large
              ? colorScheme.onPrimary
              : palette.primary.withValues(alpha: muted ? 0.75 : 1),
        ),
      ),
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
