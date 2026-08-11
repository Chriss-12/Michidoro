import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/native_file_manager.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/calendar/data/datasources/calendar_events_database.dart'
    as legacy_calendar;
import 'package:pomodoro_app_v1/features/goals/data/datasources/goals_database.dart'
    as legacy_goals;
import 'package:pomodoro_app_v1/features/pomodoro/data/datasources/pomodoro_sessions_database.dart'
    as legacy_pomodoro;
import 'package:pomodoro_app_v1/features/reports/domain/entities/statistics_report_file.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_file_writer.dart';
import 'package:pomodoro_app_v1/features/settings/data/repositories/file_settings_repository.dart';
import 'package:pomodoro_app_v1/features/settings/domain/entities/timer_preferences.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/data/datasources/tasks_database.dart'
    as legacy_tasks;
import 'package:pomodoro_app_v1/l10n/app_language.dart';
// NativeDatabase exposes sqlite3 through a transitive package in production.
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettingsController timer settings', () {
    test('statistics report periods expose V2 labels', () {
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.day,
        ).label,
        'Día',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.week,
        ).label,
        'Semana',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.month,
        ).label,
        'Mes',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.year,
        ).label,
        'Año',
      );
      expect(
        const StatisticsReportRequest(
          period: StatisticsReportPeriod.range,
        ).label,
        'Rango personalizado',
      );
    });

    test('statistics report data derives totals and progress', () {
      final data = StatisticsReportData(
        range: const StatisticsReportRequest(
          period: StatisticsReportPeriod.day,
        ).resolve(DateTime(2026, 7, 21, 10, 30)),
        tasks: const StatisticsTaskTotals(
          listed: 1,
          inProgress: 1,
          completed: 2,
        ),
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
        ..selectedCompletionSound = PomodoroCompletionSound.warmChime;

      expect(
        controller.completionSound.value,
        PomodoroCompletionSound.warmChime,
      );

      controller.selectedCompletionSound = PomodoroCompletionSound.silent;

      expect(controller.completionSound.value, PomodoroCompletionSound.silent);
    });

    test('exposes several audible notification sound options', () {
      final audibleSounds = PomodoroCompletionSound.values
          .where((sound) => sound.isAudible)
          .toList(growable: false);
      final labels = {
        for (final sound in PomodoroCompletionSound.values) sound.label,
      };

      expect(audibleSounds, hasLength(greaterThanOrEqualTo(7)));
      expect(labels, hasLength(PomodoroCompletionSound.values.length));
      expect(audibleSounds, contains(PomodoroCompletionSound.warmChime));
      expect(audibleSounds, contains(PomodoroCompletionSound.crystalChime));
      expect(audibleSounds, contains(PomodoroCompletionSound.digitalZen));
      expect(PomodoroCompletionSound.silent.isAudible, isFalse);
    });

    test('stores completion vibration preference', () {
      final controller = AppSettingsController()
        ..isCompletionVibrationEnabled = false;

      expect(controller.completionVibrationEnabled.value, isFalse);

      controller.isCompletionVibrationEnabled = true;

      expect(controller.completionVibrationEnabled.value, isTrue);
    });

    test('uses the normal completion vibration pattern by default', () {
      const preferences = TimerPreferences.defaults();
      final controller = AppSettingsController();

      expect(
        preferences.completionVibrationPattern,
        PomodoroVibrationPattern.normal,
      );
      expect(
        controller.completionVibrationPattern.value,
        PomodoroVibrationPattern.normal,
      );
    });

    test('plays each selectable completion vibration pattern', () async {
      final calls = <MethodCall>[];
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
              calls.add(call);
              return null;
            });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      const patterns = PomodoroVibrationPattern.values;
      expect(patterns, hasLength(4));
      expect(patterns[1], PomodoroVibrationPattern.normal);

      final expectedHaptics = <List<String>>[
        ['HapticFeedbackType.lightImpact'],
        ['HapticFeedbackType.mediumImpact'],
        [
          'HapticFeedbackType.lightImpact',
          'HapticFeedbackType.mediumImpact',
        ],
        ['HapticFeedbackType.heavyImpact'],
      ];
      final controller = AppSettingsController()
        ..isCompletionVibrationEnabled = true;

      for (var index = 0; index < patterns.length; index += 1) {
        controller.selectedCompletionVibrationPattern = patterns[index];

        await controller.previewCompletionVibration();

        expect(
          calls
              .where((call) => call.method == 'HapticFeedback.vibrate')
              .map((call) => call.arguments)
              .toList(growable: false),
          expectedHaptics[index],
          reason: 'Unexpected haptic sequence for ${patterns[index].name}',
        );
        calls.clear();
      }
    });

    test(
      'forwards physical vibration patterns to the Android bridge',
      () async {
        const channel = MethodChannel('michifocus/native_files');
        final calls = <MethodCall>[];
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              ..setMockMethodCallHandler(channel, (call) async {
                calls.add(call);
                return true;
              });
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

        for (final pattern in PomodoroVibrationPattern.values) {
          await NativeFileManager.playCompletionVibration(pattern.name);
        }

        expect(
          calls,
          [
            for (final pattern in PomodoroVibrationPattern.values)
              isA<MethodCall>()
                  .having(
                    (call) => call.method,
                    'method',
                    'playCompletionVibration',
                  )
                  .having(
                    (call) => call.arguments,
                    'arguments',
                    {'pattern': pattern.name},
                  ),
          ],
        );
      },
    );

    test('silent completion still honors the vibration preference', () async {
      final calls = <MethodCall>[];
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
              calls.add(call);
              return null;
            });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      final controller = AppSettingsController()
        ..selectedCompletionSound = PomodoroCompletionSound.silent
        ..selectedCompletionVibrationPattern = PomodoroVibrationPattern.normal
        ..isCompletionVibrationEnabled = true;

      await controller.playCompletionFeedback();

      expect(
        calls,
        contains(
          isA<MethodCall>()
              .having((call) => call.method, 'method', 'HapticFeedback.vibrate')
              .having(
                (call) => call.arguments,
                'arguments',
                'HapticFeedbackType.mediumImpact',
              ),
        ),
      );
      expect(
        calls.where((call) => call.method == 'SystemSound.play'),
        isEmpty,
      );

      calls.clear();
      controller.isCompletionVibrationEnabled = false;
      await controller.playCompletionFeedback();

      expect(calls, isEmpty);
    });

    test('adds and clears in-app notifications', () async {
      final controller = AppSettingsController();

      await controller.sendTestNotification(playFeedback: false);

      expect(controller.notifications.value, hasLength(1));
      expect(
        controller.notifications.value.first.title,
        'Tarea programada',
      );
      expect(
        controller.notifications.value.first.routePath,
        '/tasks',
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

      final reportFile = await controller.downloadStatisticsPdf(
        const StatisticsReportRequest(period: StatisticsReportPeriod.day),
        StatisticsReportData(
          range: const StatisticsReportRequest(
            period: StatisticsReportPeriod.day,
          ).resolve(DateTime(2026, 7, 21, 10, 30)),
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

      final pdfFiles = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.pdf'))
          .toList(growable: false);
      expect(pdfFiles, hasLength(1));

      final pdf = pdfFiles.single;
      final content = latin1.decode(await pdf.readAsBytes());

      expect(
        pdf.path,
        contains('michifocus-day-20260721-103000-'),
      );
      expect(content, contains('Ana Cliente'));
      expect(content, contains('ana@example.com'));
      expect(content, contains('Generado: 2026-07-21 10:30'));
      expect(content, contains('/MediaBox [0 0 612 792]'));
      expect(content, contains(StatisticsChartType.circular.label));
      expect(content, isNot(contains(StatisticsChartType.groupedBars.label)));
      expect(
        File(controller.lastReportPath.value).resolveSymbolicLinksSync(),
        pdf.resolveSymbolicLinksSync(),
      );
      expect(
        File(reportFile.displayPath).resolveSymbolicLinksSync(),
        pdf.resolveSymbolicLinksSync(),
      );
      expect(
        File(reportFile.openReference).resolveSymbolicLinksSync(),
        pdf.resolveSymbolicLinksSync(),
      );
    });

    test('statistics PDF exports do not overwrite each other', () async {
      final directory = await Directory.systemTemp.createTemp(
        'michifocus-report-unique-test-',
      );
      final controller = AppSettingsController()
        ..setReportsDirectoryPath(directory.path);
      const request = StatisticsReportRequest(
        period: StatisticsReportPeriod.day,
      );

      addTearDown(() async {
        if (directory.existsSync()) {
          await directory.delete(recursive: true);
        }
      });

      final firstData = StatisticsReportData(
        range: request.resolve(DateTime(2026, 7, 21, 10, 30)),
        tasks: const StatisticsTaskTotals(
          listed: 1,
          inProgress: 0,
          completed: 1,
        ),
        calendarDays: const [],
        completedPomodoros: 1,
        focusedSeconds: 1500,
      );
      final secondData = StatisticsReportData(
        range: request.resolve(
          DateTime(2026, 7, 21, 10, 30, 0, 1),
        ),
        tasks: const StatisticsTaskTotals(
          listed: 1,
          inProgress: 0,
          completed: 1,
        ),
        calendarDays: const [],
        completedPomodoros: 1,
        focusedSeconds: 1500,
      );

      await controller.downloadStatisticsPdf(request, firstData);
      final firstPath = controller.lastReportPath.value;
      await controller.downloadStatisticsPdf(request, secondData);
      final secondPath = controller.lastReportPath.value;

      final pdfFiles = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.pdf'))
          .toList(growable: false);

      expect(pdfFiles, hasLength(2));
      expect(firstPath, isNot(secondPath));
      expect(File(firstPath).existsSync(), isTrue);
      expect(File(secondPath).existsSync(), isTrue);
    });

    test('failed PDF writes preserve the last successful path', () async {
      final controller = AppSettingsController(
        statisticsReportFileWriter: _FailingStatisticsReportFileWriter(),
      );
      controller.lastReportPath.value = 'previous-report.pdf';
      const request = StatisticsReportRequest(
        period: StatisticsReportPeriod.day,
      );
      final data = StatisticsReportData(
        range: request.resolve(DateTime(2026, 7, 21, 10, 30)),
        tasks: const StatisticsTaskTotals(
          listed: 0,
          inProgress: 0,
          completed: 0,
        ),
        calendarDays: const [],
        completedPomodoros: 0,
        focusedSeconds: 0,
      );

      await expectLater(
        controller.downloadStatisticsPdf(request, data),
        throwsA(isA<FileSystemException>()),
      );
      expect(controller.lastReportPath.value, 'previous-report.pdf');
    });

    test('exports the unified database backup format', () async {
      final appDirectory = await Directory.systemTemp.createTemp(
        'michifocus-app-docs-',
      );
      final reportsDirectory = await Directory.systemTemp.createTemp(
        'michifocus-reports-',
      );
      final controller = AppSettingsController(
        documentsDirectory: appDirectory,
      )..setReportsDirectoryPath(reportsDirectory.path);

      addTearDown(() async {
        if (appDirectory.existsSync()) {
          await appDirectory.delete(recursive: true);
        }
        if (reportsDirectory.existsSync()) {
          await reportsDirectory.delete(recursive: true);
        }
      });

      await File(
        '${appDirectory.path}/michidoro-settings.json',
      ).writeAsString('{"profileName":"Backup"}');
      await _createUnifiedDatabase(
        File('${appDirectory.path}/michifocus.sqlite'),
      );
      await File(
        '${appDirectory.path}/michifocus_tasks.sqlite',
      ).writeAsString('legacy-task-db');

      final sourceDatabase = MichiFocusDatabase(
        NativeDatabase(File('${appDirectory.path}/michifocus.sqlite')),
      );
      final exportedPath = await controller.exportDatabaseBackup(
        createDatabaseSnapshot: sourceDatabase.createBackupSnapshot,
      );
      await sourceDatabase.close();
      final backupDirectory = Directory(exportedPath);

      expect(
        File('${backupDirectory.path}/michidoro-settings.json').existsSync(),
        isFalse,
      );
      expect(
        File('${backupDirectory.path}/michifocus.sqlite').existsSync(),
        isTrue,
      );
      expect(
        File('${backupDirectory.path}/michifocus_tasks.sqlite').existsSync(),
        isFalse,
      );
    });

    test(
      'round trips routines, snapshots, mood, and paused runtime context',
      () async {
        final appDirectory = await Directory.systemTemp.createTemp(
          'michifocus-round-trip-app-',
        );
        final reportsDirectory = await Directory.systemTemp.createTemp(
          'michifocus-round-trip-reports-',
        );
        final liveFile = File('${appDirectory.path}/michifocus.sqlite');
        final controller = AppSettingsController(
          documentsDirectory: appDirectory,
        )..setReportsDirectoryPath(reportsDirectory.path);

        addTearDown(() async {
          if (appDirectory.existsSync()) {
            await appDirectory.delete(recursive: true);
          }
          if (reportsDirectory.existsSync()) {
            await reportsDirectory.delete(recursive: true);
          }
        });

        await _createCompleteUnifiedDatabase(liveFile);
        final sourceDatabase = MichiFocusDatabase(NativeDatabase(liveFile));
        final exportedPath = await controller.exportDatabaseBackup(
          createDatabaseSnapshot: sourceDatabase.createBackupSnapshot,
        );
        await sourceDatabase.close();

        await liveFile.delete();
        await _createUnifiedDatabase(liveFile, goalTitle: 'Replaced goal');
        await controller.stageDatabaseBackupImport(exportedPath);
        expect(await controller.applyPendingDatabaseImport(), isTrue);

        final imported = MichiFocusDatabase(NativeDatabase(liveFile));
        try {
          final routines = await imported.select(imported.routineRecords).get();
          final days = await imported.select(imported.routineDayRecords).get();
          final items = await imported.select(imported.routineItemRecords).get()
            ..sort((left, right) => left.position.compareTo(right.position));
          final runs = await imported.select(imported.routineRunRecords).get();
          final itemRuns =
              await imported.select(imported.routineItemRunRecords).get()
                ..sort(
                  (left, right) => left.positionSnapshot.compareTo(
                    right.positionSnapshot,
                  ),
                );
          final task = await TasksDao(imported).findById('routine-task');
          final session = await PomodoroSessionsDao(
            imported,
          ).findById('routine-session');
          final runtime = await PomodoroRuntimeDao(imported).loadActive();
          final completionEvents = await imported
              .select(imported.taskCompletionEventRecords)
              .get();
          final reportingMetadata = await imported
              .select(imported.reportingMetadataRecords)
              .get();
          final calendarEvents = await imported
              .select(imported.calendarEventRecords)
              .get();

          expect(
            routines.map((routine) => [routine.id, routine.status]),
            containsAll([
              ['routine-active', 'active'],
              ['routine-archived', 'archived'],
            ]),
          );
          expect(
            routines
                .singleWhere((routine) => routine.id == 'routine-archived')
                .archivedAt,
            DateTime(2026, 8, 8, 20),
          );
          expect(days.map((day) => day.weekday).toSet(), {1, 3, 5});
          expect(
            items.map(
              (item) => [
                item.position,
                item.title,
                item.scheduledMinute,
                item.reminderMinutesBefore,
              ],
            ),
            [
              [0, 'Deep work', 540, 15],
              [1, 'Review', 600, 5],
            ],
          );
          expect(runs.single.nameSnapshot, 'Morning snapshot');
          expect(runs.single.scheduledStartMinuteSnapshot, 540);
          expect(
            itemRuns.map(
              (item) => [
                item.sourceItemId,
                item.positionSnapshot,
                item.titleSnapshot,
                item.reminderMinutesSnapshot,
                item.pomodoroModeSnapshot,
              ],
            ),
            [
              ['routine-item-1', 0, 'Deep work snapshot', 15, 'custom'],
              ['routine-item-2', 1, 'Review snapshot', 5, 'recommended'],
            ],
          );
          expect(itemRuns.first.taskId, 'routine-task');
          expect(itemRuns.first.taskIdSnapshot, 'routine-task');
          expect(task?.status, 'inProgress');
          expect(task?.durationMinutes, 90);
          expect(session?.taskId, 'routine-task');
          expect(session?.startMoodScore, 2);
          expect(session?.endMoodScore, 4);
          expect(session?.moodPromptPending, isTrue);
          expect(runtime?.isRunning, isFalse);
          expect(runtime?.taskId, 'routine-task');
          expect(runtime?.taskTitle, 'Deep work');
          expect(runtime?.remainingSeconds, 901);
          expect(runtime?.blockIndex, 2);
          expect(runtime?.blockCount, 4);
          expect(runtime?.taskFocusedSecondsAtStart, 1500);
          expect(runtime?.focusStartedAt, DateTime(2026, 8, 9, 9, 5));
          expect(runtime?.lastTickAt, isNull);
          expect(completionEvents.single.taskIdSnapshot, 'routine-task');
          expect(reportingMetadata.single.id, 'completion-history');
          expect(calendarEvents.single.title, 'Routine review');
        } finally {
          await imported.close();
        }
      },
    );

    test(
      'stages four legacy databases into one database without routines',
      () async {
        final appDirectory = await Directory.systemTemp.createTemp(
          'michifocus-legacy-import-app-',
        );
        final backupDirectory = await Directory.systemTemp.createTemp(
          'michifocus-four-file-backup-',
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

        await _createLegacyFourFileBackup(backupDirectory);
        await controller.stageDatabaseBackupImport(backupDirectory.path);
        expect(await controller.applyPendingDatabaseImport(), isTrue);

        final imported = MichiFocusDatabase(
          NativeDatabase(File('${appDirectory.path}/michifocus.sqlite')),
        );
        try {
          expect(
            (await GoalsDao(imported).getAllGoals()).single.title,
            'Legacy goal',
          );
          expect(
            (await TasksDao(imported).getAllTasks()).single.title,
            'Legacy task',
          );
          expect(
            (await PomodoroSessionsDao(
              imported,
            ).getAllSessions()).single.endMoodScore,
            5,
          );
          expect(
            (await CalendarEventsDao(imported).getAllEvents()).single.title,
            'Legacy event',
          );
          expect(await imported.select(imported.routineRecords).get(), isEmpty);
          expect(
            await imported.select(imported.routineDayRecords).get(),
            isEmpty,
          );
          expect(
            await imported.select(imported.routineItemRecords).get(),
            isEmpty,
          );
          expect(
            await imported.select(imported.routineRunRecords).get(),
            isEmpty,
          );
          expect(
            await imported.select(imported.routineItemRunRecords).get(),
            isEmpty,
          );
        } finally {
          await imported.close();
        }
      },
    );

    test('rejects an incomplete legacy backup before staging', () async {
      final appDirectory = await Directory.systemTemp.createTemp(
        'michifocus-incomplete-legacy-app-',
      );
      final backupDirectory = await Directory.systemTemp.createTemp(
        'michifocus-incomplete-legacy-backup-',
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
        '${backupDirectory.path}/michifocus_tasks.sqlite',
      ).writeAsString('partial');

      await expectLater(
        controller.stageDatabaseBackupImport(backupDirectory.path),
        throwsA(isA<FileSystemException>()),
      );
      expect(
        Directory(
          '${appDirectory.path}/michifocus-pending-import',
        ).existsSync(),
        isFalse,
      );
    });

    test('rejects four empty legacy SQLite files', () async {
      final appDirectory = await Directory.systemTemp.createTemp(
        'michifocus-empty-legacy-app-',
      );
      final backupDirectory = await Directory.systemTemp.createTemp(
        'michifocus-empty-legacy-backup-',
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
      for (final name in const [
        'michifocus_goals.sqlite',
        'michifocus_tasks.sqlite',
        'michifocus_pomodoro_sessions.sqlite',
        'michifocus_calendar_events.sqlite',
      ]) {
        sqlite3.open('${backupDirectory.path}/$name').dispose();
      }

      await expectLater(
        controller.stageDatabaseBackupImport(backupDirectory.path),
        throwsA(isA<FileSystemException>()),
      );
      expect(
        Directory(
          '${appDirectory.path}/michifocus-pending-import',
        ).existsSync(),
        isFalse,
      );
    });

    test(
      'restores the previous database after interrupted replacement',
      () async {
        final appDirectory = await Directory.systemTemp.createTemp(
          'michifocus-interrupted-import-',
        );
        final controller = AppSettingsController(
          documentsDirectory: appDirectory,
        );
        final previousFile = File(
          '${appDirectory.path}/.michifocus-before-import.sqlite',
        );

        addTearDown(() async {
          if (appDirectory.existsSync()) {
            await appDirectory.delete(recursive: true);
          }
        });

        await _createUnifiedDatabase(
          previousFile,
          goalTitle: 'Recovered goal',
        );
        await File(
          '${appDirectory.path}/.michifocus-import.sqlite',
        ).writeAsString('interrupted candidate');

        expect(await controller.applyPendingDatabaseImport(), isFalse);
        expect(
          await _loadGoalTitles(
            File('${appDirectory.path}/michifocus.sqlite'),
          ),
          ['Recovered goal'],
        );
        expect(previousFile.existsSync(), isFalse);
        expect(
          File('${appDirectory.path}/.michifocus-import.sqlite').existsSync(),
          isFalse,
        );
      },
    );

    test('discards interrupted staging and keeps the live database', () async {
      final appDirectory = await Directory.systemTemp.createTemp(
        'michifocus-interrupted-staging-',
      );
      final controller = AppSettingsController(
        documentsDirectory: appDirectory,
      );
      final liveFile = File('${appDirectory.path}/michifocus.sqlite');
      final stagingDirectory = Directory(
        '${appDirectory.path}/michifocus-staging-import',
      )..createSync();
      await _createUnifiedDatabase(liveFile, goalTitle: 'Live goal');
      await File(
        '${stagingDirectory.path}/michifocus.sqlite',
      ).writeAsString('partial staging copy');
      addTearDown(() async {
        if (appDirectory.existsSync()) {
          await appDirectory.delete(recursive: true);
        }
      });

      expect(await controller.applyPendingDatabaseImport(), isFalse);
      expect(await _loadGoalTitles(liveFile), ['Live goal']);
      expect(stagingDirectory.existsSync(), isFalse);
    });

    test('stages and applies unified database backup import', () async {
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
      await _createUnifiedDatabase(
        File('${backupDirectory.path}/michifocus.sqlite'),
      );

      await controller.stageDatabaseBackupImport(backupDirectory.path);

      expect(
        File(
          '${appDirectory.path}/michifocus-pending-import/michifocus.sqlite',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${appDirectory.path}/michifocus-pending-import/michidoro-settings.json',
        ).existsSync(),
        isFalse,
      );

      final applied = await controller.applyPendingDatabaseImport();

      expect(applied, isTrue);
      expect(
        await _loadGoalTitles(File('${appDirectory.path}/michifocus.sqlite')),
        ['Backup goal'],
      );
      expect(
        Directory(
          '${appDirectory.path}/michifocus-pending-import',
        ).existsSync(),
        isFalse,
      );
    });

    test('rejects invalid unified database backup files', () async {
      final appDirectory = await Directory.systemTemp.createTemp(
        'michifocus-app-docs-',
      );
      final backupDirectory = await Directory.systemTemp.createTemp(
        'michifocus-invalid-backup-',
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
        '${backupDirectory.path}/michifocus.sqlite',
      ).writeAsString('not-sqlite');

      await expectLater(
        controller.stageDatabaseBackupImport(backupDirectory.path),
        throwsA(isA<FileSystemException>()),
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
          completionVibrationPattern: PomodoroVibrationPattern.double,
          autoStartBreak: false,
          autoStartFocus: true,
          reportsDirectoryPath: r' C:\Reports ',
          profileName: ' Chris Dev ',
          profileEmail: ' chris@example.com ',
          profileImagePath: r' C:\Pictures\me.png ',
          avatarIndex: 2,
          themePreset: AppThemePreset.graphiteNight,
          isDarkMode: true,
          fontScale: 1.2,
          typographyPreset: AppTypographyPreset.serio,
          language: AppLanguage.english,
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
      expect(
        controller.completionVibrationPattern.value,
        PomodoroVibrationPattern.double,
      );
      expect(controller.autoStartBreak.value, isFalse);
      expect(controller.autoStartFocus.value, isTrue);
      expect(controller.reportsDirectoryPath.value, r'C:\Reports');
      expect(controller.profileName.value, 'Chris Dev');
      expect(controller.profileEmail.value, 'chris@example.com');
      expect(controller.profileImagePath.value, r'C:\Pictures\me.png');
      expect(controller.avatarIndex.value, 2);
      expect(controller.themePreset.value, AppThemePreset.graphiteNight);
      expect(controller.isDarkMode.value, isTrue);
      expect(controller.fontScale.value, 1.2);
      expect(controller.typographyPreset.value, AppTypographyPreset.serio);
      expect(controller.language.value, AppLanguage.english);
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
        ..selectedCompletionVibrationPattern = PomodoroVibrationPattern.intense
        ..setReportsDirectoryPath(r' C:\Downloads\MichiFocus ')
        ..setProfileName(' Ana ')
        ..setProfileEmail(' ana@example.com ')
        ..setProfileImagePath(r' C:\Pictures\ana.png ')
        ..setAvatarIndex(9)
        ..themePreset.value = AppThemePreset.sunshineAurora
        ..isDarkMode.value = true
        ..fontScale.value = 2
        ..selectedTypographyPreset = AppTypographyPreset.normal
        ..language.value = AppLanguage.english
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
        repository.saved?.completionVibrationPattern,
        PomodoroVibrationPattern.intense,
      );
      expect(
        repository.saved?.reportsDirectoryPath,
        r'C:\Downloads\MichiFocus',
      );
      expect(repository.saved?.profileName, 'Ana');
      expect(repository.saved?.profileEmail, 'ana@example.com');
      expect(repository.saved?.profileImagePath, r'C:\Pictures\ana.png');
      expect(repository.saved?.avatarIndex, 3);
      expect(repository.saved?.themePreset, AppThemePreset.sunshineAurora);
      expect(repository.saved?.isDarkMode, isTrue);
      expect(repository.saved?.fontScale, AppTypography.maxFontScale);
      expect(repository.saved?.typographyPreset, AppTypographyPreset.normal);
      expect(repository.saved?.language, AppLanguage.english);
      expect(
        repository.saved?.enabledStatisticsCharts,
        isNot(contains(StatisticsChartType.groupedBars)),
      );
    });

    test(
      'loads normal vibration from settings files without a pattern',
      () async {
        final directory = await Directory.systemTemp.createTemp(
          'michidoro-legacy-vibration-settings-',
        );
        final channel = _mockPathProviderDocumentsDirectory(directory.path);
        addTearDown(() async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
          if (directory.existsSync()) {
            await directory.delete(recursive: true);
          }
        });
        await File(
          '${directory.path}/michidoro-settings.json',
        ).writeAsString(jsonEncode({'completionVibrationEnabled': true}));

        final preferences = await const FileSettingsRepository()
            .loadTimerPreferences();

        expect(
          preferences.completionVibrationPattern,
          PomodoroVibrationPattern.normal,
        );
      },
    );

    test(
      'persists and restores the selected vibration pattern in JSON',
      () async {
        final directory = await Directory.systemTemp.createTemp(
          'michidoro-vibration-settings-',
        );
        final channel = _mockPathProviderDocumentsDirectory(directory.path);
        addTearDown(() async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
          if (directory.existsSync()) {
            await directory.delete(recursive: true);
          }
        });
        const selectedPattern = PomodoroVibrationPattern.double;
        final controller = AppSettingsController()
          ..selectedCompletionVibrationPattern = selectedPattern;
        const repository = FileSettingsRepository();

        await repository.saveTimerPreferences(controller.timerPreferences);

        final settingsFile = File(
          '${directory.path}/michidoro-settings.json',
        );
        final json = jsonDecode(await settingsFile.readAsString());
        expect(json, isA<Map<String, dynamic>>());
        expect(
          (json as Map<String, dynamic>)['completionVibrationPattern'],
          selectedPattern.name,
        );
        expect(
          (await repository.loadTimerPreferences()).completionVibrationPattern,
          selectedPattern,
        );
      },
    );
  });
}

MethodChannel _mockPathProviderDocumentsDirectory(String path) {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getApplicationDocumentsDirectory') {
          return path;
        }
        return null;
      });
  return channel;
}

Future<void> _createUnifiedDatabase(
  File file, {
  String goalTitle = 'Backup goal',
}) async {
  final database = MichiFocusDatabase(NativeDatabase(file));
  try {
    final now = DateTime(2026, 7, 22, 9);
    await database
        .into(database.goalRecords)
        .insert(
          GoalRecordsCompanion.insert(
            id: 'goal-backup',
            title: goalTitle,
            targetSessions: 1,
            createdAt: now,
            updatedAt: now,
          ),
        );
  } finally {
    await database.close();
  }
}

Future<void> _createCompleteUnifiedDatabase(File file) async {
  final database = MichiFocusDatabase(NativeDatabase(file));
  final now = DateTime(2026, 8, 9, 9);
  try {
    await database.transaction(() async {
      await database
          .into(database.goalRecords)
          .insert(
            GoalRecordsCompanion.insert(
              id: 'routine-goal',
              title: 'Routine goal',
              targetSessions: 8,
              completedSessions: const Value(3),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.taskRecords)
          .insert(
            TaskRecordsCompanion.insert(
              id: 'routine-task',
              title: 'Deep work',
              status: const Value('inProgress'),
              scheduledDate: Value(DateTime(2026, 8, 9, 9)),
              goalId: const Value('routine-goal'),
              durationMinutes: const Value(90),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.taskCompletionEventRecords)
          .insert(
            TaskCompletionEventRecordsCompanion.insert(
              id: 'routine-completion',
              taskId: const Value('routine-task'),
              taskIdSnapshot: 'routine-task',
              completedAt: DateTime(2026, 8, 8, 18),
              scheduledDateSnapshot: Value(DateTime(2026, 8, 8)),
            ),
          );
      await database
          .into(database.reportingMetadataRecords)
          .insert(
            ReportingMetadataRecordsCompanion.insert(
              id: 'completion-history',
              completionTrackingStartedAt: DateTime(2026, 7),
            ),
          );
      await database
          .into(database.calendarEventRecords)
          .insert(
            CalendarEventRecordsCompanion.insert(
              id: 'routine-calendar-event',
              title: 'Routine review',
              scheduledAt: DateTime(2026, 8, 9, 11),
              durationMinutes: 30,
              createdAt: now,
            ),
          );
      await database
          .into(database.routineRecords)
          .insert(
            RoutineRecordsCompanion.insert(
              id: 'routine-active',
              name: 'Morning routine',
              description: const Value('Preserve every routine field'),
              iconKey: const Value('sunrise'),
              colorKey: const Value('amber'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.routineRecords)
          .insert(
            RoutineRecordsCompanion.insert(
              id: 'routine-archived',
              name: 'Archived routine',
              status: const Value('archived'),
              archivedAt: Value(DateTime(2026, 8, 8, 20)),
              createdAt: DateTime(2026, 8),
              updatedAt: DateTime(2026, 8, 8, 20),
            ),
          );
      for (final weekday in const [1, 3, 5]) {
        await database
            .into(database.routineDayRecords)
            .insert(
              RoutineDayRecordsCompanion.insert(
                routineId: 'routine-active',
                weekday: weekday,
              ),
            );
      }
      await database
          .into(database.routineItemRecords)
          .insert(
            RoutineItemRecordsCompanion.insert(
              id: 'routine-item-2',
              routineId: 'routine-active',
              position: 1,
              title: 'Review',
              scheduledMinute: 600,
              durationMinutes: 30,
              isOptional: const Value(true),
              reminderMinutesBefore: const Value(5),
              pomodoroMode: const Value('recommended'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.routineItemRecords)
          .insert(
            RoutineItemRecordsCompanion.insert(
              id: 'routine-item-1',
              routineId: 'routine-active',
              position: 0,
              title: 'Deep work',
              scheduledMinute: 540,
              durationMinutes: 90,
              goalId: const Value('routine-goal'),
              reminderMinutesBefore: const Value(15),
              pomodoroMode: const Value('custom'),
              customFocusMinutes: const Value(30),
              customBreakMinutes: const Value(5),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.routineRunRecords)
          .insert(
            RoutineRunRecordsCompanion.insert(
              id: 'routine-run',
              routineId: const Value('routine-active'),
              sourceRoutineId: 'routine-active',
              localDate: '2026-08-09',
              status: const Value('inProgress'),
              nameSnapshot: 'Morning snapshot',
              iconKeySnapshot: 'sunrise',
              colorKeySnapshot: 'amber',
              scheduledStartMinuteSnapshot: 540,
              startedAt: Value(DateTime(2026, 8, 9, 9, 5)),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.routineItemRunRecords)
          .insert(
            RoutineItemRunRecordsCompanion.insert(
              id: 'routine-item-run-1',
              routineRunId: 'routine-run',
              routineItemId: const Value('routine-item-1'),
              sourceItemId: 'routine-item-1',
              taskId: const Value('routine-task'),
              taskIdSnapshot: const Value('routine-task'),
              positionSnapshot: 0,
              titleSnapshot: 'Deep work snapshot',
              scheduledAtSnapshot: DateTime(2026, 8, 9, 9),
              durationMinutesSnapshot: 90,
              goalTitleSnapshot: const Value('Routine goal'),
              reminderMinutesSnapshot: const Value(15),
              pomodoroModeSnapshot: 'custom',
              customFocusMinutesSnapshot: const Value(30),
              customBreakMinutesSnapshot: const Value(5),
              status: const Value('inProgress'),
              startedAt: Value(DateTime(2026, 8, 9, 9, 5)),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.routineItemRunRecords)
          .insert(
            RoutineItemRunRecordsCompanion.insert(
              id: 'routine-item-run-2',
              routineRunId: 'routine-run',
              routineItemId: const Value('routine-item-2'),
              sourceItemId: 'routine-item-2',
              positionSnapshot: 1,
              titleSnapshot: 'Review snapshot',
              scheduledAtSnapshot: DateTime(2026, 8, 9, 10),
              durationMinutesSnapshot: 30,
              isOptionalSnapshot: const Value(true),
              reminderMinutesSnapshot: const Value(5),
              pomodoroModeSnapshot: 'recommended',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.pomodoroSessionRecords)
          .insert(
            PomodoroSessionRecordsCompanion.insert(
              id: 'routine-session',
              startedAt: DateTime(2026, 8, 9, 9, 5),
              endedAt: DateTime(2026, 8, 9, 9, 30),
              plannedSeconds: 1800,
              focusedSeconds: 1500,
              goalId: const Value('routine-goal'),
              taskId: const Value('routine-task'),
              startMoodScore: const Value(2),
              endMoodScore: const Value(4),
              moodPromptPending: const Value(true),
              wasDistracted: const Value(true),
              distractionMinutes: const Value(3),
              status: 'completed',
              createdAt: now,
            ),
          );
      await database
          .into(database.pomodoroRuntimeRecords)
          .insert(
            PomodoroRuntimeRecordsCompanion.insert(
              id: 'active-runtime',
              taskId: const Value('routine-task'),
              taskTitle: const Value('Deep work'),
              goalId: const Value('routine-goal'),
              taskEstimatedMinutes: const Value(90),
              phase: 'focus',
              isRunning: true,
              remainingSeconds: 901,
              phaseTotalSeconds: 1800,
              cadenceFocusMinutes: 30,
              cadenceBreakMinutes: 5,
              longBreakMinutes: 15,
              longBreakFrequency: 4,
              autoStartBreak: true,
              autoStartFocus: true,
              planMode: 'continuous',
              blockIndex: 2,
              blockCount: 4,
              taskFocusedSecondsAtStart: 1500,
              focusStartedAt: Value(DateTime(2026, 8, 9, 9, 5)),
              lastTickAt: Value(DateTime(2026, 8, 9, 9, 30)),
              createdAt: now,
              updatedAt: now,
            ),
          );
    });
  } finally {
    await database.close();
  }
}

Future<void> _createLegacyFourFileBackup(Directory directory) async {
  final now = DateTime(2026, 8, 1, 8);
  final goals = legacy_goals.GoalsDatabase(
    NativeDatabase(File('${directory.path}/michifocus_goals.sqlite')),
  );
  try {
    await legacy_goals.GoalsDao(goals).insertGoal(
      legacy_goals.GoalRecordsCompanion.insert(
        id: 'legacy-goal',
        title: 'Legacy goal',
        targetSessions: 4,
        createdAt: now,
        updatedAt: now,
      ),
    );
  } finally {
    await goals.close();
  }

  final tasks = legacy_tasks.TasksDatabase(
    NativeDatabase(File('${directory.path}/michifocus_tasks.sqlite')),
  );
  try {
    await legacy_tasks.TasksDao(tasks).insertTask(
      legacy_tasks.TaskRecordsCompanion.insert(
        id: 'legacy-task',
        title: 'Legacy task',
        status: const Value('inProgress'),
        goalId: const Value('legacy-goal'),
        durationMinutes: const Value(45),
        createdAt: now,
        updatedAt: now,
      ),
    );
  } finally {
    await tasks.close();
  }

  final sessions = legacy_pomodoro.PomodoroSessionsDatabase(
    NativeDatabase(
      File('${directory.path}/michifocus_pomodoro_sessions.sqlite'),
    ),
  );
  try {
    await legacy_pomodoro.PomodoroSessionsDao(sessions).insertSession(
      legacy_pomodoro.PomodoroSessionRecordsCompanion.insert(
        id: 'legacy-session',
        startedAt: now,
        endedAt: now.add(const Duration(minutes: 25)),
        plannedSeconds: 1500,
        focusedSeconds: 1400,
        goalId: const Value('legacy-goal'),
        taskId: const Value('legacy-task'),
        startMoodScore: const Value(3),
        endMoodScore: const Value(5),
        status: 'completed',
        createdAt: now,
      ),
    );
  } finally {
    await sessions.close();
  }

  final events = legacy_calendar.CalendarEventsDatabase(
    NativeDatabase(
      File('${directory.path}/michifocus_calendar_events.sqlite'),
    ),
  );
  try {
    await legacy_calendar.CalendarEventsDao(events).insertEvent(
      legacy_calendar.CalendarEventRecordsCompanion.insert(
        id: 'legacy-event',
        title: 'Legacy event',
        scheduledAt: now.add(const Duration(hours: 2)),
        durationMinutes: 30,
        createdAt: now,
      ),
    );
  } finally {
    await events.close();
  }
}

Future<List<String>> _loadGoalTitles(File file) async {
  final database = MichiFocusDatabase(NativeDatabase(file));
  try {
    final goals = await GoalsDao(database).getAllGoals();
    return goals.map((goal) => goal.title).toList(growable: false);
  } finally {
    await database.close();
  }
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

class _FailingStatisticsReportFileWriter implements StatisticsReportFileWriter {
  @override
  Future<StatisticsReportFile> write({
    required List<int> bytes,
    required StatisticsReportRequest request,
    required DateTime generatedAt,
    required String configuredDestination,
  }) {
    throw const FileSystemException('No se pudo escribir el reporte.');
  }
}
