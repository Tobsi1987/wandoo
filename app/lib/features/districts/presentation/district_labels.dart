import 'package:wandoo/features/districts/domain/district.dart';
import 'package:wandoo/features/districts/domain/district_name.dart';

/// Zeile für die Zusammenfassung, wenn ein Viertel sein Abzeichen bekommt.
String badgeLine(District d) => '🧩 Abzeichen für ${districtName(d)}';
