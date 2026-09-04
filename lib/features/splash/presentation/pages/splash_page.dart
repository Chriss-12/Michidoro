import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/home/presentation/pages/home_page.dart';
import 'package:pomodoro_app_v1/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.autoNavigate = true});

  static const routePath = '/';

  final bool autoNavigate;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _navigationScheduled = false;

  @override
  void initState() {
    super.initState();
    _scheduleHomeNavigation();
  }

  @override
  void didUpdateWidget(covariant SplashPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleHomeNavigation();
  }

  void _scheduleHomeNavigation() {
    if (_navigationScheduled || !widget.autoNavigate) {
      return;
    }

    _navigationScheduled = true;
    unawaited(_goNext());
  }

  Future<void> _goNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1700));
    if (mounted) {
      context.go(
        appSettingsController.shouldShowOnboarding
            ? OnboardingPage.routePath
            : HomePage.routePath,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: DecoratedBox(
        decoration: palette.appBackgroundDecoration,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1700),
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 260,
                          child: CustomPaint(
                            painter: _MichiDoroPainter(
                              catColor: palette.primary,
                              catDetailColor: _readableForeground(
                                palette.primary,
                              ),
                              accentColor: _readableForeground(
                                palette.primary,
                              ),
                              rulerColor: palette.secondary,
                              rulerDetailColor: _readableForeground(
                                palette.secondary,
                              ),
                              clockColor: palette.tertiary,
                              clockDetailColor: _readableForeground(
                                palette.tertiary,
                              ),
                              surfaceColor: palette.surface,
                              trackColor: palette.neutralSoft,
                              progress: progress,
                              loadingColors: [
                                palette.secondary,
                                palette.primary,
                                palette.accentPeach,
                                palette.gradientEnd,
                                palette.gradientStart,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '${(progress * 100).round()}%',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: palette.primary,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),
                Text(
                  'MichiDoro',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: palette.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  context.tr('Alcanza tus objetivos', 'Reach your goals'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: palette.textSecondary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MichiDoroPainter extends CustomPainter {
  const _MichiDoroPainter({
    required this.catColor,
    required this.catDetailColor,
    required this.accentColor,
    required this.rulerColor,
    required this.rulerDetailColor,
    required this.clockColor,
    required this.clockDetailColor,
    required this.surfaceColor,
    required this.trackColor,
    required this.progress,
    required this.loadingColors,
  });

  final Color catColor;
  final Color catDetailColor;
  final Color accentColor;
  final Color rulerColor;
  final Color rulerDetailColor;
  final Color clockColor;
  final Color clockDetailColor;
  final Color surfaceColor;
  final Color trackColor;
  final double progress;
  final List<Color> loadingColors;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final catPaint = Paint()..color = catColor;
    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    final clockDetailPaint = Paint()
      ..color = clockDetailColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    final clockPaint = Paint()
      ..color = clockColor
      ..style = PaintingStyle.fill;
    final rulerPaint = Paint()
      ..color = rulerColor
      ..style = PaintingStyle.fill;
    final catDetailPaint = Paint()..color = catDetailColor;
    final center = Offset(w * 0.5, h * 0.5);
    final loadingPadding = w * 0.035;
    final loadingStrokeWidth = w * 0.04;
    final loadingRadius = (w / 2) - loadingPadding - loadingStrokeWidth;
    final loadingRect = Rect.fromCircle(center: center, radius: loadingRadius);
    final clampedProgress = progress.clamp(0.0, 1.0);
    final loadingTrack = Paint()
      ..color = trackColor.withValues(alpha: 0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = loadingStrokeWidth
      ..strokeCap = StrokeCap.round;
    final loadingPaint = Paint()
      ..shader = SweepGradient(
        colors: loadingColors,
        stops: const [0, 0.25, 0.5, 0.75, 1],
      ).createShader(loadingRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = loadingStrokeWidth
      ..strokeCap = StrokeCap.round;
    final backgroundPaint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(
        center,
        loadingRadius - loadingStrokeWidth / 2,
        backgroundPaint,
      )
      ..drawArc(loadingRect, -1.5708, 6.2832, false, loadingTrack)
      ..drawArc(
        loadingRect,
        -1.5708,
        6.2832 * clampedProgress,
        false,
        loadingPaint,
      )
      ..drawCircle(Offset(w * 0.5, h * 0.5), w * 0.23, catPaint);

    final leftEar = Path()
      ..moveTo(w * 0.34, h * 0.34)
      ..lineTo(w * 0.38, h * 0.22)
      ..lineTo(w * 0.46, h * 0.34)
      ..close();
    final rightEar = Path()
      ..moveTo(w * 0.54, h * 0.34)
      ..lineTo(w * 0.62, h * 0.22)
      ..lineTo(w * 0.66, h * 0.34)
      ..close();

    canvas
      ..drawPath(leftEar, catPaint)
      ..drawPath(rightEar, catPaint)
      ..drawCircle(Offset(w * 0.42, h * 0.47), w * 0.024, catDetailPaint)
      ..drawCircle(Offset(w * 0.58, h * 0.47), w * 0.024, catDetailPaint)
      ..drawArc(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.535),
          width: w * 0.13,
          height: h * 0.09,
        ),
        0,
        3.14,
        false,
        accentPaint,
      );

    final clockCenter = Offset(w * 0.73, h * 0.36);
    canvas
      ..drawCircle(clockCenter, w * 0.09, clockPaint)
      ..drawCircle(clockCenter, w * 0.064, Paint()..color = surfaceColor)
      ..drawLine(
        clockCenter,
        Offset(clockCenter.dx, clockCenter.dy - w * 0.04),
        clockDetailPaint,
      )
      ..drawLine(
        clockCenter,
        Offset(clockCenter.dx + w * 0.032, clockCenter.dy),
        clockDetailPaint,
      );

    final ruler = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.27, h * 0.68, w * 0.46, h * 0.09),
      Radius.circular(w * 0.028),
    );
    canvas.drawRRect(ruler, rulerPaint);
    for (var i = 1; i < 6; i++) {
      final x = w * (0.27 + i * 0.065);
      canvas.drawLine(
        Offset(x, h * 0.68),
        Offset(x, h * (i.isEven ? 0.745 : 0.725)),
        Paint()
          ..color = rulerDetailColor
          ..strokeWidth = w * 0.01
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MichiDoroPainter oldDelegate) {
    return catColor != oldDelegate.catColor ||
        catDetailColor != oldDelegate.catDetailColor ||
        accentColor != oldDelegate.accentColor ||
        rulerColor != oldDelegate.rulerColor ||
        rulerDetailColor != oldDelegate.rulerDetailColor ||
        clockColor != oldDelegate.clockColor ||
        clockDetailColor != oldDelegate.clockDetailColor ||
        surfaceColor != oldDelegate.surfaceColor ||
        trackColor != oldDelegate.trackColor ||
        progress != oldDelegate.progress ||
        loadingColors != oldDelegate.loadingColors;
  }
}

Color _readableForeground(Color background) =>
    ThemeData.estimateBrightnessForColor(background) == Brightness.dark
    ? Colors.white
    : Colors.black;
