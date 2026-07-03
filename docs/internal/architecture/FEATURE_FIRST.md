# Feature-first structure

Place feature code under `lib/features/<feature>/data`, `domain`, and `presentation`. Shared cross-feature utilities belong in `lib/core` or `lib/shared` only when reuse is proven.

## Checklist

- [ ] Dependency direction is respected.
- [ ] Feature code stays in the owning feature.
- [ ] Shared code is justified by actual reuse.
