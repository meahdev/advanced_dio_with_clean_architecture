import 'package:dio/dio.dart';

import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

/// Dio implementation for profile API calls.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ProfileModel> fetchProfile() async {
    final response = await _dio.get<Map<String, dynamic>>('/users/1');
    return ProfileModel.fromJson(response.data ?? {});
  }
}
