import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/pages/goals_page.dart';
import 'package:pomodoro_app_v1/features/home/presentation/pages/home_page.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/directory_picker_page.dart';
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

  static final router = GoRouter(
    initialLocation: SplashPage.routePath,
    routes: [
      GoRoute(
        path: SplashPage.routePath,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state: state, child: const SplashPage()),
      ),
      ShellRoute(
        pageBuilder: (context, state, child) => _buildTransitionPage(
          state: state,
          child: AppShell(
            selectedIndex: _selectedIndexForPath(state.uri.path),
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: HomePage.routePath,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state: state, child: const HomePage()),
          ),
          GoRoute(
            path: TasksPage.routePath,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state: state, child: const TasksPage()),
          ),
          GoRoute(
            path: PomodoroPage.routePath,
            pageBuilder: (context, state) => _buildTransitionPage(
              state: state,
              child: const PomodoroPage(),
            ),
          ),
          GoRoute(
            path: GoalsPage.routePath,
            pageBuilder: (context, state) => _buildTransitionPage(
              state: state,
              child: const GoalsPage(),
            ),
          ),
          GoRoute(
            path: SettingsPage.routePath,
            pageBuilder: (context, state) => _buildTransitionPage(
              state: state,
              child: const SettingsPage(),
            ),
          ),
          GoRoute(
            path: CalendarPage.routePath,
            pageBuilder: (context, state) => _buildTransitionPage(
              state: state,
              child: const CalendarPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: PomodoroFullscreenPage.routePath,
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const PomodoroFullscreenPage(),
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
    ],
  );

  static int _selectedIndexForPath(String path) {
    return switch (path) {
      HomePage.routePath => 0,
      TasksPage.routePath => 1,
      PomodoroPage.routePath => 2,
      GoalsPage.routePath => 3,
      SettingsPage.routePath => 4,
      _ => 0,
    };
  }

  static Page<void> _buildTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return NoTransitionPage<void>(key: state.pageKey, child: child);
  }
}
