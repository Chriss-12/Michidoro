# Routines architecture contract

Status: Approved design baseline for V9-M0 on 2026-08-07. No V9 schema or
application code is implemented by this document.

## Decision summary

MichiDoro routines are reusable weekly schedules made of ordered task
templates. A due item materializes as one ordinary `tasks` row for its local
date. Existing Tasks owns task status, Pomodoro owns focused time and mood, and
Reports owns aggregates. Routines owns recurrence, occurrence history, and the
link between a template item and its generated task.

Configuration belongs under `Tareas -> Rutinas`. Home and Calendar consume the
result later; neither becomes a second editor and no sixth bottom-navigation
destination is added.

## Non-negotiable boundaries

- One `michifocus.sqlite` database remains the only productivity-data export.
- Existing tables and columns keep their current names and meanings.
- A normal task has no required routine relationship.
- No focus seconds, breaks, mood score, or completion event is copied into a
  routine template.
- No UI widget imports Drift or a DAO.
- No cloud, account, network, Firebase, Supabase, or new state framework is
  introduced.
- Future dates are projected from recurrence rules; a year of tasks is never
  pre-generated.
- Every write that creates an occurrence and task is atomic and idempotent.
- Historical snapshots are immutable after an occurrence reaches a terminal
  state.

## Time model

Routines follow local wall-clock time because users describe them as
`Monday at 07:15`, not as a universal UTC instant.

| Value | Storage | Rule |
|---|---|---|
| Weekday | Integer `1..7` | ISO weekday: Monday is 1 and Sunday is 7. |
| Template time | Integer `0..1439` | Minutes since local midnight. Seconds are intentionally unsupported. |
| Occurrence date | Text `YYYY-MM-DD` | Canonical local date, lexicographically sortable. |
| Materialized task time | Existing Drift `DateTime` representation | Resolved from local date plus minute-of-day when the task is created. |
| Audit timestamps | Existing Drift `DateTime` representation | Actual creation, start, update, completion, skip, and archive instants. |

A routine run belongs to the local date on which each template occurrence is
scheduled to start. An estimated duration may cross midnight; its start-date
ownership does not change. Conflict detection includes spillover from the
previous and into the next local date.

Timezone or daylight-saving changes do not rewrite history. Unmaterialized
future projections are recalculated in the new local zone. Materialized rows
keep their scheduled timestamp snapshot unless the user explicitly edits that
occurrence.

## Final table contract

All identifiers are non-empty local text identifiers generated with the same
collision-resistant convention used by existing features. All enums are stored
as stable text names and rejected when unknown during import.

### `routines`

| Column | SQLite/Drift contract | Null | Default or constraint |
|---|---|---:|---|
| `id` | `TEXT`, primary key | No | Stable local identifier. |
| `name` | `TEXT` | No | Trimmed, `1..80` values at domain validation. |
| `description` | `TEXT` | Yes | Trimmed, maximum 500 values when present. |
| `icon_key` | `TEXT` | No | Stable app-owned icon key; fallback is `routine`. |
| `color_key` | `TEXT` | No | Stable theme-aware color key; fallback is `primary`. |
| `status` | `TEXT` | No | `active`, `paused`, or `archived`; default `active`. |
| `paused_until_local_date` | `TEXT` | Yes | Canonical `YYYY-MM-DD`; null means an indefinite pause. |
| `archived_at` | `INTEGER`/`DateTime` | Yes | Required by domain rules when status is `archived`. |
| `created_at` | `INTEGER`/`DateTime` | No | Creation instant. |
| `updated_at` | `INTEGER`/`DateTime` | No | Last template mutation instant. |

Indexes: `routines_status_idx(status)` and
`routines_updated_at_idx(updated_at)`.

Database check: `status IN ('active', 'paused', 'archived')`.

Application invariants:

- `paused_until_local_date` is allowed only for `paused`.
- Resuming clears `paused_until_local_date`.
- Archiving clears pause data and sets `archived_at`.
- Normal UI performs archive/restore, not hard delete.

### `routine_days`

| Column | SQLite/Drift contract | Null | Default or constraint |
|---|---|---:|---|
| `routine_id` | `TEXT`, foreign key | No | References `routines.id` with `ON DELETE CASCADE`. |
| `weekday` | `INTEGER` | No | Check `weekday BETWEEN 1 AND 7`. |

Primary key: `(routine_id, weekday)`. A saved active routine requires at least
one day and at least one item. Day replacement occurs in the same transaction
as the routine update. A dated pause is inclusive: the routine becomes eligible
again on the first local date after `paused_until_local_date`.

Index: `routine_days_weekday_routine_idx(weekday, routine_id)` supports due-day
lookup without scanning every routine/day pair.

### `routine_items`

| Column | SQLite/Drift contract | Null | Default or constraint |
|---|---|---:|---|
| `id` | `TEXT`, primary key | No | Stable template-item identifier. |
| `routine_id` | `TEXT`, foreign key | No | References `routines.id` with `ON DELETE CASCADE`. |
| `position` | `INTEGER` | No | Zero-based, non-negative order. |
| `title` | `TEXT` | No | Trimmed, `1..160` values at domain validation. |
| `scheduled_minute` | `INTEGER` | No | Check `0..1439`. |
| `duration_minutes` | `INTEGER` | No | Check `1..1440`; planned occupied time. |
| `goal_id` | `TEXT`, foreign key | Yes | References `goals.id` with `ON DELETE SET NULL`. |
| `is_optional` | `INTEGER`/boolean | No | Default false. |
| `reminder_minutes_before` | `INTEGER` | Yes | Check `0..10080`; null disables the reminder. |
| `pomodoro_mode` | `TEXT` | No | `none`, `recommended`, or `custom`; default `none`. |
| `custom_focus_minutes` | `INTEGER` | Yes | Check `1..240`; required only for `custom`. |
| `custom_break_minutes` | `INTEGER` | Yes | Check `1..60`; required only for `custom`. |
| `created_at` | `INTEGER`/`DateTime` | No | Creation instant. |
| `updated_at` | `INTEGER`/`DateTime` | No | Last mutation instant. |

Constraints and indexes:

- Unique `(routine_id, position)`.
- `routine_items_routine_time_idx(routine_id, scheduled_minute)`.
- `routine_items_goal_id_idx(goal_id)`.
- Custom focus/break values are both present only for `custom`; they are null
  for `none` and `recommended`.
- Database check: `pomodoro_mode IN ('none', 'recommended', 'custom')`, with a
  matching presence check for both custom-minute columns.

Items may overlap because users retain control. Save and review display the
overlap, including cross-midnight overlap, but never move an item silently.
Reordering uses a transaction-safe temporary position strategy.

### `routine_runs`

| Column | SQLite/Drift contract | Null | Default or constraint |
|---|---|---:|---|
| `id` | `TEXT`, primary key | No | Stable dated-run identifier. |
| `routine_id` | `TEXT`, foreign key | Yes | References `routines.id` with `ON DELETE SET NULL`. |
| `source_routine_id` | `TEXT` | No | Immutable original ID for history/idempotency. |
| `local_date` | `TEXT` | No | Canonical occurrence date `YYYY-MM-DD`. |
| `status` | `TEXT` | No | `scheduled`, `inProgress`, `completed`, `skipped`, or `missed`. |
| `name_snapshot` | `TEXT` | No | Name at reconciliation/materialization. |
| `icon_key_snapshot` | `TEXT` | No | Historical presentation key. |
| `color_key_snapshot` | `TEXT` | No | Historical presentation key. |
| `scheduled_start_minute_snapshot` | `INTEGER` | No | Earliest item minute, check `0..1439`. |
| `started_at` | `INTEGER`/`DateTime` | Yes | First linked task start. |
| `completed_at` | `INTEGER`/`DateTime` | Yes | Required for completed status. |
| `skipped_at` | `INTEGER`/`DateTime` | Yes | Required for intentional skip. |
| `created_at` | `INTEGER`/`DateTime` | No | Row creation instant. |
| `updated_at` | `INTEGER`/`DateTime` | No | Last transition instant. |

Constraints and indexes:

- Unique `(source_routine_id, local_date)` remains durable if `routine_id`
  later becomes null.
- `routine_id` is null or equals immutable `source_routine_id`.
- `routine_runs_date_status_idx(local_date, status)`.
- `routine_runs_routine_date_idx(routine_id, local_date)`.
- Database check: status is one of `scheduled`, `inProgress`, `completed`,
  `skipped`, or `missed`.

There is at most one normal run per routine/local date. Manually repeating a
completed routine starts ordinary tasks and does not fabricate a second
scheduled occurrence in the first V9 release.

### `routine_item_runs`

| Column | SQLite/Drift contract | Null | Default or constraint |
|---|---|---:|---|
| `id` | `TEXT`, primary key | No | Stable item-occurrence identifier. |
| `routine_run_id` | `TEXT`, foreign key | No | References `routine_runs.id` with `ON DELETE CASCADE`. |
| `routine_item_id` | `TEXT`, foreign key | Yes | References `routine_items.id` with `ON DELETE SET NULL`. |
| `source_item_id` | `TEXT` | No | Immutable original ID for idempotency. |
| `task_id` | `TEXT`, foreign key | Yes | References `tasks.id` with `ON DELETE SET NULL`. |
| `task_id_snapshot` | `TEXT` | Yes | Original generated task ID after deletion. |
| `position_snapshot` | `INTEGER` | No | Historical item order. |
| `title_snapshot` | `TEXT` | No | Historical task title. |
| `scheduled_at_snapshot` | `INTEGER`/`DateTime` | No | Historical local schedule instant. |
| `duration_minutes_snapshot` | `INTEGER` | No | Check `1..1440`. |
| `goal_title_snapshot` | `TEXT` | Yes | Historical display only; no foreign key. |
| `is_optional_snapshot` | `INTEGER`/boolean | No | Historical completion denominator. |
| `reminder_minutes_snapshot` | `INTEGER` | Yes | Reminder at materialization. |
| `pomodoro_mode_snapshot` | `TEXT` | No | Historical focus preference. |
| `custom_focus_minutes_snapshot` | `INTEGER` | Yes | Historical custom cadence. |
| `custom_break_minutes_snapshot` | `INTEGER` | Yes | Historical custom cadence. |
| `status` | `TEXT` | No | `scheduled`, `inProgress`, `completed`, `skipped`, or `missed`. |
| `started_at` | `INTEGER`/`DateTime` | Yes | First in-progress transition. |
| `completed_at` | `INTEGER`/`DateTime` | Yes | Mirrored terminal instant for history. |
| `skipped_at` | `INTEGER`/`DateTime` | Yes | Intentional skip instant. |
| `created_at` | `INTEGER`/`DateTime` | No | Row creation instant. |
| `updated_at` | `INTEGER`/`DateTime` | No | Last transition instant. |

Constraints and indexes:

- Unique `(routine_run_id, source_item_id)` remains valid if the template item
  FK later becomes null.
- `routine_item_id` is null or equals immutable `source_item_id`.
- Unique nullable `task_id`; one ordinary task cannot represent two items.
- Unique index `routine_item_runs_task_id_uq(task_id)`; SQLite permits multiple
  nulls but rejects a repeated linked task.
- `routine_item_runs_routine_item_id_idx(routine_item_id)` supports relationship
  lookup and `SET NULL` maintenance.
- `routine_item_runs_schedule_status_idx(scheduled_at_snapshot, status)`.
- `routine_item_runs_run_position_idx(routine_run_id, position_snapshot)`.
- Database checks mirror the approved run-status and Pomodoro-mode value sets.

The item-run status mirrors the linked task only to freeze history and support
bounded reports. `tasks.status` remains authoritative while the task exists.
Every task mutation path calls one shared data-layer transaction or post-write
reconciliation that updates the linked item/run. Presentation never
synchronizes the two manually. A mismatch is an integrity failure.

## Delete and archive matrix

| User action | Application behavior | Database result |
|---|---|---|
| Archive routine | Stop future projection/materialization and cancel reminders. | Template, items, runs, tasks, and history remain. |
| Restore routine | Reactivate only from the chosen effective date. | Historical rows remain unchanged. |
| Remove template item | Affect future unstarted dates only after confirmation. | Item may be deleted; historical item-run FK becomes null and snapshots remain. |
| Delete generated task | Use existing task confirmation. | Item-run task FK becomes null; task/status snapshots remain. |
| Delete goal | Existing behavior. | Item goal FK becomes null; existing task/session detach rules apply. |
| Hard-delete archived routine | Exceptional maintenance/data-erasure action. | Days/items cascade; run FK becomes null; run history survives. |
| Delete historical run | Not exposed in normal V9 UI. | Explicit erasure/repair only; item-runs cascade. Tasks require a separate decision. |

Hard deletion is rejected while a routine is active/paused, while its dated run
is active, or while a linked task owns `pomodoro_runtime`.

## Materialization transaction

For one active routine and one due local date:

1. Resolve status, pause window, weekday, local date, timezone, and template
   items without writing.
2. Start one SQLite transaction.
3. Insert-or-read `routine_runs` by `(source_routine_id, local_date)`.
4. For each item, insert-or-read `routine_item_runs` by
   `(routine_run_id, source_item_id)`.
5. If the item-run has no task and is current, insert one ordinary task with
   existing title, `listed` status, scheduled time, goal, duration, and
   timestamps; then set task link and snapshot.
6. Commit only after every required row succeeds.
7. Reload Tasks and Routines through repository/controller APIs.

Unique constraints make restart, duplicate lifecycle events, concurrent calls,
and import reconciliation retry-safe. Constraint conflicts are read back and
verified; they are not ignored blindly.

Past dates reconcile as `missed` without old pending tasks. Future dates are
projections only. A bounded OS notification window does not create task rows.

## Edit semantics

| Context | Choice | Result |
|---|---|---|
| Template editor | Save | Changes future unmaterialized occurrences; history/current run stays fixed. |
| Today's generated task | `Solo hoy` | Changes task and current snapshots; template stays fixed. |
| Today's generated task | `Hoy y futuras` | Changes today plus template in one coordinated operation; history stays fixed. |
| Future virtual item | Edit routine | Opens template editor; no task exists yet. |
| Completed/missed/skipped item | View history | Immutable in normal V9 UI. |
| Start late | Keep times | Current scheduled snapshots stay fixed. |
| Start late | Shift remaining today | Only unstarted items/tasks in this run move by one delta. |

Changing weekdays never invalidates completed days. Removing today from a
routine requires an explicit choice to keep or skip an already materialized run.

## State derivation

Task statuses remain `listed`, `inProgress`, and `completed`.

Routine item transitions are `scheduled -> inProgress -> completed`.
`scheduled -> skipped` is intentional; `scheduled -> missed` occurs only after
the local occurrence elapsed. Terminal outcomes are immutable in normal UI.

Routine run status is persisted in the same transaction:

- `scheduled`: nothing started and the occurrence is current/future.
- `inProgress`: some item started/completed while required work remains.
- `completed`: all required items completed; optional items may be completed or
  intentionally skipped.
- `skipped`: user intentionally skipped the whole run before completion.
- `missed`: date elapsed with required work missed and no intentional run skip.

An optional missed item does not prevent completion and is excluded from the
required-consistency denominator.

## Architecture ownership

Future implementation belongs under `lib/features/routines/` using the current
feature-first Clean Architecture pattern.

| Layer | Responsibility |
|---|---|
| Domain | Entities, statuses, recurrence/time rules, repository contract, projections, formulas. |
| Data | Drift/DAO, repository, transactions, mappings, indexed queries, migration/import validation. |
| Presentation | `Tareas | Rutinas`, editor, occurrence views, messages, signals controller. |
| Existing Tasks | Ordinary task CRUD/status and task-facing UI. |
| Existing Pomodoro | Runtime, block planning, breaks, focus seconds, mood, completion. |
| Existing Reports | Shared range snapshot, aggregates, Home charts, and PDF. |
| Composition root | `get_it` registration and startup reconciliation. |

The routines data implementation may insert `TaskRecords` because both tables
share one database and atomicity is required. It returns/maps domain Tasks or
triggers the existing repository reload; UI never writes tables directly.

## Migration fixture contract

V9-M1 implements temporary-file fixtures for every row below. Fixtures use
synthetic data or a user-approved copy, never the user's live file.

| Fixture | Required content | Expected V9 result |
|---|---|---|
| Fresh install | No prior database | Current plus five empty routine tables. |
| Unified v1 populated | Goal, pending/completed tasks, session, event | Existing migration semantics preserved; routine tables empty. |
| Unified v2 populated | Completion metadata/events and legacy unknown | Reporting history preserved; routine tables empty. |
| Unified v3 running | Active/paused focus or break runtime | Runtime preserved by app upgrade; routine tables empty. |
| Unified v4 populated | Every table, mood prompt pending, linked task/session | Counts, values, links preserved; routine tables empty. |
| Current empty v4 | Valid schema with zero rows | Upgrade succeeds and is idempotent. |
| Four-file legacy | All stores plus valid/broken links | Existing migration behavior; no fabricated routine rows. |
| Imported v4 backup | Valid export with paused/running runtime | Staged migration; running import paused per current policy. |
| V9 populated round trip | Every template/run/item state and deleted links | Snapshots, links, order, and states preserved. |
| Repeated target open | Current V9 file opened repeatedly | No duplicate schema, metadata, runs, or tasks. |
| Broken foreign keys | Invalid synthetic references | Reject import or apply a separately approved repair before replacement. |
| Duplicate occurrence | Duplicate durable run/item keys | Reject import; never merge ambiguously. |
| Missing table | Partial SQLite schema | Reject before live replacement. |
| Corrupt/non-SQLite | Invalid bytes or integrity failure | Reject; live database untouched. |
| Future schema | `user_version` above supported | Reject safely; never downgrade. |
| Interrupted migration | Injected failure at each boundary | Roll back and keep source/live data recoverable. |

Every successful fixture records before/after counts, representative values,
schema version, required table/index inventory, `integrity_check`,
`foreign_key_check`, and key application reads. V9 fixtures also verify unique
occurrence keys and snapshot behavior after every delete rule.

## Implementation sequence

1. V9-M1 implements schema, migration, repository, fixtures, and integrity
   tests only; it does not expose incomplete UI.
2. V9-M2 implements template management.
3. V9-M3 enables materialization after idempotency tests pass.
4. V9-M4 composes Pomodoro execution.
5. V9-M5 adds native reminders only after V4 capability approval.
6. V9-M6/V9-M7 add projections/reporting after history is trustworthy.
7. V9-M8 performs the complete round trip and Android matrix.

## V9-M0 verification

- [x] Current schema version and seven existing tables inspected.
- [x] Existing v1/v2 tests and four-file migrator inspected.
- [x] Column, nullability, constraint, index, and delete contract set.
- [x] Time, materialization, editing, state, and ownership rules set.
- [x] Migration/import matrix set for supported sources and failures.
- [x] No application, generated, Android, dependency, or live database changed.

Next gate: explicit approval to implement V9-M1.
