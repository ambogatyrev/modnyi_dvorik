import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product.dart';

/// Base class for all cart events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load cart items from storage
class LoadCart extends CartEvent {
  const LoadCart();
}

/// Event to add a product to cart with specified quantity
class AddToCart extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCart({
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [product, quantity];
}

/// Event to remove a product from cart
class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Event to update quantity of a product in cart
class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

/// Event to clear all items from cart
class ClearCart extends CartEvent {
  const ClearCart();
}
