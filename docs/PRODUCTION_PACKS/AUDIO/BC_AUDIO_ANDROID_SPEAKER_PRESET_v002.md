# BC_AUDIO_ANDROID_SPEAKER_PRESET_v002
> Assist Dept — Audio Team | 2026-02-19 | v002

## 목적
Blood Contract PoC 오디오를 **Android 폰 스피커 / 이어버드** 두 환경에서 TC01 LOCK 큐와 TC04 WALL_HIT가 명확히 들리도록 EQ·HPF·리미터 프리셋 가이드를 정의한다.
바이너리 파일이 아닌 **구현 참조 수치** 문서.

---

## 배경: 왜 Android 스피커는 다른가

| 특성 | 폰 내장 스피커 | 이어버드/헤드폰 |
|---|---|---|
| 주파수 재생 범위 | ~200Hz–8kHz (저음/고음 취약) | ~20Hz–20kHz |
| 스테레오 | 모노 또는 의사(pseudo) 스테레오 | 진짜 스테레오 |
| 최대 출력 SPL | 낮음 (75–85dB) | 충분함 |
| 저음 왜곡 | 80Hz 이하에서 심각 왜곡 | 허용 범위 |
| 주요 문제 | `wall_hit_impact` 중저음 타격감 손실, `lock_primary` 클릭 묻힘 | 상대적으로 양호 |

---

## 프리셋 A — 폰 내장 스피커 (기본 타깃)

### EQ (파라메트릭 기준)
| 밴드 | 주파수 | Q | 게인 | 목적 |
|---|---|---|---|---|
| HPF | 120Hz | — | 롤오프 | 왜곡 방지; 서브베이스 제거 |
| Low Shelf | 200Hz | 0.7 | +2.5dB | 중저음 보체 → `wall_hit_impact` 타격감 복원 |
| Peak | 1.2kHz | 1.5 | +1.5dB | `lock_primary` 클릭 배음 강조 |
| Peak | 3.5kHz | 2.0 | +2.0dB | 어택 선명도, `tel_charger_windup` 존재감 |
| High Shelf | 7kHz | 0.7 | -1.5dB | 스피커 고음 찌름 억제 |

### 리미터
| 파라미터 | 값 | 이유 |
|---|---|---|
| 천장(Ceiling) | -2.0 dBFS | 스피커 왜곡 방지 |
| 어택 | 1ms | 과도음 클리핑 방지 |
| 릴리즈 | 80ms | 자연스러운 복원 |
| 룩어헤드 | 2ms | 과도음 선처리 |

### 채널
- 내장 스피커 환경에서는 L+R 합산 후 **모노 폴드다운** 적용 권장.
- 공간감 의존 SFX(스테레오 패닝 사용 중이라면)는 센터 패닝 기본값으로 변경.

---

## 프리셋 B — 이어버드 / 헤드폰

### EQ
| 밴드 | 주파수 | Q | 게인 | 목적 |
|---|---|---|---|---|
| HPF | 60Hz | — | 롤오프 | 극저음만 제거 |
| Peak | 80Hz | 1.0 | +1.5dB | `wall_hit_impact` 육중함 복원 |
| Peak | 1.2kHz | 1.5 | +1.0dB | `lock_primary` 클릭 선명도 |
| High Shelf | 8kHz | 0.7 | -1.0dB | 청각 피로 완화 |

### 리미터
| 파라미터 | 값 |
|---|---|
| 천장 | -1.0 dBFS |
| 어택 | 1ms |
| 릴리즈 | 60ms |

### 스테레오
- 이어버드 환경: 스테레오 폭 100% 유지. 패닝 허용.
- `lock_primary`: 중앙 패닝 유지 (어느 귀로든 명확히 들려야 함).
- `wall_hit_impact`: 중앙~약 15° 좌우 허용.

---

## TC01/TC04 전용 믹스 규칙 (두 환경 공통)

### `lock_primary` 보호 규칙
1. `lock_primary` 발화 순간 다른 모든 활성 SFX를 **-8dB 덕킹**, 0.3s 후 복원.
2. `lock_primary` 소스 파일의 핵심 에너지는 **1–4kHz 대역**에 집중 (폰 스피커 재생 최적 대역).
3. `tel_charger_windup` 루프는 `lock_primary` 발화 0.05s 전부터 -12dB 페이드 시작.

### `wall_hit_impact` 보호 규칙
1. `wall_hit_impact` 발화 시 BGM(있다면) -6dB 덕킹, 0.5s 후 복원.
2. 폰 스피커에서 저음 손실 보완: `wall_hit_impact` 소스는 200–600Hz 미드에 **펀치감 배음** 추가 편집 권장.
3. `wall_hit_spikes` 레이어는 `wall_hit_impact`보다 2–3dB 낮게 고정.

---

## 구현 참고 (Godot 4)

- Godot `AudioEffectEQ` 또는 `AudioEffectFilter` + `AudioEffectLimiter` 노드 조합으로 구현 가능.
- 스피커 vs 이어버드 자동 감지는 Android API `AudioManager.getDevices()` 활용 가능 (Godot GDNative/JNI 필요).
- PoC 단계에서는 **단일 프리셋(스피커 기준 프리셋 A)** 적용 후 수동 테스트 권장.
- 추후 플레이어 설정 메뉴에서 "스피커/이어폰" 토글 추가 가능(v002 이후 범위).

---

## 다음 버전 목표
- v003: 실기기(Galaxy/Pixel 계열) 실측 테스트 후 EQ 수치 보정
- v003: BGM 도입 시 덕킹 타임라인 재정의
