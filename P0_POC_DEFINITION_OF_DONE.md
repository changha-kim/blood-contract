# Blood Contract — PoC Definition of Done (DoD)

PoC는 콘텐츠 양이 아니라 **핵심 재미(USP)가 살아있는지** 검증하는 버전.

## PoC Done (4 conditions)

### 1) Commit Combat이 전달된다 (USP)
- 적이 **Telegraph → Commit(잠금) → Execute** 를 수행한다.
- 플레이어가 **Commit 이후 변하지 않는 확정**을 이용해 **유도/오용(예: Spike Wall 박치기)** 으로 이득을 만든다.
- Validation: DB_EXPERIMENTS
  - TC01 Commit 이해도(무설명 학습)
  - TC04 Charger 3초 명장면
  - TC08 공정성(억울함) 분류

### 2) 6~10분 런 루프가 작동한다
- **5룸 + 미니보스 + (Extract/Death)** 까지 1판이 닫힌다.
- Validation: TC07 런타임 목표

### 3) 카드/태그/시너지 3단계가 ‘평균 1회’ 가능한 구조
- 18장 PoC 카드로도 런당 **Tier3**가 평균 1회 이상 가능하도록(초기 목표) 카드 제시/리롤/가중치 튜닝.
- Validation: TC05 / TC10

### 4) Android에서 조작/가독성/성능이 PoC로서 치명적이지 않다
- “Commit 읽기/대시 타이밍”이 입력지연/프레임 드랍 때문에 망가지지 않는다.
- Validation: TC09

## Notes
- TC 결과는 **Pass/Mixed/Fail** 로 DB_EXPERIMENTS에 기록.
- 설계 변경은 **ADR** 로 남긴다(왜/대안/영향/채택여부).
