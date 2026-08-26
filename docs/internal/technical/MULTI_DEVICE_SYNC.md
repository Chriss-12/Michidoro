# Multi-device synchronization

## Decision

MichiFocus will support optional Android-to-Android synchronization through a
user-selected folder transported by Syncthing. The live database always remains
private to each installation. This contract was approved on 2026-08-13 and its
isolated causal/identity protocol is in progress. Local goal, task, calendar,
and routine mutations enter a durable encrypted publication queue. Finalized
remote operation files can now be scanned, authenticated, causally classified,
and transactionally applied for those four entity types.

## Quick model

```text
Phone A private SQLite                         Phone B private SQLite
          |                                              |
          v                                              v
MichiFocus publishes A files   <-> Syncthing <-> MichiFocus publishes B files
          ^                                              ^
          |                                              |
MichiFocus validates/applies                    MichiFocus validates/applies
```

Syncthing owns file transport. MichiFocus owns application semantics,
validation, idempotency, database transactions, conflict detection, and user
resolution. A local processing action cannot claim that network transfer has
completed unless that fact is independently observable.

## Storage layout

The exact names may change during the V11-M0 prototype, but ownership must not.

```text
MichiFocusSync/
  michifocus-<group-id>.v1.json
  michifocus-op-<installation-hex>-<20-digit-counter>-<operation-hex>.v1.json
  snapshots/
    <snapshot-id>/
      manifest.json
      michifocus.sqlite
  quarantine/
```

Rules:

- Only the owner installation creates operation names carrying its installation
  ID and monotonically increasing counter.
- Operation files become immutable after publication.
- The selected folder never contains the database currently opened by Drift.
- A snapshot is a recovery/bootstrap artifact, not a multi-writer database.
- Temporary files are not eligible for import.
- Group and protocol identifiers prevent accidental cross-app or cross-group import.

The current encrypted recovery-snapshot slice publishes one immutable prototype
artifact named
`michifocus-<group-id>-recovery-<snapshot-id>.v1.json`. Its minimal visible
envelope contains only version/suite, group ID, random snapshot ID, creation time,
nonce, ciphertext, and authentication tag. The SQLite bytes and all user-authored
content are inside the AES-256-GCM ciphertext. The future directory layout may
move this same versioned artifact without changing its privacy contract.

Before a folder reference is accepted, the Android Storage Access Framework
bridge must create a uniquely named probe file, write known non-sensitive bytes,
read and compare those bytes, and delete the probe. A later explicit check uses
the same cycle to detect revoked or degraded access. Failure leaves the private
SQLite database and the previously stored folder reference untouched, reports an
actionable warning, and never blocks ordinary offline application flows.

The first immutable folder artifact is the synchronization-group key manifest:

- its deterministic name is `michifocus-<group-id>.v1.json`;
- it contains only the versioned password KDF and the password/recovery-wrapped
  group DEK; the device-bound local envelope is never published;
- Android writes a uniquely named temporary document, reads and compares its
  bytes, and uses `DocumentsContract.renameDocument` for finalization when the
  provider supports it;
- providers without rename support use a verified copy fallback and remove the
  temporary document; later readers must still accept only complete, validated
  final names;
- publishing the identical final bytes is idempotent;
- a different existing final file for the same group is a conflict and is never
  overwritten or silently selected;
- publication failure leaves the private enrollment intact and visibly retryable.

Joining-phone discovery is read-only at this stage:

- Android enumerates only canonical final names matching
  `michifocus-group_<128-bit-id>.v1.json`; temporary and unrelated files are
  never returned as candidates;
- each candidate is read with a hard 64 KiB limit, then Dart repeats the name,
  group-ID, protocol, suite, KDF, salt, nonce, ciphertext, and tag checks;
- malformed, oversized, foreign-name/group, duplicate-conflicting, or
  unsupported manifests are counted as rejected and cannot start Argon2id;
- discovery shows only short group-ID suffixes and does not enroll the phone,
  unwrap a key, import a snapshot, or modify the private database;
- linking requires the selected manifest's password or independent recovery key,
  followed by Android system authentication; the unwrapped DEK is copied only
  into a mutable short-lived buffer, wrapped by this phone's Keystore key, then
  cleared;
- successful linking preserves the existing group ID and stores only the
  encrypted manifest plus this phone's device-bound envelope; wrong credentials,
  cancelled authentication, or persistence failure cannot create an enrollment,
  and a provisional local key is removed after failure;
- linking still does not import or modify application data. The explicit
  empty/populated-database bootstrap decision remains a later gate.

The current outgoing-operation slice uses a strict protocol-v1 envelope:

- the visible authenticated metadata contains group ID, operation ID, origin
  installation ID, origin counter, payload SHA-256, nonce, ciphertext, tag,
  protocol version, and suite;
- the encrypted canonical payload contains entity type and ID, causal parent
  version, changed fields, operation kind, and creation time;
- goal, task, calendar, and routine repositories commit the application mutation,
  monotonic counter, causal metadata, and durable outbox record in one SQLite
  transaction when multiple-device mode is fully configured;
- Android publishes only encrypted bytes directly in the selected tree using a
  bounded canonical name that still carries the owner installation, counter,
  and operation IDs. The shortened hexadecimal name avoids provider-specific
  filename limits, while verified temporary/final handling never overwrites
  different final bytes. Root storage is required because some Android document
  providers accept root documents but reject nested directory creation;
- failed publication remains pending and retryable; successful publication is
  recorded locally, but does not imply Syncthing transported the file;
- Android system authentication is required before the device-bound group DEK
  is briefly unwrapped for publication, and the mutable clear-key buffer is
  erased afterward.

## Identity and causal ordering

Each installation receives a stable random installation ID and a local logical
counter. Each operation advances that counter and carries a causal version for
the affected entity. A version vector or equivalent dotted causal representation
must distinguish:

- an operation already seen;
- an operation causally newer than local state;
- an operation older than local state;
- two concurrent operations produced without knowledge of one another.

Wall-clock timestamps cannot make those decisions because phones may have
incorrect clocks. They remain useful for labels, diagnostics, and user context.

Globally generated entity IDs should use secure randomness plus a type prefix.
Legacy IDs remain stable; they receive synchronization metadata rather than
being rewritten in place unless a separately approved migration proves that
all foreign keys and external snapshots are preserved.

The production installation identity is created from 128 bits of secure random
data with the `installation_` scope and persisted in private application storage
as `michifocus-device-identity.json`. It is not derived from the Android model,
clock, user name, folder name, or Syncthing device ID. Android manufacturer and
model are used only to propose a friendly label; the fallback is `Teléfono
Android`. The user may edit that label up to 60 normalized characters.

Renaming changes only the friendly label and preserves the installation ID.
The UI may show a short installation-ID suffix to disambiguate equal labels,
but the user never types or manages the technical identifier. Uninstall/reinstall
and device retirement remain enrollment concerns: no restored identity may gain
group authority silently without the later explicit recovery flow.

## Local mutation path

1. Validate the domain command.
2. Commit the application mutation and durable outbox description in one SQLite transaction.
3. Publish the immutable operation file outside the transaction.
4. If publication fails, retain a visible retryable outbox item; never undo valid user work.
5. Mark publication complete only after the finalized file can be read and validated.

This requires synchronization metadata inside the unified database. The V11-M1
schema design should evaluate at least device/group state, durable outbox,
applied-operation ledger, per-entity or per-field causal versions, conflicts,
tombstones, and acknowledgement watermarks.

Schema version 7 keeps those seven private tables and extends their operation
context without changing application entity IDs:

- `sync_local_state` owns one monotonically increasing counter per enrolled
  group/installation pair and rejects a mismatched installation or protocol;
- `sync_outbox` keeps the complete validated local operation description,
  originating friendly name, encrypted-payload entity snapshot, and a
  unique `(group, origin device, origin counter)` identity until publication;
- `sync_applied_operations` deduplicates remote input by both operation ID and
  the unique origin counter, including its SHA-256 payload identity;
- `sync_entity_versions` retains the friendly origin of each winning field;
  `sync_tombstones` (including the friendly deletion origin and last complete entity
  snapshot needed for safe delete/update restoration), `sync_conflicts`, and
  `sync_acknowledgements` reserve durable causal, deletion, resolution, and
  retention state without changing any existing application row ID.

The first repository boundary commits an application mutation, logical-counter
advance, and outbox insert in one SQLite transaction. Any failure rolls all
three back. Remote application and its applied-operation ledger entry likewise
commit together; an exact repeat is a no-op, while reused operation IDs or
origin counters with different identity fail closed.

The first incoming slice now enumerates canonical final operation paths from
other installation directories through Android SAF with bounded file reads.
Dart repeats path/envelope validation, authenticates and decrypts AES-256-GCM,
rejects foreign-group or unsupported payloads, orders goals and routine
aggregates before dependent tasks, and retries deferred dependencies during the
same review pass. Tasks, goals, calendar events, and routine templates/lifecycle
apply inside the same transaction as their idempotency and causal metadata.
After commit, the owning controllers reload. Invalid input never reaches an
application mutation. Physical two-phone Syncthing transport, quarantine file
movement, conflict resolution UI, acknowledgements, and immutable history remain.

## Remote application path

1. Discover finalized files and wait for file size/stability when needed.
2. Validate group, protocol, schema, required fields, counter, and integrity data.
3. Deduplicate by operation ID and origin counter.
4. Classify causal relationship and dependencies.
5. Defer operations whose parent entity has not arrived.
6. Apply one entity or aggregate in a dependency-safe SQLite transaction.
7. Record the applied operation and resulting causal state in the same transaction.
8. Refresh affected controllers and derived schedules only after commit.
9. Quarantine invalid data with a user-visible diagnostic; do not partially apply it.

## Merge rules

| Situation | Result |
|---|---|
| Duplicate operation | Ignore after verifying it matches the recorded identity. |
| Causally newer update | Apply. |
| Causally older update | Ignore as superseded, retaining diagnostic history. |
| Concurrent edits to disjoint mergeable fields | Merge; a later convergence operation remains planned. |
| Concurrent edits to the same field with different values | Create one user conflict. |
| Concurrent delete and edit | Create one user conflict. |
| Immutable event with new ID | Append. |
| Same immutable ID with different content | Quarantine as an integrity conflict. |

Conflict resolution is itself a causally newer operation. No phone may resolve a
conflict only in presentation state.

Protocol-v1 payloads remain backward compatible: new operations include the
normalized friendly device name and a complete entity snapshot inside the
authenticated ciphertext. Older operations without these optional fields still
apply, but MichiFocus disables any resolution that would require unavailable
reconstruction data. Safe goal and calendar-event conflicts may preserve both
versions by resolving the original and creating a new random-ID duplicate in one
transaction; tasks and routines are excluded because blind duplication can break
execution and historical ownership.

## Deletion and compaction

Deletion creates a tombstone. A tombstone carries causal state and remains until
every active installation has acknowledged it. A phone that has been offline for
months must not resurrect the deleted entity.

Exchange files may be compacted behind a validated snapshot only when every
active device has acknowledged the compacted counters. An unavailable device
must be explicitly retired before its acknowledgement is excluded. Retirement
is a durable group operation and stale installations cannot silently regain
write authority.

## Application-data boundaries

Mutable user-authored aggregates synchronize through semantic commands or
validated patches, not arbitrary row dumps. Immutable history synchronizes as
append-only events. Derived reporting state is recalculated conservatively.
Hardware and device-specific settings stay local.

The active Pomodoro runtime remains local for V11. A last-known marker may inform
other phones, but it is not a distributed lock. Completed sessions and resulting
task/routine transitions synchronize. Concurrent legitimate sessions are
preserved and contradictory mutable state is merged or raised as a conflict.

## Mode transitions

### Single device to multiple devices

1. Explain transport, privacy, and eventual-consistency limits.
2. Select and validate the shared folder.
3. Create and verify a recovery snapshot.
4. Create or join a sync group.
5. Generate installation identity and friendly name.
6. Publish a bootstrap snapshot plus causal baseline.
7. Begin durable outbox publication and remote scanning.

### Joining with local data

- Empty local database: bootstrap from the group, validate, then replay later operations.
- Populated local database: create a recovery snapshot, then require `Merge local data`
  or `Replace local data`. Merge generates normal operations; replacement uses the
  existing staged import boundary while the live database is closed.

Before linking, MichiFocus performs
a read-only count of goals, tasks, calendar events, focus sessions, completion
events, routines, and routine runs. An empty database records `restoreIntoEmpty`;
a populated database blocks linking until the user explicitly chooses
`mergeLocal` or `replaceLocal`, and that preliminary choice survives restart.
For a group created on this phone, or a joining phone that selected `mergeLocal`,
`Preparar cambios para Syncthing` first creates ordinary causal `create`
operations for every existing mutable goal, routine aggregate, task, and calendar
event that has no synchronization history. Goals and routines are queued before
dependent tasks and calendar events. The check and outbox insert share a Drift
transaction, so retries or process interruption cannot logically duplicate an
already prepared entity. Immutable completed history is intentionally excluded
until its append-only protocol is implemented. Empty-device snapshot restore and
`replaceLocal` execution do not yet import or replace a complete remote snapshot.
Before a populated phone can finish joining, it now creates and verifies an
encrypted recovery snapshot. A phone enrolled by an earlier build receives the
same action without leaving its group or re-entering the group password: Android
authentication unlocks the device-bound DEK temporarily. The live database is
never exported directly. Incoming operation application requires that recovery
gate, another Android-authenticated temporary DEK unwrap, and an explicit
`Revisar cambios recibidos` action. Complete snapshot bootstrap/replacement and
automatic background processing remain gated. Outgoing current and pre-enrollment
goal, task, calendar, and routine data can be prepared as encrypted immutable
files for Syncthing.

Recovery snapshot creation uses the existing `VACUUM INTO` boundary, validates
the isolated copy against schema version, required tables/indexes, integrity,
foreign keys, and routine contracts, then pauses only the copied runtime state.
The validated bytes are authenticated and encrypted with the group DEK. Android
streams the private encrypted temporary artifact to SAF, verifies final size and
SHA-256 digest, prefers atomic rename, and removes partial documents on failure.
Plaintext and encrypted private temporaries are removed after the attempt.

### Multiple devices to single device

1. Process already received finalized files where possible.
2. Warn about unpublished and unresolved changes.
3. Create a recovery snapshot.
4. Stop publishing and scanning exchange files.
5. Retain all locally applied data and leave the shared folder untouched.

## Status language

MichiFocus can truthfully report:

- local changes committed;
- files published locally;
- remote files observed and applied;
- conflicts or invalid files found;
- last observed activity from another installation.

Without an approved Syncthing API integration, MichiFocus cannot truthfully report:

- that Syncthing is running;
- that another phone is online;
- that a published file reached every phone;
- that the group is globally up to date.

Therefore the local action should be `Prepare and review changes`, paired with an
`Open Syncthing` action and setup guidance. Syncthing API-key integration is not
part of V11.

## Verification strategy

- Deterministic in-process simulations for two, three, and four installations.
- Delivery permutation, duplication, delay, omission-then-retry, and crash tests.
- Property-style convergence checks for compatible operation sets.
- Real Drift migration, foreign-key, transaction rollback, and import fixtures.
- High-volume outbox, ledger, tombstone, snapshot, and compaction measurements.
- Two physical Android phones using Syncthing-Fork for foreground, background,
  delayed, offline, restart, battery-policy, and folder-permission scenarios.

## Approved encryption decision

The user required password and recovery-key protection on 2026-08-13,
superseding the earlier plaintext decision. No exchange payload or recovery
snapshot may expose task, objective, routine, Pomodoro, mood, calendar, or report
content in plaintext.

### Key hierarchy

```text
User password -> memory-hard KDF + unique salt -> password KEK
Random recovery key --------------------------> recovery KEK

password KEK  -> authenticated wrapping -> random group DEK
recovery KEK  -> authenticated wrapping -> same random group DEK

group DEK -> authenticated encryption -> operations and snapshots
```

- The data-encryption key (DEK) is random and independent of the password.
- The password is never stored and is used only through a deliberately slow,
  salted key-derivation function.
- Changing the password rewraps the DEK instead of re-encrypting every artifact.
- The recovery key is independently random, shown once, and requires explicit
  user confirmation that it was saved.
- A device that has unlocked the group may cache the DEK only when wrapped by a
  device-bound Android Keystore key.
- Losing both password and recovery key makes shared encrypted artifacts
  unrecoverable by design. MichiFocus has no server or master backdoor.

### Cryptographic requirements

- Use a mature, maintained cryptographic implementation; never implement a
  custom cipher, KDF, MAC, nonce generator, or key-wrap construction.
- Use authenticated encryption so tampering and wrong keys are detected before
  plaintext is parsed.
- Use unique, cryptographically secure nonces according to the selected AEAD.
- Bind group ID, protocol version, artifact type, origin device, counter, and
  key version as authenticated associated data where supported.
- Version the suite, parameters, salts, nonces, and key identifiers in a minimal
  unencrypted envelope; never place user-authored content in that envelope.
- Define key rotation, compromised-device retirement, password change, recovery,
  and algorithm migration before the format is frozen.
- Zero or release plaintext key material as promptly as the chosen Dart/native
  implementation permits; never log passwords, recovery keys, DEKs, or plaintext.

The current recommendation to evaluate in V11-M0 is a 256-bit random DEK,
authenticated encryption, and Argon2id (or a measured, reviewed alternative when
Android/Dart support makes Argon2id unsuitable). Exact algorithms and parameters
are not approved until the dependency and physical-device performance review is
complete.

On 2026-08-13 the user explicitly approved adding the required cryptographic
dependency. `cryptography 2.9.0` now provides the primitive boundary:

- Argon2id v1.3 derives a 256-bit password KEK from a unique 128-bit salt;
- provisional Android parameters are 64 MiB, three iterations, and one lane;
- AES-256-GCM wraps one random 256-bit group DEK independently with the password
  KEK and a random 256-bit recovery key;
- each wrap uses a unique 96-bit nonce and authenticates protocol version, suite,
  group ID, artifact purpose, and wrapper kind as associated data;
- the manifest stores only versioned parameters, salt, nonces, ciphertext, and
  authentication tags—never the password, recovery key, or DEK;
- parsing rejects unknown suites and non-exact KDF/envelope sizes before running
  Argon2id, so an untrusted manifest cannot request arbitrary resources.

On 2026-08-14 the user explicitly authorized publishing the full recovery copy
to the selected Syncthing folder after authenticated encryption. Applications
with access to that folder can still copy, rename, or delete the encrypted file;
file name, size, timestamps, and transfer timing remain visible metadata.

The core is implemented and tested. A confirmed first-phone enrollment persists
the encrypted manifest locally and attempts to publish its safe shared subset. On the
physical RMX3301, the provisional production profile created the group material
in 1,670 ms and unlocked it in 1,000 ms without an out-of-memory failure. This
supports keeping the 64 MiB, three-pass, one-lane profile for the enrollment UI;
joining and application-data publication remain gated by their own verification.

This protects file contents at rest in the selected folder. File names, sizes,
counts, modification times, and synchronization timing may still reveal metadata;
the threat model and setup copy must state that limitation.

## Local system unlock boundary

Local app unlock and shared-folder encryption are complementary boundaries:

- The synchronization-group password or recovery key unwraps the group DEK when
  a phone is enrolled, recovered, or rebound after secure-key invalidation.
- After enrollment, the DEK may be cached only while wrapped by a device-bound
  Android Keystore key that requires user authentication.
- MichiFocus requests Android's system authentication prompt. Android validates a
  strong biometric or the registered device credential; the app never receives
  the fingerprint, face data, PIN, pattern, or device password.
- The user may disable local locking or require it immediately, after one minute,
  or after five minutes. Enabled protection locks on a cold process start.
- Grace-period decisions use monotonic elapsed time. An invalid elapsed result,
  authentication cancellation, or authentication failure preserves the lock.
- Syncthing remains independent and may transport encrypted artifacts while the
  app is locked. MichiFocus queues their processing until unlock makes the DEK
  available; transport never implies successful application.
- Keystore invalidation must fail closed and lead to an explained rebind using
  the group password or recovery key. It must never silently create a new group
  key or discard the private live database.

The native implementation must use Android's supported biometric and Keystore
APIs through a reviewed bridge. Policy/state code may be tested independently,
but no simulated authentication result may become a production bypass.

The first Android Keystore boundary is implemented as follows:

- each synchronization group receives a versioned, device-local alias;
- Android generates a non-exportable 256-bit AES key in `AndroidKeyStore`;
- the group DEK is wrapped with AES-GCM and group-bound associated data;
- use of the Keystore key requires a strong biometric or registered device
  credential, with a five-minute native authorization window;
- Dart receives only the wrapped envelope or the temporarily unwrapped DEK;
  caller-owned plaintext buffers are cleared after wrapping where possible;
- missing authentication, key invalidation, unavailable secure storage, and
  integrity failure are represented separately and fail closed.

This bridge is now called by the first-phone enrollment flow. Before any local
group record is created, MichiFocus validates the password pair, creates the
versioned manifest, authenticates through Android, and wraps the DEK. The local
record is written atomically only after the user confirms that the one-time
recovery key was saved. Cancelling removes the provisional Keystore alias.

The local record contains the encrypted key manifest and device-bound DEK
envelope. Only the manifest's password/recovery-wrapped subset may be published
into the selected Syncthing folder; the local envelope stays private. Compilation,
contract, controller, persistence, and widget evidence pass. User-completed
physical wrap/unwrap and folder publication remain required.
