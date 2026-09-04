# Productivity V12 requirements

## Summary

Productivity V12 proposes a visual weekly schedule for routine activities and
dated objectives, persistent custom routine colors and validity dates, and a
separate `Notas rápidas` checklist stored in the unified local database.

Status: Approved for implementation on 2026-08-26. REQ-V12-001 is verified,
REQ-V12-002 is in progress pending physical Android inspection, and the
remaining requirements stay approved for their milestone sequence.

## Product decisions

| Area | Contract |
|---|---|
| Weekly planning | `Objetivos/Planificación` adds `Mes | Semana`; Semana offers a phone-first compact list and an optional school grid, with no sixth bottom-navigation destination. |
| Printable week | The selected week can be exported offline as a US Letter landscape PDF with goals, routine activities, time ranges, colors, and non-color state signals. |
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

Status: Verified

Objective:
Persist a user-selected routine color and an editable local validity range while
preserving existing routine data and immutable execution history.

Checklist:
- [x] Requirement approved for implementation.
- [x] Domain and local-date semantics approved.
- [x] Forward-only Drift migration implemented.
- [x] Repository, import, backup, reset, and sync boundaries updated.
- [x] Historical snapshot behavior implemented.
- [x] Checks passed and traceability updated.

Acceptance criteria:
- [x] A new routine stores one custom opaque color value in SQLite.
- [x] Existing `color_key` data remains readable and is not removed or
      repurposed; a custom value takes precedence when present.
- [x] New routines require a canonical local start date.
- [x] The local end date is nullable and can be added, changed, or cleared.
- [x] The start date cannot be later than a non-null end date.
- [x] Existing routines migrate without losing recurrence, items, links,
      reminders, lifecycle state, runs, or statistics.
- [x] Changing color or validity updates future projections and reminders only;
      prior run and item-run history remains unchanged.
- [x] Historical snapshots retain the routine color that applied when the run
      was created when that distinction is reportable or visible.
- [x] A routine past its end date is treated as naturally ended, separately
      from paused and archived lifecycle states, and can become current again if
      its end date is extended or cleared.

## REQ-V12-002 - Routine editor color and validity experience

Status: In Progress

Objective:
Expose custom color, start date, and optional end date in routine creation,
editing, review, and validation without making the existing editor fragile.

Checklist:
- [x] Requirement approved for implementation.
- [x] Responsive bilingual UI planned.
- [x] Theme and accessibility behavior approved.
- [x] Creation and edit flows implemented.
- [ ] Widget checks passed; physical Android inspection remains blocked by the
      local Gradle loopback failure.
- [x] Documentation and traceability updated.

Acceptance criteria:
- [x] `Información` exposes icon and a broad custom-color selector with a clear
      preview.
- [x] `Repetición y vigencia` exposes weekdays, start date, and either an end
      date or `Sin fecha de finalización`.
- [x] `Revisión` summarizes color, validity, weekdays, activities, total time,
      and existing overlap warnings before save.
- [x] Editing supports finite-to-indefinite and indefinite-to-finite changes.
- [x] Invalid date ranges cannot be saved and receive understandable feedback.
- [x] User colors retain their identity in light and dark themes while text,
      borders, and icons keep accessible contrast.
- [x] Activity status remains visible through icon, label, and intensity; color
      is not the only state signal.
- [x] Existing dirty-draft protection, keyboard behavior, large text, Spanish,
      English, and supported portrait widths remain usable.

## REQ-V12-003 - Responsive weekly schedule

Status: Implemented

Objective:
Add a school-timetable-style weekly view that makes routine activities and dated
objectives easier to understand than a single vertical agenda.

Checklist:
- [x] Requirement approved for implementation.
- [x] Projection and overlap contract approved.
- [x] Responsive layout implemented.
- [x] Existing planning actions integrated.
- [x] Compact mobile and printable-PDF extension approved.
- [x] Compact mobile layout and collapsible goals implemented.
- [x] Letter-landscape PDF save/open flow implemented.
- [ ] Widget, performance, and physical checks passed.
- [x] Documentation and traceability updated.

Acceptance criteria:
- [x] `Objetivos/Planificación` exposes `Mes | Semana` without adding a bottom
      navigation destination.
- [x] The weekly view supports previous, current, and next week navigation.
- [x] Routine activities appear as time-positioned blocks using the routine's
      persisted custom color, title, time range, and activity state.
- [x] Only occurrences inside the routine's weekday recurrence and validity
      range are projected.
- [x] Dated objectives appear in an all-day area with completed/total child-task
      progress and a compact progress indicator.
- [x] A routine-level summary may show completed/total activities, while an
      individual activity block does not show a redundant task count.
- [x] Tapping a routine activity reuses the existing routine inspection and
      execution entry point; objective actions preserve current behavior.
- [x] Overlaps remain visible and understandable without silently moving blocks.
- [x] Phone layouts remain readable through bounded horizontal navigation or
      equivalent responsive behavior; larger screens may show more days at once.
- [x] Color is never the only distinction between routines or states.
- [x] `Semana` exposes `Compacto | Cuadrícula`; Compacto is the default on
      narrow phones and presents all seven days as readable vertical sections.
- [x] Dated objectives can be collapsed to prioritize the schedule while their
      count and child-task progress remain discoverable.
- [x] The selected week exports offline as one printable US Letter landscape
      PDF containing the date range, seven days, goals, activity titles, time
      ranges, routine colors, states, and overlap indication.
- [ ] Android asks for an export folder, writes a uniquely named PDF, reports
      the actual destination, and offers to open the file for printing or
      sharing through an installed PDF application.
- [ ] PDF output remains readable in color and grayscale and does not include
      unrelated historical, synchronization, or security data.

## REQ-V12-004 - Persistent quick-note checklist

Status: In Progress

Objective:
Add an offline-first `Notas rápidas` checklist for lightweight items that only
need to be marked pending or completed.

Checklist:
- [x] Requirement approved for implementation.
- [x] Quick-note domain and repository contract approved.
- [x] Drift table, DAO, repository, and controller implemented.
- [x] Backup, import, reset, and synchronization implemented.
- [x] Focused persistence and migration checks passed.
- [x] Documentation and traceability updated.

Acceptance criteria:
- [x] Each quick note stores a stable ID, trimmed non-empty text, completion
      state, custom opaque color, nullable canonical local date, nullable
      priority, manual position, creation time, and update time.
- [x] Quick notes are stored in a dedicated unified-database table and are not
      rows in `tasks`.
- [x] A note can be created without a date and can later receive, change, or
      clear its date.
- [x] Checking or unchecking a note persists immediately and survives restart.
- [x] Reordering persists deterministically without corrupting other notes.
- [x] Quick notes participate in unified backup, staged import validation,
      protected reset, encrypted V11 exchange, conflict handling, and recovery.
- [x] Quick notes never create Pomodoro sessions, routine runs, task-completion
      events, or productivity-report data.

## REQ-V12-005 - Quick-note colors, priority, sorting, and planning visibility

Status: In Progress

Objective:
Make quick notes fast to scan and organize while keeping custom color, priority,
completion, and date as independent concepts.

Checklist:
- [x] Requirement approved for implementation.
- [x] Placement and interaction design approved.
- [x] Colors, priority, and sorting implemented.
- [x] Day-planning integration implemented.
- [ ] Responsive and accessibility checks passed.
- [x] Documentation and traceability updated.

Acceptance criteria:
- [x] `Tareas` exposes a clear `Tareas | Rutinas | Notas rápidas` selector or an
      equivalent in-feature control without changing bottom navigation.
- [x] A quick note renders as a native checkbox item equivalent to Markdown
      `- [ ]` and `- [x]`; literal Markdown parsing is not required.
- [x] Completion shows a checked state and readable completed treatment, and is
      reversible.
- [x] Each note can use a broad user-selected custom color stored in SQLite.
- [x] Priority is optional and explicit: high, medium, low, or none; arbitrary
      note color never implies priority.
- [x] Sorting supports manual order, priority, date, recent creation, and color.
- [x] Undated notes remain discoverable in a general list.
- [x] Dated notes appear in the selected-day planning agenda as a compact
      checklist, not as duration-based hourly blocks.
- [ ] Spanish, English, themes, large text, keyboard, semantics, and supported
      portrait widths remain usable.

## REQ-V12-006 - Compatibility, synchronization, and release verification

Status: Approved

Objective:
Prove that the V12 schema, projections, custom colors, validity changes, and
quick notes remain recoverable and convergent across the current product.

Checklist:
- [x] Requirement approved for implementation.
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

## REQ-V12-007 - Temporal filters for quick notes and routines

Status: Implemented

Objective:
Keep long note and routine histories usable with one consistent local calendar
period filter in both views.

Approval:
- Approved by the user on 2026-08-30.

Acceptance criteria:
- [x] Notes and Routines default to the current local day.
- [x] Both views expose Today, one day, one week, one month, and one year.
- [x] `All` keeps undated notes and unrestricted discovery accessible.
- [x] Notes compose the period with every existing sort mode.
- [x] Routines match weekday recurrence and inclusive validity boundaries.
- [x] Historical or future routine periods never present today's execution or
      progress as if it belonged to the selected period.
- [x] No database, synchronization, backup, or routing format changes occur.

Evidence:
- Boundary, controller, narrow-widget, and routine visual checks pass.
- `lib`/`test` analysis is clean and all 472 tests pass on 2026-08-30.

## Dependencies and sequencing

- V12 implementation was explicitly approved on 2026-08-26.
- Complete or explicitly defer the V11 synchronization gates affected by new
  mutable routine fields and the new quick-note entity before V12 data exchange
  is considered stable.
- Schema and sync contracts precede user-facing creation flows.
- The weekly view consumes bounded projections; it must not materialize
  unlimited future task rows.
