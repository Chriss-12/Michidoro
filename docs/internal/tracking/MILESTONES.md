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
