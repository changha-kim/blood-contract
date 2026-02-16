# How to test

Prereq: Godot 4.x installed.

## S1 / M1 Smoke (Player Core + Damage + Debug HUD)
Ref TC scaffolding: **TC07 (runtime timer visible)**, **TC09 (FPS visible)**.

1) Run
- Open `res://project.godot`
- Press **Play** → MainMenu
- Click **Start** → TestArena
- Confirm no blocking errors; keep playing 60 seconds.

2) Player Core
- Move: **WASD / Arrow keys**
- Attack: **F** (`attack_btn`)
- Dash: **Space** (`dash_btn`)
- Confirm dash cooldown is enforced and displayed.

3) Damage plumbing
- Attack DummyTarget(s) until HP reaches 0 (death/disable is acceptable)
- Confirm one attack swing does not multi-tick damage on the same dummy.

4) Debug HUD (always-on in TestArena)
- Confirm **FPS** updates (TC09)
- Confirm **Run timer** increments after Start (TC07)
- Confirm scene name + Player HP + Dash CD are visible

---

## S0 / M0 (Bootstrap)

## AC1 — MainMenu → Start → TestArena
- Open `res://project.godot`.
- Press **Play**.
- Verify **MainMenu** appears.
- Click **Start**.
- Verify **TestArena** loads.
- Press **Esc** (or click **Back to Main Menu**) to return.

## AC2 — Telemetry logs exist (JSONL)
- While running, after pressing Start at least once, locate logs:
  - Godot: Project Settings → Application → Config → **Use Custom User Dir** (depends)
  - Runtime path is `user://logs/`
- Confirm file exists:
  - `user://logs/app_telemetry.jsonl`
- Confirm it contains at least these events (one JSON per line):
  - `app_start`
  - `scene_loaded` (MainMenu/TestArena)
  - `run_start`

## AC3 — DataRepo scans res://data/defs gracefully
- Ensure `res://data/defs/` exists (it does).
- Optional: delete/move all json files in that folder.
- Run the project; confirm it does NOT crash (warnings are OK).

## Notes
- S0 has **no gameplay** and no Spike Wall.
