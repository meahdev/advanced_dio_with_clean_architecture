import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/network/api_client_factory.dart';
import '../../core/network/fake_backend_adapter.dart';
import '../../core/network/token_store.dart';
import '../../core/storage/memory_cache.dart';

Future<void> setupCore(GetIt sl) async {
  sl.registerLazySingleton<InMemoryTokenStore>(
    () => InMemoryTokenStore()
      ..appToken = 'demo-app-token'
      ..productsToken = 'expired-products-token',
  );

  sl.registerLazySingleton<FakeBackendAdapter>(
    () => FakeBackendAdapter(sl<InMemoryTokenStore>()),
  );

  sl.registerLazySingleton<ApiClientFactory>(
    () => ApiClientFactory(
      tokenStore: sl<InMemoryTokenStore>(),
      appAdapter: sl<FakeBackendAdapter>(),
      productsAdapter: sl<FakeBackendAdapter>(),
    ),
  );

  sl.registerLazySingleton<Dio>(
    () => sl<ApiClientFactory>().usersApi(),
    instanceName: 'usersDio',
  );

  sl.registerLazySingleton<Dio>(
    () => sl<ApiClientFactory>().productsApi(),
    instanceName: 'productsDio',
  );

  sl.registerLazySingleton<MemoryCache>(() => MemoryCache());
}
