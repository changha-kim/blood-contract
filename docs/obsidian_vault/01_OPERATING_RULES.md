# Operating Rules (Docs + Obsidian)

## Goals
- Make the project flow visible at a glance (dashboard-driven).
- Keep **one** source of truth for project state.
- Allow lightweight QA logs + PR tracking without creating duplicate specs.

---

## SSOT (Single Source of Truth)
**SSOT lives in repo files under:** `docs/PACKETS/`
- `docs/PACKETS/STATE_PACKET.md` (primary)
- `docs/PACKETS/PLAN_PACKET.md`
- `docs/PACKETS/QA_PACKET.md`
- `docs/PACKETS/TASK_PACKET.md`

Optional SSOT supplement:
- `docs/QA_REPORT.md` (1-page rolling QA summary)

**Rule:** Do not duplicate SSOT content into the Obsidian vault.
The vault is for **navigation + dashboards + session logs**.

---

## What goes into the Obsidian Vault
Location: `docs/obsidian_vault/`

Allowed content (team-facing):
- `00_DASHBOARD.md` (today / this week / quick links)
- `PACKETS_INDEX.md` (links to SSOT)
- `TC/*.md` (test case pages that point to SSOT + how-to-run)
- `QA_LOGS/*.md` (per-session/day detailed notes)
- `PR/*.md` (PR index + short summaries)
- `AGENTS/*.md` (agent run logs / work queue; optional)

Not allowed (avoid noise):
- Personal/private notes
- Raw binary exports or huge pasted logs (keep only needed excerpts)

---

## QA logging rule
- Detailed session notes → `docs/obsidian_vault/QA_LOGS/`
- Distilled outcome (5 lines) → append to `docs/QA_REPORT.md`

---

## PR rule
- Every significant change should be in a PR.
- PR link gets added to `docs/obsidian_vault/PR/PR_INDEX.md`.

---

## Git workflow (PoC / speed-first)
Goal: reduce Producer (human) click burden while keeping `main` protected.

### Branches
- `main`: protected, release-quality snapshot.
- `develop`: integration branch for day-to-day work.

### Rules
- Dev/QA agents **never push to `main`**.
- Default target for PRs is **`develop`**.
- Producer merges PRs into `develop` as needed (can be batched).
- Promotion to `main` happens via a single PR:
  - **`develop → main`** (daily or when a milestone slice is stable)

### PR bundling
- During debugging (many tiny fixes), prefer:
  - accumulate commits on a feature branch, then open **one PR**, or
  - batch multiple PR merges into `develop`, then promote once.

### Status checks
- Keep strict checks on `main`.
- `develop` can be looser (optional), but must be “green enough” before promotion.

### Bypass policy (PoC)
- Allowed: docs-only / tooling-only PRs, emergency unblockers.
- Not allowed: gameplay rule changes that impact TC01/TC04 without at least one human glance.
- Always record bypass merges by adding a 1-line note to `docs/QA_REPORT.md` or `STATE_PACKET` when it matters.

---

## Agent work visibility (future)
We will maintain an **Agent Activity Log** in the vault.
- Each agent run creates a small entry: what/why/output/links.
- Dashboard shows: current tasks, last runs, blockers.

Next step to enable this: define a simple log schema + a single page that aggregates it.
