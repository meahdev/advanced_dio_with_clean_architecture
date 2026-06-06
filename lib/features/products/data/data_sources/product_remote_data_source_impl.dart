import 'package:dio/dio.dart';

import '../models/product_model.dart';
import 'product_remote_data_source.dart';

/// Dio implementation for product API calls.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dio.get<Map<String, dynamic>>('/products');
    final data = response.data?['products'] as List<dynamic>? ?? [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }
}
