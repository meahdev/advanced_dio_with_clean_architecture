import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/safe_api_call.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_local_data_source.dart';
import '../data_sources/product_remote_data_source.dart';

/// Repository implementation that coordinates cache and remote product data.
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required ProductLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProducts({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _local.getCachedProducts();
      if (cached != null && cached.isNotEmpty) {
        return Right(cached.map((model) => model.toEntity()).toList());
      }
    }

    return safeApiCall(() async {
      final remoteModels = await _remote.fetchProducts();
      await _local.cacheProducts(remoteModels);
      return remoteModels.map((model) => model.toEntity()).toList();
    });
  }
}
