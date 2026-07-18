# Goals requirements

Statuses remain below `Verified` until implementation and verification evidence exist.

### REQ-GOAL-001 - Create goal

Status: Verified

Objective:
Allow users to create productivity goals.

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
- [x] The user can create a goal with a clear title from the Goals feature.
- [x] The initial implementation may use local UI/domain state only; no backend dependency is introduced.
- [x] Required checks before `Verified`: `dart format lib test`, `flutter analyze`, and `flutter test` when behavior or tests are affected.

Notes:
- Approved for the initial M3 slice on 2026-07-04.
- Implemented with in-memory `GoalsController`, `ProductivityGoal`, and `GoalsPage`.
- Verification evidence: `dart format lib test`, `flutter analyze`, and full `flutter test` passed.
- Local persistence is implemented and verified through `REQ-GOAL-004`.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-GOAL-002 - Track goal progress

Status: Verified

Objective:
Show measurable progress toward goals.

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
- [x] The Goals feature can show measurable progress for each goal.
- [x] The initial implementation keeps progress state offline-first and within project architecture boundaries.
- [x] Required checks before `Verified`: `dart format lib test`, `flutter analyze`, and `flutter test` when behavior or tests are affected.

Notes:
- Approved for the initial M3 slice on 2026-07-04.
- Implemented with per-goal pomodoro targets, increment/decrement controls, and computed summary progress.
- Verification evidence: `dart format lib test`, `flutter analyze`, and full `flutter test` passed.
- Local progress persistence is implemented and verified through `REQ-GOAL-004`.
- Pomodoro session links are now implemented and verified through `REQ-GOAL-003`.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-GOAL-003 - Goals with target dates and Pomodoro links

Status: Verified

Objective:
Allow users to define goals for a target date and relate completed Pomodoros to
the goal they are trying to reach.

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
- [x] A goal can have an optional target date that represents when the user wants to reach it.
- [x] The user can choose the current goal/objective for a date from the planning flow.
- [x] Completed Pomodoro sessions can be associated with a goal so progress reflects real focus work.
- [x] The implementation remains offline-first and keeps Pomodoro, Calendar, and Goals boundaries explicit.
- [x] Required checks before `Verified`: Drift generation if schema changes, `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved by user on 2026-07-10 for phased implementation.
- Implemented target dates with `ProductivityGoal.targetDate`, a nullable
  Drift column, repository/controller support, and calendar visibility.
- Pomodoro now exposes an active-goal selector, stores the selected `goalId`
  on completed sessions, and increments the related goal progress when a
  session finishes.
- Verification evidence: build runner generation, `dart format lib test`,
  `flutter analyze`, and full `flutter test` passed with 44 total tests after
  moving objective creation to Calendar and keeping Pomodoro assignment scoped
  to scheduled goals.
- Product direction updated on 2026-07-10: goals are date-oriented objectives,
  not just generic counters.
- This requirement replaces the vague "associate later" scope with target-date
  goals and Pomodoro progress links.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-GOAL-005 - Edit and delete goals

Status: Verified

Objective:
Allow users to change or remove a goal after creating it.

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
- [x] The user can edit a goal title, target Pomodoro count, and target date.
- [x] The user can delete a goal with a confirmation step.
- [x] Editing or deleting a goal updates persisted local state and related planning views.
- [x] Existing completed Pomodoro history is not deleted accidentally when a goal is deleted.
- [x] Required checks before `Verified`: Drift generation if schema changes, `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved by user on 2026-07-10 for the goal deadline planning slice.
- Goal deletion already exists in repository-backed state, but this requirement
  tracks the full user-facing edit/delete workflow for the new goal planning model.
- Verified on 2026-07-10 with goal edit dialog, target-date selector, delete
  confirmation, repository update support, Drift migration, and full test
  suite passing with 40 tests.

### REQ-GOAL-004 - Local persistence later

Status: Verified

Objective:
Persist goals locally when approved.

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
- [x] Goals are stored in a local Drift/SQLite table.
- [x] Goal creation, progress changes, deletion, and reloads go through a domain repository contract.
- [x] Required checks passed before moving to `Verified`: build runner generation, `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved and implemented on 2026-07-04.
- Implemented with `GoalsDatabase`, `GoalsDao`, `DriftGoalsRepository`, and repository-backed `GoalsController`.
- Verification evidence: build runner generated `goals_database.g.dart`; `flutter analyze` passed; full `flutter test` passed with 19 total tests.
- Keep incomplete work as [ ].
- Only mark [x] after verification.
