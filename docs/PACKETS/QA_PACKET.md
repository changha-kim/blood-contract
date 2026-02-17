# QA_PACKET (Experiments / Test Cases)

## PoC Experiments (from Notion DB_EXPERIMENTS)
- TC01 Commit 이해도 — 무설명 학습
- TC02 텔레그래프 가독성 — 정보 과밀
- TC03 스파이크 치트/무한루프 방지
- TC04 Charger 3초 명장면 재현성
- TC05 시너지 3단계 평균 1회 보장
- TC06 카드 UI(이득/대가) 이해도
- TC07 런타임(6~10분) 수렴
- TC08 공정성(억울함) 분해
- TC09 Android 성능 스모크 테스트
- TC10 빌드 다양성 분포

## This week scope (Week 1 / M1)
- Must run:
  - **TC04** (3초 장면 재현성)
  - **TC01 (최소 버전)** (Commit=LOCK 인지)
- Optional:
  - **TC03 (간단)** (Spike ICD로 치트 방지 스모크)

## Measurement rules (log-based preferred)
- Required log events:
  - **run_start** (run_id, room_id, seed)
  - **commit_enter** (enemy_id/type, telegraph_ms, commit_ms)
  - **wall_hit** (target=enemy/player, hazard=spike, damage, icd_applied)
  - **tc04_attempt** (attempt_id, success_bool, fail_reason_enum(optional))
- Output:
  - `docs/QA_REPORT.md` (수동 요약 1페이지)
  - `logs/` (런 단위 로그 파일)

## Automation (optional)
- TC04 can be auto-run via command line flags (for agent-driven smoke runs):
  - `--tc04-auto` (defaults to 10 attempts)
  - `--tc04-auto=10`
  - `--tc04-timeout=6.0`
  - `--tc04-no-quit` (do not quit after finishing)

### Note (autorun success criteria)
- Headless autorun uses a **relaxed success trigger** for stability:
  - success when SpikeWall applies **enemy damage** (charger hit causes damage)
  - (induced_success still logs separately, but is not required for autorun success)

## Pass / Mixed / Fail rubric
- Pass:
  - TC04: 10회 시도 중 **≥3회** 재현 성공(Week1 기준 임시) + 실패 사유가 분류 가능
  - TC01(min): Commit 순간에 LOCK 신호(시각/청각)가 **텔레그래프와 구분**된다는 관찰 기록(테스터 1인이라도 가능)
- Mixed:
  - TC04: 재현은 되나 성공률 <3/10, 또는 성공/실패 원인 분류가 불가
  - TC01: LOCK 신호가 있으나 텔레그래프와 혼동이 잦음
- Fail:
  - TC04: 재현 불가(Spike 피해까지 연결 실패) 또는 Charger 루프 자체가 불안정
  - TC01: Commit과 Telegraph가 체감상 구분되지 않음(‘똑같아 보임’)
