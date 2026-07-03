import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pomodoro_app_v1/features/home/presentation/pages/home_page.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/settings_page.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pomodoro_app_v1/shared/templates/page_header.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.selectedIndex,
    required this.child,
    super.key,
  });

  final int selectedIndex;
  final Widget child;

  static const List<String> routes = [
    HomePage.routePath,
    TasksPage.routePath,
    PomodoroPage.routePath,
    CalendarPage.routePath,
    SettingsPage.routePath,
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      resizeToAvoidBottomInset: false,
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
          bottom: false,
          child: Column(
            children: [
              const PageHeader(title: ''),
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
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: palette.surface,
            indicatorColor: palette.primaryMuted,

            // Texto del label
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (states) {
                final isSelected = states.contains(WidgetState.selected);

                return TextStyle(
                  color: palette.textSecondary,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w900,
                  fontSize: 12,
                );
              },
            ),

            // Color del icono
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
              (states) {
                return IconThemeData(
                  color: palette.textSecondary,
                  size: 24,
                );
              },
            ),
          ),
          child: NavigationBar(
            height: 72,
            backgroundColor: palette.primaryMuted,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              if (index != selectedIndex) {
                context.go(routes[index]);
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.checklist_rounded),
                selectedIcon: Icon(Icons.checklist_rounded),
                label: 'Tasks',
              ),
              NavigationDestination(
                icon: Icon(Icons.timer_outlined),
                selectedIcon: Icon(Icons.timer_rounded),
                label: 'Focus',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
