import '../../domain/entities/profile_entity.dart';

/// API model for a user profile response.
class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(id: id, name: name);
  }
}
