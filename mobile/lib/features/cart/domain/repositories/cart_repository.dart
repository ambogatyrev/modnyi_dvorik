import '../../../home/domain/entities/product.dart';
import '../entities/cart_item.dart';

/// Cart repository interface
/// Defines contracts for cart operations in the domain layer
abstract class CartRepository {
  /// Get all items in the cart
  Future<List<CartItem>> getCartItems();

  /// Add a product to the cart with specified quantity
  /// If product already exists, increase quantity
  Future<void> addToCart(Product product, int quantity);

  /// Remove a product from the cart by product ID
  Future<void> removeFromCart(String productId);

  /// Update the quantity of a product in the cart
  Future<void> updateCartQuantity(String productId, int quantity);

  /// Clear all items from the cart
  Future<void> clearCart();

  /// Get the total number of items in the cart
  Future<int> getCartItemCount();

  /// Get the total price of all items in the cart
  Future<double> getCartTotal();
}
