#!/usr/bin/env python
"""dev_dispatcher.py

Conservative Dev automation dispatcher.

Behavior (conservative mode):
- Scans a small allowlist of markdown files for DEV_REQUEST blocks.
- Only dispatches requests that explicitly contain `dispatch: now`.
- Enforces:
  - single-flight lock
  - rate limit (min minutes between dispatches)
  - processed-id tracking

On dispatch:
- Creates a TASK_PACKET file under docs/PACKETS/ (timestamped)
- Creates a git branch
- Runs `codex exec --full-auto ...` with a prompt that instructs Codex to follow the task packet and repo policy.

This script is designed to be called by the main agent when woken by an OpenClaw cron job.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
import textwrap
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = REPO_ROOT / "tools" / "dev_dispatcher_state.json"
LOCK_PATH = REPO_ROOT / "tools" / ".dev_dispatcher.lock"

DEFAULT_SCAN = [
    REPO_ROOT / "docs" / "QA_REPORT.md",
    REPO_ROOT / "docs" / "obsidian_vault" / "QA_LOGS",
]

BLOCK_RE = re.compile(
    r"<!--\s*DEV_REQUEST:start\s*-->\s*(.*?)\s*<!--\s*DEV_REQUEST:end\s*-->",
    re.DOTALL | re.IGNORECASE,
)


def run(cmd: list[str], cwd: Path | None = None, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, cwd=str(cwd or REPO_ROOT), text=True, capture_output=True, check=check)


def now_kst() -> dt.datetime:
    # Asia/Seoul fixed offset +09:00
    return dt.datetime.now(dt.timezone(dt.timedelta(hours=9)))


def load_state() -> dict:
    if STATE_PATH.exists():
        return json.loads(STATE_PATH.read_text(encoding="utf-8"))
    return {
        "lastDispatchedAt": None,
        "processedIds": [],
    }


def save_state(state: dict) -> None:
    STATE_PATH.parent.mkdir(parents=True, exist_ok=True)
    STATE_PATH.write_text(json.dumps(state, ensure_ascii=False, indent=2), encoding="utf-8")


def acquire_lock() -> None:
    try:
        fd = os.open(str(LOCK_PATH), os.O_CREAT | os.O_EXCL | os.O_WRONLY)
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(f"pid={os.getpid()}\n")
            f.write(f"ts={now_kst().isoformat()}\n")
    except FileExistsError:
        raise SystemExit(f"LOCKED: {LOCK_PATH} exists (another dispatch in progress)")


def release_lock() -> None:
    try:
        LOCK_PATH.unlink(missing_ok=True)
    except Exception:
        pass


def iter_md_files(scan_paths: list[Path]) -> list[Path]:
    files: list[Path] = []
    for p in scan_paths:
        if p.is_file() and p.suffix.lower() in {".md", ".markdown"}:
            files.append(p)
        elif p.is_dir():
            files.extend([x for x in p.rglob("*.md") if x.is_file()])
    # keep deterministic order
    return sorted(set(files))


def parse_kv(block: str) -> dict[str, str]:
    kv: dict[str, str] = {}
    for line in block.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            continue
        k, v = line.split(":", 1)
        kv[k.strip().lower()] = v.strip()
    return kv


def find_requests(scan_paths: list[Path]) -> list[dict]:
    reqs: list[dict] = []
    for f in iter_md_files(scan_paths):
        text = f.read_text(encoding="utf-8", errors="ignore")
        for m in BLOCK_RE.finditer(text):
            block = m.group(1)
            kv = parse_kv(block)
            dispatch = kv.get("dispatch", "").lower()
            if dispatch != "now":
                continue
            title = kv.get("title", "untitled")
            priority = kv.get("priority", "P2")
            scope = kv.get("scope", "godot")
            acceptance = kv.get("acceptance", "")
            notes = kv.get("notes", "")
            # stable-ish id: file + start index + title
            req_id = f"{f.as_posix()}::{m.start()}::{title}"
            reqs.append(
                {
                    "id": req_id,
                    "file": str(f),
                    "title": title,
                    "priority": priority,
                    "scope": scope,
                    "acceptance": acceptance,
                    "notes": notes,
                }
            )
    return reqs


def rate_limit_ok(state: dict, min_minutes: int) -> bool:
    ts = state.get("lastDispatchedAt")
    if not ts:
        return True
    try:
        last = dt.datetime.fromisoformat(ts)
    except Exception:
        return True
    return (now_kst() - last) >= dt.timedelta(minutes=min_minutes)


def make_task_packet(req: dict) -> Path:
    stamp = now_kst().strftime("%Y%m%d_%H%M%S")
    safe = re.sub(r"[^a-zA-Z0-9_-]+", "-", req["title"].strip().lower()).strip("-")
    filename = f"TASK_PACKET_AUTO_{stamp}_{safe}.md"
    path = REPO_ROOT / "docs" / "PACKETS" / filename
    content = f"""# TASK_PACKET (AUTO) — {req['title']}

## Task
- Priority: {req['priority']}
- Source: {req['file']}
- Trigger: DEV_REQUEST block (dispatch: now)

## Requirements
- Scope: minimal change, focused on request.
- Must follow repo policy:
  - Read `docs/PACKETS/STATE_PACKET.md` and relevant packets.
  - Modify only allowed paths for the request (default: `godot/**` + `docs/PACKETS/**`).
  - Update `docs/PACKETS/STATE_PACKET.md` (only: Current build / Current focus / Known issues / Next actions).
  - Create feature branch, commit, push, and open PR.

## Acceptance
{req['acceptance'] or '- (not provided)'}

## Notes
{req['notes'] or '- (none)'}
"""
    path.write_text(content, encoding="utf-8")
    return path


def ensure_clean_git() -> None:
    r = run(["git", "status", "--porcelain"], check=True)
    if r.stdout.strip():
        raise SystemExit("Working tree is not clean. Stash/commit before dispatch.")


def create_branch(task_packet: Path) -> str:
    stamp = now_kst().strftime("%m%d-%H%M")
    base = re.sub(r"[^a-zA-Z0-9_-]+", "-", task_packet.stem.lower())
    branch = f"auto/{base}-{stamp}"[:80]
    run(["git", "checkout", "-b", branch], check=True)
    return branch


def codex_prompt(task_packet: Path) -> str:
    return textwrap.dedent(
        f"""
        You are Dev. Follow repo policy strictly.

        Implement the task described in: {task_packet.as_posix()}

        Steps:
        1) Read the task packet and docs/PACKETS/STATE_PACKET.md.
        2) Implement minimal changes to satisfy acceptance.
        3) Update docs/PACKETS/STATE_PACKET.md (only the 4 allowed sections).
        4) Commit changes on the current branch.

        Do NOT run any openclaw commands at the end. Output a short summary with commit hash.
        """
    ).strip()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--min-minutes", type=int, default=30, help="rate limit between dispatches")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--scan", action="append", help="extra scan path (file or dir)")
    args = ap.parse_args()

    scan_paths = DEFAULT_SCAN.copy()
    if args.scan:
        scan_paths.extend([Path(x) for x in args.scan])

    state = load_state()
    reqs = find_requests(scan_paths)
    reqs = [r for r in reqs if r["id"] not in set(state.get("processedIds", []))]

    if not reqs:
        print("NOOP: no new DEV_REQUEST blocks with dispatch: now")
        return 0

    if not rate_limit_ok(state, args.min_minutes):
        print("RATE_LIMIT: skipping dispatch (too soon since last)")
        return 0

    # pick highest priority crudely (P0 > P1 > P2 ...), else first
    def pkey(p: str) -> int:
        m = re.match(r"p(\d+)", p.strip().lower())
        return int(m.group(1)) if m else 9

    reqs.sort(key=lambda r: (pkey(r.get("priority", "P9")), r["id"]))
    req = reqs[0]

    if args.dry_run:
        print("DRY_RUN: would dispatch", json.dumps(req, ensure_ascii=False, indent=2))
        return 0

    acquire_lock()
    try:
        ensure_clean_git()
        task_packet = make_task_packet(req)

        # commit the packet first
        run(["git", "add", str(task_packet.relative_to(REPO_ROOT))], check=True)
        run(["git", "commit", "-m", f"docs: add auto task packet ({req['title']})"], check=True)

        branch = create_branch(task_packet)

        # run codex
        prompt = codex_prompt(task_packet)
        print(f"DISPATCH: {req['title']} -> branch {branch} -> {task_packet.name}")
        cp = subprocess.run(
            ["codex", "exec", "--full-auto", prompt],
            cwd=str(REPO_ROOT),
            text=True,
        )
        if cp.returncode != 0:
            print(f"ERROR: codex exited {cp.returncode}")
            return cp.returncode

        # update state
        state.setdefault("processedIds", []).append(req["id"])
        state["lastDispatchedAt"] = now_kst().isoformat()
        save_state(state)
        print("DONE")
        return 0
    finally:
        release_lock()


if __name__ == "__main__":
    raise SystemExit(main())
