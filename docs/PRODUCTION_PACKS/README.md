# PRODUCTION_PACKS

This folder contains **content packs** produced in parallel (Narrative / Design / Audio) without touching `godot/**`.

## Rules
- **Do not modify `godot/**`** in assist-team work.
- Prefer editing only under: `docs/PRODUCTION_PACKS/**`.
- Maintain continuity by updating: `docs/PRODUCTION_PACKS/ASSIST_MEMORY.md`.
- Integration into the game happens later via a dedicated **integration PR**.

## Pack structure
- `NARRATIVE/` — story, tone, character bible, naming, in-game text drafts
- `DESIGN/` — UI/UX specs, style guides, wireframes, icon rules
- `AUDIO/` — SFX/BGM lists, naming + export specs, asset manifests (store large binaries via links initially)

## Naming convention
Use versioned filenames so iteration is easy to diff:
- `BC_<TEAM>_<TOPIC>_v###.md`

Examples:
- `BC_NARRATIVE_LOGLINE_v001.md`
- `BC_DESIGN_UI_STYLE_GUIDE_v001.md`
- `BC_AUDIO_SFX_LIST_v001.md`
