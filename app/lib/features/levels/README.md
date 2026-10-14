# levels

**Zweck:** Level-System. Ein geschlüpftes Wesen sammelt Erfahrung aus
Gehen (10 je 100 m), neuen Straßenstücken (5 je Stück), der Spürnase (50)
und Freundschaft (5 je Punkt, also Streicheln). Es gibt 30 Level; die
ersten kommen fast täglich, später dauert es länger. Bei Level 10 wird es
Stufe 2, bei Level 25 Stufe 3. Jedes Level bringt eine kleine Belohnung
(vergibt der Flow `flows/levels`).

**Bekommt:** das Wesen aus `creature`.

**Liefert:** `LevelCurve` und `Xp` (die Regeln), `Progress` und
`ProgressRepository`, `progressProvider`, `LevelBar` und `LevelUpBanner`.
