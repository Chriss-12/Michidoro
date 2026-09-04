import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine_identity_color.dart';

void main() {
  test('legacy routine keys resolve to stable theme-independent colors', () {
    expect(legacyRoutineIdentityColorArgb('primary'), 0xFF5B844E);
    expect(legacyRoutineIdentityColorArgb('secondary'), 0xFF42859A);
    expect(legacyRoutineIdentityColorArgb('tertiary'), 0xFF985C37);
    expect(legacyRoutineIdentityColorArgb('peach'), 0xFFD38052);
    expect(legacyRoutineIdentityColorArgb('neutral'), 0xFF687078);
  });

  test('a synchronized custom color always takes precedence', () {
    expect(
      effectiveRoutineIdentityColorArgb(
        colorKey: 'secondary',
        customColorArgb: 0xFF7C3AED,
      ),
      0xFF7C3AED,
    );
  });
}
