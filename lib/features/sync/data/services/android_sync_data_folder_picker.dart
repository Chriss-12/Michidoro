import 'package:pomodoro_app_v1/app/state/native_file_manager.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_data_folder.dart';

Future<SyncDataFolder?> pickAndroidSyncDataFolder() async {
  final selection = await NativeFileManager.pickFolder();
  if (selection == null) return null;
  return SyncDataFolder(uri: selection.uri, label: selection.label);
}
