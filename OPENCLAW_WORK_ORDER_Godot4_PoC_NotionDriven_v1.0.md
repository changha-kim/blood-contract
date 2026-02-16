# [OpenClaw Work Order] Godot4 PoC (Notion-driven) v1.0

Project: Blood Contract (PoC)
Engine: Godot 4.x
Language: GDScript (static typing mandatory)
Platform: Android-first (PoC)

## GLOBAL RULES
- Implement in small milestones with runnable builds each milestone.
- Use modular Scenes/Nodes. No god-scripts.
- Every milestone must ship with:
  1) Godot project that runs
  2) A short `CHANGELOG.md`
  3) A “How to test” checklist referencing `DB_EXPERIMENTS` test cases

## DATA SOURCE RULES
- Treat Notion as source of truth:
  - DB_SYSTEMS: feature specs
  - DB_CONTENT: enemies/rooms/cards/hazards/boss
  - DB_EXPERIMENTS: test cases (Planned)
  - DB_BUILDS: build tracking
- Only implement items where `PoC Scope = true`.
- Export Notion DB rows to local JSON in `res://data/notion_export/` (or generate Godot Resource `.tres` files).
- Keep data-driven balance values in JSON/Resources (not hard-coded).

## MILESTONE PLAN (GATED)

### M0 — Repo/Project Bootstrap (No Gameplay)
Goal: create a clean Godot 4 project skeleton + Android export baseline.

Deliverables:
- Folder structure:
  - `res://scenes/` `res://scripts/` `res://data/` `res://ui/` `res://audio/` `res://art/`
- Autoloads:
  - `GameApp` (app state)
  - `RunManager` (run lifecycle)
  - `DataRepo` (loads JSON/Resources)
- InputMap for mobile:
  - `move_stick`, `attack_btn`, `dash_btn`, `skill1_btn`, `pause`
- Basic UI: `MainMenu -> Start -> loads TestArena`
- Android export preset saved

Exit criteria:
- Runs on desktop + can export Android APK without errors.

---

### M1 — Player + Combat Core (No Enemy AI yet)
Goal: Player controller + HP/Damage + hit detection + debug HUD.

Implement:
- Player (`CharacterBody2D`)
  - move (stick)
  - attack (auto-aim assisted)
  - dash (invuln window param)
- Damage system:
  - `HealthComponent`, `Hurtbox/Hitbox`
- Debug HUD:
  - FPS, run timer, current room, current synergy levels (placeholder)

Exit criteria:
- Player can move/attack/dash and see debug HUD.

---

### M2 — Intent Combat State Machine (Telegraph→Commit→Execute→Recover)
Goal: make our USP visible even with 1 enemy.

Implement:
- `EnemyBase` with state machine:
  - `ChooseIntent -> Telegraph -> Commit(LOCK) -> Execute -> Recover`
- Telegraph UI:
  - ground shape (line/cone/circle)
  - damage number
- Commit UI:
  - “lock” icon/sfx + thicker outline
  - direction/target cannot change after commit
- Start with `ENY_SLASHER` only (from DB_CONTENT)

Tests to run:
- TC01 Commit understanding (no tutorial)

Exit criteria:
- TC01 can be executed end-to-end in a single arena.

---

### M3 — Spike Wall + Knockback + Anti-cheese
Goal: make the 3-second trailer moment possible.

Implement:
- `HZD_SPIKE_WALL` (collision + rules + internal cooldown)
- Knockback physics:
  - weight/resistance
  - prevent infinite loop (i-frames)
- Add `ENY_CHARGER` (Bull Charge intent)
- Add `ROOM_GAUNTLET_LANE` as a test arena layout

Tests to run:
- TC03 SpikeWall cheese loop
- TC04 Charger showcase moment

Exit criteria:
- In 5 attempts, a novice can land at least 1 SpikeWall success (tunable).

---

### M4 — Rooms + Run Loop (5 rooms + miniboss)
Goal: close the loop to an actual run.

Implement:
- Room scenes for 5 rooms from DB_CONTENT
- `RoomSpawner` + spawn table per room
- Run flow:
  - `StartRun -> Room1..Room5 -> MiniBoss -> End(Extract/Death)`
- Implement `ENY_ARBALIST` + `BOSS_BAILIFF`
- Basic pause + restart

Tests:
- TC02 Telegraph clarity stress (Ledger Court)
- TC07 Runtime target (6~10 minutes)
- TC08 Fairness death reasons (tag A/B/C)

Exit criteria:
- A full run can complete (even if balance is rough).

---

### M5 — Cards/Tags/Synergy (18 cards)
Goal: build-explosion (B) can happen in PoC.

Implement:
- Card reward UI after each room:
  - show 3 cards, pick 1, 1 reroll
  - show Benefit / Debt clearly
- Tag system + synergy thresholds 2/3/4
- Implement synergy effects minimally (define in data table)
- Use 18 PoC cards from DB_CONTENT

Tests:
- TC05 synergy tier 3 average 1 per run (tuning pass)
- TC06 card UI comprehension
- TC10 build variety distribution

Exit criteria:
- At least one synergy tier 3 produces a noticeable gameplay change.

---

### M6 — Mobile Polish + Performance Smoke
Goal: Android-first playability.

Implement:
- Mobile UI scaling, safe areas
- Touch controls feel pass (deadzone, aim assist)
- Performance check scenes (Ledger Court stress)
- Export APK build

Tests:
- TC09 Android performance smoke
- Re-run TC01/TC04 quickly on device

Exit criteria:
- No critical input lag; FPS drop does not destroy “read commit” gameplay.

## OUTPUTS PER MILESTONE
- Tag builds in DB_BUILDS (poc-0.1.x)
- Update `CHANGELOG.md`
- Link build + test notes to Notion DB_BUILDS/DB_EXPERIMENTS where possible
