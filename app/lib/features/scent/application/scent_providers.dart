import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/scent/domain/pick_scent.dart';
import 'package:wandoo/features/scent/domain/scent.dart';
import 'package:wandoo/features/scent/domain/scent_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final scentRepositoryProvider = Provider<ScentRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final pickScentProvider = Provider<PickScent>((ref) => const PickScent());

/// Die Spur, der das Wesen gerade folgt, oder `null`.
final scentProvider = StreamProvider<Scent?>(
  (ref) => ref.watch(scentRepositoryProvider).watch(),
);
