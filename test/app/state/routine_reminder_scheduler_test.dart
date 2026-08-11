import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/routine_reminder_scheduler.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'projects a bounded window and ignores inactive or elapsed reminders',
    () {
      final now = DateTime(2026, 8, 10, 9); // Monday reminder already elapsed.
      final controller = RoutinesController(
        repository: _FakeRoutinesRepository(),
        now: () => now,
      );
      controller.routines.value = [
        _routine(now: now, status: RoutineStatus.active),
        _routine(now: now, id: 'paused', status: RoutineStatus.paused),
      ];
      final scheduler = RoutineReminderScheduler(
        routinesController: controller,
        settingsController: AppSettingsController(),
      );

      final reminders = scheduler.projectReminders(now);

      expect(reminders, hasLength(2));
      expect(
        reminders.map((item) => item['scheduledAtMillis']),
        [
          DateTime(2026, 8, 12, 8, 50).millisecondsSinceEpoch,
          DateTime(2026, 8, 14, 8, 50).millisecondsSinceEpoch,
        ],
      );
      expect(
        reminders.every(
          (item) => (item['id']! as String).startsWith('item-active:'),
        ),
        isTrue,
      );
      expect(scheduler.projectReminders(now), reminders);
      expect(
        reminders.map((item) => item['id']).toSet(),
        hasLength(reminders.length),
      );
    },
  );

  test(
    'synchronization replaces alarms and clears them when disabled',
    () async {
      const channel = MethodChannel('michifocus/routine_reminders');
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final now = DateTime(2026, 8, 10, 8);
      final settings = AppSettingsController();
      final controller =
          RoutinesController(
              repository: _FakeRoutinesRepository(),
              now: () => now,
            )
            ..routines.value = [
              _routine(now: now, status: RoutineStatus.active),
            ];
      final scheduler = RoutineReminderScheduler(
        routinesController: controller,
        settingsController: settings,
        isAndroid: () => true,
      );

      await scheduler.synchronize(now: now);
      settings.notificationsEnabled.value = false;
      await scheduler.synchronize(now: now);

      expect(calls, hasLength(2));
      expect(
        calls.every((call) => call.method == 'replaceRoutineReminders'),
        isTrue,
      );
      final scheduled = calls.first.arguments! as Map<Object?, Object?>;
      final cancelled = calls.last.arguments! as Map<Object?, Object?>;
      expect(scheduled['reminders']! as List<Object?>, isNotEmpty);
      expect(cancelled['reminders']! as List<Object?>, isEmpty);
    },
  );

  test(
    'repeated synchronization sends the same idempotent projection',
    () async {
      const channel = MethodChannel('michifocus/routine_reminders');
      final arguments = <Object?>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            arguments.add(call.arguments);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final now = DateTime(2026, 8, 10, 8);
      final controller =
          RoutinesController(
              repository: _FakeRoutinesRepository(),
              now: () => now,
            )
            ..routines.value = [
              _routine(now: now, status: RoutineStatus.active),
            ];
      final scheduler = RoutineReminderScheduler(
        routinesController: controller,
        settingsController: AppSettingsController(),
        isAndroid: () => true,
      );

      await scheduler.synchronize(now: now);
      await scheduler.synchronize(now: now);

      expect(arguments, hasLength(2));
      expect(arguments.first, arguments.last);
    },
  );

  test(
    'replacing imported routines cancels obsolete projected alarms',
    () async {
      const channel = MethodChannel('michifocus/routine_reminders');
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final now = DateTime(2026, 8, 10, 8);
      final controller =
          RoutinesController(
              repository: _FakeRoutinesRepository(),
              now: () => now,
            )
            ..routines.value = [
              _routine(now: now, status: RoutineStatus.active),
            ];
      final scheduler = RoutineReminderScheduler(
        routinesController: controller,
        settingsController: AppSettingsController(),
        isAndroid: () => true,
      );

      await scheduler.synchronize(now: now);
      controller.routines.value = const [];
      await scheduler.synchronize(now: now);

      final initial = calls.first.arguments! as Map<Object?, Object?>;
      final replacement = calls.last.arguments! as Map<Object?, Object?>;
      expect(initial['reminders']! as List<Object?>, isNotEmpty);
      expect(replacement['reminders']! as List<Object?>, isEmpty);
    },
  );

  test(
    'reports denied notification permission without hiding fallback',
    () async {
      const channel = MethodChannel('michifocus/routine_reminders');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'getRoutineReminderStatus');
            return <String, Object>{
              'notificationPermissionGranted': false,
              'exactSchedulingAvailable': false,
            };
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final capability = await RoutineReminderPlatform.getCapability(
        isAndroid: () => true,
      );

      expect(capability, isNotNull);
      expect(capability!.notificationPermissionGranted, isFalse);
      expect(capability.exactSchedulingAvailable, isFalse);
    },
  );

  test(
    'reports inexact delivery while notification permission remains usable',
    () async {
      const channel = MethodChannel('michifocus/routine_reminders');
      final calls = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call.method);
            if (call.method == 'getRoutineReminderStatus') {
              return <String, Object>{
                'notificationPermissionGranted': true,
                'exactSchedulingAvailable': false,
              };
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final capability = await RoutineReminderPlatform.getCapability(
        isAndroid: () => true,
      );
      await RoutineReminderPlatform.openSystemSettings(isAndroid: () => true);

      expect(capability, isNotNull);
      expect(capability!.notificationPermissionGranted, isTrue);
      expect(capability.exactSchedulingAvailable, isFalse);
      expect(calls, [
        'getRoutineReminderStatus',
        'openRoutineReminderSettings',
      ]);
    },
  );
}

Routine _routine({
  required DateTime now,
  required RoutineStatus status,
  String id = 'active',
}) {
  return Routine(
    id: id,
    name: 'Rutina $id',
    iconKey: 'sun',
    colorKey: 'primary',
    status: status,
    createdAt: now,
    updatedAt: now,
    weekdays: const [DateTime.monday, DateTime.wednesday, DateTime.friday],
    items: [
      RoutineItem(
        id: 'item-$id',
        routineId: id,
        position: 0,
        title: 'Actividad',
        scheduledMinute: 9 * 60,
        durationMinutes: 30,
        isOptional: false,
        reminderMinutesBefore: 10,
        pomodoroMode: RoutinePomodoroMode.none,
        createdAt: now,
        updatedAt: now,
      ),
    ],
  );
}

class _FakeRoutinesRepository extends Fake implements RoutinesRepository {}
