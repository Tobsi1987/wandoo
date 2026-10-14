import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/shop/domain/shop_repository.dart';

/// Speichert den letzten Gratis-Neustart in den Einstellungen.
class DriftShopRepository implements ShopRepository {
  DriftShopRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'shop.freeRediscoverAt';

  @override
  Stream<DateTime?> watchLastFreeRediscover() =>
      _store.watch(_key).map((v) => v == null ? null : DateTime.tryParse(v));

  @override
  Future<void> saveLastFreeRediscover(DateTime at) =>
      _store.put(_key, at.toIso8601String());
}
