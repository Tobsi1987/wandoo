# Architektur von Wandoo

Ausführlich mit Diagrammen: Dokument "Wandoo – Projektstruktur &
Modularitäts-Strategie" im Claude-Projekt. Hier die Kurzfassung, die im
Repository mitwandert.

## Aufbau

| Ort | Inhalt | Darf importieren |
| --- | --- | --- |
| `packages/geo_engine` | Reines Dart: Map Matching, Neuheit, Umgebung | nur Dart |
| `app/lib/core/` | Datenbank, Standort, Kartendaten | `geo_engine` |
| `app/lib/ui_kit/` | Theme, Basis-Widgets | Flutter |
| `app/lib/features/<x>/` | Eine Fähigkeit der App | `core`, `ui_kit`, `geo_engine`, öffentliche Dateien anderer Features |
| `app/lib/flows/` | Abläufe über mehrere Features | öffentliche Feature-Dateien, `core` |
| `app/lib/bootstrap/` | Router, Verdrahtung, Start | alles |

## Innerhalb eines Features

```
features/<x>/
  <x>.dart        öffentliche Schnittstelle, nur exports
  README.md       Zweck, Ein- und Ausgänge
  domain/         Regeln, Entitäten, Schnittstellen. Kein Flutter.
  data/           Umsetzung der Schnittstellen (Datenbank, Plattform)
  application/    Riverpod-Provider und Zustand
  presentation/   Screens und Widgets, keine Logik
```

`presentation → application → domain ← data`. Neues Feature anlegen:
`dart tool/new_feature.dart <name> "<Zweck>"`.

## Grenzen (geprüft von `tool/check_architecture.dart`)

- Datei: Ziel unter 200 Zeilen, Fehler über 300.
- Funktion: Fehler über 50 Zeilen, `build()` über 60.
- Feature: ab etwa 15 Dateien in Unter-Features teilen.
- Ausnahme nur mit `// arch-ignore: <Grund>` an der Importzeile.
