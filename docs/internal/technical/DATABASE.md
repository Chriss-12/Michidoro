# Database

Use `drift` with SQLite for local persistence when needed. Keep schema and DAO concerns in data layers and map data models to domain models.

## Current local schema overview

The current local persistence model uses one Drift-managed SQLite file,
`michifocus.sqlite`. The generated ERD image documents the unified schema:

- [`database_erd.svg`](database_erd.svg)

Current Drift-backed SQLite store:

| Local store | SQLite table | Schema version | Purpose |
|---|---|---:|---|
| `michifocus.sqlite` | `goals` | 1 | Planned objectives and target dates. |
| `michifocus.sqlite` | `tasks` | 1 | Quick/planned tasks, status, scheduling, objective link, and estimated duration. |
| `michifocus.sqlite` | `pomodoro_sessions` | 1 | Completed focus sessions, actual focused seconds, optional objective/task links, and focus reflection data. |
| `michifocus.sqlite` | `calendar_events` | 1 | Local calendar events. |
| `michifocus.sqlite` | `pomodoro_runtime` | 3 | Singleton active timer owner, phase, cadence, task-plan position, and recovery timestamps. |

Logical relationships:

- `tasks.goal_id` links a task to `goals.id`.
- `pomodoro_sessions.goal_id` links a completed session to `goals.id`.
- `pomodoro_sessions.task_id` links a completed session to `tasks.id`.
- `pomodoro_runtime.task_id` links the active timer owner to `tasks.id`.
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
| `PomodoroSessionRecords` | `pomodoro_sessions` | `id`, `started_at`, `ended_at`, `planned_seconds`, `focused_seconds`, `goal_id`, `task_id`, `start_mood_score`, `end_mood_score`, `was_distracted`, `distraction_minutes`, `status`, `created_at` |

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

