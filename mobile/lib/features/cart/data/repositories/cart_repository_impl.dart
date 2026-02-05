import '../../../../core/data/mock_cart_storage.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

/// Cart repository implementation for MVP stage
/// Uses in-memory MockCartStorage instead of SharedPreferences
/// Data is lost when app restarts - suitable for MVP development
class CartRepositoryImpl implements CartRepository {
  final MockCartStorage _storage = MockCartStorage();

  @override
  Future<List<CartItem>> getCartItems() async {
    // Simulate async operation with a small delay
    await Future.delayed(const Duration(milliseconds: 100));
    return _storage.getCartItems();
  }

  @override
  Future<void> addToCart(Product product, int quantity) async {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }

    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));

    final cartItem = CartItem(
      product: product,
      quantity: quantity,
    );

    _storage.addItem(cartItem);
  }

  @override
  Future<void> removeFromCart(String productId) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    _storage.removeItem(productId);
  }

  @override
  Future<void> updateCartQuantity(String productId, int quantity) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    _storage.updateQuantity(productId, quantity);
  }

  @override
  Future<void> clearCart() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    _storage.clear();
  }

  @override
  Future<int> getCartItemCount() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 50));
    return _storage.getItemCount();
  }

  @override
  Future<double> getCartTotal() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 50));
    return _storage.getTotalPrice();
  }
}
