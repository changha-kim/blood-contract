import os, wave, struct, math, random

SR = 44100


def write_wav(path: str, samples, sr: int = SR) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)  # 16-bit
        w.setframerate(sr)
        frames = bytearray()
        for s in samples:
            s = max(-1.0, min(1.0, float(s)))
            frames += struct.pack('<h', int(s * 32767))
        w.writeframes(frames)


def gen_lock_primary() -> list[float]:
    # Short clicky metallic tick (sine + noise, fast decay)
    dur = 0.11
    n = int(SR * dur)
    out: list[float] = []
    for i in range(n):
        t = i / SR
        env = math.exp(-t * 55.0)
        tone = math.sin(2 * math.pi * 1800 * t) * 0.55 + math.sin(2 * math.pi * 900 * t) * 0.25
        noise = (random.random() * 2 - 1) * 0.35
        s = (tone + noise) * env
        if i > 0:
            s = s - (out[-1] * 0.25)  # pseudo high-pass
        out.append(s * 0.6)
    return out


def gen_wall_hit_impact() -> list[float]:
    # Short low thump + noise (punchy)
    dur = 0.18
    n = int(SR * dur)
    out: list[float] = []
    for i in range(n):
        t = i / SR
        env = math.exp(-t * 18.0)
        thump = math.sin(2 * math.pi * 110 * t) * 0.9
        noise = (random.random() * 2 - 1) * 0.25
        out.append((thump + noise) * env * 0.75)
    return out


def main() -> None:
    base = os.path.join('godot', 'assets', 'audio', 'sfx')
    write_wav(os.path.join(base, 'sfx_lock_primary.wav'), gen_lock_primary())
    write_wav(os.path.join(base, 'sfx_wall_hit_impact.wav'), gen_wall_hit_impact())
    print('Generated SFX wavs in', base)


if __name__ == '__main__':
    main()
