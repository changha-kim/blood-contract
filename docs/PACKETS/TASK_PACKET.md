# TASK_PACKET (Dev / Codex)

## Task (작업)
- Issue: **TC04 route core — 3초 장면 재현 루프(Charger → Spike Wall) + attempt logging**
- Target model: **gpt-5.3-codex (big)**
- Branch/PR policy:
  - **DO NOT push to `main`**. feature branch에서 작업하고 PR을 연다.
  - PR은 required checks를 통과해야 한다: **packets-gate**, **gdscript-lint**.

## Files allowed to modify (수정 허용 경로)
- `godot/**`
- `docs/PACKETS/**` *(마지막에 STATE_PACKET 업데이트 필수)*
- `docs/QA_REPORT.md` *(유용하면 노트 append)*

## Read first (먼저 읽기)
- `docs/PACKETS/STATE_PACKET.md`
- `docs/PACKETS/PLAN_PACKET.md`
- `docs/PACKETS/QA_PACKET.md` (Week1 scope)

## Context (배경)
Week1의 P0 목표는 **TC04를 한 룸에서 재현 가능**하게 만드는 것:
- Charger가 Telegraph→Commit→Execute를 수행
- 플레이어의 상호작용으로 Charger가 Spike Wall 데미지를 받게 유도
- 10번 빠르게 시도하고, 성공/실패를 이유와 함께 로그로 남긴다.

## Requirements
### Must (반드시 구현)
1) UI에서 TC04 룸으로 들어가는 **직접 경로**를 제공한다. (MainMenu 버튼이면 충분)
2) TC04 룸에서 **빠른 리셋 루프** + 시도별 결과 로그를 남긴다:
   - `tc04_attempt` 이벤트 emit (필드 고정):
     - `run_id`
     - `room_id`
     - `attempt_id`
     - `success_bool`
     - `fail_reason_enum` (실패 시만; `control|readability|rules|other` 중 1개)
     - `ts_msec`
   - Reset 방법은 `reload_current_scene()` 허용
3) 작업 종료 시 `docs/PACKETS/STATE_PACKET.md` 업데이트:
   - Current build / Current focus / Known issues / Next actions (**이 4개 섹션만**)

### Must NOT (금지)
- TC04 리셋/로그 루프에 필요하지 않은 신규 전투 메커닉 추가 금지
- 이벤트 rename 금지(추가만 허용)

## Acceptance criteria (완료 조건)
- [ ] MainMenu에서 TC04 룸으로 진입할 수 있다.
- [ ] TC04 룸에서 10 attempts를 `tc04_attempt`로 로그에 남길 수 있다.
- [ ] 리셋 루프가 안정적(크래시 없음)이며 앱 재시작 없이 반복 가능하다.

## Commit message format
- Use: `TC04: add attempt logging + reset loop in spike arena`
