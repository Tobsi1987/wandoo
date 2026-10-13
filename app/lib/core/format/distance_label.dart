/// "350 m" oder "3,4 km", so wie Kinder Strecken lesen.
String distanceLabel(int meters) {
  if (meters < 1000) return '${(meters / 10).round() * 10} m';
  final km = (meters / 100).round() / 10;
  final text = km == km.roundToDouble()
      ? km.toStringAsFixed(0)
      : km.toStringAsFixed(1).replaceAll('.', ',');
  return '$text km';
}
