# TASK_PACKET 후보 묶음 (2026-02-17)

> 목적: Planner가 밤에 발행 가능한 **Ready-to-run TASK_PACKET 후보 5개**. 
> 원칙: PoC=검증 우선, Scope Cut 우선. Dev 실행은 Codex CLI 고정(브랜치+PR). 

## 공통 규칙 (모든 TASK_PACKET)
- Allowed folders: `godot/**`, `tools/**`, `docs/PACKETS/**`, `assets/**`
- 반드시 읽기: `docs/PACKETS/STATE_PACKET.md`, `PLAN_PACKET.md`, `QA_PACKET.md`
- 작업 완료 시: `docs/PACKETS/STATE_PACKET.md`의 **Current build / Current focus / Known issues / Next actions**만 업데이트
- main 직접 push 금지 → feature branch → PR

---

## DEV-009: LOG schema v0.1 — run_id/room_id/seed + core events 일관화
### Goal
- Week1 튜닝/재현을 위한 로그 스키마를 **실제로 쓸 수 있게** 정리한다.

### Must
- `run_start`, `commit_enter`, `wall_hit`, `tc04_attempt`의 필드 키를 문서와 코드에서 일치.
- legacy alias 이벤트는 **유지**하되(삭제/rename 금지), 신규 스키마 이벤트를 canonical로 둔다.
- 로그가 런 단위 파일로 떨어지도록(또는 최소 run_id로 묶이도록) 개선.

### Must NOT (scope cut)
- 리플레이/telemetry 서버/분석 파이프라인 구축 금지
- 이벤트 rename/삭제 금지(추가만)

### Acceptance
- QA_PACKET의 required events가 실제 로그에 찍힘(최소 1 run).

---

## DEV-010: TC01(min) — Commit=LOCK 신호 최소 구현(시각 1 + SFX 1)
### Goal
- Telegraph와 Commit이 **헷갈리지 않게** Commit 진입 순간에 LOCK 신호를 1회 강제.

### Must
- Commit 진입 프레임에 UI(아이콘/테두리/색/선 굵기 중 1)로 LOCK 강조
- SFX placeholder 1개 연결(파일은 임시여도 됨)

### Scope cut
- 폴리싱/애니메이션/최종 아트 금지
- 신규 UI 시스템 대공사 금지(기존 UI에 최소 삽입)

### Acceptance
- TC01(min) 기준: 1~2회 내 Commit이 Telegraph와 구분된다는 관찰이 가능.

---

## DEV-011: SpikeWall ICD(0.8s) + wall_hit 로깅 정확도
### Goal
- TC03(옵션)까지 함께 커버하는 **안전장치**.

### Must
- SpikeWall 피해에 ICD 0.8s 적용 (enemy/player 각각 적용 여부 명시)
- `wall_hit`에 `icd_applied`(bool) + `damage` 기록

### Scope cut
- 신규 해저드 추가 금지

### Acceptance
- 벽박힘 연타 시 `wall_hit` 빈도가 ICD로 제한됨(로그로 확인 가능).

---

## DEV-012: TC04 룸 진입 UX + 리셋 루프 안정화
### Goal
- TC04 10회 시도가 **빠르게** 돌도록 루프 품질을 올린다.

### Must
- MainMenu에서 TC04 진입 버튼
- 리셋은 `reload_current_scene()` 기반으로 안정
- `tc04_attempt` 로그(성공/실패/사유 enum)

### Scope cut
- 룸 생성 시스템 리팩터링 금지

### Acceptance
- 10회 시도 기록이 2분 내 가능한 수준(수동 기준) + 크래시 없음.

---

## QA-002/TOOLS-001: 로그 파서 v0.1 — QA_REPORT 자동 초안 생성
### Goal
- QA팀이 로그 기반으로 Pass/Mixed/Fail를 **빠르게** 판정.

### Must
- 입력: `logs/*.jsonl` 또는 `logs/*.log`
- 출력: `test_results/qa_report_draft.md` (템플릿 채움)
- 최소 집계:
  - TC04 성공률(성공/시도)
  - wall_hit ICD 적용률
  - commit_enter 횟수

### Scope cut
- 외부 서비스 업로드/DB 저장 금지

### Acceptance
- 1개 로그 파일로 report draft가 생성됨.
