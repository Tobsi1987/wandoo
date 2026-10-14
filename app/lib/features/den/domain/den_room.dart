import 'package:wandoo/features/den/domain/furniture.dart';

/// Das eingerichtete Zuhause: was gebaut ist und was wo steht.
class DenRoom {
  const DenRoom({this.owned = const {}, this.placed = const {}});

  final Set<Furniture> owned;
  final Map<Spot, Furniture> placed;

  Furniture? at(Spot spot) => placed[spot];

  /// Nimmt ein neues Möbelstück auf und stellt es gleich hin.
  DenRoom add(Furniture f) =>
      DenRoom(owned: {...owned, f}, placed: placed).put(f);

  /// Stellt [f] auf seinen Platz; was dort stand, kommt ins Lager.
  DenRoom put(Furniture f) => owned.contains(f)
      ? DenRoom(owned: owned, placed: {...placed, f.spot: f})
      : this;

  /// Räumt den Platz leer.
  DenRoom clear(Spot spot) =>
      DenRoom(owned: owned, placed: {...placed}..remove(spot));
}
