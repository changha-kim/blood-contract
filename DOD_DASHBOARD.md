# Blood Contract PoC — DoD Dashboard (mapped to DB_EXPERIMENTS)

Status legend: **PASS / MIXED / FAIL / NOT RUN**

> Update this file after each build/test cycle. Link to latest result files in `test_results/`.

---

## DoD-1) Commit Combat이 전달된다 (USP)
**Pass criteria (all must hold):**
- Enemies clearly perform **Telegraph → Commit(LOCK) → Execute**.
- Player can **exploit the lock** (baiting / repositioning) for advantage.
- Showcase moment (Charger → spike wall) is achievable.
- Deaths attributable to skill/read, not mystery.

**Validation tests:**
- TC01 Commit 이해도(무설명 학습) → proves comprehension without tutorial
- TC04 Charger 3초 명장면 → proves “exploit lock” moment
- TC08 공정성(억울함) 분류 → proves deaths are explainable/actionable

**Current status:** NOT RUN

---

## DoD-2) 6~10분 런 루프가 작동한다
**Pass criteria (all must hold):**
- Run closes: **5 rooms + miniboss + (Extract/Death)**.
- Typical run duration is **6–10 min** (at least once; stabilize later).

**Validation tests:**
- TC07 런타임 목표 (6–10 minutes)

**Current status:** NOT RUN

---

## DoD-3) 카드/태그/시너지 Tier3가 ‘평균 1회’ 가능한 구조
**Pass criteria (initial PoC target):**
- Over N runs (recommend N=5 early; N=10 later), **avg Tier3 ≥ 1/run**.
- Tier3 produces a **noticeable gameplay change** (not just a number).
- Builds show some **variety**, not a single dominant tag combo every run.

**Validation tests:**
- TC05 Synergy Tier3 frequency
- TC10 Build variety distribution
- (supporting UX) TC06 Card UI comprehension

**Current status:** NOT RUN

---

## DoD-4) Android 조작/가독성/성능이 치명적이지 않다
**Pass criteria (PoC-level):**
- Commit-read + dash timing remains reliable on device.
- Performance in stress scenarios does not destroy readability.

**Validation tests:**
- TC09 Android performance smoke
- Re-run: TC01 + TC04 quickly on device (sanity)

**Current status:** NOT RUN

---

## Evidence index (fill in)
- Latest build tested: `poc-0.1.x` / commit: `________`
- Results folder: `test_results/YYYY-MM-DD/`
- Key clips:
  - TC01: __________________
  - TC04: __________________
  - TC09: __________________

