# BC_NARRATIVE_UI_STRING_INTEGRATION_NOTE_v001
> 목적: Narrative 산출물(Logline/UI Seeds/KO Microcopy)을 실제 UI string table로 이관하기 위한 최소 가이드.

## Source-of-truth
- Narrative pack (docs):
  - `BC_NARRATIVE_KO_UI_MICROCOPY_v002.md`
  - `BC_NARRATIVE_UI_TEXT_SEEDS_v001.md`
  - `BC_NARRATIVE_LOGLINE_v001.md`

## Locked HUD terms (DO NOT change)
- LOCK/Commit=확정
- Execute=집행
- Tier3=공명
- Tier4=파기
- Death=계약 실패
- Clear=계약 이행

## Key policy (recommended)
- Use the existing `lk_*` keys shown in KO microcopy as the canonical keys.
- Keep keys stable even if text changes.
- UI text should reference keys; logs/code can stay English snake_case.

## Suggested minimal export shape (JSON)
```json
{
  "locale": "ko",
  "strings": {
    "lk_state_lock": "확정",
    "lk_state_execute": "집행",
    "lk_synergy_tier3_label": "공명",
    "lk_synergy_tier4_label": "파기",
    "lk_run_end_death": "계약 실패",
    "lk_run_end_clear": "계약 이행"
  }
}
```

## Runtime rules (from pack)
- HUD 표시: 확정어만 사용 (영어 혼용 금지)
- 모달 본문: 1줄 이내 (설명 금지)
- Tier3/4 토스트: 카드 선택 화면에서 발동(권장)
