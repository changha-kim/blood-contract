# BC_AUDIO_MIX_GUIDE_v001
> Assist Dept — Audio Team | 2026-02-19 | v001

## 목적 (PoC)
TC01(Commit=LOCK 인지)과 TC04(Charger→SpikeWall ‘맞았다/데미지 들어갔다’ 확신)를 **소리만으로도** 판별 가능하게 만든다.

우선순위는 단순하다:
1) **LOCK(Commit)** 가 방 안에서 ‘가장 중요한 소리’
2) **WALL_HIT** 가 ‘데미지 확정 소리’
3) DAMAGE_TAKEN(플레이어 피격) / EXECUTE(돌진/베기)
4) TELEGRAPH(예고)는 *있되*, LOCK를 절대 가리지 않기

---

## 믹스 원칙 (핵심 규칙 8개)
1) **LOCK 순간(0프레임)은 절대 마스킹 금지**
   - LOCK SFX가 나는 200ms 동안 다른 SFX를 자동으로 -6dB ~ -12dB ducking.
2) **LOCK는 ‘고역 클릭 + 중저역 바디’의 2층 구조**
   - 클릭(2~6kHz)로 존재감, 바디(120~300Hz)로 ‘무게/확정감’.
3) **WALL_HIT는 ‘저역 임팩트 + 금속 스파이크’ 분리 레이어**
   - `wall_hit_impact`(저역) + `wall_hit_spikes`(고역)을 항상 레이어.
4) TELEGRAPH는 “루프”라도 존재감이 낮아야 함
   - 체감상 거의 안 들려도 됨. 목표는 “불안감”이지 “정보 전달”이 아님.
5) 플레이어 피격은 LOCK/WALL_HIT보다 우선순위 낮음(단, 치명타는 예외)
   - Heavy hit는 컷스루되, LOCK 순간에는 ducking 적용.
6) 동일 이벤트 연타 시 ‘기계총’ 방지
   - 짧은 랜덤 피치(±2~3%) 또는 2~3개 변형 샘플 로테이션.
7) 모바일 스피커/이어폰 모두 고려
   - 150Hz 이하 서브는 과감히 줄이고(HPF), 200~1kHz 정보성 대역을 살린다.
8) 전체는 ‘어둡고 건조’한 톤
   - 잔향은 짧게. PoC에서는 명료도가 최우선.

---

## 상대 레벨(권장, dBFS 기준 가이드)
정확한 수치는 엔진/리미터에 따라 달라서 “상대값”으로 고정한다.

- **LOCK primary**: 기준 0 (가장 큼)
- LOCK accent: -6
- WALL_HIT impact: -2 (LOCK 다음으로 큼)
- WALL_HIT spikes: -6
- WALL_HIT stun/pain: -10
- EXECUTE (charger dash/slash): -8
- DMG enemy_hit_generic: -10
- DMG player_hit_light: -8
- DMG player_hit_heavy: -4 (단, LOCK 순간엔 ducking)
- TELEGRAPH loop: -18 ~ -24

> 체크: LOCK가 들리는 순간 “아, 이제 확정(LOCK)이다”가 1회에 알아차려져야 함.

---

## Ducking 규칙(추천 구현)
- 트리거: `commit_enter` 발생 시
- 대상: TELEGRAPH loop + EXECUTE + ambient 계열
- 값: -9dB
- 시간: attack 10ms / hold 180ms / release 250ms

추가:
- `wall_hit` 발생 시도 짧게 ducking(hold 120ms) 걸면 “데미지 확정감”이 상승.

---

## EQ/필터 가이드(간단)
- LOCK primary
  - HPF 120Hz
  - 2~4kHz 존재감 +2~4dB
  - 7~9kHz 치찰이 거슬리면 -2dB
- WALL_HIT impact
  - HPF 80~100Hz(모바일) / 50~80Hz(PC)
  - 200Hz 주변을 살려 ‘몸통’ 확보
- TELEGRAPH loop
  - 1~2kHz는 과감히 깎아(정보 대역 회피) LOCK와 충돌 방지

---

## QA 체크(이 문서의 합격 기준)
- TC01: 튜토리얼 없이도 LOCK 순간을 소리로 구분 가능(테스터 메모로 확인)
- TC04: 벽 충돌 후 “데미지 들어갔다”를 소리만으로 확신 가능
- 다수 적 상황에서도 LOCK가 안 묻힘(최소 3회 관찰)

---

## v002 후보
- 카드 선택/시너지 Tier3 ‘큰 스팅’ 우선순위 규칙
- Android 기기별 EQ 프리셋(스피커 vs 이어폰)
