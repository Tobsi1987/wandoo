# core/database

Lokale Drift-Datenbank (SQLite). Das Schema liegt zentral in `tables.dart`,
damit `core` keine Features kennen muss. Die Repositories, die Zeilen in
Domänenobjekte übersetzen, liegen in den `data/`-Ordnern der Features.

Nach Schemaänderungen: `dart run build_runner build` im Ordner `app/`
und `schemaVersion` erhöhen.
