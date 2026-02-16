# STATE_PACKET (Single Source of Truth)

> 이 파일은 “에이전트/세션”이 아니라 “프로젝트”가 기억하는 곳입니다.
> 모든 에이전트(Planner/Critic/Dev/QA/Art/Audio)는 작업 시작 전에 이 파일을 읽고,
> 작업 종료 시 **아래 4개 섹션만** 업데이트합니다:
> - Current build / Current focus / Known issues / Next actions

## Project
- Name: (프로젝트명)
- Engine: Godot 4.x
- Platform target (PoC): Android + Desktop smoke (optional)
- Repo: (GitHub URL)

## PoC Goal
- PoC window: 4 weeks (start: 2026-02-16)
- Success criteria (from GDD_00_ONE_PAGER):
  1) Commit Combat이 “텔레그래프”로 오해되지 않는다 (TC01/TC02)
  2) 3초 트레일러 장면(Charger → push → Spike Wall)이 재현된다 (TC04)
  3) 런 구조가 6~10분에 수렴한다 (TC07)
  4) 시너지 3단계가 평균 1회 이상 나온다 (TC05)

## Current build
- Version tag: poc-0.x.y
- Last successful run: YYYY-MM-DD
- Last export build: YYYY-MM-DD (Android / Desktop)

## Current focus (this week)
- Milestone: M? (Week ?)
- P0 goals (max 3):
  1)
  2)
  3)

## Known issues (top 5)
1)
2)
3)
4)
5)

## Next actions (do next; max 5)
1)
2)
3)
4)
5)

## Links
- GDD summary: docs/GDD_SUMMARY.md
- Experiments / TCs: docs/PACKETS/QA_PACKET.md
- Planning: docs/PACKETS/PLAN_PACKET.md
- Critique: docs/PACKETS/CRITIC_PACKET.md
