# bath

**Zweck:** Matsch und Baden. Nach einem Gang durch Wald oder Feld wird das
Wesen etwas schmutzig, bei Regen mehr (Stufe 0 bis 3, `Mud.afterWalk`).
Im Zuhause zeigt eine Karte "Ab in die Wanne!", in der Wanne wischt man
mit dem Finger, bis der Matsch weg ist.

**Bekommt:** das Wesen aus `creature`, Laute aus `sounds`; schmutzig macht
der Flow `flows/process_walk` (`MudExtra`) mit dem Wetter aus `world`.

**Liefert:** `MudRepository` (Einstellung `bath.mud.<lineKey>`),
`currentMudProvider`, `BathScreen` (Route `/baden`) und `BathCard` für das
Zuhause. Den Matsch am 3D-Modell malt `creature` (`CreatureMud`).
