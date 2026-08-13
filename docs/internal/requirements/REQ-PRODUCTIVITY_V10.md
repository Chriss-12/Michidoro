# Productivity V10 requirements

## REQ-V10-001 - Unified planning inside Goals

Status: Verified

Objective:
Make the Goals bottom-navigation destination the single planning surface for
goals, tasks, routine occurrences, and calendar events, while removing the
separate Planning entry from Home.

Checklist:
- [x] Requirement approved by the user on 2026-08-11
- [x] Unified UI implemented
- [x] Navigation compatibility implemented
- [x] Period filters implemented
- [x] Responsive bilingual checks passed
- [x] Documentation and traceability verified

Acceptance criteria:
- [x] Home no longer shows a separate Planning card or action.
- [x] Opening Goals shows the existing calendar and selected-day agenda,
      including goals, tasks, routine occurrences, and calendar events.
- [x] Goal filters support All, Day, Week, Month, Year, and custom date range.
- [x] Custom range opens a compact in-app calendar with explicit Start and End
      fields instead of a full-screen system picker.
- [x] Every filter has an explicit visible period and supports changing it.
- [x] Undated goals remain discoverable in the All view.
- [x] Goal creation, editing, deletion, task planning, and routine opening keep
      their current offline behavior.
- [x] The legacy `/calendar` route reaches the unified Goals planning surface so
      notifications and existing internal links do not break.
- [x] Spanish, English, large text, keyboard, and supported portrait widths do
      not clip or overlap.

Verification evidence on 2026-08-11:
- Clean `flutter analyze` and full 245-test suite.
- Focused tests cover inclusive day, week, month, year, and custom-range
  boundaries, plus undated goals in All.
- Navigation tests prove Home has no Planning entry and legacy `/calendar`
  resolves to `/goals`.
- Bilingual dense-calendar widget coverage and physical portrait inspection on
  RMX3301 confirmed the unified calendar, two-row period selector, and agenda.
- Focused widget coverage confirms inclusive Start/End selection and a
  no-overflow 320 px English layout with large text.
- RMX3301 inspection confirmed direct opening, unclipped Start/End fields,
  continuous range highlighting, and disabled Apply until both dates exist.
- No SQLite schema, repository contract, import, export, or stored row changed.

Non-goals:
- Changing SQLite tables, goal/task/routine relationships, or report formulas.
- Moving routine-template configuration out of `Tareas -> Rutinas`.
- Adding a sixth bottom-navigation destination.
