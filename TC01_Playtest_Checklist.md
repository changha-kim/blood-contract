# TC01 Playtest Checklist — Commit(LOCK) Understanding

**Goal (PASS):** In ≤ 5 minutes, player demonstrates understanding that **once COMMIT locks, the move cannot be canceled/overridden until Recover ends**, by completing **3 consecutive** intent cycles without post-lock override attempts.

## Setup
- Build: M2 Intent Combat (Slasher) Vertical Slice
- Scene: Combat_Test
- Controls:
  - Left: virtual joystick (move)
  - Right: **COMMIT** button

## What to observe (qualitative)
1. **Do they notice the LOCK moment** without being told?
   - Look for reaction to: ring color change + flash + beep + haptic.
2. Do they attempt to **cancel/override after LOCK**?
   - If yes: do they understand quickly after seeing disabled button + "LOCKED" hint?
3. Can they explain in their own words:
   - "Once I commit, I'm locked until the move ends."

## Success criteria (behavioral)
- Within 5 minutes, player completes 3 consecutive cycles where:
  - They press COMMIT to start Telegraph,
  - LOCK confirmation is clearly noticed,
  - No post-LOCK override attempt occurs (or they adapt by the next cycle).

## Telemetry to check (user://logs/*.jsonl)
Required events for TC01 validation:
- `run_start`, `room_enter`, `intent_telegraph`, `intent_commit`, `player_damage`, `run_end`

Helpful patterns:
- LOCK moments:
  - `intent_commit` with `{ who: "player", result: "locked" }`
- Post-lock override attempts (should decrease as they learn):
  - `intent_commit` with `{ result: "attempt_override_post_lock" }`

## Notes template
- Player ID:
- Time to first correct explanation:
- # of post-lock override attempts (first 5 min):
- Did they notice LOCK feedback without instruction? (Y/N)
- Confusions / quotes:
