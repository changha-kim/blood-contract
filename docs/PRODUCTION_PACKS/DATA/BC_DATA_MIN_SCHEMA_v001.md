# BC_DATA_MIN_SCHEMA_v001
> Assist Dept — Data Team | 2026-02-19 | v001

## 목적
Blood Contract PoC 데이터 구조의 **최소 스키마**를 코드 수정 없이 문서로 정의한다.
카드·태그·시너지·로컬라이제이션 키를 명시하고, TC05/TC10 측정에 필요한 필드를 명시적으로 마킹한다.

> 이 문서는 구현 레퍼런스이며, `godot/**` 코드를 직접 수정하지 않는다.
> 개발팀은 이 스키마를 참고하여 Resource 파일 또는 JSON 데이터를 작성한다.

---

## 1. Card (카드)

### 필드 정의
| 필드명 | 타입 | 필수 | 설명 | 예시 |
|---|---|---|---|---|
| `id` | string | ✅ | 고유 식별자. 패턴: `{patron}_{seq3}` | `"blood_001"` |
| `patron` | enum | ✅ | Blood \| Iron \| Ash | `"Blood"` |
| `name_ko` | string | ✅ | 한국어 카드명 (HUD 표시) | `"혈액 각인"` |
| `name_en` | string | ⬜ optional | 영어명 (PoC에서 로그/개발용) | `"Blood Sigil"` |
| `benefit_ko` | string | ✅ | 이득(Benefit) 설명 — 1줄 | `"공격 시 출혈 1 부여"` |
| `debt_ko` | string | ✅ | 대가(Debt) 설명 — 1줄 | `"매 룸 시작 시 HP -2"` |
| `tags` | array\<TagID\> | ✅ | 시너지 연산에 쓰이는 태그 목록. 최대 3개. | `["BLEED", "INTENT"]` |
| `cost` | int | ✅ | 카드 선택 비용 (PoC에서는 0 고정 가능) | `0` |
| `rarity` | enum | ✅ | common \| rare \| patron | `"rare"` |
| `patron_exclusive` | bool | ⬜ | 특정 패트론 전용 여부 | `true` |

### TC10 연결 필드
- `patron` + `tags`: 런 종료 시 `patron_diversity_index` 및 `tag_distribution` 집계에 사용.
- TC10 목표: 3회 런 내 최소 2 Patron + 태그 4종 이상 활성화 분포 확인.

---

## 2. Tag (태그)

### PoC 허용 태그 목록
| TagID | name_ko | 역할 | 아이콘 키 | 시너지 참여 |
|---|---|---|---|---|
| `BLEED` | 출혈 | 지속 피해 | `icon_bleed` | ✅ |
| `EXECUTE` | 처형 | 임계 HP 즉사 | `icon_execute` | ✅ |
| `CURSE` | 저주 | 디버프 부여 | `icon_curse` | ✅ |
| `CHAIN` | 연쇄 | 다중 타격 | `icon_chain` | ✅ |
| `SHIELD` | 방어 | 피해 흡수 | `icon_shield` | ✅ |
| `THORN` | 가시 | 반사 피해 | `icon_thorn` | ✅ |
| `KNOCKBACK` | 넉백 | 위치 이동 | `icon_knockback` | ✅ |
| `INTENT` | 의도 | Commit/LOCK 강화 | `icon_intent` | ✅ |

### 태그 필드 정의
| 필드명 | 타입 | 설명 |
|---|---|---|
| `id` | TagID (enum) | 고유 태그 식별자 |
| `name_ko` | string | HUD 표시용 한국어명 |
| `icon_key` | string | 에셋 참조 키 (`res://assets/icons/{icon_key}.png`) |
| `synergy_contribution` | bool | 시너지 카운팅에 포함 여부 |
| `description_ko` | string | 툴팁용 설명 1줄 |

---

## 3. Synergy Tier (시너지 단계)

### 필드 정의
| 필드명 | 타입 | 필수 | 설명 | 예시 |
|---|---|---|---|---|
| `patron` | enum | ✅ | 어느 패트론의 시너지인가 | `"Blood"` |
| `tier` | int | ✅ | 2 \| 3 \| 4 | `3` |
| `required_tag` | TagID | ✅ | 이 시너지를 구성하는 태그 | `"BLEED"` |
| `required_cards` | int | ✅ | 필요 카드 수 (같은 태그 보유) | `3` |
| `tier_label_ko` | string | ✅ | HUD 표시 시너지명 | `"공명"` |
| `effect_description_ko` | string | ✅ | 효과 설명 1줄 | `"출혈 누적 시 폭발 피해 발동"` |
| `effect_code_key` | string | ✅ | 코드 내 효과 함수 매핑 키 (코드 수정 없이 참조용) | `"synergy_blood_tier3_bleed_burst"` |
| `audio_stinger_key` | string | ⬜ | 활성화 시 재생 스팅어 SFX 키 | `"sfx_synergy_tier3_sting"` |
| `visual_fx_key` | string | ⬜ | 활성화 시 VFX 키 | `"vfx_synergy_tier3"` |

### Tier 정의 요약
| Tier | 이름 예시(안A) | required_cards | 효과 강도 |
|---|---|---|---|
| 2 | (이름 없음 — 보너스 수치만) | 2 | 소 (체감 작음) |
| 3 | "공명" / "각성" | 3 | 중 (운영이 바뀜) — **TC05 타깃** |
| 4 | "파기" / "해방" | 4 | 대 (판이 뒤집힘) |

### TC05 연결 필드
- `tier=3` + `required_cards=3`: TC05 기준 "평균 1회 Tier3 도달"을 로그로 추적.
- 필요 로그 이벤트: `synergy_activated(patron, tier, run_id, room_id)`.
- TC05 패스 기준: 5회 런 중 ≥3회 `tier=3` 이벤트 발생.

---

## 4. Localization Keys (로컬라이제이션 키)

### 규칙
- 모든 HUD 표시 문자열은 하드코딩 금지. 반드시 로컬라이제이션 키 참조.
- 키 패턴: `lk_{category}_{id}` 

### 주요 키 목록 (PoC 최소)
| 키 | 기본값(한국어) | 용도 |
|---|---|---|
| `lk_state_telegraph` | (없음 — 아이콘 전용) | 예고 상태 텍스트 |
| `lk_state_lock` | "확정" | LOCK HUD 라벨 |
| `lk_state_execute` | "집행" | Execute HUD 라벨 |
| `lk_synergy_tier3_label` | "공명" | Tier3 시너지명 |
| `lk_synergy_tier4_label` | "파기" | Tier4 시너지명 |
| `lk_wall_hit_confirm` | (데미지 숫자 단독) | TC04 피해 확인 |
| `lk_run_end_death` | "계약 실패" | 런 종료 — 사망 |
| `lk_run_end_clear` | "계약 이행" | 런 종료 — 클리어 |
| `lk_card_benefit_prefix` | "이득:" | 카드 UI Benefit 라벨 |
| `lk_card_debt_prefix` | "대가:" | 카드 UI Debt 라벨 |

> 위 값은 `BC_NARRATIVE_KO_UI_MICROCOPY_v002`의 추천 안 A 기준. Main team이 안 B 선택 시 이 키 값만 업데이트.

---

## 5. 스키마 관계도 (텍스트)

```
Card ──────────┬─ patron ──▶ SynergyTier.patron
               └─ tags[] ──▶ Tag.id ──▶ SynergyTier.required_tag

SynergyTier ──▶ effect_code_key ──▶ [Code: synergy handler]
              ──▶ audio_stinger_key ──▶ [Audio: sfx_synergy_*.ogg]
              ──▶ tier_label_ko ──▶ lk_synergy_tier{N}_label

Tag ──▶ icon_key ──▶ [Asset: res://assets/icons/*.png]
     ──▶ name_ko ──▶ HUD 툴팁
```

---

## 6. PoC 콘텐츠 목록 (고정)

| 분류 | 수량 | 비고 |
|---|---|---|
| Card | 18 | 3 Patron × 6장 |
| Tag | 8 | BLEED, EXECUTE, CURSE, CHAIN, SHIELD, THORN, KNOCKBACK, INTENT |
| SynergyTier | 최소 9 | 3 Patron × Tier2+3+4 각 1 |
| Localization Keys | ≥10 | 위 표 기준 |

---

## 7. 데이터 파일 형식 권장 (PoC)

- Godot Resource (`.tres`) 또는 JSON (`.json`) 중 택 1.
- 경로 제안: `godot/assets/data/cards/`, `godot/assets/data/synergy/`
- PoC에서는 JSON이 에디터 없이 수정 편리 → **JSON 권장**.
- 인코딩: UTF-8 (한국어 문자열 필수).

---

## 다음 버전 목표
- v002: 18장 카드 전체 데이터 채움 (이름, benefit, debt, tags)
- v002: TC10 빌드 다양성 측정을 위한 런 종료 집계 스키마 추가
- v002: 로컬라이제이션 파일 형식 확정 (.csv vs .json vs Godot Translation)
