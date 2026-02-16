# TASK_PACKET (Dev / Codex)

## Task
- Issue: **DEV-002 — Player Controller v0: 이동/공격(오토에임 placeholder)/Dash(쿨/무적)**
- Target model: **gpt-5.3-codex (big)**
- Branch/PR policy:
  - **DO NOT push to `main`**. Work on a feature branch and open a PR.
  - PR must pass required checks: **packets-gate**, **gdscript-lint**.

## Files allowed to modify (explicit)
- `godot/**`
- `docs/PACKETS/**` *(only if you must update STATE_PACKET at end)*

## Read first
- `docs/PACKETS/STATE_PACKET.md`
- `docs/GDD_SUMMARY.md`
- `docs/PACKETS/QA_PACKET.md` (Week1 scope)

## Requirements
### Must (what to build)
- Implement **player movement** (mobile-first target, but desktop input OK for now):
  - Move with WASD/Arrow keys *(keep input actions flexible for mobile mapping later)*
- Implement **attack placeholder**:
  - Basic attack triggered by a single input (e.g. `attack_btn`)
  - Auto-aim placeholder is OK: pick the nearest enemy in range or forward direction; if none, fire forward.
- Implement **dash**:
  - Input: `dash_btn`
  - Cooldown: **0.75s** (configurable)
  - Invulnerability window: **0.12s** (configurable)
  - Provide at least a **debug cooldown indicator** (text/print/UI label OK)

### Must NOT (scope cut)
- No card/synergy/run-loop systems
- No new enemy types
- No Android export/performance work
- No large refactors unrelated to controller

## Acceptance criteria
- [ ] Desktop smoke: in-editor run does not crash
- [ ] Player can move reliably for 60s without stuck input
- [ ] Dash triggers reliably, respects cooldown, and invuln window is applied (debug log ok)
- [ ] Basic attack triggers and produces a visible effect (projectile/hitbox/debug line) at least once
- [ ] `docs/PACKETS/STATE_PACKET.md` updated at end (Known issues + Next actions 3)

## Linked tests (TC)
- Supports **TC04** (requires stable control + dash) and later **TC01/02** (commit readability depends on stable input).

## Commit message format
- Use: `DEV-002: player controller v0 (move/attack/dash)`

## Notes
- Prefer data/config values in a single place (constants/resource) so Week1 tuning is fast.
