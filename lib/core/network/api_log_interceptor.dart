import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

/// Logs every Dio request, response, and error in one consistent format.
class ApiLogInterceptor extends Interceptor {
  ApiLogInterceptor(this.clientName);

  final String clientName;
  final JsonEncoder _jsonEncoder = const JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _write('REQUEST ${options.method} ${options.uri}');
    _write('Headers: ${_encode(_redactHeaders(options.headers))}');
    if (options.queryParameters.isNotEmpty) {
      _write('Query: ${_encode(options.queryParameters)}');
    }
    if (options.data != null) {
      _write('Body: ${_encode(_normalizeBody(options.data))}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _write('RESPONSE ${response.statusCode} ${response.realUri}');
    _write('Data: ${_encode(response.data)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _write(
      'ERROR ${err.response?.statusCode ?? '-'} ${err.requestOptions.uri}',
    );
    _write('Type: ${err.type}');
    _write('Message: ${err.message}');
    if (err.response?.data != null) {
      _write('Error data: ${_encode(err.response?.data)}');
    }
    handler.next(err);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      if (key.toLowerCase() == 'authorization') {
        return MapEntry(key, _redactAuthorization(value));
      }
      return MapEntry(key, value);
    });
  }

  String _redactAuthorization(Object? value) {
    final text = value?.toString() ?? '';
    if (text.isEmpty) return '';
    if (!text.startsWith('Bearer ')) return '***';

    final token = text.substring('Bearer '.length);
    if (token.length <= 8) return 'Bearer ***';
    return 'Bearer ${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  dynamic _normalizeBody(dynamic data) {
    if (data is FormData) {
      return {
        'fields': Map.fromEntries(data.fields),
        'files': data.files.map((file) => file.value.filename).toList(),
      };
    }
    return data;
  }

  String _encode(dynamic value) {
    try {
      return _jsonEncoder.convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  void _write(String message) {
    log('[$clientName] $message', name: 'DIO');
  }
}
