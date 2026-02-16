# SYS | Intent Combat (Telegraph→Commit→Execute)

Last Verified Build: poc-0.1.0 (poc-0%201%200%20307777a0189881048febcef792b7153f.md)
Pillar Fit: Intent, Mobile
PoC Scope: Yes
Priority: P0
Related ADR: ADR | Make Intent Combat Immutable (ADR%20Make%20Intent%20Combat%20Immutable%20307777a018988112a465e5049b6c7186.md), ADR | Choose Spike Wall over Pit (PoC) (ADR%20Choose%20Spike%20Wall%20over%20Pit%20(PoC)%20307777a018988172a076e9a25e7e6689.md)
Related Content: HZD | Spike Wall (HZD%20Spike%20Wall%20307777a0189881168b0eedc267753885.md), ENY | Slasher (Inquisitor Bladesman) (ENY%20Slasher%20(Inquisitor%20Bladesman)%20307777a0189881b0afb1f06f483a42f6.md), ENY | Arbalist (Inquisitor Crossbow) (ENY%20Arbalist%20(Inquisitor%20Crossbow)%20307777a0189881e6a022d5f878d47dab.md), ENY | Charger (Inquisitor Ram) (ENY%20Charger%20(Inquisitor%20Ram)%20307777a0189881acb080d77158e88064.md), BOSS | The Bailiff (MiniBoss) (BOSS%20The%20Bailiff%20(MiniBoss)%20307777a0189881689e57f0fa3718e833.md), ROOM | Thorn Hall (ROOM%20Thorn%20Hall%20307777a01898812daa2af14de711e2b7.md), ROOM | Crossfire Corner (ROOM%20Crossfire%20Corner%20307777a0189881b6a731ca393ee9bd7b.md), ROOM | Pillar Yard (ROOM%20Pillar%20Yard%20307777a0189881e6812ddaa51b8f98f5.md), ROOM | Gauntlet Lane (ROOM%20Gauntlet%20Lane%20307777a018988188b889d19f8122444f.md), ROOM | Ledger Court (ROOM%20Ledger%20Court%20307777a01898812eb026e6bb08de79b3.md)
Related Experiments: EXP | PoC-001 | First Internal Playtest (EXP%20PoC-001%20First%20Internal%20Playtest%20307777a0189881488400f92ea9501dec.md)
Risk: High
Spec Version: v0.1.0
Status: In PoC

# Intent Combat System (v0.1.0)

## Goal

반사신경 게임이 아니라 **예측 기반 전술** 게임으로 만든다. Commit(잠금) 이후 적의 “의도/방향”은 바뀌지 않아야 하며, 플레이어는 넉백/지형(Spike Wall)로 그 확정을 ‘망치게’ 만든다.

## State Machine (common)

- ChooseIntent → Telegraph → Commit(LOCK) → Execute → Recover

## Core Rules

- Telegraph: 공격 형태(선/원/콘) + 예상 피해(숫자) 표시
- Commit: 방향/대상 확정(아이콘 자물쇠 + 궤적 실선/굵게)
- Execute: 발동
- Recover: 반격 창

## Mobile UX Rules

- 위험 Intent만 강하게 표시(최대 3개), 나머지 투명도↓
- Commit 순간 0.1s 마이크로 슬로우(옵션)
- “유도 성공”은 특별 피드백(사운드+짧은 텍스트+슬로우)

## Anti-cheese

- Spike Wall damage internal cooldown: 0.8s
- Knockback resistance i-frames: 0.4s (연속 넉백 루프 방지)

## Acceptance Criteria (PoC)

- 설명 없이 Commit(잠금)을 이해한다(행동 변화로 검증).
- 한 런에서 유도/오용 성공 1회 이상.
- 사망 원인이 “억울함”보다 “판단 실수”로 설명 가능.