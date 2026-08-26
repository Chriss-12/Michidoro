# Productivity V12 requirements

## Summary

Productivity V12 proposes a visual weekly schedule for routine activities and
dated objectives, persistent custom routine colors and validity dates, and a
separate `Notas rápidas` checklist stored in the unified local database.

Status: Proposed on 2026-08-26. The user authorized creating the milestone;
implementation remains unapproved and must not begin while these requirements
remain `Proposed`.

## Product decisions

| Area | Contract |
|---|---|
| Weekly planning | `Objetivos/Planificación` adds `Mes | Semana`; no sixth bottom-navigation destination. |
| Routine identity | One user-selected custom color belongs to the whole routine and is reused by all its activities. |
| Routine validity | New routines require a local start date and may have a nullable local end date. |
| Historical integrity | Date or color edits affect future projections without deleting or rewriting prior runs, tasks, or statistics. |
| Objective summary | Dated objectives appear above the hourly grid with completed/total task progress. |
| Routine summary | Individual activity blocks show their own state; routine-level summaries may show completed/total activities. |
| Quick notes | Each quick note is one checkbox item with text, completion, custom color, optional local date, optional priority, and manual order. |
| Separation | Quick notes have no duration, Pomodoro, goal, in-progress state, or productivity-statistics effect. |
| Persistence | Routine additions and quick notes live in `michifocus.sqlite` and participate in backup, import, reset, and V11 synchronization. |

## Non-goals

- Do not replace the existing task, goal, routine, calendar-event, or Pomodoro
  models.
- Do not turn quick notes into planned tasks or include them in productivity
  percentages, reports, streaks, or focus totals.
- Do not add a new bottom-navigation destination.
- Do not use color alone to communicate state or priority.
- Do not delete or recolor historical routine runs when a template changes.
- Do not add a backend or internet dependency.

## REQ-V12-001 - Persistent custom routine color and validity range

Status: Proposed

Objective:
Persist a user-selected routine color and an editable local validity range while
preserving existing routine data and immutable execution history.

Checklist:
- [ ] Requirement approved for implementation.
- [ ] Domain and local-date semantics approved.
- [ ] Forward-only Drift migration implemented.
- [ ] Repository, import, backup, reset, and sync boundaries updated.
- [ ] Historical snapshot behavior implemented.
- [ ] Checks passed and traceability updated.

Acceptance criteria:
- [ ] A new routine stores one custom opaque color value in SQLite.
- [ ] Existing `color_key` data remains readable and is not removed or
      repurposed; a custom value takes precedence when present.
- [ ] New routines require a canonical local start date.
- [ ] The local end date is nullable and can be added, changed, or cleared.
- [ ] The start date cannot be later than a non-null end date.
- [ ] Existing routines migrate without losing recurrence, items, links,
      reminders, lifecycle state, runs, or statistics.
- [ ] Changing color or validity updates future projections and reminders only;
      prior run and item-run history remains unchanged.
- [ ] Historical snapshots retain the routine color that applied when the run
      was created when that distinction is reportable or visible.
- [ ] A routine past its end date is treated as naturally ended, separately
      from paused and archived lifecycle states, and can become current again if
      its end date is extended or cleared.

## REQ-V12-002 - Routine editor color and validity experience

Status: Proposed

Objective:
Expose custom color, start date, and optional end date in routine creation,
editing, review, and validation without making the existing editor fragile.

Checklist:
- [ ] Requirement approved for implementation.
- [ ] Responsive bilingual UI planned.
- [ ] Theme and accessibility behavior approved.
- [ ] Creation and edit flows implemented.
- [ ] Widget and physical Android checks passed.
- [ ] Documentation and traceability updated.

Acceptance criteria:
- [ ] `Información` exposes icon and a broad custom-color selector with a clear
      preview.
- [ ] `Repetición y vigencia` exposes weekdays, start date, and either an end
      date or `Sin fecha de finalización`.
- [ ] `Revisión` summarizes color, validity, weekdays, activities, total time,
      and existing overlap warnings before save.
- [ ] Editing supports finite-to-indefinite and indefinite-to-finite changes.
- [ ] Invalid date ranges cannot be saved and receive understandable feedback.
- [ ] User colors retain their identity in light and dark themes while text,
      borders, and icons keep accessible contrast.
- [ ] Activity status remains visible through icon, label, and intensity; color
      is not the only state signal.
- [ ] Existing dirty-draft protection, keyboard behavior, large text, Spanish,
      English, and supported portrait widths remain usable.

## REQ-V12-003 - Responsive weekly schedule

Status: Proposed

Objective:
Add a school-timetable-style weekly view that makes routine activities and dated
objectives easier to understand than a single vertical agenda.

Checklist:
- [ ] Requirement approved for implementation.
- [ ] Projection and overlap contract approved.
- [ ] Responsive layout implemented.
- [ ] Existing planning actions integrated.
- [ ] Widget, performance, and physical checks passed.
- [ ] Documentation and traceability updated.

Acceptance criteria:
- [ ] `Objetivos/Planificación` exposes `Mes | Semana` without adding a bottom
      navigation destination.
- [ ] The weekly view supports previous, current, and next week navigation.
- [ ] Routine activities appear as time-positioned blocks using the routine's
      persisted custom color, title, time range, and activity state.
- [ ] Only occurrences inside the routine's weekday recurrence and validity
      range are projected.
- [ ] Dated objectives appear in an all-day area with completed/total child-task
      progress and a compact progress indicator.
- [ ] A routine-level summary may show completed/total activities, while an
      individual activity block does not show a redundant task count.
- [ ] Tapping a routine activity reuses the existing routine inspection and
      execution entry point; objective actions preserve current behavior.
- [ ] Overlaps remain visible and understandable without silently moving blocks.
- [ ] Phone layouts remain readable through bounded horizontal navigation or
      equivalent responsive behavior; larger screens may show more days at once.
- [ ] Color is never the only distinction between routines or states.

## REQ-V12-004 - Persistent quick-note checklist

Status: Proposed

Objective:
Add an offline-first `Notas rápidas` checklist for lightweight items that only
need to be marked pending or completed.

Checklist:
- [ ] Requirement approved for implementation.
- [ ] Quick-note domain and repository contract approved.
- [ ] Drift table, DAO, repository, and controller implemented.
- [ ] Backup, import, reset, and synchronization implemented.
- [ ] Focused persistence and migration checks passed.
- [ ] Documentation and traceability updated.

Acceptance criteria:
- [ ] Each quick note stores a stable ID, trimmed non-empty text, completion
      state, custom opaque color, nullable canonical local date, nullable
      priority, manual position, creation time, and update time.
- [ ] Quick notes are stored in a dedicated unified-database table and are not
      rows in `tasks`.
- [ ] A note can be created without a date and can later receive, change, or
      clear its date.
- [ ] Checking or unchecking a note persists immediately and survives restart.
- [ ] Reordering persists deterministically without corrupting other notes.
- [ ] Quick notes participate in unified backup, staged import validation,
      protected reset, encrypted V11 exchange, conflict handling, and recovery.
- [ ] Quick notes never create Pomodoro sessions, routine runs, task-completion
      events, or productivity-report data.

## REQ-V12-005 - Quick-note colors, priority, sorting, and planning visibility

Status: Proposed

Objective:
Make quick notes fast to scan and organize while keeping custom color, priority,
completion, and date as independent concepts.

Checklist:
- [ ] Requirement approved for implementation.
- [ ] Placement and interaction design approved.
- [ ] Colors, priority, and sorting implemented.
- [ ] Day-planning integration implemented.
- [ ] Responsive and accessibility checks passed.
- [ ] Documentation and traceability updated.

Acceptance criteria:
- [ ] `Tareas` exposes a clear `Tareas | Rutinas | Notas rápidas` selector or an
      equivalent in-feature control without changing bottom navigation.
- [ ] A quick note renders as a native checkbox item equivalent to Markdown
      `- [ ]` and `- [x]`; literal Markdown parsing is not required.
- [ ] Completion shows a checked state and readable completed treatment, and is
      reversible.
- [ ] Each note can use a broad user-selected custom color stored in SQLite.
- [ ] Priority is optional and explicit: high, medium, low, or none; arbitrary
      note color never implies priority.
- [ ] Sorting supports manual order, priority, date, recent creation, and color.
- [ ] Undated notes remain discoverable in a general list.
- [ ] Dated notes appear in the selected-day planning agenda as a compact
      checklist, not as duration-based hourly blocks.
- [ ] Spanish, English, themes, large text, keyboard, semantics, and supported
      portrait widths remain usable.

## REQ-V12-006 - Compatibility, synchronization, and release verification

Status: Proposed

Objective:
Prove that the V12 schema, projections, custom colors, validity changes, and
quick notes remain recoverable and convergent across the current product.

Checklist:
- [ ] Requirement approved for implementation.
- [ ] Compatibility and verification matrix approved.
- [ ] Automated migration and convergence coverage implemented.
- [ ] Full application regression checks passed.
- [ ] Physical Android verification passed.
- [ ] Internal and client documentation updated.

Acceptance criteria:
- [ ] Migrations from every supported schema preserve representative existing
      tasks, goals, events, sessions, runtime, routines, history, and sync data.
- [ ] Import/export round trips preserve routine custom colors, validity dates,
      historical color snapshots, and all quick-note fields and order.
- [ ] Two-device operations converge for routine color/date edits and quick-note
      create, edit, complete, recolor, redate, reprioritize, reorder, and delete.
- [ ] Concurrent edits remain visible through the established conflict model and
      never silently overwrite unrelated fields.
- [ ] Weekly projection tests cover range boundaries, indefinite routines,
      weekday recurrence, overlaps, local midnight, and date edits.
- [ ] Formatting, Drift generation, clean analysis, focused tests, full suite,
      release build, and representative physical Android checks pass.
- [ ] Documentation describes the distinction between tasks, routines,
      objectives, and quick notes without exposing internal orchestration.

## Dependencies and sequencing

- V12 implementation starts only after explicit requirement approval.
- Complete or explicitly defer the V11 synchronization gates affected by new
  mutable routine fields and the new quick-note entity before V12 data exchange
  is considered stable.
- Schema and sync contracts precede user-facing creation flows.
- The weekly view consumes bounded projections; it must not materialize
  unlimited future task rows.
