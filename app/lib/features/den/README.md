# den

**Zweck:** Das Zuhause des Wesens, eine Höhle zum Einrichten. Auf sechs
Plätzen (Wand, Licht, Bett, Pflanze, Teppich, Spielzeug) steht je ein
Möbelstück; je Platz gibt es drei, gebaut aus Fundstücken der
Schatzkiste. Ab Level 25 (Stufe 3) kann das Wesen hier Winterschlaf
halten, und man bekommt ein zweites Ei. Es ist immer nur ein Wesen aktiv;
das andere braucht weder Gänge noch Futter. Getauscht wird mit einem Tipp.

**Bekommt:** das Wesen und den Schlafplatz (`DenRepository`) aus
`creature`, die Fundstücke aus `treasure`, den Hungerbalken aus `hunger`,
das Level aus `levels`.

**Liefert:** `DenScreen` (oben in der Leiste: Zuhause), `DenRoom` und
`Furniture` mit `RoomRepository` (Einstellung `den.room`),
`denUnlockedProvider` und `SwapCreatures`.
