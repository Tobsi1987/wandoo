# reminders

**Zweck:** Schickt sanfte Erinnerungen, wenn eine Weile niemand draußen war.

**Bekommt:** den Zeitpunkt des letzten Gangs (der letzten Fütterung) und den
Namen des Wesens über den Flow `flows/creature_reminder`.

**Liefert:** `PlanReminder`: an den drei Tagen nach dem letzten Gang je eine
Erinnerung um 16 Uhr, also höchstens eine am Tag und nie abends, mit dem
Namen des Wesens ("Aurora möchte raus"); danach ist Ruhe. `ReminderScheduler`
mit der Umsetzung `LocalNotificationScheduler` plant lokale
Benachrichtigungen; jeder Gang ersetzt die geplanten. Kein Server, keine
Push-Dienste.
