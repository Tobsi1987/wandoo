const _months = [
  'Jan.',
  'Feb.',
  'März',
  'Apr.',
  'Mai',
  'Juni',
  'Juli',
  'Aug.',
  'Sep.',
  'Okt.',
  'Nov.',
  'Dez.',
];

/// Zum Beispiel "13. Okt. 2026".
String dateLabel(DateTime d) {
  final local = d.toLocal();
  return '${local.day}. ${_months[local.month - 1]} ${local.year}';
}
