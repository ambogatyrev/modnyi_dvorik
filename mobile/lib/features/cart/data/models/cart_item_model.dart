import 'package:equatable/equatable.dart';
import '../../../home/data/models/product_model.dart';

/// Cart item data model representing a product with quantity
class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  /// Calculate total price for this cart item
  double get totalPrice => product.price * quantity;

  /// Create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  /// Convert CartItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  /// Create a copy of CartItemModel with modified fields
  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];

  @override
  String toString() {
    return 'CartItemModel(product: ${product.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
