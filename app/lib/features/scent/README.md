# scent

**Zweck:** Spürnase. Das Wesen riecht einen Fund auf einer unbekannten
Straße in Gehweite. Unterwegs zeigt ein Pfeil die Richtung (bezogen auf die
Gehrichtung) und heiß oder kalt, wie nah es ist.

**Bekommt:** unbekannte Straßenabschnitte mit Umgebung (vom Flow
`flows/scent`), die laufende Position aus `tracking`, das Wesen aus
`creature`.

**Liefert:** `PickScent`, die gemerkte Spur (`ScentRepository`,
`scentProvider`) und `SniffBubble` für den Startbildschirm. Ob der Fund
erreicht ist, prüft `Scent.reachedBy`; die Belohnung vergibt der Flow.
