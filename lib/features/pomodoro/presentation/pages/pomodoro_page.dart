import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/pomodoro_time_settings_page.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  static const routePath = '/pomodoro';
  static const fullscreenRoutePath = '/pomodoro/fullscreen';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);
    final minutes = settings.remainingSeconds ~/ 60;
    final seconds = settings.remainingSeconds % 60;
    final totalSeconds = settings.focusMinutes * 60;
    final progress = totalSeconds <= 0
        ? 0.0
        : 1 - (settings.remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    final timeLabel =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return ListView(
      padding: AppCardPaddings.page,
      children: [
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: _TimerRingPainter(
                palette: palette,
                progress: progress,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeLabel,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: palette.primary,
                        fontSize: AppDesignTokens.timerFontSize,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'MODO ENFOQUE',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: palette.textSecondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 92),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CircleAction(
              icon: Icons.replay_rounded,
              onPressed: settings.onPomodoroReset,
              outline: true,
            ),
            _CircleAction(
              icon: settings.isPomodoroRunning
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              onPressed: () => _handleStartPressed(context, settings),
              large: true,
            ),
            _CircleAction(
              icon: Icons.more_vert_rounded,
              onPressed: () => context.push(PomodoroTimeSettingsPage.routePath),
              muted: true,
            ),
          ],
        ),
        const SizedBox(height: 86),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: _TimerStat(label: 'Hoy', value: '4.3h'),
              ),
              SizedBox(width: 30),
              Expanded(
                child: _TimerStat(label: 'Racha', value: '12 días'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _handleStartPressed(
  BuildContext context,
  AppSettingsScope settings,
) async {
  if (settings.isPomodoroRunning) {
    settings.onPomodoroPlayPause();
    return;
  }

  final startFullscreen = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final palette = context.palette;

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
                'Puedes decidir si queres iniciar normal o entrar en pantalla completa.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.textSecondary,
                ),
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

  if (startFullscreen == null) {
    return;
  }

  settings.onPomodoroPlayPause();

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
    final settings = AppSettingsScope.of(context);
    final minutes = settings.remainingSeconds ~/ 60;
    final seconds = settings.remainingSeconds % 60;
    final totalSeconds = settings.focusMinutes * 60;
    final progress = totalSeconds <= 0
        ? 0.0
        : 1 - (settings.remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    final timeLabel =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: palette.background,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.secondary,
              palette.gradientStart,
              palette.gradientEnd,
            ],
          ),
        ),
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
                  child: CustomPaint(
                    painter: _TimerRingPainter(
                      palette: palette,
                      progress: progress,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeLabel,
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: palette.primary,
                                  fontSize: AppDesignTokens.timerFontSize,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -3,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'MODO ENFOQUE',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: palette.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                          ),
                        ],
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
                      onPressed: settings.onPomodoroReset,
                      outline: true,
                    ),
                    _CircleAction(
                      icon: settings.isPomodoroRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      onPressed: settings.onPomodoroPlayPause,
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
              ? Colors.white
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
      borderRadius: 16,
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
