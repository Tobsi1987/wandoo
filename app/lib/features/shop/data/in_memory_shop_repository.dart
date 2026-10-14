import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/shop/domain/shop_repository.dart';

/// Hält den letzten Gratis-Neustart nur im Speicher, für Demo und Tests.
class InMemoryShopRepository extends MemoryValue<DateTime?>
    implements ShopRepository {
  InMemoryShopRepository([super.value]);

  @override
  Stream<DateTime?> watchLastFreeRediscover() => watch();

  @override
  Future<void> saveLastFreeRediscover(DateTime at) => save(at);
}
