import '../repositories/cart_repository.dart';

/// Use case to remove a product from the cart
/// Follows Clean Architecture pattern
class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  /// Execute the use case
  Future<void> call(String productId) async {
    await repository.removeFromCart(productId);
  }
}
