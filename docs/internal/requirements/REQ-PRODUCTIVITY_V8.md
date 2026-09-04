# Productivity V8 requirements

Status:
V8-M0 verified on 2026-07-31.

## Scope

V8 introduces a first-run onboarding sequence after the existing splash. It
explains Michi Focus's current offline-first workflow without changing
Pomodoro, task, reporting, synchronization, or database behavior.

### REQ-V8-001 - First-run onboarding

Status: Verified

Objective:
Show a short, skippable introduction only on a fresh installation and remember
completion locally before entering Home.

Checklist:
- [x] Requirement approved
- [x] UI implemented
- [x] Routing implemented
- [x] State and Settings JSON persistence implemented
- [x] Existing-install migration verified
- [x] Checks passed
- [x] Android inspection passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The existing splash remains the brief loading experience on every launch.
- [x] A fresh installation routes `Splash -> Onboarding -> Home`.
- [x] A returning installation routes `Splash -> Home`.
- [x] Four concise pages explain complete planning, adaptive focus,
      local/encrypted multi-device data, and reporting/dictation/personalization.
- [x] Every page exposes a visible `Omitir` / `Skip` action.
- [x] Navigation provides progress, back, continue, and a final start action.
- [x] Skip and finish persist completion before opening Home.
- [x] Completion survives process restart and onboarding does not replay.
- [x] An installation with an existing Settings JSON but no onboarding marker
      is treated as already onboarded.
- [x] The versioned marker is stored in `michidoro-settings.json`; SQLite,
      Android Gradle, packages, permissions, and user productivity data remain
      unchanged.
- [x] Spanish/English, text scaling, semantics, and supported mobile layouts are
      covered without clipping or overlap.
- [x] Header, cards, controls, text, icons, and illustrations resolve through
      the active palette in both light and dark themes.

Non-goals:
- Account creation, configuring synchronization or Android permissions,
  paywall, or analytics collection.
- Replacing the launcher/native splash.
- Replaying onboarding after ordinary copy or visual updates.

Maintenance verification:
- [x] On 2026-08-31 the four pages were refreshed for tasks, goals, routines,
      notes, weekly planning, remaining-time focus, maximum concentration,
      optional Android silence, encrypted Syncthing exchange, conflict review,
      reports, PDF export, dictation, and current theme controls.
- [x] Five focused onboarding tests, four regenerated visual baselines, selected
      light/dark palette coverage, and the complete 489-test suite passed.
