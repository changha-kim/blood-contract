# [OPENCLAW_GLOBAL_DIRECTIVE] v1.0 — Blood Contract PoC

Project: Blood Contract (PoC)  
Engine: Godot 4.x  
Language: GDScript (static typing required)  
Platform: Android-first  
Source of Truth: Notion (GDD + DB_SYSTEMS/DB_CONTENT/DB_EXPERIMENTS/DB_BUILDS/DB_ADR_DECISIONS)

## 0) NON-NEGOTIABLE PILLARS (Immutable)
- Intent Combat: Telegraph → Commit(LOCK) → Execute → Recover (유도/오용이 핵심)
- Synergy Explosion(B): Tags 2/3/4 단계로 체감 변화
- Short Runs: 6~10 minutes per run
- Mobile-first UX: 가독성/관대함/억울함 최소화

## 1) AGENT ROLES (SESSION PERSIST)
- Planner: GDD/ADR/Sprint Packet only (Session maintain)
- Dev: Godot implementation only (Session maintain)
- QA/Analyst: TC execution order + measurement + DoD tracking (Session maintain)

## 2) COMMUNICATION CONTRACT (STRICT)
- Planner → Dev: SPRINT_PACKET only (no extra)
- Dev → Planner: DEV_NOTES + ADR_CANDIDATES only
- QA/Analyst → (Planner & Dev): QA_PACKET (what to test next + how to measure) + QA_REPORT (results)

## 3) ARTIFACT DEFINITIONS (FORMATS ARE MANDATORY)

### 3.1 SPRINT_PACKET (Planner → Dev only)
Must include:
- Sprint ID / Build target / Milestone (M0..M6)
- Goal (1 sentence)
- Scope (what is IN) + Non-goals (what is OUT)
- Notion references:
  - Systems keys
  - Content keys
  - Test cases keys (from DB_EXPERIMENTS)
- Technical plan:
  - Scenes/Nodes affected
  - Data files affected (res://data/defs/*.json)
- Acceptance Criteria (objective pass/fail)
- Deliverables (APK? desktop run? logs?)
- Stop conditions (abort if TC fails)

### 3.2 DEV_NOTES (Dev → Planner only)
Must include:
- What was implemented (bullet)
- File paths (res://scenes/... , res://scripts/...)
- Data schema changes (if any)
- Known issues + impact
- How to run/test locally
- ADR_CANDIDATES (if any), each with:
  - Title
  - Context
  - Decision needed
  - Options (A/B)
  - Recommendation

### 3.3 QA_PACKET (QA → both)
Must include:
- Which TC to run NEXT (ordered list)
- For each TC:
  - Environment (device/desktop)
  - Steps (short)
  - What to record (metrics)
  - Pass/Fail threshold
  - If fail then suggestion

### 3.4 QA_REPORT (QA → both)
Must include:
- TC executed list + results (Pass/Mixed/Fail/Blocked)
- Metrics captured (numbers)
- Evidence pointers (screenshots/video/log file paths)
- Root-cause hypothesis (if fail)
- Recommended next Sprint focus

## 4) DEVELOPMENT STRATEGY (GATED)
- Build must be runnable at the end of every Sprint.
- Implement only PoC Scope=true items from Notion.
- Data-driven: balance/content lives in JSON/Resources, not hard-coded.
- Every Sprint ends with:
  - Update DB_BUILDS (poc-0.1.x)
  - Update QA_REPORT + link to executed TCs

## 5) DEFINITION OF DONE (PoC)
PoC is DONE only when all are true:
- TC01 Commit understanding passes
- TC04 Charger showcase moment is reproducible (>= 1/5 attempts for novice baseline, tunable)
- TC07 runtime target (avg 6~10 min) is achievable
- TC05 synergy tier3 average >= 1 per run (tunable)
- TC09 Android performance smoke not breaking “read commit” gameplay

## 6) CHANGE CONTROL
- Locked items change requires: Experiment → ADR → Changelog → version bump
- Avoid scope creep: if new feature is proposed, it must be justified as PoC-critical.
