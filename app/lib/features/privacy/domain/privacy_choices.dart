import 'package:meta/meta.dart';

/// Was beim Datenschutz eingestellt ist. Ab Werk geht so wenig wie möglich
/// ins Netz: Wetter und Kartenbild sind aus, bis jemand sie einschaltet.
@immutable
class PrivacyChoices {
  const PrivacyChoices({
    this.informed = false,
    this.weather = false,
    this.baseMap = false,
  });

  factory PrivacyChoices.fromJson(Map<String, dynamic> json) => PrivacyChoices(
    informed: json['informed'] == true,
    weather: json['weather'] == true,
    baseMap: json['baseMap'] == true,
  );

  /// Der Hinweis beim ersten Start wurde gelesen und bestätigt.
  final bool informed;

  /// Das Wetter am groben Ort (auf etwa 10 km) bei Open-Meteo abfragen.
  final bool weather;

  /// Das Kartenbild von OpenStreetMap unter Karte und Tagebuch laden.
  final bool baseMap;

  PrivacyChoices copyWith({bool? informed, bool? weather, bool? baseMap}) =>
      PrivacyChoices(
        informed: informed ?? this.informed,
        weather: weather ?? this.weather,
        baseMap: baseMap ?? this.baseMap,
      );

  Map<String, Object?> toJson() => {
    'informed': informed,
    'weather': weather,
    'baseMap': baseMap,
  };

  @override
  bool operator ==(Object other) =>
      other is PrivacyChoices &&
      other.informed == informed &&
      other.weather == weather &&
      other.baseMap == baseMap;

  @override
  int get hashCode => Object.hash(informed, weather, baseMap);
}
