# friends

**Zweck:** Freunde und Bestenliste ohne Server: Jeder zeigt seinen
Freundes-Code als QR, der andere scannt ihn. Die Bestenliste vergleicht dich
mit dem letzten Stand deiner Freunde, nur auf dem Handy.

**Bekommt:** `FriendsRepository` und `myCardProvider` aus dem Bootstrap;
die eigene Karte baut `flows/friends`, weil sie Wesen, Level und Erfolge
braucht. Die Wochenzahlen zählt `flows/process_walk/extras/week_extra.dart`.

**Liefert:** `FriendsScreen` (`/freunde`), `FriendCard` (QR-Inhalt:
zufällige Kennung, Art, Level, Zahlen; kein Name, kein Ort).

Kinderschutz: kein Konto, kein Chat, keine Namen im Code. Den Namen eines
Freundes gibst du selbst ein, er bleibt bei dir.
