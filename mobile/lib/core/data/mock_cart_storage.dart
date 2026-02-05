import '../../features/cart/domain/entities/cart_item.dart';

/// Mock in-memory cart storage for MVP stage
/// This simulates a persistent storage but data is lost when app restarts
class MockCartStorage {
  // Singleton pattern for shared cart storage across the app
  static final MockCartStorage _instance = MockCartStorage._internal();
  factory MockCartStorage() => _instance;
  MockCartStorage._internal();

  // In-memory cart storage
  final List<CartItem> _cartItems = [];

  /// Get all items in the cart
  List<CartItem> getCartItems() {
    return List.unmodifiable(_cartItems);
  }

  /// Add an item to the cart
  /// If product already exists, updates the quantity
  void addItem(CartItem item) {
    final existingIndex = _cartItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );

    if (existingIndex != -1) {
      // Update existing item quantity
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = CartItem(
        product: existingItem.product,
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Add new item
      _cartItems.add(item);
    }
  }

  /// Remove an item from the cart by product ID
  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  /// Update quantity of an item in the cart
  void updateQuantity(String productId, int quantity) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        final item = _cartItems[index];
        _cartItems[index] = CartItem(
          product: item.product,
          quantity: quantity,
        );
      }
    }
  }

  /// Clear all items from the cart
  void clear() {
    _cartItems.clear();
  }

  /// Get total number of items in the cart
  int getItemCount() {
    return _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  /// Get total price of all items in the cart
  double getTotalPrice() {
    return _cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;

  /// Get number of unique products in cart
  int get length => _cartItems.length;
}
