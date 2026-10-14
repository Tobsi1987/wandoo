# creature

**Zweck:** Das Wesen selbst: Ei, Schlüpfen, Arten mit Seltenheit,
Merkmale aus den Umgebungen, Fütterung (nur neue Straßen lassen es
wachsen), Wegschicken mit Pause und der Schlafplatz für ein zweites Wesen.

**Bekommt:** Futter je Umgebungstyp aus `flows/process_walk`.

**Liefert:** `Creature`, `SpeciesCatalog`, `FeedCreature`,
`ReleaseCreature`, `CreatureRepository` und `DenRepository`; zum Anzeigen
`CreatureCard`, `CreatureFigure` (3D-Modell), `CreatureAvatar`,
`AlbumScreen` und `CelebrationStage` (hält große Momente an, bis nichts
mehr darüber liegt).

**Aufbau von `presentation/`:**
- `model/`: 3D-Modell laden, Posen, Bewegungen, Augen.
- `outfit/`: Hüte, Schals und Wetterkleidung am Modell.
- `celebration/`: Schlüpfen, Freudenhüpfer, Hallo-Blase.
- `painting/` und `shaders/`: die 2D-Figur, wenn kein Modell da ist.
- `widgets/`: kleine Bausteine, die andere Module nutzen.
