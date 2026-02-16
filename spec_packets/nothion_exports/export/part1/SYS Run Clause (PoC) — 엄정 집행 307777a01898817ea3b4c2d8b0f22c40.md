# SYS | Run Clause (PoC) — 엄정 집행

Pillar Fit: Intent, Mobile, ShortRun, Synergy
PoC Scope: Yes
Priority: P1
Risk: Mid
Spec Version: v0.1.0
Status: In PoC

# SYS_RUN_CLAUSE_POC (v0.1.0) — 조항 1개 추천(엄정 집행)

(노션 DB_SYSTEMS에 새 Row로 추가 추천)

## 1) 목적

- PoC 반복 플레이에 “작은 변주”를 제공한다.
- 운영/콘텐츠 추가 없이도 “조건(제약)이 창의성을 만든다”는 철학을 런 시작에 심는다.
- 단, PoC에서는 조항을 ‘1개만’ 제공하여 밸런스 폭발을 방지한다.

## 2) 조항 정의 (PoC 단일 조항)

- ID: CLAUSE_STRICT_ENFORCEMENT
- 이름: 엄정 집행
- 설명(2줄):

  - 적의 Telegraph/Commit이 더 빠르게 확정된다.

  - 대신 계약 선택지가 늘어난다(카드 4장 중 1장 선택).

## 3) 효과(Modifiers) — 구현 난이도 낮게 설계

- enemy_telegraph_time_add: -0.08 (예: 0.70s → 0.62s)
- enemy_commit_time_add: -0.05 (예: 0.20s → 0.15s)
- reward_card_options: 4 (기본 3 → 4)
- reward_rerolls_add: 0 (PoC에서는 리롤 증가 금지)

의도:

- “읽기”가 어려워져 난이도는 올라가지만,
- 카드 선택지가 늘어나 빌드 완성(3단계 시너지) 가능성은 올라간다.
- 즉, 리스크-리턴이 명확하다.

## 4) UI/플로우

- 화면: Run Setup(조항 선택)
- 선택지:

  - A) 엄정 집행(위 조항 적용)

  - B) 무조항(기본값: 적 텔레그래프/커밋 정상, 카드 3장)

## 5) 밸런스 가이드(초안)

- 초보 기준:

  - 무조항으로 TC01/TC04(USP 이해/명장면)가 안정적으로 성공해야 한다.

  - 엄정 집행은 “선택적 난이도 상승”으로 동작해야 한다.

- 엄정 집행에서 억울함이 늘면:

  - 우선 Commit UI 강조(사운드/아이콘/실선)

  - 그다음 enemy_telegraph_time_add를 -0.08 → -0.05로 완화

## 6) PoC Acceptance Criteria

- 무조항 기준:

  - TC01(Commit 이해) 통과가 가능해야 한다.

- 엄정 집행 기준:

  - 난이도는 상승하되 “불공정”이 되지 않아야 한다(TC08 A/B 비율 폭증 금지).

  - 카드 선택지 4장으로 인해 TC05(3단계 시너지 평균 1회)가 악화되면 안 된다.

## 7) Notion/데이터 반영(권장)

run_clauses_poc.json에 아래 1개 항목으로 저장:

{

  "schema_version": "0.1.0",

  "items": [

    {

      "id": "CLAUSE_STRICT_ENFORCEMENT",

      "name": "엄정 집행",

      "description": "적의 확정이 더 빠르다. 대신 계약 선택지가 늘어난다.",

      "enabled_in_poc": true,

      "modifiers": {

        "enemy_telegraph_time_add": -0.08,

        "enemy_commit_time_add": -0.05,

        "reward_card_options": 4,

        "reward_rerolls_add": 0

      }

    }

  ]

}

## 8) 변경 로그(Changelog)

- 2026-02-14 / v0.1.0 / Added / PoC 단일 조항 “엄정 집행” 확정 / 반복 변주 최소 구현 / TC01,TC05,TC08로 검증