# Productivity V8 requirements

Status:
V8-M0 verified on 2026-07-31.

## Scope

V8 introduces a first-run onboarding sequence after the existing splash. It
explains MichiDoro's task-first workflow without changing Pomodoro, task,
reporting, or database behavior.

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
- [x] Four concise pages explain organization, intentional focus, measurable
      progress, and personalization.
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

Non-goals:
- Account creation, cloud sync, paywall, permissions, or analytics collection.
- Replacing the launcher/native splash.
- Replaying onboarding after ordinary copy or visual updates.
