# Productivity V3 requirements

Status:
Proposed. These requirements capture the next product ideas and must be
approved before implementation.

## Summary

Productivity V3 focuses on faster Pomodoro testing, clearer goal/task progress,
profile-aware settings, notification control, focus reflections, richer
analytics, professional reports, and launch polish.

### REQ-V3-001 - Flexible Pomodoro presets and test mode

Status: Verified

Objective:
Allow shorter Pomodoro configurations, including a 5-minute Pomodoro and a
1-minute focus / 20-second break preset for fast validation.

Checklist:
- [x] Requirement approved.
- [x] Timer preset UX planned.
- [x] Focus/break duration limits reviewed.
- [x] State and persistence changes planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] The user can start a 5-minute Pomodoro.
- [x] The user can start a 1-minute focus block followed by a 20-second break.
- [x] The test preset is clearly separated from normal productivity presets.
- [x] The feature does not require waiting for the default 25-minute cycle during validation.

Notes:
- Implemented on 2026-07-18.
- Normal timer settings support a 5-minute minimum focus duration.
- The 1-minute / 20-second flow is implemented as a dedicated test preset with
  second-level runtime durations, without forcing all Settings preferences to
  switch to seconds.
- Verification evidence: `dart format` ran on modified files; focused
  Settings/Pomodoro/widget tests passed; `flutter analyze` passed; full
  `flutter test` passed with 67 tests.

### REQ-V3-002 - Planning navigation and objective actions

Status: Verified

Objective:
Make `Home -> Planificacion` navigation and objective actions predictable.

Checklist:
- [x] Requirement approved.
- [x] Navigation behavior planned.
- [x] Objective action menu planned.
- [x] UI tests planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] Pressing back from `Home -> Planificacion` returns to Home instead of exiting the app.
- [x] Objective actions are accessible from a three-vertical-dots menu.
- [x] The menu exposes the expected actions without crowding the objective row.
- [x] Navigation keeps the app shell stable.

Notes:
- Implemented on 2026-07-18.
- Home now opens Planning with route push behavior so the Android/system back
  action returns to Home.
- Planning objective edit/delete actions are grouped under `Opciones de objetivo`.
- Verification evidence: `dart format` ran on modified files; widget navigation
  test passed; `flutter analyze` passed; full `flutter test` passed with 67 tests.

### REQ-V3-003 - Goals active metrics by rows

Status: Verified

Objective:
Show active goal progress as scan-friendly rows for completed, pending, in
progress, and related task totals.

Checklist:
- [x] Requirement approved.
- [x] Goals summary rows planned.
- [x] Task status mapping reviewed.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] `Goals -> Metas activas` shows completed tasks in a row.
- [x] `Goals -> Metas activas` shows pending tasks in a row.
- [x] `Goals -> Metas activas` shows in-progress tasks in a row.
- [x] Row labels and values remain readable on mobile.

Notes:
- Implemented on 2026-07-18.
- Each active goal now shows pending, in-progress, and completed task counts as
  separate scan-friendly rows.
- Verification evidence: `dart format` ran on modified files; widget test
  passed; `flutter analyze` passed; full `flutter test` passed with 67 tests.

### REQ-V3-004 - Profile identity and typography settings

Status: Verified

Objective:
Turn Settings profile fields into real app identity preferences and offer
multiple typography styles.

Checklist:
- [x] Requirement approved.
- [x] Profile fields planned.
- [x] Profile photo storage planned.
- [x] Typography options planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] The user can edit their display name.
- [x] The user can edit their email address.
- [x] The user can select a profile photo locally.
- [x] The top-right profile area shows the selected identity.
- [x] Settings includes typography choices grouped as `moderna`, `serio`, and `normal`.
- [x] The selected typography persists locally.

Notes:
- Implemented on 2026-07-18.
- Profile name, email, selected local image path, avatar choice, and typography
  preset persist in the local Settings JSON.
- 2026-07-18 added an in-app local image picker for accessible image files, so
  Settings no longer requires typing the photo path manually.
- Verification evidence: `dart format lib test` passed; focused
  Settings/widget tests passed; `flutter analyze` passed; full `flutter test`
  passed with 76 tests.

### REQ-V3-005 - Report folder and database backup picker

Status: Verified

Objective:
Make report export paths and database import/export usable through folder
selection instead of manual path entry.

Checklist:
- [x] Requirement approved.
- [x] Report folder picker planned.
- [x] Database export flow planned.
- [x] Database import flow planned.
- [x] Local file safety rules planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] `Settings -> Reportes` lets the user choose a folder through a picker.
- [x] `Settings -> Reportes` lets the user use Downloads/default output.
- [x] `Home -> Descargar estadisticas` writes to the configured report folder.
- [x] Settings exposes database export for backup.
- [x] Settings exposes database import for restore.
- [x] Database import/export uses folder selection, not manual-only typing.

Notes:
- 2026-07-18 implemented database export to a `michifocus-backup` folder under
  the configured Reports folder or Downloads/default folder.
- 2026-07-18 added an in-app local folder picker for accessible folders. No new
  picker dependency was added.
- `Settings -> Reportes` now lets the user select a report folder, reset to
  Downloads/default, export a `michifocus-backup` folder, and import from a
  selected backup folder.
- Database import is staged and applied on next app startup before Drift
  databases open, avoiding hot replacement of active SQLite files.
- Verification evidence: `dart format lib test` passed; `flutter analyze`
  passed; focused backup import tests passed; full `flutter test` passed with
  76 tests.

### REQ-V3-006 - Notification tones, test notification, and notification center

Status: Verified

Objective:
Let the user configure notification sound behavior, test notifications, and
review accumulated notifications from the top-right area.

Checklist:
- [x] Requirement approved.
- [x] Notification tone choices planned.
- [x] Test notification behavior planned.
- [x] Scheduled task notification flow planned.
- [x] Notification center routing planned for route-backed in-app notifications.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] Settings lets the user select a notification tone.
- [x] Settings includes a test button that triggers a notification with sound.
- [x] Scheduled tasks can notify the user with the selected sound while the app is open.
- [x] Notifications accumulate in a top-right dropdown.
- [x] Opening a notification routes the user to the relevant planning context.

Notes:
- 2026-07-18 implemented the in-app notification center slice.
- Settings now exposes notification tone selection and a test notification
  button using the existing local `SystemSound`/haptic feedback behavior.
- Test notifications accumulate in the top-right dropdown and open
  `Settings -> Notificaciones` when tapped.
- 2026-07-18 added in-app scheduled task reminders for pending tasks planned
  for today. The reminder uses the selected local sound/haptic feedback,
  accumulates in the top-right notification dropdown, avoids duplicate
  reminders for the same task/day, and opens `Calendario` for planning context.
- Background/system reminders while the app is closed remain a future native
  enhancement because the project currently has no approved native local
  notification dependency.
- Verification evidence: `dart format lib test` passed; `flutter analyze`
  passed; focused scheduled reminder tests passed; full `flutter test` passed
  with 74 tests.

### REQ-V3-007 - Focus mood and distraction reflection

Status: Verified

Objective:
Capture how the user feels before and after focus, and whether distractions
affected the session, without asking for a written justification.

Checklist:
- [x] Requirement approved.
- [x] Reflection prompt UX planned.
- [x] Focus reflection persistence planned.
- [x] Analytics mapping planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] On app start or focus start, the user can rate how well they feel on a scale.
- [x] On Pomodoro completion, the user can rate how well they feel on a scale.
- [x] On Pomodoro completion, the app asks whether the user was distracted.
- [x] If distracted, the app asks for approximate distraction minutes.
- [x] If everything went well, the user can mark the session as distraction-free.
- [x] No `distraction_note` or written justification is required.

Notes:
- Implemented on 2026-07-18.
- Starting Focus now asks for a 1-to-5 mood score.
- Completed Pomodoro sessions show a Focus reflection card with final mood,
  distracted/all-good choice, and approximate distraction minutes only when
  distracted.
- Reflection data is stored on the completed Pomodoro session as structured
  fields: `startMoodScore`, `endMoodScore`, `wasDistracted`, and
  `distractionMinutes`.
- No written distraction note field was added.
- Verification evidence: `build_runner` regenerated Pomodoro sessions Drift
  code; `dart format lib test` passed; `flutter analyze` passed; focused
  Pomodoro tests passed; full `flutter test` passed with 69 tests.

### REQ-V3-008 - Performance dashboard range and chart controls

Status: Verified

Objective:
Upgrade Home performance analytics with one shared time selector and optional
chart visibility.

Checklist:
- [x] Requirement approved.
- [x] Shared range selector planned.
- [x] Chart list planned.
- [x] Hide/show chart settings planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] `Home -> Rendimiento` supports day, week, month, and year.
- [x] The performance title changes to match the selected range.
- [x] One selector controls all performance charts.
- [x] The dashboard can include donut/circular charts.
- [x] The dashboard can include stacked and grouped bar charts.
- [x] The dashboard can include horizontal bar charts.
- [x] The dashboard can include standard bar and basic x/y charts.
- [x] The user can hide or show specific charts.

Notes:
- Implemented on 2026-07-18.
- Home now uses one unified performance dashboard with day/week/month/year
  ranges.
- The range selector controls all visible charts and updates the `Rendimiento`
  title.
- The dashboard includes circular, stacked bar, grouped bar, horizontal bar,
  standard bar, and basic x/y chart views.
- Chart visibility can be toggled from the dashboard. Report inclusion based on
  selected charts was connected and verified under `REQ-V3-009`.
- Verification evidence: `dart format lib test` passed; `flutter analyze`
  passed; widget test passed; full `flutter test` passed with 69 tests.

### REQ-V3-009 - Professional reports from selected analytics

Status: Verified

Objective:
Generate polished reports that respect the selected report folder, selected
chart visibility, and profile identity.

Checklist:
- [x] Requirement approved.
- [x] Report data contract planned.
- [x] Chart inclusion rules planned.
- [x] Profile identity in report planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] Reports are saved to the configured report folder or Downloads/default.
- [x] Reports include only charts enabled by the user.
- [x] Reports include the configured user name.
- [x] Reports include the configured user email.
- [x] Reports look professional and are suitable to share.

Notes:
- Implemented on 2026-07-18.
- Dashboard chart visibility is now stored in local settings and keeps at least
  one chart enabled.
- `Home -> Descargar estadisticas` supports day, week, month, year, and custom
  range exports.
- The PDF uses the configured report folder/default Downloads location and
  includes profile name, profile email, selected chart sections, task status,
  focus totals, calendar trend, and a recommendation block.
- Verification evidence: `dart format lib test` passed; `flutter analyze`
  passed; full `flutter test` passed with 71 tests.

### REQ-V3-010 - Profile quick stats panel

Status: Verified

Objective:
Show a compact statistics panel when the user taps the profile photo.

Checklist:
- [x] Requirement approved.
- [x] Profile stats panel planned.
- [x] Mood summary planned.
- [x] Motivational phrase rules planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] Tapping the profile photo opens quick stats.
- [x] The panel supports day, month, and year views.
- [x] The panel shows how well the user has felt.
- [x] The panel shows pending, in-progress, and completed tasks.
- [x] The panel shows a motivational phrase based on the mood result.

Notes:
- Implemented on 2026-07-18.
- Tapping the profile avatar opens a quick stats panel.
- The panel supports day, month, and year views.
- Mood is calculated from completed Pomodoro reflection scores in the selected
  range.
- Task counts are calculated from local tasks in the selected range.
- The motivational phrase changes according to the mood average.
- Verification evidence: `dart format lib test` passed; `flutter analyze`
  passed; widget test passed; full `flutter test` passed with 69 tests.

### REQ-V3-011 - Launch visual polish

Status: Verified

Objective:
Remove the unattractive square logo moment during app startup and keep the
approved MichiDoro cat emblem consistent across native and Flutter launch views.

Checklist:
- [x] Requirement approved.
- [x] Native launch assets reviewed.
- [x] Current cat emblem protected from unrelated changes.
- [x] Android launch verification planned.
- [x] Checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] The initial native launch shows the approved circular cat emblem without
  the white square logo card.
- [x] The launch view uses the same visual background style as the current loading screen.
- [x] The Flutter launch view shows the animated numeric loading percentage.
- [x] The in-app launch view keeps the cat, circular ring, clock, ruler, app
  name, and tagline.
- [x] The installed Android launcher icon uses the same circular cat emblem.

Notes:
- Implemented on 2026-07-18.
- Android native launch backgrounds now use the loading-screen gradient style
  and no longer reference the centered launch image.
- `SplashPage` was intentionally left unchanged, preserving the current in-app
  loading screen and progress animation.
- Verification evidence: native launch XML reviewed; `dart format lib test`
  passed; `flutter analyze` passed; full `flutter test` passed with 71 tests.
- Refined on 2026-07-20 after user approval: Android launch resources now show
  `launch_image.png` centered over the gradient instead of the white square
  text card and Android 12 uses the same cat emblem. An intermediate revision
  omitted the numeric percentage; the final preference below restores it.
- Refinement verification: focused widget test passed, `flutter analyze`
  passed, full `flutter test` passed with 76 tests, and the debug APK built
  successfully with the locally installed JDK 17.
- Final user preference confirmed on 2026-07-20: the animated percentage was
  restored below the cat emblem. All Android launcher density assets now use
  the same `launch_image.png` cat, circle, clock, and ruler mark instead of the
  text-only MichiDoro card.
- Final verification: `dart format` passed, `flutter analyze` passed, full
  `flutter test` passed with 76 tests, launcher assets were visually inspected,
  and the debug APK built successfully with the locally installed JDK 17.
