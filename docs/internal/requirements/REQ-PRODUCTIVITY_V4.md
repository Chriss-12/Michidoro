# Productivity V4 requirements

Status:
Proposed. These requirements capture native-device enhancements and must be
approved before implementation because they may require new packages, Android
permission changes, and device validation.

## Summary

Productivity V4 focuses on turning the current in-app/local behavior into a
more native Android experience where useful: system notifications while the app
is closed, native file/folder/image selection, and release/device validation.
The app remains offline-first and local-first.

### REQ-V4-001 - Native dependency and permission decision record

Status: Proposed

Objective:
Define which native capabilities are allowed before changing dependencies,
Android manifests, or platform configuration.

Checklist:
- [ ] Requirement approved.
- [ ] Native notification dependency decision documented.
- [ ] Native file/folder picker dependency decision documented.
- [ ] Android permissions reviewed.
- [ ] Offline-first and local privacy impact reviewed.
- [ ] Checks selected.
- [ ] Documentation updated.
- [ ] Traceability updated.

Acceptance criteria:
- [ ] The selected native packages, if any, are explicitly listed.
- [ ] Required Android permissions are documented before implementation.
- [ ] Rejected native options are documented with a short reason.
- [ ] The app remains offline-first and does not introduce backend services.
- [ ] V4 implementation milestones reference this decision.

Notes:
- This should be the first V4 milestone.
- No native dependency or Android Gradle change should happen until this is
  approved.

### REQ-V4-002 - System scheduled task notifications

Status: Proposed

Objective:
Notify the user about scheduled tasks through Android/system notifications even
when the app is closed, while preserving the existing in-app notification center.

Checklist:
- [ ] Requirement approved.
- [ ] Local notification scheduling planned.
- [ ] Permission request UX planned.
- [ ] Notification tap routing planned.
- [ ] Duplicate notification rules planned.
- [ ] Checks passed.
- [ ] Documentation updated.
- [ ] Traceability updated.

Acceptance criteria:
- [ ] Scheduled tasks can create system notifications when the app is closed.
- [ ] Notification tone selection is respected when supported by the platform.
- [ ] Tapping a system notification opens the relevant app context.
- [ ] In-app notifications continue to accumulate in the top-right dropdown
  while the app is open.
- [ ] Duplicate reminders for the same task/day are avoided.
- [ ] The feature works offline and does not require a server.

Notes:
- V3-M3 already verified in-app reminders while the app is open.
- This V4 requirement covers background/system delivery only.

### REQ-V4-003 - Native file, folder, and image selectors

Status: Implemented

Objective:
Replace or enhance the current in-app local selectors with native platform
pickers for profile images, report folders, and database backup import/export
when an approved dependency or platform approach is selected.

Checklist:
- [x] Requirement approved.
- [x] Profile image picker planned.
- [x] Report folder picker planned.
- [x] Backup import/export picker planned.
- [x] Permission and scoped-storage behavior reviewed.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [ ] Profile photo can be selected through a native image/file picker.
- [ ] Profile photo selection is launched from `Settings -> Perfil` and opens
  the Android gallery or system file picker instead of an in-app file browser.
- [ ] Report output folder can be selected through a native folder picker or
  approved platform-safe equivalent.
- [ ] `Settings -> Reportes` opens an external folder picker when selecting the
  report output folder.
- [ ] Database backup import/export uses a native folder/file flow where
  supported.
- [ ] Backup import from `Settings -> Reportes` opens an external file/folder
  picker instead of requiring in-app path navigation.
- [ ] Backup export from `Settings -> Reportes` clearly states the destination
  folder before or immediately after exporting.
- [ ] Existing in-app selector fallbacks remain available when native selection
  is unavailable.
- [ ] File access failures are shown with clear user-facing messages.

Notes:
- V3-M2 already verified in-app selectors without adding dependencies.
- This requirement should preserve the current no-manual-path experience.
- 2026-07-19: Implemented through an Android platform channel using system
  gallery/file/folder intents, with the existing in-app selectors preserved as
  fallback. No package, backend, Gradle, or manifest permission change was
  added.
- Verification completed so far: `dart format lib test`, `flutter analyze`,
  focused `app_settings_controller` tests, full `flutter test` with 76 tests,
  and debug APK build. Android device smoke validation remains pending before
  moving to `Verified`.

### REQ-V4-004 - Android APK and device validation

Status: Proposed

Objective:
Build, install, and validate the app on the target Android device so release
delivery is based on actual device behavior, not only local tests.

Checklist:
- [ ] Requirement approved.
- [ ] Debug or release APK build path selected.
- [ ] Target device connected and detected.
- [ ] Install flow verified.
- [ ] Launch flow verified.
- [ ] Key user flows smoke-tested on device.
- [ ] Documentation updated.
- [ ] Traceability updated.

Acceptance criteria:
- [ ] APK builds successfully with the selected build type.
- [ ] APK installs successfully on the target Android device.
- [ ] App launches without immediate exit.
- [ ] Home, Planning, Focus, Settings, Reports, and Notifications smoke tests
  pass on device.
- [ ] Any device-specific permission issue is documented or fixed.

Notes:
- This requirement can also close older device-validation notes once verified.

### REQ-V4-005 - Executive PDF reports backed by SQLite

Status: Verified

Objective:
Generate shareable executive PDF reports in US Letter format from the current
local SQLite data at export time.

Checklist:
- [x] Requirement approved by the user.
- [x] Report source and output contract planned.
- [x] Executive header, reporting date, and statistics planned.
- [x] US Letter page size planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] Every report exported from Settings is a PDF in US Letter size.
- [x] The PDF shows the configured profile name, reporting period, generated
  date, and task/Pomodoro statistics.
- [x] Task and Pomodoro totals are loaded from the unified SQLite repositories
  at export time, not from default or stale UI counters.
- [x] The selected chart visibility rules remain respected.
- [x] The report remains offline-first and is saved in the configured report
  destination or the default Downloads location.

Notes:
- 2026-07-21: User approved this corrective report slice after the report
  audit found that the plain-text export used controller counters and the PDF
  used loaded controller snapshots.
- 2026-07-21: `flutter analyze` passed and the full `flutter test` suite passed
  with 77 tests. The PDF test verifies the configured name, generated date,
  chart selection, and `/MediaBox [0 0 612 792]` US Letter page size.
