import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:latlong2/latlong.dart';
import 'package:wandoo/features/diary/domain/diary.dart';

/// Alle Wege des Wesens, neuere kräftiger, dazu die Erinnerungen als
/// kleine Bilder an ihrem Ort.
class DiaryMap extends StatelessWidget {
  const DiaryMap({required this.diary, this.showBaseMap = true, super.key});

  final Diary diary;
  final bool showBaseMap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final points = [for (final w in diary.walks) ...w.path.map(_latLng)];
    final count = diary.walks.length;
    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.coordinates(
            coordinates: points,
            padding: const EdgeInsets.all(36),
            maxZoom: 17,
          ),
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          if (showBaseMap)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'app.wandoo.wandoo',
            ),
          PolylineLayer(
            polylines: [
              for (final (i, w) in diary.walks.indexed)
                Polyline(
                  points: w.path.map(_latLng).toList(),
                  strokeWidth: 4,
                  color: colors.primary.withValues(
                    alpha: 0.35 + 0.65 * (i + 1) / count,
                  ),
                ),
            ],
          ),
          MarkerLayer(
            markers: [
              for (final m in diary.memories)
                if (m.place case final place?)
                  Marker(
                    point: _latLng(place),
                    width: 34,
                    height: 34,
                    child: _Pin(m.emoji),
                  ),
            ],
          ),
          if (showBaseMap)
            const SimpleAttributionWidget(
              source: Text('© OpenStreetMap-Mitwirkende'),
            ),
        ],
      ),
    );
  }

  static LatLng _latLng(GeoPoint p) => LatLng(p.latitude, p.longitude);
}

class _Pin extends StatelessWidget {
  const _Pin(this.emoji);

  final String emoji;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
    ),
    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
  );
}
