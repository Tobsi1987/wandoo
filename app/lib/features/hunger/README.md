# hunger

**Zweck:** Hungerbalken. Voll sind 5 km, jeden Tag wird er 1 km leerer,
Gehen füllt ihn wieder (jeder Meter, auch auf bekannten Straßen). Ist er
leer, ist das Wesen müde und traurig, und die Erinnerungen werden
dringlicher. Ist er zwei Tage leer, zieht das Wesen aus: Es hinterlässt
einen Abschiedsbrief und ein neues Ei, bleibt aber im Album und Tagebuch.
Eier haben keinen Hunger.

**Bekommt:** das Wesen aus `creature`. Füttern nach dem Gang, Auszug und
Erinnerungen erledigen Flows (`flows/hunger`, `flows/process_walk`,
`flows/creature_reminder`).

**Liefert:** `Belly` (die Regeln), `BellyRepository`, `currentBellyProvider`,
`starvingProvider`, `HungerBar` und `FarewellLetter`.
