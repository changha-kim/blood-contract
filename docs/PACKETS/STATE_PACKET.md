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
- Version tag: **poc-0.1.1**
- Last successful run: **2026-02-20** (in-editor via Combat Playground + existing arenas)
- Last export build: **TBD** (Android / Desktop)

## Current focus (this week)
- Milestone: **M1 (Week 1)**
- P0 goals (max 3):
  1) Complete TC04 route core (Charger knockback -> Spike Wall)
  2) Implement minimum commit-vs-telegraph UX readability (TC01/TC02)
  3) Lock in a reusable combat skeleton test loop (Combat Playground) so we can iterate on feel + LOCK feedback fast

## Known issues (top 5)
1) CLI environment for this task has no `godot` binary in `PATH`, so desktop smoke cannot be rerun from terminal.
2) CLI environment for this task has no `gdlint`/`gdformat` binaries in `PATH`; lint/format checks are delegated to GitHub Actions.
3) TC04 manual playtest: SpikeWall enemy damage feedback (SFX/visual) is missing or too subtle; testers can’t confirm damage.
4) Charger sometimes slides along SpikeWall after collision, creating an unnatural “crush/slide” look.
5) Combat skeleton extraction is in progress: we imported stesproject StateMachine scripts into `godot/scripts/third_party/` but still need to decide whether to adopt them for enemy phases or keep our current enum-phase FSM.

## Next actions (do next; max 5)
1) Use Combat Playground to iterate on feel quickly: confirm move/dash/attack cadence is "fast" enough and note required tuning deltas.
2) Decide FSM direction: either adopt stesproject StateMachine (third_party) for enemy phases, or keep current enum-phase EnemyBase; document choice.
3) TC04: reduce Charger wall sliding/crushing after impact (short stop/stun/repel ok).
4) TC04: confirm SpikeWall-on-enemy feedback is readable (SFX + marker) and log `wall_hit(target=enemy, damage>0)`.
5) Re-run manual TC04 (10 attempts) and record success/fail breakdown with reasons.

## Links
- GDD summary: docs/GDD_SUMMARY.md
- Experiments / TCs: docs/PACKETS/QA_PACKET.md
- Planning: docs/PACKETS/PLAN_PACKET.md
- Critique: docs/PACKETS/CRITIC_PACKET.md
