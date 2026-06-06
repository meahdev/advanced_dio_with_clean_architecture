import '../models/profile_model.dart';

/// Remote data source for profile API calls.
abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();
}
