# Database requirements

Status:
Implemented. Automated migration fixtures for legacy on-device files and a
manual migration with real existing data remain required before `Verified`.

## Summary

MichiFocus will use one Drift-managed SQLite file, `michifocus.sqlite`, for
Goals, Tasks, Pomodoro sessions, and calendar events. The database, rather
than application code alone, will enforce references between goals, tasks, and
completed sessions.

### REQ-DB-001 - Unified local database and referential integrity

Status: Implemented

Objective:
Replace the four feature-specific SQLite files with one offline-first Drift
database that preserves existing data and enforces valid task, goal, and
Pomodoro relationships through SQLite foreign keys.

Scope:
- One production SQLite file named `michifocus.sqlite`.
- Tables: `goals`, `tasks`, `pomodoro_sessions`, and `calendar_events`.
- Nullable foreign keys from `tasks.goal_id`,
  `pomodoro_sessions.goal_id`, and `pomodoro_sessions.task_id`.
- Foreign-key enforcement enabled for every database connection.
- Indexes for relationship and date-range queries.
- One-time, atomic migration from the current four SQLite files.
- Backup/export and import updated to use the unified database file.
- Focused persistence, migration, backup/import, and regression tests.

Non-goals:
- No backend, cloud synchronization, Firebase, Supabase, or account system.
- No change to domain identifiers or user-visible task/goal/Pomodoro behavior.
- No automatic deletion of a task's historical Pomodoro sessions.
- No migration, export, or import of the local JSON settings repository as part
  of database backups.

Target relationships and delete rules:

| Child column | Parent | Delete rule | Reason |
|---|---|---|---|
| `tasks.goal_id` | `goals.id` | `SET NULL` | Deleting a goal preserves its tasks, matching the verified product behavior. |
| `pomodoro_sessions.goal_id` | `goals.id` | `SET NULL` | Completed history remains valid when its goal is removed. |
| `pomodoro_sessions.task_id` | `tasks.id` | `SET NULL` | Completed history remains valid when its task is removed. |

Required indexes:
- `tasks(goal_id)` and `tasks(scheduled_date)`.
- `pomodoro_sessions(goal_id)`, `pomodoro_sessions(task_id)`, and
  `pomodoro_sessions(started_at)`.
- `calendar_events(scheduled_at)`.

Migration rules:
1. Create a recoverable local backup before altering production persistence.
2. Create the unified schema and enable `PRAGMA foreign_keys = ON`.
3. Copy goals, tasks, sessions, and calendar events in one transaction while
   preserving existing identifiers and timestamps.
4. Convert broken legacy references to `NULL` and record their counts in a
   migration result available to diagnostics; do not invent replacement IDs.
5. Validate row counts, `PRAGMA foreign_key_check`, and key application reads
   before marking migration complete.
6. Keep legacy source files untouched until the unified database is verified;
   after verification, exclude them from normal app reads and new backups.
7. If migration fails, roll back the new database and continue using the
   existing files without losing data.

Checklist:
- [x] Requirement approved.
- [x] Shared Drift database ownership and DAO placement designed.
- [x] Foreign-key and index definitions implemented.
- [x] Migration is atomic, retry-safe, and preserves valid data.
- [ ] Legacy broken links are handled and reported.
- [x] Backup/export and import use only `michifocus.sqlite` after migration.
- [ ] Tests cover each delete rule and migration success/failure behavior.
- [x] Generated Drift code, analyzer, and full test suite pass.
- [ ] Database documentation and ERD are updated.
- [x] Traceability is updated with implementation evidence.

Acceptance criteria:
- [ ] A fresh installation creates only `michifocus.sqlite` for Drift data.
- [ ] Existing installations migrate the four current Drift files without
  losing valid goals, tasks, sessions, or calendar events.
- [ ] SQLite rejects an insert/update that references a non-existent goal or
  task when foreign-key enforcement is enabled.
- [ ] Deleting a goal detaches linked tasks and sessions; it does not delete
  those records.
- [ ] Deleting a task detaches linked completed sessions; it does not delete
  session history.
- [ ] Task, goal, calendar, report, and focus flows keep their current
  observable behavior after migration.
- [x] Backup export produces only the unified Drift database file; import
  restores that same database format.
- [x] `dart run build_runner build --delete-conflicting-outputs`,
  `flutter analyze`, focused migration tests, and `flutter test` pass.

Risks and decisions still required:
- The exact migration marker/version and legacy-file retention period must be
  chosen during implementation.
- A failed or interrupted first launch must remain recoverable without data
  loss.
- Existing backup folders containing four databases need compatible import
  migration coverage.
- A session may retain a goal reference after its task is detached or deleted;
  this is intentional historical context, provided each non-null key remains
  valid.
