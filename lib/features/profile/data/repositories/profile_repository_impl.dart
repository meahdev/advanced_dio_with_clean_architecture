import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/safe_api_call.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';

/// Repository implementation that maps profile models into domain entities.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, ProfileEntity>> fetchProfile() {
    return safeApiCall(() async {
      final model = await _remote.fetchProfile();
      return model.toEntity();
    });
  }
}
