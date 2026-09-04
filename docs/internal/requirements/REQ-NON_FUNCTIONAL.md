# Non-functional requirements

Statuses remain `Proposed` until user approval and verification evidence exist.

### REQ-NFR-001 - Offline-first behavior

Status: Proposed

Objective:
The app must work without backend or internet dependency.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-NFR-002 - App performance

Status: Implemented

Objective:
Keep UI responsive and avoid unnecessary rebuilds.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Home and Settings scroll performance is tracked as a first-class milestone.
- [x] Color-theme selection avoids a multi-frame global transition across
      retained inactive tabs.
- [x] App-level signal rebuilds do not unnecessarily rebuild `MaterialApp.router` during timer or settings updates.
- [ ] Home and Settings should scroll smoothly on high-end Android hardware such as Samsung Galaxy S23 Ultra.
- [ ] Required checks before moving to `Verified`: `flutter analyze`, full `flutter test`, and manual/profile-mode scroll verification on Android.

Notes:
- 2026-09-03: The persistent indexed tab shell amplified Flutter's default
  whole-app theme animation because every retained themed branch repainted on
  each transition frame. Theme selection now applies with one immediate update;
  local persistence remains asynchronous.
- The debug APK compiled with Java 17 and installed and launched successfully
  on the Realme RMX3301 without clearing local data. Physical theme-switch
  timing remains a user-visible confirmation rather than an automated claim.
- Captured after user reported repeated scroll jank in Home and Settings on a Samsung Galaxy S23 Ultra.
- Initial code review found the app-level `SignalBuilder` wrapping `MaterialApp.router` while reading frequently changing signals, including Pomodoro timer state.
- M11 implementation reduced rebuild scope so `MaterialApp.router` depends only on theme-related signals; high-frequency app/timer signals now rebuild the scoped route content.
- Verification evidence so far: `dart format lib test`, `flutter analyze`, and full `flutter test` passed.
- 2026-07-05 verification refresh: `flutter analyze` passed and full `flutter test` passed with 34 total tests.
- 2026-07-05 Android verification attempt: `adb devices` returned no connected devices, so manual/profile scroll verification remains pending.
- Device/profile verification is still required before this requirement can become `Verified`.

### REQ-NFR-003 - Local data privacy

Status: Proposed

Objective:
Keep user productivity data local unless a future approved requirement says otherwise.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-NFR-004 - Maintainability

Status: Proposed

Objective:
Keep code and docs structured for small, reviewable changes.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-NFR-005 - Accessibility basics

Status: Proposed

Objective:
Support readable text, semantic controls, and responsive layouts.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-NFR-006 - Linting/quality

Status: Proposed

Objective:
Respect very_good_analysis and required checks.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-NFR-007 - No backend dependency

Status: Proposed

Objective:
Do not introduce Firebase, Supabase, backend services, or internet-required features.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-NFR-008 - Android APK installability and launch stability

Status: Proposed

Objective:
Ensure the generated Android APK can be installed on the target Android device and launched without closing immediately.

Checklist:
- [x] Requirement captured
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] The APK build command succeeds for the intended variant.
- [ ] The generated APK installs successfully on the target Android device.
- [ ] The installed app opens past the native splash/first frame and remains running on the target Android device.
- [ ] The root cause of the install or launch failure is documented with the exact Android error or `adb logcat` crash trace.
- [ ] Any required Android configuration change is reviewed before editing Gradle or manifest files.
- [ ] Required checks before moving to `Verified`: `flutter analyze`, `flutter test`, APK build, installation verification, and launch verification on Android.

Notes:
- Captured after user reported that the generated APK does not install on Android.
- Expanded after user clarified that the app opens and exits immediately.
- Implementation is pending diagnosis; the exact install error or launch crash trace from the device is still needed.
- Do not modify Android Gradle until the failure is reproduced or the user provides the exact error/log.

### REQ-NFR-009 - Stability and performance regression audit

Status: In Progress

Objective:
Review the app for stability issues, slowdowns, unnecessary rebuilds, expensive
UI work, persistence bottlenecks, and regressions that could make the app feel
buggy or slow during normal use.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Review route-level rebuild scope for Home, Focus, Planning, Tasks, Goals, Settings, and Reports.
- [x] Review signal usage so high-frequency timer updates do not rebuild unrelated screens or router configuration.
- [x] Review expensive widgets, custom painters, charts, gradients, progress indicators, and large lists for avoidable repaint/layout work.
- [x] Review local persistence loading and mapping paths for unnecessary repeated reads or synchronous heavy work.
- [x] Run `flutter analyze` and full `flutter test`.
- [ ] When a device is available, run manual or profile-mode navigation/scroll/focus-session verification on Android.
- [x] Document every finding with severity, impacted screen, suspected cause, and fix plan.

Notes:
- This requirement is a planned audit, not a verified fix.
- The goal is to identify and remove bug-prone or performance-heavy paths before adding more feature work.
- Keep fixes small and trace each implemented fix back to this requirement or a follow-up requirement.
- 2026-07-14: First audit slice found that Pomodoro runtime values were still
  exposed through `AppSettingsScope`, so the active route could be notified by
  every timer tick even when the screen did not need timer data.
- 2026-07-14: Added `PomodoroRuntimeScope` and moved Pomodoro running state,
  phase, remaining seconds, current phase seconds, completed Pomodoros, focused
  seconds, and Pomodoro actions out of `AppSettingsScope`.
- 2026-07-14: `dart format` passed for modified Dart files, `flutter analyze`
  passed, focused Pomodoro/widget tests passed with 19 tests, and full
  `flutter test` passed with 65 tests.
- 2026-07-15: Focus page runtime dependencies were narrowed so per-second timer
  changes no longer rebuild the full Focus list; runtime-dependent sections are
  isolated to timer, controls, lifecycle actions, and stats.
- 2026-07-15: Home chart painters were wrapped in `RepaintBoundary`, and chart
  repaint checks now compare value/label contents rather than generated list
  identity.
- 2026-07-15: Local persistence load/mapping paths were reviewed across Tasks,
  Goals, Calendar events, Pomodoro sessions, and report export; no repeated
  normal-route database reads were found.
- 2026-07-15: `dart format` passed for the modified Focus file; the Home format
  attempt reported a workspace overwrite warning, so the small Home formatting
  adjustment was kept manual. `flutter analyze` passed and full `flutter test`
  passed with 65 tests. Android manual/profile verification is still required
  before moving this requirement to `Verified`.
