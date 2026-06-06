/// Domain entity used by the app UI/business layer.
class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  String toString() => 'ProfileEntity(id: $id, name: $name)';
}
