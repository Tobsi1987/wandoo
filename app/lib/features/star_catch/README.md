# star_catch

**Zweck:** Mini-Spiel nach dem Gang. Sternschnuppen fallen vom Nachthimmel,
das Wesen läuft unten hin und her (dem Finger nach) und fängt sie, 20
Sekunden lang. Ab 6 gefangenen gibt es einen Sternsplitter, ab 14 zwei.
Einmal je Gang.

**Bekommt:** den letzten ungesehenen Gang aus `walk_summary`, das Wesen aus
`creature`, Laute aus `sounds`.

**Liefert:** `StarCatchButton` für den Startbildschirm, `StarCatchScreen`
und `StarCatchRepository` (welcher Gang schon gespielt wurde). Sternsplitter
landen in der Schatzkiste von `treasure`.
