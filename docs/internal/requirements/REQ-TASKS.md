# Tasks requirements

M2 Tasks is approved as a phased feature. All task requirements are part of M2, including Drift persistence, but implementation must happen phase by phase.

### REQ-TASK-001 - Create task

Status: Verified

Objective:
Allow users to create a daily task with a clear title and optional basic details.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] A user can enter a non-empty task title from the Tasks screen.
- [x] Blank or whitespace-only task titles are rejected with clear user feedback.
- [x] A successfully created task appears immediately in the task list.
- [x] Created tasks are saved locally when the Drift persistence phase is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- In-memory creation verified with `flutter analyze` and targeted TasksController tests.
- Drift persistence verified with repository tests using a local SQLite database file.


### REQ-TASK-002 - Edit task

Status: Verified

Objective:
Allow users to edit an existing task title and basic details.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] A user can open an existing task for editing.
- [x] Edited values are validated before saving.
- [x] Saved edits update the visible task list.
- [x] Edited tasks remain available after app restart when Drift persistence is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- In-memory editing verified with `flutter analyze` and targeted TasksController tests.
- Drift persistence verified through repository boundary tests.


### REQ-TASK-003 - Complete task

Status: Verified

Objective:
Allow users to mark tasks as completed without deleting task history.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] A user can mark a task as completed.
- [x] Completed tasks are visually distinguishable from active tasks.
- [x] Completion status updates task statistics when those statistics exist.
- [x] Completion status is saved locally when Drift persistence is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- In-memory completion verified with `flutter analyze` and targeted TasksController tests.
- No task statistics module exists yet, so there is no current statistics state to update.
- Drift persistence verified through repository boundary tests.


### REQ-TASK-004 - Delete task

Status: Verified

Objective:
Allow users to delete tasks safely.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] A user can delete a task intentionally.
- [x] Deletion avoids accidental loss through clear UI affordance or confirmation when appropriate.
- [x] Deleted tasks are removed from the visible task list.
- [x] Deleted tasks are removed from local persistence when Drift persistence is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- In-memory deletion verified with `flutter analyze` and targeted TasksController tests.
- Drift persistence verified through repository boundary tests.


### REQ-TASK-005 - Filter tasks

Status: Verified

Objective:
Allow users to filter task lists by useful task state.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] A user can view all tasks.
- [x] A user can view active tasks.
- [x] A user can view completed tasks.
- [x] Filtering does not mutate task data.

Notes:
- Approved for M2 Tasks phased implementation.
- In-memory filters verified with `flutter analyze` and targeted TasksController tests.
- Filters operate on tasks loaded from the repository-backed controller state.


### REQ-TASK-006 - Local persistence with Drift

Status: Verified

Objective:
Persist tasks locally with Drift and SQLite so tasks survive app restarts while keeping the app offline-first.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] A Drift tasks table stores task id, title, completion state, creation date, and update date.
- [x] Task persistence stays in the data layer.
- [x] Presentation/UI does not access Drift DAOs directly.
- [x] A repository abstracts Drift from domain and presentation code.
- [x] `dart run build_runner build --delete-conflicting-outputs` is run after schema/generator changes.

Notes:
- Approved for M2 Tasks phased implementation.
- Drift code generation completed and `tasks_database.g.dart` was generated.
- Persistence verified with repository tests using a local SQLite database file.


### REQ-TASK-007 - Task validation

Status: Verified

Objective:
Validate task input before creation or update so users cannot save empty or invalid task records.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Task title must be trimmed before validation.
- [x] Empty task titles are rejected before state or persistence is updated.
- [x] Validation feedback is visible and understandable to the user.
- [x] Validation logic is kept outside large widgets when it becomes non-trivial.

Notes:
- Approved for M2 Tasks phased implementation.
- Create and edit validation verified with `flutter analyze` and targeted TasksController tests.
- Validated create/edit flows now persist through the repository when input is valid.


### REQ-TASK-008 - Task listing

Status: Verified

Objective:
Display tasks clearly and accessibly in the Tasks screen.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Tasks are shown in a readable list.
- [x] The list supports an empty state when no tasks exist.
- [x] Task list styling follows existing theme, typography, and spacing conventions.
- [x] The list updates reactively when tasks are created, edited, completed, deleted, filtered, or loaded from Drift.

Notes:
- Approved for M2 Tasks phased implementation.
- Reactive updates are implemented for create, edit, complete, delete, filter, and initial repository load.
- Drift loading verified through `TasksController.loadTasks` and repository-backed startup wiring.

