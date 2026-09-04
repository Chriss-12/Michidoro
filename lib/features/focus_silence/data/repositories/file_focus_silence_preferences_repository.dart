import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/entities/focus_silence_preferences.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/repositories/focus_silence_preferences_repository.dart';

class FileFocusSilencePreferencesRepository
    implements FocusSilencePreferencesRepository {
  const FileFocusSilencePreferencesRepository();

  static const _fileName = 'michifocus-focus-silence.json';

  @override
  Future<FocusSilencePreferences> load() async {
    final file = await _file();
    if (!file.existsSync()) return const FocusSilencePreferences();

    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return const FocusSilencePreferences();
      }
      final profileName = decoded['profile'];
      return FocusSilencePreferences(
        enableWithPomodoro: decoded['enableWithPomodoro'] == true,
        profile: FocusSilenceProfile.values.firstWhere(
          (profile) => profile.name == profileName,
          orElse: () => FocusSilenceProfile.alarmsOnly,
        ),
      );
    } on FormatException {
      return const FocusSilencePreferences();
    } on FileSystemException {
      return const FocusSilencePreferences();
    }
  }

  @override
  Future<void> save(FocusSilencePreferences preferences) async {
    final file = await _file();
    await file.writeAsString(
      jsonEncode({
        'enableWithPomodoro': preferences.enableWithPomodoro,
        'profile': preferences.profile.name,
      }),
      flush: true,
    );
  }

  Future<File> _file() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }
}
