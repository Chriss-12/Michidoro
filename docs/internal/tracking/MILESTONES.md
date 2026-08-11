# Milestones

## Active roadmap - Productivity V2

Status:
This roadmap supersedes the legacy milestones below. Legacy milestones are kept
only as historical implementation evidence and should not drive new work.

Priority rule:
Implement from V2-M0 to V2-M11 unless the user explicitly reprioritizes. Each
milestone should be split into small slices before coding.

### V2-M0 - Stabilize Calendar and Planning Runtime

Priority: 0

Status: Verified

Objective:
Remove remaining runtime crashes and make `Home -> Planificacion` stable before
adding more product behavior.

Why first:
The calendar/planning path is now the center of the app. If it crashes, every
later milestone becomes hard to validate.

Grouped scope:
- Calendar navigation stability.
- Dialog/controller lifecycle stability.
- Planning page rebuild scope.
- Regression tests for entering Calendar, opening dialogs, and returning to Home.

Deliverables:
- [x] Calendar opens without `_dependents.isEmpty`, dirty build scope, or disposed controller errors in widget regression coverage.
- [x] Planning dialogs do not dispose controllers while routes are closing.
- [x] Calendar data loads without mutating signals during route build.
- [x] Widget test covers the calendar entry path and opens/closes planning dialogs.

Verification:
- 2026-07-10: `dart format lib test` passed.
- 2026-07-10: `flutter analyze` passed.
- 2026-07-10: `flutter test` passed with 44 tests.

Tracks:
- `REQ-V2-001`

### V2-M1 - Goal-First Planning Model

Priority: 1

Status: Verified

Objective:
Make `Home -> Planificacion` the main place to create objectives for a calendar
day/month, without asking for Pomodoro counts.

Why now:
This is the product foundation the rest depends on: objectives own planned work.

Grouped scope:
- Create objective from selected calendar date.
- Rename objective.
- Delete objective with 3-second undo.
- Remove Pomodoro-count-first goal creation from the planning flow.

Deliverables:
- [x] Objective creation asks only for objective name.
- [x] Objective belongs to selected calendar day.
- [x] Objective can be renamed.
- [x] Objective can be deleted with undo.
- [x] Deleting an objective has a clear rule for its child tasks.

Verification:
- 2026-07-10: `dart format lib test` passed.
- 2026-07-10: `flutter analyze` passed.
- 2026-07-10: focused Goals/widget tests passed with 15 tests.
- 2026-07-10: `flutter test` passed with 46 tests.
- 2026-07-11: V2-M2 confirmed the child-task rule for deleted objectives: tasks are detached from the deleted objective, not deleted; undo restores affected task links.
- 2026-07-11: `dart format lib test`, `flutter analyze`, focused Tasks/widget tests, and full `flutter test` passed with 52 tests.

Tracks:
- `REQ-V2-001`

### V2-M2 - Unified Task Model

Priority: 2

Status: Verified

Objective:
Unify quick tasks and planned tasks so every task can be listed, scheduled,
assigned to a goal, and tracked by status.

Why now:
Tasks are the unit of work. Pomodoro, Goals, Home metrics, Calendar colors, and
PDF reports all depend on task status and assignment.

Grouped scope:
- Quick tasks from `Tasks`.
- Planned tasks from `Home -> Planificacion`.
- Assign quick task to a date.
- Attach/detach task to objective.
- Task statuses: listed, in progress, completed.
- Rename/delete task with undo.

Deliverables:
- [x] Quick tasks can be created without date or objective.
- [x] Quick tasks can later be assigned to a date.
- [x] Planned tasks are created under a date and optionally under an objective.
- [x] Each task stores listed/in-progress/completed state.
- [x] Task status changes update local state immediately.

Verification:
- 2026-07-11: V2-M2 Slice 1 added task `status`, optional `scheduledDate`, and optional `goalId` to the domain, controller, repository, and Drift schema.
- 2026-07-11: `dart run build_runner build --delete-conflicting-outputs` regenerated Tasks Drift code.
- 2026-07-11: `dart format lib test`, `flutter analyze`, and `flutter test test/features/tasks` passed with 12 focused Tasks tests.
- 2026-07-11: Full `flutter test` passed with 49 tests.
- 2026-07-11: V2-M2 Slice 2 added planning UI to create and list selected-day tasks, optionally assign them to same-day objectives, and change task status from the agenda.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 49 tests after the planning UI slice.
- 2026-07-11: V2-M2 Slice 3 added planning UI for moving quick tasks to the selected day, editing task objective association, removing tasks from the selected day, and detaching tasks when their objective is deleted.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 52 tests.
- 2026-07-11: V2-M2 follow-up added direct task deletion from `Home -> Planificacion` and rechecked that only `Tasks` creates date-less quick tasks. `dart format lib test`, `flutter analyze`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 54 tests.

Tracks:
- `REQ-V2-002`

### V2-M3 - Start Focus From Task

Priority: 3

Status: Verified

Objective:
Let each task start a Pomodoro and carry its task/date/objective context into
`Focus` automatically.

Why now:
This connects planning to actual focus work without requiring the user to choose
the goal manually in Focus every time.

Grouped scope:
- `Empezar Pomodoro` action on quick and planned tasks.
- Default focus 25 min / break 5 min.
- Predefined focus duration selector.
- Predefined break count/duration selector.
- Auto-navigation to `Focus`.
- Auto-assignment to task and objective when available.

Deliverables:
- [x] Planned task starts Focus with task and objective preselected.
- [x] Quick task starts Focus without objective unless assigned.
- [x] User can choose predefined focus/break settings before starting.
- [x] Focus screen shows current task and objective context.

Verification:
- 2026-07-11: `Empezar Pomodoro` is available from quick and planned task UI.
- 2026-07-11: Starting from a task opens a predefined focus/break picker, applies the selected timer values, selects task/goal context in Focus, and navigates to `Focus`.
- 2026-07-11: Focus shows the active task and objective context.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/pomodoro test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 54 tests.

Tracks:
- `REQ-V2-003`

### V2-M4 - Focus Lifecycle, Breaks, and Interruption Controls

Priority: 4

Status: Verified

Objective:
Make Focus correctly count real work time, breaks, interruption discard,
restart, and early completion.

Why now:
Statistics must be based on trustworthy focus sessions before building reports.

Grouped scope:
- Focus timer and break timer.
- Default/system completion sound.
- Discard interrupted session.
- Restart session from zero.
- Finish early and count actual focused time.
- Update task status from Focus.

Deliverables:
- [x] Break time is shown in Focus.
- [x] Break/focus completion triggers local/system feedback.
- [x] Discarded Pomodoro does not add focused time or progress.
- [x] Restart resets current task Pomodoro to zero.
- [x] Early finish records actual elapsed focus time.
- [x] Task can move to in progress or completed from Focus.

Verification:
- 2026-07-11: V2-M4 Slice 1 added Focus controls for discard, restart, and early finish, plus active-task status updates from Focus.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/pomodoro`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 57 tests.
- 2026-07-11: V2-M4 Slice 2 added focus/short-break/long-break phases, break countdown display in Focus, automatic break/focus settings, long-break frequency, and break completion feedback.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/pomodoro`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 59 tests.

Tracks:
- `REQ-V2-004`

### V2-M5 - Goal and Task Progress Dashboards

Priority: 5

Status: Verified

Objective:
Make Goals and Home show progress from task status, including tasks without
assigned objectives.

Why now:
Once tasks and focus sessions are connected, the app needs clear progress
feedback before advanced reports.

Grouped scope:
- Goal count.
- Objective list.
- Task counts per objective.
- Percentages per objective.
- Separate summary for tasks without goal.
- Home task totals: listed, in progress, completed.

Deliverables:
- [x] Goals shows total objective count.
- [x] Each objective shows task counts and completion percentage.
- [x] Unassigned tasks are summarized separately.
- [x] Home shows listed/in-progress/completed task totals.
- [x] Progress updates automatically when task status changes.

Verification:
- 2026-07-11: V2-M5 added reactive task status summaries, task-based objective progress in Goals, unassigned-task summary, and Home task status totals.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 60 tests.

Tracks:
- `REQ-V2-005`
- `REQ-V2-006`

### V2-M6 - Daily/Weekly Progress Colors and Calendar Heatmap

Priority: 6

Status: Verified

Objective:
Use task completion percentages to color Home weekly progress and Calendar
days.

Why now:
The color system depends on task status summaries from V2-M5.

Grouped scope:
- Daily task completion percentage.
- Red/yellow/green/strong-green thresholds.
- `Terminar dia` action.
- Calendar day color based on progress.
- Optional locked day result after ending a day.

Deliverables:
- [x] Red: no tasks or up to 20% completed.
- [x] Yellow: up to 50% completed.
- [x] Green: up to 70% completed.
- [x] Strong green: up to 100% completed.
- [x] Home weekly progress uses those colors.
- [x] Calendar days use those colors.
- [x] `Terminar dia` finalizes the day color.

Verification:
- 2026-07-11: V2-M6 added task progress bands, daily and weekly progress summaries, Home task-count chart by weekday, weekly progress colors, Calendar progress markers, and `Terminar dia`.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 62 tests.

Tracks:
- `REQ-V2-006`
- `REQ-V2-007`

### V2-M7 - Reports and PDF Export V2

Priority: 7

Status: Verified

Objective:
Export useful day/week/month/custom reports with calendar, charts, task status,
Pomodoro data, and coaching phrases.

Why later:
PDF should consume stable task, focus, and progress data instead of defining it.

Grouped scope:
- Report range selector: day/week/month/custom.
- Calendar snapshot in PDF.
- Charts for listed/in-progress/completed tasks.
- Total vs completed task summaries.
- Pomodoro count and focused minutes.
- Coaching phrases based on red/yellow/green result.

Deliverables:
- [x] PDF supports day, week, month, and custom date range.
- [x] PDF includes calendar and charts for selected range.
- [x] PDF includes listed, in-progress, and completed tasks.
- [x] PDF includes Pomodoro count and focused minutes.
- [x] PDF includes encouraging/reflection/improvement text.

Verification:
- 2026-07-11: V2-M7 exports reports from local Tasks and Pomodoro state instead of demo statistics.
- 2026-07-11: The Home statistics export selector supports day, week, month, and custom date range.
- 2026-07-11: Generated PDFs include a selected-range calendar snapshot, task status chart, Pomodoro/focus totals, task progress, and coaching text.
- 2026-07-11: `dart format lib test`, `flutter analyze`, and focused Settings/Tasks/Pomodoro/widget tests passed with 45 tests.

Tracks:
- `REQ-V2-008`

### V2-M8 - Monthly Performance Dashboard

Priority: 8

Status: Verified

Objective:
Make Home performance show monthly totals and general performance based on
tasks and completed Pomodoros.

Why last:
It is easiest once task status, Pomodoro sessions, and reports share the same
data model.

Grouped scope:
- Monthly task total.
- Monthly Pomodoro total.
- Monthly focused minutes.
- General performance calculation.

Deliverables:
- [x] Home performance shows tasks for current month.
- [x] Home performance shows Pomodoros for current month.
- [x] Home performance shows focused minutes from completed Pomodoros.
- [x] General performance uses task completion and focus data.

Verification:
- 2026-07-11: Home `Rendimiento` now filters tasks and Pomodoro sessions to the current month.
- 2026-07-11: The card shows monthly task totals/completions, completed Pomodoros, focused minutes, and general performance from task completion plus focus progress.
- 2026-07-11: `dart format lib test`, `flutter analyze`, widget test, and full `flutter test` passed with 64 tests.

Tracks:
- `REQ-V2-009`

### V2-M9 - Planning Task Creation Cleanup

Priority: 9

Status: Verified

Objective:
Make `Home -> Planificacion` use task-first creation copy and readable
selected-day task cards.

Why now:
The planning screen already creates and manages tasks, but event wording and
crowded task actions make the user workflow confusing.

Grouped scope:
- Rename planning creation copy from event/programming language to task language.
- Keep task title input separate from duration selection.
- Persist planned task duration separately from the title.
- Preserve optional objective selection.
- Move selected-day card actions below the date.
- Compact planned-task actions into one options menu.

Deliverables:
- [x] Planning creation says `Crear nueva tarea`.
- [x] The old `Tarea para X` copy is removed.
- [x] The old `Programar tarea` copy is removed.
- [x] Planned task duration is saved separately from the title.
- [x] Planned task cards show title, status, and objective clearly.
- [x] Planned task actions are grouped into one menu.
- [x] Flutter checks pass.

Verification:
- 2026-07-14: `dart run build_runner build --delete-conflicting-outputs` regenerated Drift code for Tasks schema version 3.
- 2026-07-14: `dart format lib test` passed.
- 2026-07-14: `flutter analyze` passed.
- 2026-07-14: `flutter test test/features/tasks test/widget_test.dart` passed.
- 2026-07-14: Full `flutter test` passed with 64 tests.

Tracks:
- `REQ-V2-010`

### V2-M10 - Task Focus-Minute Progress

Priority: 10

Status: Verified

Objective:
Show how much of a planned task's estimated duration has been completed through
focused Pomodoro minutes.

Why now:
Planning task duration is an estimate, while Pomodoro duration is the actual
focus block. The app should connect them without treating a 25-minute Pomodoro
as the whole task.

Grouped scope:
- Store active task id on completed Pomodoro sessions.
- Keep Pomodoro session duration separate from task estimated duration.
- Sum focused seconds per task.
- Show `focused/estimated` minutes and percentage on planning task cards.

Deliverables:
- [x] Pomodoro sessions persist nullable `task_id`.
- [x] Completed focus sessions from task context save `task_id`.
- [x] Planning task cards show focused minutes versus estimated task minutes.
- [x] Planning task cards show a progress bar and percentage.
- [x] Flutter checks pass.

Verification:
- 2026-07-14: `dart run build_runner build --delete-conflicting-outputs` regenerated Pomodoro sessions Drift code for schema version 3.
- 2026-07-14: `dart format lib test` passed.
- 2026-07-14: `flutter analyze` passed.
- 2026-07-14: `flutter test test/features/pomodoro test/features/tasks test/widget_test.dart` passed.
- 2026-07-14: Full `flutter test` passed with 65 tests.

Tracks:
- `REQ-V2-011`

### V2-M11 - Stability and Performance Regression Audit

Priority: 11

Status: Verified

Objective:
Review the current app for stability risks, bug-prone flows, unnecessary
rebuilds, UI overdraw/repaint cost, local persistence bottlenecks, and anything
that could make the app slow down during normal use.

Why now:
The core V2 product path is implemented: planning, tasks, goals, Focus,
reports, and task focus progress. Before adding more features, the app needs a
focused stability pass so new work does not build on hidden jank or fragile
state paths.

Grouped scope:
- Navigation and route lifecycle stability across Home, Planning, Tasks, Goals,
  Focus, Settings, and Reports.
- Signal rebuild scope and high-frequency timer updates.
- Heavy UI review: custom painters, charts, gradients, progress indicators,
  dense task cards, and calendar/planning lists.
- Local persistence review: load timing, repeated reads, mapping loops, and
  repository/controller boundaries.
- Regression coverage for the highest-risk user flows.
- Android manual/profile-mode verification when a device is available.

Deliverables:
- [x] Stability/performance findings list with severity and affected screen.
- [x] Rebuild-scope review completed for high-frequency signals.
- [x] Expensive widget/repaint hotspots identified or ruled out.
- [x] Persistence load/mapping hotspots identified or ruled out.
- [x] Targeted fixes implemented in small slices after findings are confirmed.
- [x] `flutter analyze` passes.
- [x] Full `flutter test` passes.
- [ ] Android manual/profile-mode verification completed when device access is available.

Findings:
- 2026-07-14: `AppSettingsScope` mixed slow settings with high-frequency
  Pomodoro runtime state. `remainingSeconds` could notify unrelated screens
  every timer tick. Fix: move Pomodoro runtime values/actions to
  `PomodoroRuntimeScope`, leaving `AppSettingsScope` for preferences and app
  settings.
- 2026-07-15: Focus still depended on `PomodoroRuntimeScope` at page root, so
  every timer tick rebuilt the full Focus list, including static controls and
  context cards. Severity: medium. Fix: split runtime consumers into smaller
  Focus widgets so only timer, controls, lifecycle actions, and stats subscribe
  to per-second runtime changes.
- 2026-07-15: Home performance charts used custom painters without repaint
  boundaries and compared generated list instances by identity, causing avoidable
  repaint work when parent widgets rebuilt. Severity: low/medium. Fix: wrap chart
  painters in `RepaintBoundary` and compare chart values/labels by contents.
- 2026-07-15: Persistence loading paths for Tasks, Goals, Calendar events, and
  Pomodoro sessions were reviewed. No repeated database reads were found in the
  normal Home, Planning, Tasks, Goals, Focus, Settings, or report-export paths;
  controllers load once at startup or on Calendar entry and then update local
  signal state.

Verification:
- 2026-07-14: `dart format` passed for modified Dart files.
- 2026-07-14: `flutter analyze` passed.
- 2026-07-14: Focused Pomodoro/widget tests passed with 19 tests.
- 2026-07-14: Full `flutter test` passed with 65 tests.
- 2026-07-15: `dart format` passed for the modified Focus file. The Home file
  format attempt reported a workspace overwrite warning, so the small Home
  formatting adjustment was kept manual and then verified by analyzer/tests.
- 2026-07-15: `flutter analyze` passed.
- 2026-07-15: Full `flutter test` passed with 65 tests.

Tracks:
- `REQ-NFR-009`

## Proposed roadmap - Productivity V3

Status:
Proposed. This roadmap captures the next requested product direction and should
not be implemented until the individual requirements are approved.

Priority rule:
Finish or explicitly defer V2-M11 before starting V3 implementation. Within V3,
start with timer/navigation/profile foundations, then notifications and
analytics, then report polish.

### V3-M0 - Timer Presets for Fast Use and Testing

Priority: 0

Status: Verified

Objective:
Allow short Pomodoro flows so real use and quick validation do not depend on
the default 25-minute cycle.

Grouped scope:
- 5-minute Pomodoro preset.
- 1-minute focus / 20-second break test preset.
- Clear separation between test presets and normal productivity presets.
- Timer limits and persistence review.

Deliverables:
- [x] 5-minute Pomodoro can be selected.
- [x] 1-minute work / 20-second break can be selected for testing.
- [x] The test preset is easy to find without confusing normal use.
- [x] Timer checks cover the shorter durations.

Verification:
- 2026-07-18: Settings focus duration minimum changed from 10 minutes to 5 minutes.
- 2026-07-18: Task-start Pomodoro presets now include `1 min enfoque / 20 s descanso` as a test preset and `5 min enfoque / 1 min descanso` as a normal short preset.
- 2026-07-18: `PomodoroController` supports second-level runtime durations for dedicated test presets while keeping Settings preferences minute-based.
- 2026-07-18: `dart format` ran on modified files; one existing workspace access warning appeared for `app_settings_controller.dart`.
- 2026-07-18: Focused Settings/Pomodoro/widget tests passed.
- 2026-07-18: `flutter analyze` passed.
- 2026-07-18: Full `flutter test` passed with 67 tests.

Tracks:
- `REQ-V3-001`

### V3-M1 - Planning and Goals Interaction Cleanup

Priority: 1

Status: Verified

Objective:
Make Home planning and Goals easier to navigate and scan.

Grouped scope:
- Back behavior from `Home -> Planificacion`.
- Objective actions behind a three-vertical-dots menu.
- Active goal metrics shown as rows.

Deliverables:
- [x] Back from Planning returns to Home.
- [x] Objective actions are grouped in a vertical-dots menu.
- [x] Goals active metrics show completed, pending, and in-progress rows.
- [x] Mobile layout remains readable.

Verification:
- 2026-07-18: Home now opens `Home -> Planificacion` with push navigation so
  the Android/system back action returns to Home instead of leaving the app.
- 2026-07-18: Planning objective actions moved from separate edit/delete icon
  buttons to `Opciones de objetivo`, a three-vertical-dots menu.
- 2026-07-18: `Goals -> Metas activas` now shows pending, in-progress, and
  completed task counts as separate rows inside each active goal.
- 2026-07-18: `dart format` ran on modified files.
- 2026-07-18: Widget navigation/UI test passed.
- 2026-07-18: `flutter analyze` passed.
- 2026-07-18: Full `flutter test` passed with 67 tests.

Tracks:
- `REQ-V3-002`
- `REQ-V3-003`

### V3-M2 - Settings Identity, Typography, and Local Paths

Priority: 2

Status: Verified

Objective:
Make Settings represent the user and control local export/backup destinations.

Grouped scope:
- Editable user name and email.
- Local profile photo selection.
- Top-right profile identity.
- Typography groups: modern, serious, normal.
- Report folder picker and Downloads/default fallback.
- Database import/export with folder selection.

Deliverables:
- [x] Profile identity can be edited and shown in the app chrome.
- [x] Profile photo can be selected locally through a local image path.
- [x] Typography presets are grouped as `moderna`, `serio`, and `normal`.
- [x] Reports folder can be picked or reset to Downloads/default.
- [x] Database backup/export and restore/import are available from Settings.

Verification:
- 2026-07-18: Settings profile fields now edit and persist user name, email,
  local profile image path, and avatar choice.
- 2026-07-18: The top-right avatar uses the configured local image when the
  file exists, or the configured profile name/avatar initials otherwise.
- 2026-07-18: Settings Profile now includes an in-app local image picker for
  accessible image files, so the photo path does not need to be typed manually.
- 2026-07-18: Settings typography now exposes `moderna`, `serio`, and `normal`
  options and persists the selected font preset locally.
- 2026-07-18: Settings Reports can still reset to Downloads/default and now
  exports a database backup folder with local Settings and Drift database files.
- 2026-07-18: Settings Reports now includes an in-app local folder picker for
  accessible folders without adding a picker package.
- 2026-07-18: Database import can select a backup folder, stage known
  MichiFocus files, and apply them on the next startup before databases open.
- 2026-07-18: `dart format lib test` passed.
- 2026-07-18: Focused Settings/widget and backup import tests passed.
- 2026-07-18: `flutter analyze` passed.
- 2026-07-18: Full `flutter test` passed with 76 tests.

Tracks:
- `REQ-V3-004`
- `REQ-V3-005`

### V3-M3 - Notification Sounds and Notification Center

Priority: 3

Status: Verified

Objective:
Let scheduled tasks and notification testing use a configurable sound and a
top-right notification center.

Grouped scope:
- Notification tone selector.
- Test notification button.
- Scheduled task reminders with sound.
- Accumulated top-right notification dropdown.
- Notification tap routing.

Deliverables:
- [x] Notification tone can be selected.
- [x] Test button triggers a notification with sound.
- [x] Scheduled tasks can notify the user while the app is open.
- [x] Top-right dropdown shows accumulated notifications.
- [x] Tapping a notification opens the relevant app context.

Verification:
- 2026-07-18: Settings now exposes notification tone selection and a test
  notification button.
- 2026-07-18: Test notifications use the selected local sound/haptic feedback,
  accumulate in the top-right dropdown, and can be cleared.
- 2026-07-18: Route-backed notifications can open their configured route; the
  test notification opens `Settings -> Notificaciones`.
- 2026-07-18: In-app scheduled task reminders now check pending tasks planned
  for today, use the selected local sound/haptic feedback, avoid duplicate
  reminders for the same task/day, and open `Calendario` when tapped.
- 2026-07-18: Background/system reminders while the app is closed remain a
  future native enhancement because no native local notification dependency is
  currently approved.
- 2026-07-18: `dart format lib test` passed.
- 2026-07-18: `flutter analyze` passed.
- 2026-07-18: focused Settings controller and scheduled reminder tests passed.
- 2026-07-18: full `flutter test` passed with 74 tests.

Tracks:
- `REQ-V3-006`

### V3-M4 - Focus Mood and Distraction Reflection

Priority: 4

Status: Verified

Objective:
Capture mood and distraction quality around Pomodoro sessions so performance
analytics can show how focus is going.

Grouped scope:
- Mood scale at start.
- Mood scale at completion.
- Completion prompt for distracted vs all good.
- Approximate distraction minutes when distracted.
- No written `distraction_note`.

Deliverables:
- [x] Mood scale is available before or at the start of focus.
- [x] Mood scale is available at Pomodoro completion.
- [x] Completion prompt records distracted/all-good state.
- [x] Distraction minutes are captured only when needed.
- [x] Analytics can consume the reflection data.

Verification:
- 2026-07-18: Focus start flow now asks for a 1-to-5 mood score.
- 2026-07-18: Pomodoro completion shows a reflection card for final mood,
  distracted/all-good state, and approximate distraction minutes only when
  distracted.
- 2026-07-18: Pomodoro session persistence schema version 4 stores structured
  reflection fields and does not add a written `distraction_note`.
- 2026-07-18: `dart run build_runner build --delete-conflicting-outputs`
  regenerated Pomodoro session Drift code.
- 2026-07-18: `dart format lib test` passed.
- 2026-07-18: `flutter analyze` passed.
- 2026-07-18: focused Pomodoro tests passed.
- 2026-07-18: full `flutter test` passed with 69 tests.

Tracks:
- `REQ-V3-007`

### V3-M5 - Analytics Dashboard Expansion

Priority: 5

Status: Verified

Objective:
Make Home performance analytics richer, range-aware, and configurable.

Grouped scope:
- Shared day/week/month/year selector for all charts.
- Dynamic `Rendimiento` title.
- Donut/circular charts.
- Stacked, grouped, horizontal, standard bar, and x/y charts.
- Hide/show chart controls.
- Profile quick stats panel.

Deliverables:
- [x] One selector controls all Home performance charts.
- [x] Chart title reflects the selected range.
- [x] Multiple chart types are available.
- [x] User can hide or show each chart.
- [x] Profile photo opens quick stats by day/month/year.
- [x] Mood-based motivational phrase is shown in quick stats.

Verification:
- 2026-07-18: Home `Rendimiento` now supports day, week, month, and year
  through one shared selector.
- 2026-07-18: The dashboard title changes with the selected range.
- 2026-07-18: Dashboard charts include circular, stacked bar, grouped bar,
  horizontal bar, standard bar, and basic x/y chart views.
- 2026-07-18: Chart visibility can be toggled inside the dashboard.
- 2026-07-18: Profile avatar opens quick stats with day/month/year ranges,
  mood summary, task status totals, and mood-based motivation.
- 2026-07-18: `dart format lib test` passed.
- 2026-07-18: `flutter analyze` passed.
- 2026-07-18: widget test passed.
- 2026-07-18: full `flutter test` passed with 69 tests.

Tracks:
- `REQ-V3-008`
- `REQ-V3-010`

### V3-M6 - Professional Reports and Launch Polish

Priority: 6

Status: Verified

Objective:
Make exports and startup feel polished enough for client-facing use.

Grouped scope:
- Reports saved to configured folder.
- Reports include only enabled charts.
- Reports include profile name and email.
- Professional report layout.
- Initial launch without square logo.
- Current loading screen remains unchanged.

Deliverables:
- [x] Report export obeys the configured path.
- [x] Report export includes only allowed charts.
- [x] Report export includes user name and email.
- [x] Initial app launch no longer shows the square logo.
- [x] Existing in-app loading screen remains visually unchanged.

Verification:
- 2026-07-18: Dashboard chart visibility is persisted in local settings and
  reused by `Home -> Descargar estadisticas`.
- 2026-07-18: Statistics PDF exports include configured profile name/email,
  selected chart sections, task status, focus totals, calendar trend, and a
  recommendation block.
- 2026-07-18: Android native launch backgrounds were changed to the same
  gradient style as the loading screen and no longer reference the launch image;
  the Flutter loading screen was not modified.
- 2026-07-18: `dart format lib test`, `flutter analyze`, and full
  `flutter test` passed with 71 tests.

Tracks:
- `REQ-V3-009`
- `REQ-V3-011`

## Proposed roadmap - Productivity V4

Status:
Proposed. This roadmap captures native-device enhancements requested after V3.
Do not implement code until the relevant requirement is approved, especially
when a milestone needs new dependencies, Android permission changes, or device
access.

Priority rule:
Start with native dependency and permission decisions, then implement system
notifications, then native selectors, then APK/device validation.

User priority override:
Implement V4-M4 before other proposed V4 work once `REQ-DB-001` is approved.
The persistence migration protects existing local relationships and does not
require a native dependency, Android configuration change, or backend service.

### V4-M0 - Native Capability Decisions

Priority: 0

Status: In Progress

Objective:
Decide which native packages, permissions, and platform behaviors are allowed
before touching Android configuration or adding dependencies.

Grouped scope:
- Native local notification option.
- Native file/folder/image picker option.
- Android permission and scoped-storage review.
- Offline-first and local privacy review.

Deliverables:
- [ ] Approved or rejected dependency list.
- [ ] Android permission list documented.
- [ ] Implementation constraints documented.
- [ ] Traceability updated.

Tracks:
- `REQ-V4-001`

### V4-M1 - System Notifications While App Is Closed

Priority: 1

Status: Proposed

Objective:
Promote scheduled task reminders from in-app reminders to system notifications
that can fire while the app is closed.

Grouped scope:
- Local notification scheduling.
- Notification permission flow.
- Selected tone behavior where supported.
- Notification tap routing back into the app.
- Duplicate reminder prevention.

Deliverables:
- [ ] Scheduled task creates a system notification.
- [ ] Notification opens the relevant app context.
- [ ] Existing in-app notification center still works.
- [ ] Offline-first behavior is preserved.
- [ ] Flutter checks and Android device smoke test pass.

Tracks:
- `REQ-V4-002`

### V4-M2 - Native File, Folder, and Image Pickers

Priority: 2

Status: Proposed

Objective:
Use native platform selection flows for profile photos, report folders, and
database backup import/export where supported.

Grouped scope:
- Native profile image picker.
- Native report folder picker or platform-safe equivalent.
- Native backup import/export selection.
- Fallback to current in-app selectors when native selection is unavailable.

Deliverables:
- [ ] Profile photo selection uses native picker behavior.
- [ ] Report folder selection uses native picker behavior where possible.
- [ ] Backup import/export selection uses native picker behavior where possible.
- [ ] Existing V3 local selector fallback remains usable.
- [ ] File access errors are clear to the user.

Tracks:
- `REQ-V4-003`

### V4-M2.1 - Settings External Pickers for Profile and Reports

Priority: 2.1

Status: Implemented

Objective:
Make `Settings -> Perfil` and `Settings -> Reportes` use Android/system
selection flows instead of the current in-app local path selectors.

Why now:
V3 verified local selectors without new dependencies, but the desired Android
experience is to let the user choose photos, folders, and backup locations from
the device's normal gallery or file manager.

Grouped scope:
- Profile photo selection from `Settings -> Perfil`.
- Report output folder selection from `Settings -> Reportes`.
- Backup import source selection from `Settings -> Reportes`.
- Backup export destination messaging in `Settings -> Reportes`.
- Clear fallback/error behavior when the platform picker is unavailable.

Deliverables:
- [x] Profile photo selection opens the Android gallery or external file picker.
- [x] Report output folder selection opens an external folder/file manager flow.
- [x] Backup import opens an external file/folder manager flow.
- [x] Backup export clearly tells the user which folder will receive the backup.
- [x] Existing V3 in-app selector fallback remains usable if native selection is
  unavailable.
- [x] Required Flutter checks and APK build pass.
- [ ] Android device smoke validation passes.

Planning notes:
- 2026-07-19: User approved implementing this slice directly. Implementation
  uses an Android platform channel and system intents, with no new package,
  backend, Android Gradle, or manifest permission change.
- Android scoped-storage behavior was handled through persisted tree URI
  permissions for external folders.
- Preserve offline-first behavior and keep all selected paths/files local to the
  device.

Verification:
- 2026-07-19: `dart format lib test` passed.
- 2026-07-19: `flutter analyze` passed.
- 2026-07-19: focused `app_settings_controller` tests passed.
- 2026-07-19: full `flutter test` passed with 76 tests.
- 2026-07-19: debug APK build passed using JDK 17.
- Android install/launch and picker smoke validation remain pending on a real
  device before this milestone can move to `Verified`.

Tracks:
- `REQ-V4-003`

### V4-M3 - Android APK and Device Validation

Priority: 3

Status: Proposed

Objective:
Validate the app on the target Android device and prepare release delivery with
real install/launch evidence.

Grouped scope:
- APK build.
- Device detection.
- Install validation.
- Launch validation.
- Smoke tests for Home, Planning, Focus, Settings, Reports, and Notifications.

Deliverables:
- [ ] APK builds with the selected build type.
- [ ] APK installs on the target device.
- [ ] App launches without immediate exit.
- [ ] Key flows are smoke-tested on device.
- [ ] Device-specific issues are fixed or documented.

Tracks:
- `REQ-V4-001`

### V4-M4 - Unified SQLite Database and Referential Integrity

Priority: 0 by explicit user priority

Status: Implemented

Objective:
Consolidate Goals, Tasks, Pomodoro sessions, and calendar events into one
local Drift/SQLite database and make their valid references enforceable by
SQLite foreign keys.

Why now:
The current separate database files can only express task/goal/session links
through application code. A shared database is required before adding more
persistence behavior that depends on reliable joins, deletion rules, reports,
or backup/import.

Grouped scope:
- One `michifocus.sqlite` production database.
- Shared Drift database lifecycle with feature-owned repositories and DAOs.
- Foreign keys, delete rules, indexes, and connection-level enforcement.
- Atomic migration from the four existing SQLite files.
- Unified backup/export and backward-compatible import migration.
- Regression coverage for persistence and user flows that consume the data.

Deliverables:
- [x] Proposed schema and delete rules approved.
- [x] Existing local data is backed up and migrated atomically.
- [x] SQLite foreign-key constraints are enabled and tested.
- [x] Goal deletion detaches, rather than deletes, child tasks and sessions.
- [x] Task deletion detaches, rather than deletes, completed sessions.
- [x] New installs and restored backups use one Drift database file.
- [ ] Drift code generation, analyzer, focused migration tests, and full test
  suite pass.
- [ ] ERD, database documentation, requirements, and traceability contain
  verified implementation evidence.

Out of scope:
- Remote storage, synchronization, accounts, or any backend.
- Moving local JSON preferences to SQLite.
- Changing task, goal, session, or calendar user workflows.

Verification plan:
- Fresh-install schema and foreign-key enforcement test.
- Migration fixture containing linked and deliberately broken legacy rows.
- Delete-rule tests for goal/task/session history.
- Backup/export then import round-trip test.
- `dart run build_runner build --delete-conflicting-outputs`.
- `dart format` for changed Dart files, `flutter analyze`, focused persistence
  tests, and the full `flutter test` suite.

Risks:
- Migration must be crash-safe and preserve a path back to the current files.
- Existing backup folders must remain importable.
- Enabling foreign keys requires every Drift connection to opt in explicitly.

Tracks:
- `REQ-DB-001`

Verification:
- 2026-07-20: Drift code generation, `flutter analyze`, and full `flutter test`
  passed with 77 tests.
- Remaining before `Verified`: automated legacy-file migration fixture and
  manual migration on an installation containing real existing data.

### V4-M5 - Executive SQLite-Backed PDF Reports

Priority: 0 by explicit user priority

Status: Verified

Objective:
Make every Settings report a shareable executive PDF in US Letter format whose
task and Pomodoro statistics are read from the unified SQLite database when the
file is exported.

Grouped scope:
- Executive header with profile name, reporting period, and generated date.
- Task status, Pomodoro count, and focused-time statistics.
- US Letter layout that fits on one page.
- Direct repository reads at export time.
- Preserve selected dashboard-chart visibility rules and local file export.

Deliverables:
- [x] Requirement and acceptance criteria approved.
- [x] Source-of-truth gap identified in the report audit.
- [x] General report action exports an executive PDF.
- [x] Statistics report reads SQLite repositories at export time.
- [x] PDF page uses US Letter dimensions.
- [x] Focused tests, analyzer, and full test suite pass.
- [x] Requirement and traceability are updated with verified evidence.

Verification:
- 2026-07-21: report unit tests passed.
- 2026-07-21: `flutter analyze` passed with no issues.
- 2026-07-21: full `flutter test` passed with 77 tests.

Tracks:
- `REQ-V4-005`

## Proposed roadmap - Productivity V5

Status:
In Progress. V5-M0 through V5-M2 are verified and V5-M3 is in device
verification.

Priority rule:
V5-M0, V5-M1, and V5-M2 are verified. V5-M3 is the next recommended milestone
and must be completed before adding more report types or visualizations. Its
implementation should proceed through the quality gates below rather than as
one large change.

### V5-M0 - Spanish Year Terminology

Priority: 0

Status: Verified

Objective:
Replace visible `Anio`/`anio` text with the correct `Año` label throughout the
application.

Deliverables:
- [x] Audit all user-visible year labels.
- [x] Replace visible labels without changing internal keys or identifiers.
- [x] Verify selectors, headers, reports, dialogs, and empty states.
- [x] Run focused tests and Flutter quality checks.

Verification:
- 2026-07-28: The profile statistics selector and yearly summary now display
  `Año`; the internal `year` enum and date logic were preserved.
- 2026-07-28: `rg` inventory found no remaining visible `Anio`/`anio` labels.
- 2026-07-28: `flutter analyze` passed.
- 2026-07-28: Full `flutter test` passed with 86 tests.
- 2026-07-28: Visual hardening bundled all three fonts for offline Android,
  verified Sora/Merriweather differences and global save on-device, persisted
  theme color and text scale, corrected dark-system contrast, and fitted the
  day/week/month/year selector to the available width.

Tracks:
- `REQ-V5-001`

### V5-M1 - Global Typography Preview and Save

Priority: 1

Status: Verified

Objective:
Let the user preview typography choices and apply the selected choice
globally only after pressing `Guardar`.

Deliverables:
- [x] Typography selection shows a representative preview text.
- [x] Draft typography remains unapplied while the user is choosing.
- [x] `Guardar` applies the typography across the app.
- [x] Leaving without saving keeps the previous applied typography.
- [x] The applied selection persists across restarts.
- [x] Focused widget/state tests and Flutter quality checks pass.

Verification:
- 2026-07-28: Settings typography now uses a local draft, a representative
  preview, and an explicit `Guardar` action before changing the global theme.
- 2026-07-28: Focused Settings controller tests passed with 17 tests.
- 2026-07-28: Widget coverage passed for preview-before-save and global state
  after save.
- 2026-07-28: `flutter analyze` passed.
- 2026-07-28: Full `flutter test` passed with 86 tests.

Tracks:
- `REQ-V5-002`

### V5-M2 - Profile Header and Day/Month/Year Navigation

Priority: 2

Status: Verified

Objective:
Show the selected profile name only in the entry header brand area and provide
a presentable selector for navigating by day, month, or year.

Deliverables:
- [x] Entry header replaces `MichiFocus` with the selected profile name.
- [x] Empty profile names use a stable fallback.
- [x] Tapping the header name opens `Día`, `Mes`, and `Año` options.
- [x] Day selection is constrained to the current month.
- [x] Month selection is constrained to the current year.
- [x] Year selection supports the current and previous available years.
- [x] The selected period updates the relevant content.
- [x] Responsive widget tests and Flutter quality checks pass.

Verification:
- 2026-07-28: The entry header now displays the selected profile name and
  opens quick statistics when tapped; other `MichiFocus` brand references were
  preserved.
- 2026-07-28: Day, month, and year selectors use bounded local options and
  update the statistics period label and data range.
- 2026-07-28: Widget coverage passed for header tap and day/month/year mode
  changes.
- 2026-07-28: `flutter analyze` passed.
- 2026-07-28: Full `flutter test` passed with 86 tests.

Tracks:
- `REQ-V5-003`

### V5-M3 - Unified and Trustworthy Reporting Engine

Priority: 3

Status: In Progress

Objective:
Create one reliable, efficient, and maintainable offline reporting pipeline for
quick statistics and PDF exports, with explicit historical semantics and
end-to-end SQLite verification.

Why now:
The current report path reads current SQLite data, but duplicates calculation
rules, filters complete tables in memory, cannot reliably date historical task
completion, and manually lays every chart on one PDF page. Adding more reports
before correcting this foundation would increase ambiguity and rework.

Grouped scope:
- Metric dictionary and exact local `[start, end)` range contract.
- Honest treatment of task completion history and legacy records.
- Backward-compatible Drift migration and indexes when required.
- Range-aware repository queries and SQL aggregation.
- Shared report snapshot use case for quick views and exports.
- Separate PDF renderer and report file writer.
- Period-aware chart aggregation, dynamic scales, wrapping, and pagination.
- Collision-resistant report filenames and explicit write errors.
- SQLite-to-PDF integration coverage and Android export smoke validation.
- Reconciliation of legacy report/PDF requirement documents with the active
  V2/V3/V4/V5 contracts.

Implementation slices:
1. **V5-M3.0 - Metric and architecture contract**
   - Approve formulas, date sources, range boundaries, legacy-data behavior,
     package choice, and responsibility boundaries.
2. **V5-M3.1 - Historical data and query layer**
   - Add only the approved persistence migration, repository range APIs,
     indexes, and in-memory Drift fixtures.
3. **V5-M3.2 - Shared snapshot engine**
   - Implement one tested use case for totals, trends, mood, focus time, and
     period-aware aggregation.
4. **V5-M3.3 - Robust PDF and file output**
   - Implement valid multi-page US Letter output, wrapping, Spanish text,
     dynamic charts, unique naming, and explicit storage errors.
5. **V5-M3.4 - Integration and device verification**
   - Verify SQLite-to-PDF behavior, rendered pages, full quality gates, APK,
     and Android day/month/year exports.

Deliverables:
- [x] Metric dictionary defines every exported value and historical limitation.
- [ ] The measurable baseline in `docs/internal/technical/REPORTING.md` is
      implemented without weakening its fixture, timing, query, or PDF targets.
- [x] One immutable resolved range is used from query through PDF labels.
- [x] Historical completion data is accurate or explicitly unavailable; it is
      never inferred silently.
- [x] Report repository queries only the selected range through Drift.
- [x] Quick statistics and PDF export share the same snapshot engine.
- [x] Chart grain and scale adapt to day, month, year, and custom periods.
- [ ] PDF pages do not overlap, clip, truncate silently, or lose Spanish text.
- [x] Each export has a unique, descriptive filename.
- [x] Storage failures produce a clear error instead of a success message.
- [x] Backup import/export behavior remains compatible and unchanged.
- [x] Integration coverage seeds unified SQLite and verifies generated metrics.
- [ ] Rendered PDF inspection covers all charts, long text, and multiple pages.
- [ ] Android exports for day, month, and year open successfully.
- [x] Active report/PDF requirements and traceability no longer contradict one
      another.

Verification:
- 2026-07-28: V5-M3.0 through V5-M3.3 are implemented. Remaining release
  evidence belongs to V5-M3.4, so the milestone remains `In Progress`.
- Schema 1 to 2 migration preserves legacy completions as unknown and does not
  fabricate completion events.
- Automated fixtures cover local half-open ranges, reversed dates, leap day,
  empty periods, bounded grains, exact task/session/completion metrics,
  mood/distraction formulas, indexed query plans on 20,000 tasks and 50,000
  sessions, SQLite-to-PDF generation, multi-page output, write failures, and
  100 distinct sequential files.
- 2026-07-28: targeted formatting and `flutter analyze` passed; the complete
  `flutter test` suite passed with 104 tests after the adversarial fixes.
- 2026-07-28: the corrected debug APK built with JDK 17, installed successfully
  over the existing app while preserving data, and launched on the connected
  Android device. The Home dashboard and header quick statistics were visually
  checked for day, month, current year, and previous year without clipping or
  overlap.
- 2026-07-28: Android exports created distinct day, month, year, and maximum
  five-year custom-range PDFs with all charts enabled. A stale-scope defect
  that produced a blank success path was corrected so the export callback
  returns the path that was actually written.
- 2026-07-28: the empty day PDF rendered as two valid US Letter pages and the
  maximum custom range (`2021-07-29` through `2026-07-28`) rendered as three
  valid US Letter pages at 144 DPI. All five inspected pages preserve Spanish
  accents and show no clipping, overlap, blank page, or lost bucket.
- 2026-07-28: after the device correction, `flutter analyze` and the complete
  `flutter test` suite passed again with 104 tests.
- 2026-07-28: report export now returns separate display and opening
  references. The success notice exposes `Abrir`; Android grants a temporary
  read-only `content://` URI through a narrowly scoped `FileProvider`. A newly
  generated day report opened successfully in the installed PDF viewer and
  displayed the expected two-page report.
- Remaining V5-M3.4 evidence: repeat the viewer smoke for month, year, and
  custom reports, render the extreme long-profile fixture, and record one
  warm-up plus ten measured runs for each p95 budget.
- 2026-07-31: Home `Estado de tareas` was corrected to fetch listed,
  in-progress, and completed totals from the registered task repository instead
  of trusting controller memory. The dashboard still refreshes from task and
  session change signals, while the visible task-status totals come through the
  persistence boundary. `flutter analyze` passed and the full 157-test suite
  passed.
- Required implementation gates: Drift code generation when applicable,
  `dart format`, `flutter analyze`, focused persistence/report tests, complete
  `flutter test`, PDF structural and rendered-page checks, debug APK build, and
  Android export/open smoke tests.
- Standard verification volume: 20,000 tasks, 50,000 completed sessions, and
  five years of local data.
- Android p95 budgets after one warm-up and ten measured runs: quick statistics
  <= 500 ms, report snapshot <= 1,000 ms, complete PDF generation/save
  <= 3,000 ms.
- Correctness budget: zero expected-value mismatches and 100% reconciliation
  between headline totals and chart buckets.
- PDF budget: valid US Letter pages, no clipping/overlap in the required
  rendered fixtures, and 100 unique files from 100 rapid exports.

Dependencies and decisions:
- Explicit approval is required before adding or replacing a PDF package.
- Persistence work requires a reviewed migration and a defined policy for
  legacy completed tasks that have no trustworthy completion timestamp.
- Performance acceptance should verify bounded/indexed query behavior rather
  than use a fragile device-specific millisecond threshold.

Tracks:
- `REQ-V5-004`

### V5-M4 - Global Spanish and English Language

Priority: 4

Status: Verified

Objective:
Provide an offline, globally applied language preference for Spanish and
English.

Deliverables:
- [x] Settings provides a presentable Español/English selector.
- [x] Language changes rebuild every visible application surface.
- [x] The selected language persists across application restarts.
- [x] Dynamic states, dialogs, notifications, and report UI are localized.
- [x] Focused localization tests and Flutter quality checks pass.
- [x] Both languages pass Android visual inspection.

Verification:
- `flutter analyze` and the full 137-test suite passed on 2026-07-29.
- Release APK build and installation passed.
- Spanish and English were visually inspected on Android; English persisted
  after restart, and Spanish was restored and persisted after the final
  restart.

Tracks:
- `REQ-SET-006`
- `docs/internal/technical/REPORTING.md`

## Deprecated legacy milestones

Status:
Deprecated. The milestones below are preserved as historical context only.
Future implementation work should use the Active roadmap - Productivity V2
section above.

## M0 - Documentation and Architecture Baseline

Status: Verified

Objective:
Create the SDD, architecture, workflow, agents, skills, and client documentation baseline.

Deliverables:
- [x] SDD index created
- [x] Requirement files created
- [x] Architecture docs created
- [x] Technical docs created
- [x] Codex orchestrator, agents, and skills created
- [x] Client doc placeholders created

Quality gates:
- [x] Documentation baseline exists and is navigable.
- [x] Skill frontmatter is valid for project skills.
- [x] Client docs do not include internal Codex orchestration details.
- [x] Traceability matrix contains initial requirement rows.

Required docs updated:
- [x] `docs/internal/SDD.md`
- [x] `docs/internal/requirements/`
- [x] `docs/internal/architecture/`
- [x] `docs/internal/technical/`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/workflow/`
- [x] `docs/client/`
- [x] `.codex/`

Required checks:
- [x] Verified required M0 files exist.
- [x] Verified 53 requirement IDs exist.
- [x] Verified 53 traceability rows exist.
- [x] Verified no app implementation files are required for M0.

Verification evidence:
- M0 is docs-only.
- Validation confirmed the requested SDD/Codex documentation baseline exists.
- No `lib/`, Gradle, dependency, or runtime behavior changes are part of M0.

## M1 - UI Foundation

Status: Verified

Objective:
Stabilize theme, typography, responsive UI, navigation visual state, and Atomic Design usage.

Deliverables:
- [x] Theme rules reviewed
- [x] Material 3 spacing and surface rules verified
- [x] Responsive behavior considered
- [x] Navigation state rules verified
- [x] Shared UI patterns documented
- [x] Launcher/install icon aligned with the splash/loading icon

Quality gates:
- [x] Relevant requirements are approved before implementation.
- [x] Required checks pass before marking verified.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] Relevant `docs/internal/requirements/REQ-*.md` file
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] Relevant technical or client documentation

Required checks:
- [x] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

Verification evidence:
- `REQ-UI-001` through `REQ-UI-007` are verified in `REQ-UI.md`.
- `dart format lib test` passed.
- `flutter analyze` passed after the responsive breakpoint integration.
- `flutter build apk --debug` passed after launcher/splash resource updates.

## M1.1 - Background Gradient Restoration

Status: Verified

Objective:
Restore the app-wide gradient background from the approved visual direction.

Deliverables:
- [x] Background restoration requirement approved
- [x] App-level gradient background restored
- [x] Primary screens visually checked

Quality gates:
- [x] Relevant requirements are approved before implementation.
- [x] Required checks pass before marking verified.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] Relevant `docs/internal/requirements/REQ-*.md` file
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] Relevant technical or client documentation not required

Required checks:
- [x] `dart format lib test`
- [x] `flutter analyze`
- [x] Visual inspection of primary screens after implementation

Planning notes:
- Tracks `REQ-UI-008`.
- This milestone exists because M1 is already verified and the background gradient correction should be reviewed as a small visual follow-up.

Verification evidence:
- `AppPalette.appBackgroundDecoration` restores the app-wide gradient using
  centralized palette colors.
- `AppShell`, `SplashPage`, and Pomodoro fullscreen use the centralized
  app background decoration.
- `dart format lib test` passed.
- `flutter analyze` passed.
- Full `flutter test` passed with 29 total tests.

## M2 - Tasks Feature

Status: Verified

Objective:
Deliver the complete Tasks feature in phases: create, list, validate, edit, complete, delete, filter, and persist tasks locally with Drift/SQLite.

Approval status:
- [x] Milestone M2 approved for phased implementation.
- [x] `REQ-TASK-001` through `REQ-TASK-008` approved.
- [x] Drift persistence approved as part of M2 through `REQ-TASK-006`.

Phases:
- [x] Phase 0 - Requirements approved for full M2 scope.
- [x] Phase 1 - In-memory task creation, validation, and listing.
- [x] Phase 2 - Edit, complete, delete, and filter tasks in state.
- [x] Phase 3 - Drift persistence: tasks table, DAO, repository, generated code, and local save/load.
- [x] Phase 4 - Verification, documentation updates, and traceability closure.

Deliverables:
- [x] Task requirements approved: `REQ-TASK-001` through `REQ-TASK-008`
- [x] Task UI implemented
- [x] Task state implemented
- [x] Task domain boundaries implemented
- [x] Task data boundaries implemented
- [x] Task persistence implemented with Drift

Quality gates:
- [x] Relevant M2 requirements are approved before implementation.
- [x] Traceability matrix is updated for approved M2 requirements.
- [x] UI does not access Drift DAOs directly.
- [x] Required M2 Phase 3 checks passed.

Required docs to update:
- [x] `docs/internal/requirements/REQ-TASKS.md`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/technical/DATABASE.md`
- [x] Relevant client documentation after implementation

Required checks:
- [x] Run `dart run build_runner build --delete-conflicting-outputs` after Drift schema/generator changes.
- [x] Run `flutter analyze` after implementation.
- [x] Run targeted `flutter test test/features/tasks/presentation/controllers/tasks_controller_test.dart`.
- [x] Run targeted `flutter test test/features/tasks`.
- [x] Full `flutter test` suite passes.

Scope notes:
- M2 now includes persistence with Drift.
- Implementation still happens phase by phase to avoid mixing UI, state, and database work in one uncontrolled change.
- Phase 1 and Phase 2 are implemented in memory and verified with targeted controller tests.
- Phase 3 is implemented with Drift and verified using a temporary local SQLite database file.
- Phase 4 completed with full test suite verification and client-facing documentation updates.

Verification evidence:
- `dart format lib test` passed.
- `flutter analyze` passed.
- `flutter test test/features/tasks` passed with 9 Tasks tests.
- Full `flutter test` passed with 10 total tests.

## M3 - Goals Feature

Status: Verified

Objective:
Deliver goal creation, progress tracking, and later associations/persistence.

Deliverables:
- [x] Goal requirements approved (`REQ-GOAL-001`, `REQ-GOAL-002`, `REQ-GOAL-004`; deadline planning extended in M5)
- [x] Goal UI implemented
- [x] Goal progress model implemented
- [x] Goal local persistence implemented

Quality gates:
- [x] Relevant requirements are approved before implementation.
- [x] Required checks pass before marking verified.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] Relevant `docs/internal/requirements/REQ-*.md` file
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] Relevant technical or client documentation (no additional technical/client doc required)

Required checks:
- [x] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

Planning notes:
- Initial slice approved on 2026-07-04: create goals and show goal progress.
- Persistence approved and verified on 2026-07-04 through `REQ-GOAL-004`.
- Out of scope for the current slice: associations with tasks/sessions.

Verification evidence:
- `REQ-GOAL-001`, `REQ-GOAL-002`, and `REQ-GOAL-004` are verified in `REQ-GOALS.md`.
- `dart format lib test` passed.
- `dart run build_runner build --delete-conflicting-outputs` generated Drift code.
- `flutter analyze` passed.
- Full `flutter test` passed with 19 total tests.

## M4 - Pomodoro Sessions Feature

Status: Verified

Objective:
Deliver session start, pause, reset, completion, duration preferences, and later history.

Deliverables:
- [x] Pomodoro requirements approved
- [x] Timer behavior verified
- [x] Session history planned or implemented
- [x] Duration preferences verified
- [x] Atmospheric Pomodoro settings verified

Quality gates:
- [x] Relevant requirements are approved before implementation.
- [x] Required checks pass before marking verified.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] Relevant `docs/internal/requirements/REQ-*.md` file
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] Relevant technical or client documentation

Required checks:
- [x] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

Planning notes:
- Start, pause, reset, complete, and local history are verified.
- Duration and atmospheric settings are verified in `REQ-POMO-005`.
- Milestone closed as verified because all `REQ-POMO-001` through
  `REQ-POMO-006` requirements are verified and checks have passed.
- The atmospheric settings live in `PomodoroTimeControls` under
  `_AtmosphereCard`; the emphasis color selector is intentionally removed.

Verification evidence:
- `REQ-POMO-001` through `REQ-POMO-006` are verified in `REQ-POMODORO.md`.
- `dart run build_runner build --delete-conflicting-outputs` generated Drift code.
- `dart format lib test` passed.
- `flutter analyze` passed.
- Full `flutter test` passed with 29 total tests.

## M4.1 - Pomodoro Completion Feedback

Status: Verified

Objective:
Make atmospheric completion sound and vibration settings selectable, previewable, and used when a Pomodoro session finishes.

Deliverables:
- [x] Completion sound requirement approved
- [x] Sound selector implemented in atmospheric Pomodoro settings
- [x] Sound preview action implemented
- [x] Completion vibration toggle implemented
- [x] Vibration preview action implemented
- [x] Selected sound stored in local app state
- [x] Selected vibration preference stored in local app state
- [x] Completion feedback triggered when a session completes

Quality gates:
- [x] Relevant requirements are approved before implementation.
- [x] Required checks pass before marking verified.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] `docs/internal/requirements/REQ-POMODORO.md`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/tracking/MILESTONES.md`

Required checks:
- [x] `dart format lib test`
- [x] `flutter analyze`
- [x] Full `flutter test`

Verification evidence:
- `REQ-POMO-007` is verified in `REQ-POMODORO.md`.
- Sound choices use local Flutter `SystemSound` playback and no new packages.
- Vibration uses local Flutter `HapticFeedback` and no new packages.
- Tests cover selected sound state, vibration preference state, and session-completion callback behavior.

## M5 - Goal Deadline Planning Feature

Status: Verified

Objective:
Deliver calendar-driven goal planning: choose an objective for a target date,
relate Pomodoro work to that objective, and allow the objective to be changed or
deleted.

Deliverables:
- [x] Calendar requirements approved for first slice (`REQ-CAL-001`)
- [x] Calendar view implemented
- [x] Event creation implemented
- [x] Event persistence implemented
- [x] Goal target dates planned or implemented
- [x] Calendar date can show the goal to reach
- [x] Calendar date can select/change the goal to reach
- [x] Completed Pomodoros can be related to a goal
- [x] Goals can be edited and deleted from the user workflow

Quality gates:
- [x] Relevant requirements are approved before implementation.
- [x] Required checks pass before marking verified.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] Relevant `docs/internal/requirements/REQ-*.md` file
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/technical/DATABASE.md`

Required checks:
- [x] `dart run build_runner build --delete-conflicting-outputs`
- [x] `dart format lib test`
- [x] `flutter analyze`
- [x] Full `flutter test`

Planning notes:
- First slice approved on 2026-07-10: implement `REQ-CAL-001` only.
- Second slice approved on 2026-07-10: implement `REQ-CAL-002` and
  `REQ-CAL-004` together so created events persist locally.
- Product direction updated on 2026-07-10: the remaining M5 work should pivot
  from standalone calendar events to goal deadline planning.
- Goal deadline planning slices implemented `REQ-GOAL-003`,
  `REQ-GOAL-005`, and `REQ-CAL-003`:
  - target dates are exposed for goals,
  - Calendar creates, edits, deletes, and shows goals planned for selected
    dates,
  - completed Pomodoro sessions can be associated with a selected goal,
  - Pomodoro assignment is limited to scheduled goals or `Sin objetivo`.
- 2026-07-10 target-date slice implemented:
  - goals now store an optional target date,
  - Goals supports editing title, Pomodoro target, and target date,
  - Goals supports delete confirmation,
  - Calendar marks and lists goals planned for the selected date.
- M5 is verified; later refinements should be tracked as new requirements.

Verification evidence:
- `CalendarPage` now provides a local month view for the current month, month
  navigation, selected-day state, local event creation, persisted agenda
  entries, and an empty state for days without entries.
- Home links to the calendar planning view through a planning card.
- Calendar route is mounted inside `AppShell`, preserving the app navigation
  shell when opened from Home.
- `CalendarEventsDatabase`, `CalendarEventsDao`,
  `DriftCalendarEventsRepository`, and `CalendarController` persist and load
  events locally.
- `GoalRecords.targetDate`, `GoalsDao.updateDetails`,
  `DriftGoalsRepository.updateGoalDetails`, and `GoalsController.goalsForDay`
  support goal deadline planning.
- `PomodoroSessionRecords.goalId`, `PomodoroController.activeGoalId`, and the
  app-level completion callback associate completed Pomodoros with the selected
  goal and increment its progress.
- Calendar now owns the date-first objective writing flow for selected days.
- `dart run build_runner build --delete-conflicting-outputs` generated
  `calendar_events_database.g.dart` and refreshed generated Drift files.
- `dart format lib test` passed.
- `flutter analyze` passed.
- Full `flutter test` passed with 44 total tests.

## M6 - Settings Feature

Status: Implemented

Objective:
Deliver local settings for timer, theme, and notification preferences.

Deliverables:
- [x] Settings requirements approved for timer preferences (`REQ-SET-001`, `REQ-SET-002`)
- [x] Local timer preferences implemented
- [x] Reports export folder preference implemented (`REQ-SET-005`)
- [x] Settings checks passed
- [ ] Theme preference persistence remains proposed
- [ ] Notification preference persistence remains proposed

Quality gates:
- [x] Relevant requirements are approved before implementation.
- [x] Required checks pass before marking verified.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] Relevant `docs/internal/requirements/REQ-*.md` file
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] Relevant technical or client documentation not required for this slice

Required checks:
- [x] `dart format lib test`
- [x] Targeted `flutter test test/app/state/app_settings_controller_test.dart`
- [x] Targeted `flutter test test/features/pomodoro/presentation/controllers/pomodoro_controller_test.dart`
- [x] `flutter analyze`
- [x] Full `flutter test`

Planning notes:
- Tracks `REQ-SET-001` and `REQ-SET-002`.
- Out of scope for this slice: theme preference persistence and notification preference persistence.

Verification evidence:
- Existing Settings/Pomodoro controls save timer preferences through a local `SettingsRepository`.
- App startup loads persisted timer preferences before `runApp` and applies the focus duration to `PomodoroController`.
- Full `flutter test` passed with 34 total tests.
- 2026-07-11: Settings added a Reports folder path control and `Usar Descargas`; report exports now write to the configured folder or the platform Downloads/default folder. `dart format lib test`, `flutter analyze`, and focused Settings/widget tests passed with 10 tests.

## M7 - Local Persistence with Drift

Status: Proposed

Objective:
Introduce approved Drift schema, DAOs, repositories, migrations, and generated code.

Deliverables:
- [ ] Schema approved
- [ ] DAOs implemented
- [ ] Repositories implemented
- [ ] Build runner completed

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M8 - Reports

Status: Proposed

Objective:
Deliver verified summaries and chart/report views based on real local data.

Deliverables:
- [ ] Report requirements approved
- [ ] Source data verified
- [ ] Charts/reports implemented

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M9 - PDF Export

Status: Proposed

Objective:
Deliver local PDF export with clear data selection and generated file handling.

Deliverables:
- [ ] PDF requirements approved
- [ ] Export generation implemented
- [ ] File handling verified

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M10 - Client Delivery Documentation

Status: Implemented

Objective:
Complete client-facing manuals, quick guide, changelog, technical manual, and final delivery doc.

Deliverables:
- [x] User manual completed
- [x] Quick guide completed
- [x] Installation manual completed
- [x] Technical manual completed
- [x] Changelog updated
- [x] Final delivery doc completed

Quality gates:
- [x] Client docs avoid internal Codex details.
- [x] Client docs use clear Spanish with real accents.
- [x] Required documentation files exist.
- [ ] APK/device delivery validation remains pending in M10.1.

Required docs to update:
- [x] `docs/client/MANUAL_USUARIO.md`
- [x] `docs/client/GUIA_RAPIDA.md`
- [x] `docs/client/MANUAL_INSTALACION.md`
- [x] `docs/client/MANUAL_TECNICO.md`
- [x] `docs/client/CHANGELOG.md`
- [x] `docs/client/ENTREGA_FINAL.md`

Required checks:
- [x] Client docs reviewed for current V2 scope.
- [x] Encoding scan run for mojibake patterns.

Verification evidence:
- 2026-07-11: Client docs updated for V2 planning, tasks, goals, Focus, Calendar, reports, configurable report folder, offline behavior, and delivery scope.
- 2026-07-11: APK/device validation remains tracked separately in M10.1.

## M10.1 - Android APK Install and Launch Repair

Status: Proposed

Objective:
Diagnose and fix the Android APK installation or immediate launch failure reported on the target device.

Deliverables:
- [x] Install and launch stability requirement captured
- [ ] Exact Android install error or launch crash trace collected
- [ ] APK build variant identified
- [ ] Root cause documented
- [ ] Fix implemented after diagnosis
- [ ] APK installation verified on Android
- [ ] APK launch verified on Android without immediate exit

Quality gates:
- [ ] Relevant requirement is approved before implementation.
- [ ] Android Gradle or manifest changes are not made until the failure is understood.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [x] `docs/internal/requirements/REQ-NON_FUNCTIONAL.md`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/tracking/MILESTONES.md`

Required checks:
- [ ] `flutter analyze`
- [ ] Full `flutter test`
- [ ] APK build for the selected variant
- [ ] Install verification on target Android device
- [ ] Launch verification on target Android device
- [ ] `adb logcat` or equivalent crash evidence reviewed if the app exits immediately

Planning notes:
- Tracks `REQ-NFR-008`.
- The first implementation step is diagnostic: capture the exact device error or
  `adb logcat` crash trace, APK path, build variant, Android version, and
  whether an older app build is already installed.
- Possible causes include signature mismatch with a previous install,
  incompatible Android SDK/minSdk, ABI mismatch, corrupted APK transfer,
  package name conflicts, device install restrictions, native library loading
  failures, generated database/runtime initialization errors, or Android
  resource startup issues.
- Local diagnostic on 2026-07-04: `flutter build apk --debug` succeeded and
  produced `build/app/outputs/flutter-apk/app-debug.apk`; no Android device was
  listed by `adb devices`, so install/launch verification remains pending.

## M11 - Home and Settings Scroll Performance

Status: Implemented

Objective:
Diagnose and reduce repeated scroll jank in Home and Settings, especially on high-end Android hardware such as Samsung Galaxy S23 Ultra.

Deliverables:
- [x] Performance issue captured from device feedback
- [x] Relevant non-functional requirement selected (`REQ-NFR-002`)
- [x] App-level rebuild scope reduced
- [x] Home/Settings rendering hotspots reviewed
- [x] Flutter checks passed
- [ ] Profile/manual scroll verification completed on Android

Quality gates:
- [x] Requirement is tracked before optimization work.
- [x] No backend or package dependency is introduced.
- [x] Required checks pass before marking implemented.
- [x] Traceability matrix is updated.

Required docs to update:
- [x] `docs/internal/requirements/REQ-NON_FUNCTIONAL.md`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/tracking/MILESTONES.md`

Required checks:
- [x] `dart format lib test`
- [x] `flutter analyze`
- [x] Full `flutter test`
- [ ] Profile/manual scroll verification on Android device

Planning notes:
- The first code-review finding is that `main.dart` uses an app-level `SignalBuilder` that reads frequently changing app and Pomodoro signals while wrapping `MaterialApp.router`.
- Implemented fix keeps theme rebuilds at `MaterialApp` level, but moves high-frequency settings/timer rebuilds below the router builder so route configuration is not rebuilt unnecessarily.
- If jank remains after rebuild-scope reduction, inspect paint/raster costs in Home and Settings, especially custom painters, progress indicators, gradients, and dense card lists.

Verification evidence:
- `main.dart` now limits the outer `SignalBuilder` to theme preset, dark mode, and font scale.
- App/timer/settings values now rebuild `AppSettingsScope` around the routed child instead of rebuilding `MaterialApp.router`.
- `dart format lib test` passed.
- `flutter analyze` passed.
- Full `flutter test` passed with 34 total tests.
- 2026-07-05 refresh: `flutter analyze` passed and full `flutter test`
  passed with 34 total tests.
- 2026-07-05 Android verification attempt: `adb devices` reported no
  connected devices, so hardware scroll verification could not be completed.
- Android profile/manual scroll verification remains pending before `Verified`.

## V6 - Recoverable Task Focus Plans

Status:
Implemented on 2026-07-29. Automated checks, APK install/launch, accessible
Android hierarchy, and small-screen golden references passed. The manual
Android theme/typography/active-state visual matrix remains before Verified.

### V6-M0 - Continuous Task Plan and Recoverable Pomodoro

Status: Implemented

Objective:
Turn a planned task duration into a clear sequence of focus and break blocks,
allow one-block alternatives, and preserve exclusive timer ownership across
navigation, background execution, and process recreation.

Tracks:
- `REQ-V6-001`
- `REQ-V6-002`
- `REQ-V6-003`
- `REQ-V6-004`
- `REQ-V6-005`
- `REQ-V6-006`

Deliverables:
- [x] Product behavior and minute-based formulas approved
- [x] Persistence and architecture impact inspected
- [x] Planning edit supports duration and full-width actions
- [x] Pending, In Progress, and Completed transitions are automatic
- [x] Predefined recommendation and custom projection are implemented
- [x] Continue runs or resumes the complete remaining plan
- [x] Predefined/custom single-block execution is implemented
- [x] Block X of N and task percentage are visible in Pomodoro
- [x] One active owner is enforced across all task entry points
- [x] Active runtime survives process recreation
- [x] Unified backup validation covers the new schema/runtime
- [x] Automated visual verification completed
- [ ] Manual Android theme/typography/state visual matrix completed

Approved behavior:
- Planned task duration is net focus time; breaks are additional elapsed time.
- Recommendation calculations use whole completed minutes by flooring the sum
  of task-focused seconds once.
- The last focus block is shortened to the remaining task minutes.
- Continue resumes an exact partial phase or runs the remaining plan
  automatically.
- A predefined/custom single Pomodoro runs one focus plus its break and then
  stops.
- A paused or resting Pomodoro still owns the single global timer.
- Starting another task requires returning to the owner or explicitly stopping
  and switching.
- The final focus block completes the task automatically and has no mandatory
  trailing break.

Implementation slices:
1. **V6-M0.0 - Contract and tests**
   - Stable block-plan value objects, minute formulas, recommendation ranking,
     and status/ownership invariants.
2. **V6-M0.1 - Task planning edit**
   - Atomic objective/duration update, arbitrary imported duration support, and
     responsive full-width actions.
3. **V6-M0.2 - Runtime persistence and ownership**
   - Unified schema migration, runtime repository, restoration, and switch
     guard.
4. **V6-M0.3 - Continuous and single-block execution**
   - Start/Continue/Resume/Stop-for-now state machine, automatic blocks, custom
     cadence, and final-block truncation.
5. **V6-M0.4 - Presentation and verification**
   - Block/progress projection, recommendation tags, tests, analyzer, backup
     compatibility, APK build/install, and visual inspection.
6. **V6-M0.5 - Timed recovery and wellbeing**
   - Status: Implemented; direct Android reflection-state inspection remains.
   - Run the configured break countdown after every completed non-final focus
     block without adding break time to task progress.
   - Queue unanswered post-block reflections across process recreation.
   - Ask for the 1-to-5 mood with Material face icons, persist it on the focus
     session, and expose the same average in Home and PDF.
   - Keep the final task-completing block free of a mandatory trailing break.

Quality gates:
- [x] Requirement and milestone approved before implementation
- [x] No new package or backend dependency planned
- [x] Drift migration and generated schema verified
- [x] Imported databases validated before replacement
- [x] Controller and repository tests cover process restoration and exclusivity
- [x] Widget tests cover editing, custom projection, and block progress
- [x] `dart format lib test`
- [x] `flutter analyze`
- [x] Full `flutter test`
- [x] Debug and release APK build/install/launch
- [ ] Android visual inspection
- [ ] V6-M0.5 face selector, visible break countdown, daily mood statistic, PDF
      summary, and reflection restoration verified on Android

Required docs:
- [x] `docs/internal/requirements/REQ-PRODUCTIVITY_V6.md`
- [x] `docs/internal/tracking/MILESTONES.md`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/technical/DATABASE.md`
- [x] Relevant client documentation

Verification evidence:
- `dart run build_runner build --delete-conflicting-outputs` regenerated the
  unified Drift schema at version 3.
- `flutter analyze` passed with no issues.
- Full `flutter test` passed with 134 tests.
- Golden references cover the custom `45/10` projection for a 120-minute task
  and the total-progress timer ring at 390 x 844.
- 2026-07-29 visual correction keeps only countdown and phase inside the ring;
  an accessible information button below it opens the block, task progress,
  next step, and elapsed projection. Updated golden references and the full
  134-test suite passed.
- Debug and 62.1 MB release APKs built successfully. The release APK installed
  and launched on Android API 33; the accessible hierarchy exposed the
  expected app content.
- Both available headless emulators returned a black framebuffer even for the
  Android launcher. Manual screenshot-based theme/state inspection therefore
  remains pending and prevents moving the milestone to Verified.
- 2026-08-04: V6-M0.5 reused timed focus/break phases, added a persistent
  per-block reflection queue, replaced numeric mood choices with five Material
  face icons, and exposed the range-aware average in Home and PDF.
- Drift generated schema version 4, clean analysis, and all 159 tests passed.
- The 64.3 MB release APK installed on RMX3301. Home's mood summary and a new
  two-page day PDF passed direct visual inspection. A live post-block prompt was
  not forced against the user's real data, so that final Android state remains
  before Verified.

## Proposed roadmap - Productivity V7

Status:
V7-M0 is implemented and V7-M1/V7-M2/V7-M2.1 are verified on 2026-07-31.
V7-M3 remains proposed.

Priority rule:
Build the normal fullscreen/menu foundation first, then maximum concentration
and its safe exits, and finally relocate completion vibration into Settings.
This order keeps the higher-risk immersive behavior on top of one shared,
tested fullscreen lifecycle.

### V7-M0 - Focus Menu and Normal Fullscreen

Priority: 0

Status: Implemented

Objective:
Remove configuration navigation from the Focus three-dot action and make that
action open a small popup menu beside the button for presentation controls.

Deliverables:
- [x] Replace the direct Pomodoro-settings action with a small, compact popup
      menu anchored to the three-dot button.
- [x] Do not use a new page, large panel, or bottom sheet for this menu.
- [x] Show `Ver en pantalla completa` in normal view.
- [x] Show `Salir de pantalla completa` in normal fullscreen.
- [x] Preserve the selected theme in normal fullscreen.
- [x] Keep timer state unchanged across both transitions.
- [x] Add Spanish/English and accessibility coverage.

Verification:
- `dart format` and `flutter analyze` passed.
- Focused widget navigation and the full 137-test suite passed.
- The release APK built, installed, and launched on Android.
- Physical popup screenshots remain pending because the connected device was
  locked during inspection; V7-M0 remains `Implemented` until that visual check
  passes.

Tracks:
- `REQ-V7-001`

### V7-M1 - Maximum Concentration and Its Exit Controls

Priority: 1

Status: Verified

Depends on:
- `V7-M0`

Objective:
Add a black immersive Focus mode that starts with the Pomodoro and can always
be exited without affecting the timer. The double-tap gesture exists
specifically to leave maximum concentration after that mode has started.

Deliverables:
- [x] Add the `Máxima concentración` switch to the three-dot menu.
- [x] Allow the switch to arm the mode before start or enter it during an
      active Pomodoro.
- [x] Show only Focus essentials over a black fullscreen background.
- [x] Use pure black with subdued white/gray ring, text, borders, and buttons
      in an Always On Display visual style; do not reuse bright theme colors.
- [x] Keep the three-dot menu available inside maximum concentration.
- [x] Once maximum concentration is active, exit and disable only that mode
      with a double tap on a non-interactive area of the black screen.
- [x] Give double tap no special action outside maximum concentration.
- [x] Exit and disable the mode by turning off its menu switch.
- [x] Keep the Pomodoro running or paused exactly as it was after either exit.
- [x] Exit automatically when the runtime stops, is discarded, or completes.
- [x] Restore Android system UI reliably and cover gesture/control conflicts.

Persistence decision:
- The switch is ephemeral presentation state and is not persisted across
  process recreation.

Verification:
- `flutter analyze` passed without issues; the full suite passed with 139 tests.
- Controller and widget tests cover lifecycle, arming, both exits, direct switch
  taps, unchanged paused time, and the pure-black mobile golden.
- The release APK built and installed successfully.
- Android physical inspection passed for the compact English menu, active and
  paused AOD visuals, double-tap exit, direct switch exit, continued timing,
  and system UI restoration.

Tracks:
- `REQ-V7-002`

### V7-M2 - Completion Vibration in Settings

Priority: 2

Status: Verified

Objective:
Expose the existing completion-vibration preference in Settings and remove its
ownership from Focus configuration.

Implementation decision:
- Reuse `AppSettingsController.completionVibrationEnabled`, its existing
  callback, preview action, and `completionVibrationEnabled` Settings JSON key.
- Do not add state, packages, database columns, or schema migrations.

Deliverables:
- [x] Add `Vibrar al finalizar` / `Vibrate when finished` to Settings.
- [x] Reuse one completion-vibration state and callback.
- [x] Persist and restore the value through `michidoro-settings.json`.
- [x] Vibrate after focus and break completion when enabled, including silent
      sound mode.
- [x] Remove the duplicate/old vibration control from Focus configuration.
- [x] Verify enabled, disabled, restart, and silent-sound behavior on Android.

Verification:
- `dart format`, clean `flutter analyze`, and the full 140-test suite passed.
- Release APK build/install passed.
- Android inspection verified responsive English/Spanish presentation, preview
  haptic feedback, enabled/disabled control states, and restart persistence.

Tracks:
- `REQ-V7-003`
- `REQ-POMO-007`
- `REQ-SET-002`

### V7-M2.1 - Selectable Completion Vibration Patterns

Priority: 2

Status: Verified

Objective:
Replace the fixed single completion feedback with a user-selectable physical
Android vibration pattern without changing the existing switch or Pomodoro
business state.

Implementation decision:
- Add `Suave`, `Normal`, `Doble`, and `Intensa` using Android's real vibration
  motor with distinct timing and amplitude patterns.
- Keep `Normal` as the compatibility default for existing Settings JSON files.
- Persist one enum name in `michidoro-settings.json`; do not change SQLite,
  Android Gradle, or dependencies.
- Use the existing local method-channel boundary and Android `VIBRATE`
  permission; retain haptics only as a non-Android fallback.

Deliverables:
- [x] Add a localized vibration-pattern selector to both Settings surfaces.
- [x] Use the selected pattern for preview and completion feedback.
- [x] Save and restore the selected pattern with a safe legacy fallback.
- [x] Dispatch previews and phase completion through Android
      `Vibrator`/`VibrationEffect`.
- [x] Verify every pattern, the disabled state, restart persistence, and layout.

Verification:
- Controller, JSON round-trip/legacy fallback, and bilingual widget coverage
  passed; the full suite passed with 144 tests and the analyzer is clean.
- The 64.1 MB release APK built and installed on device `3bbacc93`.
- Physical pattern selection, haptic comparison, restart, and layout inspection
  were initially pending because the connected device was locked.
- A later unlocked-device inspection proved the feedback was haptic-only;
  V7-M2.1 returned to `In Progress` for real-vibration correction.
- The correction added `VIBRATE` plus a native waveform bridge. Android's
  vibrator service recorded four distinct MichiDoro-owned motor effects,
  including maximum-amplitude intense pulses, while the disabled state emitted
  no event.
- Clean analysis, the full 157-test suite, release APK build/install, restart
  persistence, and Spanish device layout inspection passed on 2026-07-31.

Tracks:
- `REQ-V7-004`
- `REQ-POMO-007`
- `REQ-SET-002`

### V7-M3 - Integrated Verification

Priority: 3

Status: Proposed

Objective:
Verify that immersive presentation changes remain recoverable and do not alter
Pomodoro business state.

Quality gates:
- [ ] Widget tests cover dynamic fullscreen labels and both maximum-mode exits.
- [ ] Controller/state tests cover arming, active entry, pause, completion, and
      vibration persistence.
- [ ] Tests prove display transitions do not change timer or task progress.
- [ ] `dart format` passes for changed Dart files.
- [ ] `flutter analyze` passes.
- [ ] Full `flutter test` passes.
- [ ] Release APK builds, installs, and launches.
- [ ] Android visual inspection covers normal fullscreen, running/paused
      maximum concentration, double-tap exit, switch exit, and Spanish/English.

Tracks:
- `REQ-V7-001`
- `REQ-V7-002`
- `REQ-V7-003`

## Proposed roadmap - Productivity V8

Status:
V8-M0 was verified on 2026-07-31 after automated, release, and physical Android
inspection without erasing the user's existing data.

### V8-M0 - First-Run Onboarding

Priority: 0

Status: Verified

Objective:
Introduce MichiDoro through a short, useful onboarding sequence that appears
only on a fresh installation, can be skipped at any point, and leads directly
into the working app.

Product distinction:
- Keep the current native and Flutter splash/loading experience brief on every
  launch.
- Show onboarding after splash only when the app has never been used on that
  installation.
- Do not present onboarding again after either `Omitir` or successful completion.

Proposed sequence:
1. **Organiza tu día** - tasks, goals, planning, and calendar in one local flow.
2. **Enfócate con intención** - task estimates, automatic focus/break blocks,
   continuation, and maximum concentration.
3. **Entiende tu progreso** - completion progress, local statistics, reports,
   backup/export, and offline-first privacy.
4. **Hazlo tuyo** - language, theme, typography, sounds, and vibration, followed
   by `Empezar a usar MichiDoro`.

Interaction requirements:
- [x] Show a clear progress indicator and concise Spanish/English copy.
- [x] Provide `Atrás`, `Continuar`, and a visible `Omitir` action.
- [x] Make `Omitir` immediately persist completion and open Home.
- [x] Make the final action persist completion before opening Home.
- [x] Preserve system back behavior without trapping the user or replaying a
      completed onboarding.
- [x] Use responsive, accessible layouts with no clipped text at supported font
      scales.
- [x] Use theme and typography settings already loaded at startup.

Persistence and migration decision:
- Store a versioned local marker such as `completedOnboardingVersion` in
  `michidoro-settings.json`; do not add an SQLite table.
- Treat installations that already contain MichiDoro settings/data when this
  feature ships as already onboarded, so an update does not masquerade as a
  first launch.
- A future onboarding version may be shown only through an explicit product
  decision; changing copy alone must not replay it.

Quality gates:
- [x] Fresh-install routing is `Splash -> Onboarding -> Home`.
- [x] Returning-install routing is `Splash -> Home`.
- [x] Skip and finish each persist before navigation and survive process restart.
- [x] Existing-install migration does not show onboarding unexpectedly.
- [x] Widget tests cover every page, progress, back, skip, finish, Spanish, and
      English.
- [x] Controller/repository tests cover missing, completed, invalid, and future
      marker values.
- [x] `dart format`, `flutter analyze`, and full `flutter test` pass.
- [x] Release APK build/install and Android fresh/returning-install inspection
      pass without erasing the user's real data.

Non-goals:
- Account creation, cloud sync, paywall, permissions, or data collection.
- Replacing the launcher/native splash or turning onboarding into advertising.
- Replaying onboarding on every update.

Traceability impact:
- `REQ-V8-001` was approved for implementation on 2026-07-31.
- Update routing, Settings JSON, UI guidance, client manual, and traceability
  only when implementation begins and verified behavior exists.

Tracks:
- `REQ-V8-001`

## Proposed roadmap - Productivity V9

Status:
Product direction and V9-M0 through V9-M2 were verified on 2026-08-07; V9-M3
was verified on 2026-08-09. V9-M0 through V9-M7 are Verified; V9-M8 is
Implemented pending its remaining integrated verification gates.

Product decision:
Routines are reusable groups of scheduled, repeating tasks. Daily routine
items become ordinary MichiDoro tasks and reuse the existing Goal, Pomodoro,
mood, calendar, statistics, PDF, and unified-database behavior.

Priority rule:
Freeze compatibility and data semantics before schema work. Implement routine
creation before daily generation, then connect execution and reminders. Add
Home/Calendar and reporting only after materialization is trustworthy. Finish
with destructive-case, migration, import/export, performance, and physical
Android verification.

### V9-M0 - Product Contract and Compatibility Baseline

Priority: 0

Status: Verified

Objective:
Define routines precisely and protect every existing workflow and stored row
before implementation begins.

Deliverables:
- [x] Define a routine as a reusable group of timed recurring task templates.
- [x] Keep ordinary Tasks and Pomodoro sessions as authoritative records.
- [x] Select `Tareas -> Rutinas` instead of a sixth navigation destination.
- [x] Define archive-first lifecycle, immutable history, and offline-only scope.
- [x] Document the five-table proposal and its relationship to existing data.
- [x] Approve implementation sequencing and final schema contract.
- [x] Capture the migration fixture matrix for every supported schema source.

Exit criteria:
- [x] `REQ-V9-001` moved to Approved after V9-M0 approval.
- [x] No existing table, column, identifier, status, or user workflow is
      repurposed.
- [x] Every later milestone traces to a testable requirement and dependency.

Verification evidence:
- `ROUTINES.md` fixes columns, nullability, enum values, checks, indexes,
  durable occurrence keys, archive/hard-delete rules, time semantics,
  materialization, editing choices, state derivation, and layer ownership.
- The fixture matrix covers fresh install, unified schemas 1-4, four-file
  legacy data, imports, V9 round trips, corruption, missing tables, invalid
  references, duplicates, future versions, and interrupted migration.
- Documentation links, requirement IDs, milestone statuses, and Markdown diff
  checks passed. No Flutter, generated, Android, dependency, or database file
  changed.

Tracks:
- `REQ-V9-001`

### V9-M1 - Routine Schema and Safe Migration

Priority: 1

Status: Verified

Depends on:
- `V9-M0`

Objective:
Add `routines`, `routine_days`, `routine_items`, `routine_runs`, and
`routine_item_runs` to the unified Drift database without changing existing
row semantics.

Deliverables:
- [x] Finalize columns, enums, indexes, unique occurrence keys, and foreign-key
      delete actions.
- [x] Add the five Drift tables and a routines DAO in the data layer.
- [x] Add domain entities, repository contracts, Drift mappings, and `get_it`
      registration without exposing Drift to UI.
- [x] Implement a forward-only transaction that creates only new tables and
      indexes for existing installations.
- [x] Preserve run/item snapshots after template, item, goal, or task removal.
- [x] Enforce daily materialization idempotency at the database level.
- [x] Add old-schema, empty, populated, foreign-key, delete-rule, rollback, and
      repeated-upgrade tests.
- [x] Regenerate Drift code and update the verified schema version and ERD.

Quality gates:
- [x] `dart run build_runner build --delete-conflicting-outputs` passes.
- [x] Migration fixtures preserve all existing table counts and representative
      row values.
- [x] `PRAGMA integrity_check` and `PRAGMA foreign_key_check` pass.
- [x] `dart format`, `flutter analyze`, and focused persistence tests pass.

Verification evidence:
- Unified schema version 5 contains the original seven tables plus the five
  routine tables; the generated Drift schema and ERD were updated.
- Populated schema 1-4 fixtures migrate without losing representative goal,
  task, session, completion-history, or active-runtime data. Reopening version
  5 is idempotent.
- Thirteen focused tests cover migrations, staged import validation, required
  indexes, future/corrupt backup rejection, aggregate rollback, foreign-key
  deletion rules, immutable snapshots, hard-delete guards, and uniqueness.
- `dart run build_runner build`, formatting, `flutter analyze`, and the full
  170-test suite passed on 2026-08-07.

Tracks:
- `REQ-V9-002`

### V9-M2 - Routine List and Editor

Priority: 2

Status: Verified

Depends on:
- `V9-M1`

Objective:
Create and manage routines from a clear `Tareas | Rutinas` surface with a
guided, conflict-aware editor.

Deliverables:
- [x] Add the `Rutinas` view inside the existing Tasks destination.
- [x] List active, paused, and archived routines with next occurrence, today's
      schedule, and item count. Actual run progress remains in V9-M3.
- [x] Implement create, edit, duplicate, pause, resume, archive, and restore.
- [x] Implement editor steps for identity, weekdays, items/times, and review.
- [x] Support ordered items with time, duration, optional goal, optionality,
      reminder, and Pomodoro preference.
- [x] Show occupied time, focus/break projection, finish time, overlap warnings,
      and validation before save.
- [x] Keep all actions responsive, full-width where appropriate, bilingual,
      accessible, theme-aware, and portrait-safe.

Quality gates:
- [x] Controller and repository tests cover every mutation and validation rule.
- [x] Widget tests cover empty, populated, paused, archived, validation,
      overlap, Spanish, English, and large-text states.
- [x] Phone-width golden/visual checks cover all editor steps without clipping.
- [x] `dart format`, `flutter analyze`, and full `flutter test` pass.

Verification evidence:
- Routine aggregate loading uses three fixed queries; lifecycle changes update
  only the routine row and preserve its days/items.
- Twenty focused routine tests cover validation, overlap math, duplicate IDs,
  every lifecycle action, rollback, empty/populated/status filters, the four
  editor steps, safe dirty-draft discard, Spanish, English, 320 px, and 150%
  text scaling.
- Seven phone-width golden baselines were generated and inspected for the active
  list, all four editor steps, the activity sheet, and in-context creation modal,
  including the visible
  non-blocking overlap warning and stable bottom actions.
- `dart format`, clean `flutter analyze`, and the full 186-test suite passed.
- The initial debug APK built with Java 17, installed, and launched on RMX3301.
- The 2026-08-11 visual refinement added a stable segmented header, consistent
  section surfaces, identity preview, weekday summary, ordered activity cards,
  review summary, and matching modal editor. Seven focused tests, English at
  320 px/150%, dark theme, clean analysis, and the complete 237-test suite passed.
- The release APK updated RMX3301 with data preservation. Direct portrait
  inspection passed all four steps, modal scrolling, contrast, fixed actions,
  singular `1 paso`, and review. The temporary routine was discarded and the
  original stored routine remained present.
- The routine filter was refined on 2026-08-11: redundant `Mostrar` / `Show`
  text was removed and the full-width form field became a 220 px anchored menu.
  Widget dimensions, clean analysis, the 237-test suite, release update, and
  direct RMX3301 closed/open-menu inspection passed without changing data.
- Routine creation was refined on 2026-08-11 to open the existing four-step
  editor as a centered, keyboard-safe modal over the blurred Routines view.
  Existing-routine editing keeps its full-screen route. Golden inspection,
  clean analysis, 237 tests, release installation, keyboard resizing, and
  dirty-draft discard passed on RMX3301 without persisting the temporary draft.

Tracks:
- `REQ-V9-003`

### V9-M3 - Daily Generation and Task Lifecycle

Priority: 3

Status: Verified

Depends on:
- `V9-M1`
- `V9-M2`

Objective:
Materialize today's routine items as ordinary tasks exactly once and reconcile
date changes without producing stale or invented task history.

Deliverables:
- [x] Reconcile on startup, resume, routine save, import, and local-date rollover.
- [x] Insert only necessary current-day tasks with existing schedule, duration,
      status, and optional goal fields.
- [x] Link generated tasks through `routine_item_runs` transactionally.
- [x] Keep future calendar occurrences virtual rather than generating unlimited
      rows.
- [x] Mark elapsed unreconciled occurrences missed without creating old pending
      tasks or invented completions.
- [x] Offer explicit current-occurrence versus future-template editing.
- [x] Preserve snapshots when generated tasks or templates are removed.
- [x] Handle concurrent/repeated reconciliation, restart, import, and clock/date
      changes without duplicates.

Quality gates:
- [x] Property/boundary tests cover weekdays, month/year rollover, leap day,
      daylight/timezone changes, and repeated execution.
- [x] Database constraints prove duplicate generation cannot be committed.
- [x] Existing quick/planned task tests pass unchanged.
- [x] Analyzer and full test suite pass.

Verification on 2026-08-09:
- Startup, resume, local-midnight, routine-save, and post-import paths use one
  idempotent reconciliation entry point.
- Missing scheduled dates since the last active template update become missed
  run/item snapshots without task rows or completion events; only the current
  local day materializes ordinary tasks and future occurrences remain virtual.
- Transactional run/task/item linking plus unique occurrence, materialization,
  and task-link indexes prevent duplicate commits under repeated or concurrent
  reconciliation.
- Current-only versus current-and-future title editing, task status
  synchronization, nullable delete links, and immutable snapshots passed direct
  persistence and existing UI-flow coverage.
- Build Runner completed; 16 focused persistence tests, clean `flutter analyze`,
  and the complete 220-test suite passed, covering weekdays, year rollover,
  leap day, clock/UTC-local adjustment, concurrency, restart-equivalent repeat,
  deletion, existing quick tasks, planning, import, Pomodoro, and reports.
- The release APK rebuilt with JDK 17, updated in place, and launched twice on
  RMX3301. Both startup reconciliations preserved two Pending tasks, zero In
  Progress, zero Completed, and one current routine occurrence without a
  duplicate task.

Tracks:
- `REQ-V9-004`

### V9-M4 - Routine Execution and Pomodoro Continuity

Priority: 4

Status: Verified

Depends on:
- `V9-M3`
- `V6-M0`

Objective:
Start or continue the current routine item by reusing existing task focus,
break, mood, progress, and exclusive-runtime behavior.

Deliverables:
- [x] Start/continue from the routine list, today's run, Home, and Calendar.
- [x] Reuse the current task Pomodoro recommendation and custom cadence flow.
- [x] Preserve total task-ring progress, shortened final block, timed breaks,
      mood reflection, and automatic task completion.
- [x] Synchronize routine run/item state from ordinary task transitions.
- [x] Preserve the one-active-owner conflict dialog and stop/switch semantics.
- [x] Support pause, continue, stop for now, optional skip, whole-run skip, and
      late-start fixed/shifted occurrence choices.
- [x] Restore routine context through backgrounding and process recreation
      without duplicating focused seconds or completing hidden work.

Quality gates:
- [x] Domain/controller tests cover every state transition and exclusivity case.
- [x] Runtime restoration tests cross focus, break, pause, completion, and date
      boundaries.
- [x] Widget tests prove existing task and unassigned Pomodoro behavior remains
      unchanged.
- [x] Release Android smoke verifies active, paused, break, return, and switch.

Implementation evidence:
- One routine execution flow now serves the routine list, Home, and Calendar,
  including late-start fixed/shifted decisions and cadence snapshots.
- Task start/completion callbacks immediately refresh routine run/item state.
- Clean analysis, six focused tests, the 226-test suite, release APK build,
  update-in-place installation, app launch, and non-mutating Home/late-start UI
  inspection passed on RMX3301.
- Physical RMX3301 verification on 2026-08-11 used the one-minute focus and
  twenty-second break preset. Active focus counted down, pause stayed at `00:22`
  through Android Home and app return, resume continued the same block, and the
  timed short break appeared with the post-focus mood reflection.
- Starting `Lectura` while routine task `f` owned the runtime showed Cancel,
  Finalize and switch, and Return to Pomodoro. Return preserved `f`; Finalize and
  switch explicitly opened `Lectura` without a silent owner replacement.
- `flutter analyze` and 47 focused routine/Pomodoro tests passed. The pre-test
  unified database backup was imported after inspection; restart restored the
  routine to Pending `0/1`, six Pending tasks, zero In Progress, one Completed,
  and no active timer.

Tracks:
- `REQ-V9-005`

### V9-M5 - Background Routine Reminders

Priority: 5

Status: Verified

Depends on:
- `V9-M3`
- `V4-M0`
- `V4-M1`

Objective:
Deliver real scheduled routine-item reminders when the app is backgrounded or
closed, with deterministic cancellation and rescheduling.

Deliverables:
- [x] Resolve the approved local notification mechanism, Android permissions,
      exact/inexact scheduling policy, reboot behavior, and battery constraints.
- [x] Schedule only a bounded next-occurrence window from routine templates.
- [x] Keep per-item reminder settings in SQLite and global notification/sound
      preferences in Settings.
- [x] Reschedule after edit, pause, archive, import, restart, timezone/date
      change, and permission change.
- [x] Cancel obsolete reminders and prevent duplicate notification identifiers.
- [x] Degrade clearly when permission or exact scheduling is unavailable while
      leaving the routine usable.
- [x] Keep internal notification-center behavior separate from Android system
      notification overlays.

Quality gates:
- [x] Scheduler tests cover idempotency, cancellation, delayed delivery, restart,
      denied permission, and imported data.
- [x] Physical Android verification covers foreground, background, app closed,
      reboot/process death where supported, silent mode, and denied permission.
- [x] No backend, network dependency, or unapproved package/Gradle change exists.

Verification progress (2026-08-09):
- Android manifest duplicate permission/receiver declarations were removed.
- Native capability reporting and a localized Settings status now distinguish
  ready, exact-alarm fallback, and denied-notification behavior. The denied state
  links to the correct Android settings while routines remain usable.
- Six scheduler tests and two capability-widget tests cover projection,
  idempotency, cancellation, import replacement, denied permission, inexact
  delivery, and the settings action. Clean analysis and all 233 tests pass.
- RMX3301 verified bounded foreground scheduling, background delivery at
  19:00:00.014, consumed-alarm removal, reboot/package restoration, silent
  delivery, denied permission and recovery, and same-offset timezone rebuilding
  with seven alarms before/after and no duplicates.
- The 67.0 MB release APK was built, installed, and launched. Cleanup restored
  `America/La_Paz`, granted notifications, the routine at 08:00 without a
  reminder, and zero active routine alarms.

Tracks:
- `REQ-V9-006`

### V9-M6 - Home and Calendar Integration

Priority: 6

Status: Verified

Depends on:
- `V9-M3`
- `V9-M4`

Objective:
Expose today's routine context and future schedule where users already plan and
act, without duplicating the full editor or overcrowding navigation.

Deliverables:
- [x] Home shows next routine, current/next item, local time, required progress,
      and one start/continue action.
- [x] Calendar merges ordinary tasks, materialized items, and virtual future
      occurrences without duplicate rows.
- [x] Visually distinguish projections from persisted tasks and completed history.
- [x] Open the relevant routine or dated run from Home and Calendar.
- [x] Represent completed, optional skipped, whole-run skipped, and missed states
      consistently.
- [x] Warn about overlaps without silently moving user data.
- [x] Preserve existing Home charts, planning, profile header, and calendar events
      when the database contains no routines.

Quality gates:
- [x] Query/controller tests cover merged and empty schedules across date ranges.
- [x] Widget/golden tests cover dense days, long names, themes, typography,
      Spanish/English, and supported portrait sizes.
- [x] Physical Android inspection verifies navigation, scrolling, no overlap,
      and no duplicate occurrence presentation.

Verification evidence (2026-08-11):
- Home widget coverage passed at 320 px with a long routine, maximum typography,
  Spanish/English, light/dark palettes, and Sora/Merriweather. Dense Calendar
  coverage passed with four overlapping routines, persisted completed/skipped/
  missed outcomes, one virtual pending projection, and stable occurrence keys.
- The matrix found the English `Settings` destination wrapping at 125%. The
  navigation label now preserves the selected font and palette while using the
  compact size above 100%, with a rendered one-line regression assertion.
- `flutter analyze`, 16 focused tests, and the complete 236-test suite passed.
- The JDK 17 release APK built and updated RMX3301 without clearing data. Direct
  portrait inspection passed Home/Calendar navigation, vertical scrolling,
  overlap presentation, and duplicate-free rendering with two distinct stored
  routines and two tasks under both tested language/theme/typography states.
- The device was restored to Spanish, Nature Focus light, 100%, Sora, routine
  progress `0/1`, six Pending tasks, zero In Progress tasks, and unchanged timer
  state.

Tracks:
- `REQ-V9-007`

### V9-M7 - Routine Analytics and PDF

Priority: 7

Status: Verified

Depends on:
- `V9-M3`
- `V9-M4`
- `V5-M3`

Objective:
Add honest routine consistency, timing, focus, and mood analysis to the shared
SQLite reporting engine and PDF output.

Deliverables:
- [x] Define scheduled/completed/skipped/missed denominators and legacy behavior.
- [x] Make consistency percentage primary and streaks secondary.
- [x] Add bounded aggregates for routine completion, item abandonment, start
      delay, planned/actual focus, focused minutes, and average mood.
- [x] Derive focus and mood from linked existing tasks/Pomodoro sessions rather
      than duplicating values in routine tables.
- [x] Add range-aware Home charts/details using the shared report snapshot.
- [x] Add a concise PDF routine section only when data exists.
- [x] Handle archived/deleted templates, partial runs, empty ranges, legacy data,
      and imported history honestly.

Quality gates:
- [x] Formula tests cover every status and denominator edge case.
- [x] SQLite query plans use range and relationship indexes with high-volume
      fixtures and recorded p95 targets.
- [x] Shared Home/PDF snapshot parity tests pass for day, month, year, and custom.
- [x] Rendered multi-page PDFs pass visual inspection in Spanish and English.

Verification evidence (2026-08-09):
- Indexed `[start, end)` Drift aggregates passed exact formula tests for routine
  and item states, optional-only denominators, partial sessions, and a completed
  session crossing midnight.
- The high-volume fixture uses 20,000 routine runs, 20,000 item runs, 20,000
  tasks, and 50,000 Pomodoro sessions; ten measured snapshots stayed within the
  1,000 ms p95 report budget.
- Six rendered PDF pages (three Spanish and three English) passed 144 DPI visual
  inspection without clipping, overlap, blank pages, or broken accents.
- Per-routine streaks follow consecutive scheduled occurrences, so weekends and
  weekly recurrence gaps do not penalize the result; an incomplete occurrence
  resets the sequence.
- `flutter analyze` passed and the complete 202-test suite passed.
- The final debug APK built with JDK 17, updated with data preservation, launched,
  and displayed routine analytics without overflow on RMX3301 / Android 15.

Tracks:
- `REQ-V9-008`

### V9-M8 - Unified Backup and Integrated Verification

Priority: 8

Status: Implemented

Depends on:
- `V9-M1`
- `V9-M2`
- `V9-M3`
- `V9-M4`
- `V9-M5`
- `V9-M6`
- `V9-M7`

Objective:
Prove V9 end to end, including old-data migration and one-file database
export/import, before declaring any routine behavior Verified.

Deliverables:
- [x] Export one consistent `michifocus.sqlite` containing current and routine
      tables after checkpointing active runtime.
- [x] Migrate imported older schemas in staging before replacing the live file.
- [x] Validate schema, integrity, foreign keys, uniqueness, and routine/task links.
- [x] Preserve templates, item order, weekdays, schedules, run snapshots, task
      links, Pomodoro history, mood, reminders, and archive state in round trips.
- [x] Pause an imported active runtime safely while retaining its task/routine
      context.
- [x] Keep supported legacy four-file imports working without fabricated routine
      data.
- [ ] Run adversarial deletion, partial/corrupt import, interruption, clock/date,
      high-volume, accessibility, localization, and visual regression checks.

Definition of done:
- [x] Build Runner, formatting, analyzer, focused tests, and full test suite pass.
- [x] Debug and release APKs build, install, launch, and preserve real device data.
- [ ] Physical Android portrait inspection covers editor, generation, execution,
      background reminder, Home, Calendar, statistics, PDF, restart, and import.
- [ ] Database ERD, schema docs, routing/UI guidance, requirements, traceability,
      client manual, and changelog reflect only verified behavior.
- [ ] All nine V9 requirements have evidence and no unresolved critical finding.

Implementation evidence on 2026-08-09:
- Export uses a checkpointed `VACUUM INTO` snapshot and includes all 12 tables
  in one `michifocus.sqlite` file without settings JSON.
- Import rejects empty/version-zero, future, corrupt, partial-legacy, missing
  table/index, altered-column, non-unique-index, invalid-date, and broken-FK
  fixtures before replacing the live database.
- Complete legacy backups migrate in isolated staging without routine rows.
  Unified round trips preserve routine order, days, reminders, snapshots, task
  links, sessions, mood, archive state, and paused runtime context.
- Interrupted staging leaves the live database untouched; interrupted swapping
  restores the previous database or finalizes a completed replacement.
- Build Runner, formatting, clean analysis, 75 focused tests, and the full
  215-test suite passed. Final debug/release APKs built, installed, and launched
  with `adb install -r`; RMX3301 retained its 217088-byte database.
- Unlocked RMX3301 portrait inspection exported one 217088-byte database to an
  Android document-tree folder. The pulled snapshot passed schema 5, integrity,
  foreign-key, all-table, and readable-row validation, then imported and applied
  after restart with the same routines, tasks, schedules, and statuses.
- Home, routine list/editor, routine start, automatic In Progress state, Focus
  countdown/details, Calendar, routine statistics, the X/Y curve, PDF creation,
  and the three-page Android viewer passed direct inspection. The original
  snapshot was restored afterward, returning to two Pending tasks, zero In
  Progress tasks, and no active timer.
- The singular routine count was corrected to `1 paso` / `1 step`; its focused
  golden, clean analyzer, full 215-test suite, rebuilt release APK, update
  installation, data preservation, and final RMX3301 text inspection passed.
- V9-M5 subsequently passed future reminder delivery, reboot restoration,
  denied permission, silent mode, and timezone reconstruction. V9-M4 passed its
  active/paused/break/return/switch physical matrix, and V9-M6 passed its
  populated bilingual theme/typography Home and Calendar matrix. V9-M8 remains
  Implemented until its explicit adversarial, complete physical-flow,
  documentation, and all-requirement closure gates pass.

Tracks:
- `REQ-V9-009`
