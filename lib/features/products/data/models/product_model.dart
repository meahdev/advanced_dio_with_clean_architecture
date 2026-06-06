import '../../domain/entities/product_entity.dart';

/// API/cache model for a product item.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(id: id, title: title);
  }
}
