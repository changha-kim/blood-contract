import argparse
import json
import os
import sys
import time
from typing import Any, Dict, List, Optional

import urllib.request

NOTION_VERSION = "2022-06-28"
API_BASE = "https://api.notion.com/v1"


def _req(method: str, url: str, token: str, body: Optional[dict] = None) -> dict:
    data = None
    if body is not None:
        data = json.dumps(body).encode("utf-8")
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Notion-Version", NOTION_VERSION)
    req.add_header("Content-Type", "application/json")
    with urllib.request.urlopen(req) as resp:
        raw = resp.read().decode("utf-8")
        return json.loads(raw) if raw else {}


def _rich_text_to_str(v: Any) -> str:
    if not isinstance(v, list):
        return ""
    parts = []
    for it in v:
        if isinstance(it, dict):
            t = it.get("plain_text")
            if isinstance(t, str):
                parts.append(t)
    return "".join(parts).strip()


def _title_to_str(prop: dict) -> str:
    return _rich_text_to_str(prop.get("title"))


def _select_to_str(prop: dict) -> str:
    sel = prop.get("select")
    if isinstance(sel, dict):
        return str(sel.get("name", "")).strip()
    return ""


def _checkbox(prop: dict) -> bool:
    v = prop.get("checkbox")
    return bool(v)


def _number(prop: dict) -> Optional[float]:
    v = prop.get("number")
    if v is None:
        return None
    try:
        return float(v)
    except Exception:
        return None


def _date(prop: dict) -> str:
    d = prop.get("date")
    if isinstance(d, dict):
        return str(d.get("start", ""))
    return ""


def _page_to_row(page: dict) -> dict:
    props = page.get("properties", {}) if isinstance(page, dict) else {}
    # Minimal, schema-agnostic extraction.
    row: Dict[str, Any] = {
        "id": page.get("id"),
        "created_time": page.get("created_time"),
        "last_edited_time": page.get("last_edited_time"),
        "url": page.get("url"),
        "archived": page.get("archived", False),
    }

    # Common field names we expect in our Notion templates.
    # If names differ, adjust mapping here.
    def get_prop(name: str) -> dict:
        p = props.get(name)
        return p if isinstance(p, dict) else {}

    row["name"] = _title_to_str(get_prop("Name")) or _title_to_str(get_prop("name"))
    row["poc_scope"] = _checkbox(get_prop("PoC Scope")) or _checkbox(get_prop("poc_scope"))
    row["status"] = _select_to_str(get_prop("Status")) or _select_to_str(get_prop("status"))
    row["type"] = _select_to_str(get_prop("Type")) or _select_to_str(get_prop("type"))
    row["priority"] = _select_to_str(get_prop("Priority")) or _select_to_str(get_prop("priority"))
    row["owner"] = _select_to_str(get_prop("Owner")) or _select_to_str(get_prop("owner"))
    row["notes"] = _rich_text_to_str(get_prop("Notes").get("rich_text")) if get_prop("Notes") else ""
    row["due"] = _date(get_prop("Due"))
    row["estimate"] = _number(get_prop("Estimate"))

    return row


def notion_query_database(token: str, db_id: str) -> List[dict]:
    url = f"{API_BASE}/databases/{db_id}/query"
    out: List[dict] = []
    cursor = None
    while True:
        body: Dict[str, Any] = {}
        if cursor:
            body["start_cursor"] = cursor
        res = _req("POST", url, token, body)
        results = res.get("results", [])
        if isinstance(results, list):
            out.extend(results)
        if not res.get("has_more"):
            break
        cursor = res.get("next_cursor")
        if not cursor:
            break
        time.sleep(0.2)
    return out


def dump_table(out_dir: str, name: str, rows: List[dict]) -> str:
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, f"{name}.json")
    payload = {
        "name": name,
        "pulled_at": int(time.time()),
        "count": len(rows),
        "rows": rows,
    }
    with open(path, "w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)
    return path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="godot/data/notion_export", help="output folder")
    ap.add_argument("--only", default="", help="comma separated table names to pull")
    args = ap.parse_args()

    token = os.environ.get("NOTION_TOKEN", "").strip()
    if not token:
        print("ERROR: NOTION_TOKEN env var is required (do not paste tokens into chat).", file=sys.stderr)
        return 2

    dbs = {
        "DB_SYSTEMS": os.environ.get("NOTION_DB_SYSTEMS", "").strip(),
        "DB_CONTENT": os.environ.get("NOTION_DB_CONTENT", "").strip(),
        "DB_EXPERIMENTS": os.environ.get("NOTION_DB_EXPERIMENTS", "").strip(),
        "DB_BUILDS": os.environ.get("NOTION_DB_BUILDS", "").strip(),
        "DB_ADR_DECISIONS": os.environ.get("NOTION_DB_ADR_DECISIONS", "").strip(),
    }

    only = [s.strip() for s in args.only.split(",") if s.strip()] if args.only else []

    pulled_any = False
    for name, db_id in dbs.items():
        if only and name not in only:
            continue
        if not db_id:
            continue
        print(f"[notion_pull] querying {name}...")
        pages = notion_query_database(token, db_id)
        rows = [_page_to_row(p) for p in pages]
        path = dump_table(args.out, name, rows)
        print(f"[notion_pull] wrote {path} ({len(rows)} rows)")
        pulled_any = True

    if not pulled_any:
        print("WARNING: no DB ids provided (set NOTION_DB_SYSTEMS/etc). Nothing pulled.", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
