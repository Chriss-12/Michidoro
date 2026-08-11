# Architecture index

Use these docs before changing application structure or adding feature code.

| File | Purpose |
|---|---|
| `CLEAN_ARCHITECTURE.md` | Layer responsibilities and boundaries. |
| `FEATURE_FIRST.md` | Folder organization by feature. |
| `ATOMIC_DESIGN.md` | UI component hierarchy. |
| `DEPENDENCY_RULES.md` | Allowed dependency directions. |
| `ROUTINES.md` | V9 routine schema contract, lifecycle, materialization, and migration fixtures. |

## Checklist

- [ ] Dependency direction is respected.
- [ ] Feature code stays in the owning feature.
- [ ] Shared code is justified by actual reuse.
