# QA_REPORT — S1 (M1 Player Core) Verification

**Date:** 2026-02-15  
**Milestone:** S1 (M1 Player Core)  
**Result:** **PASS**

## What Passed (Gates)
- **Scene flow:** MainMenu → Start → TestArena (telemetry-backed).
- **HUD:** FPS + run timer + room + synergy placeholder visible (screenshot-backed).
- **Player core:**
  - Move (telemetry `player_move` start/stop).
  - Attack (telemetry `player_attack`).
  - Damage loop works end-to-end (telemetry `damage_dealt` observed; dummy takes damage via Hitbox→Hurtbox→Health).
- **Logs available** and usable for acceptance verification.

## Evidence (Pointers)
- **HUD screenshot:** (as provided by tester)
  - Save target: `blood_contract/test_results/2026-02-15/artifacts/S1_HUD.png`
- **Telemetry log** (contains `player_attack`, `damage_dealt`):
  - `user://logs/app_telemetry.jsonl`
  - Desktop expected: `%APPDATA%\Godot\app_userdata\Blood Contract PoC\logs\app_telemetry.jsonl`
- **Per-run log** (if captured):
  - `user://logs/run_*.jsonl`
  - Desktop expected: `%APPDATA%\Godot\app_userdata\Blood Contract PoC\logs\run_*.jsonl`

## Notes / Risks
- **Dash invulnerability not explicitly proven** via a “damage attempted during dash” scenario in the supplied evidence.
  - Recommendation: add a controlled damage source in the next sprint to hard-verify i-frames via logs/clip.

## Next Sprint Recommendation (Short)
- Proceed to **USP validation path** (per QA priority):
  - Run **TC01 next** (Commit 이해도, no tutorial) using existing commit cue telemetry (`commit_cue_fired` in logs).
  - Then **TC04** when Charger/SpikeWall are available.
- Add **one deterministic player damage source** in TestArena (e.g., simple hazard or enemy swing) to verify dash i-frames with measurable criteria (attempt count vs `damage_taken` during dash window).
