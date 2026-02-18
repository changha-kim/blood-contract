# QA_PACKET (실험 / 테스트 케이스)

## PoC Experiments (Notion DB_EXPERIMENTS 기반)
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

## 이번 주 범위 (Week 1 / M1)
- Must run:
  - **TC04** (3초 장면 재현성)
  - **TC01 (최소 버전)** (Commit=LOCK 인지)
- Optional:
  - **TC03 (간단)** (Spike ICD로 치트 방지 스모크)

## 측정 규칙 (가급적 로그 기반)
- Required log events (canonical / 이벤트명은 그대로 유지):
  - **run_start**: `run_id`, `room_id`, `seed`, `ts_msec`
  - **commit_enter**: `run_id`, `enemy_id`, `enemy_type`, `telegraph_ms`, `commit_ms`, `ts_msec`
  - **wall_hit**: `run_id`, `target`(enemy|player), `hazard`(spike), `damage`, `icd_applied`, `ts_msec`
  - **tc04_attempt**: `run_id`, `room_id`, `attempt_id`, `success_bool`, `fail_reason_enum?`, `ts_msec`
- fail_reason_enum (실패 시): `control|readability|rules|other`

### 산출물(Output)
- `docs/QA_REPORT.md` (수동 요약 1페이지)
- `logs/` (런 단위 로그 파일 권장)
- (optional) `test_results/qa_report_draft.md` (파서가 생성한 초안)

## 자동화(옵션)
- TC04는 CLI 플래그로 auto-run 가능(에이전트 스모크용):
  - `--tc04-auto` (기본 10 attempts)
  - `--tc04-auto=10`
  - `--tc04-timeout=6.0`
  - `--tc04-no-quit` (종료하지 않고 유지)

### Note (autorun success criteria)
- headless autorun은 안정성을 위해 **완화된 성공 기준** 사용:
  - SpikeWall이 **enemy damage**를 적용하면 success (charger가 맞아서 데미지 발생)
  - (추가로 induced_success도 로그는 남기지만, autorun success의 필수 조건은 아님)

## Pass / Mixed / Fail 판정 기준
- Pass:
  - TC04: 10회 시도 중 **≥3회** 재현 성공(Week1 임시 기준) + 실패 사유 분류 가능
  - TC01(min): Commit 순간 LOCK 신호(시각/청각)가 **텔레그래프와 구분**된다는 관찰 기록(테스터 1인도 가능)
- Mixed:
  - TC04: 재현은 되나 성공률 <3/10, 또는 성공/실패 원인 분류가 불가
  - TC01: LOCK 신호는 있으나 텔레그래프와 혼동이 잦음
- Fail:
  - TC04: 재현 불가(Spike 피해까지 연결 실패) 또는 Charger 루프 자체가 불안정
  - TC01: Commit과 Telegraph가 체감상 구분되지 않음(“똑같아 보임”)
