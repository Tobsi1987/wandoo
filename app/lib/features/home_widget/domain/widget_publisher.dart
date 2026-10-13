import 'package:wandoo/features/home_widget/domain/widget_snapshot.dart';

/// Schreibt den Stand ins Widget auf dem Startbildschirm.
abstract interface class WidgetPublisher {
  Future<void> publish(WidgetSnapshot snapshot);
}
