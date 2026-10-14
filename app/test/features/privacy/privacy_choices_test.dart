import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/privacy/privacy.dart';

void main() {
  test('ab Werk geht nichts Unnötiges ins Netz', () {
    const fresh = PrivacyChoices();
    expect(fresh.informed, isFalse);
    expect(fresh.weather, isFalse);
    expect(fresh.baseMap, isFalse);
  });

  test('übersteht Speichern und Laden', () {
    const choices = PrivacyChoices(informed: true, baseMap: true);
    expect(PrivacyChoices.fromJson(choices.toJson()), choices);
  });
}
