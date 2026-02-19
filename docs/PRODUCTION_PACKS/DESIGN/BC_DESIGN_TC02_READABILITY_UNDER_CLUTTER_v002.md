# BC_DESIGN_TC02_READABILITY_UNDER_CLUTTER_v002
> Assist Dept — Design Team | 2026-02-19 | v002

## 목적
TC02 스트레스 조건(화면 과밀 = 복수 적 동시 Telegraph/LOCK) 에서도 **LOCK 큐가 Telegraph에 묻히지 않도록** 시각적 우선순위를 강제하는 룰셋.
v001 `BC_DESIGN_COMBAT_READABILITY_RULES_v001` 의 "Visual Priority Stack" 항목을 구체적 수치로 확장.

---

## 핵심 원칙: 위험 Intent 최대 3개 강조

화면에 몇 명의 적이 있든 **플레이어가 읽어야 할 Intent 표시기는 최대 3개**를 동시에 "강조(full emphasis)" 상태로 허용한다.
초과분은 자동으로 "dim(감쇠)" 처리된다.

> 근거(Risk Register #2): 모바일 가독성 과밀 → 위험 Intent만 강조, 나머지 투명도↓

---

## 강조 슬롯 배정 알고리즘

매 프레임(또는 적 상태 변경 시) 아래 우선순위 순서로 슬롯을 채운다.

| 순위 | 조건 | 슬롯 가중치 |
|---|---|---|
| 1 | **LOCK 상태** 적 (STATE_COMMITTED) | 필수 — 항상 슬롯 점유 |
| 2 | **LOCK 경로에 플레이어가 포함**된 적 | 슬롯 2번 우선 |
| 3 | **플레이어와 거리 가장 가까운** Telegraph 적 | 슬롯 3번 |
| 4 | 그 외 Telegraph 적 | dim 처리 |

- LOCK 적이 2명이면: 슬롯 1+2 소비 → Telegraph 슬롯은 1개만 허용.
- LOCK 적이 3명이면: 슬롯 전부 소비 → 모든 Telegraph 적 dim 처리.
- 슬롯이 남아도 4번 항목은 최대 1개만 추가 허용(과밀 방지).

---

## 시각 파라미터: 강조 vs dim

| 파라미터 | 강조(full) | dim(감쇠) |
|---|---|---|
| 바닥 표시기 투명도 | 100% | 30% |
| 바닥 표시기 선 두께 | 3px (1080p 기준) | 1px |
| Intent 아이콘 투명도 | 100% | 20% (사실상 숨김) |
| LOCK 아이콘 | 항상 100% — dim 불가 | — |
| 적 본체 아웃라인 | 2px 활성 | 없음 |

**절대 규칙:** LOCK 아이콘과 LOCK 바닥 solid arc는 dim 대상에서 **영구 제외**. LOCK 큐는 어떤 상황에서도 100% 표시.

---

## Dim 전환 애니메이션

- 새 적이 LOCK 진입 → 기존 Telegraph dim 전환: **0.1s 선형 페이드**
- LOCK 적 사망/해제 → 슬롯 재계산 → dim 복원: **0.2s 선형 페이드**
- 페이드 중 플레이어가 대시하면 전환 즉시 완료 (대시는 플레이어 판단 구간 → 빠른 피드백 우선)

---

## 예시 시나리오 3개

### 예시 A — LOCK 1 + Telegraph 2
```
적 구성: Charger(LOCK), Slasher(Telegraph, 근거리), Slasher(Telegraph, 원거리)
슬롯 배정:
  슬롯1 → Charger LOCK (필수)
  슬롯2 → Slasher 근거리 Telegraph (거리 우선)
  슬롯3 → 비어 있음(적 부족)
결과:
  Charger: LOCK 100% + solid red arc
  Slasher 근거리: Telegraph 100%, dotted amber arc
  Slasher 원거리: dim (투명도 30%, 아이콘 20%)
```
> TC01 안전: LOCK은 full, Telegraph 1개는 보조 경고, 원거리는 노이즈 제거.

### 예시 B — Telegraph만 4명 (LOCK 없음)
```
적 구성: Charger(Tel, 근), Slasher(Tel, 근), Shielder(Tel, 중), Charger(Tel, 원)
슬롯 배정 (LOCK 없으므로 거리 순):
  슬롯1 → Charger 근거리
  슬롯2 → Slasher 근거리
  슬롯3 → Shielder 중거리
  초과 → Charger 원거리: dim
결과:
  근거리 2 + 중거리 1: Telegraph 100%
  원거리 Charger: dim 30%
```
> TC02 핵심 케이스: 화면에 4명이어도 플레이어는 3개만 읽으면 됨.

### 예시 C — LOCK 2 + Telegraph 3 (극단 스트레스)
```
적 구성: Charger A(LOCK), Slasher B(LOCK), 나머지 3명(Telegraph)
슬롯 배정:
  슬롯1 → Charger A LOCK
  슬롯2 → Slasher B LOCK
  슬롯3 → Telegraph 적 중 플레이어 가장 가까운 1명
  초과 → 나머지 Telegraph 2명: dim
결과:
  LOCK 2개 full, Telegraph 1개 보조, 나머지 2개 dim
```
> LOCK 2개 동시: 두 LOCK 모두 full 표시. LOCK은 절대 희생 불가.

---

## TC02 QA 체크리스트

- [ ] 화면에 적 4명 이상일 때 바닥 표시기가 '겹쳐 보여 전부 읽기 힘들다'는 피드백 없음
- [ ] LOCK 진입 시 dim 전환이 0.1s 내에 완료되어 LOCK 큐가 묻히지 않음
- [ ] 전체 화면 인디케이터 수가 3개 초과하지 않음(full emphasis 기준)
- [ ] dim 상태 아이콘이 LOCK 아이콘과 혼동되지 않음(투명도 차이로 구분)

---

## 안티패턴

- dim 값을 50% 이상으로 올리지 말 것 — 플레이어가 "왜 이 적의 상태가 안 보이냐"고 느낌
- LOCK 적이 있는데 Telegraph 슬롯에 3개 full 허용 금지 — LOCK이 묻힘
- dim/undim 페이드 시간이 0.3s 초과 시 지연감 발생 — 0.1~0.2s 유지

---

## 다음 버전 목표
- v003: Shielder "reflect window" Intent 표시기 추가 시 슬롯 가중치 재정의
- v003: 적 3명 이상 동시 LOCK 시 카메라 줌아웃 여부(UX 실험 후 결정)
