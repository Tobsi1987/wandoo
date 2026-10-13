import 'package:home_widget/home_widget.dart';
import 'package:wandoo/features/home_widget/domain/widget_publisher.dart';
import 'package:wandoo/features/home_widget/domain/widget_snapshot.dart';

/// Übergibt die Texte per `home_widget` an das native Widget.
class HomeWidgetPublisher implements WidgetPublisher {
  const HomeWidgetPublisher();

  static const androidProvider = 'app.wandoo.wandoo.CreatureWidgetProvider';
  static const iOSKind = 'CreatureWidget';

  @override
  Future<void> publish(WidgetSnapshot snapshot) async {
    for (final MapEntry(:key, :value) in snapshot.toMap().entries) {
      await HomeWidget.saveWidgetData<String>(key, value);
    }
    await HomeWidget.updateWidget(
      qualifiedAndroidName: androidProvider,
      iOSName: iOSKind,
    );
  }
}
