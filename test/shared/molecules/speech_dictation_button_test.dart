import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';
import 'package:pomodoro_app_v1/shared/molecules/speech_dictation_button.dart';
import 'package:pomodoro_app_v1/shared/services/speech_dictation_controller.dart';

void main() {
  test('inserts speech at the cursor and replaces a selected range', () {
    final inserted = applySpeechTranscript(
      const TextEditingValue(
        text: 'Comprar mañana',
        selection: TextSelection.collapsed(offset: 7),
      ),
      'leche',
    );
    final replaced = applySpeechTranscript(
      const TextEditingValue(
        text: 'Rutina antigua',
        selection: TextSelection(baseOffset: 0, extentOffset: 6),
      ),
      'Sesión',
    );

    expect(inserted.text, 'Comprar leche mañana');
    expect(inserted.selection.baseOffset, 13);
    expect(replaced.text, 'Sesión antigua');
  });

  testWidgets('writes partial speech and restores text after an error', (
    tester,
  ) async {
    final engine = _WidgetFakeSpeechRecognitionEngine();
    final dictation = SpeechDictationController(engine: engine);
    var latestChangedValue = 'not-called';
    final textController = TextEditingController(text: 'Texto original')
      ..selection = const TextSelection.collapsed(offset: 14);
    addTearDown(textController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TextField(
            controller: textController,
            decoration: InputDecoration(
              suffixIcon: SpeechDictationFieldActions(
                fieldId: 'test-field',
                textController: textController,
                dictationController: dictation,
                onChanged: (value) => latestChangedValue = value,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('speech-input-test-field')));
    await tester.pump();
    engine.emitResult('dictado');
    await tester.pump();
    expect(textController.text, 'Texto original dictado');

    engine.emitError('error_no_match');
    await tester.pump();
    expect(textController.text, 'Texto original');
    expect(find.text('No se detectó voz. Inténtalo de nuevo.'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('clear-text-test-field')));
    await tester.pump();
    expect(textController.text, isEmpty);
    expect(latestChangedValue, isEmpty);
    expect(
      tester
          .widget<IconButton>(
            find.byKey(const ValueKey('clear-text-test-field')),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('shows local model progress and completion', (tester) async {
    final engine = _WidgetFakeSpeechRecognitionEngine()
      ..localLanguageResult = true;
    final dictation = SpeechDictationController(engine: engine);
    final textController = TextEditingController();
    addTearDown(textController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SpeechDictationButton(
            fieldId: 'model-progress',
            textController: textController,
            dictationController: dictation,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('speech-input-model-progress')));
    await tester.pump();
    engine.emitError('error_language_unavailable');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Voz sin conexión'), findsOneWidget);

    engine.emitModelState(
      const LocalSpeechModelState(
        phase: LocalSpeechModelPhase.downloading,
        progress: 42,
      ),
    );
    await tester.pump();
    expect(find.text('42%'), findsOneWidget);

    engine.emitModelState(
      const LocalSpeechModelState(
        phase: LocalSpeechModelPhase.ready,
        progress: 100,
      ),
    );
    await tester.pump();
    expect(find.textContaining('ya está listo'), findsOneWidget);
  });

  testWidgets('scheduled model offers language manager instead of waiting', (
    tester,
  ) async {
    final engine = _WidgetFakeSpeechRecognitionEngine()
      ..localLanguageResult = true;
    final dictation = SpeechDictationController(engine: engine);
    final textController = TextEditingController();
    addTearDown(textController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SpeechDictationButton(
            fieldId: 'scheduled-model',
            textController: textController,
            dictationController: dictation,
          ),
        ),
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey('speech-input-scheduled-model')),
    );
    await tester.pump();
    engine.emitError('error_language_unavailable');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('no enviará más progreso'), findsOneWidget);
    expect(find.text('Esperando a Android…'), findsNothing);
    expect(find.text('Administrar idiomas'), findsOneWidget);
    expect(find.text('Probar ahora'), findsOneWidget);

    await tester.tap(find.text('Administrar idiomas'));
    await tester.pumpAndSettle();
    expect(engine.openLocalLanguageSettingsCalls, 1);
  });
}

class _WidgetFakeSpeechRecognitionEngine implements SpeechRecognitionEngine {
  bool localLanguageResult = false;
  int openLocalLanguageSettingsCalls = 0;
  ValueChanged<String>? _onError;
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
    return true;
  }

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<void> listen({required ValueChanged<String> onResult}) async {
    _onResult = onResult;
  }

  @override
  Future<bool> prepareLocalLanguage() async => localLanguageResult;

  @override
  Future<void> openLocalLanguageSettings() async {
    openLocalLanguageSettingsCalls += 1;
  }

  @override
  Future<void> cancel() async {}

  @override
  Future<void> stop() async {}

  void emitResult(String value) => _onResult?.call(value);

  void emitError(String value) => _onError?.call(value);

  void emitModelState(LocalSpeechModelState value) =>
      _onModelState?.call(value);
}
