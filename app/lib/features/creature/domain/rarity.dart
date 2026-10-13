/// Wie selten eine Tierart schlüpft. [weight] ist die relative Chance.
enum Rarity {
  common(60),
  rare(28),
  epic(10),
  legendary(2);

  const Rarity(this.weight);

  final int weight;
}
