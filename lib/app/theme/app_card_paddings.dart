import 'package:flutter/widgets.dart';

class AppCardPaddings {
  const AppCardPaddings._();

  static const EdgeInsetsGeometry page = EdgeInsets.fromLTRB(16, 0, 16, 96);
  static const EdgeInsetsGeometry pageWithTop = EdgeInsets.fromLTRB(
    16,
    24,
    16,
    96,
  );
  static const EdgeInsetsGeometry detailPage = EdgeInsets.fromLTRB(
    20,
    0,
    20,
    126,
  );

  static const EdgeInsetsGeometry standard = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    16,
  );
  static const EdgeInsetsGeometry compact = EdgeInsets.fromLTRB(16, 14, 16, 14);
  static const EdgeInsetsGeometry spacious = EdgeInsets.fromLTRB(
    24,
    22,
    24,
    22,
  );
  static const EdgeInsetsGeometry dense = EdgeInsets.fromLTRB(14, 10, 14, 10);
}
