import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/shop/domain/shop_offer.dart';
import 'package:wandoo/features/shop/domain/shop_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final _lastFreeProvider = StreamProvider<DateTime?>(
  (ref) => ref.watch(shopRepositoryProvider).watchLastFreeRediscover(),
);

/// Wann zuletzt gratis neu entdeckt wurde.
final lastFreeRediscoverProvider = Provider<DateTime?>(
  (ref) => ref.watch(_lastFreeProvider).value,
);

/// Die Angebote. Sie greifen in andere Features, darum baut sie ein Ablauf
/// unter `flows/shop`, und der Bootstrap hängt ihn hier ein.
final shopOffersProvider = Provider<List<ShopOffer>>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);
