import 'package:flutter/services.dart';

class AndroidSyncDataFolderValidator {
  AndroidSyncDataFolderValidator({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('michifocus/native_files');

  final MethodChannel _channel;

  Future<bool> validate(String folderUri) async {
    final normalizedUri = folderUri.trim();
    if (normalizedUri.isEmpty) return false;

    try {
      return await _channel.invokeMethod<bool>(
            'validateSyncFolder',
            {'folderUri': normalizedUri},
          ) ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
