# achievements

**Zweck:** Erfolge-Buch: Stempel in Bronze, Silber und Gold für Meilensteine
(Kilometer, Wege je Umgebung, Wetter, Tageszeit, Arten, Level). Ohne
Belohnungen, nur zum Anschauen.

**Bekommt:** Zahlen je Gang über den Flow `flows/process_walk`
(`AchievementExtra`), Arten und Level live aus `creature` und `levels`.

**Liefert:** `AchievementBookScreen` (Route `/erfolge`), `StatsRepository`,
`newStamps` für die Zeile "Neuer Stempel" in der Zusammenfassung.
