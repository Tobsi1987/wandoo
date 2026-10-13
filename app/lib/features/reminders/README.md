# reminders

**Zweck:** Schickt sanfte Erinnerungen, wenn lange nichts Neues entdeckt wurde.

**Bekommt:** den Zeitpunkt der letzten Fütterung (über den Flow
`flows/creature_reminder`).

**Liefert:** `PlanReminder` (drei Tage nach der letzten Fütterung, nur
zwischen 10 und 19 Uhr) und `ReminderScheduler`. Die Umsetzung
`LocalNotificationScheduler` plant eine lokale Benachrichtigung; es gibt nie
mehr als eine, jede Fütterung verschiebt sie. Kein Server, keine Push-Dienste.
