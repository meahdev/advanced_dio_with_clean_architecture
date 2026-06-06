import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'token_store.dart';

/// Interceptor for a second API domain.
///
/// This API has its own token. If the token expires, only one refresh request
/// should run, even when multiple requests fail with 401 at the same time.
class ProductsApiInterceptor extends QueuedInterceptor {
  ProductsApiInterceptor({
    required InMemoryTokenStore tokenStore,
    required Dio retryClient,
  }) : _tokenStore = tokenStore,
       _retryClient = retryClient;

  final InMemoryTokenStore _tokenStore;
  final Dio _retryClient;
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.getProductsToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final alreadyRetried = err.requestOptions.extra['retry'] == true;
    final shouldRefresh = err.response?.statusCode == 401 && !alreadyRetried;

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    _write('TOKEN_FAILURE 401 ${err.requestOptions.uri}');
    err.requestOptions.extra['retry'] = true;

    try {
      _write('REFRESH_START productsToken');
      await _refreshTokenSingleFlight();

      final newToken = await _tokenStore.getProductsToken();
      if (newToken == null || newToken.isEmpty) {
        _write('REFRESH_FAILED productsToken is empty');
        handler.reject(err);
        return;
      }
      _write('REFRESH_SUCCESS productsToken=${_redactToken(newToken)}');

      final options = err.requestOptions;
      final retryHeaders = Map<String, dynamic>.from(options.headers);
      retryHeaders['Authorization'] = 'Bearer $newToken';

      _write('RETRY_START ${options.method} ${options.uri}');
      final response = await _retryClient.request<dynamic>(
        options.uri.toString(),
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(
          method: options.method,
          headers: retryHeaders,
          contentType: options.contentType,
          responseType: options.responseType,
        ),
      );

      _write('RETRY_RESOLVED ${response.statusCode} ${response.realUri}');
      handler.resolve(response);
    } catch (error) {
      _write('RETRY_FAILED $error');
      handler.reject(err);
    }
  }

  Future<void> _refreshTokenSingleFlight() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<void>();
    _refreshCompleter = completer;

    try {
      await _tokenStore.refreshProductsToken();
      completer.complete();
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    } finally {
      _refreshCompleter = null;
    }
  }

  String _redactToken(String token) {
    if (token.length <= 8) return '***';
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  void _write(String message) {
    log('[PRODUCTS_API_AUTH] $message', name: 'DIO');
  }
}
