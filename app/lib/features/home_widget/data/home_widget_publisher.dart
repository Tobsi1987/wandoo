import 'package:home_widget/home_widget.dart';
import 'package:wandoo/features/home_widget/domain/widget_publisher.dart';
import 'package:wandoo/features/home_widget/domain/widget_snapshot.dart';

/// Übergibt die Texte per `home_widget` an das native Widget
/// (Android: `CreatureWidgetProvider.kt`, iOS: `ios/CreatureWidget/`).
class HomeWidgetPublisher implements WidgetPublisher {
  const HomeWidgetPublisher();

  static const androidProvider = 'app.wandoo.wandoo.CreatureWidgetProvider';
  static const iOSKind = 'CreatureWidget';

  /// App-Gruppe, über die das iOS-Widget die Texte liest.
  static const appGroup = 'group.app.wandoo.wandoo';

  @override
  Future<void> publish(WidgetSnapshot snapshot) async {
    await HomeWidget.setAppGroupId(appGroup);
    for (final MapEntry(:key, :value) in snapshot.toMap().entries) {
      await HomeWidget.saveWidgetData<String>(key, value);
    }
    await HomeWidget.updateWidget(
      qualifiedAndroidName: androidProvider,
      iOSName: iOSKind,
    );
  }
}
