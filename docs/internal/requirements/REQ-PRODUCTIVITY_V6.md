# Productivity V6 requirements

Status:
Implemented on 2026-07-29. Automated verification passed; the remaining
Android theme/typography/state visual matrix is tracked before Verified.

## Scope

V6-M0 connects planned task duration with an explicit, recoverable Pomodoro
execution plan. Task duration remains net focus time. Breaks add elapsed clock
time but never task progress.

### REQ-V6-001 - Editable task duration and automatic task states

Status: Implemented

Objective:
Allow planned task duration to be edited safely and keep Pending, In Progress,
and Completed synchronized with task focus execution.

Checklist:
- [x] Requirement approved
- [x] UI planned
- [x] State/domain responsibilities planned
- [x] Data/persistence impact reviewed
- [x] Implementation completed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability verified

Acceptance criteria:
- [x] Home -> Planning task editing can update objective and duration atomically.
- [x] Existing imported durations outside current presets remain editable.
- [x] Edit-dialog actions occupy the available width and remain usable with
      large text and small screens.
- [x] Starting the first task focus changes Pending to In Progress.
- [x] Pausing, resting, leaving the page, or stopping for now keeps the task In
      Progress.
- [x] Reaching the planned focus minutes changes the task to Completed
      automatically.
- [x] Finishing early does not complete a task whose planned focus is pending.
- [x] A completed task can be explicitly reopened or extended without losing
      focus history.

### REQ-V6-002 - Minute-based block planning and recommendation

Status: Implemented

Objective:
Create predictable focus/break blocks from the task's remaining whole minutes
without extending its planned focus duration.

Checklist:
- [x] Requirement approved
- [x] UI planned
- [x] State/domain responsibilities planned
- [x] Data/persistence impact reviewed
- [x] Implementation completed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability verified

Acceptance criteria:
- [x] Recommendation input uses
      `floor(total focused seconds / 60)` after summing all task sessions.
- [x] Remaining minutes are `max(0, planned minutes - completed whole minutes)`.
- [x] Block count is `ceil(remaining minutes / configured focus minutes)`.
- [x] The final focus block is shortened to remaining minutes and never exceeds
      the task estimate.
- [x] Breaks never add task progress.
- [x] Each predefined option shows projected blocks, final-block adjustment,
      break time, and approximate elapsed time.
- [x] Exactly one predefined option is labelled `Recommended` using, in order:
      least break overhead, exact division, avoidance of a very short final
      block, then moderate focus duration.
- [x] Custom focus/break values show the same live mathematical projection.

### REQ-V6-003 - Continuous task plan and single-block alternatives

Status: Implemented

Objective:
Make Continue resume or execute the remaining task plan while preserving a
clear single-Pomodoro alternative.

Checklist:
- [x] Requirement approved
- [x] UI planned
- [x] State/domain responsibilities planned
- [x] Data/persistence impact reviewed
- [x] Implementation completed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability verified

Acceptance criteria:
- [x] A new task exposes Start; a partially focused task exposes Continue with
      remaining whole minutes.
- [x] Continue resumes an active partial focus or break at its exact remaining
      second.
- [x] Without a partial phase, Continue uses the recommended cadence and
      automatically sequences focus, break, and next focus until completion.
- [x] Focus UI shows `Block X of N`; N represents the current execution plan.
- [x] Selecting a predefined or custom single Pomodoro executes one focus block
      and its associated break, then stops with the task In Progress.
- [x] A custom cadence can also be applied to the continuous remaining plan.
- [x] The end of the final focus block completes the task and does not force a
      trailing break.
- [x] Stop for now saves actual focus, releases the timer, and keeps unfinished
      task progress.

### REQ-V6-004 - Exclusive and recoverable Pomodoro runtime

Status: Implemented

Objective:
Guarantee one active Pomodoro owner and restore it after navigation,
backgrounding, or Android process recreation.

Checklist:
- [x] Requirement approved
- [x] UI planned
- [x] State/domain responsibilities planned
- [x] Data/persistence migration planned
- [x] Implementation completed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability verified

Acceptance criteria:
- [x] Only one task or unassigned Pomodoro can own the timer at a time.
- [x] Running, paused, and break phases all retain ownership.
- [x] Starting another task is blocked with actions to return, stop and switch,
      or cancel; no task is switched silently.
- [x] Stop and switch records actual focus before releasing ownership.
- [x] Runtime persistence stores owner, phase, running state, timestamps,
      remaining seconds, cadence, plan mode, block position, and task estimate
      snapshot.
- [x] App restart restores the same owner, phase, cadence, block position, and
      remaining time.
- [x] Clock reconciliation advances elapsed background time through focus and
      break boundaries without double-counting.
- [x] Unified database export/import includes runtime state and validates the
      migrated database before replacement.

### REQ-V6-005 - Task-plan progress presentation

Status: Implemented

Objective:
Show the distinction between current phase, net task progress, and elapsed plan
time clearly in Planning and Pomodoro.

Checklist:
- [x] Requirement approved
- [x] UI planned
- [x] State/domain responsibilities planned
- [x] Data/persistence impact reviewed
- [x] Implementation completed
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability verified

Acceptance criteria:
- [x] The Pomodoro ring makes one traversal over total task focus progress.
- [x] The center timer shows the current focus or break countdown.
- [x] The information button below the ring shows current block, total blocks,
      focused/planned minutes, percentage, next break, and projected elapsed
      time without crowding the countdown.
- [x] Continue and Resume behavior reflects whether a saved partial phase exists.
- [x] Planning shows Pending, In Progress, or Completed consistently with task
      state and keeps the existing task progress bar.
- [x] Controls and dialog actions remain responsive under supported font scales.
- [ ] Android visual inspection covers light/dark themes, at least two
      typography presets, small-screen layout, and active/paused/break states.

## Non-goals

- Break minutes do not reduce task focus minutes.
- Multiple concurrent Pomodoro timers are not supported.
- Focus history is not duplicated into a mutable completed-minutes task column.
- Selecting a task cadence does not silently overwrite global timer settings.
