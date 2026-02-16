# OpenClaw Automation Design — Notion-driven PoC (Planner/Dev split)

## Goal
- 노션(GDD/DB)을 SoT로 두고, OpenClaw가 **기획자 역할(Planner)** 과 **개발자 역할(Dev)** 을 분리해서 PoC를 단계적으로 구현한다.
- 진행 중 막히면 설계를 바꾸고(ADR), 변경사항을 참조해서 계속 개발한다.

---

## Architecture (2-track)

### 1) Planner (Game Designer)
Responsibilities
- Notion의 GDD(페이지)와 DB_SYSTEMS/DB_CONTENT/DB_EXPERIMENTS를 읽고, PoC 범위(`PoC Scope=true`)만 뽑아 스프린트를 구성
- 변경/불확실성/리스크를 ADR 후보로 정리
- Dev에게 넘길 **Spec Packet** 생성

Outputs
- `spec_packets/SPRINT_YYYYMMDD.md`
- `spec_packets/ADR_CANDIDATES_YYYYMMDD.md`

### 2) Dev (Game Developer)
Responsibilities
- Spec Packet을 기준으로 구현
- 데이터는 `res://data/notion_export/`로 export하여 **data-driven** 유지
- 각 마일스톤마다 실행 가능한 빌드 + `CHANGELOG.md` + `HOW_TO_TEST.md`

Outputs
- Godot 프로젝트 변경사항
- `spec_packets/DEV_NOTES_YYYYMMDD.md` (막힘/제안/결정 필요)

---

## Handoff Contract (필수)

### Spec Packet format (Planner → Dev)
- Milestone: Mx
- Scope: Must / Should / Won't
- Data: 필요한 DB rows 목록(keys)
- Acceptance: 실행할 Test Cases(TCxx) + Pass 정의
- Implementation notes: 금지/강제 규칙(예: commit lock 불변)

### Dev Notes format (Dev → Planner)
- What shipped (파일/씬/기능)
- What’s blocked
- Change Request (ADR 후보):
  - Problem
  - Options
  - Recommendation
  - Impact on DoD/TC

---

## OpenClaw Implementation Plan

### A) Run 2 sub-agents
- `planner-bloodcontract` : GDD/노션 DB 기반 기획/스프린트 구성
- `dev-bloodcontract` : Godot 구현

Main session acts as PM:
- Planner 결과를 Dev에게 전달
- Dev의 Change Request를 Planner에게 다시 전달

### B) Optional: Cron rhythms
- Planner cron: 하루 1회(또는 요청 시)
  - 다음 1~2개 테스트케이스/스프린트 제안
- Dev cron: 하루 1회(또는 요청 시)
  - 다음 마일스톤의 작은 단위 구현 진행

(주의) 외부 메시지 전송은 명시적으로 요청될 때만.

---

## Definition of Done
See: `blood_contract/P0_POC_DEFINITION_OF_DONE.md`

## Work Order
See: `blood_contract/OPENCLAW_WORK_ORDER_Godot4_PoC_NotionDriven_v1.0.md`
