import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../error/failure.dart';

/// Converts exceptions from Dio into a predictable Either result.
Future<Either<Failure, T>> safeApiCall<T>(
  Future<T> Function() request,
) async {
  try {
    final result = await request();
    return Right(result);
  } on DioException catch (error) {
    final statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const Left(NetworkFailure('Network timeout'));
    }

    if (statusCode == 401) {
      return const Left(TokenFailure('Unauthorized'));
    }

    if (statusCode == 400 || statusCode == 422 || statusCode == 429) {
      return Left(ClientFailure(_messageFrom(error.response?.data)));
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      return const Left(ServerFailure('Server error. Try again later.'));
    }

    return const Left(ServerFailure('Something went wrong'));
  } catch (_) {
    return const Left(ServerFailure('Unexpected error'));
  }
}

String _messageFrom(dynamic data) {
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return 'Invalid request';
}
