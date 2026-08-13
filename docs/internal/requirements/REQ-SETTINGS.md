# Settings requirements

Statuses remain `Proposed` until user approval and verification evidence exist.

### REQ-SET-001 - Local settings

Status: Verified

Objective:
Keep user settings local to the device.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Timer settings are saved locally on the device without backend services.
- [x] Settings are loaded before the app starts so Pomodoro uses the persisted focus duration.
- [x] Required checks passed before moving to Verified.

Notes:
- M6 verified: timer preferences persist through a local JSON settings repository in the app documents directory.
- Verification evidence: `dart format lib test`, `flutter analyze`, targeted settings/Pomodoro tests, and full `flutter test` passed.

### REQ-SET-002 - Timer preferences

Status: Verified

Objective:
Allow timer duration and behavior preferences.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Focus, short break, long break, long break frequency, completion sound,
      completion vibration, and auto-start preferences are represented in
      Settings; completion vibration belongs to the notification/feedback
      section.
- [x] Timer preference values are clamped to supported ranges before use or persistence.
- [x] Pomodoro receives the persisted focus duration before the user starts a session.

Notes:
- M6 verified: existing settings controls now persist timer preferences locally and restore them at app startup.
- V7-M2 relocated completion vibration from Focus to Settings while retaining
  the existing `completionVibrationEnabled` JSON value.
- V7-M2.1 stores the selected pattern and drives real Android vibration with
  distinct timing and amplitude; `Normal` remains the legacy fallback.
- Theme and notification preference persistence remain out of scope for this slice.

### REQ-SET-003 - Theme preferences

Status: Verified

Objective:
Apply theme color and text scale globally and restore both at startup.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Selecting a color theme updates the complete application.
- [x] Theme and text scale are persisted in the local settings JSON.
- [x] Theme and text scale are restored when the application starts.
- [x] Dark palettes keep readable controls and system status icons.
- [x] Every color preset remains visually distinct in light and dark mode.
- [x] The implementation remains offline-first.

Notes:
- 2026-07-29: Fixed a regression where dark mode collapsed every selected
  color preset into Graphite Night. Each preset now derives its own dark
  palette and the Settings widget test verifies a global palette change.
- `flutter analyze` and the full 135-test suite passed.
- 2026-07-28: Verified on Android with Nature Focus and Graphite Night.
  Graphite Night persisted across app restart and APK reinstall.
- `flutter analyze`, the full 110-test suite, focused theme/widget tests, APK
  build, installation, and Android screenshot inspection passed.

### REQ-SET-004 - Notification preferences later

Status: Verified

Objective:
Allow local notification feedback preferences, including a selectable sound
library with multiple pleasant tones.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Settings exposes several selectable notification/completion sounds.
- [x] The selected sound is stored locally with timer preferences.
- [x] The user can preview the selected sound from Settings.
- [x] Android uses bundled local audio resources for the richer sound options.
- [x] The implementation remains offline-first and does not add a backend.

Notes:
- 2026-07-22: Verified with a local sound library of seven audible tones plus
  silent mode. Android plays bundled WAV resources through the native channel;
  non-Android platforms keep the existing Flutter system-sound fallback.

### REQ-SET-005 - Reports export folder

Status: Verified

Objective:
Allow the user to choose where report exports are saved locally.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] PDF reports are saved to the configured reports folder when one is set.
- [x] PDF reports default to the platform Downloads folder when possible.
- [x] Settings exposes a local reports folder path control.
- [x] The reports folder preference is persisted locally with the existing settings file.

Verification:
- 2026-07-11: Settings added a Reports card with an editable folder path and a `Usar Descargas` action.
- 2026-07-11: `AppSettingsController` saves PDF/TXT reports to the configured folder or the platform Downloads/default folder.
- 2026-07-11: `dart format lib test`, `flutter analyze`, and focused Settings/widget tests passed with 10 tests.

### REQ-SET-006 - Application language

Status: Verified

Objective:
Allow the user to select Spanish or English and apply the language globally
without requiring internet access.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Settings exposes a clear Español/English language selector.
- [x] Selecting a language updates every user-facing application surface.
- [x] The selected language is persisted in the local Settings JSON.
- [x] The selected language is restored before the main application starts.
- [x] Dynamic labels, dialogs, statuses, notifications, and report UI are
  localized.
- [x] Existing user-created content remains unchanged.
- [x] The implementation remains offline-first.

Verification notes:
- 2026-07-29: `flutter analyze` and the full 137-test suite passed.
- 2026-07-29: Release APK build, installation, Spanish/English switching,
  restart persistence, and Android visual inspection passed on a physical
  device.
- The preference is stored as `languageCode` in the existing local Settings
  JSON; no application database schema change was required.

### REQ-SET-007 - Clear unified database data

Status: Verified

Objective:
Allow the user to irreversibly remove all records from the unified local
database without deleting application preferences or external backups.

Checklist:
- [x] Requirement approved by the user on 2026-08-11.
- [x] Transactional database operation implemented.
- [x] Active Pomodoro and in-memory feature state synchronized.
- [x] Protected bilingual Settings UI implemented.
- [x] Automated and physical checks passed.
- [x] Documentation and traceability verified.

Acceptance criteria:
- [x] Settings exposes a clearly separated destructive data action.
- [x] The confirmation explains exactly what is deleted and retained.
- [x] The destructive action remains disabled until the user types `BORRAR`
      in Spanish or `DELETE` in English.
- [x] One transaction removes goals, tasks, completion events, Pomodoro
      sessions and runtime, routines and their runs/items, reporting metadata,
      and calendar events while preserving schema and indexes.
- [x] A running timer is stopped without recreating runtime data after the
      transaction.
- [x] Goals, Tasks, Calendar, Routines, Focus, and reports immediately observe
      the empty database without restarting the app.
- [x] Theme, language, typography, profile, timer preferences, exported
      backups, and exported reports are retained.
- [x] Failures do not show a success message and remain recoverable.
- [x] The implementation remains offline-first and adds no package or schema
      migration.

Verification evidence on 2026-08-11:
- `flutter analyze` passed and the full 247-test suite passed.
- Persistence coverage populated and cleared all 12 unified tables, retained
  schema version 5, and passed `PRAGMA foreign_key_check`.
- Widget coverage verified cancellation, disabled confirmation, and Spanish
  and English confirmation copy.
- The release APK was installed on RMX3301 and the card, dialog, typed
  confirmation, and enabled destructive state were inspected in portrait.
  The physical destructive action was cancelled to preserve device data.
