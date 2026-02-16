# SPRINT_PACKET — S2 / poc-0.1.2 / M2 (vFinal)

- **Sprint ID:** S2
- **Build Target:** poc-0.1.2
- **Milestone:** M2 (Intent Combat Stabilization / Testability)
- **Goal:** Lock **TC01 공식 실험 장소** 및 **M2(유도 성공) 판정 규칙**을 확정하고, TC01 실행/측정 템플릿을 워크스페이스에 추가한다.

## S2 결정사항 (사용자 승인 · 확정)
1) **TC01 공식 실험 장소:** **1룸 튜토리얼 고정**
   - `Thorn Hall`은 **별도 룸/쇼케이스/검증용**으로 유지 (TC01 공식 실험 장소 아님)

2) **M2(유도 성공) 판정 규칙:**
   - **Enemy Spike Wall 피해/스턴 적용 이벤트 1회 = 1 카운트**
   - **ICD 0.8s** 적용: 연속 틱/중복 이벤트는 **중복 카운트 금지**

## Scope
### Scope IN
1) **TC01 운영 규칙 정리 (문서 확정)**
- TC01은 **1룸 튜토리얼**에서 수행한다.
- Thorn Hall은 TC01과 분리하여 **쇼케이스/검증** 용도로만 사용한다.

2) **M2 판정 규칙 정리 (문서 확정)**
- Enemy Spike Wall의 피해/스턴 적용 이벤트를 계측/집계할 때:
  - 이벤트 발생 1회 = 1회 유도 성공 카운트
  - 동일 소스의 연속 틱은 **0.8초 ICD**로 디바운스하여 중복 집계하지 않는다.

3) **측정/결과 템플릿 추가 (workspace deliverable)**
- 아래 신규 템플릿 파일을 추가한다:
  - `blood_contract/test_results/templates/RESULT_TEMPLATE_TC01_P0.md`
  - `blood_contract/test_results/templates/MEASUREMENT_PROCEDURE_CHARGER_TIMINGS.md`

### Scope OUT
- 본 문서(vFinal) 범위를 넘어서는 전투 룰/타이밍 변경
- 신규 콘텐츠(적/룸/기믹) 추가 자체
- 로깅/이벤트 파이프라인 대규모 리팩터

## Notion References
### Systems keys
- `SYS_INTENT_COMBAT_CORE`
- `SYS_MAINMENU_FLOW`
- `SYS_TELEMETRY_LOGGING`
- `ADR_LOGGING_UNIFICATION` (DB_ADR_DECISIONS)

### Content keys
- `ROOM_TUTORIAL_1ROOM` (TC01 official)
- `ROOM_THORN_HALL` (showcase/validation)
- `ENY_SPIKE_WALL`

### Test cases keys (DB_EXPERIMENTS)
- `TC01` (Commit 이해도)

## Acceptance Criteria
1) **TC01 장소 확정**
- 스프린트 산출물/운영 기준에서 TC01은 **1룸 튜토리얼 고정**으로 명시되어 있다.
- Thorn Hall은 TC01 공식 실험 장소에서 제외되어 있다.

2) **M2 판정 규칙 확정**
- Enemy Spike Wall 피해/스턴 적용 이벤트의 집계 규칙이 다음을 만족한다:
  - 1 이벤트 = 1 카운트
  - ICD 0.8s로 연속틱 중복 집계가 없다.

3) **템플릿 파일 2종 존재**
- 아래 경로에 파일이 존재하며, 실험 기록에 바로 사용할 수 있는 형태의 목차/필드를 포함한다:
  - `blood_contract/test_results/templates/RESULT_TEMPLATE_TC01_P0.md`
  - `blood_contract/test_results/templates/MEASUREMENT_PROCEDURE_CHARGER_TIMINGS.md`

## Deliverables
- 본 문서 `SPRINT_PACKET` vFinal
- 신규 템플릿 2종 (위 경로)

## Stop Conditions
- (문서 스코프) 위 결정사항과 상충되는 기존 문서/운영 규칙이 발견되면, **충돌 지점**을 먼저 표기하고 합의 없이 추정 변경하지 않는다.
