# test_results/

This folder stores **repeatable test evidence** for DB_EXPERIMENTS (TC01–TC10).

## Structure
- `test_results/YYYY-MM-DD/`
  - `TC01_*.md` … `TC10_*.md`
  - `artifacts/` (clips, screenshots, logs)

## Naming
- Result file: `TCxx_<buildOrCommit>_<platform>.md`
  - Example: `TC04_poc-0.1.3_android.md`
- Artifacts: `TCxx_<shortdesc>.<ext>`
  - Example: `TC04_success_attempt2.mp4`

## Templates
- Use templates in: `test_results/templates/`
