import '../repositories/cart_repository.dart';

/// Use case to update the quantity of a product in the cart
/// Follows Clean Architecture pattern
class UpdateCartQuantity {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  /// Execute the use case
  /// If quantity is 0 or less, the product will be removed from cart
  Future<void> call(String productId, int quantity) async {
    await repository.updateCartQuantity(productId, quantity);
  }
}
