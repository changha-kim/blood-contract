# DoD Tracking — EXP PoC‑TC01 Commit(잠금) 이해도 (무설명 학습)

## Source of truth (Notion)
- EXP TC01: https://www.notion.so/EXP-PoC-TC01-Commit-307777a0189881c9a83aca00ba6e49a6?pvs=26
- SYS Intent Combat: https://www.notion.so/SYS-Intent-Combat-Telegraph-Commit-Execute-307777a01898814a9d3df5820fce8fe9?pvs=26
- ENY Charger: https://www.notion.so/ENY-Charger-Inquisitor-Ram-307777a0189881acb080d77158e88064?pvs=26
- HZD Spike Wall: https://www.notion.so/HZD-Spike-Wall-307777a0189881168b0eedc267753885?pvs=26
- ROOM Thorn Hall: https://www.notion.so/ROOM-Thorn-Hall-307777a01898812daa2af14de711e2b7?pvs=26

## Run Meta
- Date:
- Tester:
- Build id / commit:
- Platform + input:
- Room used: **1룸 튜토리얼 (TC01 공식 고정)**
  - (Exception / reference) Thorn Hall:
- Enemy used (Charger 1 or Slasher 1):
- Hazard: Spike Wall present? Y/N
- Recording paths (clips):

## Preconditions checklist (from EXP Setup/Steps)
- [ ] Player instruction limited to “공격/대시만”
- [ ] Commit 설명 금지
- [ ] Enemy runs Telegraph→Commit→Execute cycle ≥ 3 times (exposure)
- [ ] Spike Wall feedback present (metal hit SFX / sparks VFX / damage number)

## Metrics (Facts) — from EXP
- (M1) Commit을 “이해한 행동 변화” 시점: ____ sec / ____ cycles
  - What behavior counted as “understood” (describe concretely):
- (M2) 유도 성공 횟수(Spike Wall hit 유도): ____
  - Count rule: **Enemy Spike Wall 피해/스턴 적용 이벤트 1회 = 1카운트**
  - Anti-double-count: 연속틱은 Spike Wall **ICD 0.8s**로 **중복 카운트 금지**
  - (Optional conservative) distinct commits only?: Y/N
- (M3) “억울함” 발언/행동(분노/혼란): Y/N
  - Quote + context:

## Pass Criteria (from EXP)
- [ ] PC1: 설명 없이도 2분 내 1회 이상 “유도 성공” 발생
- [ ] PC2: “저거 고정되네/확정되네” 류의 말이나 행동 관찰

## Fail Criteria (from EXP)
- [ ] FC1: Commit과 Telegraph 차이를 구분 못함(계속 피하기만/무의미한 충돌 반복)
- [ ] FC2: 유도 성공 0회 + ‘왜 맞는지 모르겠다’ 반응이 강함

## Result
PASS / MIXED / FAIL / BLOCKED

## Linked templates / procedures
- Result template (TC01 P0): `RESULT_TEMPLATE_TC01_P0.md`
- Measurement procedure (Charger timings): `MEASUREMENT_PROCEDURE_CHARGER_TIMINGS.md`

## Notes (actionable)
- SYS(telegraph/commit cues) issues:
- ENY Charger issues (lock direction 0.2s prep, wall hit recover 1.2s, etc.):
- HZD Spike Wall issues (ICD 0.8s, feedback, stun 0.35s):
- ROOM issues (1룸 튜토리얼 레인/지형 유도 가능성, 필요 시 Thorn Hall reference):
