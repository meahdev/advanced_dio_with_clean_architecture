import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case that fetches products from cache or remote API.
class FetchProductsUseCase {
  const FetchProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, List<ProductEntity>>> call({
    bool forceRefresh = false,
  }) {
    return _repository.fetchProducts(forceRefresh: forceRefresh);
  }
}
