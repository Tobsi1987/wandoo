import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:latlong2/latlong.dart';
import 'package:wandoo/features/discovery_map/domain/discovery_overview.dart';
import 'package:wandoo/features/discovery_map/presentation/widgets/unknown_share_badge.dart';

/// Karte mit bekannten Straßen in Farbe und unbekannten blass.
class DiscoveryMapView extends StatelessWidget {
  const DiscoveryMapView({required this.overview, super.key});

  final DiscoveryOverview overview;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: _latLng(overview.center),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'app.wandoo.wandoo',
            ),
            PolylineLayer(
              polylines: [
                for (final s in overview.unknown)
                  _line(s, colors.outline.withValues(alpha: 0.5), 2),
                for (final s in overview.known) _line(s, colors.primary, 5),
              ],
            ),
            const SimpleAttributionWidget(
              source: Text('© OpenStreetMap-Mitwirkende'),
            ),
          ],
        ),
        Positioned(
          top: 16,
          left: 16,
          child: UnknownShareBadge(percent: overview.unknownPercent),
        ),
      ],
    );
  }

  static Polyline _line(RoadSegment s, Color color, double width) => Polyline(
    points: [_latLng(s.start), _latLng(s.end)],
    color: color,
    strokeWidth: width,
  );

  static LatLng _latLng(GeoPoint p) => LatLng(p.latitude, p.longitude);
}
