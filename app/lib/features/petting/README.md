# petting

**Zweck:** Streicheln: Das Wesen reagiert auf Antippen, und Herzen zeigen,
wie sehr es dich mag.

**Bekommt:** das aktuelle Wesen aus `creature`; gemeinsame Gänge über
`flows/process_walk` (`FriendshipExtra`).

**Liefert:** `Pettable` (macht die Figur antippbar: Freudensprung, Herzchen),
`HeartsBar` (fünf Herzen), `Friendship` und `BefriendCreature`: Streicheln
zählt bis zu fünfmal am Tag einen Punkt, jeder gemeinsame Gang drei. Die
Herzen gehören zu einem Wesen; nach dem Wegschicken fängt das neue bei
null an.
