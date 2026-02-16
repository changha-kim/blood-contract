# SYS | Contract Cards + Tags + Synergy (2/3/4)

Last Verified Build: poc-0.1.0 (poc-0%201%200%20307777a0189881048febcef792b7153f.md)
Pillar Fit: Mobile, ShortRun, Synergy
PoC Scope: Yes
Priority: P0
Related ADR: ADR | Primary Fun = Build Explosion(B) (ADR%20Primary%20Fun%20=%20Build%20Explosion(B)%20307777a01898815e8df8ed8a799b8b41.md)
Related Content: CARD | Blood-01 | 피의 도장 (CARD%20Blood-01%20%ED%94%BC%EC%9D%98%20%EB%8F%84%EC%9E%A5%20307777a018988157ade7d5714ac3dbb8.md), CARD | Blood-02 | 도살자의 서약 (CARD%20Blood-02%20%EB%8F%84%EC%82%B4%EC%9E%90%EC%9D%98%20%EC%84%9C%EC%95%BD%20307777a01898811dbf9fecb3a1759852.md), CARD | Blood-03 | 피의 분출 (CARD%20Blood-03%20%ED%94%BC%EC%9D%98%20%EB%B6%84%EC%B6%9C%20307777a0189881c9bb90f18bfa036e49.md), CARD | Blood-04 | 광기의 대시 (CARD%20Blood-04%20%EA%B4%91%EA%B8%B0%EC%9D%98%20%EB%8C%80%EC%8B%9C%20307777a0189881ae9f66ece1eca37e4e.md), CARD | Blood-05 | 피로 쓴 계약서 (CARD%20Blood-05%20%ED%94%BC%EB%A1%9C%20%EC%93%B4%20%EA%B3%84%EC%95%BD%EC%84%9C%20307777a01898812b9125e3a688e42646.md), CARD | Blood-06 | 사형 집행의 연서 (CARD%20Blood-06%20%EC%82%AC%ED%98%95%20%EC%A7%91%ED%96%89%EC%9D%98%20%EC%97%B0%EC%84%9C%20307777a01898815da9fae185a647b84b.md), CARD | Iron-01 | 강철 가죽 (CARD%20Iron-01%20%EA%B0%95%EC%B2%A0%20%EA%B0%80%EC%A3%BD%20307777a0189881299ed9d5cedd022fbf.md), CARD | Iron-02 | 가시의 갑주 (CARD%20Iron-02%20%EA%B0%80%EC%8B%9C%EC%9D%98%20%EA%B0%91%EC%A3%BC%20307777a018988119b93bf26373440916.md), CARD | Iron-03 | 벽의 충성 (CARD%20Iron-03%20%EB%B2%BD%EC%9D%98%20%EC%B6%A9%EC%84%B1%20307777a0189881db8ff3ec5484b5fb2e.md), CARD | Iron-04 | 충격의 망치 (CARD%20Iron-04%20%EC%B6%A9%EA%B2%A9%EC%9D%98%20%EB%A7%9D%EC%B9%98%20307777a01898819a8a77cf15f6c02482.md), CARD | Iron-05 | 수호자의 서약 (CARD%20Iron-05%20%EC%88%98%ED%98%B8%EC%9E%90%EC%9D%98%20%EC%84%9C%EC%95%BD%20307777a018988101b5d1fd4cfe52bf15.md), CARD | Iron-06 | 철의 법전 (CARD%20Iron-06%20%EC%B2%A0%EC%9D%98%20%EB%B2%95%EC%A0%84%20307777a0189881ef95e8eb993d4b022e.md), CARD | Ash-01 | 재의 낙인 (CARD%20Ash-01%20%EC%9E%AC%EC%9D%98%20%EB%82%99%EC%9D%B8%20307777a01898814a8f5ee1145bdc7ec1.md), CARD | Ash-02 | 연쇄의 속삭임 (CARD%20Ash-02%20%EC%97%B0%EC%87%84%EC%9D%98%20%EC%86%8D%EC%82%AD%EC%9E%84%20307777a0189881dda30ffd58c4938ed4.md), CARD | Ash-03 | 불길한 예고 (CARD%20Ash-03%20%EB%B6%88%EA%B8%B8%ED%95%9C%20%EC%98%88%EA%B3%A0%20307777a018988125bd34e61aeb234925.md), CARD | Ash-04 | 사자의 실 (CARD%20Ash-04%20%EC%82%AC%EC%9E%90%EC%9D%98%20%EC%8B%A4%20307777a018988115a9eed7373b85d831.md), CARD | Ash-05 | 계약 파기 (CARD%20Ash-05%20%EA%B3%84%EC%95%BD%20%ED%8C%8C%EA%B8%B0%20307777a01898812d8485f70aa05a1ced.md), CARD | Ash-06 | 강제 확정 (CARD%20Ash-06%20%EA%B0%95%EC%A0%9C%20%ED%99%95%EC%A0%95%20307777a018988177a589cf6c69c59e22.md)
Related Experiments: EXP | PoC-001 | First Internal Playtest (EXP%20PoC-001%20First%20Internal%20Playtest%20307777a0189881488400f92ea9501dec.md)
Risk: Mid
Spec Version: v0.1.0
Status: In PoC

# Contract Cards + Synergy (v0.1.0)

## Goal

18장만으로도 “이번 판 빌드가 달라졌다”를 체감. 시너지는 운빨이 아니라 **선택의 결과**로 느껴져야 한다.

## PoC Deck

- Blood 6 / Iron 6 / Ash 6 = 18 cards
- Card UI: Benefit / Debt 분리, 태그 2~3개 이내

## Reward Beat

- 룸 클리어 후 카드 3장 → 1장 선택
- 리롤 1회
- Patron 선택으로 카드 풀 가중치(추후 고도화)

## Synergy Tiers

- 2: Minor (즉시 체감)
- 3: Major (전술이 바뀜)
- 4: Break (하이라이트)

## Acceptance Criteria (PoC)

- 2룸 내 시너지 2단계 1회 이상 가능
- 5룸 종료 시 시너지 3단계 평균 1회 이상 가능(리롤/가중치로 조정)