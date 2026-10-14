# diary

**Zweck:** Wandertagebuch: Karte aller Wege eines Wesens und Erinnerungen
wie sein Schlüpfen.

**Bekommt:** jeden fertigen Gang als `WalkFacts` aus `flows/process_walk`
(`DiaryExtra`); das aktuelle Wesen aus `creature`.

**Liefert:** `DiaryScreen` (Karte mit allen Wegen, Zahlen, Erinnerungen),
und `RememberWalk`, das Momente findet: erster Gang, Schlüpfen,
Wachsen, 1/5/10/25/… km zusammen. Ein Tagebuch gehört zu einem Wesen vom Ei
bis zum Wegschicken (`Creature.lineKey`); alte bleiben gespeichert.
