import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum SpeechDictationFailure {
  permissionDenied,
  unavailable,
  languageUnavailable,
  languageDownloadStarted,
  noSpeech,
  busy,
  unknown,
}

enum LocalSpeechModelPhase { idle, scheduled, downloading, ready, failed }

@immutable
class LocalSpeechModelState {
  const LocalSpeechModelState({
    this.phase = LocalSpeechModelPhase.idle,
    this.progress,
    this.errorCode,
  });

  final LocalSpeechModelPhase phase;
  final int? progress;
  final int? errorCode;
}

abstract interface class SpeechRecognitionEngine {
  void setModelStateListener(ValueChanged<LocalSpeechModelState> listener);

  Future<bool> initialize({
    required ValueChanged<String> onError,
    required ValueChanged<String> onStatus,
  });

  Future<bool> hasPermission();

  Future<void> listen({required ValueChanged<String> onResult});

  Future<bool> prepareLocalLanguage();

  Future<void> openLocalLanguageSettings();

  Future<void> stop();

  Future<void> cancel();
}

class DeviceSpeechRecognitionEngine implements SpeechRecognitionEngine {
  DeviceSpeechRecognitionEngine({SpeechToText? speech})
    : _speech = speech ?? SpeechToText() {
    _localSpeechChannel.setMethodCallHandler(_handleNativeCall);
  }

  final SpeechToText _speech;
  static const _localSpanishLocaleId = 'es_ES';
  static const _localSpeechChannel = MethodChannel(
    'michifocus/local_speech',
  );
  ValueChanged<String>? _onError;
  ValueChanged<String>? _onStatus;
  ValueChanged<String>? _onResult;
  ValueChanged<LocalSpeechModelState>? _onModelState;

  @override
  void setModelStateListener(
    ValueChanged<LocalSpeechModelState> listener,
  ) {
    _onModelState = listener;
  }

  @override
  Future<bool> initialize({
    required ValueChanged<String> onError,
    required ValueChanged<String> onStatus,
  }) {
    _onError = onError;
    _onStatus = onStatus;
    return _speech.initialize(
      onError: (error) => onError(error.errorMsg),
      onStatus: onStatus,
      options: [SpeechToText.androidNoBluetooth],
    );
  }

  @override
  Future<bool> hasPermission() => _speech.hasPermission;

  @override
  Future<void> listen({required ValueChanged<String> onResult}) async {
    _onResult = onResult;
    await _localSpeechChannel.invokeMethod<bool>(
      'startListening',
      <String, String>{'localeId': _localSpanishLocaleId},
    );
  }

  @override
  Future<bool> prepareLocalLanguage() async {
    final status = await _localSpeechChannel.invokeMethod<String>(
      'downloadModel',
      <String, String>{'localeId': _localSpanishLocaleId},
    );
    return status == 'started' ||
        status == 'downloading' ||
        status == 'downloaded' ||
        status == 'scheduled';
  }

  @override
  Future<void> openLocalLanguageSettings() async {
    await _localSpeechChannel.invokeMethod<bool>(
      'openLanguageSettings',
      <String, String>{'localeId': _localSpanishLocaleId},
    );
  }

  @override
  Future<void> stop() async {
    await _localSpeechChannel.invokeMethod<bool>('stopListening');
  }

  @override
  Future<void> cancel() async {
    await _localSpeechChannel.invokeMethod<bool>('cancelListening');
  }

  Future<void> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'speechResult':
        final data = Map<Object?, Object?>.from(call.arguments as Map);
        final text = data['text'] as String?;
        if (text != null) {
          _onResult?.call(text);
        }
      case 'speechStatus':
        _onStatus?.call(call.arguments as String);
      case 'speechError':
        _onError?.call(call.arguments as String);
      case 'modelState':
        final data = Map<Object?, Object?>.from(call.arguments as Map);
        final phase = switch (data['phase']) {
          'scheduled' => LocalSpeechModelPhase.scheduled,
          'downloading' => LocalSpeechModelPhase.downloading,
          'ready' => LocalSpeechModelPhase.ready,
          'failed' => LocalSpeechModelPhase.failed,
          _ => LocalSpeechModelPhase.idle,
        };
        _onModelState?.call(
          LocalSpeechModelState(
            phase: phase,
            progress: (data['progress'] as num?)?.round(),
            errorCode: (data['error'] as num?)?.round(),
          ),
        );
    }
  }
}

class SpeechDictationController {
  SpeechDictationController({SpeechRecognitionEngine? engine})
    : _engine = engine ?? DeviceSpeechRecognitionEngine() {
    _engine.setModelStateListener((state) => localModelState.value = state);
  }

  static final SpeechDictationController shared = SpeechDictationController();

  final SpeechRecognitionEngine _engine;
  final FlutterSignal<String?> activeFieldId = signal(null);
  final FlutterSignal<LocalSpeechModelState> localModelState = signal(
    const LocalSpeechModelState(),
  );

  bool _initialized = false;
  bool _isPreparingLanguage = false;
  ValueChanged<String>? _onResult;
  ValueChanged<SpeechDictationFailure>? _onFailure;

  Future<void> toggle({
    required String fieldId,
    required ValueChanged<String> onResult,
    required ValueChanged<SpeechDictationFailure> onFailure,
  }) async {
    if (activeFieldId.value == fieldId) {
      await stop(fieldId);
      return;
    }

    if (activeFieldId.value case final activeId?) {
      await cancel(activeId);
    }

    _onResult = onResult;
    _onFailure = onFailure;

    try {
      if (!_initialized) {
        _initialized = await _engine.initialize(
          onError: _handleError,
          onStatus: _handleStatus,
        );
        if (!_initialized) {
          final hasPermission = await _engine.hasPermission();
          _fail(
            hasPermission
                ? SpeechDictationFailure.unavailable
                : SpeechDictationFailure.permissionDenied,
          );
          return;
        }
      }

      activeFieldId.value = fieldId;
      await _engine.listen(onResult: _handleResult);
    } on Object {
      _fail(SpeechDictationFailure.unavailable);
    }
  }

  Future<void> stop(String fieldId) async {
    if (activeFieldId.value != fieldId) {
      return;
    }
    try {
      await _engine.stop();
    } on Object {
      _fail(SpeechDictationFailure.unknown);
    }
  }

  Future<void> openLocalLanguageSettings() =>
      _engine.openLocalLanguageSettings();

  Future<void> cancel(String fieldId) async {
    if (activeFieldId.value != fieldId) {
      return;
    }
    try {
      await _engine.cancel();
    } on Object {
      // The local session still needs to close even if Android already did.
    } finally {
      _clearSession();
    }
  }

  void _handleResult(String text) {
    if (text.trim().isNotEmpty) {
      _onResult?.call(text);
    }
  }

  void _handleStatus(String status) {
    if (status == SpeechToText.doneStatus && !_isPreparingLanguage) {
      _clearSession();
    }
  }

  void _handleError(String code) {
    if (code == 'error_language_not_supported' ||
        code == 'error_language_unavailable') {
      _isPreparingLanguage = true;
      unawaited(_prepareLocalLanguage());
      return;
    }
    final failure = switch (code) {
      'error_permission' => SpeechDictationFailure.permissionDenied,
      'error_no_match' ||
      'error_speech_timeout' => SpeechDictationFailure.noSpeech,
      'error_busy' => SpeechDictationFailure.busy,
      _ => SpeechDictationFailure.unknown,
    };
    _fail(failure);
  }

  Future<void> _prepareLocalLanguage() async {
    try {
      localModelState.value = const LocalSpeechModelState(
        phase: LocalSpeechModelPhase.scheduled,
      );
      final started = await _engine.prepareLocalLanguage();
      _isPreparingLanguage = false;
      _fail(
        started
            ? SpeechDictationFailure.languageDownloadStarted
            : SpeechDictationFailure.languageUnavailable,
      );
    } on Object {
      _isPreparingLanguage = false;
      _fail(SpeechDictationFailure.languageUnavailable);
    }
  }

  void _fail(SpeechDictationFailure failure) {
    _onFailure?.call(failure);
    _clearSession();
  }

  void _clearSession() {
    _isPreparingLanguage = false;
    activeFieldId.value = null;
    _onResult = null;
    _onFailure = null;
  }
}
