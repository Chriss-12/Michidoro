# Codex workflow

1. Read `AGENTS.md`.
2. Route through `.codex/ORCHESTRATOR.md`.
3. Pick the narrowest applicable `.codex/agents/*.md` role.
4. Load relevant `.codex/skills/*/SKILL.md`.
5. Update requirements, tracking, and client docs only when the change affects them.
6. Report checks and risks clearly.

## Client documentation encoding

- Always write files under `docs/client/` as UTF-8.
- When client documentation is in Spanish, preserve real accents and tildes such as `á`, `é`, `í`, `ó`, `ú`, `ñ`, and `ü`.
- Do not replace accented characters with `?`; if that appears, treat it as an encoding/content bug and fix it before handoff.
