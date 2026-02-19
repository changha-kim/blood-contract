#!/usr/bin/env python3
"""parse_tc04_log.py

Parses Godot EventLogger JSONL and produces a pass/fail result for TC04 automation.

Intended uses:
- Local: run after a headless tc04 autorun to quickly see success/fail breakdown.
- CI: gate PRs by failing when TC04 automation does not meet minimum criteria.

Success rule (Week1 default): at least one `wall_hit`-style success event per N attempts.
We primarily trust explicit `tc04_attempt` events emitted by the arena script.

Exit codes:
- 0 = pass
- 1 = fail
"""

from __future__ import annotations

import argparse
import json
import pathlib
import sys
from dataclasses import dataclass


@dataclass
class Attempt:
    attempt_id: int
    success: bool
    reason: str | None


def iter_jsonl(path: pathlib.Path):
    with path.open("r", encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                # tolerate partial lines
                continue


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("log", type=pathlib.Path, help="Path to run_*.jsonl")
    ap.add_argument("--min-success", type=int, default=1)
    ap.add_argument("--min-attempts", type=int, default=10, help="Expected attempts; used for sanity checks")
    args = ap.parse_args()

    if not args.log.exists():
        print(f"FAIL: log not found: {args.log}")
        return 1

    attempts: list[Attempt] = []
    for evt in iter_jsonl(args.log):
        if evt.get("event") != "tc04_attempt":
            continue
        try:
            attempt_id = int(evt.get("attempt_id", 0))
        except Exception:
            attempt_id = 0
        success = bool(evt.get("success_bool", False))
        reason = evt.get("fail_reason_enum") or evt.get("reason") or None
        attempts.append(Attempt(attempt_id=attempt_id, success=success, reason=reason))

    if not attempts:
        print("FAIL: no tc04_attempt events found")
        return 1

    # Sort by attempt_id if present; otherwise preserve order.
    attempts_sorted = sorted(attempts, key=lambda a: (a.attempt_id if a.attempt_id else 10**9))

    success_count = sum(1 for a in attempts_sorted if a.success)
    fail_count = len(attempts_sorted) - success_count

    # Breakdown of fails
    reasons: dict[str, int] = {}
    for a in attempts_sorted:
        if a.success:
            continue
        r = a.reason or "unknown"
        reasons[r] = reasons.get(r, 0) + 1

    print(f"TC04 attempts: {len(attempts_sorted)} (success={success_count}, fail={fail_count})")
    if reasons:
        print("Fail reasons:")
        for k in sorted(reasons.keys()):
            print(f"- {k}: {reasons[k]}")

    # Sanity: if attempts far fewer than expected, likely autorun aborted.
    if len(attempts_sorted) < max(1, int(args.min_attempts * 0.6)):
        print(f"FAIL: too few attempts recorded (got {len(attempts_sorted)}, expected ~{args.min_attempts})")
        return 1

    if success_count < args.min_success:
        print(f"FAIL: success_count {success_count} < min_success {args.min_success}")
        return 1

    print("PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
