# BC_AUDIO_SFX_LIST_v001
> Assist Dept — Audio Team | 2026-02-19 | v001

## Scope
Top 15 priority SFX for PoC, mapped to the 5 combat phases. No large binaries yet — use links + this manifest. Implementer should source/create assets and log final filenames here.

**Priority order:** LOCK > WALL_HIT > DAMAGE_TAKEN > EXECUTE > TELEGRAPH

---

## Phase Map

| Phase | Code Label | Description |
|---|---|---|
| Telegraph | `TEL` | Enemy winds up, player warned |
| Commit/LOCK | `LOCK` | Intent locked — the pop moment |
| Execute | `EXEC` | Enemy action happening |
| Wall Hit | `WALL` | Enemy contacts SpikeWall (TC04) |
| Damage Taken | `DMG` | Player or enemy receives damage |

---

## SFX List (Top 15, prioritized)

### LOCK GROUP — Priority 1 (TC01 critical)

| # | ID | Phase | Description | Timbre / Feel | Duration | Notes |
|---|---|---|---|---|---|---|
| 1 | `lock_primary` | LOCK | Main commit lock cue — the key moment signal | Metallic chain-link snap or heavy deadbolt click. Short transient. Must cut through ambient. | 0.15–0.25s | **Highest priority in entire game SFX set. No other sound should mask this.** |
| 2 | `lock_accent` | LOCK | Secondary layered harmonic — reinforces finality | Low resonant thud or bass pulse beneath the snap. Quieter than primary. | 0.3–0.5s | Optional for PoC but strongly recommended. Layer under `lock_primary`. |

### WALL_HIT GROUP — Priority 2 (TC04 critical)

| # | ID | Phase | Description | Timbre / Feel | Duration | Notes |
|---|---|---|---|---|---|---|
| 3 | `wall_hit_impact` | WALL | Charger body hitting SpikeWall — primary impact | Heavy thud + crunch. Wet-metal body-slam quality. Impactful, not cartoonish. | 0.2–0.35s | **Must feel visceral — this is the trailer moment.** |
| 4 | `wall_hit_spikes` | WALL | Spikes piercing / grinding against Charger | Sharp metallic scrape or stab burst. Layered above impact. | 0.15–0.25s | Fires simultaneously or +1 frame after `wall_hit_impact`. |
| 5 | `wall_hit_stun` | WALL | Charger daze/stun after wall | Short dizzy "boing" or disoriented drone. Faint. | 0.4–0.8s | Communicates "enemy is stunned now" — buy time perception for player. |
| 6 | `wall_hit_enemy_pain` | WALL | Enemy damage grunt | Short enemy vocalization — strained exhale or guttural hit-react. | 0.1–0.2s | Must not be comedic; this is an enemy "taking real damage" read. |

### DAMAGE_TAKEN GROUP — Priority 3

| # | ID | Phase | Description | Timbre / Feel | Duration | Notes |
|---|---|---|---|---|---|---|
| 7 | `player_hit_light` | DMG | Player receives light damage | Sharp impact + short pain intake breath | 0.15–0.2s | Distinct from enemy pain sound. |
| 8 | `player_hit_heavy` | DMG | Player receives heavy / lethal-range damage | Bigger impact + lower pitch grunt. Screen-space effect should pair. | 0.25–0.4s | Reserved for hits above 30% HP damage threshold. |
| 9 | `enemy_hit_generic` | DMG | Generic enemy hit by player attack | Punch/slash impact — satisfying contact feel | 0.1–0.2s | Placeholder until per-enemy hit sounds in v002. |

### EXECUTE GROUP — Priority 4

| # | ID | Phase | Description | Timbre / Feel | Duration | Notes |
|---|---|---|---|---|---|---|
| 10 | `charger_dash_exec` | EXEC | Charger begins charge after LOCK | Rapid wind/whoosh with weight. Low rumble sweep. | 0.3–0.5s | Must feel physically heavy — Charger has mass. |
| 11 | `slasher_slash_exec` | EXEC | Slasher executes slash attack | Sharp blade swipe through air | 0.15–0.25s | Fast and crisp. |
| 12 | `generic_exec_impact` | EXEC | Fallback execute SFX for any enemy action | Medium punch/hit transient | 0.15s | Use until all enemy types have dedicated exec sounds. |

### TELEGRAPH GROUP — Priority 5

| # | ID | Phase | Description | Timbre / Feel | Duration | Notes |
|---|---|---|---|---|---|---|
| 13 | `tel_charger_windup` | TEL | Charger telegraph ambient — building energy | Low rising hum or distant rumble. Barely audible. | Loop (1.0–1.5s cycle) | **Must be significantly quieter than `lock_primary`.** Fade in at Telegraph start. |
| 14 | `tel_generic_alert` | TEL | Generic enemy telegraph alert (first frame) | Subtle "attention" tone — short tick or soft chime | 0.1–0.15s | Optional one-shot at Telegraph start. Not looping. |
| 15 | `tel_end_duck` | TEL | Telegraph hum fades on LOCK transition | Not a new SFX — automated fade/duck of `tel_charger_windup` | 0.3s fade | Implemented via AudioStreamPlayer fade, not a file. |

---

## Asset Status Manifest

| ID | Status | Source / Link | Filename (target) | Notes |
|---|---|---|---|---|
| `lock_primary` | **NEEDED** | TBD | `sfx_lock_primary.ogg` | Highest priority — source first |
| `lock_accent` | NEEDED | TBD | `sfx_lock_accent.ogg` | |
| `wall_hit_impact` | NEEDED | TBD | `sfx_wall_hit_impact.ogg` | TC04 critical |
| `wall_hit_spikes` | NEEDED | TBD | `sfx_wall_hit_spikes.ogg` | |
| `wall_hit_stun` | NEEDED | TBD | `sfx_wall_hit_stun.ogg` | |
| `wall_hit_enemy_pain` | NEEDED | TBD | `sfx_wall_hit_enemy_pain.ogg` | |
| `player_hit_light` | NEEDED | TBD | `sfx_player_hit_light.ogg` | |
| `player_hit_heavy` | NEEDED | TBD | `sfx_player_hit_heavy.ogg` | |
| `enemy_hit_generic` | NEEDED | TBD | `sfx_enemy_hit_generic.ogg` | |
| `charger_dash_exec` | NEEDED | TBD | `sfx_charger_dash_exec.ogg` | |
| `slasher_slash_exec` | NEEDED | TBD | `sfx_slasher_slash_exec.ogg` | |
| `generic_exec_impact` | NEEDED | TBD | `sfx_generic_exec_impact.ogg` | |
| `tel_charger_windup` | NEEDED | TBD | `sfx_tel_charger_windup.ogg` | Loop file |
| `tel_generic_alert` | NEEDED | TBD | `sfx_tel_generic_alert.ogg` | |
| `tel_end_duck` | n/a — code | — | — | Implemented as fade |

**Target directory in repo:** `godot/assets/audio/sfx/` (pending integration PR)

---

## Sourcing Notes

For PoC placeholder assets, acceptable free sources (verify license):
- freesound.org (CC0 / CC-BY)
- sonniss.com GDC packs (royalty-free)
- zapsplat.com (free tier ok for PoC)

All final commercial-release assets must be owned/licensed. Flag any placeholder with `[PLACEHOLDER]` in manifest Status column.

---

## Next version targets
- v002: Per-enemy hit sounds (Charger, Slasher, Shielder separate)
- v002: Synergy tier-3 / tier-4 activation SFX (Major + Break stings)
- v002: Card select SFX set
- v002: Room ambience layers (1 per room type)
