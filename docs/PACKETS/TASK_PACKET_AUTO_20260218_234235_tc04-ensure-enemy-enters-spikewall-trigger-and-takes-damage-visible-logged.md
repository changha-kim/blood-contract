# TASK_PACKET (AUTO) — TC04: ensure enemy enters SpikeWall trigger and takes damage (visible + logged)

## Task
- Priority: P0
- Source: C:\Users\schlo\.openclaw\workspace\blood_contract\docs\QA_REPORT.md
- Trigger: DEV_REQUEST block (dispatch: now)

## Requirements
- Scope: minimal change, focused on request.
- Must follow repo policy:
  - Read `docs/PACKETS/STATE_PACKET.md` and relevant packets.
  - Modify only allowed paths for the request (default: `godot/**` + `docs/PACKETS/**`).
  - Update `docs/PACKETS/STATE_PACKET.md` (only: Current build / Current focus / Known issues / Next actions).
  - Create feature branch, commit, push, and open PR.

## Acceptance
In TC04 Spike Arena, when Charger collides with SpikeWall during commit/execute, SpikeWall damage must actually apply at least once per 10 attempts (manual). Evidence: log contains spikewall_hit(target_type=enemy, damage>0) and/or wall_hit(target=enemy, damage>0) and on-screen feedback (SPIKE HIT!/equivalent) is shown.

## Notes
Repo is on main a6ce10c with SPIKE HIT! implemented in SpikeWall, but manual play still shows 0/5 visible hits and no feedback; likely trigger/layer/mask/shape prevents enemy Hurtbox from entering SpikeWall Trigger area. Fix minimal and TC04-specific if needed. Do not rename events; keep spikewall_hit + wall_hit alias.
