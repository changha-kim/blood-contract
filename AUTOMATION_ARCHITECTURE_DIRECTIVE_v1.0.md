# [AUTOMATION_ARCHITECTURE_DIRECTIVE] v1.0

## A) REPO STRUCTURE (recommended)
- /game (Godot project root)
  - project.godot
  - export_presets.cfg
  - /scenes
  - /scripts
  - /ui
  - /data
    - /defs (JSON generated from Notion)
    - /schemas (JSON schema docs)
  - /tools
    - notion_sync/ (pull Notion DB rows → JSON)
    - build/ (export scripts)
    - qa/ (log parsers + metric calculators)
- /docs
  - CHANGELOG.md
  - ADR/ (optional local mirror)

## B) DATA PIPELINE (Notion → JSON → Godot)
- Step 1: notion_pull
  - Input: Notion DBs (Systems/Content/Clauses/SynergyTable)
  - Output: /game/data/defs/*.json
  - Rule: export ONLY PoC Scope=true items
- Step 2: data_validate
  - Validate:
    - required ids exist
    - referenced enemy_id/card_id exist
    - tags are within allowed set
- Step 3: godot_run_smoke
  - Run game and ensure DataRepo loads all defs without errors.

## C) BUILD AUTOMATION (Godot CLI)
- Provide scripts:
  - tools/build/export_android.sh
  - tools/build/export_desktop.sh
- Use Godot CLI with headless export:
  - godot --headless --export-release Android ./builds/poc-0.1.x.apk
- Note: Managing export presets is done in editor once; script reuses preset name.

## D) QA AUTOMATION (Measurement)
- Instrumentation logs:
  - user://logs/run_*.jsonl
- One JSON per line, include:
  - ts, event_name, run_id, room_id, ids, values
- Provide tools/qa/parse_logs.py:
  - compute:
    - commit_seen_to_first_success_time (TC01)
    - spikewall_success_rate (TC04)
    - run_duration_avg (TC07)
    - synergy_tier3_per_run_avg (TC05)
    - deaths_reason_tagging assisted (TC08: partially manual)

## E) NOTION WRITEBACK (optional, if permitted)
- After QA_REPORT, update DB_EXPERIMENTS:
  - Result, Severity, Next Actions, Evidence link
- Update DB_BUILDS with build artifact link and tested TCs list
