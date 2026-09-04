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
                  child: Container(
                    key: const Key('onboarding-header'),
                    padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
                    decoration: BoxDecoration(
                      color: palette.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: palette.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: palette.primaryMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.pets_rounded,
                            color: palette.primary,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Michi Focus',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: palette.textPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          key: const Key('onboarding-skip'),
                          style: TextButton.styleFrom(
                            foregroundColor: palette.primary,
                            backgroundColor: palette.primaryMuted,
                            disabledForegroundColor: palette.textSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _isCompleting ? null : _finish,
                          child: Text(context.tr('Omitir', 'Skip')),
                        ),
                      ],
                    ),
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
                                          'Empezar a usar Michi Focus',
                                          'Start using Michi Focus',
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
        title: context.tr(
          'Todo tu día, en un lugar',
          'Your whole day, in one place',
        ),
        description: context.tr(
          'Organiza tareas, objetivos, rutinas y notas rápidas. Usa filtros por fecha y el horario semanal para encontrar lo importante sin perder tiempo.',
          'Organize tasks, goals, routines, and quick notes. Use date filters and the weekly schedule to find what matters without wasting time.',
        ),
        supportingText: context.tr(
          'Planificación diaria y semanal',
          'Daily and weekly planning',
        ),
        supportingIcon: Icons.calendar_view_week_rounded,
        visual: _OnboardingVisual.plan,
      ),
      _OnboardingData(
        title: context.tr(
          'Enfoque que se adapta a ti',
          'Focus that adapts to you',
        ),
        description: context.tr(
          'Trabaja solo el tiempo que falta, continúa después de cerrar la app y usa máxima concentración en modo claro u OLED. Si autorizas Android, también puede silenciar interrupciones.',
          'Work only for the remaining time, continue after closing the app, and use maximum concentration in Clear or OLED mode. If you authorize Android, it can also silence interruptions.',
        ),
        supportingText: context.tr(
          'Tu avance se conserva automáticamente',
          'Your progress is saved automatically',
        ),
        supportingIcon: Icons.check_circle_outline_rounded,
        visual: _OnboardingVisual.focus,
      ),
      _OnboardingData(
        title: context.tr(
          'Tus datos siguen siendo tuyos',
          'Your data stays yours',
        ),
        description: context.tr(
          'Elige dónde guardar tus datos. Puedes mantenerlos solo en este teléfono o enlazar varios dispositivos mediante archivos cifrados y Syncthing.',
          'Choose where to store your data. Keep it only on this phone or link several devices using encrypted files and Syncthing.',
        ),
        supportingText: context.tr(
          'Conflictos visibles, sin sobrescribir a ciegas',
          'Visible conflicts, no blind overwrites',
        ),
        supportingIcon: Icons.lock_rounded,
        visual: _OnboardingVisual.sync,
      ),
      _OnboardingData(
        title: context.tr(
          'Mide, dicta y personaliza',
          'Measure, dictate, and personalize',
        ),
        description: context.tr(
          'Revisa estadísticas, exporta reportes y tu horario semanal, dicta campos de texto y elige tema, colores, tipografía, sonidos y vibración.',
          'Review statistics, export reports and your weekly schedule, dictate text fields, and choose your theme, colors, typography, sounds, and vibration.',
        ),
        supportingText: context.tr(
          'Sin cuenta y con funcionamiento local',
          'No account and works locally',
        ),
        supportingIcon: Icons.offline_bolt_rounded,
        visual: _OnboardingVisual.customize,
      ),
    ];
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.description,
    required this.supportingText,
    required this.supportingIcon,
    required this.visual,
  });

  final String title;
  final String description;
  final String supportingText;
  final IconData supportingIcon;
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: palette.primaryMuted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          data.supportingIcon,
                          color: palette.primary,
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            data.supportingText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: palette.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
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

enum _OnboardingVisual { plan, focus, sync, customize }

class _FeatureVisual extends StatelessWidget {
  const _FeatureVisual({required this.type});

  final _OnboardingVisual type;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Semantics(
      excludeSemantics: true,
      child: Container(
        key: const Key('onboarding-feature-visual'),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 430),
        height: 238,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: palette.neutralSoft),
          boxShadow: [
            BoxShadow(
              color: palette.primary.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: switch (type) {
          _OnboardingVisual.plan => _PlanVisual(palette: palette),
          _OnboardingVisual.focus => _FocusVisual(palette: palette),
          _OnboardingVisual.sync => _SyncVisual(palette: palette),
          _OnboardingVisual.customize => _CustomizeVisual(palette: palette),
        },
      ),
    );
  }
}

class _PlanVisual extends StatelessWidget {
  const _PlanVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.today_rounded, color: palette.primary),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                context.tr('Tu planificación', 'Your plan'),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _VisualTag(
              label: context.tr('Hoy', 'Today'),
              color: palette.primary,
              background: palette.primaryMuted,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _VisualFeatureTile(
                        icon: Icons.task_alt_rounded,
                        label: context.tr('Tareas', 'Tasks'),
                        color: palette.primary,
                        background: palette.primaryMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _VisualFeatureTile(
                        icon: Icons.repeat_rounded,
                        label: context.tr('Rutinas', 'Routines'),
                        color: palette.secondary,
                        background: palette.secondarySoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _VisualFeatureTile(
                        icon: Icons.flag_rounded,
                        label: context.tr('Objetivos', 'Goals'),
                        color: palette.tertiary,
                        background: palette.accentPeach,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _VisualFeatureTile(
                        icon: Icons.sticky_note_2_rounded,
                        label: context.tr('Notas', 'Notes'),
                        color: palette.primary,
                        background: palette.neutralSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VisualFeatureTile extends StatelessWidget {
  const _VisualFeatureTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusVisual extends StatelessWidget {
  const _FocusVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 126,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 118,
                      child: CircularProgressIndicator(
                        value: 0.8,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: palette.neutralSoft,
                        color: palette.primary,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '05:00',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        Text(
                          context.tr('restantes', 'remaining'),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: palette.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FocusModeIcon(
                    icon: Icons.light_mode_rounded,
                    color: palette.primary,
                    background: palette.primaryMuted,
                  ),
                  Container(width: 2, height: 12, color: palette.neutralSoft),
                  _FocusModeIcon(
                    icon: Icons.dark_mode_rounded,
                    color: palette.secondary,
                    background: palette.secondarySoft,
                  ),
                  Container(width: 2, height: 12, color: palette.neutralSoft),
                  _FocusModeIcon(
                    icon: Icons.notifications_off_rounded,
                    color: palette.tertiary,
                    background: palette.accentPeach,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _VisualTag(
                label: context.tr('Avance guardado', 'Progress saved'),
                color: palette.primary,
                background: palette.primaryMuted,
                icon: Icons.save_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: _VisualTag(
                label: context.tr('Modo OLED', 'OLED mode'),
                color: palette.secondary,
                background: palette.secondarySoft,
                icon: Icons.battery_saver_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FocusModeIcon extends StatelessWidget {
  const _FocusModeIcon({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _SyncVisual extends StatelessWidget {
  const _SyncVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DeviceVisual(
                icon: Icons.phone_android_rounded,
                label: context.tr('Teléfono A', 'Phone A'),
                color: palette.primary,
                background: palette.primaryMuted,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_rounded, color: palette.tertiary, size: 25),
                    const SizedBox(height: 5),
                    Icon(
                      Icons.sync_alt_rounded,
                      color: palette.primary,
                      size: 32,
                    ),
                  ],
                ),
              ),
              _DeviceVisual(
                icon: Icons.phone_iphone_rounded,
                label: context.tr('Teléfono B', 'Phone B'),
                color: palette.secondary,
                background: palette.secondarySoft,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _VisualTag(
                label: context.tr('Cifrado', 'Encrypted'),
                color: palette.primary,
                background: palette.primaryMuted,
                icon: Icons.lock_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _VisualTag(
                label: context.tr('Conflictos', 'Conflicts'),
                color: palette.secondary,
                background: palette.secondarySoft,
                icon: Icons.rule_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeviceVisual extends StatelessWidget {
  const _DeviceVisual({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomizeVisual extends StatelessWidget {
  const _CustomizeVisual({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _MetricVisual(
              icon: Icons.timer_outlined,
              value: '285',
              color: palette.primary,
              background: palette.primaryMuted,
            ),
            const SizedBox(width: 8),
            _MetricVisual(
              icon: Icons.task_alt_rounded,
              value: '84%',
              color: palette.secondary,
              background: palette.secondarySoft,
            ),
            const SizedBox(width: 8),
            _MetricVisual(
              icon: Icons.picture_as_pdf_rounded,
              value: 'PDF',
              color: palette.tertiary,
              background: palette.accentPeach,
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: palette.neutralSoft.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.mic_rounded, color: palette.primary, size: 21),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.tr('Dictado para escribir', 'Voice typing'),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.translate_rounded, color: palette.secondary, size: 21),
            ],
          ),
        ),
        const SizedBox(height: 14),
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
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: palette.surface, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: palette.textPrimary.withValues(alpha: 0.08),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 9),
            ],
          ],
        ),
      ],
    );
  }
}

class _MetricVisual extends StatelessWidget {
  const _MetricVisual({
    required this.icon,
    required this.value,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 3),
            Text(
              value,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.palette.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisualTag extends StatelessWidget {
  const _VisualTag({
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
