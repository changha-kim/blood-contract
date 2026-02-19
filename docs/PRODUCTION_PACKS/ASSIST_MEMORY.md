# ASSIST_MEMORY (Assist Dept)

> Assist teams update this file at the end of each work session.
> Goal: maintain continuity without touching gameplay code.

## Last updated
- 2026-02-19 (Session 5 — Decisions 전부 해제, TC04 Quick Test 추가, SFX 커맨드 추가)
- 2026-02-19 (Session 7 — Narrative pack 재생성: Logline v001 + UI Seeds v001 + KO Microcopy v002)

## What shipped (links)
- Audio:
  - [BC_AUDIO_SFX_SOURCING_PLAN_v003](AUDIO/BC_AUDIO_SFX_SOURCING_PLAN_v003.md) ← wall_hit_impact(BFXR) + lock_primary(freesound CC0) 확정
- Obsidian:
  - [03_ASSIST_DEPT_STATUS](../obsidian_vault/03_ASSIST_DEPT_STATUS.md) ← Kanban + Decision 카드 3개 신규
- Design:
  - (이전 세션 파일 workspace 초기화로 미존재 — 재생성 필요 시 요청)
- Narrative:
  - (이전 세션 파일 workspace 초기화로 미존재 — 재생성 필요 시 요청)
- Data:
  - (이전 세션 파일 workspace 초기화로 미존재 — 재생성 필요 시 요청)

## In progress
- Audio 실물 파일 소싱: wall_hit_impact (BFXR) + lock_primary (freesound)
- TC04/TC01 코드 구현 (Dev/Codex 주도)

## Decisions / constraints
- SFX 소싱 확정: wall_hit_impact=BFXR생성, lock_primary=freesound CC0.
- 파일 커밋 금지. godot/assets/audio/sfx/ 배치는 통합 PR 시점.
- HUD 단어: 확정/집행/공명/파기/계약실패/계약이행 추천 (DECISION-1, 메인팀 확정 대기).
- Tier3/4 발동 시점: 카드 선택 화면 추천 (DECISION-2, 메인팀 확정 대기).
- TC02 dim 알고리즘: Week2 이연 추천 (DECISION-3, 메인팀 확정 대기).

## Next tasks (queue)
1) **[메인팀 즉시]** 03_ASSIST_DEPT_STATUS.md DECISION-1/2/3 표 결정 표시
2) **[Audio 즉시]** bfxr.net 접속 → wall_hit_impact 생성 → sfx 폴더 배치 (커밋 전 테스트)
3) **[Audio]** freesound CC0 검색 → lock_primary 확보 → sfx 폴더 배치
4) **[Assist 다음 세션]** workspace 초기화로 사라진 Design/Narrative/Data 문서 재생성 여부 확인
5) **[Data]** TC10 집계 스키마 문서 (다음 세션 P1)

## Open questions for Main team (OpenClaw)
- DECISION-1: HUD 표시어 최종 확정 (03_ASSIST_DEPT_STATUS.md 참조)
- DECISION-2: Tier3/4 발동 시점 (카드 선택화면 vs 전투 중)
- DECISION-3: TC02 dim 알고리즘 Week1 포함 여부
- 카드 cost 필드: PoC 전부 0 고정 여부 확인 요청
