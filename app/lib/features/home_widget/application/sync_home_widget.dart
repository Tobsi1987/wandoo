import 'dart:developer' as developer;

import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/home_widget/application/widget_snapshot_for.dart';
import 'package:wandoo/features/home_widget/domain/widget_publisher.dart';

/// Bringt das Widget auf den Stand des Wesens. Fehler (etwa auf Plattformen
/// ohne Widget) werden nur protokolliert.
class SyncHomeWidget {
  SyncHomeWidget(this._publisher, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final WidgetPublisher _publisher;
  final DateTime Function() _clock;

  Future<void> call(Creature creature) async {
    try {
      await _publisher.publish(widgetSnapshotFor(creature, _clock()));
    } on Object catch (error, stack) {
      developer.log(
        'Widget konnte nicht aktualisiert werden.',
        name: 'wandoo.home_widget',
        error: error,
        stackTrace: stack,
      );
    }
  }
}
