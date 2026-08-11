import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/features/settings/data/repositories/file_settings_repository.dart';
import 'package:pomodoro_app_v1/features/settings/domain/entities/timer_preferences.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('V8-M0 onboarding state', () {
    test('uses version one and shows onboarding before completion', () {
      final controller = AppSettingsController();

      expect(AppSettingsController.currentOnboardingVersion, 1);
      expect(controller.completedOnboardingVersion.value, 0);
      expect(controller.shouldShowOnboarding, isTrue);
    });

    test('loads the completed version from preferences', () async {
      final repository = _MemorySettingsRepository(
        const TimerPreferences.defaults(
          completedOnboardingVersion:
              AppSettingsController.currentOnboardingVersion,
        ),
      );
      final controller = AppSettingsController();

      await controller.loadTimerPreferences(repository);

      expect(
        controller.completedOnboardingVersion.value,
        AppSettingsController.currentOnboardingVersion,
      );
      expect(controller.shouldShowOnboarding, isFalse);
    });

    test('does not replay an older onboarding for a future marker', () async {
      final repository = _MemorySettingsRepository(
        const TimerPreferences.defaults(completedOnboardingVersion: 2),
      );
      final controller = AppSettingsController();

      await controller.loadTimerPreferences(repository);

      expect(controller.completedOnboardingVersion.value, 2);
      expect(controller.shouldShowOnboarding, isFalse);
    });

    test('completion persists the current onboarding version', () async {
      final repository = _MemorySettingsRepository(
        const TimerPreferences.defaults(),
      );
      final controller = AppSettingsController();
      await controller.loadTimerPreferences(repository);

      await controller.completeOnboarding();

      expect(
        controller.completedOnboardingVersion.value,
        AppSettingsController.currentOnboardingVersion,
      );
      expect(controller.shouldShowOnboarding, isFalse);
      expect(
        repository.saved?.completedOnboardingVersion,
        AppSettingsController.currentOnboardingVersion,
      );
    });
  });

  group('V8-M0 onboarding settings JSON', () {
    test('a missing settings file represents a fresh installation', () async {
      await _withSettingsDirectory((directory, repository) async {
        final preferences = await repository.loadTimerPreferences();

        expect(preferences.completedOnboardingVersion, 0);
        expect(
          File('${directory.path}/michidoro-settings.json').existsSync(),
          isFalse,
        );
      });
    });

    test('an existing legacy file is treated as already onboarded', () async {
      await _withSettingsDirectory((directory, repository) async {
        await _writeSettingsJson(directory, {'focusMinutes': 40});

        final preferences = await repository.loadTimerPreferences();

        expect(
          preferences.completedOnboardingVersion,
          AppSettingsController.currentOnboardingVersion,
        );
      });
    });

    test('an invalid legacy marker is treated as already onboarded', () async {
      await _withSettingsDirectory((directory, repository) async {
        await _writeSettingsJson(directory, {
          'completedOnboardingVersion': 'invalid',
        });

        final preferences = await repository.loadTimerPreferences();

        expect(
          preferences.completedOnboardingVersion,
          AppSettingsController.currentOnboardingVersion,
        );
      });
    });

    test('completion survives a JSON save and reload roundtrip', () async {
      await _withSettingsDirectory((directory, repository) async {
        final controller = AppSettingsController();
        await controller.loadTimerPreferences(repository);

        await controller.completeOnboarding();

        final settingsFile = File(
          '${directory.path}/michidoro-settings.json',
        );
        final decoded = jsonDecode(await settingsFile.readAsString());
        expect(decoded, isA<Map<String, dynamic>>());
        expect(
          (decoded as Map<String, dynamic>)['completedOnboardingVersion'],
          AppSettingsController.currentOnboardingVersion,
        );

        final restored = await repository.loadTimerPreferences();
        expect(
          restored.completedOnboardingVersion,
          AppSettingsController.currentOnboardingVersion,
        );
      });
    });
  });
}

Future<void> _withSettingsDirectory(
  Future<void> Function(
    Directory directory,
    FileSettingsRepository repository,
  )
  body,
) async {
  final directory = await Directory.systemTemp.createTemp(
    'michidoro-onboarding-settings-',
  );
  final channel = _mockPathProviderDocumentsDirectory(directory.path);

  try {
    await body(directory, const FileSettingsRepository());
  } finally {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  }
}

Future<void> _writeSettingsJson(
  Directory directory,
  Map<String, Object?> json,
) {
  return File(
    '${directory.path}/michidoro-settings.json',
  ).writeAsString(jsonEncode(json));
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

class _MemorySettingsRepository implements SettingsRepository {
  _MemorySettingsRepository(this.preferences);

  TimerPreferences preferences;
  TimerPreferences? saved;

  @override
  Future<TimerPreferences> loadTimerPreferences() async => preferences;

  @override
  Future<void> saveTimerPreferences(TimerPreferences preferences) async {
    saved = preferences;
    this.preferences = preferences;
  }
}
