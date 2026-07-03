# Clean Architecture

Domain owns business rules. Data implements persistence and external adapters. Presentation owns Flutter UI, controllers, and view state. Dependencies point inward; adapters translate outward concerns.

## Checklist

- [ ] Dependency direction is respected.
- [ ] Feature code stays in the owning feature.
- [ ] Shared code is justified by actual reuse.
