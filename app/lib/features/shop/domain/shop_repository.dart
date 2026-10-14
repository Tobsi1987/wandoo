/// Merkt sich, wann zuletzt gratis neu entdeckt wurde.
abstract interface class ShopRepository {
  Stream<DateTime?> watchLastFreeRediscover();

  Future<void> saveLastFreeRediscover(DateTime at);
}
