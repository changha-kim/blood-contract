# DEV_REQUEST Spec (Conservative)

Goal: allow QA/Producer to drop small dev requests into markdown, and have a dispatcher trigger Codex automatically.

## Block format
Place this block in either:
- `docs/QA_REPORT.md`
- `docs/obsidian_vault/QA_LOGS/*.md`

```md
<!-- DEV_REQUEST:start -->
title: <short title>
priority: P0|P1|P2
scope: godot|docs|...
acceptance: <one-line acceptance criteria>
notes: <optional>
dispatch: now
<!-- DEV_REQUEST:end -->
```

### Conservative rules
- The dispatcher only runs when `dispatch: now` is present.
- After dispatch, remove or change `dispatch:` (e.g. `dispatch: hold`) to prevent repeats.
- A lock file prevents concurrent runs.
- Rate limit prevents too-frequent Codex runs.

## Dispatcher
Script: `tools/dev_dispatcher.py`

Recommended manual run:
```bash
python tools/dev_dispatcher.py --dry-run
python tools/dev_dispatcher.py
```

## Cron integration
OpenClaw cron should wake the main agent every **15 minutes** with a system event that says:
- "Run dev_dispatcher once (conservative mode)"

The agent will then run the dispatcher (cheap scan + conditional dispatch).
