# Database

Use `drift` with SQLite for local persistence when needed. Keep schema and DAO concerns in data layers and map data models to domain models.

## Current local schema overview

The current local persistence model uses one Drift-managed SQLite file,
`michifocus.sqlite`. The generated ERD image documents the unified schema:

- [`database_erd.svg`](database_erd.svg)

Current Drift-backed SQLite store:

The unified database is currently at schema version 5. The `Introduced` column
records the first unified-schema version containing each table.

| SQLite table | Introduced | Purpose |
|---|---:|---|
| `goals` | 1 | Planned objectives and target dates. |
| `tasks` | 1 | Quick/planned tasks, status, scheduling, objective link, and estimated duration. |
| `pomodoro_sessions` | 1 | Completed focus sessions, actual focused seconds, task/goal links, and reflection data. |
| `calendar_events` | 1 | Local calendar events. |
| `task_completion_events` | 2 | Immutable, reportable task-completion transitions. |
| `reporting_metadata` | 2 | Trust boundary for completion-history reporting. |
| `pomodoro_runtime` | 3 | Singleton timer owner, phase, cadence, task-plan position, and recovery timestamps. |
| `routines` | 5 | Reusable routine identity and archive-first lifecycle. |
| `routine_days` | 5 | Normalized weekly recurrence. |
| `routine_items` | 5 | Ordered task templates scheduled within a routine. |
| `routine_runs` | 5 | Dated routine occurrence and immutable routine snapshots. |
| `routine_item_runs` | 5 | Idempotent task materialization link and historical item outcome. |

Logical relationships:

- `tasks.goal_id` links a task to `goals.id`.
- `pomodoro_sessions.goal_id` links a completed session to `goals.id`.
- `pomodoro_sessions.task_id` links a completed session to `tasks.id`.
- `pomodoro_runtime.task_id` links the active timer owner to `tasks.id`.
- `routine_days` and `routine_items` belong to reusable `routines`.
- `routine_runs` and `routine_item_runs` retain immutable dated snapshots.
- `routine_item_runs.task_id` links a generated ordinary task without taking
  ownership of that task.
- `tasks.scheduled_date` and `calendar_events.scheduled_at` group planning
  data by calendar day.

Important boundary:

- The unified Drift database declares SQLite foreign keys for task/goal and
  Pomodoro history links.
- Settings and timer preferences are stored through the local JSON settings
  repository, not as Drift tables and not as part of database backups.
- Database export checkpoints the active timer, creates a consistent SQLite
  snapshot with `VACUUM INTO`, and exports only that `michifocus.sqlite` file.
- Database import selects a local backup folder, stages `michifocus.sqlite`,
  migrates it in isolation, runs SQLite integrity and foreign-key checks,
  verifies required tables and schema version, pauses any imported running
  timer, and applies it on the next app startup before Drift opens. Legacy
  four-file database backups are still accepted for migration.
- The database connection uses `PRAGMA journal_mode = DELETE` so normal backup
  export remains a single SQLite file rather than requiring separate WAL files.

## Unified relationships

The database declares these SQLite foreign keys:

| Child column | Parent column | Delete action |
|---|---|---|
| `tasks.goal_id` | `goals.id` | `SET NULL` |
| `pomodoro_sessions.goal_id` | `goals.id` | `SET NULL` |
| `pomodoro_sessions.task_id` | `tasks.id` | `SET NULL` |
| `pomodoro_runtime.goal_id` | `goals.id` | `SET NULL` |
| `pomodoro_runtime.task_id` | `tasks.id` | `RESTRICT` |
| `routine_days.routine_id` | `routines.id` | `CASCADE` |
| `routine_items.routine_id` | `routines.id` | `CASCADE` |
| `routine_items.goal_id` | `goals.id` | `SET NULL` |
| `routine_runs.routine_id` | `routines.id` | `SET NULL` |
| `routine_item_runs.routine_run_id` | `routine_runs.id` | `CASCADE` |
| `routine_item_runs.routine_item_id` | `routine_items.id` | `SET NULL` |
| `routine_item_runs.task_id` | `tasks.id` | `SET NULL` |

The connection enables `PRAGMA foreign_keys = ON`, and indexes cover the
foreign-key and scheduled-date/time query columns. On first launch after the
unified database change, legacy feature-specific files are copied into
`michifocus.sqlite` when no unified database exists. See
[`REQ-DATABASE.md`](../requirements/REQ-DATABASE.md) for the complete scope and
remaining verification items.

## Required checks

- [ ] Relevant requirement or decision is linked.
- [ ] Implementation remains offline-first.
- [ ] Verification evidence is recorded when status changes.

## M2 Tasks persistence plan

Drift is the approved persistence mechanism for Tasks in M2.

Planned table:

| Column | Purpose |
|---|---|
| `id` | Local task identifier. |
| `title` | User-facing task title. |
| `isCompleted` | Completion state. |
| `status` | V2 task status: listed, in progress, or completed. |
| `scheduledDate` | Optional planned calendar day. |
| `goalId` | Optional linked objective identifier. |
| `durationMinutes` | Optional planned task duration in minutes. |
| `createdAt` | Local creation timestamp. |
| `updatedAt` | Local update timestamp. |

Implemented table:

| Drift table | SQLite table | Columns |
|---|---|---|
| `TaskRecords` | `tasks` | `id`, `title`, `is_completed`, `status`, `scheduled_date`, `goal_id`, `duration_minutes`, `created_at`, `updated_at` |

Implemented data boundary:

- `TasksDatabase` owns the Drift database and schema version.
- `TasksDao` owns task SQL operations.
- `DriftTasksRepository` maps Drift records to domain `Task` entities.
- `TasksController` depends on the `TasksRepository` contract, not Drift.
- `get_it` wiring lives in `lib/app/di/service_locator.dart`.
- Schema version 2 adds `status`, nullable `scheduled_date`, and nullable
  `goal_id` for the Productivity V2 unified task model.
- Schema version 3 adds nullable `duration_minutes` for planned task duration
  in `Home -> Planificacion`.

Boundary rules:

- Drift table and DAO stay in `lib/features/tasks/data/`.
- Repository maps Drift rows to domain-friendly task models.
- Presentation/controllers use repository/domain APIs, not DAOs directly.
- Schema/generator changes require `dart run build_runner build --delete-conflicting-outputs`.

Verification evidence:

- `dart run build_runner build --delete-conflicting-outputs` generated `tasks_database.g.dart`.
- `flutter analyze` passed after generated code changes.
- `flutter test test/features/tasks` passed, including a local SQLite file persistence test.
- 2026-07-11: V2-M2 Slice 1 regenerated `tasks_database.g.dart`; `dart format
  lib test`, `flutter analyze`, and `flutter test test/features/tasks` passed
  with 12 focused Tasks tests.
- 2026-07-11: Full `flutter test` passed with 49 tests.

## M3 Goals persistence plan

Drift is the approved persistence mechanism for Goals in M3.

Implemented table:

| Drift table | SQLite table | Columns |
|---|---|---|
| `GoalRecords` | `goals` | `id`, `title`, `target_sessions`, `completed_sessions`, `target_date`, `created_at`, `updated_at` |

Implemented data boundary:

- `GoalsDatabase` owns the Drift database and schema version.
- `GoalsDao` owns goal SQL operations.
- `DriftGoalsRepository` maps Drift records to domain `ProductivityGoal` entities.
- `GoalsController` depends on the `GoalsRepository` contract, not Drift.
- `get_it` wiring lives in `lib/app/di/service_locator.dart`.
- Schema version 2 adds nullable `target_date` for goal deadline planning.

Verification evidence:

- `dart run build_runner build --delete-conflicting-outputs` generated `goals_database.g.dart`.
- `flutter analyze` passed after generated code changes.
- Full `flutter test` passed with 40 total tests after the `target_date`
  migration, including goal controller and local SQLite file persistence tests.

## M4 Pomodoro sessions persistence plan

Drift is the approved persistence mechanism for completed Pomodoro sessions in M4.

Implemented table:

| Drift table | SQLite table | Columns |
|---|---|---|
| `PomodoroSessionRecords` | `pomodoro_sessions` | `id`, `started_at`, `ended_at`, `planned_seconds`, `focused_seconds`, `goal_id`, `task_id`, `start_mood_score`, `end_mood_score`, `mood_prompt_pending`, `was_distracted`, `distraction_minutes`, `status`, `created_at` |

Implemented data boundary:

- `PomodoroSessionsDatabase` owns the Drift database and schema version.
- `PomodoroSessionsDao` owns completed-session SQL operations.
- `DriftPomodoroSessionsRepository` maps Drift records to domain `PomodoroSession` entities.
- `PomodoroController` depends on the `PomodoroSessionsRepository` contract, not Drift.
- `get_it` wiring lives in `lib/app/di/service_locator.dart`.
- Schema version 2 adds nullable `goal_id` so completed sessions can be linked
  to goal progress without requiring a goal.
- Schema version 3 adds nullable `task_id` so completed sessions can be linked
  to task estimated-duration progress.
- Schema version 4 adds nullable structured reflection fields for V3-M4:
  `start_mood_score`, `end_mood_score`, `was_distracted`, and
  `distraction_minutes`. No written distraction note is stored.

Verification evidence:

- `dart run build_runner build --delete-conflicting-outputs` generated `pomodoro_sessions_database.g.dart`.
- `dart format lib test` passed after schema and UI changes.
- `flutter analyze` passed after generated code changes.
- Full `flutter test` passed with 44 total tests, including controller and
  local SQLite file persistence coverage for `goal_id`.

## M5 Calendar events persistence plan

Drift is the approved persistence mechanism for Calendar events in M5.

Implemented table:

| Drift table | SQLite table | Columns |
|---|---|---|
| `CalendarEventRecords` | `calendar_events` | `id`, `title`, `scheduled_at`, `duration_minutes`, `created_at` |

Implemented data boundary:

- `CalendarEventsDatabase` owns the Drift database and schema version.
- `CalendarEventsDao` owns calendar event SQL operations.
- `DriftCalendarEventsRepository` maps Drift records to domain
  `CalendarEvent` entities.
- `CalendarController` depends on the `CalendarEventsRepository` contract, not
  Drift.
- `get_it` wiring lives in `lib/app/di/service_locator.dart`.

Verification evidence:

- `dart run build_runner build --delete-conflicting-outputs` generated
  `calendar_events_database.g.dart`.
- `flutter analyze` passed after generated code changes.
- Full `flutter test` passed with 39 total tests, including calendar
  controller and local SQLite file persistence tests.

## V5-M3 reporting history and indexes

Unified database schema version 2 adds:

| Drift table/column | SQLite storage | Purpose |
|---|---|---|
| `TaskRecords.legacyCompletionUnknown` | `tasks.legacy_completion_unknown` | Marks migrated completed tasks whose completion date cannot be trusted. |
| `TaskCompletionEventRecords` | `task_completion_events` | Preserves immutable completion transitions with task and scheduled-date snapshots. |
| `ReportingMetadataRecords` | `reporting_metadata` | Records when trustworthy completion tracking began. |

The migration marks existing completed tasks as legacy unknown, creates no
invented completion events, and keeps backup import/export on the single
`michifocus.sqlite` file.

Reporting range indexes cover `tasks.scheduled_date`, `tasks.created_at`,
`pomodoro_sessions.ended_at`, and `task_completion_events.completed_at`.
Automated query-plan evidence uses 20,000 tasks and 50,000 sessions and confirms
the timestamp indexes are selected for bounded report queries. Chart buckets
are grouped in one bounded task query and one bounded Pomodoro query instead of
issuing one query per bucket.

## V6-M0 recoverable Pomodoro runtime

Unified database schema version 3 adds the singleton `pomodoro_runtime` table.
It stores the active owner, focus/break phase, running or paused state,
remaining and total phase seconds, cadence, automatic transition settings,
continuous or single-block mode, current block, total blocks, task estimate,
focused baseline, and clock reconciliation timestamps.

## V9 routines persistence

Status: Verified for V9-M1 on 2026-08-07. Unified schema version 5 adds the
five routine tables through a forward-only migration; existing tables and rows
are not rebuilt or repurposed.

V9 adds routine templates and dated execution history without replacing the
existing task or Pomodoro sources of truth.

| Table | Verified key data | Responsibility |
|---|---|---|
| `routines` | `id`, name/description, icon/color keys, lifecycle state, timestamps | Reusable routine identity and archive-first lifecycle. |
| `routine_days` | `routine_id`, weekday | Normalized weekly recurrence with unique routine/day pairs. |
| `routine_items` | `id`, `routine_id`, order, title, minute-of-day, duration, optional goal, optionality, reminder, Pomodoro preference | Ordered templates for tasks scheduled within the routine. |
| `routine_runs` | `id`, nullable `routine_id`, local date, status, actual timestamps, immutable routine snapshots | One expected or actual occurrence on a local date. |
| `routine_item_runs` | `id`, run/item/task links, planning snapshots, status, completion/skip timestamps | Idempotent daily materialization link and historical item outcome. |

Verified relationships and deletion rules:

| Child column | Parent column | Delete action | Reason |
|---|---|---|---|
| `routine_days.routine_id` | `routines.id` | `CASCADE` | Recurrence rows have no meaning without their template. |
| `routine_items.routine_id` | `routines.id` | `CASCADE`, guarded by archive-first application rules | Template rows are removed only by exceptional hard delete; item-run snapshots preserve history. |
| `routine_items.goal_id` | `goals.id` | `SET NULL` | Goal deletion must not delete routine items. |
| `routine_runs.routine_id` | `routines.id` | `SET NULL` | Immutable snapshots preserve dated history. |
| `routine_item_runs.routine_run_id` | `routine_runs.id` | `CASCADE` | Explicit deletion of a dated run owns its item outcomes. |
| `routine_item_runs.routine_item_id` | `routine_items.id` | `SET NULL` | Historical item snapshots survive template edits/deletion. |
| `routine_item_runs.task_id` | `tasks.id` | `SET NULL` | Task deletion must not erase routine history. |

Data ownership:

- `tasks.status` remains authoritative for Pending, In Progress, and Completed.
- `pomodoro_sessions.focused_seconds` and mood fields remain authoritative for
  focus and wellbeing reporting.
- Routine item runs store schedule/history snapshots, not duplicate focused
  seconds or mood values.
- Future occurrences are computed from active templates. Only necessary current
  tasks are materialized.
- Missed historical dates may create missed run outcomes but must never create
  stale pending tasks or invented completion events.

Verified constraints and indexes:

- Unique routine/day recurrence.
- Unique dated routine occurrence key.
- Unique run/item materialization key and one routine link per generated task.
- Stable item ordering per routine.
- Indexes for active recurrence lookup, local schedule time, run date/status,
  item/run/task relationships, and bounded report ranges.
- Transactions around run creation, task insertion, item-run linking, and state
  synchronization.

Migration and backup behavior:

- The forward migration may create only V9 tables/indexes and must preserve
  every existing row and identifier.
- Old-schema migration fixtures must compare table counts and representative
  values before and after upgrade.
- Unified export continues to produce only `michifocus.sqlite`; no routine JSON
  or separate per-table files are introduced.
- Import migrates in staging and validates schema, integrity, foreign keys,
  required tables, and uniqueness before replacing the live database.
- Legacy four-file imports remain accepted and produce no fabricated routine
  data.
- Import validation requires all 12 application tables and every named index,
  rejects future schema versions before migration, checks canonical local dates,
  and runs `integrity_check` plus `foreign_key_check` in staging.

V9-M1 verification evidence on 2026-08-07:

- Drift generated schema rebuilt successfully at version 5.
- Migration fixtures from populated unified schemas 1, 2, 3, and 4 preserve
  existing records and active Pomodoro runtime state.
- Repository tests cover aggregate persistence, safe reorder, archive-first
  deletion, snapshot survival, foreign-key delete actions, task/run ownership,
  duplicate occurrence/materialization rejection, and database checks.
- Import validation tests cover a valid current database, staged schema-4
  migration, future-version rejection without byte changes, missing-index
  rejection, and non-canonical local-date rejection.
- Focused V9 persistence tests, `flutter analyze`, and the full Flutter test
  suite passed.

V9-M3 verification evidence on 2026-08-09:

- Startup, resume, local-midnight, routine-save, and post-import paths converge
  on one current-local-day reconciliation operation.
- The transaction materializes only today's ordinary tasks and their item-run
  links. Future dates remain virtual projections.
- Scheduled dates missed since the routine template's last active update are
  recorded as missed run/item snapshots without task rows or completion events.
  This lower bound prevents the current template from being projected into
  dates before that template state existed.
- Existing run/task/item links synchronize Pending, In Progress, and Completed
  through the authoritative task state. Task or template deletion nulls live
  links while preserving identifiers, titles, schedules, and outcome snapshots.
- Unique occurrence, run/item, and task-link indexes plus one transaction make
  repeated, concurrent, restart, import, and clock-adjustment reconciliation
  idempotent.
- Build Runner, 16 focused persistence tests, clean analysis, and the full
  220-test suite passed across year rollover, leap day, UTC/local clock
  representation, deletion, task planning, Pomodoro, reporting, and import.
- A release update and two RMX3301 process restarts preserved the same two
  Pending tasks and single current routine occurrence, providing physical
  evidence that startup reconciliation is repeatable without duplicates.

V9-M8 implementation evidence on 2026-08-09:

- Export requires a live-database `VACUUM INTO` snapshot and emits only
  `michifocus.sqlite`; settings JSON and per-table files are excluded.
- Unified and complete four-file legacy imports are converted, migrated, and
  validated inside staging before a recoverable same-filesystem replacement.
- Validation rejects version-zero/empty SQLite files and checks all 12 tables,
  exact column/primary-key inventories, schema version, integrity, declared
  foreign keys, named index columns and uniqueness, routine contracts,
  canonical dates, and existing references. Partial or empty legacy sets are
  rejected.
- Round-trip fixtures preserve all 12 tables, routine templates/days/order,
  reminders, run snapshots, task links, Pomodoro mood/history, archive state,
  and a paused runtime with unchanged remaining seconds.
- Interrupted staging is ignored and removed at startup; only a fully validated
  staging directory becomes a pending import. Interrupted live replacement
  restores the previous database or finalizes the completed swap.
- Build Runner, formatting, clean analysis, 75 focused tests, and the full
  215-test suite passed. Debug and release APKs installed and launched with
  `adb install -r`; the RMX3301 database remained 217088 bytes. The unlocked
  physical import/visual matrix remains before `Verified`.

See `REQ-PRODUCTIVITY_V9.md`, `../architecture/ROUTINES.md`, and V9-M0 through
V9-M8 in `MILESTONES.md`.

The runtime row is a recoverable checkpoint, not immutable focus history.
Completed and partial focus remain in `pomodoro_sessions`; deterministic
session identifiers and insert-ignore semantics prevent a retried boundary
from being counted twice. Background time is reconciled from timestamps when
the process resumes or restarts.

Verification evidence on 2026-07-29:

- Drift generated code was rebuilt after schema version 3.
- Schema 1 and schema 2 migration tests passed.
- Runtime repository restoration, exclusive ownership, background clock
  reconciliation, and duplicate-boundary tests passed.
- Unified import/export, invalid backup rejection, and full database
  regression tests passed.
- `flutter analyze` passed and the full suite passed with 134 tests.

## V6-M0.5 recoverable block reflection

Unified database schema version 4 adds `pomodoro_sessions.mood_prompt_pending`.
A completed focus block sets the flag; saving its final 1-to-5 reflection clears
it in the same DAO update. Partial sessions never set it. Loading session
history rebuilds the unanswered queue oldest-first, so background transitions
or Android process recreation cannot replace one block's question with another.

The report average uses only valid `end_mood_score` values from completed
sessions that remain linked to a task. Start mood, partial sessions, free
Pomodoros, null scores, and out-of-range values are excluded.

Verification evidence on 2026-08-04:

- Drift generated code was rebuilt for unified schema version 4.
- Schema 1 and schema 2 migration paths add the pending flag safely.
- Persistence, queue restoration, report formula, Home, and PDF tests passed.
- `flutter analyze` passed and the full suite passed with 159 tests.

