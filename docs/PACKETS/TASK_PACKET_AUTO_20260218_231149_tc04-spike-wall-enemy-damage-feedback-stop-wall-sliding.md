# TASK_PACKET (AUTO) — TC04: spike wall enemy damage feedback + stop wall sliding

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
In TC04 Spike Arena, when Charger hits SpikeWall, player gets clear confirmation (SFX or on-screen text) and log includes wall_hit(target=enemy, damage>0). Charger should not keep sliding/crushing along the wall after impact (short stop/stun/repel ok).

## Notes
Manual TC04 (2026-02-18): 0/5 had any damage feeling; no audible SFX; only “hit wall then slide forward”. Keep changes minimal; do not rename events.
