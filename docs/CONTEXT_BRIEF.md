# CONTEXT_BRIEF (SSOT)
> Keep this file <= 2 pages. This is the ONLY context file Cowork should read.
> Last updated: 2026-02-19

## Game (5 lines)
- Title: **Blood Contract** (Godot 4.x PoC)
- Core loop: read enemy intent → **확정(LOCK)** → survive/position → **집행(Execute)** resolves → rewards/risks via card choice
- Progression axis: 3 Patrons (**Blood / Iron / Ash**) → synergy tiers (**공명**=Tier3, **파기**=Tier4)
- Run ends: **계약 실패** (Death) / **계약 이행** (Clear)
- Tone: dark contract / resonance, short readable mobile UI, no lore dumps

## Locked HUD terms (DO NOT change)
- LOCK/Commit=확정 | Execute=집행 | Tier3=공명 | Tier4=파기 | Death=계약 실패 | Clear=계약 이행

## Current priorities
- P0: TC04 readability/physics fix + audio feedback (wall hit)
- P0: TC01 LOCK cue (audio + basic visual clarity)

## Source-of-truth docs
- Narrative spine: `docs/PRODUCTION_PACKS/NARRATIVE/BC_NARRATIVE_STORYLINE_SPINE_v001.md`
- Narrative pack: `docs/PRODUCTION_PACKS/NARRATIVE/` (microcopy + seeds + logline)
- Audio sourcing plan: `docs/PRODUCTION_PACKS/AUDIO/BC_AUDIO_SFX_SOURCING_PLAN_v003.md`

## Scope guard for Cowork
- Cowork should only touch: `docs/PRODUCTION_PACKS/**` (and optionally `docs/obsidian_vault/00_DASHBOARD.md`)
- Cowork MUST NOT touch: `godot/**` or `.obsidian/**`
