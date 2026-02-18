# Dev Dispatcher (보수적 자동 디스패치)

목표: QA/로그 문서에 **작은 개발 요청(DEV_REQUEST)** 을 적어두면, 보수 모드로 Codex 자동 실행까지 이어지게.

## 요청을 적을 위치(스캔 대상)
- `docs/QA_REPORT.md`
- `docs/obsidian_vault/QA_LOGS/*.md`

## DEV_REQUEST 블록 템플릿
```md
<!-- DEV_REQUEST:start -->
title: <짧은 제목>
priority: P0|P1|P2
scope: godot|docs|...
acceptance: <완료 조건 1줄>
notes: <선택>
dispatch: now
<!-- DEV_REQUEST:end -->
```

### 운영 규칙(중요)
- `dispatch: now` 인 것만 실행 대상.
- 실행되면 **재실행 방지**를 위해 `dispatch: hold`로 바꾸거나 블록을 제거.
- 한 번에 하나(락 파일) + 레이트리밋으로 과부하 방지.

## 구현 위치
- 스크립트: `tools/dev_dispatcher.py`
- 스펙: `tools/DEV_REQUEST_SPEC.md`

## OpenClaw에서 어떻게 도는가
- 크론/리마인더가 주기적으로 깨움 → dispatcher 1회 실행
- 새 요청 없으면 빠르게 종료(NOOP)
