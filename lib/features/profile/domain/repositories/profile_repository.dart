import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_entity.dart';

/// Contract for profile data operations.
abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> fetchProfile();
}
