# TASK_PACKET (Dev / Codex)

## Task
- Issue: **LOG-001 — Week1 logging schema alignment (commit_enter / wall_hit aliases)**
- Target model: **gpt-5.3-codex (big)**
- Branch/PR policy:
  - **DO NOT push to `main`**. Work on a feature branch and open a PR.
  - PR must pass required checks: **packets-gate**, **gdscript-lint**.

## Files allowed to modify (explicit)
- `godot/**`
- `docs/PACKETS/**` *(update STATE_PACKET at end if needed)*
- `docs/QA_REPORT.md` *(append note if useful)*

## Read first
- `docs/PACKETS/STATE_PACKET.md`
- `docs/PACKETS/QA_PACKET.md` (Week1 scope)
- `docs/QA_REPORT.md` (latest findings)

## Context
Current logs emit related-but-different event names:
- Enemy commit: `intent_commit` (EventLogger) + `commit_*` events.
- Spike wall: `spikewall_hit` (EventLogger).
STATE_PACKET Week1 schema expects:
- `run_start`
- `commit_enter`
- `wall_hit`

We want schema alignment **without breaking existing tooling**.

## Requirements
### Must (what to build)
1) **Emit `commit_enter`** as an *alias event* when an enemy enters commit.
   - Keep existing `intent_commit` event unchanged.
   - `commit_enter` payload must include at least:
     - `run_id` (from `RunManager.current_run_id` if available)
     - `enemy_id`
     - `intent_id`
     - `ts_msec`

2) **Emit `wall_hit`** as an *alias event* when spike wall hit occurs.
   - Keep existing `spikewall_hit` unchanged.
   - `wall_hit` payload must include at least:
     - `run_id`
     - `wall_id`
     - `target_id`
     - `target_type` (player/enemy)
     - `damage`
     - `ts_msec`

3) **Do not rename existing events.** Only add aliases.

4) Update `docs/PACKETS/STATE_PACKET.md` at end:
   - Known issues: remove/update items if resolved
   - Next actions: adjust (log validation step should become easier)

### Must NOT (scope cut)
- No new gameplay mechanics
- No refactors unrelated to logging
- No breaking changes to existing JSONL formats

## Acceptance criteria
- [ ] Running the game produces `commit_enter` and `wall_hit` lines in `user://logs/run_*.jsonl`.
- [ ] Existing `intent_commit` and `spikewall_hit` events still appear.
- [ ] PR opened from feature branch; required checks pass.

## Commit message format
- Use: `LOG-001: add commit_enter + wall_hit alias events`
