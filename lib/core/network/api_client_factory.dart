import 'package:dio/dio.dart';

import 'api_base.dart';
import 'api_log_interceptor.dart';
import 'app_api_interceptor.dart';
import 'products_api_interceptor.dart';
import 'token_store.dart';

/// Centralized factory for all Dio clients in the app.
class ApiClientFactory {
  static const usersConnectTimeout = Duration(seconds: 5);
  static const usersReceiveTimeout = Duration(seconds: 10);
  static const productsConnectTimeout = Duration(seconds: 20);
  static const productsReceiveTimeout = Duration(seconds: 45);

  ApiClientFactory({
    required InMemoryTokenStore tokenStore,
    HttpClientAdapter? appAdapter,
    HttpClientAdapter? productsAdapter,
  }) : _tokenStore = tokenStore,
       _appAdapter = appAdapter,
       _productsAdapter = productsAdapter;

  final InMemoryTokenStore _tokenStore;
  final HttpClientAdapter? _appAdapter;
  final HttpClientAdapter? _productsAdapter;

  Dio usersApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBase.usersApi,
        connectTimeout: usersConnectTimeout,
        receiveTimeout: usersReceiveTimeout,
      ),
    );

    if (_appAdapter != null) dio.httpClientAdapter = _appAdapter;

    dio.interceptors.addAll([
      AppApiInterceptor(_tokenStore),
      ApiLogInterceptor('USERS_API'),
    ]);
    return dio;
  }

  Dio productsApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBase.productsApi,
        connectTimeout: productsConnectTimeout,
        receiveTimeout: productsReceiveTimeout,
      ),
    );

    if (_productsAdapter != null) dio.httpClientAdapter = _productsAdapter;

    final retryClient = Dio(
      BaseOptions(
        connectTimeout: productsConnectTimeout,
        receiveTimeout: productsReceiveTimeout,
      ),
    );
    if (_productsAdapter != null) {
      retryClient.httpClientAdapter = _productsAdapter;
    }
    retryClient.interceptors.add(ApiLogInterceptor('PRODUCTS_API_RETRY'));

    dio.interceptors.addAll([
      ProductsApiInterceptor(tokenStore: _tokenStore, retryClient: retryClient),
      ApiLogInterceptor('PRODUCTS_API'),
    ]);
    return dio;
  }
}
