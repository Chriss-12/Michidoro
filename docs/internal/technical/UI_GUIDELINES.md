# Ui Guidelines

Build Material 3 UI with clear spacing, accessible labels, responsive layouts, and reusable Atomic Design components. Avoid embedding business logic in widgets.

## Visual consistency

- Keep text letter spacing at `0` unless a future approved visual rule says otherwise.
- Use the shared `GlassCard` default radius of `8` for card surfaces.
- Keep feature-only cards, tiles, and controls inside their owning feature until actual cross-feature reuse exists.
- Configure responsive breakpoints once in `MaterialApp.router`; use local responsive layout changes only when a screen has a proven overflow or density issue.
- Typography presets are user-facing Settings choices. Keep the categories
  `moderna`, `serio`, and `normal` mapped through `AppTypographyPreset` instead
  of hardcoding font families in individual widgets.
- User-selectable fonts must be bundled in the APK; do not rely on runtime font
  downloads or system-family substitution.
- Theme presets must keep status/navigation bar icon brightness and interactive
  control contrast aligned with the active palette.
- After successful device authentication, the percentage/loading screen must
  use the locally saved theme preset and light/dark appearance before its first
  frame; startup must not reread the same settings later in that boot.
- Theme presets must remain visually distinct in both light and dark mode;
  enabling dark mode must not replace every preset with one shared palette.
- Shared Material surfaces (dialogs, sheets, menus, snackbars and chips),
  progress indicators, startup artwork and ordinary semantic status accents
  must derive from `AppPalette`; do not introduce fixed decorative colors that
  remain unchanged when the user selects another preset.
- Preserve explicit color ownership exceptions: routine and quick-note colors
  are user identity data, while Clear/OLED maximum-concentration palettes are
  deliberately fixed display modes. These exceptions still require readable
  foreground contrast.
- Apply color-theme changes without a global theme transition. The persistent
  tab shell keeps inactive branches alive, so animating the complete ThemeData
  would repaint every retained branch on each transition frame.
- Bottom-navigation labels must preserve the selected font family, weight, and
  palette. Above the 100% text-size setting, use the compact navigation-label
  size so all five destinations remain on one line at supported portrait widths.
- Multi-step editors must keep one stable progress header, consistently grouped
  controls, and a fixed full-width action footer. Modal editors must use the same
  section hierarchy and remain scrollable at supported portrait text sizes.
- User-selected routine colors are identity data, not status data. Preserve the
  chosen hue across themes, compute readable foreground contrast, and keep state
  visible through labels, icons, and intensity in addition to color.
- Legacy routine color keys resolve through one canonical, theme-independent
  identity palette so old routines keep the same visible color on every device.
- Quick-note colors are user identity data and never imply priority. Notes use
  a native reversible checkbox, keep optional priority as a separate label,
  remain discoverable without a date, and appear in selected-day Planning only
  when explicitly dated.
- In-context creation flows may use a bounded modal with a dimmed barrier when
  the user should remain anchored to the source view. Large modal editors must
  use an opaque themed canvas and avoid live full-screen blur, which can cause
  frame drops on high-resolution phones. Preserve `SafeArea`, keyboard resizing,
  fixed actions, and dirty-draft protection; do not compress multi-step forms
  into a small dialog.
- Compact list filters must use an anchored content-sized menu rather than a
  full-width form field. Avoid redundant floating labels such as `Show` when the
  selected value and filter icon already communicate the control's purpose.
- Period filters with more than three compact choices must remain immediately
  visible in portrait. Use balanced segmented rows instead of a clipped or
  horizontally discoverable control.
- Notes and routines share Today, day, week, month, year, and all-time period
  language. Today is the initial local view; all-time preserves undated notes.
  Historical or future routine views never borrow today's execution state.
- Contextual creation in the Goals card belongs directly below the card header,
  before period controls and potentially long objective lists.
- Weekly planning uses Monday through Sunday. Narrow phones default to seven
  stacked, readable day sections and expose `Compacto | Cuadrícula`; the
  alternative school grid keeps the time axis fixed and scrolls only its
  bounded seven-day content horizontally. Wider layouts may default to the grid.
- Weekly goals are collapsible. The collapsed header must retain the goal count
  and completed/total child-task summary.
- Weekly routine blocks keep their original time when schedules overlap. Use
  lanes plus a border/icon signal for conflicts, and reduce block detail
  progressively when a lane becomes too narrow instead of overflowing.
- Dated goals belong in the weekly all-day area with completed/total child-task
  progress. Individual activity blocks show identity, time range, and state but
  do not repeat routine-level task counts.
- Weekly printable exports use one US Letter landscape page, show the selected
  Monday-Sunday range, goals, activity identity, time, state, routine color, and
  a non-color overlap cue, and exclude unrelated history or synchronization
  metadata.
- Date-range filters must expose separate Start and End fields in a bounded
  in-app calendar dialog, highlight the selected interval, and avoid replacing
  the current workflow with a full-screen system picker.
- Text fields approved for dictation use one themed microphone suffix action
  followed by a clear-all eraser. The eraser stays disabled while the field is
  empty, clears the controller and its form state together, and returns the
  field to its initial one-line height.
  Voice only edits text, never saves automatically, and numeric or structured
  controls do not expose this action. These fields wrap words instead of
  scrolling horizontally, grow from one to two visible lines, keep that height
  after the second line, and use Enter for a newline rather than implicit save.
  Preserve each established feature's label alignment; Tasks, Routines, and
  Quick Notes retain their previous multiline top alignment, while Goals keeps
  its centered empty-state label.
- Local voice-model preparation uses one themed live-status dialog. Show the
  Android state truthfully as scheduled, determinate download percentage when
  available, ready, or failed; repeated taps must not imply a new download.
- Searchable relationship selectors use a full-width summary control and a
  keyboard-safe bounded sheet. Keep the unassigned option visible, show useful
  secondary context such as date, and reuse the shared dictation action only in
  the editable search field.
- Fixed task-duration choices use adaptive chips that wrap on narrow screens,
  expose exactly one selected value, and default to 25 minutes. Duration is a
  structured numeric control and therefore does not expose dictation.
- Keep the Pomodoro ring center limited to the current countdown and phase.
  Show the compact completed-Pomodoros check plus `X/Y` outside the ring,
  immediately above the controls; detailed task-plan metadata belongs in the
  information action below the ring.
- Maximum concentration offers a pure-white Clear palette with black content
  and the original pure-black OLED palette with neutral gray content. OLED
  exposes a locally persisted 20–100% opacity slider that dims all focus
  content using opaque colors, plus a default-on AMOLED protection switch that
  moves the complete clock/text/control group vertically every 60 seconds and
  recenters it when disabled. The three-dot menu always keeps an opaque surface.
- Focus display options expose a device-local `Keep screen awake` switch.
  Maximum concentration enables it automatically, but the user can opt out.
  Apply the native screen-awake flag only while the timer is advancing and
  release it on pause, completion, discard, or app disposal.
- Irreversible database actions belong in a final, visually separated Settings
  card. Explain deleted and retained data, require typed bilingual confirmation,
  and keep the final destructive action disabled until the phrase matches.

## Required checks

- [ ] Relevant requirement or decision is linked.
- [ ] Implementation remains offline-first.
- [ ] Verification evidence is recorded when status changes.
