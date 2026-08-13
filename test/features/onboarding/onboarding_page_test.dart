import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_file.dart';
import 'package:pomodoro_app_v1/features/splash/presentation/pages/splash_page.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('walks through every onboarding page and finishes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var completionCount = 0;

    await tester.pumpWidget(
      _OnboardingTestApp(
        onComplete: () async {
          completionCount += 1;
        },
      ),
    );

    expect(find.text('Organiza tu día'), findsOneWidget);
    expect(find.text('Omitir'), findsOneWidget);
    expect(find.bySemanticsLabel('Paso 1 de 4'), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Enfócate con intención'), findsOneWidget);
    expect(find.byTooltip('Atrás'), findsOneWidget);

    await tester.tap(find.byTooltip('Atrás'));
    await tester.pumpAndSettle();
    expect(find.text('Organiza tu día'), findsOneWidget);

    for (var index = 0; index < 3; index += 1) {
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Hazlo tuyo'), findsOneWidget);
    expect(find.text('Empezar a usar MichiDoro'), findsOneWidget);
    expect(find.bySemanticsLabel('Paso 4 de 4'), findsOneWidget);
    await tester.tap(find.text('Empezar a usar MichiDoro'));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(completionCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('skip is visible and completes immediately in English', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var completionCount = 0;

    await tester.pumpWidget(
      _OnboardingTestApp(
        language: AppLanguage.english,
        textScale: 1.3,
        onComplete: () async {
          completionCount += 1;
        },
      ),
    );

    expect(find.text('Organize your day'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(completionCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('splash sends fresh and returning installs to the right route', (
    tester,
  ) async {
    addTearDown(() {
      appSettingsController.completedOnboardingVersion.value =
          AppSettingsController.currentOnboardingVersion;
    });

    appSettingsController.completedOnboardingVersion.value = 0;
    await tester.pumpWidget(
      _OnboardingTestApp(
        initialLocation: SplashPage.routePath,
        onComplete: () async {},
      ),
    );
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();
    expect(find.text('Organiza tu día'), findsOneWidget);

    appSettingsController.completedOnboardingVersion.value =
        AppSettingsController.currentOnboardingVersion;
    await tester.pumpWidget(
      _OnboardingTestApp(
        initialLocation: SplashPage.routePath,
        onComplete: () async {},
      ),
    );
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('matches the approved Spanish onboarding presentation', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _OnboardingTestApp(onComplete: () async {}),
    );
    await tester.pumpAndSettle();

    for (var page = 1; page <= 4; page += 1) {
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/onboarding_spanish_page_$page.png'),
      );
      if (page < 4) {
        await tester.tap(find.text('Continuar'));
        await tester.pumpAndSettle();
      }
    }

    expect(tester.takeException(), isNull);
  });
}

class _OnboardingTestApp extends StatelessWidget {
  const _OnboardingTestApp({
    required this.onComplete,
    this.language = AppLanguage.spanish,
    this.textScale = 1,
    this.initialLocation = OnboardingPage.routePath,
  });

  final Future<void> Function() onComplete;
  final AppLanguage language;
  final double textScale;
  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: SplashPage.routePath,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: OnboardingPage.routePath,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('HOME')),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      locale: language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.fromPreset(AppThemePreset.natureFocus, isDark: false),
      routerConfig: router,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return AppSettingsScope(
          themePreset: AppThemePreset.natureFocus,
          isDarkMode: false,
          fontScale: textScale,
          profileName: 'Test',
          profileEmail: '',
          profileImagePath: '',
          avatarIndex: 0,
          typographyPreset: AppTypographyPreset.moderna,
          language: language,
          completedOnboardingVersion: 0,
          focusMinutes: 25,
          shortBreakMinutes: 5,
          longBreakMinutes: 15,
          longBreakFrequency: 3,
          completionSound: PomodoroCompletionSound.softBell,
          completionVibrationEnabled: true,
          completionVibrationPattern: PomodoroVibrationPattern.normal,
          autoStartBreak: true,
          autoStartFocus: false,
          notificationsEnabled: true,
          breakAlertsEnabled: true,
          focusAlertsEnabled: true,
          completedTasks: 0,
          totalTasks: 0,
          lastReportPath: '',
          reportsDirectoryPath: '',
          enabledStatisticsCharts: const {...StatisticsChartType.values},
          notifications: const [],
          onThemeChanged: (_) {},
          onDarkModeChanged: (_) {},
          onFontScaleChanged: (_) {},
          onProfileNameChanged: (_) {},
          onProfileEmailChanged: (_) {},
          onProfileImagePathChanged: (_) {},
          onAvatarChanged: (_) {},
          onTypographyPresetChanged: (_) {},
          onLanguageChanged: (_) {},
          onCompleteOnboarding: onComplete,
          onFocusMinutesChanged: (_) {},
          onShortBreakMinutesChanged: (_) {},
          onLongBreakMinutesChanged: (_) {},
          onLongBreakFrequencyChanged: (_) {},
          onCompletionSoundChanged: (_) {},
          onPreviewCompletionSound: () async {},
          onCompletionVibrationChanged: (_) {},
          onCompletionVibrationPatternChanged: (_) {},
          onPreviewCompletionVibration: () async {},
          onAutoStartBreakChanged: (_) {},
          onAutoStartFocusChanged: (_) {},
          onReportsDirectoryPathChanged: (_) {},
          onUseDefaultReportsDirectory: () async {},
          onStatisticsChartVisibilityChanged: (_, {required enabled}) {},
          onNotificationsEnabledChanged: (_) {},
          onBreakAlertsEnabledChanged: (_) {},
          onFocusAlertsEnabledChanged: (_) {},
          onDownloadReport: () async {},
          onDownloadStatisticsPdf: (_) async => const StatisticsReportFile(
            displayPath: '',
            openReference: '',
          ),
          onOpenReport: (_) async {},
          onExportDatabaseBackup: () async => '',
          onImportDatabaseBackup: (_) async {},
          onDeleteAllDatabaseData: () async {},
          onTestNotification: () async {},
          onClearNotifications: () {},
          child: MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(textScale),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
