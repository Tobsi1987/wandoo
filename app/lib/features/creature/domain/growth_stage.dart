/// Entwicklungsstufen des Wesens im MVP.
enum GrowthStage {
  egg(foodNeeded: 0),
  juvenile(foodNeeded: 20),
  adult(foodNeeded: 100);

  const GrowthStage({required this.foodNeeded});

  /// Gesamtfutter, ab dem diese Stufe erreicht ist. Platzhalterwerte, die
  /// mit echten Spaziergängen abgestimmt werden.
  final int foodNeeded;

  static GrowthStage forFood(int food) =>
      values.lastWhere((stage) => food >= stage.foodNeeded);
}
