import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/pages/goals_page.dart';
import 'package:pomodoro_app_v1/features/home/presentation/pages/home_page.dart';
import 'package:pomodoro_app_v1/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/pages/routine_editor_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/directory_picker_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/local_image_picker_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/notification_settings_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/pomodoro_time_settings_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/settings_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:pomodoro_app_v1/features/splash/presentation/pages/splash_page.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pomodoro_app_v1/shared/templates/app_shell.dart';

class AppRouter {
  const AppRouter._();

  static String startupLocation({required bool shouldShowOnboarding}) {
    return shouldShowOnboarding ? OnboardingPage.routePath : HomePage.routePath;
  }

  static final router = GoRouter(
    initialLocation: startupLocation(
      shouldShowOnboarding: appSettingsController.shouldShowOnboarding,
    ),
    routes: [
      GoRoute(
        path: SplashPage.routePath,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state: state, child: const SplashPage()),
      ),
      GoRoute(
        path: OnboardingPage.routePath,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state: state, child: const OnboardingPage()),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => _buildTransitionPage(
          state: state,
          child: AppShell(
            navigationShell: navigationShell,
          ),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomePage.routePath,
                pageBuilder: (context, state) => _buildTransitionPage(
                  state: state,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: true,
            routes: [
              GoRoute(
                path: TasksPage.routePath,
                pageBuilder: (context, state) => _buildTransitionPage(
                  state: state,
                  child: TasksPage(
                    showRoutines:
                        state.uri.queryParameters['view'] == 'routines',
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PomodoroPage.routePath,
                pageBuilder: (context, state) => _buildTransitionPage(
                  state: state,
                  child: const PomodoroPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: GoalsPage.routePath,
                pageBuilder: (context, state) => _buildTransitionPage(
                  state: state,
                  child: CalendarPage(
                    initialGoalId: state.uri.queryParameters['goalId'],
                    initialTaskId: state.uri.queryParameters['taskId'],
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SettingsPage.routePath,
                pageBuilder: (context, state) => _buildTransitionPage(
                  state: state,
                  child: const SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: CalendarPage.routePath,
        redirect: (context, state) => GoalsPage.routePath,
      ),
      GoRoute(
        path: PomodoroFullscreenPage.routePath,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 180),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          child: const PomodoroFullscreenPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: RoutineEditorPage.routePath,
        pageBuilder: (context, state) => NoTransitionPage<bool>(
          key: state.pageKey,
          child: RoutineEditorPage(
            routineId: state.uri.queryParameters['id'],
          ),
        ),
      ),

      GoRoute(
        path: ProfileSettingsPage.routePath,
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const ProfileSettingsPage(),
        ),
      ),
      GoRoute(
        path: ThemeSettingsPage.routePath,
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const ThemeSettingsPage(),
        ),
      ),
      GoRoute(
        path: NotificationSettingsPage.routePath,
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const NotificationSettingsPage(),
        ),
      ),
      GoRoute(
        path: PomodoroTimeSettingsPage.routePath,
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const PomodoroTimeSettingsPage(),
        ),
      ),
      GoRoute(
        path: DirectoryPickerPage.routePath,
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: DirectoryPickerPage(
            initialPath: state.extra is String ? state.extra! as String : null,
          ),
        ),
      ),
      GoRoute(
        path: LocalImagePickerPage.routePath,
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: LocalImagePickerPage(
            initialPath: state.extra is String ? state.extra! as String : null,
          ),
        ),
      ),
    ],
  );

  static Page<void> _buildTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return NoTransitionPage<void>(key: state.pageKey, child: child);
  }
}
