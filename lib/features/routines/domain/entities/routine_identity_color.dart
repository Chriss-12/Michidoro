const int defaultRoutineIdentityColorArgb = 0xFF5B844E;

int legacyRoutineIdentityColorArgb(String colorKey) => switch (colorKey) {
  'secondary' => 0xFF42859A,
  'tertiary' => 0xFF985C37,
  'peach' => 0xFFD38052,
  'neutral' => 0xFF687078,
  _ => defaultRoutineIdentityColorArgb,
};

int effectiveRoutineIdentityColorArgb({
  required String colorKey,
  int? customColorArgb,
}) => customColorArgb ?? legacyRoutineIdentityColorArgb(colorKey);
