# QA_REPORT

## 2026-02-17 — DEV-002 smoke + Week 1 logging validation (headless)

### Environment
- Godot: 4.6.stable (console, `--headless`)
- Project path: `blood_contract/godot`
- Runner: local automation script (`res://scripts/qa/qa_smoke_dev002.gd`)

### 1) DEV-002 smoke (STATE_PACKET Next actions #1)
**Scenes**
- `res://scenes/levels/TestArena.tscn`
- `res://scenes/levels/IntentArena_Slasher.tscn`

**Checks**
- 60s movement stability (headless approximation): PASS
- Dash cooldown set (>0): PASS (prints `Dash CD: 0.75s`)
- Dash invulnerability toggles on/off within window: PASS
- Attack visibility placeholder: PASS (Line2D debug slash spawns briefly)

### 2) Week 1 log validation (STATE_PACKET Next actions #2)
**Goal events (per STATE_PACKET)**
- `run_start`
- `commit_enter`
- `wall_hit`

**What we can confirm right now**
- `run_start`
  - Implemented in code: `scripts/autoload/game_app.gd` logs both Telemetry + EventLogger on `GameApp.start_run()`.
  - NOTE: Our headless smoke instantiates scenes directly and does **not** call `GameApp.start_run()`, so `run_start` will not appear unless the run is started through GameApp.

- `commit_enter`
  - **Not found as a literal event name** in current code.
  - Closest existing events observed in `run_*.jsonl`:
    - `intent_commit` (EventLogger)
    - `commit_cue_fired` / `commit_micro_slow_*`
  - Recommendation: add an alias/bridge event `commit_enter` emitted at the same point as `intent_commit` (or rename for schema consistency).

- `wall_hit`
  - Current event name emitted by SpikeWall is `spikewall_hit` (EventLogger) in `scripts/hazards/spike_wall.gd`.
  - Recommendation: add an alias event `wall_hit` (or rename) to match the Week 1 schema.

**Artifacts**
- Telemetry file (stable): `user://logs/app_telemetry.jsonl`
- Per-run/event file (timestamped): `user://logs/run_YYYY-MM-DDTHH-MM-SS.jsonl`

### 3) Player feel tuning (STATE_PACKET Next actions #3)
**Source of truth**: `godot/data/defs/player_core.json`

**Current values (unchanged today)**
- move_speed: 340
- dash: speed 900 / duration 0.12 / cooldown 0.75 / invuln 0.12
- attack: hitbox_active 0.09 / auto_aim 220

**Rationale**
- Today’s QA smoke was stability-focused and headless; it does not provide enough “feel” signal to justify parameter changes without a manual in-editor playtest.
- Next tuning pass should be done immediately after a short manual playtest (TestArena + IntentArena_Slasher) focusing on readability + TC04 setup.
