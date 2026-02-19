# QA_REPORT

<!-- DEV_REQUEST:start -->
title: TC04: stop post-collision lateral drift + fix induced_success feedback + audit enemy death cause
priority: P0
scope: godot
acceptance: In TC04 Spike Arena, when Charger hits SpikeWall, (1) Charger does not keep sliding sideways along the wall due to inertia; on first wall collision during execute, lateral velocity is clamped (stop or small repel ok) and the enemy transitions cleanly into recover. (2) "유도 성공" feedback reliably shows on each induced_success trigger per run, including after F5 restart (no one-time-only bug). (3) Add lightweight logging to disambiguate why Charger disappears: distinguish deaths from SpikeWall damage vs player collision damage; ensure player collision does NOT unintentionally damage the enemy unless explicitly intended.
notes: Field test (2026-02-19): damage feedback feels OK; lateral wall drift remains. Observed: Charger disappears after ~13 body-crush contacts with player; if player dodges, Charger can keep charging indefinitely. Observed: "유도 성공" shows only once and not after F5 restart. Also: player can pass through/hide inside SpikeWall (confirm if intended for PoC).
dispatch: hold
<!-- DEV_REQUEST:end -->

<!-- DEV_REQUEST:start -->
title: AUDIO P0: add wall_hit_impact + lock_primary SFX assets (TC04/TC01)
priority: P0
scope: godot
acceptance: (1) `sfx_wall_hit_impact.ogg` and `sfx_lock_primary.ogg` exist under `godot/assets/audio/sfx/` and are loadable in Godot. (2) TC04 SpikeWall enemy hit uses `sfx_wall_hit_impact` (audible, not clipping). (3) TC01 LOCK primary cue uses `sfx_lock_primary` (short, crisp). (4) If any source is not CC0, update credits per repo policy.
notes: Follow sourcing plan `docs/PRODUCTION_PACKS/AUDIO/BC_AUDIO_SFX_SOURCING_PLAN_v003.md`. Keep the sounds short (0.15–0.35s) and phone-speaker readable. Prefer CC0 sources.
dispatch: hold
<!-- DEV_REQUEST:end -->

## 2026-02-17 — DEV-002 smoke + Week 1 logging validation (headless)

### 4) TC04 auto-run (headless)

**Run A**
- Runner: Godot 4.6 console (`--headless`)
- Flags: `--tc04-auto=10 --tc04-timeout=2.0`
- Log: `user://logs/run_2026-02-17T10-45-49.jsonl`
- Result: **0 / 10 success** (timeout=10)

**Run B**
- Runner: Godot 4.6 console (`--headless`)
- Flags: `--tc04-auto=10 --tc04-timeout=6.0`
- Log: `user://logs/run_2026-02-17T10-54-29.jsonl`
- Result: **0 / 10 success** (timeout=10)

Interpretation:
- Autorun loop + logging works.
- Current bait heuristic fails to induce `SpikeWall.induced_success` even with 6s timeout.

Next:
- Improve bait logic (positioning + movement) OR relax/replace the success trigger for automation.

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
