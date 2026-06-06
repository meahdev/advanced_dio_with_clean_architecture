import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/storage/memory_cache.dart';
import '../../features/products/data/data_sources/product_local_data_source.dart';
import '../../features/products/data/data_sources/product_local_data_source_impl.dart';
import '../../features/products/data/data_sources/product_remote_data_source.dart';
import '../../features/products/data/data_sources/product_remote_data_source_impl.dart';
import '../../features/profile/data/data_sources/profile_remote_data_source.dart';
import '../../features/profile/data/data_sources/profile_remote_data_source_impl.dart';

Future<void> setupDataSources(GetIt sl) async {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<Dio>(instanceName: 'usersDio')),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<Dio>(instanceName: 'productsDio')),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sl<MemoryCache>()),
  );
}
