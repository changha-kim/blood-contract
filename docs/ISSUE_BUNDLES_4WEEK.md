# 4-Week PoC Issue Bundle (Detailed)

이 문서는 Notion GDD/DB 기반으로 ‘바로 GitHub 이슈로 만들 수 있게’ 쪼갠 작업 묶음입니다.

## Labels suggestion

- `team:planning`, `team:dev`, `team:qa`, `team:design`
- `prio:P0|P1|P2`
- `size:S|M|L`
- `tc-TC01` ... `tc-TC10`

## Week gates

- **M1 (Week1)**: 3초 장면(TC04) 재현 + Commit UI 최소 전달
- **M2 (Week2)**: 5룸+보스+보상 UI로 런 루프 닫기
- **M3 (Week3)**: 시너지 2/3/4 구현 + 밸런스/치트 방지 + 로그 자동측정
- **M4 (Week4)**: Android 성능/빌드 + 최종 PoC 판정


---

# Week 1

## DEV-001 — Godot 프로젝트/레포 기본 구조 + .gitignore + PACKETS 적용

- Team: Dev
- Priority: P0
- Size: M

- References: GDD_12_DATA_SCHEMA, GDD_02_CONSTITUTION_IMMUTABLE_RULES


**What/Why**

레포에 docs/PACKETS 포함, Godot 캐시(.godot) 등 제외, 기본 실행 씬 구성.


**Acceptance criteria**

- [ ] 프로젝트 실행(Desktop) 1회 성공

- [ ] STATE_PACKET에 Current build 기록

- [ ] GitHub Projects 보드에 'Ready' 기준 문서화



## DEV-002 — Player Controller v0: 이동/공격(오토에임 placeholder)/Dash(쿨/무적)

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC04

- References: GDD_04_COMBAT_UX_MOBILE, GDD_09_POC_COMBAT_MATH


**What/Why**

모바일 우선 컨트롤: 이동 스틱+공격/대시 버튼. Dash: CD 0.75s, 무적 0.12s(초안).


**Acceptance criteria**

- [ ] 대시 입력이 안정적으로 나가고, 쿨다운 표시 가능(텍스트/디버그 OK)

- [ ] 기본 공격이 범위 내 적을 자동 타겟(간단 구현)



## DEV-003 — Intent Combat State Machine v0: Telegraph → Commit → Execute + 이벤트 훅

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC01, TC02, TC04

- References: SYS Intent Combat (Telegraph→Commit→Execute), GDD_04_COMBAT_UX_MOBILE


**What/Why**

적 행동이 3단계로 흘러가도록 상태 머신 구현. Commit 진입 시 '방향/의도 고정' 규칙을 코드로 강제.


**Acceptance criteria**

- [ ] Commit 진입 후 방향이 플레이어 유도 없이 바뀌지 않음

- [ ] Commit 진입 이벤트(log) 발생

- [ ] Telegraph/Commit 시간이 데이터로 조정 가능



## DEV-004 — Telegraph/Commit UI v0: 바닥 텔레그래프 + Intent 아이콘 + LOCK 강조 + SFX 훅

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC01, TC02, TC04

- References: GDD_11_UI_FLOW_POC, GDD_04_COMBAT_UX_MOBILE, GDD_07_RISK_REGISTER


**What/Why**

Commit이 텔레그래프로 오해되지 않도록 시각/청각 큐를 최소 구현.


**Acceptance criteria**

- [ ] Commit 순간: LOCK 아이콘 + 실선/굵기 변화(최소 1개) + SFX 트리거

- [ ] Settings에서 '마이크로 슬로우 0.1s' 토글 가능(옵션)



## DEV-005 — Knockback/Collision v0: 대시 접촉 넉백 + 벽 충돌 판정 + 면역 프레임 훅

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC03, TC04

- References: GDD_09_POC_COMBAT_MATH, GDD_10_SYNERGY_TABLE_POC


**What/Why**

대시/타격으로 적을 밀 수 있어야 3초 장면이 가능. 스파이크 치트 방지용 면역/ICD 훅도 마련.


**Acceptance criteria**

- [ ] 대시 접촉 시 적이 일정 거리 밀림(디버그 수치 OK)

- [ ] 벽 충돌 감지 이벤트(log)

- [ ] 추후 '넉백 면역 0.4s' 적용이 가능하도록 구조화



## DEV-006 — Hazard: Spike Wall v0 (피해=enemy maxHP*0.20, ICD 0.8s) + 플레이어 벽 피해 8%

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC03, TC04

- References: HZD Spike Wall, GDD_09_POC_COMBAT_MATH, GDD_07_RISK_REGISTER


**What/Why**

스파이크 벽 박힘으로 큰 피해/경직. 치트 방지 위해 내부 쿨다운.


**Acceptance criteria**

- [ ] 적 벽박힘 시 피해 적용 및 경직(최소 0.2s)

- [ ] ICD 0.8s 적용

- [ ] 플레이어 벽 피해는 약하게(8%)



## DEV-007 — Enemy Base + Charger v0 (Commit dash)

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC04

- References: ENY Charger (Inquisitor Ram), GDD_09_POC_COMBAT_MATH


**What/Why**

Charger: Telegraph 후 Commit 돌진. Commit 중엔 궤적/의도 고정.


**Acceptance criteria**

- [ ] Charger가 Telegraph→Commit→Execute 사이클 수행

- [ ] Commit 돌진이 Spike Wall로 유도 가능

- [ ] TTK가 대략 7~8s에 근접(초안)



## DEV-008 — Room: Thorn Hall(또는 Trailer Arena) v0 + 3초 장면 재현 시나리오 구성

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC04

- References: ROOM Thorn Hall, GDD_11_UI_FLOW_POC


**What/Why**

Charger 1 + Spike Wall 배치로 3초 명장면 재현. 카메라/입력 안정.


**Acceptance criteria**

- [ ] TC04를 10회 시도해 재현 성공률을 기록할 수 있음(로그/수동)

- [ ] 실패 원인(가독성/조작/룰) 분류 가능



## PLAN-001 — 4주 PoC 기준 'Definition of Done' + 주간 게이트(M1~M4) 확정

- Team: Planning
- Priority: P0
- Size: S

- References: GDD_00_ONE_PAGER, GDD_07_RISK_REGISTER, DB_EXPERIMENTS


**What/Why**

PoC 성공 정의를 TCs로 매핑하고, M1~M4 게이트 기준(뭘 보면 다음 주로 넘어가는지)을 문서로 고정.


**Acceptance criteria**

- [ ] docs/PACKETS/STATE_PACKET.md의 PoC Success criteria 4줄 확정

- [ ] docs/PACKETS/QA_PACKET.md에 이번 주 Must TC 지정



## QA-001 — 로그 스키마 v0 + run_id/room_id/seed 기록 + 핵심 이벤트(commit_enter, wall_hit, synergy_tier)

- Team: QA/Analytics
- Priority: P0
- Size: M

- TCs: TC04, TC07, TC08

- References: GDD_12_DATA_SCHEMA


**What/Why**

PoC는 '측정'이 이김. 최소 로그를 남겨야 후반 튜닝이 가능.


**Acceptance criteria**

- [ ] logs/에 런 단위 로그 파일 생성

- [ ] commit_enter/wall_hit 최소 이벤트 기록

- [ ] run_id로 한 런을 묶을 수 있음



## DES-001 — PoC용 통일 에셋팩 선정 + 최소 스프라이트(플레이어/적/벽) 적용 + CREDITS 기록

- Team: Design
- Priority: P1
- Size: M


**What/Why**

일관성 있는 임시 에셋을 1팩으로 정하고 적용. 나중에 교체 쉬운 구조로.


**Acceptance criteria**

- [ ] assets/CREDITS.md에 출처/라이선스 기록

- [ ] 플레이어/적/스파이크 벽이 시각적으로 구분됨



## DES-002 — SFX placeholder: Commit LOCK / Wall-hit / UI click + 볼륨 슬라이더 연결

- Team: Design
- Priority: P1
- Size: S

- References: GDD_11_UI_FLOW_POC


**Acceptance criteria**

- [ ] Settings에서 BGM/SFX 볼륨 조절 가능

- [ ] Commit 순간에 '소리'가 반드시 남




---

# Week 2

## DEV-101 — Room Manager + 룸 전환/클리어 조건 + 5룸 진행 프레임워크

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC07

- References: GDD_01_CORE_LOOP, GDD_11_UI_FLOW_POC


**Acceptance criteria**

- [ ] 5개의 룸을 순서대로 로드/클리어 가능

- [ ] 룸당 평균 시간 측정 가능(로그)



## DEV-102 — Rooms 5개 배치/스폰 테이블 v0 (Thorn Hall, Crossfire Corner, Pillar Yard, Gauntlet Lane, Ledger Court)

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC07, TC08

- References: ROOM Thorn Hall, ROOM Crossfire Corner, ROOM Pillar Yard, ROOM Gauntlet Lane, ROOM Ledger Court


**Acceptance criteria**

- [ ] 각 룸이 ‘다른 압박’을 제공(원거리/근거리/장애물 등 최소 1개 차이)

- [ ] 스폰이 데이터로 조정 가능



## DEV-103 — Enemy: Slasher v0 (근접) + Intent 표시

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC01, TC02, TC07

- References: ENY Slasher (Inquisitor Bladesman), GDD_09_POC_COMBAT_MATH


**Acceptance criteria**

- [ ] Slasher가 Telegraph→Commit→Execute 수행

- [ ] TTK 목표 5s 내외로 맞출 수 있는 파라미터 존재



## DEV-104 — Enemy: Arbalist v0 (원거리) + Intent 표시

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC02, TC07

- References: ENY Arbalist (Inquisitor Crossbow), GDD_09_POC_COMBAT_MATH


**Acceptance criteria**

- [ ] 원거리 공격 텔레그래프가 과밀을 유발하지 않도록 최소 표현

- [ ] TTK 목표 4s 내외 파라미터



## DEV-106 — UI Flow v0: Main Menu → Run Setup(조항 선택) → Run HUD → Card Reward → Run End

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC01, TC06, TC07

- References: GDD_11_UI_FLOW_POC


**Acceptance criteria**

- [ ] 런이 끊기지 않고 닫힌 루프를 형성(시작→종료→메뉴)

- [ ] Pause/Restart 최소 동작



## DEV-107 — Card Reward Screen v0: 3장 제시/1장 선택/리롤1회/Confirm (Benefit/Debt 분리 표기)

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC06

- References: GDD_03_CARDS_TAGS_SYNERGY, GDD_11_UI_FLOW_POC


**Acceptance criteria**

- [ ] 카드에 Benefit/Debt가 명확히 분리 표시

- [ ] 리롤 1회 제한 동작

- [ ] 선택 확정 전까지 런 진행 불가



## DEV-108 — Card System v0: JSON 로드 + 18장 데이터 입력 + 태그 카운팅(시너지 엔진은 Week3)

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC10

- References: GDD_12_DATA_SCHEMA, DB_CONTENT (Cards), GDD_03_CARDS_TAGS_SYNERGY


**Acceptance criteria**

- [ ] res://data/defs/cards_poc.json 로드

- [ ] 18장 모두 게임 내에서 등장

- [ ] 태그 카운트 HUD 디버그 표시 가능



## PLAN-101 — Week2 목표: 5 Rooms + 3 Enemies + Boss + Card Reward + Run End 루프 닫기

- Team: Planning
- Priority: P0
- Size: S

- References: GDD_01_CORE_LOOP, GDD_11_UI_FLOW_POC, DB_CONTENT, DB_SYSTEMS


**Acceptance criteria**

- [ ] PLAN_PACKET에 Week2 P0 3개/Scope cut/TC 지정



## QA-101 — TC01/TC02/TC06 프로토콜 문서화 + 첫 실행 플레이테스트 시트 생성

- Team: QA/Analytics
- Priority: P0
- Size: M

- References: DB_EXPERIMENTS


**Acceptance criteria**

- [ ] QA_PACKET에 TC01/02/06 수행 절차/측정 항목 추가

- [ ] Mixed/Fail 기준을 문장으로 고정



## DES-101 — Intent/Tag/LOCK 아이콘 세트(임시) + HUD 배치(가독성 우선순위 적용)

- Team: Design
- Priority: P1
- Size: M

- References: GDD_11_UI_FLOW_POC, GDD_04_COMBAT_UX_MOBILE, GDD_07_RISK_REGISTER


**Acceptance criteria**

- [ ] 위험 Intent 최대 3개 강조 정책 반영(초안)

- [ ] 아이콘이 작은 화면에서도 구분됨



## DEV-105 — MiniBoss: The Bailiff v0 (1~2패턴) + PoC 종료(Clear) 구현

- Team: Dev
- Priority: P1
- Size: L

- TCs: TC07

- References: BOSS The Bailiff (MiniBoss), GDD_01_CORE_LOOP, GDD_09_POC_COMBAT_MATH


**Acceptance criteria**

- [ ] 미니보스 처치 시 Clear 엔딩 화면으로 이동

- [ ] TTK 목표 25~35s 튜닝 가능



## DEV-109 — Run Clause (PoC) ‘엄정 집행’ v0: 선택/보상 변화 1개만 구현

- Team: Dev
- Priority: P1
- Size: M

- TCs: TC07

- References: SYS Run Clause (PoC) — 엄정 집행, GDD_11_UI_FLOW_POC


**Acceptance criteria**

- [ ] Run Setup에서 조항 선택 가능

- [ ] 조항 선택 시 카드 제시 수/난이도 중 1개 변화가 체감됨



## DEV-110 — Extract & Reward Lock v0: Extract는 미니보스 이후 1회만

- Team: Dev
- Priority: P1
- Size: M

- TCs: TC07

- References: SYS Extract & Reward Lock (Run End), GDD_01_CORE_LOOP


**Acceptance criteria**

- [ ] Extract 선택이 미니보스 이후에만 등장

- [ ] Extract 엔딩 화면 정상




---

# Week 3

## DEV-201 — Synergy Engine v0: 태그 카운트 → Tier(2/3/4) 판정 → 효과 적용 훅

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC05, TC10

- References: GDD_10_SYNERGY_TABLE_POC, GDD_03_CARDS_TAGS_SYNERGY


**Acceptance criteria**

- [ ] 태그별 Tier 산출

- [ ] Tier 3 달성 시 HUD 팝업+SFX 트리거

- [ ] Tier 4는 1개만이라도 동작



## DEV-202 — Synergy Effects: KNOCKBACK, BLEED, SHIELD, CURSE, CHAIN (PoC table 그대로)

- Team: Dev
- Priority: P0
- Size: L

- TCs: TC05

- References: GDD_10_SYNERGY_TABLE_POC


**Acceptance criteria**

- [ ] 각 태그 Tier 2/3/4 중 최소 2단계 이상 효과 확인 가능

- [ ] 효과가 전투 양상을 바꾸는지 플레이테스트 가능



## DEV-204 — Balance pass v0: Enemy HP/TTK/Spike damage 조정 (combat_math 기준)

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC05, TC07

- References: GDD_09_POC_COMBAT_MATH


**Acceptance criteria**

- [ ] Slasher 5s, Arbalist 4s, Charger 7~8s, Boss 25~35s 목표로 튜닝 가능

- [ ] Spike wall damage 룰 유지(20%, ICD 0.8s)



## DEV-205 — Anti-cheese lock-in: Spike ICD 0.8s + Knockback immunity 0.4s + room-first-wallhit bonus CD

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC03

- References: GDD_07_RISK_REGISTER, DB_EXPERIMENTS TC03


**Acceptance criteria**

- [ ] 무한 벽박힘/스파이크 치트가 현저히 감소(재현 테스트)

- [ ] 수치 변경 시 ADR/Changelog 루틴 적용



## DEV-206 — Run-time tuning v0: 룸당 60~75s 목표에 수렴하도록 스폰/후딜/보상 UI 템포 조정

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC07

- References: GDD_01_CORE_LOOP, DB_EXPERIMENTS TC07


**Acceptance criteria**

- [ ] 20런 샘플에서 중앙값이 6~10분 구간에 근접

- [ ] 룬/보상 화면에서 시간 잡아먹는 구간 기록



## PLAN-201 — Week3 목표: 시너지(2/3/4) 구현 + 밸런스(TTK/런타임) + 치트 방지 수치 고정

- Team: Planning
- Priority: P0
- Size: S

- References: GDD_10_SYNERGY_TABLE_POC, GDD_09_POC_COMBAT_MATH, GDD_07_RISK_REGISTER


**Acceptance criteria**

- [ ] PLAN_PACKET에 Week3 P0/Scope cut/TC05/TC07/TC03 지정



## QA-201 — parse_logs.py v1: TC03/TC05/TC07/TC10 자동 산출 + metrics.csv 출력

- Team: QA/Analytics
- Priority: P0
- Size: L


**What/Why**

로그에서 (런타임/벽박힘 횟수/시너지 티어 달성/카드 선택 분포) 자동 계산.


**Acceptance criteria**

- [ ] python tools/parse_logs.py 실행 시 metrics.csv 생성

- [ ] TC별 Pass/Mixed/Fail에 필요한 수치가 포함



## DEV-203 — 18 Cards effect mapping v0: 각 카드가 태그+효과(간단)로 연결

- Team: Dev
- Priority: P1
- Size: L

- TCs: TC10

- References: DB_CONTENT (Cards), GDD_03_CARDS_TAGS_SYNERGY


**Acceptance criteria**

- [ ] 18장 중 최소 12장은 실제 효과가 있고, 나머지도 '의도된 대가'가 적용

- [ ] 항상 같은 빌드만 나오지 않도록 가중치/풀 조정 여지



## QA-202 — TC08 억울함 분해 프로토콜 + 분류 템플릿 (UI/조작/룰)

- Team: QA/Analytics
- Priority: P1
- Size: M

- TCs: TC08

- References: DB_EXPERIMENTS TC08


**Acceptance criteria**

- [ ] QA_PACKET에 억울함 분류 기준 3종(예시) 문서화

- [ ] 플레이테스트 로그에 원인 태깅 가능




---

# Week 4

## DEV-301 — UI Polish: 위험 Intent 최대 3개 강조, 나머지 투명도↓, 데미지 숫자/텔레그래프 옵션 정리

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC01, TC02

- References: GDD_07_RISK_REGISTER, GDD_11_UI_FLOW_POC


**Acceptance criteria**

- [ ] TC02에서 과밀감이 줄어드는지 관찰 가능(옵션 토글 포함)

- [ ] Commit이 텔레그래프로 오해되지 않음



## DEV-303 — Performance pass: 텔레그래프/VFX/충돌 최적화 + Android FPS/발열 스모크 대비

- Team: Dev
- Priority: P0
- Size: M

- TCs: TC09

- References: DB_EXPERIMENTS TC09


**Acceptance criteria**

- [ ] Android에서 5분 플레이 시 프레임/입력 지연이 크게 무너지지 않음(정성+간단 계측)



## BUILD-301 — Godot CLI export 스크립트(Windows): Android export 1클릭 + 빌드 태그 poc-0.x.y 기록

- Team: DevOps/Build
- Priority: P0
- Size: M

- TCs: TC09


**Acceptance criteria**

- [ ] tools/build.ps1 or build.cmd로 export가 가능

- [ ] build 산출물 폴더 구조 고정

- [ ] STATE_PACKET에 빌드 날짜 기록



## PLAN-301 — Week4 목표: Android 빌드/성능 스모크 + 최종 PoC 판정(Pass/Mixed/Fail)

- Team: Planning
- Priority: P0
- Size: S

- References: DB_EXPERIMENTS TC09, TC01~TC10


**Acceptance criteria**

- [ ] PLAN_PACKET에 최종 게이트/릴리스 체크리스트 반영



## QA-301 — TC09 Android 성능 스모크 실행 + 결과 기록

- Team: QA/Analytics
- Priority: P0
- Size: S

- TCs: TC09

- References: DB_EXPERIMENTS TC09


**Acceptance criteria**

- [ ] QA_REPORT에 프레임/발열/입력 느낌 3항목 기록

- [ ] 재현 가능한 문제는 이슈화



## QA-302 — Final QA Gate: TC01~TC10 중 '필수 세트' 수행 + PoC 판정

- Team: QA/Analytics
- Priority: P0
- Size: M


**Acceptance criteria**

- [ ] PoC Success criteria 4개에 대해 근거(로그/영상/메모)로 결론 작성

- [ ] STATE_PACKET 업데이트



## DES-301 — 최소 아트/오디오 '일관성 패스': 가장 튀는 에셋 교체 + CREDITS 정리

- Team: Design
- Priority: P1
- Size: M


**Acceptance criteria**

- [ ] CREDITS.md 완성

- [ ] UI/적/벽의 스타일 충돌 최소화



## DEV-302 — Input/Feel: 오토에임 우선순위/대시 억울함 완화/마이크로 슬로우 기본값 조정

- Team: Dev
- Priority: P1
- Size: M

- TCs: TC08

- References: GDD_04_COMBAT_UX_MOBILE


**Acceptance criteria**

- [ ] 억울함 케이스 재현 수 감소(기록 기반)

- [ ] 조작이 '먹통'처럼 느껴지는 순간 감소



## DOC-301 — README + GDD_SUMMARY 업데이트 + 데모 플레이 가이드(2분) 작성

- Team: Planning
- Priority: P1
- Size: S


**Acceptance criteria**

- [ ] 처음 켜는 사람이 2탭 이내에 런 시작 가능

- [ ] 3초 장면 재현을 위한 조작 힌트 1줄 포함


