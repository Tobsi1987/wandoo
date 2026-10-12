# Wandoo – Regeln für Claude

Antworte auf Deutsch. Lies `docs/architecture.md`, bevor du Code anlegst.

- Feature-basiert: neuer Code gehört in genau ein Feature unter
  `app/lib/features/<x>/` oder in `packages/geo_engine`. Neue Features nur
  mit `dart tool/new_feature.dart`.
- Andere Features nur über ihre öffentliche Datei `<x>.dart` importieren.
  Abläufe über mehrere Features gehören nach `app/lib/flows/`.
- `domain/` importiert kein Flutter, kein Riverpod, keine Datenbank.
- Dateien unter 200 Zeilen halten (Fehler ab 300), Funktionen unter 50.
  Wird es länger: teilen, nicht ausnehmen.
- Vor dem Abschluss immer: `dart format .`, `dart tool/check_architecture.dart`,
  `flutter analyze`, Tests in `packages/geo_engine` und `app`.
