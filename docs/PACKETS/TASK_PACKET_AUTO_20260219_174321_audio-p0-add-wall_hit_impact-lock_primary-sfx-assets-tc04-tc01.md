# TASK_PACKET (AUTO) — AUDIO P0: add wall_hit_impact + lock_primary SFX assets (TC04/TC01)

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
(1) `sfx_wall_hit_impact.ogg` and `sfx_lock_primary.ogg` exist under `godot/assets/audio/sfx/` and are loadable in Godot. (2) TC04 SpikeWall enemy hit uses `sfx_wall_hit_impact` (audible, not clipping). (3) TC01 LOCK primary cue uses `sfx_lock_primary` (short, crisp). (4) If any source is not CC0, update credits per repo policy.

## Notes
Follow sourcing plan `docs/PRODUCTION_PACKS/AUDIO/BC_AUDIO_SFX_SOURCING_PLAN_v003.md`. Keep the sounds short (0.15–0.35s) and phone-speaker readable. Prefer CC0 sources.
