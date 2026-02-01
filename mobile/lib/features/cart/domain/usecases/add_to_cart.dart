import '../../../home/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

/// Use case to add a product to the cart
/// Follows Clean Architecture pattern
class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  /// Execute the use case
  /// If product already exists in cart, quantity will be increased
  Future<void> call(Product product, int quantity) async {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }
    await repository.addToCart(product, quantity);
  }
}
