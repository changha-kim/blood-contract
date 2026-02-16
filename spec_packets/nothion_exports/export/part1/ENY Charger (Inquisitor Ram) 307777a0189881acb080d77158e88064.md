# ENY | Charger (Inquisitor Ram)

Complexity(1-5): 3
Difficulty(1-5): 3
Last Verified Build: poc-0.1.0 (poc-0%201%200%20307777a0189881048febcef792b7153f.md)
Patron: Neutral
PoC Scope: Yes
Related Systems: SYS | Intent Combat (Telegraph→Commit→Execute) (SYS%20Intent%20Combat%20(Telegraph%E2%86%92Commit%E2%86%92Execute)%20307777a01898814a9d3df5820fce8fe9.md)
Status: Spec
Tags: INTENT, KNOCKBACK
Type: Enemy

# Charger

## Role

Spike Wall 쇼케이스. “유도/오용” 쾌감을 최대화.

## Intents

1) Bull Charge

- Telegraph: thick line 6m + big dmg number
- Commit: LOCK direction + 0.2s prep
- Execute: charge, stops on collision
- Recover: 0.90s (wall hit: 1.20s)

2) Shoulder Smash

- Telegraph: circle 2.0m
- Commit: LOCK position
- Execute: knockback + dmg
- Recover: 0.80s

## Spike Wall Interaction

- Bull Charge를 스파이크 벽에 유도하면 큰 스턴+피해.