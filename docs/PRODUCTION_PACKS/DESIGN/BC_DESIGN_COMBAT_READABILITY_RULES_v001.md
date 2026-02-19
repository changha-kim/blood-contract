# BC_DESIGN_COMBAT_READABILITY_RULES_v001
> Assist Dept — Design Team | 2026-02-19 | v001

## Scope
Mobile-first visual hierarchy rules for the 3-phase Intent Combat loop:
**Telegraph → Commit/LOCK → Execute**
These rules exist to ensure TC01 (Commit distinct from Telegraph) and TC04 (wall-hit moment legible) pass on a ~5-inch screen without HUD clutter.

---

## Phase 1 — TELEGRAPH

**What it communicates:** "Enemy is winding up. You have a window to reposition."

| Element | Rule |
|---|---|
| Floor indicator | Dotted arc or directional arrow, 60–70% opacity |
| Color | Amber / warm yellow (`#FFB830` or similar) |
| Animation | Slow pulse (0.8–1.0s cycle); does NOT flash |
| Enemy body | Slight lean/wind-up pose. No glow. |
| Icon | Intent icon above enemy head (e.g. ⚡ for Charger). Small (32–40px on 1080p). |
| SFX | Subtle low hum or breath-in sound. Quiet. Must NOT compete with LOCK cue. |
| Duration | Variable per enemy; Charger = 1.2–1.8s typical |

**Mobile readability rule:** At 360p/480p equivalent, the dotted arc must still be visible. Min indicator width = 12px on shortest screen dimension.

---

## Phase 2 — COMMIT / LOCK

**What it communicates:** "Direction and intent are now locked. Enemy WILL execute this action. Reposition or use it against them."

This is the CRITICAL differentiation point for TC01. Every element must change visibly from Telegraph.

| Element | Rule |
|---|---|
| Floor indicator | Solid arc/arrow (not dotted). Same shape as Telegraph, now filled. |
| Color | Red / blood red (`#E8202A` or similar). Hard switch from amber — no gradual fade. |
| Animation | Single hard flash (1 frame) on transition, then static. No pulse. |
| Enemy body | Brief full-body red tint (3–5 frames). After tint: subtle outline glow (red, 2px). |
| Lock icon | **Lock icon (🔒) appears above enemy head**, replacing Intent icon. Size: 40–48px on 1080p. |
| Micro-slow | Optional: 0.08–0.12s time-scale drop to 0.6× for player (not enemy) at LOCK moment. Max once per commit. |
| SFX | **Distinct LOCK sound cue** (see BC_AUDIO_SFX_LIST_v001). Must be louder and different timbre from Telegraph hum. |
| Duration | Until Execute begins (enemy action completes). |

**Hard rule:** The Telegraph→LOCK color shift must be distinguishable in grayscale and under mobile screen glare. Use shape change (dotted→solid) as the primary signal, not color alone.

**Hard rule:** Lock icon must not overlap HP bar or player character. Offset upward by 48–64px from enemy sprite top.

---

## Phase 3 — EXECUTE

**What it communicates:** "Action is happening now."

| Element | Rule |
|---|---|
| Floor indicator | Fade out over 0.15s as action begins |
| Enemy body | Motion blur or speed lines if dashing/charging |
| SFX | Execute action sound (charge whoosh, etc.) |
| Special: Wall Hit | If enemy contacts SpikeWall: **dedicated wall-hit feedback** (see TC04 section below) |

---

## TC04 Special — SpikeWall Impact Feedback

**Problem (Known Issue #3):** SpikeWall enemy damage feedback is missing or too subtle; testers can't confirm damage occurred.

**Required feedback chain on Charger→SpikeWall collision:**

1. **Impact frame freeze** — 2–4 frame pause on collision contact (sell the hit weight)
2. **Screen shake** — Short, sharp (0.15s, magnitude 8–12px, bias toward horizontal)
3. **Damage number** — Float above Charger: large font, red, bold. Min size 48px equivalent. Show for 1.2s.
4. **Charger stun indicator** — Charger changes to "stunned" pose/color for 0.5–1.0s. Stars or dizzy icon acceptable.
5. **SpikeWall flash** — Spike tips flash red for 2–3 frames
6. **SFX** — See BC_AUDIO_SFX_LIST_v001 `WALL_HIT` group
7. **Optional micro-text** — "SPIKED!" floating text, small, 0.5s lifetime. Can be toggled off post-PoC.

**TC04 pass criteria link:** Tester must be able to confirm "enemy took damage from wall" with zero ambiguity after the collision.

---

## Visual Priority Stack (mobile, crowded combat)

When multiple enemies are present, use this priority order for emphasis:

1. Any enemy in COMMIT/LOCK state (always top priority — highlight them)
2. Player hit feedback
3. Enemy in Telegraph state (reduce opacity of non-threatening telegraphs to 40% if >2 on screen)
4. Environmental hazards (SpikeWall idle glow = background, not competing)

**Rule:** Never show more than 2 floor indicators at full opacity simultaneously on mobile.

---

## Color Palette (PoC)

| State | Hex | Use |
|---|---|---|
| Telegraph | `#FFB830` | Floor arc, intent icon |
| LOCK | `#E8202A` | Floor arc solid, lock icon, body tint |
| Execute | — | No floor color; motion only |
| Wall Hit / Damage | `#FF4040` | Damage numbers, SpikeWall flash |
| Player safe zone | `#2ECC71` | (Future) safe dash window indicator |

---

## Anti-patterns (do NOT do)

- Do NOT use the same color for Telegraph and LOCK (even similar shades).
- Do NOT animate the LOCK icon (it must be static — "locked").
- Do NOT show damage numbers smaller than 36px equivalent on mobile.
- Do NOT let the floor indicator outlast the Execute phase — it must clear.
- Do NOT add more than 3 simultaneous screen-space effects during TC04 moment (pick: shake + damage number + stun indicator — that's enough).

---

## Next version targets
- v002: Add Slasher + Shielder telegraph/lock variants
- v002: Specify dash-window safe indicator (green arc) timing relative to LOCK
