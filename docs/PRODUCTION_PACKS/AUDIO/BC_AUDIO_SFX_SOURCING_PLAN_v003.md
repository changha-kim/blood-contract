---
# BC_AUDIO_SFX_SOURCING_PLAN_v003
> Audio Team | 2026-02-19 | model: claude-sonnet-4-6 | budget: 100줄
> 목적: TC01(lock_primary) · TC04(wall_hit_impact) P0 블로커 SFX 오늘 확정

---

## 🔴 P0-1 — `wall_hit_impact` (TC04 블로커)
**목표:** 육중한 신체+금속 충돌. 0.2–0.35s. 200–600Hz 펀치 필수(폰 스피커 대응).

| # | 후보 링크 | 라이선스 |
|---|---|---|
| 1 | https://freesound.org/search/?q=heavy+body+impact+metal&f=license%3A%220%22 | CC0 — 크레딧 불필요 |
| 2 | https://pixabay.com/sound-effects/search/impact%20crash/ | Pixabay License — 상업 사용 가능, 크레딧 불필요 |
| 3 | https://www.bfxr.net/ (Hit 프리셋 → Frequency 낮춤 + Sustain 0.2) | 생성음 저작권 없음 — 가장 즉시 사용 가능 |

✅ **최종 추천: 후보 3 (BFXR 직접 생성)**
> 이유: 브라우저에서 즉시 생성 가능, 라이선스 이슈 0, 200–600Hz 집중 조정이 파라미터 조작으로 직관적.

**후속 액션:**
1. https://www.bfxr.net/ 접속
2. "Hit/Hurt" 프리셋 선택 → `Start Frequency` 낮춤(0.2–0.3) → `Sustain Time` 0.25 → `Decay Time` 0.15
3. Export → `sfx_wall_hit_impact.wav` 저장 → OGG 변환(`ffmpeg -i in.wav -q:a 5 sfx_wall_hit_impact.ogg`)
4. `godot/assets/audio/sfx/sfx_wall_hit_impact.ogg` 에 배치 **(커밋 전 테스트 먼저)**
5. 담당: 오디오 담당 개발자 또는 Main team 멤버

---

## 🔴 P0-2 — `lock_primary` (TC01 블로커)
**목표:** 짧은 금속 클릭/자물쇠 스냅. 0.15–0.25s. 1–4kHz 에너지 집중.

| # | 후보 링크 | 라이선스 |
|---|---|---|
| 1 | https://freesound.org/search/?q=metal+lock+click&f=license%3A%220%22 | CC0 — 크레딧 불필요 |
| 2 | https://pixabay.com/sound-effects/search/lock%20click/ | Pixabay License — 상업 사용 가능 |
| 3 | https://sfxr.me/ (Pickup 프리셋 → 고주파 짧은 클릭 커스텀) | 생성음 저작권 없음 |

✅ **최종 추천: 후보 1 (freesound CC0 검색)**
> 이유: "metal lock click" CC0 필터로 0.2s 내외 고품질 실음원 다수 존재; 폰 스피커 1–4kHz 대역에서 실음원이 합성음보다 타격감 우수.

**후속 액션:**
1. https://freesound.org/search/?q=metal+lock+click&f=license%3A%220%22 접속
2. 0.15–0.25s 길이 필터 → 상위 3개 청취 후 가장 날카로운 것 선택
3. `.wav` 다운로드 → OGG 변환 → `sfx_lock_primary.ogg`
4. `godot/assets/audio/sfx/sfx_lock_primary.ogg` 배치 **(커밋 전 테스트)**
5. CC0이면 `docs/CREDITS.md` 기재 불필요. CC-BY면 기재 필수.
6. 담당: 오디오 담당 개발자 또는 Main team 멤버

---

## 상태 매니페스트 (업데이트)

| ID | 상태 | 추천 소스 | 파일명 목표 |
|---|---|---|---|
| `wall_hit_impact` | ✅ 소스 확정 → 소싱 대기 | BFXR 생성 | `sfx_wall_hit_impact.ogg` |
| `lock_primary` | ✅ 소스 확정 → 소싱 대기 | freesound CC0 | `sfx_lock_primary.ogg` |
| `wall_hit_spikes` | ⬜ NEEDED (P1) | freesound CC0 | `sfx_wall_hit_spikes.ogg` |
| `wall_hit_stun` | ⬜ NEEDED (P1) | BFXR/sfxr.me | `sfx_wall_hit_stun.ogg` |
| `lock_accent` | ⬜ NEEDED (P2) | BFXR | `sfx_lock_accent.ogg` |

**목표 경로:** `godot/assets/audio/sfx/` — 파일 커밋은 통합 PR 시점에 진행.

---

## 복사-붙여넣기 커맨드 (바로 사용)

### wall_hit_impact — BFXR 생성 후 변환
```bash
# 1. https://www.bfxr.net/ → Hit/Hurt 프리셋 → Start Freq 낮춤(0.2) → Export .wav
ffmpeg -i sfx_wall_hit_impact.wav -c:a libvorbis -q:a 5 sfx_wall_hit_impact.ogg
cp sfx_wall_hit_impact.ogg godot/assets/audio/sfx/
# 목표 길이: 0.2–0.35s
```

### lock_primary — freesound 다운로드 후 변환
```bash
# 1. freesound.org CC0 검색 → .wav 다운로드
ffmpeg -i <downloaded>.wav -c:a libvorbis -q:a 5 sfx_lock_primary.ogg
cp sfx_lock_primary.ogg godot/assets/audio/sfx/
# CC0: CREDITS.md 기재 불필요 | CC-BY: 파일명+작성자+URL 기재 필수
```

### 공통 규칙
- 파일명: `sfx_{id}.ogg` | 경로: `godot/assets/audio/sfx/`
- **커밋 전 Godot 에디터 재생 테스트 필수 — 바이너리 직접 커밋 금지**
---
