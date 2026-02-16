# TASK_PACKET (Dev / Codex)

## Task
- Issue: **DEV-001 — Godot 프로젝트/레포 기본 구조 + .gitignore + PACKETS 적용**
- Target model: **gpt-5.3-codex (big)**
- Files allowed to modify (explicit):
  - `godot/**`
  - `.gitignore`
  - `docs/PACKETS/**`
  - (필요 시) `tools/**` *(이번 태스크에서는 사용하지 않는 것을 우선)*

## Read first
- `docs/PACKETS/STATE_PACKET.md`
- `docs/GDD_SUMMARY.md`
- `docs/PACKETS/QA_PACKET.md` (Week1 scope)

## Requirements
### Must
- Godot 4.x 프로젝트가 **repo 안에서 Desktop 실행 1회 성공**해야 한다.
- Godot 캐시/빌드 산출물 등 **불필요 파일은 커밋되지 않도록** `.gitignore`를 정리한다.
  - 최소: `.godot/`, `*.import`, `.mono/`(사용 시), `export_presets.cfg`(정책에 따라) 등
- PACKETS 파일이 repo에 존재하고, Dev 작업 종료 시 아래를 갱신한다.
  - `STATE_PACKET > Current build` (Last successful run 날짜 포함)
  - `STATE_PACKET > Known issues` (발견된 blocker가 있으면 1~2개만)
  - `STATE_PACKET > Next actions` (DEV-002로 이어지게)

### Must NOT
- 신규 게임 시스템(시너지/카드/런루프/적 추가) 구현 금지
- Android export/성능 작업 금지
- “편의상” 구조를 크게 바꾸는 리팩터링 금지 (Week1은 재현 루트가 우선)

## Output / Structure expectations
- `godot/` 아래에 Godot 프로젝트 루트(예: `godot/project.godot`)가 명확히 존재
- 최소 실행 씬 1개(예: `Main.tscn`)가 있고, 실행 시 크래시 없이 화면이 뜸
- (선택) 디버그 HUD 텍스트 1줄: build tag 또는 현재 씬명 표시

## Acceptance criteria
- [ ] `godot/` 프로젝트를 **Desktop에서 실행**해 1회 이상 정상 동작 (크래시/에러 없이)
- [ ] `.gitignore`가 적용되어 `.godot/` 등 캐시가 커밋 대상에서 제외됨
- [ ] `docs/PACKETS/STATE_PACKET.md`의 **Current build**가 업데이트됨
  - Last successful run: YYYY-MM-DD
  - Version tag: (planned → 실제 값으로 확정 or planned 유지하되 실행일 기록)
- [ ] 다음 작업(DEV-002)을 막는 **blocker가 없는지** 짧게 확인하고, 있으면 Known issues에 1줄로 기록

## Linked tests (TC)
- 직접 TC 수행은 아님. 단, Week1 Must인 **TC04/TC01**을 위해 ‘실행 가능한 베이스’를 만든다.

## Commit message suggestion
- `chore: add godot baseline project + gitignore + packets wired`
