# SPRINT_PACKET — S2 / Implementation / v0 (Draft)

> Status: **DRAFT v0** (Some items marked **TBD**).  
> Source of truth: Notion pages linked below.  
> Rule: If anything requires guessing beyond spec, keep it **TBD** and add to Open Questions.

## Context
S2 follows M2(vFinal) operational lock-in:
- **TC01 official room = 1-room tutorial** (Thorn Hall is *not* the official TC01 room)
- **M2 lure success count** = Enemy SpikeWall damage/stun applied event **1 = 1 count**, **ICD 0.8s** prevents double count

S2 Implementation goal is to make the PoC experiment **EXP | PoC‑TC01 Commit(LOCK) 이해도 — 무설명 학습** runnable end-to-end with:
- SYS Intent Combat (Telegraph→Commit→Execute)
- ENY Charger (Bull Charge / Shoulder Smash)
- HZD Spike Wall rules + feedback
- ROOM Thorn Hall (as showcase/validation room)

## Goals
- Deliver a build where TC01 can be executed per EXP spec without adding extra mechanics.
- Implement/verify commit cues + basic anti-cheese + Charger + Spike Wall interaction.

## Non-goals
- Any new gameplay/system not stated in the 5 Notion pages
- Balancing expansion beyond parameterization (tunable only)
- Large telemetry refactors (unless explicitly required)

## Spec pointers (Notion URLs)
- EXP TC01: https://www.notion.so/EXP-PoC-TC01-Commit-307777a0189881c9a83aca00ba6e49a6?pvs=26
- SYS Intent Combat: https://www.notion.so/SYS-Intent-Combat-Telegraph-Commit-Execute-307777a01898814a9d3df5820fce8fe9?pvs=26
- ENY Charger: https://www.notion.so/ENY-Charger-Inquisitor-Ram-307777a0189881acb080d77158e88064?pvs=26
- HZD Spike Wall: https://www.notion.so/HZD-Spike-Wall-307777a0189881168b0eedc267753885?pvs=26
- ROOM Thorn Hall: https://www.notion.so/ROOM-Thorn-Hall-307777a01898812daa2af14de711e2b7?pvs=26

---

## Scope IN (DEV-1 ~ DEV-14)

### [DEV-1] SYS Intent Combat state machine: Choose→Telegraph→Commit→Execute→Recover
- Implement or confirm EnemyBase phase machine matches SYS spec.
- Ensure transitions are deterministic and visible to player.

### [DEV-2] Telegraph display: shape + expected damage number
- Support minimum shapes required by Charger:
  - Bull Charge: thick line **6m** + big damage number
  - Shoulder Smash: circle **2.0m**
- Others (cone etc): **TBD if required by TC01/other enemies**

### [DEV-3] Commit(LOCK) cue: lock icon + solid/thick trajectory + SFX
- Ensure commit moment is unambiguous.
- Visual: lock icon + line becomes solid/thick.
- Audio: commit SFX (exact asset **TBD** if not specified).

### [DEV-4] Mobile UX rules (PoC subset)
- “Danger intents emphasized (max 3), others transparency down”
  - Danger classification: **TBD** (must locate exact spec rule or keep feature off).
- Commit micro slow 0.1s: configurable option.
- “Lure success” feedback: SFX + short text + slow.

### [DEV-5] Anti-cheese rules
- Spike Wall damage ICD: **0.8s**
- Knockback resistance i-frames: **0.4s**

### [DEV-6] HZD Spike Wall — enemy hit rule
- Damage: enemy max HP * **0.20** (tunable)
- Stun: **0.35s**
- Internal cooldown: **0.8s**

### [DEV-7] HZD Spike Wall — player hit rule
- Damage: player max HP * **0.08** (tunable)
- Small knockback only

### [DEV-8] Spike Wall feedback
- Metal hit SFX + sparks VFX + damage number
- Link to SYS “lure success” special feedback

### [DEV-9] ENY Charger — Intent 1: Bull Charge
- Telegraph: thick line **6m** + big dmg number
- Commit: LOCK direction + **0.2s prep**
- Execute: charge; stop on collision
- Recover: **0.90s** (wall hit: **1.20s**)

### [DEV-10] ENY Charger — Intent 2: Shoulder Smash
- Telegraph: circle **2.0m**
- Commit: LOCK position
- Execute: knockback + dmg
- Recover: **0.80s**

### [DEV-11] Charger ↔ Spike Wall interaction
- Bull Charge lured into Spike Wall produces big stun + damage (ensure outcome is perceivable)

### [DEV-12] ROOM Thorn Hall implementation/verification
- Layout: rectangle + one side Spike Wall
- Spawns: Slasher x2
- Target clear time: 60~75s (verify feasibility; do not rebalance beyond tunables)

### [DEV-13] EXP TC01 experiment entry/setup
- Official room: **1-room tutorial**
- Enemy: Charger 1 OR Slasher 1
- Hazard: Spike Wall required
- Instruction: only attack/dash; **no commit explanation**

### [DEV-14] EXP TC01 minimal measurement hooks
- Ensure we can count M2 lure success events consistently with M2 rule.
- Logging: **TBD** (use existing telemetry events if already defined; avoid refactor).

---

## Scope OUT
- Any combat/UX beyond the five pages
- Replacing telemetry pipeline
- New rooms/enemies not referenced

## Acceptance Criteria
- AC1: TC01 can be run in **1-room tutorial** with Spike Wall + (Charger 1 or Slasher 1), no commit explanation.
- AC2: Player can observe Telegraph→Commit→Execute cycle at least 3 times.
- AC3: Commit cue is perceivable (lock icon + solid trajectory + SFX) and lock behavior is consistent.
- AC4: Spike Wall rules match spec (enemy/player damage ratios, stun, ICD 0.8s, knockback i-frames 0.4s).
- AC5: Charger Bull Charge and Shoulder Smash match durations/rules.
- AC6: QA templates can be used as-is:
  - `blood_contract/test_results/templates/RESULT_TEMPLATE_TC01_P0.md`
  - `blood_contract/test_results/templates/MEASUREMENT_PROCEDURE_CHARGER_TIMINGS.md`

## Stop Conditions
- Any requirement not explicitly specified → mark **TBD** and surface as Open Question.
- If TC01 setup conflicts with room content definitions → do not guess; escalate to Planner.

## Risks
- Danger intent definition missing (for DEV-4)
- Lure success trigger definition ambiguity (commit-only vs hazard hit; currently uses M2 rule)

## Open Questions (need explicit answers / citations)
1) “Danger intent” classification rule location?
2) Exact commit SFX asset / text for lure success feedback?
3) Should lure success require commit-locked bait, or is hazard hit enough? (Currently hazard hit per M2 rule)
