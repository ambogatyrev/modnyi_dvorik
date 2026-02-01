import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Use case to get all items in the cart
/// Follows Clean Architecture pattern
class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  /// Execute the use case
  Future<List<CartItem>> call() async {
    return await repository.getCartItems();
  }
}
