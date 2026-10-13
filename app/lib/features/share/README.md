# share

**Zweck:** Erzeugt das Teilen-Bild des Wesens.

**Bekommt:** das aktuelle Wesen aus `creature`.

**Liefert:** `ShareScreen` (Route `/teilen`): Vorschau im Format 4:5, die
per `RepaintBoundary` als PNG fotografiert und mit Begleittext über das
System-Teilen-Menü geteilt wird. `imageSharerProvider` ist austauschbar
(Standard: `share_plus`). Es verlässt nur das Bild das Gerät, keine Wege.
