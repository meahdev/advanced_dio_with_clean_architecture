import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';

/// Contract for product data operations.
abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> fetchProducts({
    bool forceRefresh = false,
  });
}
