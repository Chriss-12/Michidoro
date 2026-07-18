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

## Required checks

- [ ] Relevant requirement or decision is linked.
- [ ] Implementation remains offline-first.
- [ ] Verification evidence is recorded when status changes.
