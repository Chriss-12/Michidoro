import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/router/app_router.dart';
import 'package:pomodoro_app_v1/features/home/presentation/pages/home_page.dart';
import 'package:pomodoro_app_v1/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  test('starts at onboarding only when the installation still needs it', () {
    expect(
      AppRouter.startupLocation(shouldShowOnboarding: true),
      OnboardingPage.routePath,
    );
    expect(
      AppRouter.startupLocation(shouldShowOnboarding: false),
      HomePage.routePath,
    );
  });

  test('preloads only the Tasks branch of the main navigation', () {
    final shell = AppRouter.router.configuration.routes
        .whereType<StatefulShellRoute>()
        .single;

    expect(shell.branches.map((branch) => branch.preload), [
      false,
      true,
      false,
      false,
      false,
    ]);
  });
}
