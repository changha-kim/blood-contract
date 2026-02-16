## spec_packets/ADR_CANDIDATES_20260214.md

# Blood Contract PoC — ADR Candidates (Rolling)
Date: 2026-02-14

> ADR format: Context → Decision → Consequences → Validation (TC)

## ADR-POC-001: Intent Combat definition (what is “Commit Lock” precisely?)
- Context: USP depends on “Commit 이후 방향/의도 불변”.
- Decision: Commit 시점, lock 대상(방향 vs 타겟 vs 위치), 예외(보스 면역 등) 정의.
- Consequences: Enemy AI, UI, fairness tuning.
- Validation: TC01 / TC04 / TC08

## ADR-POC-002: Mobile controls baseline
- Context: Android-first, 조작이 USP 전달을 망치면 PoC 실패.
- Decision: two-thumb(가상스틱+버튼) 기본 채택, 오토에임/관용도 범위.
- Consequences: 구현/UX/난이도.
- Validation: TC09 + TC01 재실행

## ADR-POC-003: Run structure hard lock
- Context: 6~10분 목표.
- Decision: 5 rooms + miniboss + extract/death 흐름 고정(이미 GDD에 있으나, 구현 중 스코프 압축 필요 가능).
- Consequences: 콘텐츠/난이도/런타임.
- Validation: TC07

## ADR-POC-004: Offer logic for Synergy Tier3 평균 1회
- Context: TC05/TC10 목표.
- Decision: 카드 제시 3장 + 리롤 1회 + patron 가중치(또는 태그 가중치) 규칙 확정.
- Consequences: 빌드 다양성/운빨 체감.
- Validation: TC05 / TC10
