# ASSIST_BRIEF — Blood Contract PoC (Assist Teams)

## One-liner
A 4-week Godot PoC to prove **Intent Combat (Telegraph → Commit/LOCK → Execute)** and reproduce a **TC04 “3-second trailer moment”**: Charger committed charge → bait → spike wall damage.

## Read order (SSOT)
1) `docs/PACKETS/STATE_PACKET.md` (what matters *now*)
2) `docs/GDD_SUMMARY.md` (design intent summary)
3) `docs/PACKETS/QA_PACKET.md` (test cases / pass criteria)

## Hard constraints (to avoid conflicts)
- **DO NOT modify `godot/**`**.
- Output only under: `docs/PRODUCTION_PACKS/**`.
- Keep deliverables short + versioned: `BC_<TEAM>_<TOPIC>_v###.md`.
- Large binaries (audio/images) → **links + manifest** first.

## Current priorities (Week 1)
- Must support:
  - **TC04**: Charger hits spike wall and enemy damage is clearly confirmed.
  - **TC01/TC02**: Commit/LOCK readability (visual hierarchy + SFX cues).

## Where your output goes
- Narrative: `docs/PRODUCTION_PACKS/NARRATIVE/`
- Design: `docs/PRODUCTION_PACKS/DESIGN/`
- Audio: `docs/PRODUCTION_PACKS/AUDIO/`

## Integration policy
Assist outputs are "packs". We integrate later via a dedicated **integration PR** once the PoC loop is stable.
