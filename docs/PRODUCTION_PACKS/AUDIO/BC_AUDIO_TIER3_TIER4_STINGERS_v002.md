# BC_AUDIO_TIER3_TIER4_STINGERS_v002
> Assist Dept — Audio Team | 2026-02-19 | v002

## 목적
시너지 **Tier3(Major)** 와 **Tier4(Break)** 활성화 시 재생되는 스팅어(stinger) 오디오의 컨셉·길이·레이어 구조와, TC01 LOCK 큐 및 TC04 WALL_HIT와의 **믹스 우선순위**를 정의한다.

---

## 시너지 스팅어 개요

| 분류 | 트리거 | 중요도 | 플레이어 메시지 |
|---|---|---|---|
| Tier2 (Minor) | 2장 태그 매칭 | 낮음 | 스팅어 없음 — UI 시각 효과만 | 
| **Tier3 (Major)** | 3장 태그 매칭 | 중간 | "운영이 바뀌었다" — 반드시 들려야 함 |
| **Tier4 (Break)** | 4장 태그 매칭 | 높음 | "판이 뒤집혔다" — 하이라이트 순간 |

---

## Tier3 스팅어 스펙

### 컨셉
- 느낌: 잠금 해제(unlock), 체인이 당겨지는 순간. 기계적+혈기적.
- 장르 레퍼런스: 짧은 오케스트라 hit + 합성음 리조네이터. 어둡고 날카로움.
- **키워드:** 확실하지만 과하지 않다. "예고된 폭발 직전".

### 파라미터
| 항목 | 값 |
|---|---|
| 길이 | 1.5–2.2s |
| 레이어 구조 | Hit 타격(0.0s) + 잔향 스윕(0.2–0.8s) + 짧은 톤 유지(~2.0s) |
| 재생 시점 | 카드 선택 화면에서 시너지 달성 확정 순간 (`synergy_activated` 이벤트) |
| 루프 여부 | 없음 (원샷) |
| 파일명(목표) | `sfx_synergy_tier3_sting.ogg` |

### 믹스 레벨 (기준 0dBFS)
| 상황 | Tier3 스팅어 레벨 | 비고 |
|---|---|---|
| 단독 재생 | -6 dBFS | 기본 |
| LOCK 큐와 충돌 시 | **-18 dBFS** (LOCK 덕킹) | LOCK이 최우선 — 스팅어 대폭 감쇠 |
| WALL_HIT와 충돌 시 | -12 dBFS (WALL_HIT 덕킹) | WALL_HIT 우선 |
| BGM과 동시 재생 | BGM -4dB 덕킹하며 스팅어 재생 | |

---

## Tier4 스팅어 스펙

### 컨셉
- 느낌: 계약이 발동됐다 — 피의 계약 파열. 압도적 순간.
- 장르 레퍼런스: 풀 오케스트라 brass hit + 저음 드론 스윕 + 타악기 크레센도. 드물기 때문에 무거워도 됨.
- **키워드:** "이 판은 다르다." 플레이어가 멈추게 만드는 사운드.

### 파라미터
| 항목 | 값 |
|---|---|
| 길이 | 2.5–4.0s |
| 레이어 구조 | 충격파 hit(0.0s) + brass swell(0.3–1.5s) + 드론 잔향(~4.0s fade) |
| 재생 시점 | 시너지 Tier4 달성 확정 순간 (`synergy_activated(tier=4)` 이벤트) |
| 루프 여부 | 없음 (원샷). 단, 드론 잔향 꼬리는 자연 감쇠. |
| 마이크로 슬로우 연동 | Tier4 스팅어 재생 시 `Engine.time_scale = 0.7` × 0.5s 권장 (LOCK 마이크로슬로우와 동일 방식) |
| 파일명(목표) | `sfx_synergy_tier4_sting.ogg` |

### 믹스 레벨
| 상황 | Tier4 스팅어 레벨 | 비고 |
|---|---|---|
| 단독 재생 | -3 dBFS | Tier4는 게임의 하이라이트 |
| LOCK 큐와 충돌 시 | **-15 dBFS** (LOCK 덕킹) | LOCK은 여전히 최우선 |
| WALL_HIT와 충돌 시 | -10 dBFS | WALL_HIT 우선 |
| BGM과 동시 재생 | BGM -8dB 덕킹 | Tier4는 더 강하게 BGM 누름 |

---

## 믹스 우선순위 전체 체계

LOCK이 언제나 최우선. 스팅어는 전투 SFX에 절대 간섭하지 않는다.

```
우선순위 1 (최고): lock_primary
우선순위 2:        wall_hit_impact + wall_hit_spikes
우선순위 3:        player_hit_heavy
우선순위 4:        Tier4 스팅어 (드묾 + 카드선택 화면이므로 전투 SFX 없음 가능성 높음)
우선순위 5:        Tier3 스팅어
우선순위 6:        execute SFX (charger_dash_exec 등)
우선순위 7:        telegraph ambient
우선순위 8 (최저): BGM
```

---

## 타이밍 / 충돌 회피 규칙

1. **스팅어는 원칙적으로 카드 선택 화면에서 재생** → 전투 SFX 충돌 최소화.
2. 만약 전투 중 스팅어 트리거 발생 시(예: 특정 카드 즉발 시너지): LOCK 이벤트 감지 후 0.5s 이내면 스팅어 **재생 지연** 0.5s.
3. WALL_HIT 이벤트 감지 후 0.3s 이내면 스팅어 **재생 지연** 0.3s.
4. 지연된 스팅어는 단 1회만 재생. 복수 지연 누적 금지.

---

## TC05 연결

TC05(Tier3 시너지 평균 1회 보장) 패스 기준에서 Tier3 스팅어는 **"시너지 달성을 플레이어가 인지했는가"** 의 오디오 확인 도구.
QA 세션에서: 스팅어 재생 시점 로그 `synergy_audio_played(tier=3, timestamp)` 추가 권장.

---

## 에셋 상태 매니페스트

| ID | 상태 | 파일명 목표 |
|---|---|---|
| `sfx_synergy_tier3_sting` | NEEDED | `sfx_synergy_tier3_sting.ogg` |
| `sfx_synergy_tier4_sting` | NEEDED | `sfx_synergy_tier4_sting.ogg` |

소싱 우선순위: Tier4 > Tier3 (Tier4가 더 강한 인상 필요)

---

## 다음 버전 목표
- v003: Patron별(Blood/Iron/Ash) 스팅어 색 변주 — 같은 Tier라도 패트론마다 다른 톤
- v003: Tier4 Break 시각 효과(화면 플래시)와 오디오 싱크 포인트 정의
