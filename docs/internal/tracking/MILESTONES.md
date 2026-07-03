# Milestones

## M0 - Documentation and Architecture Baseline

Status: Verified

Objective:
Create the SDD, architecture, workflow, agents, skills, and client documentation baseline.

Deliverables:
- [x] SDD index created
- [x] Requirement files created
- [x] Architecture docs created
- [x] Technical docs created
- [x] Codex orchestrator, agents, and skills created
- [x] Client doc placeholders created

Quality gates:
- [x] Documentation baseline exists and is navigable.
- [x] Skill frontmatter is valid for project skills.
- [x] Client docs do not include internal Codex orchestration details.
- [x] Traceability matrix contains initial requirement rows.

Required docs updated:
- [x] `docs/internal/SDD.md`
- [x] `docs/internal/requirements/`
- [x] `docs/internal/architecture/`
- [x] `docs/internal/technical/`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/workflow/`
- [x] `docs/client/`
- [x] `.codex/`

Required checks:
- [x] Verified required M0 files exist.
- [x] Verified 53 requirement IDs exist.
- [x] Verified 53 traceability rows exist.
- [x] Verified no app implementation files are required for M0.

Verification evidence:
- M0 is docs-only.
- Validation confirmed the requested SDD/Codex documentation baseline exists.
- No `lib/`, Gradle, dependency, or runtime behavior changes are part of M0.

## M1 - UI Foundation

Status: Proposed

Objective:
Stabilize theme, typography, responsive UI, navigation visual state, and Atomic Design usage.

Deliverables:
- [ ] Theme rules reviewed
- [ ] Navigation state rules verified
- [ ] Shared UI patterns documented

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M2 - Tasks Feature

Status: In Progress

Objective:
Deliver the complete Tasks feature in phases: create, list, validate, edit, complete, delete, filter, and persist tasks locally with Drift/SQLite.

Approval status:
- [x] Milestone M2 approved for phased implementation.
- [x] `REQ-TASK-001` through `REQ-TASK-008` approved.
- [x] Drift persistence approved as part of M2 through `REQ-TASK-006`.

Phases:
- [x] Phase 0 - Requirements approved for full M2 scope.
- [ ] Phase 1 - In-memory task creation, validation, and listing.
- [ ] Phase 2 - Edit, complete, delete, and filter tasks in state.
- [ ] Phase 3 - Drift persistence: tasks table, DAO, repository, generated code, and local save/load.
- [ ] Phase 4 - Verification, documentation updates, and traceability closure.

Deliverables:
- [x] Task requirements approved: `REQ-TASK-001` through `REQ-TASK-008`
- [ ] Task UI implemented
- [ ] Task state implemented
- [ ] Task domain/data boundaries implemented
- [ ] Task persistence implemented with Drift

Quality gates:
- [x] Relevant M2 requirements are approved before implementation.
- [x] Traceability matrix is updated for approved M2 requirements.
- [ ] UI does not access Drift DAOs directly.
- [ ] Required checks pass before marking implemented or verified.

Required docs to update:
- [x] `docs/internal/requirements/REQ-TASKS.md`
- [x] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [x] `docs/internal/technical/DATABASE.md`
- [ ] Relevant client documentation after implementation

Required checks:
- [ ] Run `dart run build_runner build --delete-conflicting-outputs` after Drift schema/generator changes.
- [ ] Run `flutter analyze` after implementation.
- [ ] Run `flutter test` if tests are added or behavior is covered.

Scope notes:
- M2 now includes persistence with Drift.
- Implementation still happens phase by phase to avoid mixing UI, state, and database work in one uncontrolled change.

## M3 - Goals Feature

Status: Proposed

Objective:
Deliver goal creation, progress tracking, and later associations/persistence.

Deliverables:
- [ ] Goal requirements approved
- [ ] Goal UI implemented
- [ ] Goal progress model implemented

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M4 - Pomodoro Sessions Feature

Status: Proposed

Objective:
Deliver session start, pause, reset, completion, duration preferences, and later history.

Deliverables:
- [ ] Pomodoro requirements approved
- [ ] Timer behavior verified
- [ ] Session history planned or implemented

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M5 - Calendar Planning Feature

Status: Proposed

Objective:
Deliver local calendar planning and later event/task/session associations.

Deliverables:
- [ ] Calendar requirements approved
- [ ] Calendar view implemented
- [ ] Event persistence planned or implemented

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M6 - Settings Feature

Status: Proposed

Objective:
Deliver local settings for timer, theme, and notification preferences.

Deliverables:
- [ ] Settings requirements approved
- [ ] Local preferences implemented
- [ ] Settings checks passed

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M7 - Local Persistence with Drift

Status: Proposed

Objective:
Introduce approved Drift schema, DAOs, repositories, migrations, and generated code.

Deliverables:
- [ ] Schema approved
- [ ] DAOs implemented
- [ ] Repositories implemented
- [ ] Build runner completed

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M8 - Reports

Status: Proposed

Objective:
Deliver verified summaries and chart/report views based on real local data.

Deliverables:
- [ ] Report requirements approved
- [ ] Source data verified
- [ ] Charts/reports implemented

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M9 - PDF Export

Status: Proposed

Objective:
Deliver local PDF export with clear data selection and generated file handling.

Deliverables:
- [ ] PDF requirements approved
- [ ] Export generation implemented
- [ ] File handling verified

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.

## M10 - Client Delivery Documentation

Status: Proposed

Objective:
Complete client-facing manuals, quick guide, changelog, technical manual, and final delivery doc.

Deliverables:
- [ ] User manual completed
- [ ] Installation manual completed
- [ ] Technical manual completed
- [ ] Final delivery doc completed

Quality gates:
- [ ] Relevant requirements are approved before implementation.
- [ ] Required checks pass before marking verified.
- [ ] Traceability matrix is updated.

Required docs to update:
- [ ] Relevant `docs/internal/requirements/REQ-*.md` file
- [ ] `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- [ ] Relevant technical or client documentation

Required checks:
- [ ] Run the checks listed in `docs/internal/technical/QUALITY_GATES.md` for this task type.
