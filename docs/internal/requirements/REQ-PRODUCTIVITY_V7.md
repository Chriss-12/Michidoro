# Productivity V7 requirements

Status:
V7-M0 implemented, V7-M1/V7-M2 verified, and V7-M2.1 implemented on
2026-07-31. V7-M3 remains proposed until separately approved.

## Scope

V7 simplifies the Focus overflow menu, separates normal fullscreen from a
black maximum-concentration presentation, and exposes completion vibration in
Settings without changing Pomodoro timing, task progress, or session history.

### REQ-V7-001 - Focus overflow menu and normal fullscreen

Status: Implemented

Objective:
Replace the Focus three-dot settings shortcut with a small anchored display
menu.

Checklist:
- [x] Requirement approved
- [x] UI implemented
- [x] State and navigation responsibilities implemented
- [x] Data/persistence impact reviewed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The Focus three-dot button no longer opens Pomodoro time settings.
- [x] Tapping the three-dot button opens a small compact popup beside the
      button; it does not open a page, full-screen panel, or large bottom sheet.
- [x] Pomodoro duration and atmosphere configuration remains available from
      Settings, so removing the shortcut does not delete the functionality.
- [x] In the normal Focus view, the menu shows `Ver en pantalla completa`.
- [x] In normal fullscreen, the same small menu shows
      `Salir de pantalla completa`.
- [x] Normal fullscreen preserves the selected application theme and shows the
      active Focus experience without the app shell or bottom navigation.
- [x] Entering or leaving fullscreen does not start, pause, reset, or finish the
      Pomodoro.
- [x] Spanish and English labels are included.

Verification notes:
- `dart format`, `flutter analyze`, the focused navigation/widget test, and the
  full 137-test suite passed on 2026-07-31.
- The release APK built with JDK 17, installed over the existing app, and
  launched successfully on the connected Android device.
- Physical screenshot inspection remains pending because the connected device
  was behind its secure lock screen; keep this requirement below `Verified`
  until the compact popup is inspected in normal and fullscreen Focus.

### REQ-V7-002 - Maximum concentration mode and safe exit

Status: Verified

Objective:
Provide a minimal black fullscreen Focus mode with two explicit exit paths.

Checklist:
- [x] Requirement approved
- [x] UI planned
- [x] State and runtime interaction planned
- [x] Data/persistence impact reviewed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The Focus three-dot menu includes a `Máxima concentración` switch.
- [x] Enabling the switch before a Pomodoro starts arms the mode; starting the
      Pomodoro enters maximum concentration automatically.
- [x] Enabling the switch while a Pomodoro is already active enters the mode
      immediately.
- [x] Maximum concentration is rendered only while a Pomodoro runtime is
      active; stopping, discarding, or completing the runtime exits the mode.
- [x] The mode uses an immersive fullscreen black background and keeps only the
      Focus countdown, phase, progress ring, indispensable timer controls, and
      the three-dot menu visible.
- [x] The screen is pure black while the countdown, ring, icons, borders, and
      buttons use subdued white/gray tones with an Always On Display appearance;
      no active theme color or bright button fill remains visible.
- [x] Once maximum concentration is active, double-tapping a non-interactive
      area of its black screen exits that mode and turns its switch off.
- [x] Double-tapping outside maximum concentration has no special behavior.
- [x] Opening the three-dot menu and turning off `Máxima concentración` provides
      the second exit path.
- [x] Either exit returns to the normal Focus presentation without pausing,
      resetting, finishing, or changing the remaining time.
- [x] Pausing the timer does not exit maximum concentration automatically.
- [x] Single taps and taps on timer controls never trigger the maximum-mode
      double-tap exit.
- [x] Back/system UI restoration is deterministic after every exit path.
- [x] Spanish and English labels and accessibility semantics are included.

Implementation decision:
- Maximum concentration is ephemeral presentation state. It is not written to
  SQLite or Settings JSON and does not reactivate automatically after process
  recreation.

Verification evidence (2026-07-31):
- `flutter analyze` passed without issues and the full 139-test suite passed.
- Controller tests cover pause/discard lifecycle; the widget flow covers arming,
  immediate entry, pure-black rendering, double-tap exit, direct switch exit,
  and unchanged paused time.
- The 390 x 844 golden was inspected for pure black and subdued grayscale AOD
  styling without theme colors or overflow.
- The release APK built, installed, and launched on the connected Android
  device. Physical inspection covered the English menu, active and paused AOD
  presentation, direct switch interaction, double-tap exit, continued timing,
  and Android system UI restoration.

### REQ-V7-003 - Completion vibration in Settings

Status: Verified

Objective:
Manage completion vibration from Settings instead of Focus configuration.

Checklist:
- [x] Requirement approved
- [x] UI implemented
- [x] Existing state integration reused
- [x] Data/persistence impact reviewed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Settings exposes a `Vibrar al finalizar` switch in the notification or
      completion-feedback section.
- [x] English displays `Vibrate when finished`.
- [x] The setting reuses the existing completion-vibration behavior and does
      not create a second conflicting preference.
- [x] The switch value persists in `michidoro-settings.json` and is restored at
      startup.
- [x] Enabled vibration runs when a focus or break phase finishes, including
      when the selected completion sound is silent.
- [x] Disabled vibration produces no completion haptic feedback.
- [x] The former Focus atmosphere/configuration surface no longer owns this
      setting.
- [x] The implementation remains offline-first and does not require a database
      schema change.

Verification evidence (2026-07-31):
- `dart format` passed, `flutter analyze` reported no issues, and the full suite
  passed with 140 tests.
- State tests cover enabled/disabled haptics with silent completion sound and
  existing load/save tests cover `completionVibrationEnabled` persistence.
- The widget flow covers Spanish/English labels, reactive switching, and the
  Settings-owned test-vibration action.
- The release APK built and installed successfully. Android inspection covered
  responsive layout, enabled/disabled controls, haptic preview, and restoration
  of the disabled value after a process restart.

### REQ-V7-004 - Selectable completion vibration patterns

Status: Implemented

Objective:
Let the user choose the completion-vibration pattern while preserving the
existing on/off preference and backward compatibility.

Checklist:
- [x] Requirement approved
- [x] UI implemented
- [x] State integration implemented
- [x] Settings JSON compatibility verified
- [x] Checks passed
- [ ] Android inspection passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Settings offers `Suave`, `Normal`, `Doble`, and `Intensa` vibration
      patterns, with equivalent English labels.
- [x] The selected pattern is used both by the preview action and when a focus
      or break phase finishes.
- [x] Turning completion vibration off suppresses every pattern.
- [x] `Normal` preserves the former single medium-impact behavior.
- [x] The pattern persists in `michidoro-settings.json`.
- [x] Settings files created before this requirement load `Normal` when the new
      key is absent or invalid.
- [x] The implementation remains offline-first and requires no database schema,
      Gradle, or package change.

Implementation evidence (2026-07-31):
- Settings and its notification detail page expose the same localized selector,
  description, switch, and full-width preview action.
- Controller tests verify light, medium, double light/medium, and heavy platform
  haptic calls, disabled behavior, silent-sound behavior, and the normal default.
- Settings repository tests verify legacy JSON fallback and a complete save/load
  round trip for `completionVibrationPattern`.
- Widget coverage selects `Doble`, verifies its description and English label,
  then restores `Normal`.
- `dart format`, clean `flutter analyze`, and the full 144-test suite passed.
- The 64.1 MB release APK built and installed on device `3bbacc93`. Physical
  inspection remains pending because the device is locked with a user pattern.

## Non-goals

- These display modes do not change focus duration, break duration, block
  planning, task percentage, task status, or session persistence.
- Maximum concentration does not block pause, resume, or safe runtime exit.
- This milestone does not add a new vibration package unless a later technical
  review proves the existing local platform feedback insufficient.
