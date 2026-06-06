import '../models/product_model.dart';

/// Remote data source for product API calls.
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}
