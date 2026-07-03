# Tasks requirements

M2 Tasks is approved as a phased feature. All task requirements are part of M2, including Drift persistence, but implementation must happen phase by phase.

### REQ-TASK-001 - Create task

Status: Approved

Objective:
Allow users to create a daily task with a clear title and optional basic details.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] A user can enter a non-empty task title from the Tasks screen.
- [ ] Blank or whitespace-only task titles are rejected with clear user feedback.
- [ ] A successfully created task appears immediately in the task list.
- [ ] Created tasks are saved locally when the Drift persistence phase is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.


### REQ-TASK-002 - Edit task

Status: Approved

Objective:
Allow users to edit an existing task title and basic details.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] A user can open an existing task for editing.
- [ ] Edited values are validated before saving.
- [ ] Saved edits update the visible task list.
- [ ] Edited tasks remain available after app restart when Drift persistence is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.


### REQ-TASK-003 - Complete task

Status: Approved

Objective:
Allow users to mark tasks as completed without deleting task history.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] A user can mark a task as completed.
- [ ] Completed tasks are visually distinguishable from active tasks.
- [ ] Completion status updates task statistics when those statistics exist.
- [ ] Completion status is saved locally when Drift persistence is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.


### REQ-TASK-004 - Delete task

Status: Approved

Objective:
Allow users to delete tasks safely.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] A user can delete a task intentionally.
- [ ] Deletion avoids accidental loss through clear UI affordance or confirmation when appropriate.
- [ ] Deleted tasks are removed from the visible task list.
- [ ] Deleted tasks are removed from local persistence when Drift persistence is implemented.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.


### REQ-TASK-005 - Filter tasks

Status: Approved

Objective:
Allow users to filter task lists by useful task state.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] A user can view all tasks.
- [ ] A user can view active tasks.
- [ ] A user can view completed tasks.
- [ ] Filtering does not mutate task data.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.


### REQ-TASK-006 - Local persistence with Drift

Status: Approved

Objective:
Persist tasks locally with Drift and SQLite so tasks survive app restarts while keeping the app offline-first.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] A Drift tasks table stores task id, title, completion state, creation date, and update date.
- [ ] Task persistence stays in the data layer.
- [ ] Presentation/UI does not access Drift DAOs directly.
- [ ] A repository abstracts Drift from domain and presentation code.
- [ ] `dart run build_runner build --delete-conflicting-outputs` is run after schema/generator changes.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.


### REQ-TASK-007 - Task validation

Status: Approved

Objective:
Validate task input before creation or update so users cannot save empty or invalid task records.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] Task title must be trimmed before validation.
- [ ] Empty task titles are rejected before state or persistence is updated.
- [ ] Validation feedback is visible and understandable to the user.
- [ ] Validation logic is kept outside large widgets when it becomes non-trivial.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.


### REQ-TASK-008 - Task listing

Status: Approved

Objective:
Display tasks clearly and accessibly in the Tasks screen.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [ ] Tasks are shown in a readable list.
- [ ] The list supports an empty state when no tasks exist.
- [ ] Task list styling follows existing theme, typography, and spacing conventions.
- [ ] The list updates reactively when tasks are created, edited, completed, deleted, filtered, or loaded from Drift.

Notes:
- Approved for M2 Tasks phased implementation.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

