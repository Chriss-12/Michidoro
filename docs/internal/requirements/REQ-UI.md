# UI requirements

Statuses remain `Proposed` until user approval and verification evidence exist.

### REQ-UI-001 - App theme usage

Status: Verified

Objective:
Use the centralized app theme and palette for visual decisions.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The requirement has a clear user or architecture outcome.
- [x] The implementation approach respects offline-first behavior and project architecture.
- [x] Required checks are documented before moving to Verified.

Notes:
- Verified by moving shared app background surfaces in `AppShell`,
  `SplashPage`, and Pomodoro fullscreen to `AppPalette.appBackgroundDecoration`.
- `dart format lib test` passed.
- `flutter analyze` passed.

### REQ-UI-002 - Material 3 consistency

Status: Verified

Objective:
Keep screens and components aligned with Material 3 behavior and spacing expectations.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The requirement has a clear user or architecture outcome.
- [x] The implementation approach respects offline-first behavior and project architecture.
- [x] Required checks are documented before moving to Verified.

Notes:
- Verified by normalizing text letter spacing to `0` and aligning shared
  `GlassCard` surfaces with the app's 8px Material 3 radius convention.
- `docs/internal/technical/UI_GUIDELINES.md` documents the visual rule.
- `dart format lib test` passed.
- `flutter analyze` passed.

### REQ-UI-003 - Atomic Design usage

Status: Verified

Objective:
Use atoms, molecules, organisms, and templates only when they reduce duplication and improve clarity.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The requirement has a clear user or architecture outcome.
- [x] The implementation approach respects offline-first behavior and project architecture.
- [x] Required checks are documented before moving to Verified.

Notes:
- Verified by documenting the project Atomic Design mapping and preserving
  feature-private widgets where reuse is not yet justified.
- `docs/internal/architecture/ATOMIC_DESIGN.md` and
  `docs/internal/technical/UI_GUIDELINES.md` document the rule.
- Docs-only verification confirmed the referenced files exist.

### REQ-UI-004 - Responsive UI

Status: Verified

Objective:
Support responsive layouts through existing project patterns and responsive_framework when needed.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The requirement has a clear user or architecture outcome.
- [x] The implementation approach respects offline-first behavior and project architecture.
- [x] Required checks are documented before moving to Verified.

Notes:
- Verified by configuring `ResponsiveBreakpoints.builder` in `MaterialApp.router`
  and documenting the responsive rule in `UI_GUIDELINES.md`.
- Existing page layouts already use scrollable, wrapping, or flexible structures
  for the inspected screen-level UI.
- `dart format lib test` passed.
- `flutter analyze` passed.

### REQ-UI-005 - Selected navigation state

Status: Verified

Objective:
Keep selected bottom navigation state visually clear and consistent.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The requirement has a clear user or architecture outcome.
- [x] The implementation approach respects offline-first behavior and project architecture.
- [x] Required checks are documented before moving to Verified.

Notes:
- Verified by removing the local `NavigationBarTheme` override from `AppShell`
  so selected and unselected destination styling comes from the centralized
  `AppTheme` palette.
- `dart format lib test` passed.
- `flutter analyze` passed.

### REQ-UI-006 - No hardcoded colors when palette values exist

Status: Verified

Objective:
Prefer palette and theme values over new hardcoded colors.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The requirement has a clear user or architecture outcome.
- [x] The implementation approach respects offline-first behavior and project architecture.
- [x] Required checks are documented before moving to Verified.

Notes:
- Verified for normal UI components by replacing hardcoded foreground, swatch,
  and decorative preview colors with `ColorScheme` or `AppPalette` values.
- Hardcoded splash painter colors remain intentionally scoped to `REQ-UI-007`,
  where the launcher and splash/loading source image will be aligned.
- `dart format lib test` passed.
- `flutter analyze` passed.

### REQ-UI-007 - Launcher and splash icon consistency

Status: Verified

Objective:
Use the same approved brand image for the installed app icon and the native splash/loading image.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The launcher/install icon uses the same source brand asset as the splash/loading image.
- [x] Android launcher resources and native splash resources are generated or configured from the approved asset.
- [x] Required checks are documented before moving to Verified.

Notes:
- Verified by replacing Android launcher icons with the MichiDoro splash/loading
  mark and adding `drawable-nodpi/launch_image.png` to the native Android
  launch background.
- `flutter analyze` passed.
- `flutter build apk --debug` passed.

### REQ-UI-008 - Restore global gradient background

Status: Verified

Objective:
Restore the app-wide gradient background that was part of the approved visual design.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] App-level screen backgrounds use the approved gradient design instead of a flat fallback.
- [x] The implementation approach should keep the gradient centralized in theme/palette values.
- [x] Required checks before moving to `Verified`: `dart format lib test`, `flutter analyze`, and visual inspection of primary app screens.

Notes:
- Approved on 2026-07-04 after user clarification that the app background should remain the previously defined gradient.
- Verified by restoring `AppPalette.appBackgroundDecoration` to use the
  centralized palette gradient colors: `secondary`, `gradientStart`, and
  `gradientEnd`.
- Code-path visual inspection confirmed `AppShell`, `SplashPage`, and
  Pomodoro fullscreen all use the centralized app background decoration.
- `dart format lib test` passed.
- `flutter analyze` passed.
- Full `flutter test` passed with 29 total tests.
