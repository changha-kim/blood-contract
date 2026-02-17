# TASK_PACKET (Dev / Codex)

## Task
- Issue: **TC04 route core — 3초 장면 재현 루프(Charger → Spike Wall) + attempt logging**
- Target model: **gpt-5.3-codex (big)**
- Branch/PR policy:
  - **DO NOT push to `main`**. Work on a feature branch and open a PR.
  - PR must pass required checks: **packets-gate**, **gdscript-lint**.

## Files allowed to modify (explicit)
- `godot/**`
- `docs/PACKETS/**` *(update STATE_PACKET at end)*
- `docs/QA_REPORT.md` *(append note if useful)*

## Read first
- `docs/PACKETS/STATE_PACKET.md`
- `docs/PACKETS/PLAN_PACKET.md`
- `docs/PACKETS/QA_PACKET.md` (Week1 scope)

## Context
Week1 P0 goal is to make TC04 reproducible in one room:
- Charger does Telegraph→Commit→Execute
- Player interaction makes Charger take Spike Wall damage
- We can try 10 times quickly and log success/fail counts with reasons.

## Requirements
### Must (what to build)
1) Ensure there is a **direct route** to the TC04 room from the UI (MainMenu button is fine).
2) In the TC04 room, provide a **fast reset loop** and log per-attempt results:
   - Emit `tc04_attempt` with fields:
     - `run_id`
     - `room_id`
     - `attempt_id`
     - `success_bool`
     - `fail_reason_enum` (only when fail; one of: `control|readability|rules|other`)
     - `ts_msec`
   - Reset method can be `reload_current_scene()`.
3) Update `docs/PACKETS/STATE_PACKET.md` at end:
   - Current build / Current focus / Known issues / Next actions (only these sections)

### Must NOT
- No new combat mechanics beyond what’s needed for TC04 reset/log loop
- No event renames (only add)

## Acceptance criteria
- [ ] MainMenu has a way to enter the TC04 room.
- [ ] In TC04 room, 10 attempts can be recorded in logs with `tc04_attempt`.
- [ ] Reset loop is stable (no crash) and doesn’t require restarting the app.

## Commit message format
- Use: `TC04: add attempt logging + reset loop in spike arena`
