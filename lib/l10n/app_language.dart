import 'package:flutter/widgets.dart';

enum AppLanguage {
  spanish('es'),
  english('en');

  const AppLanguage(this.code);

  final String code;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(Object? value) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == value,
      orElse: () => AppLanguage.spanish,
    );
  }
}
