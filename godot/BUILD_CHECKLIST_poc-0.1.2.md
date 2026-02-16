# Build Checklist — poc-0.1.2 (Desktop)

## Pre-flight
- [ ] Project runs in-editor without errors.
- [ ] MainMenu → Start routes to `IntentArena_Slasher` and player is controllable.
- [ ] Logs written under `user://logs/` (Windows: `%APPDATA%\Godot\app_userdata\Blood Contract PoC\logs\`).

## Export (Godot Editor)
- [ ] Project → Export…
- [ ] Preset exists: **Windows Desktop**
- [ ] Export path set to: `res://build/BloodContractPoC_poc-0.1.2.exe`
- [ ] Export filter: **All Resources**
- [ ] Templates installed (Godot will prompt if missing)
- [ ] Click **Export Project**

## Smoke test (exported exe)
- [ ] Launch exported exe
- [ ] ≤2 clicks to enter IntentArena_Slasher and move
- [ ] `app_telemetry.jsonl` contains `run_start` and `room_enter` for `ROOM_INTENT_ARENA_SLASHER`
- [ ] At least one `commit_cue_fired` observed during a short run

## Packaging
- [ ] Zip: `build/BloodContractPoC_poc-0.1.2.exe` (+ any required dll/pck if Godot produces them)
- [ ] Include: `CHANGELOG.md` excerpt or link
- [ ] Note log location for QA
