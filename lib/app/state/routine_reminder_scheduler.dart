import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';

class RoutineReminderCapability {
  const RoutineReminderCapability({
    required this.notificationPermissionGranted,
    required this.exactSchedulingAvailable,
  });

  factory RoutineReminderCapability.fromMap(Map<Object?, Object?> value) {
    return RoutineReminderCapability(
      notificationPermissionGranted:
          value['notificationPermissionGranted'] == true,
      exactSchedulingAvailable: value['exactSchedulingAvailable'] == true,
    );
  }

  final bool notificationPermissionGranted;
  final bool exactSchedulingAvailable;
}

class RoutineReminderPlatform {
  const RoutineReminderPlatform._();

  static const channel = MethodChannel('michifocus/routine_reminders');

  static Future<RoutineReminderCapability?> getCapability({
    bool Function()? isAndroid,
  }) async {
    if (!(isAndroid ?? RoutineReminderScheduler.platformIsAndroid)()) {
      return null;
    }
    final value = await channel.invokeMapMethod<Object?, Object?>(
      'getRoutineReminderStatus',
    );
    return value == null ? null : RoutineReminderCapability.fromMap(value);
  }

  static Future<void> openSystemSettings({bool Function()? isAndroid}) async {
    if (!(isAndroid ?? RoutineReminderScheduler.platformIsAndroid)()) return;
    await channel.invokeMethod<void>('openRoutineReminderSettings');
  }
}

class RoutineReminderScheduler {
  RoutineReminderScheduler({
    required RoutinesController routinesController,
    required AppSettingsController settingsController,
    this.horizonDays = 7,
    bool Function()? isAndroid,
  }) : _routinesController = routinesController,
       _settingsController = settingsController,
       _isAndroid = isAndroid ?? platformIsAndroid;

  final RoutinesController _routinesController;
  final AppSettingsController _settingsController;
  final bool Function() _isAndroid;
  final int horizonDays;

  Future<void> synchronize({DateTime? now}) async {
    if (!_isAndroid()) return;
    final current = now ?? DateTime.now();
    final reminders = _enabled
        ? projectReminders(current)
        : const <Map<String, Object>>[];
    await RoutineReminderPlatform.channel.invokeMethod<Object?>(
      'replaceRoutineReminders',
      {
        'reminders': reminders,
      },
    );
  }

  bool get _enabled =>
      _settingsController.notificationsEnabled.value &&
      _settingsController.focusAlertsEnabled.value;

  List<Map<String, Object>> projectReminders(DateTime now) {
    final result = <Map<String, Object>>[];
    final start = DateTime(now.year, now.month, now.day);
    for (final routine in _routinesController.routines.value) {
      if (routine.status != RoutineStatus.active) continue;
      for (var offset = 0; offset < horizonDays; offset++) {
        final day = start.add(Duration(days: offset));
        if (!routine.weekdays.contains(day.weekday)) continue;
        for (final item in routine.items) {
          final advance = item.reminderMinutesBefore;
          if (advance == null) continue;
          final scheduledAt = DateTime(
            day.year,
            day.month,
            day.day,
            item.scheduledMinute ~/ 60,
            item.scheduledMinute % 60,
          ).subtract(Duration(minutes: advance));
          if (!scheduledAt.isAfter(now)) continue;
          result.add({
            'id': '${item.id}:${_dateKey(day)}',
            'title': item.title,
            'body': 'Rutina: ${routine.name}',
            'scheduledAtMillis': scheduledAt.millisecondsSinceEpoch,
            'year': scheduledAt.year,
            'month': scheduledAt.month,
            'day': scheduledAt.day,
            'hour': scheduledAt.hour,
            'minute': scheduledAt.minute,
          });
        }
      }
    }
    return result;
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static bool platformIsAndroid() => Platform.isAndroid;
}
