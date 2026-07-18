# Calendar requirements

Statuses remain `Proposed` until user approval and verification evidence exist.

### REQ-CAL-001 - View calendar planning

Status: Verified

Objective:
Allow users to view planned work in a calendar-oriented UI.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] The user can open a calendar-oriented planning view from Home.
- [x] The calendar shows the current month, supports month navigation, and allows day selection locally.
- [x] The selected day shows local planning entries or an empty state without backend or internet dependency.
- [x] Required checks before `Verified`: `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved by user on 2026-07-10 for the first M5 slice.
- Verified by replacing the static calendar placeholder with a local month view,
  selected-day state, and an offline agenda.
- Event creation and persistence are now tracked by verified follow-up
  requirements `REQ-CAL-002` and `REQ-CAL-004`; task/session association
  remains tracked by `REQ-CAL-003`.

### REQ-CAL-002 - Create calendar event locally

Status: Verified

Objective:
Allow users to create local calendar events from the calendar planning view.

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
- [x] The user can create a calendar event for the selected day without backend or internet dependency.
- [x] Blank event titles are rejected with a local validation message.
- [x] Created events appear in the selected day's agenda and mark the day in the month grid.
- [x] Required checks before `Verified`: `dart run build_runner build --delete-conflicting-outputs`, `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved by user on 2026-07-10 for the second M5 slice.
- Verified on 2026-07-10 with `CalendarController`, a create-event dialog,
  selected-day agenda refresh, and month-grid event markers backed by local
  persisted events.

### REQ-CAL-003 - Plan goals on calendar dates

Status: Verified

Objective:
Use the calendar to choose which goal/objective should be reached by a target
date.

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
- [x] A selected calendar date can show the goal planned for that date.
- [x] The user can pick or change the goal associated with a selected date.
- [x] The selected date remains local and does not require backend or internet dependency.
- [x] The calendar view can show which dates have planned goals.
- [x] Required checks before `Verified`: Drift generation if schema changes, `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved by user on 2026-07-10 for the goal deadline planning slice.
- Calendar now reads `GoalsController`, marks target-date days in the month
  grid, and shows matching goals in the selected day's agenda.
- The selected calendar date can create, edit, or delete its goal directly.
- Pomodoro selection now lists only incomplete goals with a calendar target date
  plus the `Sin objetivo` option.
- Product direction updated on 2026-07-10: calendar planning should prioritize
  goal target dates over standalone events.
- Verified on 2026-07-10 with `dart format lib test`, `flutter analyze`, and
  full `flutter test` passing with 44 total tests.
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-CAL-004 - Local calendar event persistence

Status: Verified

Objective:
Persist calendar events locally with Drift/SQLite.

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
- [x] Calendar events are stored in a local Drift table and survive database reloads.
- [x] Presentation/controllers depend on repository/domain APIs, not Drift DAOs.
- [x] The database schema is documented in `docs/internal/technical/DATABASE.md`.
- [x] Required checks before `Verified`: `dart run build_runner build --delete-conflicting-outputs`, `dart format lib test`, `flutter analyze`, and full `flutter test`.

Notes:
- Approved by user on 2026-07-10 for the second M5 slice.
- Verified on 2026-07-10 with `CalendarEventRecords`,
  `CalendarEventsDao`, `DriftCalendarEventsRepository`, generated Drift code,
  and SQLite persistence tests.
