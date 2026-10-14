"""Erzeugt die kleinen Laute der Wesen als WAV (22 kHz, mono).

    python3 tool/make_sounds.py   ->  app/assets/sounds/<name>.wav

Alle Laute sind synthetisch und gemeinfrei. Die Stimme gibt es in drei
Lagen (`_high`, `_mid`, `_low`); welche Art welche Lage hat, steht in
`features/sounds/domain/voice.dart`. Abspielgeschwindigkeit hilft dafür
nicht: Browser und Android halten dabei die Tonhöhe fest. Wer bessere Laute
hat, ersetzt einfach die Dateien mit gleichem Namen.
"""
import wave
from pathlib import Path

import numpy as np

RATE = 22050
OUT = Path(__file__).resolve().parent.parent / 'app' / 'assets' / 'sounds'
rng = np.random.default_rng(7)


def t(seconds):
    return np.arange(int(seconds * RATE)) / RATE


def env(n, attack=0.02, release=0.15):
    e = np.ones(n)
    a = min(int(attack * RATE), n // 3)
    r = min(int(release * RATE), n // 2)
    e[:a] = np.linspace(0, 1, a)
    e[n - r:] *= np.linspace(1, 0, r) ** 2
    return e


def voice(f0, seconds, wobble=6, depth=0.03):
    """Ein weicher, runder Ton mit etwas Vibrato, wie ein Piepsen."""
    x = t(seconds)
    f = f0 * (1 + depth * np.sin(2 * np.pi * wobble * x))
    phase = 2 * np.pi * np.cumsum(f) / RATE
    tone = np.sin(phase) + 0.35 * np.sin(2 * phase) + 0.12 * np.sin(3 * phase)
    return tone * env(len(x))


def glide(f_from, f_to, seconds, **kw):
    x = t(seconds)
    f = np.geomspace(f_from, f_to, len(x))
    f = f * (1 + kw.get('depth', 0.02) * np.sin(2 * np.pi * kw.get('wobble', 7) * x))
    phase = 2 * np.pi * np.cumsum(f) / RATE
    tone = np.sin(phase) + 0.3 * np.sin(2 * phase)
    return tone * env(len(x), kw.get('attack', 0.02), kw.get('release', 0.12))


def gap(seconds):
    return np.zeros(int(seconds * RATE))


def lowpass(x, k):
    kernel = np.ones(k) / k
    return np.convolve(x, kernel, mode='same')


def happy():
    # Fröhliches "Uii-ii!": zwei kurze, steigende Piepser.
    return np.concatenate([glide(520, 760, 0.16), gap(0.04), glide(600, 900, 0.22)])


def purr():
    # Schnurren: tiefes Brummen, das 22-mal pro Sekunde pulsiert.
    x = t(1.2)
    hum = np.sin(2 * np.pi * 70 * x) + 0.5 * np.sin(2 * np.pi * 140 * x)
    noise = lowpass(rng.standard_normal(len(x)), 40)
    pulse = 0.55 + 0.45 * np.sin(2 * np.pi * 22 * x)
    return (0.7 * hum + 2.5 * noise) * pulse * env(len(x), 0.15, 0.4)


def yawn():
    # Gähnen: langsam fallender Ton mit Hauch.
    tone = glide(560, 260, 1.0, wobble=3, depth=0.015, attack=0.2, release=0.4)
    breath = lowpass(rng.standard_normal(len(tone)), 12) * 0.25
    return tone + breath * env(len(tone), 0.3, 0.5)


def cheer():
    # Jubeln beim Schlüpfen: drei Töne nach oben, der letzte lang.
    notes = [(523, 0.12), (659, 0.12), (784, 0.12), (1047, 0.38)]
    parts = []
    for f, d in notes:
        parts += [voice(f, d, wobble=9, depth=0.04), gap(0.03)]
    return np.concatenate(parts)


def sniff():
    # Schnüffeln: drei kurze, gefilterte Luftstöße.
    parts = []
    for _ in range(3):
        n = int(0.07 * RATE)
        burst = lowpass(rng.standard_normal(n), 6) * env(n, 0.01, 0.05)
        parts += [burst, gap(0.06)]
    return np.concatenate(parts) * 1.4


def found():
    # Fund! Ein helles Glöckchen-Dreiklang.
    parts = []
    for f in (880, 1109, 1319):
        x = t(0.35)
        bell = np.sin(2 * np.pi * f * x) + 0.4 * np.sin(2 * np.pi * 2.76 * f * x)
        parts.append(bell * np.exp(-6 * x))
    out = np.zeros(int(0.2 * RATE) * 2 + len(parts[-1]))
    for i, p in enumerate(parts):
        s = i * int(0.1 * RATE)
        out[s:s + len(p)] += p
    return out


def write(name, x):
    x = x / max(1e-9, np.abs(x).max()) * 0.8
    data = (x * 32767).astype('<i2').tobytes()
    with wave.open(str(OUT / f'{name}.wav'), 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(data)


def shift(x, factor):
    """Höher (factor > 1) oder tiefer, durch Umrechnen der Abtastung."""
    src = np.arange(0, len(x) - 1, factor)
    return np.interp(src, np.arange(len(x)), x)


LAGEN = {'high': 1.25, 'mid': 1.0, 'low': 0.75}

if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.glob('*.wav'):
        old.unlink()
    for name, make in [('happy', happy), ('purr', purr), ('yawn', yawn),
                       ('cheer', cheer), ('sniff', sniff)]:
        sound = make()
        for lage, factor in LAGEN.items():
            write(f'{name}_{lage}', shift(sound, factor))
    write('found', found())
    print('ok', sorted(p.name for p in OUT.iterdir()))
