# Blood Contract PoC — Test Plan Recommendations (M2–M6)

Order is optimized for **fast signal** + **cheap iteration**.

---

## M2 — Intent Combat (Telegraph→Commit→Execute)
**Run first:**
1) **TC01** Commit 이해도 (no tutorial) — primary USP signal.

**Then (quick sanity):**
- Re-run TC01 after any change to telegraph visuals/commit timing.

**Why:** If TC01 is Mixed/Fail, later content work won’t matter.

---

## M3 — Spike Wall + Charger moment
**Run first:**
1) **TC03** SpikeWall anti-infinite — prevents systemic exploit early.
2) **TC04** Charger showcase — validates the 3-second “trailer moment”.

**Why:** TC03 catches loop bugs that waste tuning time; TC04 validates the core fantasy.

---

## M4 — Rooms + Run Loop
**Run first:**
1) **TC07** Runtime target (6–10 min) — loop closure / pacing gate.

**Then:**
2) **TC02** Telegraph clarity stress — multi-enemy readability.
3) **TC08** Fairness death reasons — classify problems while balance is rough.

**Why:** Close the loop first, then test readability/fairness in real run context.

---

## M5 — Cards/Tags/Synergy
**Run first:**
1) **TC06** Card UI comprehension — if UX is unclear, TC05/TC10 data is garbage.

**Then (tuning loops):**
2) **TC05** Tier3 frequency (N=5 early) — reachability tuning.
3) **TC10** Build variety (N=5 early; later N=10) — distribution/weighting.

**Why:** Validate comprehension → then measure frequency → then measure diversity.

---

## M6 — Mobile polish + performance
**Run first:**
1) **TC09** Android performance smoke — commit-read integrity on device.

**Then (mobile sanity):**
2) **TC01** quick rerun on device.
3) **TC04** quick rerun on device.

**Why:** If mobile performance breaks commit-read, the PoC fails regardless of content.

---

## Suggested minimal cadence per build
- Combat-focused build: TC01 (+ TC04 if charger exists)
- Run-loop build: TC07 + TC08
- Card/tuning build: TC06 + TC05 (N=3–5)
- Android build: TC09 + quick TC01/TC04
