# ADR — Logging Unification Direction (S2 / poc-0.1.2)

- **Date:** 2026-02-15
- **Sprint:** S2
- **Build target:** poc-0.1.2
- **Milestone:** M2 (Intent Combat Stabilization / Testability)
- **Notion key:** ADR_LOGGING_UNIFICATION (DB_ADR_DECISIONS)

## Context
The project currently has **two JSONL logging paths** under `user://logs/`:

1) **Telemetry** (`res://scripts/autoload/telemetry.gd`)
- Stable file: `user://logs/app_telemetry.jsonl`
- Schema: `{ ts_ms, event_name, payload }`
- Used by: app/menu + some TC01 cue instrumentation (e.g., `commit_cue_fired`).

2) **EventLogger** (`res://scripts/autoload/event_logger.gd`)
- Per-run file: `user://logs/run_<timestamp>.jsonl`
- Schema: `{ ts_msec, event, ...payloadFlattened }`
- Used by: intent combat state machine events (`intent_*`) and some room entry events.

This split increases QA friction (multiple files + multiple schemas) and makes TC01 verification slower.

## Decision
**Choose Direction A: Keep/extend `Telemetry` as the single event pipeline.**

- `Telemetry` becomes the canonical pipeline for all gameplay/test telemetry.
- `EventLogger` is treated as **transitional/legacy** and will be migrated/deprecated in a later sprint.

## Rationale
- `Telemetry` already has a consistent, grep-friendly schema and a stable file path referenced by QA.
- Stable file naming (`app_telemetry.jsonl`) reduces “which run file?” confusion for quick test loops.
- Payload nesting avoids schema drift from ad-hoc top-level keys.

## Conventions
### Event naming
- Use **snake_case**.
- Prefer **domain prefixes** to keep the surface area navigable:
  - `app_*`, `ui_*`, `run_*`, `room_*`
  - `player_*`, `enemy_*`
  - `intent_*` (telegraph/commit/execute/recover)
  - `damage_*`

### Payload rules
- Keys are **snake_case**.
- Keep payloads small; use ids/ints; avoid large nested objects.
- Prefer explicit ids:
  - `run_id`, `room`, `enemy_id`, `intent_id`

## Required core events for TC01 (minimum)
**Run/session framing**
- `run_start` payload: `{ run_id }`
- `room_enter` payload: `{ run_id, room }`

**Intent readability / commit understanding**
- `intent_telegraph` payload: `{ enemy_id, intent_id, dmg, shape }`
- `intent_commit` payload: `{ enemy_id, intent_id, lock_type, lock_vector }`
- `commit_cue_fired` payload: `{ enemy_id, intent_id, ts_ms }`
- `intent_execute` payload: `{ enemy_id, intent_id, hit }`
- `intent_recover` payload: `{ enemy_id, intent_id }`

(If TC01 uses additional cues later, add them under the `intent_*` namespace rather than inventing a parallel channel.)

## File location + rotation policy
- Base dir: `user://logs/`

**Telemetry (canonical)**
- Path: `user://logs/app_telemetry.jsonl`
- Rotation: **none yet** (explicitly accepted for PoC). A later sprint may add size-based rotation.

**EventLogger (transitional)**
- Path: `user://logs/run_<timestamp>.jsonl`
- Rotation: new file per session. No pruning yet.

## “How to grep” guidance
**Windows (PowerShell)**
- Find TC01 commit cue events:
  - `Select-String -Path "$env:APPDATA\Godot\app_userdata\Blood Contract PoC\logs\app_telemetry.jsonl" -Pattern 'commit_cue_fired'`
- Find intent commit events:
  - `Select-String -Path "$env:APPDATA\Godot\app_userdata\Blood Contract PoC\logs\app_telemetry.jsonl" -Pattern 'intent_commit'`

**macOS/Linux**
- `grep -n "commit_cue_fired" ~/.local/share/godot/app_userdata/Blood\ Contract\ PoC/logs/app_telemetry.jsonl`

## Migration note (non-goal for S2)
Current implementation still emits some `intent_*` events via `EventLogger`. Next logging sprint should:
- Mirror or move `intent_*` emissions to **Telemetry** (no schema changes required; only event routing).
- Standardize `ts_ms` field usage (Telemetry uses `ts_ms`; EventLogger uses `ts_msec`).
- Deprecate/remove `EventLogger` once parity is confirmed.
