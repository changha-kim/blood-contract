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
1) GitHub ruleset requires reviews on protected branches; during PoC debugging this can cause frequent manual merges.
   - Mitigation: use `develop` for day-to-day PRs and promote `develop → main` in batches.
2) CLI environment does not have `gdlint`/`gdformat` working locally (Python 3.14 compatibility); lint/format checks are delegated to GitHub Actions.
3) Player attack is currently a placeholder hitbox + debug slash line, not final combat VFX.

## Next actions (do next; max 5)
1) Run **TC01(min)** in editor (IntentArena_Slasher) and record whether Commit=LOCK cue is distinguishable from Telegraph (Pass/Mixed/Fail per QA_PACKET).
2) Run TC04 session in editor using MainMenu → **TC04 (Spike Arena)**.
   - Do 10 attempts; mark **F5=success**, **F6=fail** (Shift=control, Ctrl=readability, Alt=rules); verify `tc04_attempt` logs.
3) Append TC01(min) + TC04 notes to `docs/QA_REPORT.md` (5-line summary each).
4) Use `develop` as default PR target; promote `develop → main` in batches.
5) Tune player combat feel values (`move_speed`, attack placeholder timing/range, dash speed) using `godot/data/defs/player_core.json` after QA findings.

## Links
- GDD summary: docs/GDD_SUMMARY.md
- Experiments / TCs: docs/PACKETS/QA_PACKET.md
- Planning: docs/PACKETS/PLAN_PACKET.md
- Critique: docs/PACKETS/CRITIC_PACKET.md
