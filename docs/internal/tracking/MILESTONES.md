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

2026-08-24 verified follow-up: `REQ-TASK-009` adds one universal temporal
filter for all, active, and completed tasks, with day, month, year, and
inclusive custom-range options. Counts are scoped to the selected period;
planned tasks use their scheduled date and quick tasks use their creation date.
Formatting, clean analysis, 25 focused Tasks tests, and all 411 project tests
pass. No persistence change was required.
- 2026-08-24 persistence follow-up: first use now defaults to the current local
  day. Every explicit all-time/day/month/year/range selection is stored in a
  dedicated offline preference and restored after process restart; invalid
  preference data falls back to today. Clean analysis, 29 focused Tasks tests,
  and all 415 project tests pass. No Drift schema or package change was needed.

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
- 2026-09-03: Color-theme selection disables MaterialApp's global theme
  animation, avoiding repeated repaint of all branches retained by the indexed
  tab shell. The integrated widget test locks the transition duration to zero;
  focused analysis/test and the complete 495-test suite pass.
- The Java 17 debug APK installed and launched on the wireless RMX3301 while
  preserving its existing data; final perceived-latency confirmation remains
  physical.
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

Current sequence:
1. **Todo tu día, en un lugar** - tasks, goals, routines, notes, date filters,
   and daily/weekly planning.
2. **Enfoque que se adapta a ti** - exact remaining time, persisted progress,
   Clear/OLED maximum concentration, and optional Android silence.
3. **Tus datos siguen siendo tuyos** - selectable local storage, encrypted
   Syncthing exchange, multiple phones, and visible conflict review.
4. **Mide, dicta y personaliza** - statistics, report/PDF export, dictation,
   language, palette, typography, sound, and vibration, followed by
   `Empezar a usar Michi Focus`.

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
- [x] Resolve onboarding surfaces, illustrations, text, icons, and controls from
      the selected light or dark theme palette.

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
- [x] The 2026-08-31 maintenance refresh passed five focused onboarding tests,
      four updated golden baselines, explicit light/dark palette coverage, and
      the complete 489-test suite.
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
  text was removed and the form field became a compact anchored menu. On
  2026-08-24 its visible trigger returned to the full available width while the
  popup remained 220 px; optional activity cards also gained one balanced
  Edit/Skip row. Widget dimensions, nine focused tests, clean analysis, and all
  415 project tests pass without changing data.
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

### V9-M6 - Routine Access and Calendar Integration

Priority: 6

Status: Verified

Depends on:
- `V9-M3`
- `V9-M4`

Objective:
Keep routine execution in `Tareas -> Rutinas` and expose future schedules in
Calendar without duplicating a routine surface in Home or overcrowding
navigation.

Deliverables:
- [x] Home does not duplicate routine summary or execution controls.
- [x] `Tareas -> Rutinas` owns routine summary, current activity, start/continue,
      edit, and optional-skip actions.
- [x] Calendar merges ordinary tasks, materialized items, and virtual future
      occurrences without duplicate rows.
- [x] Visually distinguish projections from persisted tasks and completed history.
- [x] Open the relevant routine or dated run from `Tareas -> Rutinas` and
      Calendar.
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
- On 2026-08-24 the user explicitly consolidated routine access under
  `Tareas -> Rutinas`. The Home card was removed, the routine-list filter now
  spans the available width, and Edit/Skip share one row when skipping is
  available. Nine focused tests, clean analysis, and all 415 tests pass; the
  existing Calendar projection remains unchanged.

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

## Approved roadmap - Productivity V10

### V10-M0 - Unified Goals Planning Hub

Priority: 1

Status: Verified

Objective:
Move the complete calendar planning experience into Goals and add explicit
goal-period filtering without duplicating data, routes, or persistence.

Deliverables:
- [x] Remove the separate Home Planning card.
- [x] Make Goals render calendar, selected-day goals, tasks, routine
      occurrences, and events.
- [x] Add All, Day, Week, Month, Year, and custom-range goal filters.
- [x] Present custom ranges in a compact Start/End calendar dialog with visible
      range highlighting and no full-screen system picker.
- [x] Keep undated goals visible and dated goals ordered chronologically.
- [x] Preserve create/edit/delete, task planning, routine opening, and Focus
      entry behavior.
- [x] Redirect or alias legacy calendar navigation to Goals.

Quality gates:
- [x] Focused widget tests cover every period boundary and undated goals.
- [x] Navigation tests prove Home has no Planning card and `/calendar` lands in
      the Goals tab.
- [x] Spanish/English, 320 px, large text, light/dark, and portrait visual checks
      pass without overflow.
- [x] `dart format`, `flutter analyze`, and full `flutter test` pass.

Verification evidence on 2026-08-11:
- Clean analyzer and 245 passing tests.
- Inclusive period-boundary, undated-goal, legacy-route, and unified-calendar
  coverage passed.
- RMX3301 portrait inspection confirmed Home without the Planning card and
  Goals with the calendar, two-row filters, and selected-day agenda.
- Start/End range interaction and 320 px large-text rendering passed focused
  widget coverage.
- RMX3301 inspection confirmed direct opening, readable Inicio/Fin fields,
  inclusive range highlighting, and the guarded Apply action.
- Release APK built and updated without clearing the existing local database.

Tracks:
- `REQ-V10-001`

### V10-M1 - Protected database reset

Priority: 2

Status: Verified

Objective:
Provide an explicit, transaction-safe way to clear every record from the
unified SQLite database while retaining local preferences and external files.

Deliverables:
- [x] Add a final danger-zone card to Settings.
- [x] Require typed `BORRAR` / `DELETE` confirmation.
- [x] Clear all 12 unified tables in dependency-safe order and one transaction.
- [x] Stop active Focus runtime and refresh all feature controllers.
- [x] Preserve settings JSON, selected folders, reports, and external backups.

Quality gates:
- [x] Persistence tests verify every table is empty and foreign keys remain
      valid after reset.
- [x] Widget tests verify cancel, disabled confirmation, and bilingual copy.
- [x] Clean analyzer and full Flutter test suite.
- [x] Release APK update and physical portrait verification.

Verification evidence:
- Clean analysis and 247 automated tests on 2026-08-11.
- Release APK installed on RMX3301; destructive card, confirmation dialog,
  typed `BORRAR`, and enabled final action inspected in portrait.
- Physical deletion was intentionally cancelled; the transactional destructive
  path is covered with a populated in-memory SQLite database.

Tracks:
- `REQ-SET-007`

## Approved roadmap - Productivity V11

Productivity V11 adds optional Android-to-Android synchronization through a
user-selected folder transported by Syncthing. Single-device mode remains the
default. The user approved implementation and then required password plus
recovery-key encryption on 2026-08-13, superseding the earlier plaintext choice.
No real user data may be published until the cryptographic design and dependency
boundary pass review.

### V11-M0 - Synchronization contract and risk prototype

Priority: 1

Status: In Progress

Objective:
Freeze the product boundary and prove the highest-risk causal, Android storage,
and Syncthing assumptions before changing production persistence.

Deliverables:
- [ ] Approve single-device default and selected-folder semantics.
- [ ] Approve the 12-table synchronization/local-only policy.
- [ ] Prototype secure IDs, per-device counters, causal comparison, and
      field-level concurrent merge with two-, three-, and four-device fixtures.
- [x] Prototype immutable publication and stable-file detection through the
      existing Android document-tree boundary without adding a package.
- [x] Require authenticated application-level encryption with password and an
      independent recovery key; plaintext exchange is rejected.
- [ ] Select and approve a maintained cryptographic implementation, algorithm
      suite, KDF parameters, Android Keystore boundary, and key-rotation format.
- [ ] Prototype password unlock, recovery unlock, wrong-key rejection, tamper
      rejection, and measured KDF performance on target Android hardware.
- [ ] Record measured file-count, latency, and compaction estimates.

Quality gates:
- [ ] The prototype proves convergence under reordered and duplicated delivery.
- [ ] Clock skew cannot change causal or conflict outcomes.
- [ ] A truncated or foreign-group file cannot reach application tables.
- [x] Encryption, password, and recovery-key product decisions are approved.
- [ ] Cryptographic dependency/native boundary and threat model are approved.

Implementation evidence on 2026-08-13:
- Added an isolated `features/sync` prototype with immutable causal versions,
  causal candidates, field/record merge, and scoped 128-bit secure identifiers.
- Logical counters classify equal, older, newer, and concurrent state without
  reading wall-clock timestamps.
- Compatible concurrent fields merge, concurrent same-field values remain
  visible, repeated operations are idempotent, and causally older candidates
  are removed.
- Nine focused tests pass. They cover all four-device compatible-delivery
  permutations with a duplicate, all three-record conflict permutations, and
  4,000 generated identifiers.
- The complete Flutter suite passes with 266 tests.
- The V11 files are analysis-clean. Full repository analysis retains one
  pre-existing info-level dependency warning in a temporary physical-verification
  script outside V11.
- No schema, DI, UI, Android, Syncthing folder, or production data path changed.
- The user superseded the earlier plaintext choice on 2026-08-13 and required
  password plus recovery-key encryption. No encryption code or package has been
  added; security design and dependency approval remain M0 gates.

Tracks:
- `REQ-V11-001`
- `REQ-V11-002`
- `REQ-V11-003`
- `REQ-V11-009`

### V11-M0.1 - Local biometric/PIN unlock and protected key access

Priority: 2

Status: In Progress

Objective:
Add the optional local security boundary that lets Android biometrics or the
registered device credential unlock MichiFocus and its device-protected group key
without asking for the group password on every normal application opening.

Deliverables:
- [x] Implement and persist `Never`, `Immediately`, `After 1 minute`, and
      `After 5 minutes` policies with protection disabled by default.
- [x] Implement the policy controller, persist it, load it before application
      content, and wire monotonic lifecycle decisions into production.
- [x] Add a native capability and authentication bridge for strong biometric or
      device credential, with a system credential fallback on older Android.
- [x] Wrap the cached group DEK with a device-bound Android Keystore key that
      requires successful user authentication.
- [x] Gate every cold start with the existing Android system authenticator before
      any bootstrap/loading work, then run the percentage loading exactly once.
- [x] Route directly to onboarding or Home after bootstrap so the percentage
      loading is not replayed from 0 to 100.
- [ ] Add system-prompt unlock, locked-content overlay, cancellation, retry,
      secure-key invalidation, and password/recovery rebind flows.
- [ ] Defer incoming encrypted operation application while locked and resume it
      only after the local key becomes available.

Quality gates:
- [x] Policy, cold-start, timeout-boundary, repeated-lifecycle, and fail-closed
      unit tests pass.
- [x] Startup widget tests prove pending or cancelled authentication cannot start
      bootstrap or expose percentage loading, while success starts it once.
- [ ] Widget tests prove sensitive content and navigation cannot bypass the lock.
- [ ] Native tests prove the app never handles the Android device credential and
      cannot use the protected key without authorized system authentication.
- [ ] Restart, cancellation, biometric/device-credential fallback, Keystore
      invalidation, and recovery pass on supported physical Android phones.

Tracks:
- `REQ-V11-003`
- `REQ-V11-010`

Implementation evidence on 2026-08-13:
- Added an isolated `LocalUnlockPolicy` with disabled, immediate, one-minute,
  and five-minute choices; enabled policies start locked after process restart.
- Added a Signals-based lifecycle controller using an injectable monotonic source.
  Repeated background events cannot extend the grace period, and invalid negative
  elapsed time fails closed.
- Ten focused lock-policy tests and all 19 sync tests pass. The complete Flutter
  suite passed with 266 tests in the first isolated slice.
- The second slice adds a dedicated policy repository/file, DI registration,
  startup loading, real lifecycle wiring, and a themed lock gate that removes
  sensitive routed content while locked.
- Four repository tests, two added controller persistence tests, and four lock-gate
  widget tests bring focused sync coverage to 29 passing tests and the complete
  Flutter suite to 276 passing tests. Scoped analysis reports no issues.
- The unlock button deliberately remains disabled until a trusted Android
  authenticator is wired. No native authentication, Keystore access, Android
  file, package dependency, user-facing enable switch, or sync data path changed.
- The third slice connects the lock gate to a native Android system prompt. The
  channel exposes only capability and boolean success; cancellation, missing
  bridge, unavailable device security, and native errors fail closed.
- Android 10+ offers the platform biometric/device-credential dialog. Android
  6-9 uses platform credential confirmation. No PIN, pattern, password, face, or
  fingerprint material crosses into Dart.
- Seven new controller/bridge tests bring focused sync coverage to 36 passing
  tests and the complete suite to 283. Scoped analysis is clean, and a debug APK
  compiles successfully with the installed Java 17 without changing Gradle.
- Android Keystore key wrapping, user-facing policy selection, key invalidation,
  physical-device authentication, and encrypted DEK access remain pending.
- The fourth slice adds the user-facing Settings card and an inherited
  controller boundary without scattering service-locator access into widgets.
  Enabling defaults to five minutes; immediate and one-/five-minute choices are
  visible only while protection is active.
- Every enable, timeout change, and disable action authenticates first. Four
  widget tests prove successful persistence and unchanged state after
  cancellation. Focused sync coverage reaches 40 tests and the complete suite
  reaches 287 passing tests; scoped analysis remains clean.
- Android Keystore work remains correctly deferred until group enrollment owns a
  real DEK to wrap; this UI slice creates no placeholder secret or false key state.

Implementation evidence on 2026-08-15:
- The application composition root now mounts the lock surface and requests the
  existing Android system authenticator before import, migration, dependency
  registration, database access, reconciliation, or controller loading.
- Authentication failure, cancellation, unavailability, and bridge errors stay
  fail-closed with a retry action. Successful startup authentication is handed to
  the existing local-lock controller so no redundant second prompt appears before
  entering the application.
- Three startup widget tests plus the existing controller/gate coverage pass as a
  22-test focused set. Scoped analysis is clean and the debug APK builds. The full
  suite is currently blocked by an unrelated pre-existing UTC/local-time assertion
  in `drift_sync_outbox_publication_service_test.dart`; full analysis retains only
  the unrelated temporary `sqlite3` dependency notice.

Implementation evidence on 2026-09-01:
- Corrected lifecycle classification so transient Android `inactive` events,
  such as system overlays, do not begin the one-/five-minute grace period.
- The first real `hidden` or `paused` event starts the monotonic interval;
  repeated lifecycle events preserve that original instant and resume applies
  the exact configured boundary.
- Settings now explains that the interval counts only in the background and
  that a fully closed process always requires cold-start authentication.
- Twenty-one focused controller/widget checks and all 495 project tests pass;
  physical Realme/Poco timeout verification remains pending.

### V11-M1 - Local storage mode, recovery folder, and sync metadata

Priority: 3

Status: In Progress

Objective:
Add the safe local foundation while preserving current behavior when the
multi-device switch is off.

Deliverables:
- [x] Add single-device/multi-device setting with single device as the default.
- [x] Let either mode select, validate, change, or disconnect its data folder.
- [ ] Keep live `michifocus.sqlite` in private app storage.
- [ ] In single-device mode, create versioned, consistent recovery snapshots.
- [x] Design and migrate durable group/device, outbox, applied-operation,
      causal-version, tombstone, conflict, and acknowledgement metadata.
- [x] Preserve all existing rows, IDs, foreign keys, indexes, import, export,
      reset, reports, and device-local settings.

Quality gates:
- [x] Schema migration fixtures preserve all 12 existing tables and representative data.
- [ ] Folder-access loss never blocks ordinary offline use.
- [ ] Mode-off regression tests prove no exchange work or new user-visible behavior.
- [ ] Build Runner, formatting, analyzer, focused tests, and full suite pass.

Tracks:
- `REQ-V11-001`
- `REQ-V11-004`
- `REQ-V11-008`

Implementation evidence on 2026-08-13:
- Added a persisted `singleDevice`/`multipleDevices` configuration with malformed
  or future values falling back to single device and no selected folder.
- Added a user-facing Settings card in both modes for selecting, changing, and
  disconnecting an Android document-tree folder. The persisted URI and friendly
  label contain no user task data or credential.
- The multiple-device choice requires confirmation explaining that the private
  live database is not moved and no data is shared until a protected group is
  created or joined.
- Changing mode preserves the folder reference; disconnecting it preserves mode
  and does not touch the private database. Mode selection currently prepares UI
  state only and cannot publish exchange data.
- Thirteen focused storage tests bring all sync coverage to 53 passing tests; the
  complete Flutter suite passes with 300 tests, scoped analysis is clean, and the
  debug APK compiles with Java 17.
- Folder write validation, recovery snapshots before operational transitions,
  group metadata, exchange metadata, and physical permission-loss checks remain.

Implementation evidence on 2026-08-14:
- Unified schema version 6 adds seven private metadata tables for the local
  logical counter, durable outbox, applied ledger, field versions, tombstones,
  conflicts, and acknowledgement watermarks. The 12 application tables, their
  row identifiers, foreign keys, and indexes are unchanged.
- A new Drift boundary commits a caller-supplied application mutation, counter
  advance, and outbox row atomically. Remote application and idempotency-ledger
  insertion are also atomic; exact repeats are ignored and inconsistent reuse
  of an operation ID or origin counter is rejected.
- Schema 1-5 migration, import validation, total reset, rollback, monotonic
  counter, and deduplication checks pass in 21 focused tests. Build Runner and
  scoped analysis pass, and all 381 tests pass. Full analysis keeps only the
  unrelated existing `tmp/verify_physical_database_round_trip.dart` notice.
- The debug APK builds, installs over the existing app without clearing data,
  launches, and is confirmed as the focused activity on the connected RMX3301.
- No existing goal/task/calendar/routine repository is wired to this boundary
  yet, so this slice cannot publish or apply user-data changes and does not
  falsely activate task or routine transfer.

### V11-M2 - Device enrollment and immutable exchange engine

Priority: 4

Status: In Progress

Objective:
Create or join a sync group and exchange validated operations without requiring
manual identifiers or shared mutable files.

Deliverables:
- [x] Generate stable installation identity and editable friendly name.
- [ ] Create group manifest, owner-encoded immutable operation namespace,
      protocol version, and counters.
- [ ] Publish durable outbox operations with temporary/finalized file handling.
- [ ] Scan, validate, deduplicate, defer, retry, apply, acknowledge, and quarantine.
- [ ] Support safe empty-device bootstrap and populated-device merge/replace choice.
- [ ] Refresh only affected controllers after successful remote commit.

Quality gates:
- [ ] Reinstall, duplicate model names, renamed devices, group mismatch, future
      protocol, missing parent, partial file, and repeated file tests pass.
- [ ] Local commit survives publication failure and retries exactly once logically.
- [ ] Remote aggregate rollback leaves no partial database or applied-ledger state.

Tracks:
- `REQ-V11-002`
- `REQ-V11-003`
- `REQ-V11-004`

Approval and implementation evidence on 2026-08-13:
- The user's repeated instruction to continue approved starting this milestone's
  first bounded slice; group creation, enrollment, encryption, and exchange remain
  unavailable until their own gates are implemented.
- MichiFocus now creates one private, secure-random 128-bit installation ID on
  first startup and reuses it across later app startups. The identifier does not
  depend on the phone model, friendly name, clock, folder, or Syncthing.
- Android proposes a local manufacturer/model label with a safe fallback. The
  multiple-device Settings surface lets the user rename it and shows only a short
  internal-ID suffix for disambiguation; renaming preserves the full identity.
- Identity initialization is wired through dependency injection before app content
  and persisted separately from the live SQLite database and selected shared folder.
- Thirteen new identity tests cover missing/malformed storage, persistence, native
  bridge failure, stable restart, model suggestion, rename safety, single-mode
  hiding, and multiple-mode UI. All 66 sync tests and the full 313-test suite pass;
  final focused tests and scoped production analysis are clean, and the debug APK
  compiles with the Android native model bridge.
- Group ID creation, duplicate-name device lists, reinstall/recovery authority,
  retirement, encrypted enrollment, and physical-phone inspection remain pending.

Additional implementation evidence on 2026-08-13:
- Folder selection now succeeds only after Android creates a unique probe file,
  writes known non-sensitive bytes, reads and compares them, and removes the file.
- Settings rechecks an existing folder without touching SQLite. Revoked access is
  shown as an actionable warning with a retry/reselection path; the stored folder
  reference remains available for recovery and all local app flows stay independent.
- Seven new validator/controller/widget tests bring focused sync coverage to 73
  and the complete suite to 320 passing tests. Scoped production analysis is clean
  and the debug APK compiles with the native Storage Access Framework probe.
- The approved cryptographic review found no mature memory-hard password KDF in
  the current dependency set. To avoid a weak or partial group, password, recovery
  key, DEK, and group-manifest persistence remain unimplemented pending an explicit
  dependency approval and measured Android parameter review.
- The user then explicitly approved the required dependency. `cryptography 2.9.0`
  was added without changing Android Gradle.
- Added the versioned `argon2id-aes256gcm-v1` key-manifest core: one random
  256-bit DEK is wrapped independently through the password and a random 256-bit
  recovery key. Authenticated context binds each wrapper to its group and purpose;
  password and plaintext keys are absent from serialized JSON.
- Six focused tests prove both unlock paths, JSON secrecy, wrong-credential,
  cross-group and tamper rejection, password policy, and pre-KDF rejection of
  hostile parameters. Sync coverage reaches 79 tests and the complete suite 326;
  full analysis retains only the unrelated pre-existing `tmp` dependency notice.
- The provisional profile is 64 MiB, three passes, one lane, and 32-byte output.
  Physical Android timing/memory review remains required before create/join UI,
  group persistence, or external manifest publication.
- Added the device-bound key-protection contract and Android Keystore bridge.
  Android generates a non-exportable per-group AES-256 key, requires system user
  authentication, and wraps the group DEK with AES-GCM plus group-bound context.
- Six bridge tests cover availability, key presence, wrap/unwrap contracts,
  deletion, native error mapping, and unavailable bridges. Focused sync coverage
  reaches 85 passing tests; the complete Flutter suite reaches 332 passing tests
  and scoped V11 analysis is clean.
- The debug APK compiles, installs over the existing app without clearing its
  data, and launches on the connected Android phone. At that bridge-only slice,
  no physical enrollment entry point existed and Keystore invocation remained a
  pending gate.
- Added the first-phone enrollment controller, atomic encrypted local repository,
  inherited presentation scope, and multi-device Settings card. No password or
  recovery key is written to disk; the recovery key exists only during the
  confirmation step.
- Creation requires a selected folder, matching 12-character-or-longer password,
  and Android authentication. Confirmation persists the versioned key manifest
  and device-bound envelope; cancellation removes the provisional Keystore alias.
- Eleven new repository/controller/widget tests bring focused sync coverage to
  96 and the full Flutter suite to 343. Scoped V11 analysis is clean, and the
  rebuilt APK installs preserving data and launches on the connected phone.
- Application-data publication, joining a second phone, rebind/recovery UI, and
  a user-completed physical cryptographic enrollment remain pending.
- A dedicated physical RMX3301 diagnostic then measured the production Argon2id
  profile at 1,670 ms for group creation and 1,000 ms for password unlock without
  an out-of-memory failure. The normal APK was rebuilt, reinstalled preserving
  data, relaunched, and confirmed as the resumed activity afterward.
- Added immutable, idempotent group-manifest publication through Android SAF.
  Temporary bytes are read back before finalization, rename is preferred, and a
  verified-copy fallback supports document providers without rename.
- The publisher refuses to overwrite different bytes for the same group. Folder
  failure or conflict preserves local enrollment and exposes an honest retry;
  successful UI copy says only that Syncthing can transport the file.
- Four publisher bridge tests and one publication-retry controller test bring
  focused sync coverage to 101 and the full suite to 348. Scoped analysis is
  clean and the native APK compiles. The previously connected phone was offline,
  so physical SAF publication remains explicitly pending.
- Added read-only joining-phone manifest discovery. Android returns only exact
  finalized group-manifest names with a 64 KiB ceiling; Dart repeats the group,
  protocol, suite, KDF, and envelope-shape checks before any expensive KDF work.
- The multi-device Settings card can search and report valid groups and rejected
  files without enrolling, decrypting, importing, or changing local SQLite data.
  Seven added checks bring sync coverage to 108 and the full suite to 355. Scoped
  analysis is clean; the APK compiles, installs preserving data, and launches on
  the wirelessly connected RMX3301. Physical SAF discovery with a user-selected
  folder and data bootstrap remain pending.
- Added password-or-recovery linking for a validated discovered group. Correct
  credentials are followed by Android system authentication; the same group ID
  and DEK are protected with this phone's Keystore key without creating a second
  group or touching the private SQLite database.
- Wrong credentials, cancelled authentication, and persistence failures leave no
  enrollment; a provisional device alias is removed after a failed save and the
  mutable clear-key buffer is erased. Seven new checks bring focused sync coverage
  to 115 and the complete suite to 362. Scoped analysis is clean; the APK builds,
  installs preserving data, and launches on RMX3301. User-completed physical
  folder/password/biometric linking and bootstrap/merge decisions remain.
- Added a read-only joining-phone data inspection across goals, tasks, calendar
  events, focus sessions, completion events, routines, and routine runs. Empty
  phones record an empty-bootstrap intent; populated phones require an explicit
  merge-or-replace choice before secure enrollment can finish.
- The choice is persisted but no data is changed yet. Replacement remains gated
  on a verified recovery snapshot. Five new checks bring sync coverage to 120 and
  the complete suite to 367; scoped analysis is clean and full analysis retains
  only the unrelated existing temporary `sqlite3` notice. The debug APK builds,
  installs preserving app data, and launches as the resumed activity on RMX3301.
- Added full encrypted recovery snapshots after explicit user authorization.
  MichiFocus snapshots with `VACUUM INTO`, validates the isolated 12-table SQLite
  copy, encrypts/authenticates it with the group DEK, and asks Android SAF to
  verify the immutable final artifact without exposing the live database.
- Populated new joins fail closed until the snapshot succeeds. Previously
  enrolled phones receive a post-enrollment action protected by Android system
  authentication; no group-password re-entry is required. Failed publication
  preserves both local data and enrollment and removes private temporaries.
- Nine new checks bring sync coverage to 129 and the complete suite to 376.
  Drift generation and scoped analysis pass; full analysis retains only the
  unrelated existing temporary `sqlite3` notice. The debug APK builds, installs
  preserving data, and launches on RMX3301. Physical user-confirmed SAF snapshot
  creation and application-data exchange remain pending.

### V11-M3 - Core goals, tasks, and calendar convergence

Priority: 5

Status: In Progress

Objective:
Deliver the first useful multi-device slice for stable mutable user data before
adding routines and focus history.

Deliverables:
- [ ] Synchronize goal create/edit/delete and task detachment rules.
- [x] Synchronize task create, planning fields, goal link, status, and deletion.
- [ ] Synchronize calendar event create and deletion behavior.
- [ ] Merge concurrent disjoint fields automatically.
- [ ] Surface same-field and delete/update conflicts.
- [ ] Preserve tombstones across long-offline delivery.

Quality gates:
- [ ] Two-, three-, and four-device permutations converge without duplicates.
- [ ] Foreign keys and task-completion history remain valid under every delivery order.
- [ ] Existing single-device Goals, Tasks, Calendar, and reports do not regress.

Progress on 2026-08-15:
- Goal, task, and calendar create/mutation paths now generate causal operations
  atomically with their local SQLite work when multiple-device mode is enrolled.
- An authenticated action encrypts pending operations and publishes immutable
  files only beneath this installation's directory; failures remain retryable.
- The Settings warning that transfer was inactive was replaced by the real
  `Preparar cambios para Syncthing` action and honest local publication status.
- Remote scanning, application, conflict surfacing, calendar deletion, and the
  convergence quality gates remain open; therefore no deliverable above is yet
  marked complete.
- Scoped analysis and all 393 tests pass. The debug APK builds with Java 17,
  installs preserving data, launches, and remains running on RMX3301.

Incoming progress on 2026-08-15:
- Android SAF now enumerates bounded canonical operation files only from other
  installation directories. Dart repeats path/envelope checks, authenticates
  and decrypts the payload, rejects foreign or unsupported operations, and
  processes dependencies in goal/routine/task/calendar order.
- Task create/update/delete and compatible field merges apply transactionally
  with the applied-operation ledger and causal versions. Exact repeats are
  no-ops; concurrent same-field and delete/update work creates a durable
  conflict rather than overwriting or resurrecting deleted data.
- Settings now exposes `Revisar cambios recibidos`, requires Android
  authentication, creates the encrypted recovery snapshot first when needed,
  reports applied/conflict/deferred/rejected counts, and refreshes app data only
  after commit. Calendar deletion, conflict choices, quarantine movement, and
  multi-phone convergence gates remain open.
- Clean scoped analysis and the complete 399-test suite pass after the incoming
  application, routine publication, idempotency, same-field conflict, and
  delayed-update-after-delete coverage.
- The final release APK compiles with the Android SAF scanner, installs with
  `adb install -r` preserving data, launches, and remains focused/running on the
  RMX3301. User-authenticated folder review and two-phone Syncthing transport
  remain the physical acceptance gate.
- Added idempotent initial publication for mutable data that existed before
  enrollment. Preparing changes queues goals, routine aggregates, tasks, and
  calendar events in dependency order only when the entity has no causal history,
  tombstone, or prior outbox operation.
- The eligibility check, counter advance, outbox insertion, and initial field
  versions are transactional. Repeating preparation keeps the same four logical
  operations in the populated fixture instead of creating duplicates.
- Drift generation, formatting, clean `lib`/`test` analysis, focused bootstrap,
  key-buffer, publisher/discovery, and controller tests, and the complete
  404-test suite pass. Empty-device
  restore, replace-local execution, immutable history, and physical two-phone
  transport/application remain pending.
- Physical inspection then identified two independent blockers: the populated
  Poco retained `restoreIntoEmpty` while reporting 18 local records, and Realme
  retained four operations after nested SAF publication failed.
- Bootstrap now runs for every enrollment except explicit `replaceLocal`, skips
  remote-origin baselines, and repairs an older local-only update with one full
  create baseline. Operation publication/discovery uses unique flat root names
  because root-level manifests and encrypted recovery files already work on both
  selected Android document providers.
- A follow-up Realme diagnostic found that Android returned the unwrapped DEK as
  an unmodifiable byte list, so secure erasure threw after publication. The
  controller now makes an explicitly mutable short-lived copy before use and
  erases that copy; tests exercise an unmodifiable platform result.
- The first flat operation name was still about 137 characters. It is now a
  bounded hexadecimal `michifocus-op-...` name of about 108 characters while
  retaining owner, counter, and operation identity. This addresses document
  providers whose practical filename limit is shorter than the filesystem's
  nominal limit. Release APK installation succeeds on Poco and Realme without
  clearing data; authenticated two-phone publication and transport remained open.
- On 2026-08-21, physical publication identified one final compatibility issue:
  older outbox digests included milliseconds that Drift had stored at Unix-second
  precision. Publication now recovers only the legacy millisecond whose canonical
  payload matches the durable SHA-256 digest, while new operation timestamps are
  normalized before hashing and persistence. Invalid digests remain rejected.
- The corrected release installed preserving data on Poco 2201117PG and Realme
  RMX3301. Authenticated preparation published 18 and 11 distinct operations;
  Syncthing transported all 29 files to both selected folders without overwrite.
  Incoming review then applied 18 operations on Realme and 11 on Poco, with zero
  conflicts, deferred dependencies, or rejected files on either phone. Drift
  generation, focused tests, clean `lib`/`test` analysis, and all 405 tests pass.
  This closes the first bidirectional physical publication/transport/application
  gate; delayed, offline, background, conflict-resolution, history, and broader
  convergence matrices remain open.

Tracks:
- `REQ-V11-004`
- `REQ-V11-005`

### V11-M4 - Routine aggregates and immutable history

Priority: 6

Status: In Progress

Objective:
Synchronize routine definitions and completed history without duplicating daily
materialization or inventing report data.

Deliverables:
- [x] Synchronize routine template, weekdays, ordered items, lifecycle, and reminders as an aggregate.
- [ ] Preserve one logical routine occurrence and item materialization per existing key.
- [ ] Append and deduplicate routine-run, item-run, Pomodoro-session, and
      task-completion history.
- [ ] Recompute conservative reporting trust metadata and derived statistics.
- [ ] Defer dependent history until its required parent data is available.

Quality gates:
- [ ] Simultaneous daily reconciliation on four phones creates one logical occurrence.
- [ ] Archived/deleted templates, task links, snapshots, mood, optional items,
      skips, missed runs, and reminders retain current semantics.
- [ ] Converged phones produce equivalent report inputs and totals.

Progress on 2026-08-15:
- Routine create/edit, pause/resume, archive/restore, and guarded deletion now
  produce encrypted causal operations. Templates carry weekdays, ordered items,
  goal links, optionality, reminders, and Pomodoro preferences as one aggregate.
- A received aggregate applies through the existing Drift aggregate transaction;
  retries are idempotent and lifecycle operations share one aggregate causal
  field so concurrent routine intent cannot be silently split.
- Routine runs, item runs, completion history, Focus history, report trust, and
  four-phone materialization convergence remain open.

Tracks:
- `REQ-V11-004`
- `REQ-V11-005`

### V11-M5 - Conflict center, tombstones, and deterministic resolution

Priority: 7

Status: In Progress

Objective:
Make unavoidable concurrent intent visible and ensure one resolution converges
on every active phone.

Deliverables:
- [ ] Add a conflict center grouped by entity and origin device.
- [ ] Show local, remote, and relevant merged context with friendly device names.
- [x] Offer use-local, use-remote, and safe preserve-both actions where applicable.
- [x] Publish every resolution as a causally newer operation.
- [x] Implement delete/update resolution and resurrection prevention.
- [ ] Distinguish user conflicts from quarantined integrity/protocol failures.

Quality gates:
- [ ] Concurrent same-field, delete/update, duplicate resolution, delayed
      resolution, and third-device arrival cases converge.
- [x] No conflict is silently resolved by wall-clock ordering.
- [ ] Spanish, English, 320 px, large text, light/dark, and accessibility checks pass.

Implementation evidence:
- 2026-08-24: Settings gained a themed, bilingual conflict sheet with explicit
  confirmation, local/remote values, dates, device labels or stable suffixes,
  and safe disabled states for incomplete candidates.
- Resolution now commits the chosen application value and a causally dominating
  outbox operation atomically. A later phone consumes that operation and closes
  its matching conflict when both candidate versions are dominated.
- Schema 7 adds backward-compatible encrypted operation context: the originating
  friendly name and a full entity snapshot. Delete/update restoration no longer
  guesses missing fields, and existing schema-6 databases migrate in place.
- Safe goal and calendar-event conflicts can preserve both versions atomically;
  task and routine duplication remains intentionally unavailable because it can
  detach execution or historical links.
- Clean `lib`/`test` analysis, all 162 sync tests, and all 423 project tests
  pass. Complete arrival-order
  permutations, accessibility matrices, immutable-history integrity conflicts,
  and physical two-phone conflict creation remain.

Tracks:
- `REQ-V11-005`
- `REQ-V11-007`

### V11-M6 - Pomodoro ownership and completed-result synchronization

Priority: 8

Status: Proposed

Objective:
Synchronize useful Focus outcomes while keeping the active timer safe and honest
under delayed file transport.

Deliverables:
- [ ] Keep `pomodoro_runtime` local to its origin phone.
- [ ] Publish and display last-known task/device ownership as informational state.
- [ ] Synchronize completed session, task progress, completion event, mood, and
      routine outcome as one logical result.
- [ ] Preserve simultaneous legitimate sessions without dropping focused time.
- [ ] Explain that disconnected phones cannot provide a global timer lock.

Quality gates:
- [ ] Running, paused, break, early-stop, complete, mood-pending, restart, and
      owner-offline cases preserve current local recovery.
- [ ] Contradictory task state becomes a deterministic merge or visible conflict.
- [ ] No remote operation starts, stops, transfers, or reconstructs a live countdown.

Tracks:
- `REQ-V11-006`

### V11-M7 - Status, guidance, retention, and device lifecycle

Priority: 9

Status: In Progress

Objective:
Make the feature understandable and keep its files bounded without abandoning
offline devices silently.

Deliverables:
- [ ] Show device, folder, local publication, remote observation, conflict, and
      last-processing status without claiming unobservable transport completion.
- [x] Add `Preparar y revisar cambios` as the primary authenticated local action.
- [x] Add a separate `Abrir Syncthing` action.
- [ ] Add bilingual Syncthing background, battery, run-condition, folder, and
      overlap-online instructions.
- [ ] Add acknowledgement watermarks, safe snapshot compaction, and retention.
- [ ] Add rename, disconnect, retire, stale-device, lost-folder, and recovery flows.
- [ ] Preserve the selected folder and other phones' files when leaving the group.

Progress on 2026-08-24:
- The user's explicit authorization to continue starts this bounded M7 slice.
- Multi-device Settings now uses one primary `Preparar y revisar cambios`
  action instead of separate publication and incoming-review buttons. It
  authenticates once, opens one short-lived clear-key window, bootstraps and
  publishes local operations first, then reviews already transported remote
  operations and refreshes application data.
- Publication and incoming counts remain separate, so the UI still does not
  claim that Syncthing transported a file or that another phone is online.
  Existing separate controller operations remain available for compatibility
  and diagnosis.
- A separate `Abrir Syncthing` action now launches Syncthing-Fork first or
  classic Syncthing second through the existing Android bridge. If neither is
  installed, MichiFocus reports that condition without claiming transport.
- Drift generation, formatting, 29 focused sync tests, clean `lib`/`test`
  analysis, and the complete 408-test suite pass. The release APK builds with
  Java 17 and is installed on the wireless Realme while preserving its data.
  The phone is waiting for the owner's fingerprint, so the physical button tap
  and the remaining status, guidance, retention, and device-lifecycle work
  remain open.

Quality gates:
- [ ] File growth remains within the approved bound after high-volume compaction.
- [ ] No tombstone is removed while an active device can still need it.
- [ ] Device retirement and rejoin cannot grant stale write authority silently.
- [ ] Settings remain simple in single-device mode and responsive in multi-device mode.

Tracks:
- `REQ-V11-007`
- `REQ-V11-008`

### V11-M8 - Integrated multi-device verification and documentation

Priority: 10

Status: Proposed

Objective:
Verify the complete system with simulations and real Android phones before
declaring synchronization stable.

Deliverables:
- [ ] Run adversarial two-, three-, and four-device operation permutations.
- [ ] Run migration, corruption, interruption, permission-loss, reinstall,
      stale-device, clock-skew, retention, and high-volume tests.
- [ ] Verify two physical Android phones with Syncthing-Fork in foreground,
      background, delayed, offline, restart, and battery-restricted conditions.
- [ ] Verify tasks, goals, calendar, routines, completed Pomodoros, conflicts,
      reports, backup, restore, and mode transitions end to end.
- [ ] Update database, architecture, UI, routing, requirements, traceability,
      client manuals, quick-start, troubleshooting, and changelog.

Definition of done:
- [ ] Every REQ-V11 requirement has direct evidence and no unresolved critical finding.
- [ ] Drift generation, formatting, clean analyzer, focused tests, and full suite pass.
- [ ] Single-device mode has no verified regression.
- [ ] Two-phone physical evidence proves eventual delivery and conflict convergence.
- [ ] Limitations and Syncthing dependency are clear in Spanish and English.
- [ ] The release retains an immediate recovery path to a verified local snapshot.

Tracks:
- `REQ-V11-001`
- `REQ-V11-002`
- `REQ-V11-003`
- `REQ-V11-004`
- `REQ-V11-005`
- `REQ-V11-006`
- `REQ-V11-007`
- `REQ-V11-008`
- `REQ-V11-009`
- `REQ-V11-010`

## Approved roadmap - Productivity V12

Status:
Approved for implementation on 2026-08-26. V12-M0 and the persistence portion
of V12-M1 are in progress; later milestones remain approved and pending.

Objective:
Add persistent custom routine colors and validity dates, a responsive weekly
schedule for routine activities and objectives, and a separate database-backed
`Notas rápidas` checklist without changing the meaning of existing tasks.

Priority rule:
Complete or explicitly defer the affected V11 synchronization gates before V12
schema and exchange implementation. Implement V12-M0 through V12-M5 in order
unless the user explicitly reprioritizes.

### V12-M0 - Contract, schema, migration, and synchronization design

Priority: 1

Status: In Progress

Objective:
Freeze the routine-color, validity-range, quick-note, history, backup, and sync
contracts before changing production persistence.

Deliverables:
- [x] Approve all `REQ-V12` requirements for implementation.
- [x] Finalize canonical local-date and color-value storage.
- [x] Preserve existing routine `color_key` compatibility.
- [ ] Design forward-only routine additions, historical color snapshots, and
      the dedicated quick-note table and indexes.
- [ ] Define V11 operation, conflict, recovery, import, export, and reset rules.
- [x] Define migration defaults for existing routines without inventing history.

Quality gates:
- [ ] Architecture and migration review pass.
- [ ] Old-schema fixtures and sync-operation compatibility matrix are planned.
- [ ] No implementation starts while requirements remain `Proposed`.

Tracks:
- `REQ-V12-001`
- `REQ-V12-004`
- `REQ-V12-006`

### V12-M1 - Routine custom color and validity editor

Priority: 2

Status: In Progress

Objective:
Persist routine custom colors and editable start/end validity, then expose them
through the existing creation and editing workflow.

Deliverables:
- [x] Add routine custom color and local validity fields through Drift.
- [x] Preserve historical execution snapshots and future-only edit semantics.
- [x] Add broad color selection and contrast-safe previews.
- [x] Add start date and optional end date to creation, editing, and review.
- [x] Recalculate future projections and reminders after valid edits.

Quality gates:
- [x] Migration, repository, reminder, projection, and history tests pass.
- [x] Spanish/English, light/dark, large-text, keyboard, and narrow-phone widget checks pass.
- [x] Drift generation, formatting, clean analysis, and full tests pass.

- [ ] Physical Android inspection passes; the RMX3301 is connected, but the
      local Gradle process cannot establish its loopback connection.

Verification:
- 2026-08-26: schema 8, repository/sync boundaries, color snapshots, validity
  projection, reminder refresh, editor controls, bilingual responsive widgets,
  and visual references passed focused coverage.
- 2026-08-26: dart format, clean lib/test analysis, 19 focused editor and
  controller tests, 19 repository tests, and all 428 tests passed.

Tracks:
- `REQ-V12-001`
- `REQ-V12-002`

### V12-M2 - Responsive weekly schedule

Priority: 3

Status: Verified

Objective:
Add a school-timetable-style weekly planning view for routine activities and
dated objectives while preserving the existing monthly view and actions.

Deliverables:
- [x] Add `Mes | Semana` inside `Objetivos/Planificación`.
- [x] Project only valid routine occurrences into time-positioned colored blocks.
- [x] Show objective task progress in an all-day area.
- [x] Show activity state and routine-level progress without redundant counts.
- [x] Preserve overlap visibility and existing routine/objective actions.
- [x] Provide responsive day navigation for phones and wider layouts.
- [x] Add a phone-first `Compacto | Cuadrícula` selector with all seven days in
      readable vertical sections and collapsible weekly goals.
- [x] Export the selected week offline as a uniquely named US Letter landscape
      PDF that Android can save and open for print/share.

Quality gates:
- [ ] Boundary, indefinite-range, overlap, local-midnight, and edit tests pass.
- [ ] Dense bilingual and accessibility widget checks pass.
- [ ] Scrolling, projection, and repaint performance remain bounded.
- [ ] Physical portrait inspection passes on a representative Android phone.
- [ ] PDF structure, Letter-landscape geometry, Spanish text, unique naming,
      Android save, and open smoke checks pass.

Evidence:
- 2026-08-26: bounded Monday-Sunday activity projection, inclusive routine
  validity, immutable historical color snapshots, visible overlap lanes, and
  the `Mes | Semana` planning selector were implemented without future task
  materialization.
- 2026-08-26: clean `lib`/`test` analysis, 10 focused schedule/calendar tests,
  and all 433 project tests passed. The focused coverage includes local-midnight
  ownership, while the widget check includes a dense
  eight-way overlap at 320 px without overflow.
- 2026-08-26: release generation and physical installation remain pending
  because the local Java selector cannot establish Gradle's loopback connection;
  Adoptium JDK 17, Android Studio JBR, IPv4-only, and no-daemon attempts failed
  before Android compilation began.
- 2026-08-27: the phone-first compact view now shows all seven days as vertical
  sections, keeps the school grid as an explicit alternative, and collapses the
  weekly goals without hiding their task-progress summary.
- 2026-08-27: the selected week now renders offline as one US Letter landscape
  PDF and reuses Android's folder picker, collision-resistant save, exact
  destination, and open-file bridge. Renderer, unique-file, narrow-layout,
  bilingual, goals-toggle, grid-switch, and UI export tests pass; the complete
  project test suite also passes. Android save/open and printed-page inspection
  remain the final verification gates.

Tracks:
- `REQ-V12-003`

### V12-M3 - Quick-note persistence and checklist core

Priority: 4

Status: Implemented

Objective:
Create the independent offline-first quick-note entity and reliable checkbox
workflow without reusing or changing ordinary tasks.

Deliverables:
- [x] Add the dedicated quick-note Drift table, DAO, repository, domain entity,
      controller, DI, and forward migration.
- [x] Persist text, completion, color, optional date, optional priority, order,
      and timestamps.
- [x] Add create, edit, check, uncheck, delete, and reorder behavior.
- [x] Include quick notes in reset, backup, import validation, recovery, and sync.
- [x] Prove quick notes do not affect Pomodoro, task statistics, or reports.

Quality gates:
- [x] Migration, persistence, ordering, validation, and restart tests pass.
- [x] Sync create/update/delete/completion idempotency tests pass.
- [x] Drift generation, formatting, clean analysis, and full tests pass.

Tracks:
- `REQ-V12-004`
- `REQ-V12-006`

### V12-M4 - Quick-note organization and planning visibility

Priority: 5

Status: Implemented

Objective:
Expose `Notas rápidas` with personalized colors, optional priority, flexible
sorting, and compact selected-day visibility.

Deliverables:
- [x] Add `Notas rápidas` inside the existing Tasks feature navigation.
- [x] Add native checkbox presentation with reversible completed treatment.
- [x] Add broad custom-color selection independent of priority.
- [x] Add optional high/medium/low priority and
      manual/priority/date/recent/color sorting.
- [x] Keep undated notes discoverable and show dated notes in the day agenda.

Quality gates:
- [ ] Spanish/English, theme, large-text, keyboard, semantics, and narrow-phone checks pass.
- [x] Sorting remains stable after restart and synchronization.
- [x] Existing Tasks and Routines workflows have no regression.

Implementation evidence on 2026-08-27:

- Unified schema version 9 adds the independent `quick_notes` table with opaque
  color, optional canonical date and priority, spaced manual position, and
  timestamps. Reset and staged import validation cover the table and indexes.
- Repository mutations create encrypted `quickNote` operations; initial
  preparation, incoming application, duplicate rejection, conflict selection,
  preserve-both, and controller refresh use the existing secure group model.
- `Tareas | Rutinas | Notas` exposes the general checklist and selected-day
  Planning shows only dated notes. New notes default to the current or supplied
  planning day, while existing undated notes remain undated when edited.
- The editor exposes a Paint-style hue and saturation/value selector with a hex
  preview and presets. A 320 px dark-theme widget test covers custom color,
  default date, creation, reversible completion, and compact cards without
  overflow.
- Secure synchronized mutations preserve validation and encryption while loading
  the Android storage, enrollment, and device-identity prerequisites
  sequentially with bounded reads. App-private values are cached after the
  first read and refreshed by their own save/create/update operations, avoiding
  three repeated filesystem reads for each note mutation.
- A failed or timed-out prerequisite now re-enables `Guardar nota` and shows an
  actionable message instead of leaving the editor in an indefinite loading
  state.
- Physical diagnosis found that production quick-note creation passed the
  unsupported scope `quick_note` to the secure ID generator. It now uses the
  valid `quick-note` scope, with repository coverage using the production
  generator rather than the timestamp fallback.
- Drift generation and clean `lib`/`test` analysis pass; all 448 project tests
  pass. The 70.4 MB release APK builds, installs over the existing RMX3301 data,
  and reaches the Android authentication prompt on 2026-08-27.

Tracks:
- `REQ-V12-005`

### V12-M5 - Integrated compatibility and release verification

Priority: 6

Status: Approved

Objective:
Verify V12 end to end before changing any requirement to `Verified`.

Deliverables:
- [ ] Run supported-schema migration and populated-database preservation tests.
- [ ] Run backup/import/reset/recovery round trips with all new fields.
- [ ] Run two-device convergence and conflict cases for routine and quick-note changes.
- [ ] Verify weekly schedule, routine editing, and quick notes on physical Android.
- [ ] Update database, UI, routine, sync, requirement, traceability, and client docs.

Definition of done:
- [ ] Every `REQ-V12` acceptance criterion has direct evidence.
- [ ] Historical routine data remains unchanged after template color/date edits.
- [ ] Quick notes remain separate from task and focus statistics.
- [ ] Drift generation, formatting, clean analysis, focused tests, and full suite pass.
- [ ] Release build and representative physical Android flows pass.
- [ ] Backup, recovery, and synchronized convergence retain an immediate safe path.

Tracks:
- `REQ-V12-001`
- `REQ-V12-002`
- `REQ-V12-003`
- `REQ-V12-004`
- `REQ-V12-005`
- `REQ-V12-006`

## V13 — Objetivos y notificaciones contextuales

### V13-M0 — Contrato aprobado

Status: Implemented

Decisiones aprobadas por el usuario el 2026-08-28:
- Agrupar las alertas de tareas por objetivo.
- Mostrar pendientes, en progreso y completadas en cada alerta.
- Abrir y revelar el objetivo desde su notificación.
- Añadir creación contextual y objetivos desplegables.

### V13-M1 — Implementación y verificación

Status: Implemented

- [x] Implementar el resumen estructurado por objetivo.
- [x] Implementar navegación contextual y revelado del objetivo.
- [x] Implementar el botón “+ Crear” y el detalle desplegable.
- [x] Actualizar y ejecutar pruebas relevantes.
- [x] Ejecutar análisis, suite completa, build release e instalación.
- [ ] Validar visualmente los flujos tras la autenticación del dispositivo.

Implementation evidence on 2026-08-28:
- Clean `lib`/`test` analysis and all 450 project tests pass.
- Focused reminder and planning tests cover grouping, counts, expansion,
  contextual reveal, task highlighting, creation menu, theme, and layout.
- The 70.5 MB release APK builds with Java 17, installs over the existing
  RMX3301 application data, launches, and reaches the system authentication
  prompt. Authenticated physical interaction remains pending.

Tracks:
- `REQ-V13-001`
- `REQ-V13-002`

### V13-M2 — Propiedad de la ejecución diaria

Status: Implemented

- [x] Enriquecer las tarjetas de la sección Tareas.
- [x] Retirar la lista diaria duplicada de Objetivos.
- [x] Preservar filtros, acciones y navegación contextual.
- [x] Ejecutar pruebas enfocadas y puertas de calidad.

Tracks:
- `REQ-V13-003`

## V20 — Silencio temporal de enfoque en Android

### V20-M0 — Contrato y prueba de viabilidad nativa

Status: In Progress

Objective:
Definir una experiencia honesta y demostrar qué interrupciones puede evitar
Android antes de implementar el selector por aplicaciones.

Deliverables:
- [ ] Aprobar activación al iniciar enfoque, mantenimiento durante pausa,
  desactivación en descanso/salida y acción independiente secundaria.
- [ ] Aprobar perfiles, duraciones y excepciones.
- [ ] Probar No molestar mediante una regla automática propia.
- [ ] Probar supresión selectiva en Realme y Poco con sonido, vibración y aviso
  emergente, pantalla encendida/apagada y app en primer/segundo plano.
- [ ] Decidir `Silenciar aplicaciones` o `Ocultar notificaciones` según evidencia.
- [ ] Confirmar la estrategia mínima de visibilidad de paquetes y excluir
  `QUERY_ALL_PACKAGES`, Accesibilidad y administración del dispositivo.

Tracks:
- `REQ-V20-001`
- `REQ-V20-002`
- `REQ-V20-003`

### V20-M1 — Ajustes, duración y selección

Status: In Progress

Deliverables:
- [ ] Añadir la tarjeta `Silencio de enfoque` desactivada por defecto.
- [ ] Añadir `Activar al iniciar un Pomodoro`; pausar o salir de la app siempre
  debe restaurar las notificaciones.
- [ ] Añadir en los tres puntos de Pomodoro el switch `Bloquear notificaciones
  en este Pomodoro` para activar o desactivar solo el plan actual.
- [ ] Hacer que cada nuevo plan herede Ajustes y limpiar su modificación temporal
  al completar, descartar o cambiar de tarea.
- [ ] Añadir perfiles seguros reutilizables en los Pomodoros.
- [ ] Mostrar fin previsto, estado, contador y terminación manual.
- [ ] Crear lista buscable con selección individual/múltiple, seleccionar todas
  y quitar selección.
- [ ] Mostrar el total seleccionado y reutilizar la lista sin preguntar antes de
  cada Pomodoro.
- [ ] Guardar perfil y paquetes solo en el celular actual.
- [ ] Cubrir español, inglés, tema claro/oscuro, texto grande y 320 px.

Tracks:
- `REQ-V20-001`
- `REQ-V20-002`

### V20-M2 — Regla No molestar y autorizaciones Android

Status: In Progress

Deliverables:
- [ ] Implementar el puente de capacidades y la regla automática propiedad de
  Michi Focus sin sobrescribir reglas ajenas.
- [ ] Abrir directamente el acceso a No molestar y actualizar el estado al
  regresar.
- [ ] Mostrar explicación previa, `Autorizar en Android`, estado `Listo` y
  `Abrir ajustes de Android` sin pedir credenciales dentro de Michi Focus.
- [ ] Desde el switch de Pomodoro sin autorización, abrir la explicación y el
  acceso correcto; una cancelación conserva el switch apagado y el reloj activo.
- [ ] Abrir ajustes de notificación por aplicación con alternativa segura.
- [ ] Añadir el listener opcional solo si M0 aprueba el modo selectivo.
- [ ] Tratar permiso denegado, revocado, actividad inexistente y perfil
  administrado sin bloquear la productividad offline.
- [ ] Validar comportamiento diferenciado de Android 23, 24–34 y 35 o posterior.

Tracks:
- `REQ-V20-002`
- `REQ-V20-003`

### V20-M3 — Caducidad, recuperación y aviso persistente

Status: In Progress

Deliverables:
- [ ] Mantener una única sesión local con inicio, fin y regla propietaria.
- [ ] Activar al comenzar realmente el contador de enfoque.
- [ ] Retirar la regla al pausar o mandar la app a segundo plano y volver a
  aplicarla al regresar solo si el contador continúa avanzando.
- [ ] Aplicar o retirar inmediatamente la protección si el switch del plan cambia
  durante un bloque de enfoque.
- [ ] Durante el descanso, guardar el switch para el siguiente bloque sin
  silenciar el descanso actual.
- [ ] Mantener o retirar durante pausa según el switch y reactivar al reanudar.
- [ ] Desactivar en descanso y reactivar en el siguiente bloque de enfoque.
- [ ] Terminar de forma segura al completar, descartar, cambiar tarea, finalizar
  el plan, agotar una duración secundaria o usar la acción manual.
- [ ] Hacer que máxima concentración reutilice la sesión existente.
- [ ] Recuperar proceso cerrado, reinicio, hora/zona cambiada y permiso revocado.
- [ ] Mostrar una notificación activa con tiempo restante y `Terminar silencio`.
- [ ] Garantizar idempotencia: iniciar o finalizar repetidamente no duplica reglas
  ni deja estados huérfanos.
- [ ] Confirmar que reset, backup y sincronización excluyen paquetes y sesión.

Tracks:
- `REQ-V20-001`
- `REQ-V20-004`

### V20-M4 — Modo selectivo condicionado por evidencia

Status: Proposed

Deliverables:
- [ ] Implementar selección temporal solo con el nombre y garantía aprobados en
  V20-M0.
- [ ] No leer, guardar ni sincronizar títulos o contenido de notificaciones.
- [ ] Excluir Michi Focus y componentes críticos de acciones masivas.
- [ ] Explicar cualquier alerta que Android pueda emitir antes de ocultarla.
- [ ] Permitir retirar el acceso opcional sin afectar el silencio global.

Tracks:
- `REQ-V20-002`
- `REQ-V20-003`

### V20-M5 — Verificación integral y entrega

Status: Proposed

Deliverables:
- [ ] Ejecutar formato, análisis, pruebas enfocadas y suite Flutter completa.
- [ ] Compilar APK debug/release e instalar en Realme y Poco.
- [ ] Probar permisos concedidos/denegados/revocados, proceso cerrado, reinicio,
  cambio horario y final anticipado.
- [ ] Probar iniciar, pausar, reanudar, descansar, encadenar bloques, completar,
  descartar y cambiar de tarea con ambos valores del switch de pausa.
- [ ] Probar el switch de tres puntos activado/desactivado, herencia global,
  permiso faltante, cancelación y limpieza al terminar el plan.
- [ ] Comprobar llamadas, mensajes, alarmas, medios, notificaciones de terceros y
  avisos de fin de Pomodoro para cada perfil.
- [ ] Confirmar que ninguna regla propia queda activa después del fin.
- [ ] Actualizar guías Android y cliente únicamente con conducta verificada.

Definition of Done:
- [ ] El silencio global temporal funciona sin modificar reglas ajenas.
- [ ] Cada bloque de enfoque activa la protección configurada y cada descanso o
  salida la restaura según el contrato.
- [ ] El switch del plan responde inmediatamente y nunca altera silenciosamente
  el valor general de Ajustes.
- [ ] La interfaz nunca promete silencio selectivo sin evidencia física.
- [ ] Seleccionar todas/quitar selección es reversible y local al dispositivo.
- [ ] La app abre las pantallas correctas de Android y refleja el permiso real.
- [ ] Realme y Poco superan la matriz física sin una sesión huérfana.

Tracks:
- `REQ-V20-001`
- `REQ-V20-002`
- `REQ-V20-003`
- `REQ-V20-004`

## V18 — Continuidad exacta del Pomodoro

### V18-M0 — Continuidad exacta implementada

Status: Verified

- [x] Definir el tiempo pendiente en segundos.
- [x] Prohibir la repetición de sesiones completas o parciales persistidas.
- [x] Mantener el esquema y la sincronización sin cambios.
- [x] Implementar reconciliación y limpieza esperada del runtime.
- [x] Cubrir cierre, reapertura y último bloque reducido con pruebas.
- [x] Ejecutar las puertas completas y la instalación física.

Verification evidence through 2026-08-31:
- 30 minutos completos más 25 parciales de una tarea de 60 producen un último
  bloque de 5 minutos después de cerrar y preparar nuevamente la tarea.
- Los runtimes antiguos completos y parciales se reconcilian sin repetir foco.
- La entrada desde Tareas descarta sin guardar progreso un runtime antiguo que
  exceda el resto persistido y recalcula el plan desde ese historial.
- El análisis está limpio, las 485 pruebas pasan y el APK se instaló/abrió en
  el Realme RMX3301 por depuración inalámbrica.
- En el Realme, una tarea real de 55/60 mostró `faltan 5 min` y dejó el reloj
  preparado en `05:00`, 0/1, sin iniciar el conteo.

Tracks:
- `REQ-V18-001`

## V19 — Rendimiento de navegación y actualización

### V19-M1 — Pestañas persistentes

Status: Verified

- [x] Conservar las cinco ramas principales con un shell indexado.
- [x] Preservar estado local, filtros y desplazamiento al cambiar de pestaña.
- [x] Mantener rutas contextuales y pantallas secundarias compatibles.

### V19-M2 — Actualización coordinada

Status: Verified

- [x] Deduplicar recargas manuales y posteriores a sincronización.
- [x] Añadir deslizar para actualizar en Inicio, Tareas y Objetivos.
- [x] Evitar recargas por seleccionar de nuevo una vista ya activa.
- [x] Cubrir navegación, conservación, concurrencia y regresiones.

### V19-M3 — Precarga segura de productividad

Status: Verified

- [x] Iniciar Tareas, Rutinas y Notas únicamente después de la autenticación.
- [x] Cargar los tres conjuntos en paralelo durante el único arranque.
- [x] Retirar las cargas duplicadas de la configuración de dependencias.
- [x] Compartir lecturas simultáneas de Tareas y Notas.
- [x] Precargar solo la rama visual de Tareas.
- [x] Cubrir autenticación, rama anticipada y concurrencia con pruebas.

Implementation evidence on 2026-08-31:
- Las 32 pruebas enfocadas pasaron.
- `flutter analyze lib test` terminó limpio.
- Las 482 pruebas del proyecto pasaron.
- El APK compiló con Java 17 y se instaló/abrió en el Realme RMX3301.
- Tareas, Rutinas y Notas aparecieron sin otra carga visible; la actualización
  manual terminó sin error y la selección Notas sobrevivió al cambio de pestaña.

Tracks:
- `REQ-V19-001`

## V17 — Filtros temporales y creación accesible

### V17-M1 — Notas, rutinas y Objetivos

Status: Implemented

- [x] Compartir Hoy/Día/Semana/Mes/Año/Todas entre Notas y Rutinas.
- [x] Filtrar rutinas por recurrencia y vigencia sin mezclar progreso de hoy.
- [x] Mantener accesibles las notas sin fecha mediante Todas.
- [x] Mover Crear a la parte superior de la tarjeta de Objetivos.
- [x] Cubrir límites temporales, controladores, vista estrecha y regresiones.
- [x] Ejecutar formato, análisis limpio y suite completa.

Implementation evidence on 2026-08-30:
- Los filtros reutilizan un modelo único de periodos locales e inclusivos.
- El análisis de `lib` y `test` está limpio y las 472 pruebas pasan.
- La referencia visual de Rutinas incluye el nuevo control.
- El APK de depuración compiló con Java 17 y se instaló/abrió por ADB
  inalámbrico en el Realme RMX3301.

Tracks:
- `REQ-V12-007`
- `REQ-V13-002`

## V16 — Visualización de enfoque

### V16-M0 — Contrato aprobado

Status: Approved

- [x] Definir los estilos Claro y OLED y conservar OLED como inicial.
- [x] Delimitar estilo/protección efímeros y opacidad AMOLED local persistente.
- [x] Definir el conteo de Pomodoros completados por fase.

Tracks:
- `REQ-V16-001`
- `REQ-V16-002`

### V16-M2 — Pantalla activa durante el Pomodoro

Status: Implemented

- [x] Añadir el switch al menú de visualización normal y de Máxima concentración.
- [x] Activarlo automáticamente al entrar en Máxima concentración.
- [x] Permitir desactivarlo sin modificar la sesión.
- [x] Aplicar y liberar `FLAG_KEEP_SCREEN_ON` según el contador esté corriendo.
- [x] Cubrir el estado, el coordinador y la interfaz con pruebas.
- [x] Ejecutar formato, análisis y suite completa.

Implementation evidence on 2026-09-03:
- El análisis completo de `lib` y `test` está limpio y las 497 pruebas pasan.
- El APK de depuración compiló con Java 17 y se instaló/abrió por ADB
  inalámbrico en el Realme RMX3301 sin borrar sus datos.
- La inspección física del tiempo de espera queda pendiente antes de promover
  el requisito a `Verified`.

Tracks:
- `REQ-V16-003`

### V16-M1 — Implementación y verificación

Status: Implemented

- [x] Añadir la selección Claro/OLED al menú de Máxima concentración.
- [x] Restaurar los grises OLED originales y añadir opacidad AMOLED regulable.
- [x] Mantener sólido el menú de tres puntos en Máxima concentración.
- [x] Añadir Protección AMOLED con movimiento vertical de todo el contenido.
- [x] Mostrar check más X/Y fuera del reloj en las tres presentaciones.
- [x] Cubrir selección, colores, conteo y salida segura con pruebas.
- [x] Ejecutar análisis, suite completa, APK e instalación física.

Implementation evidence on 2026-08-30:
- El análisis completo de `lib` y `test`, las pruebas enfocadas de ajustes y
  controlador, la prueba integral visual y las 468 pruebas del proyecto pasan.
- El APK de depuración compiló con Java 17 y se instaló/abrió por ADB
  inalámbrico en el Realme RMX3301.
- La inspección física de legibilidad y movimiento queda pendiente antes de
  `Verified`.

Tracks:
- `REQ-V16-001`
- `REQ-V16-002`

## V15 — Objetivo al crear una tarea

### V15-M0 — Contrato aprobado

Status: Approved

- [x] Definir “Sin objetivo” como valor inicial.
- [x] Limitar opciones a objetivos fechados desde hoy.
- [x] Definir búsqueda por teclado y dictado local.
- [x] Definir que la tarea hereda la fecha del objetivo elegido.

### V15-M1 — Implementación y verificación

Status: Implemented

- [x] Añadir el selector buscable al formulario de Tareas.
- [x] Reutilizar el dictado local en la búsqueda.
- [x] Crear la tarea rápida o planificada según la selección.
- [x] Cubrir fechas, búsqueda, selección y creación con pruebas.
- [x] Ejecutar análisis, suite completa, APK e instalación física.

Implementation evidence on 2026-08-30:
- El análisis enfocado está limpio y las 467 pruebas del proyecto pasan.
- El APK de depuración compiló con Java 17, se instaló y se abrió por ADB
  inalámbrico en el Realme RMX3301.
- La inspección visual y el dictado de una frase quedan como puerta física para
  promover el requisito a `Verified`.

Tracks:
- `REQ-V15-001`

### V15-M2 — Duración al crear tareas

Status: Implemented

- [x] Aprobar el valor inicial y las seis duraciones disponibles.
- [x] Añadir el selector adaptable debajo del objetivo.
- [x] Persistir duración en tareas rápidas y planificadas.
- [x] Cubrir selección, reinicio y ambos tipos de creación con pruebas.
- [x] Ejecutar análisis, suite completa, APK e instalación física.

Implementation evidence on 2026-08-30:
- El análisis enfocado está limpio y las 467 pruebas pasan.
- Build Runner completó sin cambios de esquema.
- El APK de depuración compiló con Java 17 y se instaló/abrió por ADB
  inalámbrico en el Realme RMX3301.
- La inspección visual física queda pendiente antes de `Verified`.

Tracks:
- `REQ-V15-002`

## V14 — Dictado opcional en campos de texto

### V14-M0 — Contrato y arquitectura

Status: Implemented

Objective:
Permitir que el micrófono rellene únicamente campos escritos, manteniendo la
edición manual y el guardado explícito.

Deliverables:
- [x] Delimitar tareas, objetivos, rutinas, actividades y notas rápidas.
- [x] Excluir comandos, autoguardado, audio persistente y campos estructurados.
- [x] Aprobar la dependencia, el permiso Android y el servicio compartido.

### V14-M1 — Implementación y verificación Android

Status: Implemented

Deliverables:
- [x] Integrar reconocimiento de frases cortas con un único coordinador.
- [x] Añadir una acción de micrófono reutilizable a los campos aprobados.
- [x] Cubrir inserción, cancelación, errores y exclusión mutua con pruebas.
- [x] Ejecutar formato, análisis y pruebas relevantes.
- [x] Compilar e instalar en el Realme por depuración inalámbrica.
- [ ] Validar una frase hablada en el Realme tras la autorización del usuario.

Implementation evidence on 2026-08-29:
- 463 automated tests pass and static analysis reports no issues after adding
  the current Calendar/Goals forms and the Android start-result guard.
- Debug APK built with Java 17 and installed successfully on RMX3301 at
  ``192.168.100.43:39669``; the application launcher opened it.
- The first physical dictation remains a manual check because Android requires
  the user to grant microphone access and may require biometric unlocking.
- Follow-up on 2026-08-29 restored local-only recognition, removed the false
  start failure caused by the package's void return, and added Android's
  official local-model download request for the active locale.
- Follow-up on 2026-08-30 changed dictation to user-controlled stop, with a
  five-minute safety limit, sixty-second silence tolerance, and guarded language
  preparation status.
- RMX3301 logs confirmed Android `LANGUAGE_PACK_ERROR 12` for `es-BO`; local
  preparation and recognition now use the compatible `es-ES` model together.
- Follow-up on 2026-08-30 exposes Android's model state as scheduled, live
  percentage when supported, ready, or failed, and creates a fresh on-device
  recognizer after preparation. Nine focused tests, all 465 project tests,
  scoped analysis, Android compilation, and wireless RMX3301 installation pass;
  speaking and observing the real model transition remain a manual physical
  check. Full-project analysis reports only the pre-existing temporary SQLite
  verification-script dependency notice.
- Physical logs then identified a provider mismatch: Google TTS owned the
  downloaded `es-ES` pack while the on-device constructor selected AiAi and
  returned `LANGUAGE_PACK_ERROR 13`. Download and recognition now share
  Android's configured recognition service. Android compilation, nine focused
  tests, wireless RMX3301 installation, and clean focused diff checks pass;
  one spoken phrase remains the final physical verification.
- Poco M4 Pro inspection on 2026-08-31 confirmed Android 13/API 33 cannot report
  model-download progress to the app. Scheduled state now stops indefinite
  progress, checks installed/pending support, and offers the real Google voice
  language manager plus retry. The manager resolved and displayed the explicit
  49.31 MB Spanish (Spain) download; 11 focused and all 491 tests, Android
  compilation, and Poco ADB installation pass. Package acceptance and one spoken
  phrase remain manual.
- On 2026-09-01, all twelve dictation-enabled fields were aligned to one
  multiline contract: word wrapping, one-to-two visible lines, fixed height
  after line two, vertical cursor scrolling, newline on Enter, and explicit
  save actions. Scoped analysis, updated Routine visual references, all 495
  tests, the Java 17 debug build, and wireless RMX3301 installation pass.
- The same twelve fields now place a themed clear-all eraser immediately after
  the microphone. It is disabled for empty content and clears both the text
  controller and the form or search state through the existing change callback.
- Follow-up verification passes clean full analysis, 19 focused tests, all 495
  project tests, Java 17 Android compilation, and wireless RMX3301 installation
  and launch without clearing existing application data.
- Creation and editing now share the same microphone and eraser behavior for
  tasks, goals, routines, routine activities, and quick notes. Empty and
  one-line labels stay vertically centered instead of using permanent
  multiline top alignment.
- Final follow-up verification passes clean full analysis, 23 focused tests,
  all 495 project tests, Java 17 compilation, and wireless RMX3301 installation
  and launch while preserving local application data.
- User-requested visual rollback on 2026-09-03 restores the previous label
  alignment in Tasks, Routines, and Quick Notes without removing dictation,
  clear-all, or one-to-two-line wrapping. Goals keeps its centered label.
- The rollback passes scoped analysis, 20 focused tests, Java 17 compilation,
  and wireless RMX3301 installation and launch without clearing local data.

Tracks:
- `REQ-V14-001`

### V13-M4 — Creación integrada en Objetivos

Status: Implemented

- [x] Mover Crear al pie de la tarjeta de Objetivos.
- [x] Dar al botón el ancho completo disponible.
- [x] Retirar la tarjeta independiente de agenda y sus acciones duplicadas.
- [x] Preservar Nueva tarea y Nuevo objetivo dentro del menú Crear.
- [x] Ejecutar pruebas enfocadas y puertas de calidad.

Tracks:
- `REQ-V13-002`

### V13-M5 — Filtro de tareas por objetivo

Status: Implemented

- [x] Aprobar el comportamiento y el valor inicial.
- [x] Componer objetivo, período y estado en el controlador.
- [x] Añadir el selector de objetivo en Tareas.
- [x] Ejecutar pruebas enfocadas y puertas de calidad.

Implementation evidence on 2026-08-28:
- “Todos los objetivos” es el valor inicial e incluye tareas sin objetivo.
- Los recuentos de estado se recalculan para el objetivo y período activos.
- El análisis enfocado, 23 pruebas enfocadas y la suite completa pasan.

Tracks:
- `REQ-V13-004`

### V13-M3 — Propiedad de la ejecución de rutinas

Status: Implemented

- [x] Retirar las tarjetas de rutina de la agenda de Objetivos.
- [x] Conservar las rutinas como bloques del horario semanal.
- [x] Mostrar estado y progreso diario en Tareas → Rutinas sin `0/0`.
- [x] Ejecutar pruebas enfocadas y puertas de calidad.

Tracks:
- `REQ-V13-003`
