# Productivity V5 requirements

Status:
In Progress. V5-M0 through V5-M2 are verified and V5-M3 is in device
verification.

## Summary

Productivity V5 improves identity, typography, wording, time-range navigation,
and report reliability. The scope stays local-first and must preserve current
task, Pomodoro, backup, and database compatibility unless an approved,
backward-compatible report migration is required.

### REQ-V5-001 - Spanish year terminology

Status: Verified

Objective:
Use `Año` consistently in user-visible Spanish text instead of `Anio` or
`anio`.

Checklist:
- [x] Requirement approved.
- [x] User-visible terminology inventory completed.
- [x] Replacements implemented without changing persisted keys or identifiers.
- [x] Tests/checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] All visible year labels use `Año`.
- [x] The change covers selectors, headers, reports, empty states, and dialogs.
- [x] Internal identifiers and database/settings keys remain compatible.
- [x] No unrelated wording changes are introduced.

Notes:
- Verified on 2026-07-28. The two visible profile-statistics labels now use
  `Año`; technical identifiers such as `year` were intentionally preserved.
- `flutter analyze` passed and the full test suite passed with 86 tests.

### REQ-V5-002 - Global typography preview and apply

Status: Verified

Objective:
Allow the user to preview a typography option and apply it globally only after
pressing a visible save button.

Checklist:
- [x] Requirement approved.
- [x] Typography options and preview text defined.
- [x] Draft selection is separate from the applied global setting.
- [x] Save/cancel behavior defined.
- [x] Local persistence and startup application reviewed.
- [x] Tests/checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] Selecting a typography option updates the preview immediately.
- [x] The rest of the app does not change until `Guardar` is pressed.
- [x] Pressing `Guardar` applies the selected typography globally.
- [x] The applied typography affects all supported screens consistently.
- [x] Leaving without saving preserves the previously applied typography.
- [x] The selected typography persists and is restored at startup.

Notes:
- Verified on 2026-07-28. Settings now keeps a local draft preset, renders a
  representative preview, and applies the draft only through `Guardar`.
- The existing `AppSettingsController` persistence and global theme pipeline
  remain the source of truth after saving.
- `flutter analyze` passed, the focused Settings controller tests passed, the
  widget test passed, and the full suite passed with 86 tests.
- 2026-07-28 visual hardening bundled Sora, Merriweather, and Roboto inside the
  APK for offline use; verified preview-only selection, global save,
  navigation/chart labels, restart persistence, and responsive period labels
  on an Android device. The complete suite passed with 110 tests.

### REQ-V5-003 - Profile name header and temporal range selector

Status: Verified

Objective:
Replace only the entry header brand text with the selected profile name and
provide a clear period selector for day, month, and year views.

Checklist:
- [x] Requirement approved.
- [x] Header identity states defined, including an empty-name fallback.
- [x] Day/month/year selector interaction designed.
- [x] Valid day, month, and year bounds defined.
- [x] State ownership and persistence impact reviewed.
- [x] Tests/checks passed.
- [x] Documentation updated.
- [x] Traceability updated.

Acceptance criteria:
- [x] The entry header shows the selected profile name instead of `MichiFocus`.
- [x] Tapping the name opens options for `Día`, `Mes`, and `Año`.
- [x] Day selection is limited to days in the current month.
- [x] Month selection is limited to months in the current year.
- [x] Year selection supports the current year and previous available years.
- [x] The selected period updates the relevant dashboard/statistics content.
- [x] The selector is readable and usable on mobile screens.
- [x] An empty profile name has a stable, user-friendly fallback.

Notes:
- Verified on 2026-07-28. Only the entry header brand label changes to the
  selected profile name; report, database, and other internal brand mentions
  remain unchanged.
- The name opens a local quick-statistics panel with bounded day, month, and
  year selectors. The period selection is runtime UI state and is not saved.
- `flutter analyze` passed and the full test suite passed with 86 tests.

### REQ-V5-004 - Unified and trustworthy reporting engine

Status: In Progress

Objective:
Replace duplicated and potentially ambiguous report calculations with one
offline-first reporting engine that produces accurate, efficient, explainable,
and maintainable statistics for both quick views and exported PDFs.

Problem statement:
- Current PDF exports correctly read the unified SQLite database, but load all
  tasks and Pomodoro sessions before filtering them in memory.
- Task totals use the task's current status, so a past-period report can imply
  a completion happened during that period even though no completion timestamp
  is currently stored.
- Quick statistics and PDF exports calculate ranges and totals through
  different paths.
- Long-period charts can be truncated, use fixed scales, or exceed the
  available single-page PDF layout.
- Existing tests inject precomputed report data and do not verify the complete
  SQLite-to-PDF path.

Target situations:
- The user reviews a specific day, month, year, or custom range.
- The user compares quick statistics with an exported report for the same
  resolved period.
- The user exports reports after accumulating several years of local data.
- The user opens a report containing Spanish names, accents, long labels, and
  every supported chart section.

Checklist:
- [x] Requirement direction and quality baseline approved by the user.
- [x] V5-M3.0 metric and architecture work approved to begin.
- [x] Metric definitions and historical semantics documented before coding.
- [x] Architecture and package decision approved before changing persistence
      or PDF generation.
- [x] Backward-compatible persistence migration designed if completion history
      requires new fields or events.
- [x] Range-aware Drift queries and required indexes designed.
- [x] Shared report snapshot/use-case boundary designed.
- [x] PDF renderer, pagination, naming, and file-error behavior designed.
- [x] Automated SQLite-to-report integration fixtures defined.
- [x] Android export smoke-test procedure defined.
- [x] Implementation completed.
- [ ] Required checks passed.
- [x] Documentation and traceability updated.

Acceptance criteria:
- [x] Every metric has a documented name, formula, date source, unit, range
      boundary, and treatment of missing or legacy data.
- [x] A resolved report range uses local calendar semantics and one immutable
      `[start, end)` interval shared by querying, labels, charts, and export.
- [x] Historical completion metrics use a real completion timestamp or event;
      the implementation must not invent completion dates for legacy records.
- [x] Legacy records with unavailable completion history are handled explicitly
      and cannot silently inflate historical completion totals.
- [x] Quick statistics and PDF exports use the same report snapshot use case
      when requesting equivalent metrics and ranges.
- [x] Report queries filter or aggregate in SQLite through repository
      boundaries; report generation does not call whole-table `loadAll` methods
      and then filter every record in presentation code.
- [x] Query columns used for report ranges have appropriate indexes, including
      the chosen Pomodoro completion/end timestamp.
- [x] Day, month, year, and custom ranges select an appropriate chart grain;
      no period is silently reduced to the first ten data points.
- [x] Chart scales derive from the selected data and communicate zero/empty
      states without fixed caps that distort monthly or yearly values.
- [ ] PDF content supports page breaks, text wrapping, Spanish accents, long
      profile values, all enabled chart sections, and US Letter output without
      overlap or clipping.
- [x] Exported filenames include the report period and a collision-resistant
      date/time component instead of replacing the previous report.
- [x] File-system and native-folder failures produce clear user-facing errors
      and do not report a successful export.
- [x] Report generation remains offline-first and reads `michifocus.sqlite` as
      the source of record; backup import/export behavior remains unchanged.
- [x] Report responsibilities are separated into range resolution, data
      retrieval/aggregation, snapshot construction, PDF rendering, and file
      writing; settings state does not own report business logic.
- [x] Automated tests cover range boundaries, reversed custom dates, empty
      data, legacy completion data, multi-year volume, chart aggregation,
      pagination, unique naming, and write failures.
- [x] At least one integration test seeds an in-memory unified Drift database,
      generates a report through the production use case, and verifies the
      expected task/Pomodoro metrics and valid PDF output.
- [ ] Android verification exports and opens day, month, and year reports with
      all charts enabled.
- [x] `dart format`, Drift code generation when applicable,
      `flutter analyze`, focused report/database tests, and the full
      `flutter test` suite pass before moving to `Verified`.

Measurable quality targets:
- [x] Exact metrics and chart buckets produce zero mismatches across the
      approved reference fixtures.
- [x] The standard large fixture contains at least 20,000 tasks and 50,000
      completed Pomodoro sessions spanning five calendar years.
- [x] Indexed range queries show no unrestricted full-table scan under
      `EXPLAIN QUERY PLAN` on the standard large fixture.
- [ ] On the target Android device, after one warm-up and ten measured runs,
      quick statistics meet p95 <= 500 ms, report snapshots meet
      p95 <= 1,000 ms, and complete PDF generation/save meets p95 <= 3,000 ms.
- [x] Chart series contain at most 24 hourly, 7 daily-week, 31 daily-month,
      12 monthly-year, 53 weekly-custom, or 60 monthly-custom buckets according
      to the resolved range, with no omitted source interval.
- [x] Headline totals equal their chart-bucket sums in 100% of automated
      fixtures.
- [ ] Rendered PDF checks cover 612 x 792 point pages, a minimum 36-point
      content margin, all charts together, multipage output, five-year data,
      Spanish accents, a 120-character name, a 254-character email, and a
      200-character recommendation without clipping or overlap.
- [x] One hundred rapid sequential exports produce one hundred distinct,
      existing files.
- [ ] The complete evidence contract in
      [`REPORTING.md`](../technical/REPORTING.md) passes before `Verified`.

Non-goals:
- Cloud synchronization, remote analytics, or a backend reporting service.
- Moving settings JSON into SQLite.
- Changing the unified database backup contract.
- Adding a PDF dependency without explicit approval.
- Claiming immutable historical workload snapshots unless the required event
  history has been deliberately designed and implemented.

Architecture direction:
- A report request resolves its dates and generation timestamp once.
- A report repository exposes range-aware domain queries and hides Drift.
- A report snapshot use case owns metric formulas and is shared by quick views
  and exports.
- A PDF renderer owns document presentation only.
- A report file writer owns naming, destinations, and write failures.
- The implementation must compare isolating the current raw PDF renderer with
  adopting a maintained PDF package; package installation remains a separate
  explicit approval gate.

Quality gates:
- Gate 1 - Metric contract: no implementation until date and historical
  semantics are unambiguous and `REPORTING.md` is approved.
- Gate 2 - Persistence/query design: no schema change until migration,
  legacy-data behavior, indexes, and backup compatibility are reviewed.
- Gate 3 - Engine verification: calculation tests and SQLite integration tests
  pass before connecting the PDF renderer.
- Gate 4 - Document verification: structural PDF checks and rendered-page
  inspection confirm no overlap, clipping, encoding, or pagination defects.
- Gate 5 - Release verification: analyzer, full tests, APK build, and Android
  day/month/year/five-year export smoke tests and recorded p95 budgets pass.

Notes:
- V5-M0 should be completed first because it is small and reduces wording
  ambiguity before UI verification.
- V5-M1 should precede V5-M2 so the header and selector use the finalized
  identity/settings behavior.
- V5-M3 is the next recommended milestone after V5-M2 and should be completed
  before adding more report types or report visualizations.
- On 2026-07-28, the user approved the strengthened measurable baseline and
  authorized starting V5-M3.0. This approval does not install a package or
  approve a schema migration before its design is reviewed.
- This requirement does not change the SQLite backup contract or move settings
  preferences into the database.
