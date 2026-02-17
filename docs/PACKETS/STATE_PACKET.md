# STATE_PACKET (Single Source of Truth)

> All agents (Planner/Critic/Dev/QA/Art/Audio) should read this before starting work.
> At task completion, update only these four sections:
> - Current build / Current focus / Known issues / Next actions

## Project
- Name: **Blood Contract (PoC)**
- Engine: **Godot 4.x**
- Platform target (PoC): **Android + Desktop smoke(optional)**
- Repo: https://github.com/changha-kim/blood-contract

## PoC Goal
- PoC window: **4 weeks (start: 2026-02-16)**
- Success criteria (from GDD_00_ONE_PAGER):
  1) Commit combat is clearly readable (TC01/TC02)
  2) 3-second trailer moment is reproducible (Charger push -> Spike Wall) (TC04)
  3) Core run structure resolves in 6-10 minutes (TC07)
  4) Synergy tier-3 appears at least once on average (TC05)

## Current build
- Version tag: **poc-0.1.1 (LOG-001 alias events added)**
- Last successful run: **2026-02-16** (Desktop smoke, in-editor; terminal rerun unavailable in this task environment)
- Last export build: **TBD** (Android / Desktop)

## Current focus (this week)
- Milestone: **M1 (Week 1)**
- P0 goals (max 3):
  1) Complete TC04 route core (Charger knockback -> Spike Wall)
  2) Implement minimum commit-vs-telegraph UX readability (TC01/TC02)
  3) Validate Week 1 logging schema in run logs (`run_start` + `commit_enter` + `wall_hit`, while legacy aliases remain)

## Known issues (top 5)
1) CLI environment for this task has no `godot` binary in `PATH`, so desktop smoke cannot be rerun from terminal.
2) CLI environment for this task has no `gdlint`/`gdformat` binaries in `PATH`; lint/format checks are delegated to GitHub Actions.
3) Player attack is currently a placeholder hitbox + debug slash line, not final combat VFX.

## Next actions (do next; max 5)
1) Run QA smoke for DEV-002 in editor: verify 60s movement stability, dash cooldown/invuln behavior, and attack visibility in `TestArena` and `IntentArena_Slasher`.
2) Execute Week 1 log validation for `run_start`, `commit_enter`, and `wall_hit` events (and confirm `intent_commit` + `spikewall_hit` still coexist) and append results to `docs/QA_REPORT.md`.
3) Tune player combat feel values (`move_speed`, attack placeholder timing/range, dash speed) using `godot/data/defs/player_core.json` after QA findings.

## Links
- GDD summary: docs/GDD_SUMMARY.md
- Experiments / TCs: docs/PACKETS/QA_PACKET.md
- Planning: docs/PACKETS/PLAN_PACKET.md
- Critique: docs/PACKETS/CRITIC_PACKET.md
