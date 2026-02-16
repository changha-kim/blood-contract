# GDD_SUMMARY (from Notion export)

> Source docs in your Notion export:
> - GDD_00_ONE_PAGER 307777a01898817ab223d9e159ad99bd.md
> - GDD_01_CORE_LOOP 307777a0189881c98565e21ca3d87707.md
> - GDD_02_CONSTITUTION_IMMUTABLE_RULES 307777a01898818babc2d1f98cc5c495.md
> - GDD_03_CARDS_TAGS_SYNERGY 307777a01898814a8e08ee395d6fc847.md
> - GDD_04_COMBAT_UX_MOBILE 307777a0189881a8a25dc3fa7299dc48.md
> - GDD_05_CONTENT_BUDGET_AND_RULES 307777a0189881539b97f7e66f98b8ad.md
> - GDD_07_RISK_REGISTER 307777a0189881038071e9bfd6786c22.md

## One Pager: Promise / Hook / 3-second scene / Content budget
# GDD_00_ONE_PAGER

# One Pager (v0.1.0)

## The Promise (플레이어 약속 3개)

- 적의 의도가 보인다. **이제 네가 판을 짠다.**
- 빌드가 완성되면 전투 양상이 바뀐다(2/3/4단계 시너지).
- 모바일에서도 한 판이 짧고 선명하게 끝난다(6~10분).

## The Hook (USP)

**Commit Combat**: Telegraph로 보이고, Commit으로 “확정”되면 방향/의도는 바뀌지 않는다. 플레이어는 밀치기/유도로 적의 확정을 “망치게” 만든다.

## 3초 트레일러 장면

Charger가 Commit 돌진 → 플레이어가 옆으로 피하며 밀쳐서 **Spike Wall에 박음** → 경직/큰 피해 → 시너지 폭발.

## PoC Content Budget (고정)

- Enemies 3, MiniBoss 1, Hazard 1(Spike Wall), Rooms 5, Cards 18(3 Patron×6)

## Core loop & run structure
# GDD_01_CORE_LOOP

# Core Loop (v0.1.0)

## Run Structure (목표 6~10분)

- 전투 룸 5개 + 미니보스 1
- 룸당 평균 60~75초 (전투+선택 포함)

## Reward Beats

- 룸 클리어 후 카드 3장 제시 → 1장 선택
- 리롤 1회 제공
- PoC에서는 Extract(중도 종료)은 ‘미니보스 이후 1회’로 단순화(선택 UX 검증)

## End States

- Death: 런 종료(최소 보상)
- Extract: 안전 종료(중간 보상)
- Clear(미니보스 처치): PoC 종료 기준(상대적으로 큰 보상)

## Immutable pillars / lock rule
# GDD_02_CONSTITUTION_IMMUTABLE_RULES

# Constitution (v0.1.0)

## Immutable Pillars

- Intent / Synergy / ShortRun / Mobile

## 금지 리스트(우리가 만들지 않는 게임)

- 30~60분 장기 런 전제 하드코어 로그라이크
- 버튼 6개 이상 요구하는 정교 액션
- 시즌/이벤트/UA 전제 라이브옵스
- 컷신 중심 내러티브 RPG

## Lock Rule

- Status=Locked 변경 시: Experiment 기록 → ADR 작성 → Changelog → 버전 업데이트

## Cards / tags / synergy tiers (PoC)
# GDD_03_CARDS_TAGS_SYNERGY

# Cards / Tags / Synergy (v0.1.0)

## Patrons

- Blood / Iron / Ash (각 6장씩 PoC)

## Tags (PoC 제한)

BLEED, EXECUTE, CURSE, CHAIN, SHIELD, THORN, KNOCKBACK, INTENT

## Synergy Tiers

- 2: Minor (체감 작은 보너스)
- 3: Major (운영이 바뀜)
- 4: Break (판이 뒤집힘, 하이라이트)

## Card UI Rule

- Benefit(이득) / Debt(대가) 분리 표기
- 태그 아이콘 2~3개 이내

## Combat UX (mobile-first)
# GDD_04_COMBAT_UX_MOBILE

# Combat UX (Mobile-first) v0.1.0

## Controls

- Left stick: Move
- Buttons: Attack(오토에임), Dash(넉백/유도 핵심), Skill1

## Auto-aim (PoC)

- 우선순위: Commit 중 위협 > 근접 > 원거리
- 헛스윙 최소화(범위 내 적이 있으면 자동 타겟)

## Telegraph/Commit UI

- 바닥 텔레그래프 + Intent 아이콘
- Commit 순간: 자물쇠/실선/사운드 큐
- (옵션) 마이크로 슬로우 0.1s

## Feedback

- 유도 성공(벽 박힘/아군오인/빗나감) 시: 특수 사운드 + 슬로우 + 짧은 텍스트

## Content budget rule
# GDD_05_CONTENT_BUDGET_AND_RULES

# Content Budget (PoC fixed) v0.1.0

## PoC Fixed

- Enemy 3, MiniBoss 1, Hazard 1(Spike Wall), Rooms 5, Cards 18

## Expansion Rule (PoC 통과 후만)

- Enemy 6, Rooms 12, Cards 36
- “종류”보다 “모듈/재조합” 우선

## Risk register (Top 5)
# GDD_07_RISK_REGISTER

# Risk Register (Top 5)

1) Commit이 그냥 텔레그래프로 오해됨 → Commit UI/사운드/숫자 표시 강화

2) 모바일 가독성 과밀 → 위험 Intent만 강조, 나머지 투명도↓

3) 넉백/스파이크 치트 → 내부 쿨다운/면역 프레임

4) PoC 이후 확장 생산성 → Patron×Tags 생산라인 고정

5) 런 길이 증가 → 룸당 목표 타임 강제
