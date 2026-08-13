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
- Theme presets must remain visually distinct in both light and dark mode;
  enabling dark mode must not replace every preset with one shared palette.
- Bottom-navigation labels must preserve the selected font family, weight, and
  palette. Above the 100% text-size setting, use the compact navigation-label
  size so all five destinations remain on one line at supported portrait widths.
- Multi-step editors must keep one stable progress header, consistently grouped
  controls, and a fixed full-width action footer. Modal editors must use the same
  section hierarchy and remain scrollable at supported portrait text sizes.
- In-context creation flows may use a bounded modal with a blurred barrier when
  the user should remain anchored to the source view. Preserve `SafeArea`,
  keyboard resizing, fixed actions, and dirty-draft protection; do not compress
  multi-step forms into a small dialog.
- Compact list filters must use an anchored content-sized menu rather than a
  full-width form field. Avoid redundant floating labels such as `Show` when the
  selected value and filter icon already communicate the control's purpose.
- Period filters with more than three compact choices must remain immediately
  visible in portrait. Use balanced segmented rows instead of a clipped or
  horizontally discoverable control.
- Date-range filters must expose separate Start and End fields in a bounded
  in-app calendar dialog, highlight the selected interval, and avoid replacing
  the current workflow with a full-screen system picker.
- Keep the Pomodoro ring center limited to the current countdown and phase.
  Task-plan metadata belongs in the information action directly below the ring.
- Irreversible database actions belong in a final, visually separated Settings
  card. Explain deleted and retained data, require typed bilingual confirmation,
  and keep the final destructive action disabled until the phrase matches.

## Required checks

- [ ] Relevant requirement or decision is linked.
- [ ] Implementation remains offline-first.
- [ ] Verification evidence is recorded when status changes.
