import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Use case that fetches the signed-in user's profile.
class FetchProfileUseCase {
  const FetchProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileEntity>> call() {
    return _repository.fetchProfile();
  }
}
