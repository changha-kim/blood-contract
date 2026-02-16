# DEV_NOTES

## How to run
- Open `blood_contract/godot/project.godot` with **Godot 4.x**
- Press **F5** (Play)

## M0 (BC_POC_S0_M0_BOOTSTRAP) checklist
- Main scene: `res://scenes/ui/MainMenu.tscn`
- Start flow: MainMenu → Start → `res://scenes/levels/TestArena.tscn`
- Autoloads:
  - `res://scripts/autoload/game_app.gd`
  - `res://scripts/autoload/run_manager.gd`
  - `res://scripts/autoload/data_repo.gd`
  - `res://scripts/autoload/telemetry.gd`
- Telemetry output: `user://logs/app_telemetry.jsonl`
- Data defs directory: `res://data/defs/` (missing dir/file should not crash; warnings only)
- Build/QA placeholders:
  - `res://tools/build/export_desktop.bat`
  - `res://tools/build/export_android.bat`
  - `res://tools/qa/parse_logs.py`

---

## (Later milestone notes)

Implemented:
- Player (top-down): movement + melee attack + dash (cooldown + brief invulnerability)
- Reusable components: HealthComponent, Hurtbox, Hitbox
- DummyTarget debug enemy (HP label)
- Debug HUD: FPS / Player HP / Dash cooldown remaining / Scene name / Run timer
- Telemetry (JSONL): player_move, player_attack, player_dash, damage_dealt, damage_taken

## Controls (desktop)
- Move: **WASD / Arrow keys** (`move_up/down/left/right`)
- Attack: **F** (`attack_btn`)
- Dash: **Space** (`dash_btn`)
- Back to Main Menu: **Esc** (`pause`)

## How to test (Acceptance Criteria)
1) Run project → MainMenu → **Start** (loads TestArena)
2) **AC1** Player moves with WASD and can Attack (F) and Dash (Space)
3) **AC2** Stand near DummyTarget(s) and press **F** → Dummy HP label decreases
4) **AC3** Press **Space** repeatedly → dash is blocked during cooldown; HUD shows cooldown countdown
5) **AC4** Inspect logs under `user://logs/` (see Project Settings → Application → User Data Dir)
   - Confirm JSONL events include: `player_attack`, `player_dash`, `damage_dealt`, `damage_taken`

## Tuning (data-driven)
File: `res://data/defs/CombatTuning.json`
- `player.move_speed`
- `player.attack.hitbox_active_sec`
- `player.attack.auto_aim_range_px`
- `player.dash.*` (speed/duration/cooldown/invuln)

## Notes / Known limitations
- Auto-aim: selects nearest node in group `targetable` with a child node named `Hurtbox`.
- DummyTarget(s) are placed in TestArena for PoC verification.
