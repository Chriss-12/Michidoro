# Database

Use `drift` with SQLite for local persistence when needed. Keep schema and DAO concerns in data layers and map data models to domain models.

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
| `createdAt` | Local creation timestamp. |
| `updatedAt` | Local update timestamp. |

Implemented table:

| Drift table | SQLite table | Columns |
|---|---|---|
| `TaskRecords` | `tasks` | `id`, `title`, `is_completed`, `created_at`, `updated_at` |

Implemented data boundary:

- `TasksDatabase` owns the Drift database and schema version.
- `TasksDao` owns task SQL operations.
- `DriftTasksRepository` maps Drift records to domain `Task` entities.
- `TasksController` depends on the `TasksRepository` contract, not Drift.
- `get_it` wiring lives in `lib/app/di/service_locator.dart`.

Boundary rules:

- Drift table and DAO stay in `lib/features/tasks/data/`.
- Repository maps Drift rows to domain-friendly task models.
- Presentation/controllers use repository/domain APIs, not DAOs directly.
- Schema/generator changes require `dart run build_runner build --delete-conflicting-outputs`.

Verification evidence:

- `dart run build_runner build --delete-conflicting-outputs` generated `tasks_database.g.dart`.
- `flutter analyze` passed after generated code changes.
- `flutter test test/features/tasks` passed, including a local SQLite file persistence test.

