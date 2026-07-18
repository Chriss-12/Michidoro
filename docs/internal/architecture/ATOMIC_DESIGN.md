# Atomic Design

Prefer small reusable atoms, composed molecules, feature organisms, and screen-level templates/pages. Keep design language consistent with Material 3 and avoid feature-specific styling leaks.

## Project mapping

- `shared/templates/` contains screen-level structure reused across routes, such as `AppShell` and `PageHeader`.
- `shared/molecules/` contains reused visual building blocks, such as `GlassCard`.
- Feature pages may keep private widgets for feature-only cards, tiles, sections, and controls.
- Move a widget to `shared/` only after at least two real feature areas need the same behavior or visual contract.
- Do not create atoms, molecules, or organisms only to satisfy naming; prefer clarity and actual reuse.

## Checklist

- [ ] Dependency direction is respected.
- [ ] Feature code stays in the owning feature.
- [ ] Shared code is justified by actual reuse.
