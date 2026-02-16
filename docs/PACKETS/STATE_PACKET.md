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
- Version tag: **poc-0.1.0 (baseline)**
- Last successful run: **2026-02-16** (Desktop smoke, in-editor)
- Last export build: **TBD** (Android / Desktop)

## Current focus (this week)
- Milestone: **M1 (Week 1)**
- P0 goals (max 3):
  1) Complete TC04 route core (Charger knockback -> Spike Wall)
  2) Implement minimum commit-vs-telegraph UX readability (TC01/TC02)
  3) Stabilize minimum logging schema (`run_id`/`room_id`/`seed` + `commit_enter` + `wall_hit`)

## Known issues (top 5)
1) CLI environment for this task has no `godot` binary in `PATH`, so desktop smoke cannot be rerun from terminal.
2) `godot/export_presets.cfg` is tracked by repo policy; only user-local export preset data is ignored.

## Next actions (do next; max 5)
1) Start **DEV-002**: implement TC04 core route (Charger push into Spike Wall) on baseline.
2) Run **QA-001** logging pass for `run_start`, `commit_enter`, `wall_hit`, and verify in `user://logs/`.
3) Validate **TC01 minimum** commit-vs-telegraph readability and record week-1 outcomes in `docs/QA_REPORT.md`.

## Links
- GDD summary: docs/GDD_SUMMARY.md
- Experiments / TCs: docs/PACKETS/QA_PACKET.md
- Planning: docs/PACKETS/PLAN_PACKET.md
- Critique: docs/PACKETS/CRITIC_PACKET.md