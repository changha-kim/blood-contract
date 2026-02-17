# Dev Dispatcher (Conservative)

Goal: allow small development requests to be dropped into QA markdown, then dispatched to Codex automatically.

## Where to write requests
- `docs/QA_REPORT.md`
- `docs/obsidian_vault/QA_LOGS/*.md`

## DEV_REQUEST block
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
- **Only** requests with `dispatch: now` are eligible.
- After dispatch, change it to `dispatch: hold` (or remove the block) to prevent re-trigger.
- One-at-a-time execution (lock file) + rate limit to avoid overload.

## Implementation
- Script: `tools/dev_dispatcher.py`
- Spec: `tools/DEV_REQUEST_SPEC.md`

## How it runs (OpenClaw)
- A cron wake checks periodically (15m) and runs the dispatcher once.
- The dispatcher does a cheap scan and exits fast when there are no new requests.
