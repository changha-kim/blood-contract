# TASK_PACKET (AUTO) — TC04: stop post-collision lateral drift + fix induced_success feedback + audit enemy death cause

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
In TC04 Spike Arena, when Charger hits SpikeWall, (1) Charger does not keep sliding sideways along the wall due to inertia; on first wall collision during execute, lateral velocity is clamped (stop or small repel ok) and the enemy transitions cleanly into recover. (2) "유도 성공" feedback reliably shows on each induced_success trigger per run, including after F5 restart (no one-time-only bug). (3) Add lightweight logging to disambiguate why Charger disappears: distinguish deaths from SpikeWall damage vs player collision damage; ensure player collision does NOT unintentionally damage the enemy unless explicitly intended.

## Notes
Field test (2026-02-19): damage feedback feels OK; lateral wall drift remains. Observed: Charger disappears after ~13 body-crush contacts with player; if player dodges, Charger can keep charging indefinitely. Observed: "유도 성공" shows only once and not after F5 restart. Also: player can pass through/hide inside SpikeWall (confirm if intended for PoC).
