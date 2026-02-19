# ASSIST_MEMORY (Assist Dept)

> Assist teams update this file at the end of each work session.
> Goal: maintain continuity without touching gameplay code.

## Last updated
- 2026-02-19

## What shipped (links)
- Narrative:
  - NARRATIVE/BC_NARRATIVE_LOGLINE_v001.md
  - NARRATIVE/BC_NARRATIVE_UI_TEXT_SEEDS_v001.md
- Design:
  - DESIGN/BC_DESIGN_COMBAT_READABILITY_RULES_v001.md
  - DESIGN/BC_DESIGN_LOCK_MOMENT_SPEC_v001.md
- Audio:
  - AUDIO/BC_AUDIO_SFX_LIST_v001.md
  - AUDIO/BC_AUDIO_MIX_GUIDE_v001.md
- Data:
  - (v001 없음)

## In progress
- (없음) v001 문서 드랍 완료

## Decisions / constraints
- 코드(godot/**) 수정 금지. 문서만 산출.
- TC01/TC04를 우선 통과시키기 위해 **LOCK(Commit)와 WALL_HIT(SpikeWall 피해)**의 가독성/피드백을 최우선으로 정의.
- 대형 바이너리(SFX 파일 등)는 아직 커밋하지 않고, 링크+매니페스트 방식으로 관리.

## Next tasks (queue)
1) Data 팀 v001: 카드/태그/시너지/텍스트 키의 최소 데이터 스키마 문서(코드 수정 없이) 작성
2) Design v002: 다중 적(TC02) 상황에서 ‘위험 Intent 최대 3개 강조’ 룰 구체화(레이어링/투명도)
3) Audio v002: Android 스피커 기준 EQ/리미터 프리셋 가이드 + Tier3/4 stinger 우선순위

## Open questions for Main team (OpenClaw)
- LOCK을 HUD에 한국어(예: "확정")로 표기할지, 영어 LOCK를 유지할지 결정 필요(UX/브랜딩).
