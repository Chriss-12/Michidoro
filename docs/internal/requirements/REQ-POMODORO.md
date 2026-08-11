# Pomodoro requirements

Statuses remain below `Verified` until implementation and verification evidence exist.

### REQ-POMO-001 - Start focus session

Status: Verified

Objective:
Allow users to start a focus timer.

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
- [x] The user can start a focus timer from the Pomodoro screen.
- [x] The implementation uses `PomodoroController` with `signals_flutter` state and keeps session history offline-first.
- [x] Required checks passed before moving to `Verified`: build runner generation, `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04.
- Implemented with repository-backed `PomodoroController`.
- Verification evidence: `flutter analyze` passed; full `flutter test` passed with 25 total tests.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-POMO-002 - Pause session

Status: Verified

Objective:
Allow users to pause an active session.

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
- [x] The user can pause an active Pomodoro session.
- [x] Pausing preserves the remaining timer state without writing incomplete session history.
- [x] Required checks passed before moving to `Verified`: `flutter analyze` and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04.
- Verification evidence: `PomodoroController` tests cover pause behavior.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-POMO-003 - Reset session

Status: Verified

Objective:
Allow users to reset the current session.

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
- [x] The user can reset the current Pomodoro session.
- [x] Reset restores the configured focus duration and does not save incomplete history.
- [x] Required checks passed before moving to `Verified`: `flutter analyze` and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04.
- Verification evidence: `PomodoroController` tests cover reset behavior.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-POMO-004 - Complete session

Status: Verified

Objective:
Record a completed Pomodoro session outcome.

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
- [x] A finished Pomodoro session is recorded as a completed session outcome.
- [x] Completion updates session count and total focus seconds from repository-loaded state.
- [x] Required checks passed before moving to `Verified`: build runner generation, `flutter analyze`, and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04.
- Verification evidence: controller and repository tests cover session completion.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-POMO-005 - Configure focus, break, and atmosphere settings

Status: Verified

Objective:
Allow configurable focus/break durations and Pomodoro atmosphere settings.

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
- [x] The user can configure focus duration, short break duration, long break duration, long break frequency, and atmospheric Pomodoro settings from timer settings.
- [x] Focus duration changes update the active Pomodoro timer plan when the timer is stopped.
- [x] Supported ranges are enforced: focus 5-90 minutes, short break 1-20 minutes, long break 5-45 minutes, long break frequency 3-5 sessions.
- [x] Atmospheric settings expose the completion sound and environment preview without a separate emphasis color selector.
- [x] Required checks passed before moving to `Verified`: `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04.
- Implemented through `PomodoroTimeControls`, `AppSettingsController`, and `PomodoroController.setFocusMinutes`.
- 2026-07-18 V3-M0 update: focus settings now allow a 5-minute minimum, and
  task-start presets include a dedicated 1-minute focus / 20-second break test
  mode.
- Atmospheric settings live in `PomodoroTimeControls` under `_AtmosphereCard`.
- The emphasis color selector was removed from atmospheric settings after user clarification.
- Verification evidence: settings and Pomodoro controller tests passed; full `flutter test` passed with 29 total tests.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-POMO-006 - Save session history later

Status: Verified

Objective:
Persist session history locally when approved.

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
- [x] Completed Pomodoro sessions are stored in a local Drift/SQLite table.
- [x] Session history loads through a domain repository contract.
- [x] Required checks passed before moving to `Verified`: build runner generation, `flutter analyze`, and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04.
- Implemented with `PomodoroSessionsDatabase`, `PomodoroSessionsDao`, `DriftPomodoroSessionsRepository`, and generated `pomodoro_sessions_database.g.dart`.
- 2026-07-10 update: completed sessions can store an optional `goalId` for
  verified goal progress links.
- Verification evidence: `flutter test test/features/pomodoro` passed with 6 tests; full `flutter test` passed with 25 total tests.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-POMO-007 - Select and preview completion feedback

Status: Verified

Objective:
Allow users to choose and preview Pomodoro completion sound and vibration feedback.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The user can choose a completion sound from atmospheric Pomodoro settings.
- [x] The user can preview the selected completion sound before saving or leaving the screen.
- [x] The user can enable or disable completion vibration from Settings notifications.
- [x] The user can preview completion vibration from the same Settings control.
- [x] The selected sound and vibration preference are stored in local app state.
- [x] A selected non-silent sound plays and enabled vibration runs when a Pomodoro session completes.
- [x] The implementation remains offline-first and does not add new dependencies.
- [x] Required checks passed before moving to `Verified`: `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04 as `M4.1`.
- Completion sound uses local Flutter/native playback. Android completion
  vibration uses the physical motor through `Vibrator`/`VibrationEffect`; other
  platforms retain Flutter haptics as a fallback.
- Available options: `Campana suave`, `Toque breve`, and `Silencio`.
- Completion vibration is enabled by default and can be disabled from Settings.
- V7-M2 moved vibration ownership out of Focus without changing the existing
  state, feedback behavior, or local JSON key.
- V7-M2.1 added four native Android timing/amplitude patterns and the normal
  `VIBRATE` permission without adding a dependency or changing SQLite.
- Verification evidence: targeted settings/controller tests passed; full `flutter test` passed.
