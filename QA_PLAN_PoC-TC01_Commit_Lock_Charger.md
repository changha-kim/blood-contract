# QA Plan (Notion Source‑of‑Truth) — EXP PoC‑TC01 Commit(잠금)

엄밀 버전: **수치/규칙/엣지/판정 근거**를 아래 5개 Notion 페이지에서 직접 인용/반영.

## Source of truth (Notion)
- EXP | PoC‑TC01 | Commit(잠금) 이해도 — 무설명 학습
  - https://www.notion.so/EXP-PoC-TC01-Commit-307777a0189881c9a83aca00ba6e49a6?pvs=26
- SYS | Intent Combat (Telegraph→Commit→Execute)
  - https://www.notion.so/SYS-Intent-Combat-Telegraph-Commit-Execute-307777a01898814a9d3df5820fce8fe9?pvs=26
- ENY | Charger (Inquisitor Ram)
  - https://www.notion.so/ENY-Charger-Inquisitor-Ram-307777a0189881acb080d77158e88064?pvs=26
- HZD | Spike Wall
  - https://www.notion.so/HZD-Spike-Wall-307777a0189881168b0eedc267753885?pvs=26
- ROOM | Thorn Hall
  - https://www.notion.so/ROOM-Thorn-Hall-307777a01898812daa2af14de711e2b7?pvs=26

---

## 0) What this experiment must prove (EXP + SYS acceptance)
- “텍스트 설명 없이도 ‘Commit=확정(잠금)’을 플레이어가 **행동으로** 이해” (EXP Goal)
- “유도 성공(Spike Wall hit 유도)”을 **2분 내 ≥1회** 만들 수 있음 (EXP Pass)
- Commit 이후 “의도/방향은 바뀌지” 않는다는 전술적 전제가 전달됨 (SYS Goal)
- 결과적으로 “사망 원인이 억울함보다 판단 실수로 설명 가능” (SYS Acceptance)

---

## 1) Canonical setup (from EXP + ROOM + ENY + HZD)
### Test room
- **TC01 공식 실험 장소: 1룸 튜토리얼 고정**
- (Reference only) ROOM: Thorn Hall
  - Layout: “직사각형 + 한 면 Spike Wall”
  - Spawns: “Slasher x2”
  - Target clear time: “60~75s”

### Enemies
- EXP Setup: “Charger 1 또는 Slasher 1”
- ENY Charger intents (must exist to claim spec compliance):
  - Bull Charge (primary for showcase)
    - Telegraph: “thick line 6m + big dmg number”
    - Commit: “LOCK direction + 0.2s prep”
    - Execute: “charge, stops on collision”
    - Recover: “0.90s (wall hit: 1.20s)”
  - Shoulder Smash
    - Telegraph: “circle 2.0m”
    - Commit: “LOCK position”
    - Recover: “0.80s”

### Hazard
- EXP Setup: “지형: Spike Wall 필수”
- Spike Wall rules (HZD):
  - Enemy hit: damage = enemy maxHP * 0.20, stun=0.35s, internal cooldown=0.8s
  - Player hit: damage = player maxHP * 0.08, small knockback only (억울함 방지)
  - Feedback: “Metal hit SFX + sparks VFX + damage number”
  - “유도 성공 순간은 슬로우/텍스트로 강조” (also aligns with SYS Mobile UX)

### System UX (must be observable)
From SYS Core Rules:
- Telegraph: “공격 형태(선/원/콘) + 예상 피해(숫자) 표시”
- Commit: “방향/대상 확정(아이콘 자물쇠 + 궤적 실선/굵게)”
From SYS Mobile UX:
- “위험 Intent만 강하게 표시(최대 3개)”
- “Commit 순간 0.1s 마이크로 슬로우(옵션)”

---

## 2) Metrics model (EXP Facts → QA record schema)
EXP Metrics (Facts):
- (M1) Commit을 “이해한 행동 변화”가 나타난 시점(몇 초/몇 회)
- (M2) 유도 성공 횟수(Spike Wall hit 유도)
- (M3) “억울함” 발언/행동(분노/혼란) 발생 여부

### Operational definitions
**M1: ‘이해한 행동 변화’**
Record first timestamp where player intentionally uses “Commit 이후에는 공격이 바뀌지 않는다” 전제를 활용.
- Examples:
  - Wait through Telegraph; move only after Commit to prove lock.
  - Step-aside after Commit to make Bull Charge hit Spike Wall.
Record both:
- `m1_time_sec` (first telegraph exposure → first qualifying behavior)
- `m1_cycle_index` (which intent cycle; EXP requires ≥3 cycles exposed)

**M2: ‘유도 성공’ count**
Count **1** when:
- **Enemy Spike Wall 피해/스턴 적용 이벤트가 1회 발생**(= 유효 판정 1회)
  - 판정 근거: Spike Wall 히트 피드백(SFX/VFX/데미지 넘버) 및/또는 enemy에 spec’d damage/stun 적용
Edge / anti-double-count:
- Spike Wall 연속 접촉(틱)은 내부 쿨다운 **ICD 0.8s**로 **중복 카운트 금지**
- 운영상 더 보수적으로 기록하려면: 새 **Commit** 사이클을 경계로만 1회로 카운트(권장)

**M3: ‘억울함’**
Record:
- `m3_flag` Y/N
- `m3_quote` verbatim if possible
- `m3_context` (intent/hazard/visibility/input)

---

## 3) Pass/Fail (verbatim criteria from EXP)
### PASS
- “설명 없이도 2분 내 1회 이상 유도 성공이 발생”
- “플레이어가 ‘저거 고정되네/확정되네’ 류의 말이나 행동을 보임”

### FAIL
- “Commit과 Telegraph의 차이를 구분 못함(계속 피하기만 하거나 무의미한 충돌 반복)”
- “유도 성공이 0회이고 ‘왜 맞는지 모르겠다’ 반응이 강함”

### MIXED (QA 운영값)
EXP가 PASS/FAIL 외 상태를 정의하진 않지만, 실무상 아래는 MIXED로 기록(개선 스프린트 도출 목적):
- Commit 이해 행동은 관찰되나, 룸/벽/스폰/충돌/ICD 때문에 2분 내 유도 성공이 구조적으로 어려움
- 유도 성공은 있으나 “고정/확정” 언행/행동 근거가 약함

---

## 4) Test cases — priority, steps, metrics, expected, logging

### TC01‑P0 — EXP PoC‑TC01 본시험(무설명 학습)
**Priority:** P0

**Setup (must match EXP)**
- Player instruction: “공격/대시만” 안내, Commit 설명 금지
- Room: **1룸 튜토리얼(공식 고정)**
- Enemy: Charger 1 또는 Slasher 1
- Hazard: Spike Wall 필수
- Ensure enemy performs Telegraph→Commit→Execute at least **3 cycles** (EXP Step 2)

**Timebox:** 2:00 (EXP Pass)

**Steps**
1) Start timer on first telegraph exposure.
2) Let enemy run ≥3 Telegraph→Commit→Execute cycles.
3) Observe for M1 qualifying behavior (post‑commit exploit attempt).
4) Attempt lure into Spike Wall (prefer Charger Bull Charge).
5) Record M2 count and any M3 unfair/confusion signals.

**Record**
- M1: m1_time_sec, m1_cycle_index, concrete description of behavior.
- M2: lure_success_count (distinct commits only).
- M3: flag + quote + context.

**Expected (PASS target)**
- Within 2 minutes: M2 ≥ 1
- “고정/확정” understanding evidenced by 말/행동

**Evidence / logging locations**
- Result file: `test_results/YYYY-MM-DD/TC01P0_commit_lock.md`
- Video clip(s): `test_results/YYYY-MM-DD/artifacts/TC01P0_*.mp4`
- Optional telemetry (project standard): `user://logs/app_telemetry.jsonl`

---

### TC01‑P0‑SETUP — 1룸 튜토리얼 실험 세팅 스모크(유도 성공 가능성)
**Priority:** P0

**Goal**
Make sure the EXP’s M2 (Spike Wall hit 유도) is physically possible in the **official TC01 room (1-room tutorial)**.

**Steps (≤5 min)**
1) Confirm 1룸 튜토리얼에 Spike Wall이 존재하며, 유도 가능한 동선/레인이 있다.
2) Confirm Spike Wall feedback: metal hit SFX / sparks VFX / damage number.
3) For Charger: confirm Bull Charge telegraph (thick line 6m + big dmg number) appears.
4) Try 3 quick lures; verify charge stops on collision and wall-hit recover is noticeably longer (1.20s vs 0.90s).

**Record**
- Setup OK? Y/N
- If N: which spec is missing/broken (telegraph shape, lock icon/solid trajectory, hazard feedback, collision stop, etc.)

**Expected**
- Setup OK = Y, otherwise TC01‑P0 is blocked/misleading.

---

### TC01‑P1 — Failure taxonomy (root cause for sprint planning)
**Priority:** P1 (run only if TC01‑P0 is FAIL or MIXED)

**Goal**
Turn failures into actionable buckets tied to SYS/ENY/HZD/ROOM specs.

**Steps (10–20 min)**
Re-run short attempts; for each non-success attempt, tag failure reason:
- SYS‑UX: Telegraph shape/dmg number not readable
- SYS‑UX: Commit cues missing (lock icon + solid/thick trajectory)
- SYS‑UX: micro slow missing/too subtle (0.1s) — if implemented
- ENY: Bull Charge not locking direction / prep 0.2s too short/long
- ENY: Charge not stopping on collision / wall-hit recover not distinct (1.20s)
- HZD: Spike Wall feedback missing / ICD behavior confusing (0.8s)
- ROOM: Lane geometry makes luring unrealistic
- Other: input/camera/perf

**Record**
- Top 3 reasons + evidence timestamps.

---

### TC03‑P1 — Anti‑cheese regression (SYS Anti‑cheese + HZD ICD)
**Priority:** P1

**Goal**
Verify no infinite pin loop:
- Spike Wall damage ICD = 0.8s
- Knockback resistance i‑frames = 0.4s

**Steps (2–3 min)**
1) Attempt to chain knockbacks into Spike Wall repeatedly.
2) Verify resistance/i‑frames or behavior prevents “infinite lock”.

**Record**
- Can you lock infinitely? Y/N
- If Y: exact repro steps (critical)

---

## 5) Output artifacts & storage
- Store results in: `blood_contract/test_results/YYYY-MM-DD/`
- Store clips/screens: `blood_contract/test_results/YYYY-MM-DD/artifacts/`

---

## 6) Templates (copy/paste)
- DoD tracking: `blood_contract/test_results/templates/DOD_TEMPLATE_EXP_TC01.md`
- Result write-up (TC01 P0): `blood_contract/test_results/templates/RESULT_TEMPLATE_TC01_P0.md`
- Measurement procedure (Charger timings): `blood_contract/test_results/templates/MEASUREMENT_PROCEDURE_CHARGER_TIMINGS.md`