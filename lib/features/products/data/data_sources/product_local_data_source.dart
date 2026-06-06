import '../models/product_model.dart';

/// Local data source for cached products.
abstract class ProductLocalDataSource {
  Future<List<ProductModel>?> getCachedProducts();

  Future<void> cacheProducts(List<ProductModel> products);
}
