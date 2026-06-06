import 'package:get_it/get_it.dart';

import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';

Future<void> setupRepositories(GetIt sl) async {
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remote: sl(), local: sl()),
  );
}
