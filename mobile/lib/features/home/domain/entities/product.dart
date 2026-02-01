import 'package:equatable/equatable.dart';

/// Product entity - pure Dart class with no Flutter dependencies
/// Represents a product in the domain layer following Clean Architecture
class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, price, image, category];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category)';
  }
}
