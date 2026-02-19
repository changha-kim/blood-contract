# TASK_PACKET (AUTO) — Integrate stesproject Godot 4 topdown template (combat skeleton extraction)

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
(1) Import/port a minimal combat skeleton from https://github.com/stesproject/godot-2d-topdown-template into `blood_contract/godot/` without breaking existing TC01/TC04 scenes. (2) Player has fast topdown movement + dash/flash + basic melee attack + i-frames (if present in template) wired to existing input map or a minimal compatible one. (3) Hurtbox/Hitbox/Health/Knockback are componentized and usable by existing enemies (at least Charger) with minimal glue. (4) Provide a small "Playground" scene to validate feel quickly (move/dash/attack/hit). (5) Keep our core rule integration path clear: enemy FSM supports Telegraph→LOCK→Execute→Recover states (can be stubbed but architecture must support it).

## Notes
Do NOT wholesale replace our project; extract only needed modules. Prefer keeping existing autoloads (DataRepo/EventLogger/Feedback/RunManager) and integrate template code around them. Remove/avoid nonessential systems (inventory/dialogue/save) for PoC. Record license attribution (MIT) + source URL in a new `docs/CREDITS.md` entry.
