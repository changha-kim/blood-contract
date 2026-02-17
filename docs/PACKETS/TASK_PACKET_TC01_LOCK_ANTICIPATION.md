# TASK_PACKET — TC01(min) LOCK readability: pre-crash anticipation cue

## Task
- Goal: strengthen the **Commit(LOCK) readability** by adding a clearer **pre-crash / pre-execute anticipation motion** right before the crash/execute moment.
- Scope: **minimal** (Week1 philosophy: readability > new mechanics).
- Target model: Codex CLI (Dev execution).
- Branch/PR policy:
  - **DO NOT push to `main`**. Work on a feature branch and open a PR.
  - PR must pass required checks: **packets-gate**, **gdscript-lint**.

## Files allowed to modify (explicit)
- `godot/**`
- `docs/PACKETS/**` *(update STATE_PACKET at end)*
- `docs/QA_REPORT.md` *(append note if useful)*

## Read first
- `docs/PACKETS/STATE_PACKET.md`
- `docs/PACKETS/QA_PACKET.md`
- `docs/QA_REPORT.md` (latest)

## Context
- Manual feedback (TC01/min): Commit(LOCK) distinction is clear within ~10s via **SFX + color change**.
- Improvement request: add a more explicit **pre-crash anticipation motion** right before the crash/execute moment.

## Requirements
### Must (what to build)
1) Add a small, readable anticipation cue right before execute/crash.
   - Prefer **animation/motion** (e.g., brief wind-up, squash/stretch, recoil, pose hold, or micro-telegraph accent) over new VFX systems.
   - Cue should be visible even with minimal art.
2) Do not change combat rules / timings drastically.
   - Keep gameplay feel the same; only improve readability.
3) Update `docs/PACKETS/STATE_PACKET.md` at end:
   - Current build / Current focus / Known issues / Next actions (only these sections)

### Must NOT
- No new mechanics, no new UI screens.
- No broad refactors.
- Avoid renaming existing event schemas; only add if needed.

## Suggested target
- Primary: `IntentArena_Slasher` (TC01/min context)
- Enemy: Slasher commit/execute sequence.

## Acceptance criteria
- [ ] In `IntentArena_Slasher`, the moment right before execute/crash is noticeably clearer to a novice.
- [ ] No crashes; lint/checks pass.

## Commit message
- Use: `TC01: add pre-crash anticipation cue for lock readability`
