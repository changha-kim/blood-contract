# BC_DESIGN_LOCK_MOMENT_SPEC_v001
> Assist Dept — Design Team | 2026-02-19 | v001

## Purpose
Exact specification of everything that must fire at the instant an enemy transitions from **Telegraph → Commit/LOCK**. This is the single most important UX moment for TC01 pass.

"LOCK" = enemy direction/intent is now immutable. Player must read this and decide to dodge, bait, or counter.

---

## Trigger Definition

| Field | Value |
|---|---|
| Event name | `commit_enter` |
| Log key | `commit_enter(enemy_id, telegraph_ms, commit_ms)` |
| Who fires | Enemy state machine, on transition to `STATE_COMMITTED` |
| Godot signal | `enemy_committed(enemy_node)` (consumed by FX manager) |

The LOCK moment spec defines everything the **FX/UX layer** does in response to `enemy_committed`. Dev team owns the signal; Assist owns what fires.

---

## The Pop — Complete Simultaneous Burst

All elements below fire on the **same frame** as `commit_enter`. No delays between elements.

### 1. Floor Indicator Snap

- Dotted amber arc → **solid red arc**, same shape.
- Transition: **instant** (1 frame). No tween, no fade. The snap is the signal.
- Arc width increases by ~20% at snap (emphasizes "locked" hitbox).

### 2. Lock Icon Drop

- Intent icon (e.g. ⚡) → **replaced by lock icon (🔒)**.
- Drop animation: icon scales from 130% → 100% over 3 frames (quick "stamp" feel).
- Position: centered above enemy, 48–64px above sprite top edge.
- Color: white icon on red circular background (`#E8202A`). High contrast.
- Icon must NOT animate after the drop-stamp — it holds static.

### 3. Enemy Body Flash

- Full-body color tint: red (`#FF3333`), 3–5 frames only.
- After flash: thin red outline remains for LOCK duration (2px glow).
- Do NOT sustain a full-body tint — the flash is the "notification", the outline is the "reminder".

### 4. Micro-Slow (Optional — recommended ON for PoC)

- On `commit_enter`: set `Engine.time_scale = 0.55` for `0.10s`, then restore to `1.0`.
- Applies to **everything** (simpler) or player + UI only (smoother feel — preferred if implementable).
- Must NOT stack if two enemies commit within 0.5s — only one micro-slow fires (first wins, second skipped).
- Toggle: `LOCK_MICROSLOW_ENABLED` project setting, default `true`.

### 5. Screen Edge Pulse (Optional — recommended for TC04 path)

- On `commit_enter` **when enemy is Charger type**: brief red vignette pulse at screen edges.
- Duration: 0.12s in, hold 0.05s, 0.08s out.
- Alpha: max 0.25 (subtle — reinforces danger without obscuring play).
- Only fires for Charger. Slasher/Shielder do not trigger edge pulse (too noisy).

---

## LOCK SFX — Timing Specification

See BC_AUDIO_SFX_LIST_v001 for asset details. This section defines **when** the audio fires.

| SFX slot | Fire time | Notes |
|---|---|---|
| `lock_primary` | Frame 0 of `commit_enter` | The main LOCK metallic click/snap |
| `lock_accent` (optional) | +2 frames after primary | Layered harmonic tone, lower volume |
| Telegraph ambient | Fade out over 0.3s | Cross-fade: telegraph hum ducks as LOCK fires |

**Constraint:** `lock_primary` must be the loudest single event in the room at moment of fire. See BC_AUDIO_MIX_GUIDE_v001 for mix levels.

---

## Duration — How Long LOCK State Reads

The LOCK visual state holds until the enemy begins their Execute action (`STATE_EXECUTING`).

| Element | Behavior during LOCK hold |
|---|---|
| Floor solid red arc | Stays at 100% opacity |
| Lock icon | Static, 100% opacity |
| Red outline glow | Stays, subtle pulse OK (0.5s cycle, ±10% opacity only) |
| Micro-slow | Already resolved; not sustained |
| SFX | No looping SFX. LOCK is punctuation, not ambience. |

On Execute start:
- Floor arc fades out (0.15s).
- Lock icon fades out (0.1s).
- Execute SFX fires.

---

## Charger-Specific LOCK Moment (TC04 Path)

The Charger commit is the **primary TC04 setup**. Additional requirements:

1. **Direction arrow overlay** appears at LOCK on floor: solid red arrow showing exact charge trajectory. Length = full charge travel distance projected from enemy position.
2. **"LOCKED" ghost path**: faint red ghost of charge path (20% alpha) lets player see exactly where Charger will go. This is the bait invitation — "can I put the wall in this path?"
3. If SpikeWall is in the charge path at LOCK moment: optionally add a brief **wall glow** (SpikeWall spikes flash amber once) to hint the hazard opportunity. This is a "discoverable" feel, not a tutorial tooltip.

---

## QA Checklist for LOCK Moment (TC01 Pass Criteria)

A first-time tester (no tutorial) should be able to answer YES to all of these after one combat encounter:

- [ ] "The enemy looked different right before it attacked" (floor snap + icon change)
- [ ] "Something happened right when it locked in" (SFX + flash)
- [ ] "I could tell where it was going to go" (solid arc + optional direction arrow)
- [ ] "It felt like the window to react was real" (micro-slow buys perceived reaction time)
- [ ] "Telegraph and LOCK felt like two different things" (TC01 core pass)

---

## Anti-patterns

- Do NOT tween the arc color change. Instant snap only.
- Do NOT show a "LOCK" text label on screen — the icon does the job (mobile space is precious).
- Do NOT fire the LOCK pop if enemy dies mid-Telegraph. Cancel cleanly.
- Do NOT let the lock icon overlap the player character at any camera distance.

---

## Dependencies on Dev Team

| Need | Status |
|---|---|
| `enemy_committed(enemy_node)` signal | Must be exposed from enemy state machine |
| `ENGINE_MICROSLOW_ENABLED` toggle | Expose as project setting or autoload var |
| Floor indicator node (existing?) | LOCK spec assumes a floor indicator node exists from Telegraph phase |
| Camera shake API | Need brief shake call accessible from FX manager |

---

## Next version targets
- v002: Slasher LOCK spec (telegraphs arc-slash, LOCK narrows arc to exact slice)
- v002: Shielder LOCK spec (telegraphs shield-up, LOCK shows reflect window)
- v002: LOCK moment localization — ensure lock icon readable at 270×480 (low-end Android)
