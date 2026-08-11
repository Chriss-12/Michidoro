import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/pages/goals_page.dart';
import 'package:pomodoro_app_v1/features/home/presentation/pages/home_page.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/settings_page.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/templates/page_header.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.selectedIndex,
    required this.child,
    this.showHeader = true,
    super.key,
  });

  final int selectedIndex;
  final Widget child;
  final bool showHeader;

  static const List<String> routes = [
    HomePage.routePath,
    TasksPage.routePath,
    PomodoroPage.routePath,
    GoalsPage.routePath,
    SettingsPage.routePath,
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: palette.appBackgroundDecoration,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (showHeader) const PageHeader(title: ''),
              Expanded(child: child),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border(
            top: BorderSide(color: palette.neutralSoft),
          ),
        ),
        child: NavigationBar(
          height: 72,
          backgroundColor: palette.surface,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            if (index != selectedIndex) {
              context.go(routes[index]);
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: context.tr('Inicio', 'Home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.checklist_rounded),
              selectedIcon: const Icon(Icons.checklist_rounded),
              label: context.tr('Tareas', 'Tasks'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.timer_outlined),
              selectedIcon: const Icon(Icons.timer_rounded),
              label: context.tr('Enfoque', 'Focus'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.flag_outlined),
              selectedIcon: const Icon(Icons.flag_rounded),
              label: context.tr('Objetivos', 'Goals'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: context.tr('Ajustes', 'Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
