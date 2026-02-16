# Blood Contract PoC — HOW_TO_TEST (DB_EXPERIMENTS)

This is a **solo-tester friendly** checklist for running PoC validation tests **TC01–TC10**.

## Quick rules
- Record every test run as **Pass / Mixed / Fail**.
- Always capture:
  - Build id / git commit
  - Platform (Desktop / Android device model)
  - Date + tester
  - Evidence (short clip/screenshot) when possible
- Keep runs short: **1–3 attempts** per TC unless the TC explicitly calls for multiple runs.

## Pre-flight (2–5 min)
- [ ] Confirm build id: `poc-0.1.x` or commit hash
- [ ] Confirm input method:
  - Desktop: KB/M or controller
  - Android: touch controls
- [ ] Enable debug overlay if available (FPS, room, run timer)
- [ ] Set audio ON (commit SFX matters)
- [ ] Prepare capture:
  - Desktop: OBS / built-in recorder
  - Android: screen recording

---

# TC01 — Commit 이해도 (무설명 학습)
**Goal:** Player infers **Telegraph → Commit(LOCK) → Execute** without tutorial.

### Setup
- Arena: single enemy (ENY_SLASHER)
- No tutorial text.

### Steps (10–60s)
1. Start arena; let enemy attack a few times.
2. Observe telegraph shape + lock moment.
3. After **Commit**, move to bait the now-locked execution.
4. Repeat once.

### Record
- Result: Pass/Mixed/Fail
- Time-to-understand (seconds) or “never got it”
- Notes: what visual/audio cue taught it (telegraph shape? lock icon? outline thickness? SFX?)
- Confusion points (e.g., commit timing unclear)
- Evidence: 10–20s clip

---

# TC02 — Telegraph clarity stress (Ledger Court)
**Goal:** Telegraphs remain readable under **visual clutter / multi-enemy** conditions.

### Setup
- Scene/Room: Ledger Court (or the designated stress room)
- Spawn mix includes ranged + melee.

### Steps (2–4 min)
1. Enter stress room.
2. Survive ~60–120s while staying near multiple enemies.
3. Intentionally reposition during telegraphs to test readability.

### Record
- Result: Pass/Mixed/Fail
- 3 biggest readability issues (color, thickness, overlap, camera, VFX)
- Any “unfair hits” caused by unreadable telegraph (count)
- FPS range if visible

---

# TC03 — SpikeWall cheese loop (anti-infinite)
**Goal:** Spike wall + knockback can be exploited **once**, but cannot become an **infinite lock**.

### Setup
- Scene: ROOM_GAUNTLET_LANE (or spike-wall test arena)
- Hazard: HZD_SPIKE_WALL
- Enemy with knockback interactions enabled.

### Steps (2–3 min)
1. Lure an enemy into spike wall damage.
2. Attempt to chain knockbacks to keep enemy pinned.
3. Try 2–3 loops.

### Record
- Result: Pass/Mixed/Fail
- Did enemy escape / recover? How? (i-frames, resistance, cooldown)
- If infinite is possible: exact repro steps (critical)
- Evidence clip

---

# TC04 — Charger 3초 명장면 (showcase)
**Goal:** In a few attempts, a novice can create the “**bait committed charge into spike wall**” moment.

### Setup
- Enemy: ENY_CHARGER
- Hazard: HZD_SPIKE_WALL
- Layout supports a clear lane + wall.

### Steps (max 5 attempts)
1. Trigger charger telegraph.
2. Wait for **Commit(LOCK)**.
3. Sidestep/dash so execution path hits spike wall.
4. Repeat until success or 5 attempts.

### Record
- Result: Pass/Mixed/Fail
- Attempts until first success (1–5 / none)
- What failed when it failed (commit window? dash i-frames? hitbox? wall rules?)
- Subjective: “Trailer moment achieved?” (Y/N)
- Evidence clip (best attempt)

---

# TC05 — Synergy Tier3 frequency (avg ≥ 1 / run)
**Goal:** With 18 PoC cards, a typical run reaches **Tier 3 synergy at least once on average**.

### Setup
- Full run enabled (5 rooms + miniboss)
- Card rewards: 3 choices + 1 reroll

### Steps (requires multiple runs)
1. Play **N runs** (suggest N=5 for first pass).
2. Track when Tier 3 is achieved (room index/time).

### Record
- Result: Pass/Mixed/Fail
- Runs played: N
- Tier3 achieved in how many runs (count)
- Avg time/room to Tier3
- Which tags/cards commonly enabled Tier3
- Notes on tuning (offer weights, reroll value)

---

# TC06 — Card UI comprehension (Benefit/Debt)
**Goal:** Card selection UI clearly communicates **benefit + debt + tag impact**.

### Setup
- Any card reward screen
- If possible: show 3 varied cards (different tags/debts)

### Steps (5–10 min)
1. Without reading external docs, pick a card.
2. Immediately answer:
   - What benefit did you gain?
   - What debt/cost did you accept?
   - What tag/synergy progress changed?
3. Repeat for 3 reward screens.

### Record
- Result: Pass/Mixed/Fail
- For each pick: comprehension correctness (Y/N) + what was misunderstood
- UI elements causing confusion (icons, wording, placement)
- Screenshot of reward UI

---

# TC07 — Runtime target (6–10 minutes)
**Goal:** One run closes (Extract/Death) in **6–10 minutes**.

### Setup
- Standard run: Room1..Room5 → MiniBoss → End

### Steps (1 run)
1. Play normally until Extract or Death.

### Record
- Result: Pass/Mixed/Fail
- Run duration (mm:ss)
- End state: Extract or Death (which room/boss)
- 2 pacing notes: too slow? too fast? long downtime?

---

# TC08 — Fairness death reasons (억울함 분류)
**Goal:** When you die, the reason is classifiable and actionable (not mysterious/unfair).

### Setup
- Run or combat stress scenario

### Steps (until 3 deaths or 1 run)
1. Intentionally play risky to produce deaths.
2. For each death, classify primary cause:
   - A) Misread telegraph/commit
   - B) Input/controls (dash didn’t fire, stick drift, etc.)
   - C) Visibility/performance (FPS drop, clutter)
   - D) Balance (damage too high)
   - E) Other (describe)

### Record
- Result: Pass/Mixed/Fail
- Death log table (3 entries): room, enemy, cause tag, short note
- If “unfair”: what would have prevented it? (UI cue, more time, less clutter)

---

# TC09 — Android performance smoke (read-commit integrity)
**Goal:** On Android, performance/input does **not** break the core loop of reading commit + dashing.

### Setup
- Device model + OS version
- Stress scene (Ledger Court) + a commit-centric enemy (Slasher/Charger)

### Steps (5–10 min)
1. Measure FPS/feel in stress room for ~2 minutes.
2. Perform 10 commit-dodge attempts (count successes).
3. Do 3 spike-wall showcase attempts if available.

### Record
- Result: Pass/Mixed/Fail
- FPS estimate (min/avg) or qualitative (“stable / stuttery”)
- Input issues: missed taps, latency, dash timing consistency
- Commit-read success rate (e.g., 7/10)
- Thermal/throttling notes

---

# TC10 — Build variety distribution (tag diversity)
**Goal:** Across runs, builds do not converge to the same tags every time; tag distribution is healthy.

### Setup
- Same as TC05 (cards + tags + synergy)

### Steps (requires multiple runs)
1. Play N runs (suggest N=10 when ready; N=5 early).
2. Record final tag levels + main damage/defense pattern.

### Record
- Result: Pass/Mixed/Fail
- Tag frequency summary (top 3 tags per run)
- % of runs dominated by same tag combo
- Notes: which cards feel mandatory / dead

---

## Where to save results
- Store markdown results under: `test_results/YYYY-MM-DD/TCxx_*.md`
- Attach clips/screenshots under: `test_results/YYYY-MM-DD/artifacts/`
