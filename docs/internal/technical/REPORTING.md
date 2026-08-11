# Reporting quality contract

Status:
Implementation contract for `REQ-V5-004` and `V5-M3`. Automated evidence is
implemented; Android timing, export/open smoke tests, and rendered-page
inspection remain release gates. No new PDF package was added.

## Purpose

Define what `accurate`, `efficient`, `maintainable`, and `valid PDF` mean in
terms that can be tested. V5-M3 cannot move to `Verified` through visual
inspection or unit tests alone.

## Source and range contract

- `michifocus.sqlite` is the source of record for task and Pomodoro metrics.
- Settings JSON may provide report identity, destination, and chart visibility,
  but never task or Pomodoro totals.
- A report request resolves `generatedAt`, local time zone, `start`, and `end`
  once.
- Every query, label, bucket, chart, and export uses the same half-open local
  interval: `start <= timestamp < end`.
- Date-only selections resolve to local midnight boundaries.
- Reversed custom dates are normalized before querying and the normalized
  interval is shown in the report.
- The supported custom range is up to five calendar years. Larger future
  ranges require a new performance review rather than silent truncation.

## Metric dictionary

The V5-M3.0 design must approve the storage source for `completedAt` or an
equivalent immutable task-completion event before implementation.

| Metric | Required formula and date source |
|---|---|
| Planned tasks | Count tasks whose `scheduledDate` falls inside the resolved interval. Unscheduled tasks are excluded and reported separately when needed. |
| Created tasks | Count tasks whose `createdAt` falls inside the resolved interval. |
| Completion events | Count trustworthy task completion timestamps/events inside the resolved interval. Current task status alone is not completion evidence for a past period. |
| Planned completion rate | Tasks scheduled in the interval and completed no later than the interval end, divided by all tasks scheduled in the interval. The report must expose the denominator. |
| Current task status | Current listed/in-progress/completed state of tasks in the selected cohort, explicitly labeled as a current snapshot rather than historical completion activity. |
| Legacy unknown completions | Completed legacy tasks for which no trustworthy completion time exists. They are shown as unavailable/unknown and never silently assigned to a period. |
| Completed Pomodoros | Count completed sessions whose `endedAt` falls inside the resolved interval. |
| Focused time | Sum `focusedSeconds` for those completed sessions. Display rounding occurs only after summing seconds. |
| Mood average | Arithmetic mean of valid final mood scores from completed task-linked focus blocks ending inside the interval. Start mood, partial sessions, free Pomodoros, null/invalid scores, and unanswered prompts are excluded. The sample count is always shown. |
| Distraction time | Sum persisted `distractionMinutes` only for sessions marked distracted and ending inside the interval. |

Historical integrity rules:

- A report must not infer `completedAt` from `updatedAt`.
- Legacy unknown completions must not increase period completion events.
- The implementation must preserve records or immutable events needed by
  historical metrics when users edit, reschedule, reopen, or delete tasks.
- If immutable historical workload snapshots are not implemented, the report
  must explicitly describe cohort values as current snapshots.
- Empty denominators produce `0%` plus an empty-data label, never `NaN`,
  infinity, or a fabricated percentage.

## Chart aggregation contract

All source data in the selected interval must contribute to exactly one
appropriate bucket. No `.take(n)` or equivalent silent truncation is allowed.

| Period | Required default grain | Maximum points |
|---|---|---:|
| Day | Hour | 24 |
| Week | Day | 7 |
| Month | Day | 31 |
| Year | Month | 12 |
| Custom up to 31 days | Day | 31 |
| Custom 32 to 366 days | Week | 53 |
| Custom over 366 days to five years | Month | 60 |

- Chart maxima derive from the selected series. Fixed caps such as 24
  Pomodoros or 600 minutes are forbidden for month/year reports.
- Zero-value periods remain represented when continuity is required.
- Bucket totals must reconcile exactly with headline totals.

## Correctness targets

- Reference fixtures must produce `0` mismatches across all expected scalar
  metrics and chart buckets.
- Summed chart buckets must equal the corresponding headline total in `100%`
  of automated fixtures.
- Quick statistics and PDF snapshots for the same request must return identical
  shared metrics in `100%` of integration cases.
- Boundary coverage must include at least: local day start/end, week start/end,
  month transition, year transition, leap day, reversed custom dates, empty
  range, future range, and legacy completion without a trustworthy timestamp.
- Monetary-style tolerance is not applicable: counts and seconds must match
  exactly; mood averages may differ only by the documented display rounding.

## Query and volume targets

The standard large local fixture contains:

- 20,000 tasks.
- 50,000 completed Pomodoro sessions.
- Five calendar years of timestamps.
- Mixed scheduled/unscheduled, legacy, mood, distraction, task-link, and
  objective-link records.

Required evidence:

- Report code must not call whole-table task/session loading APIs and then
  filter in presentation or controller code.
- Scalar totals are aggregated in SQLite or through bounded range query
  results.
- `EXPLAIN QUERY PLAN` for task and Pomodoro range queries must use the intended
  timestamp index on the standard large fixture and must not report an
  unrestricted full scan of the large source table.
- Data returned across the repository boundary is bounded by the selected
  detail/bucket contract; the PDF renderer never receives all raw historical
  rows.
- Tests verify that unrelated records before and after the interval do not
  affect results.

## Performance targets

Measure a profile or release build on the target Android device using the
standard large fixture. Run one warm-up followed by ten measured runs and
record median and p95:

| Operation | Median target | p95 target |
|---|---:|---:|
| Quick scalar snapshot | <= 250 ms | <= 500 ms |
| Report snapshot including chart buckets | <= 500 ms | <= 1,000 ms |
| Complete PDF generation and local save | <= 1,500 ms | <= 3,000 ms |

These budgets are release gates for the named fixture and device, not universal
benchmarks. A device change requires recording the device model and new
baseline. A failed target requires profiling and an explicit decision; reducing
the fixture or omitting data is not an acceptable workaround.

## PDF quality targets

- Every page is US Letter: `612 x 792` points.
- Content stays inside a minimum 36-point page margin, excluding intentional
  full-width header/footer backgrounds.
- The renderer creates as many pages as needed; no section may overlap another
  section or the footer.
- Text wraps without clipping for a 120-character profile name, a 254-character
  email value, and a 200-character recommendation.
- The verification corpus includes
  `áéíóúüñÁÉÍÓÚÜÑ¿¡` and must render legibly.
- Structural validation must parse every generated PDF without error and
  confirm page count and page dimensions.
- Rendered-page inspection at 144 DPI must cover empty data, all charts enabled,
  long Spanish text, five-year volume, and a multi-page output.
- Each chart type is tested alone and all chart types are tested together.
- One hundred rapid sequential exports must produce one hundred distinct,
  existing filenames.
- A failed write must leave no success notification and must not update the
  last successful report path.

## Automated evidence matrix

Before `Verified`, tests must include:

1. Pure range and bucket tests for every period and boundary case.
2. Metric formula tests, including zero denominators and legacy unknown data.
3. In-memory unified Drift integration tests with exact expected results.
4. Large-fixture query-plan and result-bounding tests.
5. Production-path SQLite-to-PDF integration.
6. PDF structural, pagination, text, chart, and filename tests.
7. File-write failure behavior.
8. Regression tests proving backup import/export remains unchanged.

## Manual release evidence

- Build and install the debug or release candidate APK on the target Android
  device.
- Export and open day, month, year, and five-year custom reports.
- Repeat with empty data, all charts enabled, and long accented profile text.
- Confirm destination, unique filename, readable pages, and clear failure
  feedback for an unavailable destination.
- Record device model, build type, dataset size, timing results, and inspected
  files in the milestone verification notes.

## Architecture boundaries

- Range resolution and metric formulas belong to domain/application code.
- Drift queries and `EXPLAIN QUERY PLAN` verification belong to the data layer.
- PDF rendering receives an immutable report snapshot and owns no database
  access.
- File writing owns destination resolution, collision handling, and write
  errors.
- UI/controllers initiate a report and display progress/result only.
- A new PDF package requires explicit approval and must be maintained,
  offline-capable, license-compatible, and covered by the same quality targets.

## Implementation record - 2026-07-28

- `StatisticsReportRequest` resolves one local `[start, end)` range and one
  generation timestamp for the complete request.
- `ReportsDao` performs range-bounded SQLite aggregates and groups all chart
  buckets into one task query and one session query. Query-plan fixtures
  verify the scheduled-task, created-task, Pomodoro-end, and completion-event
  indexes against 20,000 tasks and 50,000 sessions.
- Schema version 2 adds immutable task-completion events, reporting metadata,
  and an explicit legacy-unknown marker. Migration does not infer completion
  time from `updated_at`.
- `GenerateStatisticsReport` is shared by Home quick statistics and PDF export.
- Day, week, month, year, and custom reports retain every required bucket.
  Task, Pomodoro, and focused-time bucket sums reconcile with their headlines.
- The raw offline PDF renderer owns wrapping and pagination. The file writer
  owns destinations, collision-resistant naming, and write errors.
- Automated evidence includes SQLite-to-PDF production-path coverage,
  multi-page US Letter structure, WinAnsi Spanish text, exact mood and
  distraction formulas, write-failure state, and 100 distinct sequential
  exports.
- Targeted formatting, `flutter analyze`, and the complete 104-test suite
  passed on 2026-07-28.
- The debug APK built with JDK 17, installed over the existing app with data
  preservation, and launched successfully on the connected Android device.
- The Home dashboard and header quick-statistics modal were visually inspected
  on Android for day, month, current year, and previous year.
- Android generated distinct day, month, year, and maximum five-year custom
  range files with all chart types enabled.
- The device day export rendered as two valid US Letter pages. The maximum
  five-year range (`2021-07-29` through `2026-07-28`) rendered as three valid
  US Letter pages at 144 DPI. The five inspected pages preserve Spanish accents
  and contain no clipping, overlap, blank page, or missing period bucket.
- The export success callback returns the exact path written, avoiding a blank
  success-path message after asynchronous generation.
- Export results keep the user-facing location separate from the technical
  opening reference. The Android `Abrir` action accepts SAF `content://`
  references directly or copies an app-local PDF into a private cache folder
  before sharing a read-only FileProvider URI.
- A day report generated by the installed APK opened successfully in the
  Android chooser and PDF viewer and displayed the expected two-page document.
- After the device correction, `flutter analyze` and all 104 tests passed again.

Remaining before `Verified`:

- Render the extreme long-profile fixture at 144 DPI and inspect every page.
- Repeat the Android viewer smoke for month, year, and custom reports.
- Record one warm-up plus ten measured Android runs for the three p95 budgets.

## Routine analytics verification - 2026-08-09

- `ReportsDao` now aggregates complete routine/run item states, required-item
  consistency, abandonment, start delay, planned focus, completed-session focus,
  mood, and per-routine streaks from bounded SQLite ranges.
- Completed routine focus and mood are attributed by session `ended_at`; planned
  occurrences remain attributed by run `local_date`.
- A zero required-item denominator is represented as unavailable and rendered as
  `Sin datos` / `No data`, never as a fabricated zero percent.
- The indexed high-volume test covers 20,000 routine runs, 20,000 routine item
  runs, 20,000 tasks, and 50,000 sessions. One warm-up plus ten measured complete
  snapshots stayed within the 1,000 ms p95 budget.
- Three-page Spanish and English PDFs rendered at 144 DPI without clipping,
  overlap, blank pages, or broken accents.
- Per-routine streaks count consecutive scheduled occurrences rather than
  consecutive calendar dates, avoiding penalties for weekends or weekly gaps.
- `flutter analyze`, 202 automated tests, debug APK build, data-preserving install,
  launch, and portrait Home inspection passed on RMX3301 / Android 15.
