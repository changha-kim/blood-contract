# 운영 규칙 (Docs + Obsidian)

## 목표
- 프로젝트 흐름을 **한눈에** 보이게 만든다(대시보드 중심).
- 프로젝트 상태는 **진실의 원천(SSOT)** 을 1개로 유지한다.
- QA 로그/PR 추적은 가볍게 하되, 중복 스펙을 만들지 않는다.

---

## SSOT (Single Source of Truth / 단일 진실)
SSOT는 repo 안의 아래 파일들에 있다: `docs/PACKETS/`
- `docs/PACKETS/STATE_PACKET.md` (최우선)
- `docs/PACKETS/PLAN_PACKET.md`
- `docs/PACKETS/QA_PACKET.md`
- `docs/PACKETS/TASK_PACKET.md`

보조 요약(선택):
- `docs/QA_REPORT.md` (1페이지 롤링 QA 요약)

**규칙:** SSOT 내용을 Obsidian vault에 ‘복붙’해서 중복 저장하지 않는다.
Obsidian vault의 역할은 **네비게이션 + 대시보드 + 세션 로그**다.

---

## Obsidian Vault에 들어갈 것
위치: `docs/obsidian_vault/`

허용(팀 공유용):
- `00_DASHBOARD.md` (오늘/이번주/빠른 링크)
- `PACKETS_INDEX.md` (SSOT 링크 모음)
- `TC/*.md` (테스트 케이스 페이지: SSOT/실행 방법으로 연결)
- `QA_LOGS/*.md` (세션/일자 단위 상세 기록)
- `PR/*.md` (PR 인덱스 + 2~3줄 요약)
- `AGENTS/*.md` (에이전트 실행 로그/큐; 선택)

금지(노이즈 방지):
- 개인/프라이빗 메모
- 바이너리 export / 큰 로그 원문 통째 붙여넣기(필요한 발췌만)

---

## QA 로깅 규칙
- 상세 세션 노트 → `docs/obsidian_vault/QA_LOGS/`
- 요약(핵심 5줄) → `docs/QA_REPORT.md`에 append

---

## PR 규칙
- 의미있는 변경은 PR로 남긴다.
- PR 링크는 `docs/obsidian_vault/PR/PR_INDEX.md`에 추가한다.

---

## 에이전트 작업 가시화(추후)
Vault에 **Agent Activity Log**를 유지한다.
- 각 에이전트 실행마다: what/why/output/links 1개 엔트리
- 대시보드에서: 진행중 작업, 최근 실행, blocker를 보이게

다음 단계: 간단한 로그 스키마 + 집계 페이지(1장) 정의
