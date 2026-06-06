/// Domain entity used by UI/business logic.
class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  @override
  String toString() => 'ProductEntity(id: $id, title: $title)';
}
