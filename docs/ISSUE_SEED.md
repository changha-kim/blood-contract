# ISSUE_SEED (from Notion DB)

This is a *suggested* initial issue list for a 4-week PoC.

## Week 0-1: Core hook / 3-second scene

- [DEV] SYS | Intent Combat (Telegraph→Commit→Execute) (P0) — Spec vv0.1.0
- [DEV] SYS | Contract Cards + Tags + Synergy (2/3/4) (P0) — Spec vv0.1.0
- [DEV] SYS | Extract & Reward Lock (Run End) (P1) — Spec vv0.1.0
- [DEV] SYS | Run Clause (PoC) — 엄정 집행 (P1) — Spec vv0.1.0
- [DEV] HZD | Spike Wall — Type: Hazard | Complexity: 2
- [DEV] ENY | Charger (Inquisitor Ram) — Type: Enemy | Complexity: 3
- [DEV] ROOM | Gauntlet Lane — Type: Room | Complexity: 2
- [DEV] ROOM | Thorn Hall — Type: Room | Complexity: 1
- [DEV] ROOM | Ledger Court — Type: Room | Complexity: 3
- [QA] Run TC04 (3초 명장면 재현성) + log evidence

- [QA] Run TC01 (Commit 이해도) quick test


## Week 2: Full PoC content budget

- [DEV] ENY | Slasher (Inquisitor Bladesman) — Type: Enemy | Complexity: 2
- [DEV] ENY | Arbalist (Inquisitor Crossbow) — Type: Enemy | Complexity: 2
- [DEV] BOSS | The Bailiff (MiniBoss) — Type: Boss | Complexity: 4
- [DEV] ROOM | Crossfire Corner — Type: Room | Complexity: 2
- [DEV] ROOM | Pillar Yard — Type: Room | Complexity: 2
- [DEV] Implement all 18 cards as data-driven (tags, benefit/debt UI) — verify synergy tier triggers

- [QA] Run TC02 (텔레그래프 가독성 스트레스)

- [QA] Run TC03 (스파이크 치트/무한루프 방지)


## Week 3: Balance, pacing (6~10 min), logging automation

- [DEV] Logging schema + tools/parse_logs.py to compute: run_time, synergy_tier_counts, commit_events, spike_hits

- [PLAN] Adjust combat math (GDD_09_POC_COMBAT_MATH) based on logs

- [QA] N=20 runs: average run time, crash rate, stuck rate


## Week 4: Polish + Export build

- [DEV] Godot CLI export script (Windows) + release build output

- [ASSET] Pick CC0 asset pack for placeholder art (consistent style) + update assets/CREDITS.md

- [ASSET] Add minimal SFX/BGM (commit cue, spike hit) + credits

- [QA] Final PoC verdict: Pass/Mixed/Fail with evidence bundle
