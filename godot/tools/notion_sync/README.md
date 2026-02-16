# Notion Sync (PoC)

This folder contains scripts to pull Notion DB rows into local JSON tables.

## Output
- `res://data/notion_export/*.json`

## Auth (DO NOT COMMIT TOKENS)
Provide token via env var:
- `NOTION_TOKEN`

Provide DB ids via env vars (or config json):
- `NOTION_DB_SYSTEMS`
- `NOTION_DB_CONTENT`
- `NOTION_DB_EXPERIMENTS`
- `NOTION_DB_BUILDS`
- `NOTION_DB_ADR_DECISIONS`

## Usage
From repo root:
```powershell
$env:NOTION_TOKEN="..."
$env:NOTION_DB_SYSTEMS="..."  # optional per DB
python godot/tools/notion_sync/notion_pull.py --out godot/data/notion_export
```

## Notes
- This script is intentionally minimal: query DB, dump selected properties into a stable JSON format.
- Extend property mapping in `notion_pull.py` as the Notion schema stabilizes.
