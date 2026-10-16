# districts

**Zweck:** Viertel-Puzzle mit Abzeichen. Die Gegend (rund 5 × 3,5 km) ist in
25 Viertel geteilt. Sind 80 % der Wege eines Viertels bekannt, gibt es sein
Abzeichen und das Puzzleteil liegt. Viertel fast ohne Wege sind Wildnis.

**Bekommt:** Kartendaten (`core/map_data`) und bekannte Abschnitte
(`discovery`).

**Liefert:** `PuzzleScreen` (Teile antippen zeigt Skizze und Straßen des Viertels), `DistrictProgress.newBadges` für die
Zusammenfassung nach dem Gang, `districtName`.
