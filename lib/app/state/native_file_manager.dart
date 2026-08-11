import 'dart:io';

import 'package:flutter/services.dart';

class ExternalFolderSelection {
  const ExternalFolderSelection({
    required this.uri,
    required this.label,
  });

  final String uri;
  final String label;
}

class ExternalSavedFile {
  const ExternalSavedFile({
    required this.displayPath,
    required this.openReference,
  });

  final String displayPath;
  final String openReference;
}

class NativeFileManager {
  const NativeFileManager._();

  static const _channel = MethodChannel('michifocus/native_files');

  static bool get isAndroidExternalPickerAvailable => Platform.isAndroid;

  static bool isExternalFolderReference(String value) {
    return value.trim().startsWith('content://');
  }

  static Future<String?> pickProfileImage() async {
    if (!Platform.isAndroid) {
      return null;
    }

    return _channel.invokeMethod<String>('pickProfileImage');
  }

  static Future<ExternalFolderSelection?> pickFolder() async {
    if (!Platform.isAndroid) {
      return null;
    }

    final result = await _channel.invokeMapMethod<String, String>('pickFolder');
    if (result == null) {
      return null;
    }

    final uri = result['uri']?.trim() ?? '';
    if (uri.isEmpty) {
      return null;
    }

    final label = result['label']?.trim();
    return ExternalFolderSelection(
      uri: uri,
      label: label == null || label.isEmpty ? uri : label,
    );
  }

  static Future<ExternalFolderSelection?> pickExportFolder() {
    return pickFolder();
  }

  static Future<String?> pickBackupImportFolder() async {
    if (!Platform.isAndroid) {
      return null;
    }

    return _channel.invokeMethod<String>('pickBackupImportFolder');
  }

  static Future<ExternalSavedFile> saveFileToExternalFolder({
    required String folderUri,
    required String fileName,
    required String mimeType,
    required List<int> bytes,
  }) async {
    final result = await _channel.invokeMapMethod<String, String>(
      'saveFileToExternalFolder',
      {
        'folderUri': folderUri,
        'fileName': fileName,
        'mimeType': mimeType,
        'bytes': Uint8List.fromList(bytes),
      },
    );

    final displayPath = result?['path']?.trim() ?? '';
    final openReference = result?['uri']?.trim() ?? '';
    if (openReference.isEmpty) {
      throw const FormatException(
        'Android no devolvio la referencia del archivo guardado.',
      );
    }
    return ExternalSavedFile(
      displayPath: displayPath.isEmpty ? folderUri : displayPath,
      openReference: openReference,
    );
  }

  static Future<String> exportBackupToExternalFolder({
    required String folderUri,
    required List<String> fileNames,
  }) async {
    final result = await _channel.invokeMethod<String>(
      'exportBackupToExternalFolder',
      {
        'folderUri': folderUri,
        'fileNames': fileNames,
      },
    );

    return result ?? folderUri;
  }

  static Future<void> openFile({
    required String path,
    String mimeType = 'application/pdf',
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('La apertura de archivos requiere Android.');
    }

    await _channel.invokeMethod<void>(
      'openFile',
      {
        'path': path,
        'mimeType': mimeType,
      },
    );
  }

  static Future<void> playCompletionSound(String soundName) async {
    if (!Platform.isAndroid) {
      return;
    }

    await _channel.invokeMethod<void>(
      'playCompletionSound',
      {'sound': soundName},
    );
  }

  static Future<void> playCompletionVibration(String patternName) {
    return _channel.invokeMethod<void>(
      'playCompletionVibration',
      {'pattern': patternName},
    );
  }
}
