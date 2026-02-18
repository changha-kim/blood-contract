# QA_REPORT

## 2026-02-17 — DEV-002 스모크 + Week 1 로그 스키마 검증 (headless)

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

해석(Interpretation):
- autorun 루프 + 로깅은 동작함.
- 현재 bait(유도) 휴리스틱이 6초 timeout에서도 `SpikeWall.induced_success`를 만들지 못함.

다음(Next):
- bait 로직 개선(포지셔닝 + 이동) **또는** 자동화 성공 트리거를 완화/대체.

---

### Environment (환경)
- Godot: 4.6.stable (console, `--headless`)
- Project path: `blood_contract/godot`
- Runner: local automation script (`res://scripts/qa/qa_smoke_dev002.gd`)

---

### 1) DEV-002 smoke (STATE_PACKET Next actions #1)
**Scenes**
- `res://scenes/levels/TestArena.tscn`
- `res://scenes/levels/IntentArena_Slasher.tscn`

**Checks**
- 60s movement stability (headless approximation): PASS
- Dash cooldown set (>0): PASS (prints `Dash CD: 0.75s`)
- Dash invulnerability toggles on/off within window: PASS
- Attack visibility placeholder: PASS (Line2D debug slash spawns briefly)

---

### 2) Week 1 log validation (STATE_PACKET Next actions #2)
**Goal events (per STATE_PACKET)**
- `run_start`
- `commit_enter`
- `wall_hit`

**What we can confirm right now**
- `run_start`
  - Implemented in code: `scripts/autoload/game_app.gd` logs both Telemetry + EventLogger on `GameApp.start_run()`.
  - NOTE: headless smoke는 씬을 직접 인스턴스화하고 `GameApp.start_run()`을 호출하지 않아서,
    GameApp를 통해 런을 시작하지 않으면 `run_start`가 로그에 나타나지 않음.

- `commit_enter`
  - 현재 코드에서 **리터럴 이벤트명으로는 존재하지 않음**.
  - `run_*.jsonl`에서 관측된 가장 가까운 이벤트:
    - `intent_commit` (EventLogger)
    - `commit_cue_fired` / `commit_micro_slow_*`
  - 권고: `intent_commit`와 동일 지점에서 `commit_enter` alias/bridge 이벤트를 emit (또는 스키마 일치 목적의 rename — 단, rename은 리스크)

- `wall_hit`
  - SpikeWall에서 emit 되는 현재 이벤트명은 `spikewall_hit` (EventLogger), 위치: `scripts/hazards/spike_wall.gd`
  - 권고: 스키마 일치를 위해 `wall_hit` alias 이벤트를 추가 emit (또는 rename)

**Artifacts**
- Telemetry file (stable): `user://logs/app_telemetry.jsonl`
- Per-run/event file (timestamped): `user://logs/run_YYYY-MM-DDTHH-MM-SS.jsonl`

---

### 3) Player feel tuning (STATE_PACKET Next actions #3)
**Source of truth**: `godot/data/defs/player_core.json`

**Current values (unchanged today)**
- move_speed: 340
- dash: speed 900 / duration 0.12 / cooldown 0.75 / invuln 0.12
- attack: hitbox_active 0.09 / auto_aim 220

**Rationale**
- 오늘 QA 스모크는 안정성 중심 + headless라서, 파라미터를 “감(Feel)”로 조정하기엔 신호가 부족.
- 다음 튜닝은 짧은 수동(in-editor) 플레이 이후(TestArena + IntentArena_Slasher) 즉시 진행 권장: 가독성 + TC04 셋업 관점.
