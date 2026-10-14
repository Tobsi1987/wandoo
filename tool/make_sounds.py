"""Erzeugt die kleinen Laute der Wesen als WAV (22 kHz, mono).

    python3 tool/make_sounds.py   ->  app/assets/sounds/<name>.wav

Alle Laute sind synthetisch und gemeinfrei. Die Stimme gibt es in drei
Lagen (`_high`, `_mid`, `_low`); welche Art welche Lage hat, steht in
`features/sounds/domain/voice.dart`. Die Stimme entsteht wie bei einem
Tier: Grundton mit Obertönen, geformt von Vokal-Formanten, dazu etwas
Atem und Raumklang. Wer bessere Laute
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


# Die Stimme: eine kleine Kehle (Grundton mit Obertönen) und ein Mund
# (Formanten der Vokale). So klingen die Laute wie ein Tierchen, das
# "wii", "aah" oder "mmh" sagt, und nicht wie ein Piepser.

VOWELS = {
    'i': ((330, 2700, 3500), (1.0, 0.5, 0.25)),
    'e': ((480, 2300, 3100), (1.0, 0.55, 0.25)),
    'a': ((880, 1450, 2900), (1.0, 0.8, 0.3)),
    'o': ((540, 950, 2700), (1.0, 0.6, 0.15)),
    'u': ((360, 850, 2500), (1.0, 0.35, 0.1)),
    'm': ((270, 1100, 2600), (1.0, 0.12, 0.05)),
}
WIDTHS = (110, 150, 220)


def path(points, n):
    """Wert entlang (Anteil, Wert)-Punkten, für n Abtastungen."""
    xs, ys = zip(*points)
    return np.interp(np.linspace(0, 1, n), xs, ys)


def drift(n, amount, speed=8):
    """Langsames Zittern, damit die Stimme lebendig klingt."""
    k = max(1, int(RATE / speed))
    wobble = lowpass(rng.standard_normal(n + 2 * k), k)[k:k + n]
    return 1 + amount * wobble / max(1e-9, np.abs(wobble).max())


def syllable(seconds, pitch, vowels, *, lage=(1, 1), breath=0.05,
             vibrato=(6, 0.02), attack=0.03, release=0.12):
    """Eine Silbe: [pitch] und [vowels] als (Anteil, Wert)-Punkte."""
    n = int(seconds * RATE)
    x = t(seconds)
    f0 = path(pitch, n) * lage[0] * drift(n, 0.012)
    f0 = f0 * (1 + vibrato[1] * np.sin(2 * np.pi * vibrato[0] * x))
    phase = 2 * np.pi * np.cumsum(f0) / RATE
    formants = [
        path([(at, VOWELS[v][0][j]) for at, v in vowels], n) * lage[1]
        for j in range(3)
    ]
    gains = [path([(at, VOWELS[v][1][j]) for at, v in vowels], n)
             for j in range(3)]
    out = np.zeros(n)
    for k in range(1, 48):
        f = k * f0
        weight = sum(
            g / (1 + ((f - fm) / (w / 2)) ** 2)
            for fm, g, w in zip(formants, gains, WIDTHS)
        )
        out += np.where(f < 7000, weight / k ** 0.6, 0) * np.sin(k * phase)
    hiss = shaped_noise(n, 1200, 5000) * breath
    return (out + hiss) * env(n, attack, release)


def shaped_noise(n, low, high):
    """Rauschen nur zwischen [low] und [high] Hz."""
    spectrum = np.fft.rfft(rng.standard_normal(n))
    freqs = np.fft.rfftfreq(n, 1 / RATE)
    spectrum[(freqs < low) | (freqs > high)] = 0
    noise = np.fft.irfft(spectrum, n)
    return noise / max(1e-9, np.abs(noise).max())


def room(x, wet=0.12):
    """Ein Hauch Raumklang, damit es weich und nicht trocken klingt."""
    tail = t(0.18)
    impulse = rng.standard_normal(len(tail)) * np.exp(-tail * 30)
    impulse[0] = 0
    echo = np.convolve(x, impulse)
    dry = np.concatenate([x, np.zeros(len(echo) - len(x))])
    return dry + wet * echo / max(1e-9, np.abs(echo).max()) * np.abs(x).max()


def gap(seconds):
    return np.zeros(int(seconds * RATE))


def lowpass(x, k):
    kernel = np.ones(k) / k
    return np.convolve(x, kernel, mode='same')


def happy(lage):
    # "Mii-hii!": zwei fröhliche, steigende Silben.
    return room(np.concatenate([
        syllable(0.17, [(0, 420), (1, 560)], [(0, 'm'), (0.35, 'i')],
                 lage=lage),
        gap(0.03),
        syllable(0.3, [(0, 520), (0.4, 720), (1, 640)],
                 [(0, 'e'), (0.3, 'i'), (1, 'i')], lage=lage, release=0.2),
    ]))


def purr(lage):
    # Schnurren: ein tiefes, weiches "Rrr" beim Ein- und Ausatmen.
    parts = []
    for loud in (1, 0.6, 1, 0.6):
        n = int(0.32 * RATE)
        x = t(0.32)
        pulses = (0.5 + 0.5 * np.sin(2 * np.pi * 26 * x)) ** 3
        body = syllable(0.32, [(0, 95), (1, 90)], [(0, 'u'), (1, 'm')],
                        lage=(lage[0] ** 0.5, 1), breath=0.5,
                        vibrato=(0, 0), attack=0.08, release=0.1)
        parts += [body * (0.3 + 0.7 * pulses) * loud, gap(0.02)]
    return room(np.concatenate(parts), wet=0.08)


def yawn(lage):
    # Gähnen: Luft holen, dann ein langes "Aaah-mm", das tiefer wird.
    inhale = shaped_noise(int(0.3 * RATE), 600, 3000) * env(
        int(0.3 * RATE), 0.15, 0.1) * 0.25
    voice = syllable(1.05, [(0, 470), (0.25, 430), (0.8, 300), (1, 260)],
                     [(0, 'a'), (0.55, 'a'), (0.8, 'o'), (1, 'm')],
                     lage=lage, breath=0.18, vibrato=(4, 0.015),
                     attack=0.12, release=0.3)
    return room(np.concatenate([inhale, gap(0.05), voice]))


def cheer(lage):
    # Jubeln beim Schlüpfen: "Ja-hii-hii!", hell und mit Schwung.
    return room(np.concatenate([
        syllable(0.16, [(0, 480), (1, 620)], [(0, 'e'), (0.4, 'a')],
                 lage=lage),
        gap(0.03),
        syllable(0.16, [(0, 640), (1, 800)], [(0, 'e'), (0.5, 'i')],
                 lage=lage),
        gap(0.03),
        syllable(0.42, [(0, 760), (0.3, 980), (1, 820)],
                 [(0, 'e'), (0.3, 'i'), (1, 'i')], lage=lage,
                 vibrato=(8, 0.035), release=0.25),
    ]), wet=0.18)


def sniff(lage):
    # Schnüffeln: drei kurze Nasen-Züge, der letzte etwas länger.
    parts = []
    for seconds, loud in ((0.06, 0.7), (0.06, 0.85), (0.11, 1)):
        n = int(seconds * RATE)
        low = 1500 * lage[1]
        burst = shaped_noise(n, low, low * 3.5) * env(n, 0.008, 0.04)
        parts += [burst * loud, gap(0.05)]
    return np.concatenate(parts)


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


# Grundton und Mundgröße je Stimmlage: Kleine piepsen höher, Große
# haben auch einen größeren Mund (tiefere Formanten).
LAGEN = {'high': (1.3, 1.12), 'mid': (1.0, 1.0), 'low': (0.72, 0.88)}

if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.glob('*.wav'):
        old.unlink()
    for name, make in [('happy', happy), ('purr', purr), ('yawn', yawn),
                       ('cheer', cheer), ('sniff', sniff)]:
        for lage, factors in LAGEN.items():
            write(f'{name}_{lage}', make(factors))
    write('found', found())
    print('ok', sorted(p.name for p in OUT.iterdir()))
