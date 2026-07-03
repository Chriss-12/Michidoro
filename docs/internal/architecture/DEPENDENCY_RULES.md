# Dependency rules

Domain must not import Flutter, routing, database, DI, or state packages. Presentation may depend on domain. Data may implement domain contracts. Composition roots wire dependencies through `get_it`.

## Checklist

- [ ] Dependency direction is respected.
- [ ] Feature code stays in the owning feature.
- [ ] Shared code is justified by actual reuse.
