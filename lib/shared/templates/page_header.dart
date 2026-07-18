import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.showSettings = false,
    this.centerTitle = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final bool showSettings;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Column(
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          _BrandBar(showBack: showBack, showSettings: showSettings),
          if (title.isNotEmpty) ...[
            SizedBox(height: centerTitle ? 42 : 26),
            Text(
              title,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: palette.tertiary,
                fontSize: centerTitle ? 26 : 28,
                fontWeight: FontWeight.w600,
                height: 1.18,
                letterSpacing: 0,
              ),
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: palette.textSecondary,
                fontSize: centerTitle ? 16 : 15,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar({required this.showBack, required this.showSettings});

  final bool showBack;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    Widget leading;
    if (showBack) {
      leading = IconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
        icon: Icon(Icons.arrow_back_rounded, color: palette.tertiary),
      );
    } else if (showSettings) {
      leading = Icon(
        Icons.settings_outlined,
        color: palette.tertiary,
        size: 50,
      );
    } else {
      leading = _Avatar(settings: settings);
    }

    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Align(alignment: Alignment.centerLeft, child: leading),
        ),
        Expanded(
          child: Text(
            'MichiFocus',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: palette.tertiary,
              fontSize: AppDesignTokens.sectionTitleFontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ),
        _NotificationCenter(settings: settings),
        if (showSettings) ...[
          const SizedBox(width: 14),
          _Avatar(settings: settings, radius: 16),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.settings,
    this.radius = 22,
    this.enableQuickStats = true,
  });

  final AppSettingsScope settings;
  final double radius;
  final bool enableQuickStats;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final image = _profileImage(settings.profileImagePath);

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: palette.primaryMuted,
      foregroundImage: image,
      child: image == null
          ? Text(
              _avatarLabel(settings),
              style: TextStyle(
                color: palette.tertiary,
                fontSize: radius * 0.62,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
    );

    if (!enableQuickStats) {
      return avatar;
    }

    return Tooltip(
      message: 'Estadisticas rapidas',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _showProfileQuickStats(context, settings),
        child: avatar,
      ),
    );
  }

  ImageProvider? _profileImage(String path) {
    if (path.isEmpty) {
      return null;
    }

    final file = File(path);
    if (!file.existsSync()) {
      return null;
    }

    return FileImage(file);
  }

  String _avatarLabel(AppSettingsScope settings) {
    if (settings.profileName.trim().isNotEmpty) {
      return settings.profileName.trim().characters.first.toUpperCase();
    }

    return settings.avatarIndex == 1 ? 'CH' : 'C';
  }
}

enum _ProfileStatsRange { day, month, year }

Future<void> _showProfileQuickStats(
  BuildContext context,
  AppSettingsScope settings,
) async {
  var selectedRange = _ProfileStatsRange.day;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return SafeArea(
            child: SignalBuilder(
              builder: (sheetContext) {
                final snapshot = _ProfileStatsSnapshot.fromControllers(
                  range: selectedRange,
                );

                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                  children: [
                    Row(
                      children: [
                        _Avatar(
                          settings: settings,
                          enableQuickStats: false,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                settings.profileName,
                                style: Theme.of(
                                  sheetContext,
                                ).textTheme.titleMedium,
                              ),
                              if (settings.profileEmail.trim().isNotEmpty)
                                Text(
                                  settings.profileEmail,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(sheetContext)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            sheetContext.palette.textSecondary,
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SegmentedButton<_ProfileStatsRange>(
                      segments: const [
                        ButtonSegment(
                          value: _ProfileStatsRange.day,
                          label: Text('Dia'),
                        ),
                        ButtonSegment(
                          value: _ProfileStatsRange.month,
                          label: Text('Mes'),
                        ),
                        ButtonSegment(
                          value: _ProfileStatsRange.year,
                          label: Text('Anio'),
                        ),
                      ],
                      selected: {selectedRange},
                      showSelectedIcon: false,
                      onSelectionChanged: (selection) {
                        setSheetState(() => selectedRange = selection.single);
                      },
                    ),
                    const SizedBox(height: 18),
                    _QuickMoodCard(snapshot: snapshot),
                    const SizedBox(height: 12),
                    _QuickTaskStats(snapshot: snapshot),
                    const SizedBox(height: 12),
                    _MotivationCard(message: snapshot.motivation),
                  ],
                );
              },
            ),
          );
        },
      );
    },
  );
}

class _QuickMoodCard extends StatelessWidget {
  const _QuickMoodCard({required this.snapshot});

  final _ProfileStatsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return _QuickStatsTile(
      icon: Icons.self_improvement_rounded,
      title: 'Como te has sentido',
      value: snapshot.moodLabel,
      subtitle: '${snapshot.reflectionCount} registros',
      color: palette.primary,
    );
  }
}

class _QuickTaskStats extends StatelessWidget {
  const _QuickTaskStats({required this.snapshot});

  final _ProfileStatsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuickStatsTile(
          icon: Icons.playlist_add_check_rounded,
          title: 'Pendientes',
          value: '${snapshot.pendingTasks}',
          subtitle: snapshot.rangeLabel,
          color: context.palette.secondary,
        ),
        const SizedBox(height: 8),
        _QuickStatsTile(
          icon: Icons.pending_actions_rounded,
          title: 'En progreso',
          value: '${snapshot.inProgressTasks}',
          subtitle: snapshot.rangeLabel,
          color: const Color(0xFFE3B341),
        ),
        const SizedBox(height: 8),
        _QuickStatsTile(
          icon: Icons.task_alt_rounded,
          title: 'Completadas',
          value: '${snapshot.completedTasks}',
          subtitle: snapshot.rangeLabel,
          color: context.palette.primary,
        ),
      ],
    );
  }
}

class _MotivationCard extends StatelessWidget {
  const _MotivationCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.palette.primaryMuted.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.palette.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _QuickStatsTile extends StatelessWidget {
  const _QuickStatsTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatsSnapshot {
  const _ProfileStatsSnapshot({
    required this.range,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.averageMood,
    required this.reflectionCount,
  });

  factory _ProfileStatsSnapshot.fromControllers({
    required _ProfileStatsRange range,
  }) {
    final tasksController = serviceLocator<TasksController>();
    final pomodoroController = serviceLocator<PomodoroController>();
    final now = DateTime.now();
    final bounds = _profileRangeBounds(range, now);
    final tasks = tasksController.tasks.value.where((task) {
      final date = task.scheduledDate ?? task.createdAt;
      return !_dateOnly(date).isBefore(bounds.start) &&
          !_dateOnly(date).isAfter(bounds.end);
    });
    final moodScores = pomodoroController.sessions.value
        .where((session) {
          final date = _dateOnly(session.endedAt);
          return !date.isBefore(bounds.start) && !date.isAfter(bounds.end);
        })
        .map((session) => session.endMoodScore ?? session.startMoodScore)
        .whereType<int>()
        .toList(growable: false);
    final averageMood = moodScores.isEmpty
        ? null
        : moodScores.reduce((first, second) => first + second) /
              moodScores.length;
    final summary = TaskStatusSummary.fromTasks(tasks);

    return _ProfileStatsSnapshot(
      range: range,
      pendingTasks: summary.listed,
      inProgressTasks: summary.inProgress,
      completedTasks: summary.completed,
      averageMood: averageMood,
      reflectionCount: moodScores.length,
    );
  }

  final _ProfileStatsRange range;
  final int pendingTasks;
  final int inProgressTasks;
  final int completedTasks;
  final double? averageMood;
  final int reflectionCount;

  String get rangeLabel {
    return switch (range) {
      _ProfileStatsRange.day => 'Hoy',
      _ProfileStatsRange.month => 'Este mes',
      _ProfileStatsRange.year => 'Este anio',
    };
  }

  String get moodLabel {
    final mood = averageMood;
    if (mood == null) {
      return 'Sin datos';
    }

    return '${mood.toStringAsFixed(1)}/5';
  }

  String get motivation {
    final mood = averageMood;
    if (mood == null) {
      return 'Registra tu proximo enfoque y el panel empezara a mostrar tu ritmo real.';
    }

    if (mood < 2.5) {
      return 'Baja la friccion: una tarea pequena y un descanso honesto pueden cambiar el dia.';
    }

    if (mood < 4) {
      return 'Vas estable. Cierra una tarea antes de abrir otra y protege ese avance.';
    }

    return 'Buen ritmo. Aprovecha esta energia para terminar lo importante y cerrar con calma.';
  }
}

DateTimeRange _profileRangeBounds(_ProfileStatsRange range, DateTime now) {
  final today = _dateOnly(now);

  return switch (range) {
    _ProfileStatsRange.day => DateTimeRange(start: today, end: today),
    _ProfileStatsRange.month => DateTimeRange(
      start: DateTime(today.year, today.month),
      end: DateTime(today.year, today.month + 1, 0),
    ),
    _ProfileStatsRange.year => DateTimeRange(
      start: DateTime(today.year),
      end: DateTime(today.year, 12, 31),
    ),
  };
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class _NotificationCenter extends StatelessWidget {
  const _NotificationCenter({required this.settings});

  final AppSettingsScope settings;

  static const _clearAction = 'clear';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final notifications = settings.notifications;

    return PopupMenuButton<Object>(
      tooltip: 'Centro de notificaciones',
      offset: const Offset(0, 36),
      onSelected: (value) {
        if (value == _clearAction) {
          settings.onClearNotifications();
          return;
        }

        if (value is AppNotification) {
          final routePath = value.routePath;
          if (routePath != null && routePath.isNotEmpty) {
            context.go(routePath);
          }
        }
      },
      itemBuilder: (context) {
        if (notifications.isEmpty) {
          return [
            PopupMenuItem<Object>(
              enabled: false,
              child: Text(
                'Sin notificaciones',
                style: TextStyle(color: palette.textSecondary),
              ),
            ),
          ];
        }

        return [
          for (final notification in notifications)
            PopupMenuItem<Object>(
              value: notification,
              child: SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatNotificationTime(notification.createdAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const PopupMenuDivider(),
          const PopupMenuItem<Object>(
            value: _clearAction,
            child: Row(
              children: [
                Icon(Icons.done_all_rounded, size: 18),
                SizedBox(width: 10),
                Text('Limpiar notificaciones'),
              ],
            ),
          ),
        ];
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Badge.count(
            count: notifications.length,
            isLabelVisible: notifications.isNotEmpty,
            child: Icon(
              Icons.notifications_none_rounded,
              color: palette.tertiary,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  String _formatNotificationTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
