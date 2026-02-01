import 'package:equatable/equatable.dart';

/// Product data model for serialization and data layer operations
class ProductModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  /// Create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'category': category,
    };
  }

  /// Create a copy of ProductModel with modified fields
  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, name, price, image, category];

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, image: $image, category: $category)';
  }
}
