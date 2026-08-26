# Productivity V9 requirements

Status: V9-M0 through V9-M7 are Verified; V9-M8 is Implemented.

Product direction and the V9-M0 architecture baseline were accepted on
2026-08-07. Application implementation remains gated per milestone.

## Decision

V9 adds routines as reusable groups of scheduled, repeating tasks. A routine
is not a second task system and is not merely a repeating Pomodoro. Its daily
items materialize as ordinary MichiDoro tasks so existing task status,
Pomodoro, mood, statistics, calendar, PDF, and unified-database workflows stay
authoritative.

## User model

Example: `Manana productiva`, Monday through Friday.

1. `07:00 - Levantarse`
2. `07:15 - Ejercicio`, 30 minutes
3. `08:10 - Desayunar`, 20 minutes
4. `08:45 - Trabajo profundo`, 50 focus minutes with Pomodoro

The routine is configured once. Each scheduled local day gets an independent
run and ordinary task instances, preserving what was planned and what actually
happened on that date.

## Invariants

- Existing tables, identifiers, task statuses, session history, settings, and
  user workflows must remain valid.
- A task may exist without a routine; all routine links are optional from the
  existing feature perspective.
- Routine items generate or link ordinary `tasks`; routine presentation must
  not create a competing task entity or duplicate Pomodoro progress.
- `tasks` remains authoritative for Pending, In Progress, and Completed.
- `pomodoro_sessions` remains authoritative for focused seconds and mood.
- Future schedule projections are calculated from templates. They are not
  inserted as unlimited future tasks.
- Daily materialization is transactional and idempotent: the same routine item
  cannot generate the same daily task twice.
- Editing a template never rewrites completed or historical runs.
- Archiving is the normal removal action. Historical snapshots survive template,
  item, task, or goal deletion according to declared foreign-key rules.
- Only one Pomodoro runtime owner exists, including focus started from a routine.
- Unified export and import continue to use one `michifocus.sqlite` file.
- No cloud account, backend, or internet connection is required.

## Proposed persistence model

Five tables are added to the unified Drift database:

| Table | Responsibility |
|---|---|
| `routines` | Reusable routine identity, presentation, active/archive state, and timestamps. |
| `routine_days` | Normalized weekday recurrence rules for a routine. |
| `routine_items` | Ordered task templates with local time, duration, goal, reminder, and Pomodoro preference. |
| `routine_runs` | One dated execution of a routine, including immutable name/schedule snapshots and run status. |
| `routine_item_runs` | Daily item result, immutable planning snapshots, and optional link to the generated ordinary task. |

Planned relationships:

- `routine_days.routine_id -> routines.id` with `CASCADE` for template-only
  recurrence rows.
- `routine_items.routine_id -> routines.id` with template lifecycle managed by
  archive-first application rules.
- `routine_items.goal_id -> goals.id` with `SET NULL`.
- `routine_runs.routine_id -> routines.id` with `SET NULL`; run snapshots retain
  history if a template is removed.
- `routine_item_runs.routine_run_id -> routine_runs.id` with `CASCADE` only when
  an explicit run deletion is approved.
- `routine_item_runs.routine_item_id -> routine_items.id` with `SET NULL`.
- `routine_item_runs.task_id -> tasks.id` with `SET NULL`.

Required uniqueness and indexes:

- Unique `(routine_id, weekday)` in `routine_days`.
- Stable item order within each routine.
- Unique scheduled occurrence key per routine and local date.
- Unique `(routine_run_id, routine_item_id)` materialization key.
- At most one routine-item-run link per generated task.
- Indexes for active routines, weekday lookup, scheduled local date/time,
  routine run date/status, task link, and reporting ranges.

## State definitions

Routine template state:

- `active`: eligible for projection and materialization.
- `paused`: preserved but temporarily excluded.
- `archived`: hidden from normal scheduling while history remains readable.

Routine run state:

- `scheduled`: expected for the local date.
- `inProgress`: at least one generated task started.
- `completed`: all required items completed; optional items may be completed or
  intentionally skipped.
- `skipped`: user intentionally skipped the routine or occurrence.
- `missed`: reconciliation found that the scheduled day ended without the
  required items being completed.

Routine item run state:

- `scheduled`, `inProgress`, `completed`, `skipped`, or `missed`.
- When a linked task exists, task status is authoritative and the item-run state
  is synchronized transactionally for historical reporting.

## REQ-V9-001 - Routine contract and backward compatibility

Status: Approved

Objective:
Introduce routines without replacing or changing the meaning of existing
tasks, goals, calendar events, Pomodoro sessions/runtime, reporting metadata,
settings, or completion history.

Checklist:
- [x] Product concept and planning direction accepted by the user
- [x] Existing schema and feature boundaries reviewed
- [x] V9-M0 design slice approved
- [ ] Compatibility tests implemented
- [x] V9-M0 architecture, milestone, and traceability documentation verified

Acceptance criteria:
- [ ] Existing databases open and migrate without data loss.
- [ ] Existing tasks remain usable without routine records.
- [ ] Existing task, goal, Pomodoro, calendar, statistics, PDF, onboarding,
      language, theme, typography, vibration, and backup behavior is preserved.
- [ ] No existing table or column is removed, renamed, or repurposed.
- [ ] Routine data is offline-first and stored in the unified SQLite database.
- [ ] Settings JSON remains reserved for user preferences, not routine content.

## REQ-V9-002 - Routine schema, migration, and repository boundary

Status: Verified

Objective:
Add the five-table routine model through a forward-only Drift migration with
declared referential integrity, transactional writes, and domain-friendly
repository APIs.

Checklist:
- [x] Final column contract and delete rules approved in V9-M0
- [x] V9-M1 implementation slice approved by the user
- [x] Drift tables, DAO, repository, and mappings implemented
- [x] Generated schema and migration implemented
- [x] Migration and integrity tests passed
- [x] Database documentation updated with verified schema version

Acceptance criteria:
- [x] Drift and DAO details stay in the data layer; UI never depends on a DAO.
- [x] Schema upgrade only creates routine tables/indexes and does not rebuild or
      mutate existing user rows unnecessarily.
- [x] Foreign keys are enabled and every delete action has a tested outcome.
- [x] Snapshots preserve historical names, times, durations, optionality, and
      schedule context after template edits.
- [x] Generation and status synchronization use database transactions.
- [x] Duplicate daily materialization is rejected by database constraints, not
      only by UI checks.

## REQ-V9-003 - Routine list, editor, and scheduling rules

Status: Verified

Objective:
Configure routines under `Tareas -> Rutinas` without adding a sixth bottom
navigation destination.

Checklist:
- [x] V9-M2 implementation approved by the user on 2026-08-07
- [x] Information step implemented
- [x] Recurrence step implemented
- [x] Scheduled-items editor implemented
- [x] Review/conflict step implemented
- [x] Responsive bilingual visual verification passed

Acceptance criteria:
- [x] `Tareas` exposes a clear `Tareas | Rutinas` view selector.
- [x] Users can create, edit, duplicate, pause, resume, archive, and restore a
      routine.
- [x] A routine supports name, description, icon, color, and active state.
- [x] Users select weekdays and add multiple ordered items with title, local
      time, estimated minutes, optional goal, required/optional flag, reminder,
      and Pomodoro preference.
- [x] Items can be added, removed, reordered, and edited without layout shifts.
- [x] Review shows total occupied time, focus time, break projection, expected
      finish, overlaps, and invalid or duplicate times before saving.
- [x] Overlaps produce understandable warnings but do not silently rewrite the
      user's schedule.
- [x] Spanish/English, large text, keyboard, semantics, and supported portrait
      widths remain usable without clipping or overlap.
- [x] Returning from a dirty new routine shows one discard confirmation and
      closes the editor without a deactivated-context or result-type error.
- [x] The routine-status trigger uses the full available list width while its
      anchored popup remains compact.
- [x] When the current activity can be skipped, `Editar rutina` and `Omitir`
      appear as balanced actions in one row below the primary start action.

Visual refinement evidence on 2026-08-11:
- The four-step editor now uses one stable segmented-progress header, consistent
  section labels/surfaces, identity preview, clearer weekday selection, ordered
  activity cards, summary metrics, and a matching activity bottom sheet.
- Seven focused widget tests pass, including all four Spanish golden steps, the
  activity-sheet golden, English at 320 px with 150% text, dark theme, and safe
  dirty-draft discard. Goal, reminder, and Pomodoro selectors remain expanded
  and ellipsized instead of overflowing at narrow large-text sizes.
- Clean `flutter analyze` and the complete 237-test suite passed. A JDK 17
  release APK updated RMX3301 without clearing data; direct portrait inspection
  passed all four steps, modal scrolling, contrast, fixed actions, and review.
  The temporary visual-test routine was discarded and the original routine was
  confirmed present.
- The routine-status filter no longer shows the redundant `Mostrar` / `Show`
  label. Its anchored control and three-option popup both use a verified 220 px
  width; the release APK passed direct closed/open-menu inspection on RMX3301.
- Creating a routine now opens the same four-step flow in a centered modal over
  `Tareas -> Rutinas`, with a dimmed background and no navigation reset.
  Editing an existing routine remains full-screen. A seventh phone golden,
  keyboard-open inspection, dirty-draft confirmation, and direct RMX3301
  discard check passed; the temporary draft was not persisted.
- On 2026-08-15 the creation modal moved to an opaque themed canvas and removed
  its live full-screen blur after RMX3301 diagnostics showed costly opening
  frames in the debug build. The icon picker now uses labelled selectable tiles
  for daily list, morning, work, exercise, and study instead of unexplained
  circles. Scoped analysis and all 393 tests pass; an optimized release APK was
  built and installed preserving data. Final post-authentication device timing
  remains for the user-visible smoke check.
- On 2026-08-24 the list filter trigger expanded to the full available width
  while preserving the compact anchored popup. Optional current activities now
  place `Editar rutina` on the left and `Omitir` on the right in one row below
  the full-width start action. Nine focused Home/Routines tests, clean analysis,
  and the complete 415-test suite pass.

## REQ-V9-004 - Daily materialization and ordinary task integration

Status: Verified

Objective:
Turn today's scheduled routine items into normal tasks exactly once while
keeping future calendar occurrences virtual and historical outcomes stable.

Checklist:
- [x] Materialization use case implemented
- [x] Task linking and state synchronization implemented
- [x] Date rollover and missed-day reconciliation implemented
- [x] Edit/delete semantics implemented
- [x] Idempotency and boundary tests passed

Acceptance criteria:
- [x] Startup, resume, and local-date rollover reconcile active routines.
- [x] Only the necessary current-day task instances are inserted into `tasks`.
- [x] Generated tasks use the existing title, status, scheduled date/time,
      duration, and optional goal behavior.
- [x] Re-running reconciliation does not create duplicates after restart,
      import, clock adjustment, or concurrent calls.
- [x] Missed historical dates do not create stale pending tasks; they produce
      explicit missed run/item outcomes without invented completion data.
- [x] Editing a generated item offers an explicit current-occurrence versus
      future-template choice when both are meaningful.
- [x] Template edits affect future unstarted occurrences only.
- [x] Deleting a generated task does not erase the routine's historical
      snapshot; deleting ordinary non-routine tasks behaves as before.

Verification evidence on 2026-08-09:
- Startup, resume, local-midnight, routine-save, and post-import paths invoke
  the same idempotent current-day reconciliation.
- One transaction creates the dated run, ordinary current-day tasks, and
  item-run links; unique occurrence, materialization, and task-link indexes
  reject duplicate commits.
- Missing scheduled dates since the template's last active update become
  `missed` run/item snapshots with no task row or completion event. Current
  template data is never projected into dates before that update boundary.
- Generated-task edits expose `Solo hoy` and `Hoy y futuras`; task/template
  deletion keeps immutable run/item snapshots through nullable foreign keys.
- Drift generation, clean analysis, 16 focused persistence tests, and the full
  220-test suite passed, including year rollover, leap day, clock/UTC-local
  adjustment, concurrent/repeated reconciliation, and snapshot preservation.
- The release APK updated and launched twice on RMX3301 with preserved data;
  both starts retained two Pending tasks, zero In Progress, zero Completed, and
  one current routine occurrence without duplicate materialization.

## REQ-V9-005 - Routine execution and Pomodoro integration

Status: Verified

Objective:
Let users start or continue a routine from its current item while reusing the
existing task Pomodoro plan, breaks, mood reflection, background reconciliation,
and exclusive runtime owner.

Checklist:
- [x] Routine execution coordinator implemented
- [x] Existing Pomodoro start/continue flow integrated
- [x] Pause, skip, late start, and completion rules implemented
- [x] Process restoration and exclusivity tests passed
- [x] Android execution inspection passed

Acceptance criteria:
- [x] Starting the first required item changes the routine run to In Progress.
- [x] Focus items start the linked ordinary task through the existing Pomodoro
      selection and recommendation flow.
- [x] Existing total-task progress, shortened final block, timed breaks, mood
      reflection, and task auto-completion rules remain authoritative.
- [x] Starting another task or routine while a timer owns the runtime shows the
      existing return, stop/switch, or cancel decision; no owner changes silently.
- [x] Leaving the page, backgrounding, and process recreation preserve the
      active task and routine context without double-counting time.
- [x] Users can pause, continue, skip an optional item, or stop for now without
      falsely completing required work.
- [x] Starting late offers a clear choice between retaining fixed times and
      shifting only the remaining occurrence; the template is unchanged unless
      explicitly edited.

Implementation evidence:
- Routine list, Home, and Calendar now use one routine execution entry point;
  ordinary Calendar tasks retain their existing task-only flow.
- Recommended and custom routine cadence snapshots feed the existing task plan,
  while task transitions refresh routine run/item progress immediately.
- Clean analysis, six focused coordinator tests, and the complete 226-test suite
  passed. The release APK was installed and launched on RMX3301; Home and the
  late-start decision were inspected without changing user data.
- On 2026-08-11 the release app passed the RMX3301 active, paused, timed-break,
  Android Home/return, Return to Pomodoro, and Finalize-and-switch matrix. Pause
  remained at `00:22` while backgrounded, the short break and mood reflection
  appeared, and another task could not replace routine task `f` silently.
- `flutter analyze` and 47 focused routine/Pomodoro tests passed. Importing the
  pre-test unified backup and restarting restored Pending `0/1`, six Pending
  tasks, zero In Progress, one Completed, and no active timer.

## REQ-V9-006 - Background reminders and schedule reconciliation

Status: Verified

Objective:
Notify scheduled routine items at their intended local times and reconcile
changes safely when the app is backgrounded, closed, restarted, or updated.

Implementation decision:
Use standard Android native APIs, without a new Flutter package or Gradle
dependency: notification channel, Android 13 notification permission, and
AlarmManager with an inexact fallback where exact alarms are unavailable.
Persist the bounded native alarm projection so boot, package replacement, and
device time/timezone broadcasts can reconstruct pending alarms. The app also
replaces the projection at startup, resume, local midnight, settings changes,
routine edits, and routine lifecycle changes.

Checklist:
- [x] Native capability/dependency decision approved
- [x] Permission and exact/inexact scheduling behavior documented
- [x] Reminder scheduler implemented
- [x] Reschedule/cancel/restart behavior tested
- [x] Physical Android closed-app verification passed

Acceptance criteria:
- [x] Reminder configuration belongs to each routine item; global notification
      permission and sound behavior remain in Settings.
- [x] The next bounded set of reminders is scheduled without generating
      unlimited future task rows.
- [x] Pause, archive, edit, import, timezone change, and local-date change cancel
      or replace obsolete reminders deterministically.
- [x] Disabled permission or unsupported exact scheduling degrades visibly and
      does not prevent the routine itself from working.
- [x] Repeated scheduling is idempotent and does not emit duplicate reminders.
- [x] Android inspection covers foreground, background, closed-app, restart,
      denied permission, delayed delivery, and device time changes.

Verification progress (2026-08-09):
- Removed duplicate boot permission/receiver declarations from the Android
  manifest before running the restart matrix.
- Scheduler tests now cover bounded projection, idempotent replacement,
  cancellation when notifications are disabled, and imported-data replacement.
- The native channel reports notification permission and exact-alarm capability;
  Settings shows localized ready, inexact fallback, and permission-denied states
  without blocking routine use. The denied state opens the correct Android app
  notification settings screen.
- Clean analysis, six focused scheduler tests, two capability-widget tests, the
  complete 233-test suite, and the 67.0 MB release APK build passed.
- RMX3301 registered a bounded seven-day projection, retained it while the app
  was backgrounded, restored future alarms after reboot/package replacement,
  and delivered the 19:00 reminder at 19:00:00.014 while MichiDoro was outside
  the foreground. The consumed occurrence disappeared without duplication.
- Exact scheduling was unavailable on the device, so Android used its inexact
  window and the app visibly reported flexible delivery. With notifications
  denied, the warning remained usable and routine data stayed intact; permission
  was then restored. The device was silent and the delivered record had no sound
  or vibration.
- Switching between `America/La_Paz` and the same-offset `America/Lima`
  reconstructed exactly seven alarms in each direction without duplicates, then
  restored `America/La_Paz`. Final cleanup restored the routine to 08:00 with no
  reminder, zero active routine alarms, and granted notification permission.

## REQ-V9-007 - Routine access and calendar presentation

Status: Verified

Objective:
Keep routine execution centered in `Tareas -> Rutinas` while preserving useful
calendar projection without crowding navigation or duplicating the editor in
Home.

Checklist:
- [x] Duplicate Home routine section removed
- [x] Calendar projection implemented
- [x] Daily progress and conflict states implemented
- [x] Existing-task presentation regression tests passed
- [x] Android visual matrix passed

Acceptance criteria:
- [x] Home does not show a routine card or become a second routine surface.
- [x] `Tareas -> Rutinas` remains the primary place to inspect, start, continue,
      edit, or skip routine work.
- [x] Calendar combines ordinary tasks, materialized routine tasks, and future
      virtual routine occurrences without duplicate rows.
- [x] Projected occurrences are visually distinguishable from persisted tasks.
- [x] Users can open the routine or dated occurrence from `Tareas -> Rutinas`
      and Calendar.
- [x] Routine progress distinguishes completed, optional skipped, intentional
      whole-run skipped, and missed outcomes.
- [x] Existing Home charts, task planning, and calendar event behavior remain
      unchanged when no routines exist.

Verification evidence on 2026-08-11:
- Widget coverage passed for a long Home routine at 320 px, maximum typography,
  Spanish/English, light/dark palettes, and Sora/Merriweather. Dense Calendar
  coverage passed with four overlapping routines, persisted completed/skipped/
  missed states, one virtual pending projection, stable occurrence keys, and no
  duplicate presentation.
- The matrix exposed an English `Settings` label wrapping at 125%. Navigation
  now retains the selected font and palette while using its compact label size
  above 100%; the rendered label is asserted to remain on one line.
- `flutter analyze`, 16 focused tests, and the complete 236-test suite passed.
- A release APK built with JDK 17 and updated the RMX3301 with data preservation.
  Direct portrait inspection passed Home and dense Calendar navigation,
  scrolling, overlap indicators, two distinct stored routines, two tasks, and
  no clipping or duplicate occurrence under Spanish/Nature/Sora/100% and
  English/Graphite Night/Merriweather/125%.
- Final device cleanup restored Spanish, Nature Focus light, 100%, Sora, routine
  progress `0/1`, six Pending tasks, zero In Progress tasks, and no timer change.
- On 2026-08-24 the user replaced the earlier Home-summary decision. The Home
  routine card and its direct execution path were removed; Calendar projection
  and the complete `Tareas -> Rutinas` workflow remain intact. A regression test
  proves populated routines stay absent from Home in Spanish/English and at
  maximum typography. Nine focused tests, clean analysis, and all 415 project
  tests pass.

## REQ-V9-008 - Routine statistics, mood, and PDF reporting

Status: Verified

Objective:
Measure routine consistency and outcomes from SQLite while preserving the
existing reporting engine as the single reporting boundary.

Checklist:
- [x] Metric definitions approved
- [x] Bounded aggregate queries implemented
- [x] Home statistics integrated
- [x] PDF sections implemented
- [x] Data-quality, performance, and rendered-PDF checks passed

Acceptance criteria:
- [x] Reports expose scheduled, completed, skipped, and missed routines/items.
- [x] Primary consistency is `completed required occurrences / scheduled
      required occurrences`; streaks are secondary and non-punitive.
- [x] Planned versus actual focus uses task estimates and completed Pomodoro
      session seconds without counting breaks as work.
- [x] Average mood uses valid completed-session reflection scores linked through
      ordinary tasks; mood is not duplicated in routine tables.
- [x] Reports can show completion by routine, typical abandonment item, start
      delay, focused minutes, and average mood for supported date ranges.
- [x] Empty, legacy-only, deleted-template, partially completed, and imported
      histories produce honest output rather than fabricated zeros.
- [x] PDF includes a concise routine section only when routine data exists and
      respects the selected report range and language.
- [x] Queries are indexed, bounded, and performance-tested at realistic and
      high-volume fixtures.

## REQ-V9-009 - Unified import/export and integrated verification

Status: Implemented

Objective:
Prove that routines survive the complete local database lifecycle and that V9
does not regress current MichiDoro behavior.

Checklist:
- [x] Old-to-new migration fixtures passed
- [x] Export/import round trips passed
- [x] Corrupt/partial import rejection passed
- [x] Full automated quality gates passed
- [ ] Release APK and physical Android matrix passed

Acceptance criteria:
- [x] Database export checkpoints runtime and includes all current and routine
      tables in one consistent `michifocus.sqlite` snapshot.
- [x] Import migrates older supported schemas in isolation before replacement.
- [x] Import validates required tables, schema version, integrity, foreign keys,
      uniqueness, and routine/task references.
- [x] A routine-active imported runtime is paused safely and restores the same
      task/routine context without advancing hidden time.
- [x] Round trips preserve templates, days, item order, schedules, run history,
      task links, Pomodoro history, mood, and archive state.
- [x] Existing legacy four-file backup migration remains supported and produces
      no routine rows unless routine data actually exists.
- [ ] Drift generation, formatting, analyzer, focused tests, full tests, release
      APK build/install/launch, and physical Android visual/behavior checks pass.
- [x] Upgrade verification uses a copy/fixture and never erases the user's real
      device data.

Physical verification evidence on 2026-08-09:
- RMX3301 exported one 217088-byte `michifocus.sqlite` into a selected Android
  document-tree folder. The pulled file passed schema 5, integrity, foreign-key,
  required-table, and readable-row checks for all 12 tables.
- The same snapshot imported through the Android picker, applied after process
  restart, and restored the routine, task counts, schedules, and statuses.
- Portrait inspection passed for Home, routine list/editor, routine start and
  automatic In Progress transition, Focus countdown/details, Calendar, routine
  statistics, the X/Y curve, PDF generation, and the three-page Android viewer.
- The pre-test snapshot was imported again after the execution smoke; the app
  returned to two Pending tasks, zero In Progress tasks, and no active timer.
- The future routine reminder, reboot restoration, background delivery, denied
  permission, silent mode, and timezone gates passed under V9-M5. V9-M4 passed
  active, paused, timed-break, return, and explicit stop/switch checks, and
  V9-M6 passed its populated bilingual theme/typography Home and Calendar matrix
  on 2026-08-11. REQ-V9-009 remains Implemented until its own remaining
  adversarial, complete physical-flow, and documentation gates pass.

## Non-goals for the first V9 release

- Cloud synchronization, shared routines, accounts, or social leaderboards.
- Artificial-intelligence-generated routines or internet recommendations.
- Arbitrary cron expressions, monthly recurrence, or calendar-provider sync.
- Replacing Goals, Tasks, Calendar, Pomodoro, or Settings navigation.
- Pre-generating a year of task rows.
- Automatically changing user schedules to resolve overlaps.
- Making streaks the primary success or punishment mechanism.

## Definition of done

V9 can move to Verified only when all nine requirements have implementation
evidence, the unified database round trip is proven, old data is preserved,
the full automated suite passes, and the complete portrait Android workflow is
visually and behaviorally inspected on a physical device.
