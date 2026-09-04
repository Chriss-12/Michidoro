import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/shared/services/speech_dictation_controller.dart';

void main() {
  test(
    'publishes recognized text and clears the active field when done',
    () async {
      final engine = _FakeSpeechRecognitionEngine();
      final controller = SpeechDictationController(engine: engine);
      final results = <String>[];

      await controller.toggle(
        fieldId: 'task-title',
        onResult: results.add,
        onFailure: (_) => fail('dictation should not fail'),
      );
      engine
        ..emitResult('Comprar leche')
        ..emitStatus('done');

      expect(results, ['Comprar leche']);
      expect(controller.activeFieldId.value, isNull);
      expect(engine.listenCalls, 1);
    },
  );

  test('starting another field cancels the previous session', () async {
    final engine = _FakeSpeechRecognitionEngine();
    final controller = SpeechDictationController(engine: engine);

    await controller.toggle(
      fieldId: 'routine-name',
      onResult: (_) {},
      onFailure: (_) {},
    );
    await controller.toggle(
      fieldId: 'routine-description',
      onResult: (_) {},
      onFailure: (_) {},
    );

    expect(engine.cancelCalls, 1);
    expect(controller.activeFieldId.value, 'routine-description');
    expect(engine.listenCalls, 2);
  });

  test('a second tap requests stop and waits for Android to finish', () async {
    final engine = _FakeSpeechRecognitionEngine();
    final controller = SpeechDictationController(engine: engine);

    await controller.toggle(
      fieldId: 'task-title',
      onResult: (_) {},
      onFailure: (_) {},
    );
    await controller.toggle(
      fieldId: 'task-title',
      onResult: (_) {},
      onFailure: (_) {},
    );

    expect(engine.stopCalls, 1);
    expect(controller.activeFieldId.value, 'task-title');

    engine.emitStatus('done');
    expect(controller.activeFieldId.value, isNull);
  });

  test(
    'reports denied microphone permission without starting a session',
    () async {
      final engine = _FakeSpeechRecognitionEngine()
        ..initializeResult = false
        ..permission = false;
      final controller = SpeechDictationController(engine: engine);
      SpeechDictationFailure? failure;

      await controller.toggle(
        fieldId: 'note',
        onResult: (_) {},
        onFailure: (value) => failure = value,
      );

      expect(failure, SpeechDictationFailure.permissionDenied);
      expect(controller.activeFieldId.value, isNull);
      expect(engine.listenCalls, 0);
    },
  );

  test('requests the local language model when it is unavailable', () async {
    final engine = _FakeSpeechRecognitionEngine()..localLanguageResult = true;
    final controller = SpeechDictationController(engine: engine);
    SpeechDictationFailure? failure;

    await controller.toggle(
      fieldId: 'goal-title',
      onResult: (_) {},
      onFailure: (value) => failure = value,
    );
    engine
      ..emitError('error_language_unavailable')
      ..emitStatus('done');
    await Future<void>.delayed(Duration.zero);

    expect(failure, SpeechDictationFailure.languageDownloadStarted);
    expect(controller.activeFieldId.value, isNull);
    expect(engine.prepareLocalLanguageCalls, 1);
  });

  test('publishes local model download progress and ready state', () {
    final engine = _FakeSpeechRecognitionEngine();
    final controller = SpeechDictationController(engine: engine);

    engine.emitModelState(
      const LocalSpeechModelState(
        phase: LocalSpeechModelPhase.downloading,
        progress: 42,
      ),
    );
    expect(controller.localModelState.value.progress, 42);

    engine.emitModelState(
      const LocalSpeechModelState(
        phase: LocalSpeechModelPhase.ready,
        progress: 100,
      ),
    );
    expect(
      controller.localModelState.value.phase,
      LocalSpeechModelPhase.ready,
    );
  });

  test('opens the device language manager through the engine', () async {
    final engine = _FakeSpeechRecognitionEngine();
    final controller = SpeechDictationController(engine: engine);

    await controller.openLocalLanguageSettings();

    expect(engine.openLocalLanguageSettingsCalls, 1);
  });
}

class _FakeSpeechRecognitionEngine implements SpeechRecognitionEngine {
  bool initializeResult = true;
  bool permission = true;
  bool localLanguageResult = false;
  int listenCalls = 0;
  int cancelCalls = 0;
  int stopCalls = 0;
  int prepareLocalLanguageCalls = 0;
  int openLocalLanguageSettingsCalls = 0;
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
  }) async {
    _onError = onError;
    _onStatus = onStatus;
    return initializeResult;
  }

  @override
  Future<bool> hasPermission() async => permission;

  @override
  Future<void> listen({required ValueChanged<String> onResult}) async {
    listenCalls += 1;
    _onResult = onResult;
  }

  @override
  Future<bool> prepareLocalLanguage() async {
    prepareLocalLanguageCalls += 1;
    return localLanguageResult;
  }

  @override
  Future<void> openLocalLanguageSettings() async {
    openLocalLanguageSettingsCalls += 1;
  }

  @override
  Future<void> cancel() async {
    cancelCalls += 1;
  }

  @override
  Future<void> stop() async {
    stopCalls += 1;
  }

  void emitResult(String value) => _onResult?.call(value);

  void emitStatus(String value) => _onStatus?.call(value);

  void emitError(String value) => _onError?.call(value);

  void emitModelState(LocalSpeechModelState value) =>
      _onModelState?.call(value);
}
