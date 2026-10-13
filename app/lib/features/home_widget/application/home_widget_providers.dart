import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/home_widget/application/sync_home_widget.dart';
import 'package:wandoo/features/home_widget/domain/widget_publisher.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final widgetPublisherProvider = Provider<WidgetPublisher>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final syncHomeWidgetProvider = Provider<SyncHomeWidget>(
  (ref) => SyncHomeWidget(ref.watch(widgetPublisherProvider)),
);
