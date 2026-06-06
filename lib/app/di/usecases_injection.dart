import 'package:get_it/get_it.dart';

import '../../features/products/domain/usecases/fetch_products_usecase.dart';
import '../../features/profile/domain/usecases/fetch_profile_usecase.dart';

Future<void> setupUseCases(GetIt sl) async {
  sl.registerLazySingleton(() => FetchProfileUseCase(sl()));
  sl.registerLazySingleton(() => FetchProductsUseCase(sl()));
}
