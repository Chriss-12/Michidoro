# Database

Use `drift` with SQLite for local persistence when needed. Keep schema and DAO concerns in data layers and map data models to domain models.

## Current local schema overview

The current local persistence model is documented in the generated ERD image:

- [`database_erd.svg`](database_erd.svg)

Current Drift-backed SQLite stores:

| Local store | SQLite table | Schema version | Purpose |
|---|---|---:|---|
| `michifocus_goals` | `goals` | 2 | Planned objectives and target dates. |
| `michifocus_tasks` | `tasks` | 3 | Quick/planned tasks, status, scheduling, objective link, and estimated duration. |
| `michifocus_pomodoro_sessions` | `pomodoro_sessions` | 4 | Completed focus sessions, actual focused seconds, optional objective/task links, and focus reflection data. |
| `michifocus_calendar_events` | `calendar_events` | 1 | Legacy/local calendar events. |

Logical relationships:

- `tasks.goal_id` links a task to `goals.id`.
- `pomodoro_sessions.goal_id` links a completed session to `goals.id`.
- `pomodoro_sessions.task_id` links a completed session to `tasks.id`.
- `tasks.scheduled_date` and `calendar_events.scheduled_at` group planning
  data by calendar day.

Important boundary:

- These links are logical application-level relationships; Drift does not
  currently declare foreign key constraints between the feature databases.
- Settings and timer preferences are stored through the local JSON settings
  repository, not as Drift tables.
- V3-M2 database export copies the local Settings JSON and known Drift SQLite
  database files into a `michifocus-backup` folder under the configured Reports
  folder or Downloads/default folder.
- V3-M2 database import selects a local backup folder, stages known MichiFocus
  files in `michifocus-pending-import`, and applies them on the next app startup
  before Drift databases open.

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

