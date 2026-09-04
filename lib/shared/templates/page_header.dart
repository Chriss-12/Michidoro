import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart'
    show AppNotification;
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

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
    final profileName = settings.profileName.trim();
    final brandLabel = profileName.isEmpty ? 'MichiFocus' : profileName;

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
          child: Tooltip(
            message: context.tr(
              'Abrir estadísticas por período',
              'Open statistics by period',
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _showProfileQuickStats(context, settings),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  brandLabel,
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
      message: context.tr('Estadísticas rápidas', 'Quick statistics'),
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
  final today = DateTime.now();
  var selection = _ProfileStatsSelection.today(today);
  Future<StatisticsReportData> loadReport() {
    return serviceLocator<GenerateStatisticsReport>()(
      selection.reportRequest(today),
    );
  }

  var reportFuture = loadReport();

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
            child: ListView(
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
                              style: Theme.of(sheetContext).textTheme.bodySmall
                                  ?.copyWith(
                                    color: sheetContext.palette.textSecondary,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SegmentedButton<_ProfileStatsRange>(
                  segments: [
                    ButtonSegment(
                      value: _ProfileStatsRange.day,
                      label: Text(context.tr('Día', 'Day')),
                    ),
                    ButtonSegment(
                      value: _ProfileStatsRange.month,
                      label: Text(context.tr('Mes', 'Month')),
                    ),
                    ButtonSegment(
                      value: _ProfileStatsRange.year,
                      label: Text(context.tr('Año', 'Year')),
                    ),
                  ],
                  selected: {selection.range},
                  showSelectedIcon: false,
                  onSelectionChanged: (ranges) {
                    setSheetState(() {
                      selection = selection.forRange(ranges.single, today);
                      reportFuture = loadReport();
                    });
                  },
                ),
                const SizedBox(height: 18),
                _ProfilePeriodPicker(
                  selection: selection,
                  today: today,
                  onChanged: (next) => setSheetState(() {
                    selection = next;
                    reportFuture = loadReport();
                  }),
                ),
                const SizedBox(height: 18),
                FutureBuilder<StatisticsReportData>(
                  future: reportFuture,
                  builder: (sheetContext, reportSnapshot) {
                    if (reportSnapshot.connectionState !=
                        ConnectionState.done) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (reportSnapshot.hasError ||
                        reportSnapshot.data == null) {
                      return Column(
                        children: [
                          Text(
                            context.tr(
                              'No se pudieron cargar las estadísticas.',
                              'Statistics could not be loaded.',
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => setSheetState(
                              () => reportFuture = loadReport(),
                            ),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(context.tr('Reintentar', 'Retry')),
                          ),
                        ],
                      );
                    }

                    final snapshot = _ProfileStatsSnapshot.fromReportData(
                      selection: selection,
                      report: reportSnapshot.data!,
                      taskSummary: serviceLocator<TasksController>()
                          .allTaskSummary
                          .value,
                    );
                    return Column(
                      children: [
                        _QuickMoodCard(snapshot: snapshot),
                        const SizedBox(height: 12),
                        _QuickTaskStats(snapshot: snapshot),
                        const SizedBox(height: 12),
                        _MotivationCard(
                          message: snapshot.motivation(sheetContext),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _ProfilePeriodPicker extends StatelessWidget {
  const _ProfilePeriodPicker({
    required this.selection,
    required this.today,
    required this.onChanged,
  });

  final _ProfileStatsSelection selection;
  final DateTime today;
  final ValueChanged<_ProfileStatsSelection> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = switch (selection.range) {
      _ProfileStatsRange.day => List<int>.generate(
        DateUtils.getDaysInMonth(today.year, today.month),
        (index) => index + 1,
      ),
      _ProfileStatsRange.month => List<int>.generate(12, (index) => index + 1),
      _ProfileStatsRange.year => [today.year, today.year - 1],
    };
    final value = switch (selection.range) {
      _ProfileStatsRange.day => selection.day,
      _ProfileStatsRange.month => selection.month,
      _ProfileStatsRange.year => selection.year,
    };

    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: switch (selection.range) {
          _ProfileStatsRange.day => context.tr(
            'Día del mes actual',
            'Day of the current month',
          ),
          _ProfileStatsRange.month => context.tr(
            'Mes del año actual',
            'Month of the current year',
          ),
          _ProfileStatsRange.year => context.tr('Año', 'Year'),
        },
        prefixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      items: [
        for (final option in values)
          DropdownMenuItem<int>(
            value: option,
            child: Text(_optionLabel(context, option)),
          ),
      ],
      onChanged: (next) {
        if (next == null) {
          return;
        }

        onChanged(
          switch (selection.range) {
            _ProfileStatsRange.day => selection.copyWith(day: next),
            _ProfileStatsRange.month => selection.copyWith(month: next),
            _ProfileStatsRange.year => selection.copyWith(year: next),
          },
        );
      },
    );
  }

  String _optionLabel(BuildContext context, int value) {
    return switch (selection.range) {
      _ProfileStatsRange.day =>
        '$value ${context.tr('de', 'of')} '
            '${_profileMonthName(context, today.month)}',
      _ProfileStatsRange.month => _profileMonthName(context, value),
      _ProfileStatsRange.year => '${context.tr('Año', 'Year')} $value',
    };
  }
}

class _ProfileStatsSelection {
  const _ProfileStatsSelection({
    required this.range,
    required this.day,
    required this.month,
    required this.year,
  });

  factory _ProfileStatsSelection.today(DateTime today) {
    return _ProfileStatsSelection(
      range: _ProfileStatsRange.day,
      day: today.day,
      month: today.month,
      year: today.year,
    );
  }

  final _ProfileStatsRange range;
  final int day;
  final int month;
  final int year;

  _ProfileStatsSelection copyWith({
    _ProfileStatsRange? range,
    int? day,
    int? month,
    int? year,
  }) {
    return _ProfileStatsSelection(
      range: range ?? this.range,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  _ProfileStatsSelection forRange(
    _ProfileStatsRange nextRange,
    DateTime today,
  ) {
    return _ProfileStatsSelection(
      range: nextRange,
      day: today.day,
      month: today.month,
      year: today.year,
    );
  }

  StatisticsReportRequest reportRequest(DateTime today) {
    final period = switch (range) {
      _ProfileStatsRange.day => StatisticsReportPeriod.day,
      _ProfileStatsRange.month => StatisticsReportPeriod.month,
      _ProfileStatsRange.year => StatisticsReportPeriod.year,
    };
    final anchor = switch (range) {
      _ProfileStatsRange.day => DateTime(today.year, today.month, day),
      _ProfileStatsRange.month => DateTime(today.year, month),
      _ProfileStatsRange.year => DateTime(year),
    };
    return StatisticsReportRequest(period: period, anchor: anchor);
  }

  String label(BuildContext context) {
    return switch (range) {
      _ProfileStatsRange.day =>
        '$day ${context.tr('de', 'of')} ${_profileMonthName(context, month)}',
      _ProfileStatsRange.month => '${_profileMonthName(context, month)} $year',
      _ProfileStatsRange.year => '${context.tr('Año', 'Year')} $year',
    };
  }
}

String _profileMonthName(BuildContext context, int month) {
  return [
    context.tr('Enero', 'January'),
    context.tr('Febrero', 'February'),
    context.tr('Marzo', 'March'),
    context.tr('Abril', 'April'),
    context.tr('Mayo', 'May'),
    context.tr('Junio', 'June'),
    context.tr('Julio', 'July'),
    context.tr('Agosto', 'August'),
    context.tr('Septiembre', 'September'),
    context.tr('Octubre', 'October'),
    context.tr('Noviembre', 'November'),
    context.tr('Diciembre', 'December'),
  ][month - 1];
}

class _QuickMoodCard extends StatelessWidget {
  const _QuickMoodCard({required this.snapshot});

  final _ProfileStatsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return _QuickStatsTile(
      icon: Icons.self_improvement_rounded,
      title: context.tr('Cómo te has sentido', 'How you have felt'),
      value: snapshot.moodLabel(context),
      subtitle: context.tr(
        '${snapshot.reflectionCount} registros',
        '${snapshot.reflectionCount} entries',
      ),
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
          title: context.tr('Pendientes', 'Pending'),
          value: '${snapshot.pendingTasks}',
          valueKey: const ValueKey('profile-pending-task-count'),
          subtitle: snapshot.rangeLabel(context),
          color: context.palette.secondary,
        ),
        const SizedBox(height: 8),
        _QuickStatsTile(
          icon: Icons.pending_actions_rounded,
          title: context.tr('En progreso', 'In progress'),
          value: '${snapshot.inProgressTasks}',
          valueKey: const ValueKey('profile-in-progress-task-count'),
          subtitle: snapshot.rangeLabel(context),
          color: context.palette.statusWarning,
        ),
        const SizedBox(height: 8),
        _QuickStatsTile(
          icon: Icons.task_alt_rounded,
          title: context.tr('Completadas', 'Completed'),
          value: '${snapshot.completedTasks}',
          valueKey: const ValueKey('profile-completed-task-count'),
          subtitle: snapshot.rangeLabel(context),
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
    this.valueKey,
  });

  final IconData icon;
  final String title;
  final String value;
  final Key? valueKey;
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
            key: valueKey,
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
    required this.selection,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.averageMood,
    required this.reflectionCount,
  });

  factory _ProfileStatsSnapshot.fromReportData({
    required _ProfileStatsSelection selection,
    required StatisticsReportData report,
    required TaskStatusSummary taskSummary,
  }) {
    return _ProfileStatsSnapshot(
      selection: selection,
      pendingTasks: taskSummary.listed,
      inProgressTasks: taskSummary.inProgress,
      completedTasks: taskSummary.completed,
      averageMood: report.moodAverage,
      reflectionCount: report.moodSampleCount,
    );
  }

  final _ProfileStatsSelection selection;
  final int pendingTasks;
  final int inProgressTasks;
  final int completedTasks;
  final double? averageMood;
  final int reflectionCount;

  String rangeLabel(BuildContext context) {
    return selection.label(context);
  }

  String moodLabel(BuildContext context) {
    final mood = averageMood;
    if (mood == null) {
      return context.tr('', 'No data');
    }

    return '${mood.toStringAsFixed(1)}/5';
  }

  String motivation(BuildContext context) {
    final mood = averageMood;
    if (mood == null) {
      return context.tr(
        'Registra tu próximo enfoque y el panel empezará a mostrar tu ritmo real.',
        'Log your next focus session and the panel will start showing your actual pace.',
      );
    }

    if (mood < 2.5) {
      return context.tr(
        'Baja la fricción: una tarea pequeña y un descanso honesto pueden cambiar el día.',
        'Reduce friction: a small task and a proper break can change your day.',
      );
    }

    if (mood < 4) {
      return context.tr(
        'Vas estable. Cierra una tarea antes de abrir otra y protege ese avance.',
        'You are steady. Finish one task before starting another and protect that progress.',
      );
    }

    return context.tr(
      'Buen ritmo. Aprovecha esta energía para terminar lo importante y cerrar con calma.',
      'Good pace. Use this energy to finish what matters and wrap up calmly.',
    );
  }
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
      tooltip: context.tr('Centro de notificaciones', 'Notification center'),
      offset: const Offset(0, 36),
      color: palette.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: palette.neutralSoft),
      ),
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
                context.tr('Sin notificaciones', 'No notifications'),
                style: TextStyle(color: palette.textSecondary),
              ),
            ),
          ];
        }

        return [
          for (final notification in notifications)
            PopupMenuItem<Object>(
              value: notification,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: _NotificationCard(notification: notification),
            ),
          const PopupMenuDivider(),
          PopupMenuItem<Object>(
            value: _clearAction,
            child: Row(
              children: [
                const Icon(Icons.done_all_rounded, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.tr(
                      'Limpiar notificaciones',
                      'Clear notifications',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
}

enum _NotificationKind { goal, task, routine, general }

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final kind = _notificationKind(notification);
    final accent = switch (kind) {
      _NotificationKind.goal => palette.primary,
      _NotificationKind.task => palette.primary,
      _NotificationKind.routine => palette.secondary,
      _NotificationKind.general => palette.tertiary,
    };
    final softBackground = switch (kind) {
      _NotificationKind.goal => palette.primaryMuted,
      _NotificationKind.task => palette.primaryMuted,
      _NotificationKind.routine => palette.secondarySoft,
      _NotificationKind.general => palette.neutralSoft,
    };
    final taskCount = kind == _NotificationKind.task
        ? _pendingTaskCount(notification)
        : null;
    final body =
        kind == _NotificationKind.task || kind == _NotificationKind.goal
        ? null
        : _localizedNotificationBody(context, notification.body);

    return Container(
      key: ValueKey('notification-card-${kind.name}'),
      width: 276,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: softBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationKindIcon(notification: notification),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            kind == _NotificationKind.task
                                ? context.tr(
                                    'Tareas pendientes',
                                    'Pending tasks',
                                  )
                                : _localizedNotificationTitle(
                                    context,
                                    notification.title,
                                  ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: palette.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (taskCount != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            key: const ValueKey('notification-task-count'),
                            constraints: const BoxConstraints(minWidth: 30),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: palette.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$taskCount',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (kind == _NotificationKind.goal) ...[
                      const SizedBox(height: 8),
                      _GoalNotificationCounts(notification: notification),
                    ],
                    if (body != null && body.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _NotificationMetaCapsule(
                    key: ValueKey('notification-time-${kind.name}'),
                    icon: Icons.schedule_rounded,
                    label: _formatNotificationTime(notification.createdAt),
                    accent: accent,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _NotificationMetaCapsule(
                    key: ValueKey('notification-date-${kind.name}'),
                    icon: Icons.calendar_today_rounded,
                    label: _formatNotificationDate(notification.createdAt),
                    accent: accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalNotificationCounts extends StatelessWidget {
  const _GoalNotificationCounts({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final goalId = notification.goalId ?? 'unknown';

    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: [
        _GoalNotificationCount(
          key: ValueKey('notification-goal-$goalId-listed'),
          icon: Icons.assignment_outlined,
          count: notification.pendingCount ?? 0,
          color: palette.tertiary,
          label: context.tr('Pendientes', 'Pending'),
        ),
        _GoalNotificationCount(
          key: ValueKey('notification-goal-$goalId-inProgress'),
          icon: Icons.pending_actions_rounded,
          count: notification.inProgressCount ?? 0,
          color: palette.secondary,
          label: context.tr('En progreso', 'In progress'),
        ),
        _GoalNotificationCount(
          key: ValueKey('notification-goal-$goalId-completed'),
          icon: Icons.task_alt_rounded,
          count: notification.completedCount ?? 0,
          color: palette.primary,
          label: context.tr('Completadas', 'Completed'),
        ),
      ],
    );
  }
}

class _GoalNotificationCount extends StatelessWidget {
  const _GoalNotificationCount({
    required this.icon,
    required this.count,
    required this.color,
    required this.label,
    super.key,
  });

  final IconData icon;
  final int count;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.palette.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationMetaCapsule extends StatelessWidget {
  const _NotificationMetaCapsule({
    required this.icon,
    required this.label,
    required this.accent,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: accent),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: palette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationKindIcon extends StatelessWidget {
  const _NotificationKindIcon({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final kind = _notificationKind(notification);
    final (icon, color, label) = switch (kind) {
      _NotificationKind.goal => (
        Icons.flag_rounded,
        palette.primary,
        context.tr('Objetivo', 'Goal'),
      ),
      _NotificationKind.task => (
        Icons.task_alt_rounded,
        palette.primary,
        context.tr('Tarea', 'Task'),
      ),
      _NotificationKind.routine => (
        Icons.event_repeat_rounded,
        palette.secondary,
        context.tr('Rutina', 'Routine'),
      ),
      _NotificationKind.general => (
        Icons.notifications_active_outlined,
        palette.tertiary,
        context.tr('Notificación', 'Notification'),
      ),
    };

    return Container(
      key: ValueKey('notification-kind-${kind.name}'),
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 21, color: color, semanticLabel: label),
    );
  }
}

_NotificationKind _notificationKind(AppNotification notification) {
  if (notification.isGoalSummary) {
    return _NotificationKind.goal;
  }

  final searchable =
      '${notification.title} ${notification.body} '
              '${notification.routePath ?? ''}'
          .toLowerCase();
  if (searchable.contains('rutina') || searchable.contains('routine')) {
    return _NotificationKind.routine;
  }
  if (searchable.contains('tarea') ||
      searchable.contains('task') ||
      searchable.contains('/tasks') ||
      searchable.contains('/calendar')) {
    return _NotificationKind.task;
  }
  return _NotificationKind.general;
}

int _pendingTaskCount(AppNotification notification) {
  final countMatch = RegExp(
    r'(?:Tienes|You have) (\d+) (?:tareas pendientes|pending tasks)',
    caseSensitive: false,
  ).firstMatch(notification.body);

  return int.tryParse(countMatch?.group(1) ?? '') ?? 1;
}

String _formatNotificationTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}

String _formatNotificationDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}

String _localizedNotificationTitle(BuildContext context, String title) {
  return switch (title) {
    'Tarea programada' => context.tr('Tarea programada', 'Scheduled task'),
    'Tarea programada para hoy' => context.tr(
      'Tarea programada para hoy',
      'Task scheduled for today',
    ),
    'Tareas programadas para hoy' => context.tr(
      'Tareas programadas para hoy',
      'Tasks scheduled for today',
    ),
    _ => title,
  };
}

String _localizedNotificationBody(BuildContext context, String body) {
  final singleTask = RegExp(r'^Tienes pendiente: (.*)\.$').firstMatch(body);
  if (singleTask != null) {
    final taskName = singleTask.group(1)!;
    return context.tr(
      'Tienes pendiente: $taskName.',
      'Pending task: $taskName.',
    );
  }

  final multipleTasks = RegExp(
    r'^Tienes (\d+) tareas pendientes\. Empieza por: (.*)\.$',
  ).firstMatch(body);
  if (multipleTasks != null) {
    final count = multipleTasks.group(1)!;
    final taskName = multipleTasks.group(2)!;
    return context.tr(
      'Tienes $count tareas pendientes. Empieza por: $taskName.',
      'You have $count pending tasks. Start with: $taskName.',
    );
  }

  final testNotification = RegExp(
    r'^Hoy a (.+) - Revisar tu siguiente bloque de enfoque\.$',
  ).firstMatch(body);
  if (testNotification != null) {
    final time = testNotification.group(1)!;
    return context.tr(
      'Hoy a $time - Revisar tu siguiente bloque de enfoque.',
      'Today at $time - Review your next focus block.',
    );
  }

  return body;
}
