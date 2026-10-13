import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/world/world.dart';

void main() {
  test('Tageszeiten', () {
    expect(Daytime.at(DateTime(2026, 10, 14, 7)), Daytime.morning);
    expect(Daytime.at(DateTime(2026, 10, 14, 13)), Daytime.day);
    expect(Daytime.at(DateTime(2026, 10, 14, 19)), Daytime.evening);
    expect(Daytime.at(DateTime(2026, 10, 14, 22)), Daytime.night);
    expect(Daytime.at(DateTime(2026, 10, 14, 3)), Daytime.night);
  });

  test('Ostersonntag', () {
    expect(EggTheme.easterSunday(2026), DateTime(2026, 4, 5));
    expect(EggTheme.easterSunday(2027), DateTime(2027, 3, 28));
    expect(EggTheme.easterSunday(2025), DateTime(2025, 4, 20));
  });

  test('Ei-Muster: Feste vor Jahreszeiten', () {
    expect(EggTheme.on(DateTime(2026, 3, 29)), EggTheme.easter);
    expect(EggTheme.on(DateTime(2026, 3, 28)), EggTheme.spring);
    expect(EggTheme.on(DateTime(2026, 4, 6)), EggTheme.easter);
    expect(EggTheme.on(DateTime(2026, 4, 7)), EggTheme.spring);
    expect(EggTheme.on(DateTime(2026, 7, 2)), EggTheme.summer);
    expect(EggTheme.on(DateTime(2026, 10, 14)), EggTheme.autumn);
    expect(EggTheme.on(DateTime(2026, 10, 31)), EggTheme.halloween);
    expect(EggTheme.on(DateTime(2026, 12, 24)), EggTheme.christmas);
    expect(EggTheme.on(DateTime(2026, 12, 30)), EggTheme.winter);
    expect(EggTheme.on(DateTime(2027, 2, 2)), EggTheme.winter);
  });

  test('WMO-Wettercodes', () {
    expect(Weather.fromWmo(0), Weather.clear);
    expect(Weather.fromWmo(3), Weather.cloudy);
    expect(Weather.fromWmo(45), Weather.fog);
    expect(Weather.fromWmo(61), Weather.rain);
    expect(Weather.fromWmo(81), Weather.rain);
    expect(Weather.fromWmo(73), Weather.snow);
    expect(Weather.fromWmo(86), Weather.snow);
    expect(Weather.fromWmo(95), Weather.storm);
  });

  test('Sätze zur Welt', () {
    final night = WorldState.at(DateTime(2026, 10, 14, 22));
    expect(worldLine(night), contains('schläft'));
    final storm = WorldState.at(
      DateTime(2026, 10, 14, 22),
      weather: Weather.storm,
    );
    expect(worldLine(storm), contains('drinnen'));
    final cloudyDay = WorldState.at(
      DateTime(2026, 10, 14, 13),
      weather: Weather.cloudy,
    );
    expect(worldLine(cloudyDay), isNull);
  });
}
