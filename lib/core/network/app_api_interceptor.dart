import 'package:dio/dio.dart';

import 'token_store.dart';

/// Interceptor for the main application API.
///
/// This API uses the app auth token.
class AppApiInterceptor extends QueuedInterceptor {
  AppApiInterceptor(this._tokenStore);

  final InMemoryTokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.getAppToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }
}
