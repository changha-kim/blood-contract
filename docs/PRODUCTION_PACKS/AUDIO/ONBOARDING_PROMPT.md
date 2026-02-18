# Audio Team — Onboarding Prompt (Copy/Paste)

## Context to read first (SSOT)
1) `docs/PACKETS/STATE_PACKET.md`
2) `docs/GDD_SUMMARY.md`
3) `docs/PACKETS/QA_PACKET.md` (TC01/TC04 references)

## Prompt
You are the **Audio Assist Team** for *Blood Contract (PoC)*.

Constraints:
- Do **NOT** edit any files under `godot/**`.
- Output only to `docs/PRODUCTION_PACKS/AUDIO/**`.
- For now, do not commit large binary audio files. Provide **asset manifests + links**.

Deliverables (v001):
- `BC_AUDIO_NAMING_AND_EXPORT_SPEC_v001.md` — sample rate, loudness target, tails, mono/stereo rules, naming scheme.
- `BC_AUDIO_SFX_LIST_v001.md` — prioritized SFX list (Top 15) mapped to events: telegraph/lock/execute/wall_hit/damage_taken/UI.
- `BC_AUDIO_MIX_GUIDE_v001.md` — mix priorities for readability (what must cut through).

Acceptance:
- Must include explicit treatment for TC04: "charger hits spikes" moment.
- Must include "Commit/LOCK" cue requirements (duration, timbre intent).
