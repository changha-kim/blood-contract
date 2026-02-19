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

### Vault scope gotcha (important)
If you open the vault root as `docs/obsidian_vault/`, anything under `docs/PRODUCTION_PACKS/` (e.g. narrative spine) is **outside the vault** and won’t show up in search.

**Recommended:** open Obsidian vault root as `docs/` when you need full-doc search, or use a deliberate link/replication strategy for the few files you want searchable inside the vault.

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

## Agent work visibility (future)
We will maintain an **Agent Activity Log** in the vault.
- Each agent run creates a small entry: what/why/output/links.
- Dashboard shows: current tasks, last runs, blockers.

Next step to enable this: define a simple log schema + a single page that aggregates it.
