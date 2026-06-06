import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'token_store.dart';

/// Fake backend used so the demo can run without internet.
class FakeBackendAdapter implements HttpClientAdapter {
  FakeBackendAdapter(this._tokenStore);

  final InMemoryTokenStore _tokenStore;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path;
    final authHeader = options.headers['Authorization'] as String?;

    if (path == '/users/1') {
      return _json({
        'id': 1,
        'name': 'Leanne Graham',
        'email': 'Sincere@april.biz',
      });
    }

    if (path == '/products') {
      final expected = 'Bearer ${_tokenStore.productsToken}';
      final hasFreshToken = authHeader == expected &&
          _tokenStore.productsToken == 'fresh-products-token';

      if (!hasFreshToken) {
        return _json({'message': 'Products API token expired'}, status: 401);
      }

      return _json({
        'products': [
          {'id': 1, 'title': 'Wireless Headphones'},
          {'id': 2, 'title': 'Mechanical Keyboard'},
        ],
      });
    }

    return _json({'message': 'Not found'}, status: 404);
  }

  ResponseBody _json(Map<String, dynamic> body, {int status = 200}) {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
