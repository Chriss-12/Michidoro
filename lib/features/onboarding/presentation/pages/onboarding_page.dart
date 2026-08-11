import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/home/presentation/pages/home_page.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const routePath = '/onboarding';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _pageCount = 4;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isCompleting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int page) async {
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _continue() async {
    if (_currentPage < _pageCount - 1) {
      await _goToPage(_currentPage + 1);
      return;
    }
    await _finish();
  }

  Future<void> _back() async {
    if (_currentPage > 0) {
      await _goToPage(_currentPage - 1);
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    if (_isCompleting) {
      return;
    }
    setState(() => _isCompleting = true);
    await AppSettingsScope.of(context).onCompleteOnboarding();
    if (mounted) {
      context.go(HomePage.routePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final pages = _pages(context);
    final isLastPage = _currentPage == pages.length - 1;

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _back();
        }
      },
      child: Scaffold(
        backgroundColor: palette.background,
        body: DecoratedBox(
          decoration: palette.appBackgroundDecoration,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 12, 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        child: Text(
                          'MichiDoro',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: palette.background,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _isCompleting ? null : _finish,
                        child: Container(
                          decoration: BoxDecoration(
                            color: palette.textPrimary.withValues(alpha: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 5,
                          ),
                          child: Text(context.tr('Omitir', 'Skip')),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (value) {
                      setState(() => _currentPage = value);
                    },
                    itemBuilder: (context, index) => _OnboardingStep(
                      data: pages[index],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                  child: Column(
                    children: [
                      Semantics(
                        label: context.tr(
                          'Paso ${_currentPage + 1} de ${pages.length}',
                          'Step ${_currentPage + 1} of ${pages.length}',
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var index = 0; index < pages.length; index++)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: index == _currentPage ? 28 : 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: index == _currentPage
                                      ? palette.primary
                                      : palette.neutralSoft,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          if (_currentPage > 0) ...[
                            SizedBox.square(
                              dimension: 52,
                              child: IconButton.outlined(
                                tooltip: context.tr('Atrás', 'Back'),
                                onPressed: _isCompleting ? null : _back,
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: FilledButton.icon(
                                onPressed: _isCompleting ? null : _continue,
                                icon: _isCompleting
                                    ? const SizedBox.square(
                                        dimension: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        isLastPage
                                            ? Icons.check_rounded
                                            : Icons.arrow_forward_rounded,
                                      ),
                                label: Text(
                                  isLastPage
                                      ? context.tr(
                                          'Empezar a usar MichiDoro',
                                          'Start using MichiDoro',
                                        )
                                      : context.tr('Continuar', 'Continue'),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_OnboardingData> _pages(BuildContext context) {
    return [
      _OnboardingData(
        title: context.tr('Organiza tu día', 'Organize your day'),
        description: context.tr(
          'Convierte objetivos en tareas con fecha y tiempo estimado. Tu planificación queda lista para actuar.',
          'Turn goals into scheduled tasks with a time estimate. Your plan stays ready for action.',
        ),
        supportingText: context.tr(
          'Tareas · Objetivos · Calendario',
          'Tasks · Goals · Calendar',
        ),
        visual: _OnboardingVisual.organize,
      ),
      _OnboardingData(
        title: context.tr('Enfócate con intención', 'Focus with intention'),
        description: context.tr(
          'MichiDoro divide el tiempo pendiente en bloques de enfoque y descansos, sin alargar el último bloque.',
          'MichiDoro divides remaining work into focus and break blocks without extending the final block.',
        ),
        supportingText: context.tr(
          'Continúa exactamente donde lo dejaste',
          'Continue exactly where you stopped',
        ),
        visual: _OnboardingVisual.focus,
      ),
      _OnboardingData(
        title: context.tr('Entiende tu progreso', 'Understand your progress'),
        description: context.tr(
          'Consulta minutos enfocados, Pomodoros, tareas completadas y reportes locales para mejorar tu planificación.',
          'Review focused minutes, Pomodoros, completed tasks, and local reports to improve your planning.',
        ),
        supportingText: context.tr(
          'Progreso medible y datos bajo tu control',
          'Measurable progress and data under your control',
        ),
        visual: _OnboardingVisual.progress,
      ),
      _OnboardingData(
        title: context.tr('Hazlo tuyo', 'Make it yours'),
        description: context.tr(
          'Personaliza idioma, tema, tipografía, sonidos y vibración. Todo funciona de forma local y privada.',
          'Personalize language, theme, typography, sounds, and vibration. Everything works locally and privately.',
        ),
        supportingText: context.tr(
          'Sin cuenta · Sin conexión obligatoria',
          'No account · No required connection',
        ),
        visual: _OnboardingVisual.personalize,
      ),
    ];
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.description,
    required this.supportingText,
    required this.visual,
  });

  final String title;
  final String description;
  final String supportingText;
  final _OnboardingVisual visual;
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 600 ? 72.0 : 24.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            14,
            horizontalPadding,
            12,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 26,
              maxWidth: 680,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FeatureVisual(type: data.visual),
                  const SizedBox(height: 30),
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          data.supportingText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: palette.primary,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum _OnboardingVisual { organize, focus, progress, personalize }

class _FeatureVisual extends StatelessWidget {
  const _FeatureVisual({required this.type});

  final _OnboardingVisual type;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Semantics(
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 430),
        height: 238,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: palette.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: palette.neutralSoft),
          boxShadow: [
            BoxShadow(
              color: palette.textPrimary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: switch (type) {
          _OnboardingVisual.organize => _OrganizeVisual(palette: palette),
          _OnboardingVisual.focus => _FocusVisual(palette: palette),
          _OnboardingVisual.progress => _ProgressVisual(palette: palette),
          _OnboardingVisual.personalize => _PersonalizeVisual(palette: palette),
        },
      ),
    );
  }
}

class _OrganizeVisual extends StatelessWidget {
  const _OrganizeVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.calendar_month_rounded, color: palette.primary),
            const SizedBox(width: 10),
            Expanded(child: Container(height: 10, color: palette.primaryMuted)),
            const SizedBox(width: 30),
          ],
        ),
        const SizedBox(height: 14),
        for (final item in const [
          (Icons.flag_rounded, 0.92, true),
          (Icons.task_alt_rounded, 0.72, false),
          (Icons.schedule_rounded, 0.84, false),
        ]) ...[
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.$3 ? palette.primaryMuted : palette.neutralSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.$1,
                  size: 19,
                  color: item.$3 ? palette.primary : palette.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: item.$2,
                      child: Container(height: 9, color: palette.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    FractionallySizedBox(
                      widthFactor: 0.52,
                      child: Container(height: 7, color: palette.neutralSoft),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _FocusVisual extends StatelessWidget {
  const _FocusVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 172,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.square(
                dimension: 164,
                child: CircularProgressIndicator(
                  value: 0.62,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: palette.neutralSoft,
                  color: palette.primary,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '45:00',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '45 / 120 min',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 22),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _VisualPhaseDot(color: palette.primary, icon: Icons.bolt_rounded),
            Container(width: 2, height: 22, color: palette.neutralSoft),
            _VisualPhaseDot(
              color: palette.secondary,
              icon: Icons.coffee_rounded,
            ),
            Container(width: 2, height: 22, color: palette.neutralSoft),
            _VisualPhaseDot(color: palette.tertiary, icon: Icons.flag_rounded),
          ],
        ),
      ],
    );
  }
}

class _VisualPhaseDot extends StatelessWidget {
  const _VisualPhaseDot({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }
}

class _ProgressVisual extends StatelessWidget {
  const _ProgressVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final values = [0.36, 0.58, 0.46, 0.78, 0.66, 0.9, 0.72];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricVisual(value: '12', color: palette.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricVisual(value: '285', color: palette.secondary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricVisual(value: '84%', color: palette.tertiary),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          height: 112,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var index = 0; index < values.length; index++) ...[
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: values[index],
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == values.length - 2
                            ? palette.primary
                            : palette.primaryMuted,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                if (index < values.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricVisual extends StatelessWidget {
  const _MetricVisual({required this.value, required this.color});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PersonalizeVisual extends StatelessWidget {
  const _PersonalizeVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final color in [
              palette.primary,
              palette.secondary,
              palette.tertiary,
              palette.accentPeach,
            ]) ...[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: palette.surface, width: 3),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ],
        ),
        const SizedBox(height: 26),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: palette.primaryMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.translate_rounded, color: palette.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Español  /  English',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.vibration_rounded, color: palette.secondary),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.text_fields_rounded, color: palette.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 9, color: palette.textPrimary)),
            const SizedBox(width: 12),
            Icon(Icons.volume_up_rounded, color: palette.textSecondary),
          ],
        ),
      ],
    );
  }
}
