import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product.dart';

/// Cart item entity - pure Dart class with no Flutter dependencies
/// Represents a product with quantity in the shopping cart
class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  /// Calculate total price for this cart item
  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];

  @override
  String toString() {
    return 'CartItem(product: ${product.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
