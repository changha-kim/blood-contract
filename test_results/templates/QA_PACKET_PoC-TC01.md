# QA_PACKET — EXP PoC‑TC01 Commit(잠금) (Notion source‑of‑truth)

Audience: Planner + Dev

## Notion references
- EXP TC01: https://www.notion.so/EXP-PoC-TC01-Commit-307777a0189881c9a83aca00ba6e49a6?pvs=26
- SYS Intent Combat: https://www.notion.so/SYS-Intent-Combat-Telegraph-Commit-Execute-307777a01898814a9d3df5820fce8fe9?pvs=26
- ENY Charger: https://www.notion.so/ENY-Charger-Inquisitor-Ram-307777a0189881acb080d77158e88064?pvs=26
- HZD Spike Wall: https://www.notion.so/HZD-Spike-Wall-307777a0189881168b0eedc267753885?pvs=26
- ROOM Thorn Hall: https://www.notion.so/ROOM-Thorn-Hall-307777a01898812daa2af14de711e2b7?pvs=26

## What to run NEXT (ordered)
P0
1) TC01‑P0‑SETUP (≤5 min) — **1룸 튜토리얼(공식)** / Charger / Spike Wall 스모크
2) TC01‑P0 (2:00) — 무설명 Commit 이해도 + 유도 성공

P1 (only if TC01 is FAIL/MIXED)
3) TC01‑P1 — failure taxonomy
4) TC03‑P1 — anti‑cheese (Spike Wall ICD 0.8s + knockback i‑frames 0.4s)

## Environment
- Build id / commit: _______
- Platform: Desktop / Android (device model: _______)
- Input: KB/M / Controller / Touch
- Audio: ON (Spike Wall / 유도 성공 feedback)
- Recording: ON

## TC01‑P0‑SETUP (≤5 min)
**Spec checks**
- **TC01 공식 실험 장소: 1룸 튜토리얼 고정**
- 1룸 튜토리얼: Spike Wall 존재 + 유도 가능한 동선/레인
- Spike Wall feedback: metal hit SFX + sparks VFX + damage number
- Charger Bull Charge telegraph: thick line 6m + big dmg number
- Charger commit: lock direction + 0.2s prep
- Execute: charge stops on collision
- Recover difference: 0.90s vs wall-hit 1.20s

**Record**
- Setup OK? Y/N + missing/broken spec

## TC01‑P0 (2 minutes)
**EXP Steps**
1) Player instruction limited to “공격/대시만”; Commit 설명 금지
2) Ensure enemy performs Telegraph→Commit→Execute at least 3 cycles
3) Observe if player uses “Commit 이후 공격이 바뀌지 않는다” to bait into wall

**Metrics (Facts)**
- (M1) 이해 행동 변화 시점: ___ sec / ___ cycles
- (M2) 유도 성공 횟수(Spike Wall hit 유도): ___
  - 판정: **Enemy Spike Wall 피해/스턴 적용 이벤트 1회 = 1카운트**
  - 주의: 연속틱은 ICD 0.8s로 **중복 카운트 금지**
- (M3) “억울함” 발언/행동(분노/혼란): Y/N (quote: ___)

**Pass/Fail (from EXP)**
- PASS: 2분 내 유도 성공 ≥1 AND “고정/확정” 류 말/행동
- FAIL: Commit vs Telegraph 구분 못함 OR 유도 0회 + ‘왜 맞는지 모르겠다’ 강함

## Output
- Results (storage): `test_results/YYYY-MM-DD/TC01P0_commit_lock.md`
- Result template: `test_results/templates/RESULT_TEMPLATE_TC01_P0.md`
- DoD template: `test_results/templates/DOD_TEMPLATE_EXP_TC01.md`
- Measurement procedure (Charger timings): `test_results/templates/MEASUREMENT_PROCEDURE_CHARGER_TIMINGS.md`
- Clips: `test_results/YYYY-MM-DD/artifacts/`
