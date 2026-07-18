# Productivity V2 requirements

These requirements define the new product direction. All items start as
`Proposed` and must be implemented in milestone order unless the user explicitly
reprioritizes.

### REQ-V2-001 - Goal-first planning model

Status: Verified

Objective:
Create goals from `Home -> Planificacion` by choosing a calendar day and naming
the objective, without asking for a Pomodoro target up front.

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
- [x] The user can create one or more objectives for a selected day/month from planning.
- [x] Goal creation asks for the objective name first, not a Pomodoro count.
- [x] Goals can be renamed and deleted.
- [x] Deleting a goal also removes or detaches its child tasks according to a confirmed local rule. Note: V2-M2 keeps tasks and detaches them from the deleted goal; undo restores the goal links.
- [x] A 3-second undo affordance is shown after deleting goals or tasks.

Verification:
- 2026-07-10: `dart format lib test`, `flutter analyze`, and full `flutter test` passed with 46 tests.
- V2-M1 keeps a hidden default target session for current persistence compatibility; task-based Pomodoro progress replaces this in later V2 milestones.
- 2026-07-11: V2-M2 confirmed the child-task rule for deleted goals: tasks are detached from the deleted goal, not deleted; undo restores affected task links.
- 2026-07-11: `dart format lib test`, `flutter analyze`, focused Tasks/widget tests, and full `flutter test` passed with 52 tests.

### REQ-V2-002 - Task model with quick and planned tasks

Status: Verified

Objective:
Support quick tasks and planned tasks under goals, with clear status and date
assignment.

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
- [x] Tasks may be quick tasks from `Tasks` without date or objective.
- [x] Tasks may be planned tasks assigned from `Home -> Planificacion` to a day and optionally to a goal.
- [x] Quick tasks can later be assigned to a calendar day.
- [x] Each task has one of these statuses: listed, in progress, completed.
- [x] Tasks can be renamed, deleted, moved between quick/planned, and associated or detached from a goal.

Verification:
- 2026-07-11: V2-M2 Slice 1 implemented the unified task model fields, repository/controller APIs, and Drift schema version 2 for task status, optional scheduled date, and optional goal assignment.
- 2026-07-11: `dart run build_runner build --delete-conflicting-outputs` regenerated `tasks_database.g.dart`.
- 2026-07-11: `dart format lib test`, `flutter analyze`, and `flutter test test/features/tasks` passed with 12 focused Tasks tests.
- 2026-07-11: Full `flutter test` passed with 49 tests.
- 2026-07-11: V2-M2 Slice 2 added `Home -> Planificacion` UI for creating planned tasks on the selected day, optionally linking them to a same-day objective, listing them in the agenda, and changing their listed/in-progress/completed status.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 49 tests after the planning UI slice.
- 2026-07-11: V2-M2 Slice 3 added planning UI for moving quick tasks to the selected day, editing task objective association, removing tasks from the selected day, and detaching tasks when their objective is deleted.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 52 tests.
- 2026-07-11: V2-M2 follow-up added direct task deletion from `Home -> Planificacion` and verified that tasks created there remain selected-day planned tasks; date-less quick tasks stay limited to `Tasks`. `dart format lib test`, `flutter analyze`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 54 tests.

### REQ-V2-003 - Start Pomodoro from task

Status: Verified

Objective:
Make each task the main entry point for starting a Pomodoro session.

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
- [x] Each quick or planned task exposes an `Empezar Pomodoro` action.
- [x] Starting a planned task navigates to `Focus` and assigns the current task and goal automatically.
- [x] Starting a quick task navigates to `Focus` without a goal unless the user assigns one.
- [x] The start action supports default 25-minute focus and 5-minute break.
- [x] The start action supports predefined focus/break options before entering `Focus`.

Verification:
- 2026-07-11: V2-M3 added `Empezar Pomodoro` actions to quick and planned tasks, a predefined focus/break picker, task context selection in `PomodoroController`, and Focus UI that shows the active task/objective context.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/pomodoro test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 54 tests.

### REQ-V2-004 - Focus lifecycle and interruption handling

Status: Verified

Objective:
Track task-focused Pomodoro time correctly, including breaks, early completion,
discard, and restart.

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
- [x] `Focus` shows focus time and break time in the same timer experience.
- [x] Break completion uses the system/default alarm or current local feedback mechanism.
- [x] The user can discard an interrupted Pomodoro so its elapsed time does not count.
- [x] The user can restart a task Pomodoro from zero.
- [x] The user can finish a Pomodoro early and only the actual focused time is counted.
- [x] Task status updates to in progress or completed based on the chosen action.

Verification:
- 2026-07-11: V2-M4 Slice 1 added Focus controls for discard, restart, and early finish. Early finish persists only elapsed focus seconds; discard/reset do not save a session.
- 2026-07-11: Starting or restarting an active task Pomodoro marks the task `inProgress`; Focus can mark the active task completed.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/pomodoro`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 57 tests.
- 2026-07-11: V2-M4 Slice 2 added focus/short-break/long-break phases, break countdown display in Focus, automatic break/focus settings, long-break frequency, and break completion feedback through the existing local sound/vibration mechanism.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/pomodoro`, `flutter test test/widget_test.dart`, and full `flutter test` passed with 59 tests.

### REQ-V2-005 - Goal and task progress summaries

Status: Verified

Objective:
Show objective progress based on child tasks and task statuses, including tasks
without goals.

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
- [x] `Goals` shows total objective count.
- [x] `Goals` lists each objective and its child task counts.
- [x] Each objective shows listed, in-progress, and completed tasks as numbers and percentages.
- [x] Tasks without a goal are summarized separately.
- [x] Progress updates automatically when task status or assignment changes.

Verification:
- 2026-07-11: V2-M5 added `TaskStatusSummary` in `TasksController`, reactive all/goal/unassigned task status summaries, task-based objective progress in `Goals`, and unassigned-task summary.
- 2026-07-11: `Home` now uses the same task summaries for listed/in-progress/completed totals and task completion progress.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 60 tests.

### REQ-V2-006 - Home daily and weekly task metrics

Status: Verified

Objective:
Make Home show task status counts, daily statistics, and weekly progress colors.

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
- [x] Home shows total listed, in-progress, and completed task counts.
- [x] Home statistics chart uses day on the x-axis and task counts on the y-axis.
- [x] Weekly progress colors are derived from completed task percentage per day.
- [x] Red represents no tasks or up to 20% completion.
- [x] Yellow represents up to 50% completion.
- [x] Green represents up to 70% completion.
- [x] Strong green represents up to 100% completion.
- [x] A `Terminar dia` action freezes or confirms the day's progress color.

Verification:
- 2026-07-11: V2-M5 added Home listed/in-progress/completed task totals and task completion progress using `TasksController` summaries. Remaining daily chart, weekly colors, thresholds, and `Terminar dia` stay scheduled for V2-M6.
- 2026-07-11: V2-M6 added task progress bands, daily and weekly progress summaries, Home task-count chart by weekday, weekly progress colors, and `Terminar dia`.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 62 tests.

### REQ-V2-007 - Calendar progress heatmap

Status: Verified

Objective:
Show calendar day colors based on task completion progress.

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
- [x] Calendar days use the same red/yellow/green/strong-green progress rules as Home.
- [x] Calendar still shows goals and planned tasks for selected days.
- [x] Ending a day from Home updates the calendar day color.
- [x] Calendar colors can be recalculated from local task state when the day is not locked.

Verification:
- 2026-07-11: V2-M6 colors Calendar day markers from `TasksController.progressByDayForMonth`, preserving goals/tasks/events in the selected-day agenda.
- 2026-07-11: `Terminar dia` marks the current day ended in local task state, and Calendar reads the same ended-day state when rendering month progress.
- 2026-07-11: `dart format lib test`, `flutter analyze`, `flutter test test/features/tasks test/widget_test.dart`, and full `flutter test` passed with 62 tests.

### REQ-V2-008 - PDF reports with calendar, charts, and coaching text

Status: Verified

Objective:
Generate PDF reports for day, week, month, or custom date ranges using task and
Pomodoro data.

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
- [x] The user can export day, week, month, or custom-range reports.
- [x] PDF includes calendar view for the selected range.
- [x] PDF includes charts for listed, in-progress, and completed tasks.
- [x] PDF includes completed Pomodoros, focused minutes, and objective progress where applicable.
- [x] PDF includes encouraging, reflective, or improvement-oriented phrases based on red/yellow/green results.

Verification:
- 2026-07-11: V2-M7 replaced the demo statistics PDF with local task and Pomodoro report data for day, week, month, and custom ranges.
- 2026-07-11: The exported PDF includes selected-range calendar progress, listed/in-progress/completed task bars, completed Pomodoros, focused minutes, task completion progress, and coaching text derived from completion ratio.
- 2026-07-11: `dart format lib test`, `flutter analyze`, and focused Settings/Tasks/Pomodoro/widget tests passed with 45 tests.

### REQ-V2-009 - Monthly performance dashboard

Status: Verified

Objective:
Show monthly task and Pomodoro performance in Home.

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
- [x] Home performance shows total tasks for the month.
- [x] Home performance shows total Pomodoros for the month.
- [x] Home performance shows focused minutes from completed Pomodoros.
- [x] General performance is derived from task completion and completed focus time.

Verification:
- 2026-07-11: V2-M8 updated Home `Rendimiento` to use current-month tasks, completed Pomodoro sessions, focused minutes, and a monthly performance value derived from task completion and completed focus time.
- 2026-07-11: `dart format lib test`, `flutter analyze`, widget test, and full `flutter test` passed with 64 tests.

### REQ-V2-010 - Planning task creation cleanup

Status: Verified

Objective:
Clean up `Home -> Planificacion` so task creation and selected-day task cards
use task-first language, compact actions, and clear task metadata.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Planning task creation says `Crear nueva tarea`, not `Crear nuevo evento`.
- [x] Creating a planned task asks for title and duration, with optional objective selection when objectives exist.
- [x] Planned task duration is stored separately from the task title.
- [x] The task title is saved from the title field and is not replaced by the duration label.
- [x] Selected-day agenda cards show the date above the action buttons.
- [x] Planned task cards keep title, task status, and objective readable, with task actions grouped into one options menu.
- [x] The old `Tarea para X` and `Programar tarea` copy is removed from the planning flow.

Verification:
- 2026-07-14: V2-M9 removed event/programming copy from the planning creation flow, moved selected-day actions below the date, grouped planned-task actions into one options menu, and persisted planned task duration as `duration_minutes`.
- 2026-07-14: `dart run build_runner build --delete-conflicting-outputs` regenerated Drift code for Tasks schema version 3.
- 2026-07-14: `dart format lib test` passed.
- 2026-07-14: `flutter analyze` passed.
- 2026-07-14: `flutter test test/features/tasks test/widget_test.dart` passed.
- 2026-07-14: Full `flutter test` passed with 64 tests.

### REQ-V2-011 - Task focus-minute progress

Status: Verified

Objective:
Show planned task progress from completed Pomodoro focus minutes against the
task's estimated duration.

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
- [x] Completed Pomodoro sessions can store the active task id.
- [x] Starting Pomodoro from a planned task keeps the session associated with that task.
- [x] Planning task cards show focused minutes over estimated task duration, such as `25/120 min`.
- [x] Planning task cards show the equivalent completion percentage and progress bar.
- [x] The Pomodoro session duration remains separate from the task estimated duration.

Verification:
- 2026-07-14: V2-M10 added nullable `task_id` to persisted Pomodoro sessions and stores the selected task id when focus completes.
- 2026-07-14: Calendar planning derives focused seconds per task from loaded Pomodoro sessions and shows `focused/estimated` progress on planned task cards.
- 2026-07-14: `dart run build_runner build --delete-conflicting-outputs` regenerated Drift code for Pomodoro sessions schema version 3.
- 2026-07-14: `dart format lib test` passed.
- 2026-07-14: `flutter analyze` passed.
- 2026-07-14: `flutter test test/features/pomodoro test/features/tasks test/widget_test.dart` passed.
- 2026-07-14: Full `flutter test` passed with 65 tests.
