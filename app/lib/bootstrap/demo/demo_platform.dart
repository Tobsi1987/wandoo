import 'dart:developer' as developer;

import 'package:wandoo/features/home_widget/home_widget.dart';
import 'package:wandoo/features/reminders/reminders.dart';

/// Erinnerungen gibt es im Browser nicht, die Demo protokolliert sie nur.
class LoggingReminderScheduler implements ReminderScheduler {
  @override
  Future<void> scheduleAll(List<Reminder> reminders) async {
    for (final r in reminders) {
      developer.log('Erinnerung ${r.at}: ${r.title}', name: 'demo');
    }
  }

  @override
  Future<void> cancel() async {}
}

/// Ein Homescreen-Widget gibt es im Browser nicht.
class LoggingWidgetPublisher implements WidgetPublisher {
  @override
  Future<void> publish(WidgetSnapshot snapshot) async =>
      developer.log('Widget: ${snapshot.toMap()}', name: 'demo');
}
