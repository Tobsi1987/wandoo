# privacy

**Zweck:** Was die App über das Kind weiß und wohin etwas geht: Hinweis beim
ersten Start, Schalter für Wetter und Kartenbild, alle Daten löschen.

**Bekommt:** eine `PrivacyRepository`- und eine `DataWiper`-Umsetzung aus dem
Bootstrap.

**Liefert:** `PrivacyGate` (hält die App hinter dem Hinweis beim ersten
Start), `PrivacyScreen` (`/datenschutz`), `weatherAllowedProvider` und
`baseMapAllowedProvider`, an denen der Bootstrap Wetter und Kartenbild
festmacht.

Ab Werk sind Wetter und Kartenbild aus (Datenschutz durch Voreinstellung).
Nur die Straßendaten von Overpass sind nötig und laufen immer.
