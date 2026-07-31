import 'package:flutter/widgets.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String tr(String spanish, String english) {
    return l10n.localeName == 'en' ? english : spanish;
  }

  String localizeMessage(String message) {
    if (l10n.localeName != 'en') {
      return message;
    }

    if (message.startsWith('La base de datos no es compatible')) {
      return 'The database is incompatible or damaged.';
    }

    return switch (message) {
      'Escribe un titulo para guardar la tarea.' =>
        'Enter a title to save the task.',
      'La duracion debe estar entre 1 y 1440 minutos.' =>
        'Duration must be between 1 and 1440 minutes.',
      'No se pudo actualizar la tarea.' => 'The task could not be updated.',
      'Escribe un titulo para guardar la meta.' =>
        'Enter a title to save the goal.',
      'El objetivo debe tener al menos 1 pomodoro.' =>
        'The goal must contain at least 1 Pomodoro.',
      'Escribe un titulo para guardar el evento.' =>
        'Enter a title to save the event.',
      'La duracion debe ser mayor a 0 minutos.' =>
        'Duration must be greater than 0 minutes.',
      'La carpeta de backup no existe.' => 'The backup folder does not exist.',
      'La carpeta no contiene archivos de backup de MichiFocus.' =>
        'The folder does not contain a MichiFocus backup.',
      'La base de datos de backup no es un archivo SQLite valido.' =>
        'The backup database is not a valid SQLite file.',
      _ => message,
    };
  }
}
