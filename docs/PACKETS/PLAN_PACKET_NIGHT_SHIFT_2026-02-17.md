# PLAN_PACKET — Night Shift (2026-02-17)

## Goal (tonight)
- **A)** Ready-to-run TASK_PACKET 후보 5개 발행
- **B)** QA_PACKET을 로그 기반 판정에 충분할 정도로 구체화(키/enum 확정)
- **C)** Dev(Codex) 1개 작업을 실제로 PR로 올릴 수 있게 TASK_PACKET 기반 실행

## Constraints
- PoC = 검증 우선, 기능추가보다 Scope Cut 우선
- Single Source of Truth: Notion(GDD) / GitHub(실행·이슈) / STATE_PACKET(현재 상태)
- Dev는 Codex CLI 고정(브랜치+PR, main 직접 push 금지)

## Outputs
- `docs/PACKETS/TASK_PACKET_CANDIDATES_2026-02-17.md`
- `docs/PACKETS/QA_PACKET.md`(log schema 더 명확)
- Dev PR: `docs/PACKETS/TASK_PACKET.md` 기준 TC04 loop/logging 작업 수행(가능하면)
