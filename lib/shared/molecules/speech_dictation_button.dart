import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/services/speech_dictation_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SpeechDictationButton extends StatefulWidget {
  const SpeechDictationButton({
    required this.fieldId,
    required this.textController,
    this.onChanged,
    this.dictationController,
    super.key,
  });

  final String fieldId;
  final TextEditingController textController;
  final ValueChanged<String>? onChanged;
  final SpeechDictationController? dictationController;

  @override
  State<SpeechDictationButton> createState() => _SpeechDictationButtonState();
}

class SpeechDictationFieldActions extends StatelessWidget {
  const SpeechDictationFieldActions({
    required this.fieldId,
    required this.textController,
    this.onChanged,
    this.dictationController,
    super.key,
  });

  final String fieldId;
  final TextEditingController textController;
  final ValueChanged<String>? onChanged;
  final SpeechDictationController? dictationController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: textController,
        child: SpeechDictationButton(
          fieldId: fieldId,
          textController: textController,
          onChanged: onChanged,
          dictationController: dictationController,
        ),
        builder: (context, value, microphone) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            microphone!,
            IconButton(
              key: ValueKey('clear-text-$fieldId'),
              tooltip: context.tr('Borrar todo', 'Clear all'),
              onPressed: value.text.isEmpty ? null : _clear,
              icon: const _EraserIcon(),
            ),
          ],
        ),
      ),
    );
  }

  void _clear() {
    textController.clear();
    onChanged?.call('');
  }
}

class _EraserIcon extends StatelessWidget {
  const _EraserIcon();

  @override
  Widget build(BuildContext context) {
    final color =
        IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return Transform.rotate(
      angle: -0.55,
      child: Container(
        width: 21,
        height: 13,
        decoration: BoxDecoration(
          color: color.withAlpha(28),
          border: Border.all(color: color, width: 1.7),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 7,
            decoration: BoxDecoration(
              color: color.withAlpha(62),
              border: Border(left: BorderSide(color: color, width: 1.2)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeechDictationButtonState extends State<SpeechDictationButton> {
  late final SpeechDictationController _dictation =
      widget.dictationController ?? SpeechDictationController.shared;
  TextEditingValue? _initialValue;
  bool _isStarting = false;
  bool _isModelDialogOpen = false;

  @override
  void dispose() {
    if (_dictation.activeFieldId.value == widget.fieldId) {
      unawaited(_dictation.cancel(widget.fieldId));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final isListening = _dictation.activeFieldId.value == widget.fieldId;
        return IconButton(
          key: ValueKey('speech-input-${widget.fieldId}'),
          tooltip: isListening
              ? context.tr('Detener dictado', 'Stop dictation')
              : context.tr('Dictar texto', 'Dictate text'),
          onPressed: _isStarting ? null : _toggle,
          color: isListening
              ? context.palette.primary
              : context.palette.textSecondary,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Icon(
              isListening ? Icons.graphic_eq_rounded : Icons.mic_none_rounded,
              key: ValueKey(isListening),
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggle() async {
    final wasListening = _dictation.activeFieldId.value == widget.fieldId;
    if (!wasListening) {
      _initialValue = widget.textController.value;
    }

    setState(() => _isStarting = true);
    await _dictation.toggle(
      fieldId: widget.fieldId,
      onResult: _applyTranscript,
      onFailure: _handleFailure,
    );
    if (mounted) {
      setState(() => _isStarting = false);
    }
  }

  void _applyTranscript(String transcript) {
    if (!mounted || _initialValue == null) {
      return;
    }
    final next = applySpeechTranscript(_initialValue!, transcript);
    widget.textController.value = next;
    widget.onChanged?.call(next.text);
  }

  void _handleFailure(SpeechDictationFailure failure) {
    if (!mounted) {
      return;
    }
    if (_initialValue case final initial?) {
      widget.textController.value = initial;
      widget.onChanged?.call(initial.text);
    }

    if (failure == SpeechDictationFailure.languageDownloadStarted) {
      unawaited(_showLocalModelDialog());
      return;
    }

    final message = switch (failure) {
      SpeechDictationFailure.permissionDenied => context.tr(
        'Permite el acceso al micrófono en Ajustes para usar el dictado.',
        'Allow microphone access in Settings to use dictation.',
      ),
      SpeechDictationFailure.languageUnavailable => context.tr(
        'No se pudo preparar el español local en este dispositivo.',
        'The local Spanish model could not be prepared on this device.',
      ),
      SpeechDictationFailure.languageDownloadStarted => context.tr(
        'Android está preparando el español local. Inténtalo nuevamente cuando termine.',
        'Android is preparing the local Spanish model. Try again when it finishes.',
      ),
      SpeechDictationFailure.noSpeech => context.tr(
        'No se detectó voz. Inténtalo de nuevo.',
        'No speech was detected. Try again.',
      ),
      SpeechDictationFailure.busy => context.tr(
        'El micrófono está ocupado. Inténtalo nuevamente.',
        'The microphone is busy. Try again.',
      ),
      SpeechDictationFailure.unavailable ||
      SpeechDictationFailure.unknown => context.tr(
        'El dictado no está disponible en este dispositivo.',
        'Dictation is unavailable on this device.',
      ),
    };
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showLocalModelDialog() async {
    if (!mounted || _isModelDialogOpen) {
      return;
    }
    _isModelDialogOpen = true;
    final action = await showDialog<_LocalModelDialogAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SignalBuilder(
        builder: (context) {
          final state = _dictation.localModelState.value;
          final isReady = state.phase == LocalSpeechModelPhase.ready;
          final hasFailed = state.phase == LocalSpeechModelPhase.failed;
          final isScheduled =
              state.phase == LocalSpeechModelPhase.idle ||
              state.phase == LocalSpeechModelPhase.scheduled;
          final progress = state.progress?.clamp(0, 100);
          final description = switch (state.phase) {
            LocalSpeechModelPhase.idle ||
            LocalSpeechModelPhase.scheduled => context.tr(
              'Android dejó pendiente el español sin conexión y no enviará más progreso a Michi Focus. Abre el administrador de idiomas, instala Español y luego prueba otra vez.',
              'Android left offline Spanish pending and will not send more progress to Michi Focus. Open the language manager, install Spanish, and then try again.',
            ),
            LocalSpeechModelPhase.downloading => context.tr(
              'Descargando español para dictar sin conexión…',
              'Downloading Spanish for offline dictation…',
            ),
            LocalSpeechModelPhase.ready => context.tr(
              'El español local ya está listo. Cierra este mensaje y vuelve a tocar el micrófono.',
              'Offline Spanish is ready. Close this message and tap the microphone again.',
            ),
            LocalSpeechModelPhase.failed => context.tr(
              'Android no pudo descargar el español local. Comprueba tu conexión e inténtalo otra vez.',
              'Android could not download offline Spanish. Check your connection and try again.',
            ),
          };

          return AlertDialog(
            icon: Icon(
              isReady
                  ? Icons.check_circle_rounded
                  : hasFailed
                  ? Icons.cloud_off_rounded
                  : Icons.download_rounded,
              color: isReady
                  ? context.palette.primary
                  : hasFailed
                  ? Theme.of(context).colorScheme.error
                  : context.palette.secondary,
            ),
            title: Text(context.tr('Voz sin conexión', 'Offline voice')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(description),
                if (state.phase == LocalSpeechModelPhase.downloading) ...[
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: progress == null ? null : progress / 100,
                    color: context.palette.primary,
                    backgroundColor: context.palette.primaryMuted,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    progress == null ? '…' : '$progress%',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ],
            ),
            actions: [
              if (isScheduled || hasFailed)
                TextButton.icon(
                  onPressed: () => Navigator.of(dialogContext).pop(
                    _LocalModelDialogAction.manageLanguages,
                  ),
                  icon: const Icon(Icons.language_rounded),
                  label: Text(
                    context.tr('Administrar idiomas', 'Manage languages'),
                  ),
                ),
              if (isScheduled || isReady)
                FilledButton.icon(
                  onPressed: () => Navigator.of(dialogContext).pop(
                    _LocalModelDialogAction.retry,
                  ),
                  icon: const Icon(Icons.mic_rounded),
                  label: Text(context.tr('Probar ahora', 'Try now')),
                ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(
                  _LocalModelDialogAction.close,
                ),
                child: Text(context.tr('Cerrar', 'Close')),
              ),
            ],
          );
        },
      ),
    );
    _isModelDialogOpen = false;
    if (!mounted) {
      return;
    }
    switch (action) {
      case _LocalModelDialogAction.manageLanguages:
        try {
          await _dictation.openLocalLanguageSettings();
        } on Object {
          if (mounted) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(
                content: Text(
                  context.tr(
                    'Android no pudo abrir el administrador de idiomas de voz.',
                    'Android could not open the voice language manager.',
                  ),
                ),
              ),
            );
          }
        }
      case _LocalModelDialogAction.retry:
        await _toggle();
      case _LocalModelDialogAction.close:
      case null:
        break;
    }
  }
}

enum _LocalModelDialogAction { close, manageLanguages, retry }

@visibleForTesting
TextEditingValue applySpeechTranscript(
  TextEditingValue initialValue,
  String transcript,
) {
  final spoken = transcript.trim();
  if (spoken.isEmpty) {
    return initialValue;
  }

  final text = initialValue.text;
  final selection = initialValue.selection;
  final hasValidSelection =
      selection.isValid &&
      selection.start <= text.length &&
      selection.end <= text.length;
  final start = hasValidSelection ? selection.start : text.length;
  final end = hasValidSelection ? selection.end : text.length;
  final left = text.substring(0, start);
  final right = text.substring(end);
  final leadingSpace = left.isNotEmpty && !RegExp(r'\s$').hasMatch(left)
      ? ' '
      : '';
  final trailingSpace = right.isNotEmpty && !RegExp(r'^\s').hasMatch(right)
      ? ' '
      : '';
  final insertion = '$leadingSpace$spoken$trailingSpace';
  final nextText = '$left$insertion$right';
  final cursor = left.length + leadingSpace.length + spoken.length;

  return TextEditingValue(
    text: nextText,
    selection: TextSelection.collapsed(offset: cursor),
  );
}
