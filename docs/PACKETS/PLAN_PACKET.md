# PLAN_PACKET (Planner)

## Planning window
- Iteration: **Week 1 (2026-02-16 ~ 2026-02-22)** / Milestone: **M1 — 3초 장면 + Commit UI 최소 전달**
- Pillars: Intent / Synergy / ShortRun / Mobile
- PoC fixed budget: Enemy 3, MiniBoss 1, Hazard 1(Spike Wall), Rooms 5, Cards 18

## This iteration goals (P0)
1) **TC04 3초 장면 재현 루트 완성**: Charger → (Push/Knockback) → Spike Wall 피해까지 “한 룸”에서 재현 가능
2) **Intent Commit이 ‘고정/LOCK’으로 전달되는 최소 UX 구현**(TC01/TC02 선행): Telegraph→Commit→Execute 구분이 화면/사운드 중 최소 1개로 즉시 인지됨
3) **재현/튜닝을 위한 최소 로그 스키마 구축**(QA-001): run_id/room_id/seed + 핵심 이벤트(commit_enter, wall_hit) 기록

## Scope cuts (explicit “NOT doing” list)
- **Week1에는 시너지 엔진/카드 18장 구현 안 함** (Week3 예산)
- **Week1에는 5 Rooms/Run loop(6~10분 수렴) 닫기 안 함** (Week2~3 예산)
- **Week1에는 Android export/성능 최적화 작업 안 함** (Week4 스모크)
- **Week1에는 신규 적(Charger 외) 추가 안 함** (Slasher/Arbalist는 Week2)

## Deliverables (what “done” looks like)
- Build tag: **poc-0.1.0** (제안; 실제 태그는 Dev가 결정)
- Demo scenario: **Thorn Hall(또는 Trailer Arena)**에서 “Charger 1 + Spike Wall”로 TC04 10회 시도 가능
- TCs to run this week: **Must = TC04, TC01(최소), Optional = TC03**

## Must Test (2~4)
- **TC04**: Charger 3초 명장면 재현성(10회 시도, 성공/실패 카운트 기록)
- **TC01 (최소 버전)**: Commit 진입 순간에 “LOCK/고정”이 텔레그래프와 구분되는지 관찰(설명 없이도 1~2회 내 인지)
- **TC03 (옵션/간단)**: Spike wall ICD(0.8s)로 “무한 벽박힘 치트”가 즉시 무력화되는지(로그 wall_hit 빈도/ICD 확인)

## Definition of Done (2~4 lines)
- TC04 룸에서 **Charger가 Telegraph→Commit→Execute를 수행**하고, 플레이어 상호작용으로 **Spike Wall 피해가 적용**된다.
- Commit 순간에 “LOCK(고정)”이 **시각/청각 중 최소 1개 채널**로 전달된다.
- 로그가 **run_id/room_id/seed**로 묶이고, **commit_enter / wall_hit**가 기록된다.

## Risks (top 3) + mitigation
1) **컨트롤/카메라 불안정으로 TC04 재현이 흔들림** → DEV-002/DEV-008에서 “재현 루트 고정(스폰/벽 배치/카메라)” 우선
2) **Commit 전달이 약해 Telegraph로 오해** → DEV-004에서 LOCK 강조(아이콘/선 굵기/색) + SFX 1개를 강제
3) **로그가 늦게 들어가면 튜닝/재현 실패 원인 파악 불가** → QA-001을 Week1 P0에 포함(최소 이벤트만)

## Issue bundle (to create / move to Ready)
- [ ] **DEV-001 Repo/Godot baseline + PACKETS**: Desktop 1회 실행 성공 + STATE_PACKET “Current build” 갱신
- [ ] **DEV-002 Player Controller v0**: 이동/공격 placeholder/대시(CD+무적) 동작 + TC04 룸에서 조작 안정
- [ ] **DEV-003 Intent FSM v0**: Telegraph→Commit→Execute + commit_enter 이벤트 훅(로그)
- [ ] **DEV-004 Telegraph/Commit UI v0**: Commit 순간 LOCK 강조(시각 1 + SFX 1)로 Telegraph와 구분
- [ ] **DEV-005 Knockback/Collision v0**: 대시 접촉 넉백 + wall_hit 이벤트(로그)
- [ ] **DEV-006 Spike Wall v0**: 적 피해(20% maxHP) + ICD 0.8s + 플레이어 8% 적용
- [ ] **DEV-007 Charger v0**: Commit dash가 Spike Wall 유도 가능(기본 TTK 7~8s 튜닝 가능)
- [ ] **DEV-008 Thorn Hall v0**: Charger 1 + Spike Wall 배치 + TC04 10회 시도 기록 가능
- [ ] **QA-001 로그 스키마 v0**: logs/에 런 단위 파일 + run_id/room_id/seed + commit_enter/wall_hit 기록
- [ ] **DES-002 SFX placeholder**(선택): Commit LOCK / Wall-hit / UI click 최소 1개 연결 + 볼륨 슬라이더(가능하면)

## Notes to Dev (Codex)
- Allowed folders: `godot/`(project), `tools/`, `docs/PACKETS/`, `assets/`
- Must update on finish: `STATE_PACKET`의 Current build / Known issues / Next actions
