# ASSIST_MEMORY (Assist Dept)

> Assist teams update this file at the end of each work session.
> Goal: maintain continuity without touching gameplay code.

## Last updated
- 2026-02-19 (Session 2 — v002 드랍)

## What shipped (links)

- Narrative:
  - NARRATIVE/BC_NARRATIVE_LOGLINE_v001.md
  - NARRATIVE/BC_NARRATIVE_UI_TEXT_SEEDS_v001.md
  - NARRATIVE/BC_NARRATIVE_KO_UI_MICROCOPY_v002.md ← NEW
- Design:
  - DESIGN/BC_DESIGN_COMBAT_READABILITY_RULES_v001.md
  - DESIGN/BC_DESIGN_LOCK_MOMENT_SPEC_v001.md
  - DESIGN/BC_DESIGN_TC02_READABILITY_UNDER_CLUTTER_v002.md ← NEW
- Audio:
  - AUDIO/BC_AUDIO_SFX_LIST_v001.md
  - AUDIO/BC_AUDIO_MIX_GUIDE_v001.md
  - AUDIO/BC_AUDIO_ANDROID_SPEAKER_PRESET_v002.md ← NEW
  - AUDIO/BC_AUDIO_TIER3_TIER4_STINGERS_v002.md ← NEW
- Data:
  - DATA/BC_DATA_MIN_SCHEMA_v001.md ← NEW

## In progress
- (없음) v002 문서 드랍 완료

## Decisions / constraints
- 코드(godot/**) 수정 금지. 문서만 산출.
- TC01/TC04를 우선 통과시키기 위해 **LOCK(Commit)와 WALL_HIT(SpikeWall 피해)**의 가독성/피드백을 최우선으로 정의.
- 대형 바이너리(SFX 파일 등)는 아직 커밋하지 않고, 링크+매니페스트 방식으로 관리.
- HUD 표시 단어(확정/봉인, 집행/발동 등) 최종 선택은 Main team(OpenClaw)이 결정. Assist는 안 A/B 후보 제시까지.
- dim 알고리즘(TC02): 위험 Intent 최대 3개 full emphasis, 초과분 30% 투명도로 감쇠.
- LOCK 큐는 어떤 상황에서도 dim 금지 (절대 규칙).

## Next tasks (queue)
1) **Design v003**: Shielder / Slasher 전용 Telegraph+LOCK 변형 스펙 (v001 내용 확장)
2) **Audio v003**: 실기기(Galaxy/Pixel) 실측 후 EQ 수치 보정 + BGM 도입 시 덕킹 타임라인 재정의
3) **Data v002**: 18장 카드 전체 데이터 채움 (name_ko, benefit_ko, debt_ko, tags) + TC10 집계 스키마
4) **Narrative v003**: 카드 이름 한국어화 가이드 (Patron × 6장 × 이득/대가) + 룸 플레이버 텍스트 확정
5) **All teams**: HUD 표시 단어 최종 확정 후 → lk_{key} 값 업데이트 및 BC_DATA_MIN_SCHEMA 로컬라이제이션 키 반영

## Open questions for Main team (OpenClaw)
- HUD 표시 단어 최종 선택: "확정" vs "봉인" (LOCK), "집행" vs "발동" (Execute), "예고"(미표시) vs 아이콘 전용. → `BC_NARRATIVE_KO_UI_MICROCOPY_v002` 표 참조 후 결정 요청.
- Tier3/Tier4 시너지 발동 시점이 "카드 선택 화면"인지 "전투 중 즉발"인지 확정 필요 → 오디오 충돌 회피 규칙에 영향.
- TC02 dim 알고리즘 구현 우선순위 — Week1 M1 스코프에 포함할지 Week2로 미룰지 결정 요청.
