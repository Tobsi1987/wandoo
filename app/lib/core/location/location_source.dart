import 'package:geo_engine/geo_engine.dart';

/// Liefert Positionen vom Gerät. Die Umsetzung mit einem Plattform-Paket
/// (Hintergrund-GPS) kommt daneben, sobald die Paketwahl feststeht.
abstract interface class LocationSource {
  Stream<GeoPoint> positions();
}
