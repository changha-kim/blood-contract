# MEASUREMENT PROCEDURE — Charger Timings

> 목적: Charger(또는 유사 돌진/차지 계열) 타이밍을 재현 가능하게 측정/기록하기 위한 절차 템플릿.
> 주의: 본 문서는 **측정 절차**이며, 전투 룰/타이밍 변경을 지시하지 않는다.

## A) 준비물
- 화면 녹화(권장): 60fps 이상
- 로그(JSONL 등) 저장 경로/파일명:
- 스톱워치/프레임 카운트 도구(선택):

## B) 측정 정의(용어)
- Telegraph start (T0): 시각/사운드 텔레그래프가 시작된 시점
- Commit lock (T1): 플레이어/적이 커밋되어 회피/취소가 제한되는 시점
- Execute impact (T2): 실제 타격/충돌/피해 적용이 발생한 시점
- Recover end (T3): 다음 입력/상태 전환이 정상화되는 시점

## C) 실행 절차
1) 시작 조건을 기록한다(룸/거리/상태 이상 유무).
2) 녹화를 시작한다.
3) 동일 조건에서 Charger 동작을 **N회(권장 10회)** 유도한다.
4) 각 회차마다 아래를 기록한다:
   - Trial #
   - T0/T1/T2/T3 타임스탬프(영상 기준 또는 로그 기준)
   - 예외사항(벽/지형/피격/넉백 등)

## D) 산출값 계산(기록)
- Telegraph duration = T1 - T0
- Commit→Impact = T2 - T1
- Impact→RecoverEnd = T3 - T2
- Total = T3 - T0

## E) 결과 기록 포맷(복붙용)
- Trials:
  - #1: T0=, T1=, T2=, T3=, notes=
  - #2: T0=, T1=, T2=, T3=, notes=
  - …

## F) 주의사항
- 카메라/프레임드랍이 있으면 해당 trial은 제외한다.
- 이벤트/로그 기반으로 측정 시, 이벤트 정의(예: damage_applied, stun_applied)를 함께 명시한다.
