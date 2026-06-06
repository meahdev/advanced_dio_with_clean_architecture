import '../../../../core/storage/memory_cache.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

/// In-memory cache implementation for products.
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._cache);

  static const _cacheKey = 'cached_products';

  final MemoryCache _cache;

  @override
  Future<List<ProductModel>?> getCachedProducts() async {
    return _cache.read<List<ProductModel>>(_cacheKey);
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    _cache.write(_cacheKey, products);
  }
}
