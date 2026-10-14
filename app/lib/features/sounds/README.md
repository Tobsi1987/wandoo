# sounds

**Zweck:** Kleine Laute der Wesen: Freuen, Schnurren, Gähnen, Jubeln,
Schnüffeln und ein Glöckchen für Funde. Jede Art hat eine Stimmlage (hoch,
mittel, tief; `voice.dart`). Die Laute lassen sich ausschalten.

**Bekommt:** die Art des Wesens als `speciesId` von dem, der abspielt.

**Liefert:** `PlaySound` (`playSoundProvider`), `Cue`, `SoundToggle`. Die
Dateien liegen in `assets/sounds/` und entstehen mit
`python3 tool/make_sounds.py`; bessere Laute ersetzen sie einfach.
