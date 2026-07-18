import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/settings/domain/entities/timer_preferences.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';

void main() {
  group('AppSettingsController timer settings', () {
    test('statistics report periods expose V2 labels', () {
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.day,
        ).label,
        'Day',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.week,
        ).label,
        'Week',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.month,
        ).label,
        'Month',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.year,
        ).label,
        'Year',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.range,
        ).label,
        'Custom range',
      );
    });

    test('statistics report data derives totals and progress', () {
      const data = StatisticsReportData(
        tasks: StatisticsTaskTotals(listed: 1, inProgress: 1, completed: 2),
        calendarDays: [],
        completedPomodoros: 3,
        focusedSeconds: 3700,
      );

      expect(data.tasks.total, 4);
      expect(data.tasks.completionRatio, 0.5);
      expect(data.focusedMinutes, 61);
      expect(data.progressPercent, 50);
      expect(data.completedPomodoros, 3);
    });

    test('clamps focus duration to the supported slider range', () {
      final controller = AppSettingsController()..setFocusMinutes(3);

      expect(controller.focusMinutes.value, 5);
      expect(controller.remainingSeconds.value, 5 * 60);

      controller.setFocusMinutes(120);

      expect(controller.focusMinutes.value, 90);
      expect(controller.remainingSeconds.value, 90 * 60);
    });

    test('clamps short and long break durations', () {
      final controller = AppSettingsController()
        ..setShortBreakMinutes(0)
        ..setLongBreakMinutes(60);

      expect(controller.shortBreakMinutes.value, 1);
      expect(controller.longBreakMinutes.value, 45);
    });

    test('clamps long break frequency', () {
      final controller = AppSettingsController()..setLongBreakFrequency(1);

      expect(controller.longBreakFrequency.value, 3);

      controller.setLongBreakFrequency(9);

      expect(controller.longBreakFrequency.value, 5);
    });

    test('stores the selected completion sound', () {
      final controller = AppSettingsController()
        ..selectedCompletionSound = PomodoroCompletionSound.lightTap;

      expect(
        controller.completionSound.value,
        PomodoroCompletionSound.lightTap,
      );

      controller.selectedCompletionSound = PomodoroCompletionSound.silent;

      expect(controller.completionSound.value, PomodoroCompletionSound.silent);
    });

    test('stores completion vibration preference', () {
      final controller = AppSettingsController()
        ..isCompletionVibrationEnabled = false;

      expect(controller.completionVibrationEnabled.value, isFalse);

      controller.isCompletionVibrationEnabled = true;

      expect(controller.completionVibrationEnabled.value, isTrue);
    });

    test('adds and clears in-app notifications', () async {
      final controller = AppSettingsController();

      await controller.sendTestNotification(playFeedback: false);

      expect(controller.notifications.value, hasLength(1));
      expect(
        controller.notifications.value.first.title,
        'Notificacion de prueba',
      );
      expect(
        controller.notifications.value.first.routePath,
        '/settings/notifications',
      );

      controller.clearNotifications();

      expect(controller.notifications.value, isEmpty);
    });

    test('keeps at least one statistics chart enabled', () {
      final controller = AppSettingsController();

      for (final chart in StatisticsChartType.values.skip(1)) {
        controller.setStatisticsChartEnabled(chart, enabled: false);
      }
      controller.setStatisticsChartEnabled(
        StatisticsChartType.circular,
        enabled: false,
      );

      expect(controller.enabledStatisticsCharts.value, {
        StatisticsChartType.circular,
      });
    });

    test('statistics PDF uses profile and enabled chart selection', () async {
      final directory = await Directory.systemTemp.createTemp(
        'michifocus-report-test-',
      );
      final controller = AppSettingsController()
        ..setReportsDirectoryPath(directory.path)
        ..setProfileName('Ana Cliente')
        ..setProfileEmail('ana@example.com')
        ..setStatisticsChartEnabled(
          StatisticsChartType.groupedBars,
          enabled: false,
        );

      addTearDown(() async {
        if (directory.existsSync()) {
          await directory.delete(recursive: true);
        }
      });

      await controller.downloadStatisticsPdf(
        const StatisticsReportRequest(period: StatisticsReportPeriod.day),
        StatisticsReportData(
          tasks: const StatisticsTaskTotals(
            listed: 1,
            inProgress: 1,
            completed: 2,
          ),
          calendarDays: [
            StatisticsCalendarDay(
              day: DateTime(2026, 7, 18),
              completionRatio: 0.5,
              isEnded: true,
              totalTasks: 4,
            ),
          ],
          completedPomodoros: 3,
          focusedSeconds: 3600,
        ),
      );

      final pdf = File('${directory.path}/michifocus-statistics.pdf');
      final content = latin1.decode(await pdf.readAsBytes());

      expect(content, contains('Ana Cliente'));
      expect(content, contains('ana@example.com'));
      expect(content, contains(StatisticsChartType.circular.label));
      expect(content, isNot(contains(StatisticsChartType.groupedBars.label)));
      expect(controller.lastReportPath.value, pdf.path);
    });

    test('stages and applies database backup import', () async {
      final appDirectory = await Directory.systemTemp.createTemp(
        'michifocus-app-docs-',
      );
      final backupDirectory = await Directory.systemTemp.createTemp(
        'michifocus-backup-',
      );
      final controller = AppSettingsController(
        documentsDirectory: appDirectory,
      );

      addTearDown(() async {
        if (appDirectory.existsSync()) {
          await appDirectory.delete(recursive: true);
        }
        if (backupDirectory.existsSync()) {
          await backupDirectory.delete(recursive: true);
        }
      });

      await File(
        '${backupDirectory.path}/michidoro-settings.json',
      ).writeAsString('{"profileName":"Backup"}');
      await File(
        '${backupDirectory.path}/michifocus_tasks.sqlite',
      ).writeAsString('sqlite-bytes');

      await controller.stageDatabaseBackupImport(backupDirectory.path);

      expect(
        File(
          '${appDirectory.path}/michifocus-pending-import/michifocus_tasks.sqlite',
        ).existsSync(),
        isTrue,
      );

      final applied = await controller.applyPendingDatabaseImport();

      expect(applied, isTrue);
      expect(
        File('${appDirectory.path}/michifocus_tasks.sqlite').readAsStringSync(),
        'sqlite-bytes',
      );
      expect(
        Directory(
          '${appDirectory.path}/michifocus-pending-import',
        ).existsSync(),
        isFalse,
      );
    });

    test('rejects import folders without backup files', () async {
      final appDirectory = await Directory.systemTemp.createTemp(
        'michifocus-app-docs-',
      );
      final backupDirectory = await Directory.systemTemp.createTemp(
        'michifocus-empty-backup-',
      );
      final controller = AppSettingsController(
        documentsDirectory: appDirectory,
      );

      addTearDown(() async {
        if (appDirectory.existsSync()) {
          await appDirectory.delete(recursive: true);
        }
        if (backupDirectory.existsSync()) {
          await backupDirectory.delete(recursive: true);
        }
      });

      await expectLater(
        controller.stageDatabaseBackupImport(backupDirectory.path),
        throwsA(isA<FileSystemException>()),
      );
    });

    test('loads persisted timer preferences', () async {
      final repository = _MemorySettingsRepository(
        const TimerPreferences(
          focusMinutes: 40,
          shortBreakMinutes: 7,
          longBreakMinutes: 22,
          longBreakFrequency: 4,
          completionSound: PomodoroCompletionSound.lightTap,
          completionVibrationEnabled: false,
          autoStartBreak: false,
          autoStartFocus: true,
          reportsDirectoryPath: r' C:\Reports ',
          profileName: ' Chris Dev ',
          profileEmail: ' chris@example.com ',
          profileImagePath: r' C:\Pictures\me.png ',
          avatarIndex: 2,
          typographyPreset: AppTypographyPreset.serio,
          enabledStatisticsCharts: {
            StatisticsChartType.circular,
            StatisticsChartType.xy,
          },
        ),
      );
      final controller = AppSettingsController();

      await controller.loadTimerPreferences(repository);

      expect(controller.focusMinutes.value, 40);
      expect(controller.shortBreakMinutes.value, 7);
      expect(controller.longBreakMinutes.value, 22);
      expect(controller.longBreakFrequency.value, 4);
      expect(
        controller.completionSound.value,
        PomodoroCompletionSound.lightTap,
      );
      expect(controller.completionVibrationEnabled.value, isFalse);
      expect(controller.autoStartBreak.value, isFalse);
      expect(controller.autoStartFocus.value, isTrue);
      expect(controller.reportsDirectoryPath.value, r'C:\Reports');
      expect(controller.profileName.value, 'Chris Dev');
      expect(controller.profileEmail.value, 'chris@example.com');
      expect(controller.profileImagePath.value, r'C:\Pictures\me.png');
      expect(controller.avatarIndex.value, 2);
      expect(controller.typographyPreset.value, AppTypographyPreset.serio);
      expect(controller.enabledStatisticsCharts.value, {
        StatisticsChartType.circular,
        StatisticsChartType.xy,
      });
      expect(controller.remainingSeconds.value, 40 * 60);
    });

    test('saves normalized timer preferences', () async {
      final repository = _MemorySettingsRepository(
        const TimerPreferences.defaults(),
      );
      final controller = AppSettingsController();
      await controller.loadTimerPreferences(repository);

      controller
        ..setFocusMinutes(120)
        ..setShortBreakMinutes(0)
        ..setLongBreakMinutes(60)
        ..setLongBreakFrequency(9)
        ..selectedCompletionSound = PomodoroCompletionSound.silent
        ..isCompletionVibrationEnabled = false
        ..setReportsDirectoryPath(r' C:\Downloads\MichiFocus ')
        ..setProfileName(' Ana ')
        ..setProfileEmail(' ana@example.com ')
        ..setProfileImagePath(r' C:\Pictures\ana.png ')
        ..setAvatarIndex(9)
        ..selectedTypographyPreset = AppTypographyPreset.normal
        ..setStatisticsChartEnabled(
          StatisticsChartType.groupedBars,
          enabled: false,
        );
      await controller.saveTimerPreferences();

      expect(repository.saved?.focusMinutes, 90);
      expect(repository.saved?.shortBreakMinutes, 1);
      expect(repository.saved?.longBreakMinutes, 45);
      expect(repository.saved?.longBreakFrequency, 5);
      expect(repository.saved?.completionSound, PomodoroCompletionSound.silent);
      expect(repository.saved?.completionVibrationEnabled, isFalse);
      expect(
        repository.saved?.reportsDirectoryPath,
        r'C:\Downloads\MichiFocus',
      );
      expect(repository.saved?.profileName, 'Ana');
      expect(repository.saved?.profileEmail, 'ana@example.com');
      expect(repository.saved?.profileImagePath, r'C:\Pictures\ana.png');
      expect(repository.saved?.avatarIndex, 3);
      expect(repository.saved?.typographyPreset, AppTypographyPreset.normal);
      expect(
        repository.saved?.enabledStatisticsCharts,
        isNot(contains(StatisticsChartType.groupedBars)),
      );
    });
  });
}

class _MemorySettingsRepository implements SettingsRepository {
  _MemorySettingsRepository(this.preferences);

  TimerPreferences preferences;
  TimerPreferences? saved;

  @override
  Future<TimerPreferences> loadTimerPreferences() async {
    return preferences;
  }

  @override
  Future<void> saveTimerPreferences(TimerPreferences preferences) async {
    saved = preferences;
    this.preferences = preferences;
  }
}
